From: akpm@linux-foundation.org
Subject: + mempolicy-sanitize-the-usage-of-get_task_policy.patch added to
 -mm tree
Date: Tue, 26 Aug 2014 16:48:35 -0700
Message-ID: <53fd1cd3.JdsjRW37LnUF30cc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:41797 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbaHZXsh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:48:37 -0400
Received: by mail-ob0-f201.google.com with SMTP id va2so2493432obc.2
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:48:37 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: sanitize the usage of get_task_policy()
has been added to the -mm tree.  Its filename is
     mempolicy-sanitize-the-usage-of-get_task_policy.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempolicy-sanitize-the-usage-of-get_task_policy.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempolicy-sanitize-the-usage-of-get_task_policy.patch

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
Subject: mempolicy: sanitize the usage of get_task_policy()

Cleanup + preparation. Every user of get_task_policy() calls it
unconditionally, even if it is not going to use the result.

get_task_policy() is cheap but still this does not look clean, plus
the code looks simpler if get_task_policy() is called only when this
is really needed.

Note: I hope this is correct, but it is not clear why vma_policy_mof()
doesn't fall back to get_task_policy() if ->get_policy() returns NULL.

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

 mm/mempolicy.c |   25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-sanitize-the-usage-of-get_task_policy mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-sanitize-the-usage-of-get_task_policy
+++ a/mm/mempolicy.c
@@ -1621,14 +1621,11 @@ COMPAT_SYSCALL_DEFINE6(mbind, compat_ulo
 struct mempolicy *get_vma_policy(struct task_struct *task,
 		struct vm_area_struct *vma, unsigned long addr)
 {
-	struct mempolicy *pol = get_task_policy(task);
+	struct mempolicy *pol = NULL;
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
-			struct mempolicy *vpol = vma->vm_ops->get_policy(vma,
-									addr);
-			if (vpol)
-				pol = vpol;
+			pol = vma->vm_ops->get_policy(vma, addr);
 		} else if (vma->vm_policy) {
 			pol = vma->vm_policy;
 
@@ -1643,12 +1640,15 @@ struct mempolicy *get_vma_policy(struct
 		}
 	}
 
+	if (!pol)
+		pol = get_task_policy(task);
+
 	return pol;
 }
 
 bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
 {
-	struct mempolicy *pol = get_task_policy(task);
+	struct mempolicy *pol = NULL;
 
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
@@ -1660,11 +1660,14 @@ bool vma_policy_mof(struct task_struct *
 			mpol_cond_put(pol);
 
 			return ret;
-		} else if (vma->vm_policy) {
-			pol = vma->vm_policy;
 		}
+
+		pol = vma->vm_policy;
 	}
 
+	if (!pol)
+		pol = get_task_policy(task);
+
 	return pol->flags & MPOL_F_MOF;
 }
 
@@ -2068,12 +2071,12 @@ retry_cpuset:
  */
 struct page *alloc_pages_current(gfp_t gfp, unsigned order)
 {
-	struct mempolicy *pol = get_task_policy(current);
+	struct mempolicy *pol = &default_policy;
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
 
-	if (in_interrupt() || (gfp & __GFP_THISNODE))
-		pol = &default_policy;
+	if (!in_interrupt() && !(gfp & __GFP_THISNODE))
+		pol = get_task_policy(current);
 
 retry_cpuset:
 	cpuset_mems_cookie = read_mems_allowed_begin();
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

