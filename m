From: akpm@linux-foundation.org
Subject: +
 mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch added to
 -mm tree
Date: Wed, 22 Jun 2016 14:46:08 -0700
Message-ID: <576b0720.fC5bgGThha5OG09T%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbcFVVqJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 17:46:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: hide mm which is shared with kthread or global init
has been added to the -mm tree.  Its filename is
     mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init.patch

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
Subject: mm, oom: hide mm which is shared with kthread or global init

The only case where the oom_reaper is not triggered for the oom victim is
when it shares the memory with a kernel thread (aka use_mm) or with the
global init.  After "mm, oom: skip vforked tasks from being selected" the
victim cannot be a vforked task of the global init so we are left with
clone(CLONE_VM) (without CLONE_SIGHAND).  use_mm() users are quite rare as
well.

In order to guarantee a forward progress for the OOM killer make sure that
this really rare cases will not get into the way and hide the mm from the
oom killer by setting MMF_OOM_REAPED flag for it.  oom_scan_process_thread
will ignore any TIF_MEMDIE task if it has MMF_OOM_REAPED flag set to catch
these oom victims.

After this patch we should guarantee a forward progress for the OOM killer
even when the selected victim is sharing memory with a kernel thread or
global init.

Link: http://lkml.kernel.org/r/1466426628-15074-11-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff -puN mm/oom_kill.c~mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-hide-mm-which-is-shared-with-kthread-or-global-init
+++ a/mm/oom_kill.c
@@ -283,10 +283,22 @@ enum oom_scan_t oom_scan_process_thread(
 
 	/*
 	 * This task already has access to memory reserves and is being killed.
-	 * Don't allow any other task to have access to the reserves.
-	 */
-	if (!is_sysrq_oom(oc) && atomic_read(&task->signal->oom_victims))
-		return OOM_SCAN_ABORT;
+	 * Don't allow any other task to have access to the reserves unless
+	 * the task has MMF_OOM_REAPED because chances that it would release
+	 * any memory is quite low.
+	 */
+	if (!is_sysrq_oom(oc) && atomic_read(&task->signal->oom_victims)) {
+		struct task_struct *p = find_lock_task_mm(task);
+		enum oom_scan_t ret = OOM_SCAN_ABORT;
+
+		if (p) {
+			if (test_bit(MMF_OOM_REAPED, &p->mm->flags))
+				ret = OOM_SCAN_CONTINUE;
+			task_unlock(p);
+		}
+
+		return ret;
+	}
 
 	/*
 	 * If task is allocating a lot of memory and has been marked to be
@@ -913,9 +925,14 @@ void oom_kill_process(struct oom_control
 			/*
 			 * We cannot use oom_reaper for the mm shared by this
 			 * process because it wouldn't get killed and so the
-			 * memory might be still used.
+			 * memory might be still used. Hide the mm from the oom
+			 * killer to guarantee OOM forward progress.
 			 */
 			can_oom_reap = false;
+			set_bit(MMF_OOM_REAPED, &mm->flags);
+			pr_info("oom killer %d (%s) has mm pinned by %d (%s)\n",
+					task_pid_nr(victim), victim->comm,
+					task_pid_nr(p), p->comm);
 			continue;
 		}
 		do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
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

