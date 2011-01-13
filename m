From: akpm@linux-foundation.org
Subject: [folded] hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch removed from -mm tree
Date: Thu, 13 Jan 2011 15:37:49 -0800
Message-ID: <201101132337.p0DNbnHw007450@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757120Ab1AMXiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 18:38:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aarcange@redhat.com, caiqian@redhat.com, emunson@mgebm.net, mhocko@suse.cz, nacc@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix
has been removed from the -mm tree.  Its filename was
     hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix.patch

This patch was dropped because it was folded into hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix
From: Andrew Morton <akpm@linux-foundation.org>

avoid multiple return paths in nr_hugepages_store_common()

Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: CAI Qian <caiqian@redhat.com>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Nishanth Aravamudan <nacc@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment-fix
+++ a/mm/hugetlb.c
@@ -1363,6 +1363,7 @@ static ssize_t nr_hugepages_show_common(
 
 	return sprintf(buf, "%lu\n", nr_huge_pages);
 }
+
 static ssize_t nr_hugepages_store_common(bool obey_mempolicy,
 			struct kobject *kobj, struct kobj_attribute *attr,
 			const char *buf, size_t len)
@@ -1375,15 +1376,14 @@ static ssize_t nr_hugepages_store_common
 
 	err = strict_strtoul(buf, 10, &count);
 	if (err) {
-		NODEMASK_FREE(nodes_allowed);
-		return 0;
+		err = 0;		/* This seems wrong */
+		goto out;
 	}
 
 	h = kobj_to_hstate(kobj, &nid);
-
 	if (h->order >= MAX_ORDER) {
-		NODEMASK_FREE(nodes_allowed);
-		return -EINVAL;
+		err = -EINVAL;
+		goto out;
 	}
 
 	if (nid == NUMA_NO_NODE) {
@@ -1411,6 +1411,9 @@ static ssize_t nr_hugepages_store_common
 		NODEMASK_FREE(nodes_allowed);
 
 	return len;
+out:
+	NODEMASK_FREE(nodes_allowed);
+	return err;
 }
 
 static ssize_t nr_hugepages_show(struct kobject *kobj,
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
hugetlb-do-not-allow-pagesize-=-max_order-pool-adjustment.patch
mm-fix-migration-hangs-on-anon_vma-lock-checkpatch-fixes.patch
mm-page_allocc-dont-cache-current-in-a-local.patch
mm-batch-activate_page-to-reduce-lock-contention-checkpatch-fixes.patch
memcg-document-cgroup-dirty-memory-interfaces-fix.patch

