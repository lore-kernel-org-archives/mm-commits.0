From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch
 removed from -mm tree
Date: Wed, 11 Sep 2013 13:53:51 -0700
Message-ID: <5230d85f.rNb9KiB5xfTwqvXM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab3IKUxw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:53:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com, minchan@kernel.org, mel@csn.ul.ie, cody@linux.vnet.ibm.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,cody@linux.vnet.ibm.com,mel@csn.ul.ie,minchan@kernel.org,srivatsa.bhat@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:53:51 -0700


The patch titled
     Subject: mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix.patch

This patch was dropped because it was folded into mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix

remove unneeded `inline', small coding-style fix

Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-restructure-free-page-stealing-code-and-fix-a-bug-fix
+++ a/mm/page_alloc.c
@@ -1020,8 +1020,8 @@ static void change_pageblock_range(struc
  * Returns the new migratetype of the pageblock (or the same old migratetype
  * if it was unchanged).
  */
-static inline int try_to_steal_freepages(struct zone *zone, struct page *page,
-					 int start_type, int fallback_type)
+static int try_to_steal_freepages(struct zone *zone, struct page *page,
+				  int start_type, int fallback_type)
 {
 	int current_order = page_order(page);
 
@@ -1037,7 +1037,6 @@ static inline int try_to_steal_freepages
 	if (current_order >= pageblock_order / 2 ||
 	    start_type == MIGRATE_RECLAIMABLE ||
 	    page_group_by_mobility_disabled) {
-
 		int pages;
 
 		pages = move_freepages_block(zone, page, start_type);
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
mm-hugetlb-decrement-reserve-count-if-vm_noreserve-alloc-page-cache-fix.patch
mm-mempolicy-return-null-if-node-is-numa_no_node-in-get_task_policy.patch
vmstat-create-separate-function-to-fold-per-cpu-diffs-into-local-counters-fix.patch
genalloc-fix-overflow-of-ending-address-of-memory-chunk-fix.patch
mm-use-zone_end_pfn-instead-of-zone_start_pfnspanned_pages-fix.patch
mm-hotplug-verify-hotplug-memory-range-fix.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp-fix.patch
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

