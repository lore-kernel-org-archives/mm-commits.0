From: akpm@linux-foundation.org
Subject: + mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch added to -mm tree
Date: Tue, 26 Aug 2014 16:48:40 -0700
Message-ID: <53fd1cd8.oDy0hiaTUlhMdNJV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:49716 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbaHZXsl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:48:41 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so4129298pab.1
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:48:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: unexport get_vma_policy() and remove its "task" arg
has been added to the -mm tree.  Its filename is
     mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch

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
Subject: mempolicy: unexport get_vma_policy() and remove its "task" arg

- get_vma_policy(task) is not safe if task != current, remove this
  argument.

- get_vma_policy() no longer has callers outside of mempolicy.c,
  make it static.

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

 include/linux/mempolicy.h |    2 --
 mm/mempolicy.c            |   19 ++++++++-----------
 2 files changed, 8 insertions(+), 13 deletions(-)

diff -puN include/linux/mempolicy.h~mempolicy-unexport-get_vma_policy-and-remove-its-task-arg include/linux/mempolicy.h
--- a/include/linux/mempolicy.h~mempolicy-unexport-get_vma_policy-and-remove-its-task-arg
+++ a/include/linux/mempolicy.h
@@ -137,8 +137,6 @@ struct mempolicy *mpol_shared_policy_loo
 struct mempolicy *get_task_policy(struct task_struct *p);
 struct mempolicy *__get_vma_policy(struct vm_area_struct *vma,
 		unsigned long addr);
-struct mempolicy *get_vma_policy(struct task_struct *tsk,
-		struct vm_area_struct *vma, unsigned long addr);
 bool vma_policy_mof(struct vm_area_struct *vma);
 
 extern void numa_default_policy(void);
diff -puN mm/mempolicy.c~mempolicy-unexport-get_vma_policy-and-remove-its-task-arg mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-unexport-get_vma_policy-and-remove-its-task-arg
+++ a/mm/mempolicy.c
@@ -1616,27 +1616,24 @@ struct mempolicy *__get_vma_policy(struc
 }
 
 /*
- * get_vma_policy(@task, @vma, @addr)
- * @task: task for fallback if vma policy == default
+ * get_vma_policy(@vma, @addr)
  * @vma: virtual memory area whose policy is sought
  * @addr: address in @vma for shared policy lookup
  *
  * Returns effective policy for a VMA at specified address.
- * Falls back to @task or system default policy, as necessary.
- * Current or other task's task mempolicy and non-shared vma policies must be
- * protected by task_lock(task) by the caller.
+ * Falls back to current->mempolicy or system default policy, as necessary.
  * Shared policies [those marked as MPOL_F_SHARED] require an extra reference
  * count--added by the get_policy() vm_op, as appropriate--to protect against
  * freeing by another task.  It is the caller's responsibility to free the
  * extra reference for shared policies.
  */
-struct mempolicy *get_vma_policy(struct task_struct *task,
-		struct vm_area_struct *vma, unsigned long addr)
+static struct mempolicy *get_vma_policy(struct vm_area_struct *vma,
+						unsigned long addr)
 {
 	struct mempolicy *pol = __get_vma_policy(vma, addr);
 
 	if (!pol)
-		pol = get_task_policy(task);
+		pol = get_task_policy(current);
 
 	return pol;
 }
@@ -1864,7 +1861,7 @@ struct zonelist *huge_zonelist(struct vm
 {
 	struct zonelist *zl;
 
-	*mpol = get_vma_policy(current, vma, addr);
+	*mpol = get_vma_policy(vma, addr);
 	*nodemask = NULL;	/* assume !MPOL_BIND */
 
 	if (unlikely((*mpol)->mode == MPOL_INTERLEAVE)) {
@@ -2019,7 +2016,7 @@ alloc_pages_vma(gfp_t gfp, int order, st
 	unsigned int cpuset_mems_cookie;
 
 retry_cpuset:
-	pol = get_vma_policy(current, vma, addr);
+	pol = get_vma_policy(vma, addr);
 	cpuset_mems_cookie = read_mems_allowed_begin();
 
 	if (unlikely(pol->mode == MPOL_INTERLEAVE)) {
@@ -2285,7 +2282,7 @@ int mpol_misplaced(struct page *page, st
 
 	BUG_ON(!vma);
 
-	pol = get_vma_policy(current, vma, addr);
+	pol = get_vma_policy(vma, addr);
 	if (!(pol->flags & MPOL_F_MOF))
 		goto out;
 
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

