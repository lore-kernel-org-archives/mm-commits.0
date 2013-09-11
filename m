From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
 removed from -mm tree
Date: Wed, 11 Sep 2013 13:59:25 -0700
Message-ID: <5230d9ad.OchhKNoDD8f3ixdI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab3IKU70 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:59:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, khalid.aziz@oracle.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,khalid.aziz@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:59:25 -0700


The patch titled
     Subject: mm-fix-aio-performance-regression-for-database-caused-by-thp-fix
has been removed from the -mm tree.  Its filename was
     mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch

This patch was dropped because it was folded into mm-fix-aio-performance-regression-for-database-caused-by-thp.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-fix-aio-performance-regression-for-database-caused-by-thp-fix

tweak comments

Cc: Khalid Aziz <khalid.aziz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN mm/swap.c~mm-fix-aio-performance-regression-for-database-caused-by-thp-fix mm/swap.c
--- a/mm/swap.c~mm-fix-aio-performance-regression-for-database-caused-by-thp-fix
+++ a/mm/swap.c
@@ -83,9 +83,9 @@ static void __put_compound_page(struct p
 static void put_compound_page(struct page *page)
 {
 	/*
-	 * hugetlbfs pages can not be split from under us. If this
-	 * is a hugetlbfs page, check refcount on head page and release
-	 * the page if refcount is zero.
+	 * hugetlbfs pages cannot be split from under us.  If this is a
+	 * hugetlbfs page, check refcount on head page and release the page if
+	 * the refcount becomes zero.
 	 */
 	if (PageHuge(page)) {
 		page = compound_head(page);
@@ -202,8 +202,8 @@ bool __get_page_tail(struct page *page)
 	struct page *page_head;
 
 	/*
-	 * If this is a hugetlbfs page, it can not be split under
-	 * us. Simply increment refcount for head page
+	 * If this is a hugetlbfs page it cannot be split under us.  Simply
+	 * increment refcount for the head page.
 	 */
 	if (PageHuge(page)) {
 		page_head = compound_head(page);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
revert-include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
block-support-embedded-device-command-line-partition.patch
swap-warn-when-a-swap-area-overflows-the-maximum-size.patch
mm-swapfilec-convert-to-pr_foo.patch
mm-vmstats-track-tlb-flush-stats-on-up-too.patch
swap-make-swap-discard-async.patch
swap-make-cluster-allocation-per-cpu.patch
mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages.patch
mm-hotplug-verify-hotplug-memory-range.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp.patch
mm-track-vma-changes-with-vm_softdirty-bit-fix.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-page-writebackc-add-strictlimit-feature-fix.patch
mm-madvisec-madvise_hwpoison-remove-local-ret.patch
lib-crc32-update-the-comments-of-crc32_bele_generic-checkpatch-fixes.patch
move-exit_task_namespaces-outside-of-exit_notify-fix.patch
partitions-efi-use-lba-aware-partition-records-checkpatch-fixes.patch
partitions-efi-check-pmbr-records-starting-lba-checkpatch-fixes.patch
partitions-efi-detect-hybrid-mbrs-checkpatch-fixes.patch
partitions-efi-some-style-cleanups-checkpatch-fixes.patch
block-partitions-efic-consistently-use-pr_foo.patch
initmpfs-move-bdi-setup-from-init_rootfs-to-init_ramfs-fix.patch
initmpfs-use-initramfs-if-rootfstype=-or-root=-specified-checkpatch-fixes.patch
ipc-drop-ipcctl_pre_down-fix.patch
ipcshm-make-shmctl_nolock-lockless-checkpatch-fixes.patch
drivers-staging-lustre-lustre-ptlrpc-sec_bulkc-rename-ptrs_per_page.patch

