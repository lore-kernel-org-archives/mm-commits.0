From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page-writebackc-add-strictlimit-feature-fix.patch removed from -mm tree
Date: Wed, 11 Sep 2013 14:01:58 -0700
Message-ID: <5230da46.z5PhttNxkkm3G2q5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49152 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753987Ab3IKVB7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 17:01:59 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfr@canb.auug.org.au, mpatlasov@parallels.com, akpm@linux-foundation.org

Subject: [folded-merged] mm-page-writebackc-add-strictlimit-feature-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,mpatlasov@parallels.com,sfr@canb.auug.org.au,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 14:01:58 -0700


The patch titled
     Subject: mm-page-writebackc-add-strictlimit-feature-fix
has been removed from the -mm tree.  Its filename was
     mm-page-writebackc-add-strictlimit-feature-fix.patch

This patch was dropped because it was folded into mm-page-writebackc-add-strictlimit-feature.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page-writebackc-add-strictlimit-feature-fix

fix warning in page-writeback.c

Cc: Maxim Patlasov <mpatlasov@parallels.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page-writeback.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page-writeback.c~mm-page-writebackc-add-strictlimit-feature-fix mm/page-writeback.c
--- a/mm/page-writeback.c~mm-page-writebackc-add-strictlimit-feature-fix
+++ a/mm/page-writeback.c
@@ -1366,10 +1366,8 @@ static void balance_dirty_pages(struct a
 {
 	unsigned long nr_reclaimable;	/* = file_dirty + unstable_nfs */
 	unsigned long nr_dirty;  /* = file_dirty + writeback + unstable_nfs */
-	unsigned long bdi_dirty;
 	unsigned long background_thresh;
 	unsigned long dirty_thresh;
-	unsigned long bdi_thresh;
 	long period;
 	long pause;
 	long max_pause;
@@ -1385,8 +1383,10 @@ static void balance_dirty_pages(struct a
 
 	for (;;) {
 		unsigned long now = jiffies;
-		unsigned long dirty;
+		unsigned long uninitialized_var(bdi_thresh);
 		unsigned long thresh;
+		unsigned long uninitialized_var(bdi_dirty);
+		unsigned long dirty;
 		unsigned long bg_thresh;
 
 		/*
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
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-vmscan-fix-do_try_to_free_pages-livelock.patch
mm-page-writebackc-add-strictlimit-feature.patch
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

