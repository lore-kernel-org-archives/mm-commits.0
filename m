From: akpm@linux-foundation.org
Subject: +
 mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch added to -mm tree
Date: Tue, 26 Aug 2014 16:48:34 -0700
Message-ID: <53fd1cd2.toyB4rD7ET+ZfrP4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f201.google.com ([209.85.214.201]:56744 "EHLO
	mail-ob0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930AbaHZXsf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 26 Aug 2014 19:48:35 -0400
Received: by mail-ob0-f201.google.com with SMTP id va2so2494183obc.0
        for <mm-commits@vger.kernel.org>; Tue, 26 Aug 2014 16:48:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, andi@firstfloor.org, ebiederm@xmission.com, gorcunov@openvz.org, hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com, peterz@infradead.org, rientjes@google.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: mempolicy: change get_task_policy() to return default_policy rather than NULL
has been added to the -mm tree.  Its filename is
     mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch

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
Subject: mempolicy: change get_task_policy() to return default_policy rather than NULL

Every caller of get_task_policy() falls back to default_policy if it
returns NULL. Change get_task_policy() to do this.

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

 mm/mempolicy.c |   31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff -puN mm/mempolicy.c~mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null mm/mempolicy.c
--- a/mm/mempolicy.c~mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null
+++ a/mm/mempolicy.c
@@ -126,22 +126,20 @@ static struct mempolicy preferred_node_p
 static struct mempolicy *get_task_policy(struct task_struct *p)
 {
 	struct mempolicy *pol = p->mempolicy;
+	int node;
 
-	if (!pol) {
-		int node = numa_node_id();
+	if (pol)
+		return pol;
 
-		if (node != NUMA_NO_NODE) {
-			pol = &preferred_node_policy[node];
-			/*
-			 * preferred_node_policy is not initialised early in
-			 * boot
-			 */
-			if (!pol->mode)
-				pol = NULL;
-		}
+	node = numa_node_id();
+	if (node != NUMA_NO_NODE) {
+		pol = &preferred_node_policy[node];
+		/* preferred_node_policy is not initialised early in boot */
+		if (pol->mode)
+			return pol;
 	}
 
-	return pol;
+	return &default_policy;
 }
 
 static const struct mempolicy_operations {
@@ -1644,14 +1642,14 @@ struct mempolicy *get_vma_policy(struct
 				mpol_get(pol);
 		}
 	}
-	if (!pol)
-		pol = &default_policy;
+
 	return pol;
 }
 
 bool vma_policy_mof(struct task_struct *task, struct vm_area_struct *vma)
 {
 	struct mempolicy *pol = get_task_policy(task);
+
 	if (vma) {
 		if (vma->vm_ops && vma->vm_ops->get_policy) {
 			bool ret = false;
@@ -1667,9 +1665,6 @@ bool vma_policy_mof(struct task_struct *
 		}
 	}
 
-	if (!pol)
-		return default_policy.flags & MPOL_F_MOF;
-
 	return pol->flags & MPOL_F_MOF;
 }
 
@@ -2077,7 +2072,7 @@ struct page *alloc_pages_current(gfp_t g
 	struct page *page;
 	unsigned int cpuset_mems_cookie;
 
-	if (!pol || in_interrupt() || (gfp & __GFP_THISNODE))
+	if (in_interrupt() || (gfp & __GFP_THISNODE))
 		pol = &default_policy;
 
 retry_cpuset:
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

