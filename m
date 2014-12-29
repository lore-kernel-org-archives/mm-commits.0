From: akpm@linux-foundation.org
Subject: + oom-dont-count-on-mm-less-current-process.patch added to -mm
 tree
Date: Mon, 29 Dec 2014 13:58:21 -0800
Message-ID: <54a1ce7d.rk8D+X2mrRBie5Xy%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56150 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaL2V6W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Dec 2014 16:58:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: penguin-kernel@I-love.SAKURA.ne.jp, mhocko@suse.cz, oleg@redhat.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: oom: don't count on mm-less current process
has been added to the -mm tree.  Its filename is
     oom-dont-count-on-mm-less-current-process.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/oom-dont-count-on-mm-less-current-process.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/oom-dont-count-on-mm-less-current-process.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: oom: don't count on mm-less current process

out_of_memory() doesn't trigger the OOM killer if the current task is
already exiting or it has fatal signals pending, and gives the task access
to memory reserves instead.  However, doing so is wrong if out_of_memory()
is called by an allocation (e.g.  from exit_task_work()) after the current
task has already released its memory and cleared TIF_MEMDIE at exit_mm(). 
If we again set TIF_MEMDIE to post-exit_mm() current task, the OOM killer
will be blocked by the task sitting in the final schedule() waiting for
its parent to reap it.  It will trigger an OOM livelock if its parent is
unable to reap it due to doing an allocation and waiting for the OOM
killer to kill it.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Acked-by: Michal Hocko <mhocko@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN mm/oom_kill.c~oom-dont-count-on-mm-less-current-process mm/oom_kill.c
--- a/mm/oom_kill.c~oom-dont-count-on-mm-less-current-process
+++ a/mm/oom_kill.c
@@ -643,8 +643,12 @@ void out_of_memory(struct zonelist *zone
 	 * If current has a pending SIGKILL or is exiting, then automatically
 	 * select it.  The goal is to allow it to allocate so that it may
 	 * quickly exit and free its memory.
+	 *
+	 * But don't select if current has already released its mm and cleared
+	 * TIF_MEMDIE flag at exit_mm(), otherwise an OOM livelock may occur.
 	 */
-	if (fatal_signal_pending(current) || task_will_free_mem(current)) {
+	if (current->mm &&
+	    (fatal_signal_pending(current) || task_will_free_mem(current))) {
 		set_thread_flag(TIF_MEMDIE);
 		return;
 	}
_

Patches currently in -mm which might be from penguin-kernel@I-love.SAKURA.ne.jp are

oom-dont-count-on-mm-less-current-process.patch
oom-make-sure-that-tif_memdie-is-set-under-task_lock.patch
lib-vsprintf-add-%pt-format-specifier.patch

