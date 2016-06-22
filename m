From: akpm@linux-foundation.org
Subject: + oom-suspend-fix-oom_reaper-vs-oom_killer_disable-race.patch
 added to -mm tree
Date: Wed, 22 Jun 2016 15:15:30 -0700
Message-ID: <576b0e02.wYMtkc0FpMjoiihG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45724 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbcFVWPb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 18:15:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, penguin-kernel@I-love.SAKURA.ne.jp, rjw@rjwysocki.net, mm-commits@vger.kernel.org


The patch titled
     Subject: oom, suspend: fix oom_reaper vs. oom_killer_disable race
has been added to the -mm tree.  Its filename is
     oom-suspend-fix-oom_reaper-vs-oom_killer_disable-race.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-suspend-fix-oom_reaper-vs-oom_killer_disable-race.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-suspend-fix-oom_reaper-vs-oom_killer_disable-race.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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

Patches currently in -mm which might be from mhocko@suse.com are

tree-wide-get-rid-of-__gfp_repeat-for-order-0-allocations-part-i.patch
x86-get-rid-of-superfluous-__gfp_repeat.patch
x86-efi-get-rid-of-superfluous-__gfp_repeat.patch
arm64-get-rid-of-superfluous-__gfp_repeat.patch
arc-get-rid-of-superfluous-__gfp_repeat.patch
mips-get-rid-of-superfluous-__gfp_repeat.patch
nios2-get-rid-of-superfluous-__gfp_repeat.patch
parisc-get-rid-of-superfluous-__gfp_repeat.patch
score-get-rid-of-superfluous-__gfp_repeat.patch
powerpc-get-rid-of-superfluous-__gfp_repeat.patch
sparc-get-rid-of-superfluous-__gfp_repeat.patch
s390-get-rid-of-superfluous-__gfp_repeat.patch
sh-get-rid-of-superfluous-__gfp_repeat.patch
tile-get-rid-of-superfluous-__gfp_repeat.patch
unicore32-get-rid-of-superfluous-__gfp_repeat.patch
jbd2-get-rid-of-superfluous-__gfp_repeat.patch
arm-get-rid-of-superfluous-__gfp_repeat.patch
oom-suspend-fix-oom_reaper-vs-oom_killer_disable-race.patch
slab-make-gfp_slab_bug_mask-information-more-human-readable.patch
slab-do-not-panic-on-invalid-gfp_mask.patch
mm-oom_reaper-make-sure-that-mmput_async-is-called-only-when-memory-was-reaped.patch
mm-memcg-use-consistent-gfp-flags-during-readahead.patch
mm-memcg-use-consistent-gfp-flags-during-readahead-fix.patch
proc-oom-drop-bogus-task_lock-and-mm-check.patch
proc-oom-drop-bogus-sighand-lock.patch
proc-oom_adj-extract-oom_score_adj-setting-into-a-helper.patch
mm-oom_adj-make-sure-processes-sharing-mm-have-same-view-of-oom_score_adj.patch
mm-oom-skip-vforked-tasks-from-being-selected.patch
mm-oom-kill-all-tasks-sharing-the-mm.patch
mm-oom-fortify-task_will_free_mem.patch
mm-oom-task_will_free_mem-should-skip-oom_reaped-tasks.patch
mm-oom_reaper-do-not-attempt-to-reap-a-task-more-than-twice.patch
mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch

