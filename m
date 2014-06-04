From: akpm@linux-foundation.org
Subject: [folded-merged]
 swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map-fix.patch removed from -mm tree
Date: Wed, 04 Jun 2014 15:51:16 -0700
Message-ID: <538fa2e4.7xp5D1av8UkAXiTo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaFDWvR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Jun 2014 18:51:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, slaoub@gmail.com, shli@kernel.org, hughd@google.com

Subject: [folded-merged] swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map-fix.patch removed from -mm tree
To: hughd@google.com,shli@kernel.org,slaoub@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 04 Jun 2014 15:51:16 -0700


The patch titled
     Subject: swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map-fix
has been removed from the -mm tree.  Its filename was
     swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map-fix.patch

This patch was dropped because it was folded into swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map-fix

Cc: Chen Yucong <slaoub@gmail.com>
Cc: Shaohua Li <shli@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff -puN mm/swapfile.c~swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map-fix mm/swapfile.c
--- a/mm/swapfile.c~swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map-fix
+++ a/mm/swapfile.c
@@ -523,13 +523,10 @@ static unsigned long scan_swap_map(struc
 		/*
 		 * If seek is expensive, start searching for new cluster from
 		 * start of partition, to minimize the span of allocated swap.
-		 * But if seek is cheap, search from our current position, so
-		 * that swap is allocated from all over the partition: if the
-		 * Flash Translation Layer only remaps within limited zones,
-		 * we don't want to wear out the first zone too quickly.
+		 * If seek is cheap, that is the SWP_SOLIDSTATE si->cluster_info
+		 * case, just handled by scan_swap_map_try_ssd_cluster() above.
 		 */
-		if (!(si->flags & SWP_SOLIDSTATE))
-			scan_base = offset = si->lowest_bit;
+		scan_base = offset = si->lowest_bit;
 		last_in_cluster = offset + SWAPFILE_CLUSTER - 1;
 
 		/* Locate the first empty (unaligned) cluster */
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
mm-fix-sleeping-function-warning-from-__put_anon_vma.patch
hugetlb-restrict-hugepage_migration_support-to-x86_64.patch
mm-softdirty-make-freshly-remapped-file-pages-being-softdirty-unconditionally.patch
mm-softdirty-dont-forget-to-save-file-map-softdiry-bit-on-unmap.patch
mm-softdirty-clear-vm_softdirty-flag-inside-clear_refs_write-instead-of-clear_soft_dirty.patch
mm-only-force-scan-in-reclaim-when-none-of-the-lrus-are-big-enough.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-numa-add-migrated-transhuge-pages-to-lru-the-same-way-as-base-pages.patch
fs-bufferc-remove-block_write_full_page_endio.patch
fs-mpagec-factor-clean_buffers-out-of-__mpage_writepage.patch
fs-mpagec-factor-page_endio-out-of-mpage_end_io.patch
fs-block_devc-add-bdev_read_page-and-bdev_write_page.patch
swap-use-bdev_read_page-bdev_write_page.patch
brd-add-support-for-rw_page.patch
brd-return-enospc-rather-than-enomem-on-page-allocation-failure.patch
mm-replace-__get_cpu_var-uses-with-this_cpu_ptr.patch
mm-swapc-introduce-put_refcounted_compound_page-helpers-for-spliting-put_compound_page.patch
mm-swapc-split-put_compound_page-function.patch
mm-introdule-compound_head_by_tail.patch
mm-thp-avoid-excessive-compaction-latency-during-fault.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
swap-change-swap_info-singly-linked-list-to-list_head.patch
plist-add-helper-functions.patch
plist-add-plist_requeue.patch
swap-change-swap_list_head-to-plist-add-swap_avail_head.patch
jump_label-expose-the-reference-count.patch
mm-page_alloc-use-jump-labels-to-avoid-checking-number_of_cpusets.patch
mm-page_alloc-only-check-the-zone-id-check-if-pages-are-buddies.patch
mm-page_alloc-only-check-the-alloc-flags-and-gfp_mask-for-dirty-once.patch
mm-page_alloc-take-the-alloc_no_watermark-check-out-of-the-fast-path.patch
mm-page_alloc-use-word-based-accesses-for-get-set-pageblock-bitmaps.patch
mm-page_alloc-reduce-number-of-times-page_to_pfn-is-called.patch
mm-page_alloc-lookup-pageblock-migratetype-with-irqs-enabled-during-free.patch
mm-page_alloc-use-unsigned-int-for-order-in-more-places.patch
mm-page_alloc-convert-hot-cold-parameter-and-immediate-callers-to-bool.patch
mm-shmem-avoid-atomic-operation-during-shmem_getpage_gfp.patch
mm-do-not-use-atomic-operations-when-releasing-pages.patch
mm-do-not-use-unnecessary-atomic-operations-when-adding-pages-to-the-lru.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers.patch
mm-non-atomically-mark-page-accessed-during-page-cache-allocation-where-possible.patch
mm-page_alloc-calculate-classzone_idx-once-from-the-zonelist-ref.patch
fs-superblock-unregister-sb-shrinker-before-kill_sb.patch
fs-superblock-avoid-locking-counting-inodes-and-dentries-before-reclaiming-them.patch
mm-vmscan-use-proportional-scanning-during-direct-reclaim-and-full-scan-at-def_priority.patch
mm-process_vm_access-move-config-option-into-init-kconfig.patch
mm-nominate-faultaround-area-in-bytes-rather-then-page-order.patch
hugetlb-rename-hugepage_migration_support-to-_supported.patch
swap-delete-the-last_in_cluster-scan_base-loop-in-the-body-of-scan_swap_map.patch
mm-memcg-periodically-schedule-when-emptying-page-list.patch

