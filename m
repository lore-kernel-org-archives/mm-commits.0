From: akpm@linux-foundation.org
Subject: +
 mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch added to
 -mm tree
Date: Tue, 26 Aug 2014 16:48:37 -0700
Message-ID: <53fd1cd5.J8LbQZwBaFE0zVxD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:45703 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031AbaHZXsj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:48:39 -0400
Received: by mail-qc0-f202.google.com with SMTP id r5so1847245qcx.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:48:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: introduce __get_vma_policy(), export get_task_policy()
has been added to the -mm tree.  Its filename is
     mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch

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
Subject: mempolicy: introduce __get_vma_policy(), export get_task_policy()

Extract the code which looks for vma's policy from get_vma_policy()
into the new helper, __get_vma_policy(). Export get_task_policy().

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

 include/linux/mempolicy.h |    3 ++
 mm/mempolicy.c            |   44 +++++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 18 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-introduce-__get_vma_policy-export-get_task_policy include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-introduce-__get_vma_policy-export-get_task_policy
+++ a/include/linux/mempolicy.h
@@ -134,6 +134,9 @@ void mpol_free_shared_policy(struct shar
 struct mempolicy *mpol_shared_policy_lookup(struct shared_policy *sp,
 					    unsigned long idx);
 
+struct mempolicy *get_task_policy(struct task_struct *p);
+struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
+		unsigned long addr);
 struct mempolicy *get_vma_policy(struct task_struct *tsk,
 		struct vm_area_struct *vma, unsigned long addr);
 bool vma_policy_mof(struct vm_area_struct *vma);
diff -puN mm/mempolicy.c~mempolicy-introduce-__get_vma_policy-export-get_task_policy mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-introduce-__get_vma_policy-export-get_task_policy
+++ a/mm/mempolicy.c
@@ -123,7 +123,7 @@ static struct mempolicy default_policy =
 
 static struct mempolicy preferred_node_policy[MAX_NUMNODES];
 
-static struct mempolicy *get_task_policy(struct task_struct *p)
+struct mempolicy *get_task_policy(struct task_struct *p)
 {
 	struct mempolicy *pol = p->mempolicy;
 	int node;
@@ -1603,23 +1603,8 @@ COMPAT_SYSCALL_DEFINE6(mbind, compat_ulo
 
 #endif
 
-/*
- * get_vma_policy(@task, @vma, @addr)
- * @task: task for fallback if vma policy == default
- * @vma: virtual memory area whose policy is sought
- * @addr: address in @vma for shared policy lookup
- *
- * Returns effective policy for a VMA at specified address.
- * Falls back to @task or system default policy, as necessary.
- * Current or other task's task mempolicy and non-shared vma policies must be
- * protected by task_lock(task) by the caller.
- * Shared policies [those marked as MPOL_F_SHARED] require an extra reference
- * count--added by the get_policy() vm_op, as appropriate--to protect against
- * freeing by another task.  It is the caller's responsibility to free the
- * extra reference for shared policies.
- */
-struct mempolicy *get_vma_policy(struct task_struct *task,
-		struct vm_area_struct *vma, unsigned long addr)
+struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
+						unsigned long addr)
 {
 	struct mempolicy *pol = NULL;
 
@@ -1640,6 +1625,29 @@ struct mempolicy *get_vma_policy(struct
 		}
 	}
 
+	return pol;
+}
+
+/*
+ * get_vma_policy(@task, @vma, @addr)
+ * @task: task for fallback if vma policy == default
+ * @vma: virtual memory area whose policy is sought
+ * @addr: address in @vma for shared policy lookup
+ *
+ * Returns effective policy for a VMA at specified address.
+ * Falls back to @task or system default policy, as necessary.
+ * Current or other task's task mempolicy and non-shared vma policies must be
+ * protected by task_lock(task) by the caller.
+ * Shared policies [those marked as MPOL_F_SHARED] require an extra reference
+ * count--added by the get_policy() vm_op, as appropriate--to protect against
+ * freeing by another task.  It is the caller's responsibility to free the
+ * extra reference for shared policies.
+ */
+struct mempolicy *get_vma_policy(struct task_struct *task,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	struct mempolicy *pol = __get_vma_policy(vma, addr);
+
 	if (!pol)
 		pol = get_task_policy(task);
 
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

