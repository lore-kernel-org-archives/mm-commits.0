From: akpm@linux-foundation.org
Subject: [folded] hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:37:27 -0800
Message-ID: <201101132337.p0DNbRxF007442@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58103 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757120Ab1AMXh5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:37:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, caiqian@redhat.com, mhocko@suse.cz, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix.patch

This patch was dropped because it was folded into hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix
From: Andrew Morton <akpm@linux-foundation.org>

correctly propagate proc_doulongvec_minmax return code

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler-fix
+++ a/mm/hugetlb.c
@@ -1859,14 +1859,16 @@ static int hugetlb_sysctl_handler_common
 {
 	struct hstate *h = &default_hstate;
 	unsigned long tmp;
+	int ret;
 
 	if (!write)
 		tmp = h->max_huge_pages;
 
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
-	if (proc_doulongvec_minmax(table, write, buffer, length, ppos))
-		return -EINVAL;
+	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	if (ret)
+		goto out;
 
 	if (write) {
 		NODEMASK_ALLOC(nodemask_t, nodes_allowed,
@@ -1881,8 +1883,8 @@ static int hugetlb_sysctl_handler_common
 		if (nodes_allowed != &node_states[N_HIGH_MEMORY])
 			NODEMASK_FREE(nodes_allowed);
 	}
-
-	return 0;
+out:
+	return ret;
 }
 
 int hugetlb_sysctl_handler(struct ctl_table *table, int write,
@@ -1920,22 +1922,24 @@ int hugetlb_overcommit_handler(struct ct
 {
 	struct hstate *h = &default_hstate;
 	unsigned long tmp;
+	int ret;
 
 	if (!write)
 		tmp = h->nr_overcommit_huge_pages;
 
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
-	if (proc_doulongvec_minmax(table, write, buffer, length, ppos))
-		return -EINVAL;
+	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
+	if (ret)
+		goto out;
 
 	if (write) {
 		spin_lock(&hugetlb_lock);
 		h->nr_overcommit_huge_pages = tmp;
 		spin_unlock(&hugetlb_lock);
 	}
-
-	return 0;
+out:
+	return ret;
 }
 
 #endif /* CONFIG_SYSCTL */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
atmel_serial-fix-rts-high-after-initialization-in-rs485-mode.patch
mm-vmstat-use-a-single-setter-function-and-callback-for-adjusting-percpu-thresholds.patch
sync_inode_metadata-fix-comment.patch
fs-mpagec-consolidate-code.patch
mm-vmscan-reclaim-order-0-and-use-compaction-instead-of-lumpy-reclaim.patch
mm-migration-allow-migration-to-operate-asynchronously-and-avoid-synchronous-compaction-in-the-faster-path.patch
mlock-do-not-hold-mmap_sem-for-extended-periods-of-time.patch
writeback-avoid-unnecessary-determine_dirtyable_memory-call.patch
thp-pte-alloc-trans-splitting.patch
thp-kvm-mmu-transparent-hugepage-support.patch
thp-khugepaged-make-khugepaged-aware-of-madvise.patch
mm-migration-use-rcu_dereference_protected-when-dereferencing-the-radix-tree-slot-during-file-page-migration.patch
mm-hugetlbc-fix-error-path-memory-leak-in-nr_hugepages_store_common.patch
brk-fix-min_brk-lower-bound-computation-for-compat_brk.patch
mm-page_allocc-simplify-calculation-of-combined-index-of-adjacent-buddy-lists.patch
mm-dmapoolc-use-task_uninterruptible-in-dma_pool_alloc.patch
hugetlb-check-the-return-value-of-string-conversion-in-sysctl-handler.patch
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch
mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch

