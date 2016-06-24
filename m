From: akpm@linux-foundation.org
Subject: [patch 36/41] oom, suspend: fix oom_reaper vs. oom_killer_disable race
Date: Fri, 24 Jun 2016 14:50:16 -0700
Message-ID: <576dab18.qyc119NZtfSdWVpw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474AbcFXVuR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jun 2016 17:50:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rjw@rjwysocki.net

From: Michal Hocko <mhocko@suse.com>
Subject: oom, suspend: fix oom_reaper vs. oom_killer_disable race

Tetsuo has reported the following potential oom_killer_disable vs. 
oom_reaper race:

(1) freeze_processes() starts freezing user space threads.
(2) Somebody (maybe a kenrel thread) calls out_of_memory().
(3) The OOM killer calls mark_oom_victim() on a user space thread
    P1 which is already in __refrigerator().
(4) oom_killer_disable() sets oom_killer_disabled = true.
(5) P1 leaves __refrigerator() and enters do_exit().
(6) The OOM reaper calls exit_oom_victim(P1) before P1 can call
    exit_oom_victim(P1).
(7) oom_killer_disable() returns while P1 not yet finished
(8) P1 perform IO/interfere with the freezer.

This situation is unfortunate.  We cannot move oom_killer_disable after
all the freezable kernel threads are frozen because the oom victim might
depend on some of those kthreads to make a forward progress to exit so we
could deadlock.  It is also far from trivial to teach the oom_reaper to
not call exit_oom_victim() because then we would lose a guarantee of the
OOM killer and oom_killer_disable forward progress because exit_mm->mmput
might block and never call exit_oom_victim.

It seems the easiest way forward is to workaround this race by calling
try_to_freeze_tasks again after oom_killer_disable.  This will make sure
that all the tasks are frozen or it bails out.

Fixes: 449d777d7ad6 ("mm, oom_reaper: clear TIF_MEMDIE for all tasks queued for oom_reaper")
Link: http://lkml.kernel.org/r/1466597634-16199-1-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/power/process.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff -puN kernel/power/process.c~oom-suspend-fix-oom_reaper-vs-oom_killer_disable-race kernel/power/process.c
--- a/kernel/power/process.c~oom-suspend-fix-oom_reaper-vs-oom_killer_disable-race
+++ a/kernel/power/process.c
@@ -146,6 +146,18 @@ int freeze_processes(void)
 	if (!error && !oom_killer_disable())
 		error = -EBUSY;
 
+	/*
+	 * There is a hard to fix race between oom_reaper kernel thread
+	 * and oom_killer_disable. oom_reaper calls exit_oom_victim
+	 * before the victim reaches exit_mm so try to freeze all the tasks
+	 * again and catch such a left over task.
+	 */
+	if (!error) {
+		pr_info("Double checking all user space processes after OOM killer disable... ");
+		error = try_to_freeze_tasks(true);
+		pr_cont("\n");
+	}
+
 	if (error)
 		thaw_processes();
 	return error;
_
