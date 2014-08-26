From: akpm@linux-foundation.org
Subject: +
 mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch added to -mm tree
Date: Tue, 26 Aug 2014 16:48:36 -0700
Message-ID: <53fd1cd4.YeDJaA8dLI5ar4Xk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:64672 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756029AbaHZXsi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:48:38 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so4092086pab.0
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:48:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: remove the "task" arg of vma_policy_mof() and simplify it
has been added to the -mm tree.  Its filename is
     mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: mempolicy: remove the "task" arg of vma_policy_mof() and simplify it

1. vma_policy_mof(task) is simply not safe unless task == current,
   it can race with do_exit()->mpol_put(). Remove this arg and update
   its single caller.

2. vma can not be NULL, remove this check and simplify the code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mempolicy.h |    2 +-
 kernel/sched/fair.c       |    2 +-
 mm/mempolicy.c            |   25 +++++++++++--------------
 3 files changed, 13 insertions(+), 16 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it
+++ a/include/linux/mempolicy.h
@@ -136,7 +136,7 @@ struct mempolicy *mpol_shared_policy_loo
 
 struct mempolicy *get_vma_policy(struct task_struct *tsk,
 		struct vm_area_struct *vma, unsigned long addr);
-bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma);
+bool vma_policy_mof(struct vm_area_struct *vma);
 
 extern void numa_default_policy(void);
 extern void numa_policy_init(void);
diff -puN kernel/sched/fair.c~mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it kernel/sched/fair.c
--- a/kernel/sched/fair.c~mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it
+++ a/kernel/sched/fair.c
@@ -1946,7 +1946,7 @@ void task_numa_work(struct callback_head
 		vma = mm->mmap;
 	}
 	for (; vma; vma = vma->vm_next) {
-		if (!vma_migratable(vma) || !vma_policy_mof(p, vma))
+		if (!vma_migratable(vma) || !vma_policy_mof(vma))
 			continue;
 
 		/*
diff -puN mm/mempolicy.c~mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it
+++ a/mm/mempolicy.c
@@ -1646,27 +1646,24 @@ struct mempolicy *get_vma_policy(struct
 	return pol;
 }
 
-bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
+bool vma_policy_mof(struct vm_area_struct *vma)
 {
-	struct mempolicy *pol = NULL;
+	struct mempolicy *pol;
 
-	if (vma) {
-		if (vma->vm_ops && vma->vm_ops->get_policy) {
-			bool ret = false;
+	if (vma->vm_ops && vma->vm_ops->get_policy) {
+		bool ret = false;
 
-			pol = vma->vm_ops->get_policy(vma, vma->vm_start);
-			if (pol && (pol->flags & MPOL_F_MOF))
-				ret = true;
-			mpol_cond_put(pol);
+		pol = vma->vm_ops->get_policy(vma, vma->vm_start);
+		if (pol && (pol->flags & MPOL_F_MOF))
+			ret = true;
+		mpol_cond_put(pol);
 
-			return ret;
-		}
-
-		pol = vma->vm_policy;
+		return ret;
 	}
 
+	pol = vma->vm_policy;
 	if (!pol)
-		pol = get_task_policy(task);
+		pol = get_task_policy(current);
 
 	return pol->flags & MPOL_F_MOF;
 }
_

Patches currently in -mm which might be from oleg@redhat.com are

prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch
mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch
mempolicy-sanitize-the-usage-of-get_task_policy.patch
mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch
mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch
mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch
earlyprintk-re-enable-earlyprintk-calling-early_param.patch
fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch
fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
proc-introduce-proc_mem_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
fs-proc-task_mmuc-reintroduce-m-version-logic.patch
fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_nommuc-dont-use-priv-task-mm.patch
proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode.patch
proc-maps-make-vm_is_stack-logic-namespace-friendly.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

