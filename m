From: akpm@linux-foundation.org
Subject: + mm-oom-skip-vforked-tasks-from-being-selected.patch added to
 -mm tree
Date: Wed, 22 Jun 2016 14:45:58 -0700
Message-ID: <576b0716.KTVJNn9gmRSID38U%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45290 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbcFVVp7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jun 2016 17:45:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhocko@suse.com, oleg@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, rientjes@google.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, oom: skip vforked tasks from being selected
has been added to the -mm tree.  Its filename is
     mm-oom-skip-vforked-tasks-from-being-selected.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-oom-skip-vforked-tasks-from-being-selected.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-oom-skip-vforked-tasks-from-being-selected.patch

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
Subject: mm, oom: skip vforked tasks from being selected

vforked tasks are not really sitting on any memory.  They are sharing the
mm with parent until they exec into a new code.  Until then it is just
pinning the address space.  OOM killer will kill the vforked task along
with its parent but we still can end up selecting vforked task when the
parent wouldn't be selected.  E.g.  init doing vfork to launch a task or
vforked being a child of oom unkillable task with an updated oom_score_adj
to be killable.

Add a new helper to check whether a task is in the vfork sharing memory
with its parent and use it in oom_badness to skip over these tasks.

Link: http://lkml.kernel.org/r/1466426628-15074-6-git-send-email-mhocko@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   26 ++++++++++++++++++++++++++
 mm/oom_kill.c         |    6 ++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~mm-oom-skip-vforked-tasks-from-being-selected include/linux/sched.h
--- a/include/linux/sched.h~mm-oom-skip-vforked-tasks-from-being-selected
+++ a/include/linux/sched.h
@@ -1948,6 +1948,32 @@ static inline int tsk_nr_cpus_allowed(st
 #define TNF_FAULT_LOCAL	0x08
 #define TNF_MIGRATE_FAIL 0x10
 
+static inline bool in_vfork(struct task_struct *tsk)
+{
+	bool ret;
+
+	/*
+	 * need RCU to access ->real_parent if CLONE_VM was used along with
+	 * CLONE_PARENT.
+	 *
+	 * We check real_parent->mm == tsk->mm because CLONE_VFORK does not
+	 * imply CLONE_VM
+	 *
+	 * CLONE_VFORK can be used with CLONE_PARENT/CLONE_THREAD and thus
+	 * ->real_parent is not necessarily the task doing vfork(), so in
+	 * theory we can't rely on task_lock() if we want to dereference it.
+	 *
+	 * And in this case we can't trust the real_parent->mm == tsk->mm
+	 * check, it can be false negative. But we do not care, if init or
+	 * another oom-unkillable task does this it should blame itself.
+	 */
+	rcu_read_lock();
+	ret = tsk->vfork_done && tsk->real_parent->mm == tsk->mm;
+	rcu_read_unlock();
+
+	return ret;
+}
+
 #ifdef CONFIG_NUMA_BALANCING
 extern void task_numa_fault(int last_node, int node, int pages, int flags);
 extern pid_t task_numa_group_id(struct task_struct *p);
diff -puN mm/oom_kill.c~mm-oom-skip-vforked-tasks-from-being-selected mm/oom_kill.c
--- a/mm/oom_kill.c~mm-oom-skip-vforked-tasks-from-being-selected
+++ a/mm/oom_kill.c
@@ -176,11 +176,13 @@ unsigned long oom_badness(struct task_st
 
 	/*
 	 * Do not even consider tasks which are explicitly marked oom
-	 * unkillable or have been already oom reaped.
+	 * unkillable or have been already oom reaped or the are in
+	 * the middle of vfork
 	 */
 	adj = (long)p->signal->oom_score_adj;
 	if (adj == OOM_SCORE_ADJ_MIN ||
-			test_bit(MMF_OOM_REAPED, &p->mm->flags)) {
+			test_bit(MMF_OOM_REAPED, &p->mm->flags) ||
+			in_vfork(p)) {
 		task_unlock(p);
 		return 0;
 	}
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

