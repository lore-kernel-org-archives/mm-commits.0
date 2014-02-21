From: akpm@linux-foundation.org
Subject: + mm-swap-use-swapfiles-in-priority-order.patch added to -mm tree
Date: Fri, 21 Feb 2014 15:03:33 -0800
Message-ID: <5307db45.DbvgdR2x2qwNvw+X%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59061 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbaBUXDe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 18:03:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, weijie.yang.kh@gmail.com, mhocko@suse.cz, hughd@google.com, mgorman@suse.de

Subject: + mm-swap-use-swapfiles-in-priority-order.patch added to -mm tree
To: mgorman@suse.de,hughd@google.com,mhocko@suse.cz,weijie.yang.kh@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 15:03:33 -0800


The patch titled
     Subject: mm: swap: use swapfiles in priority order
has been added to the -mm tree.  Its filename is
     mm-swap-use-swapfiles-in-priority-order.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-use-swapfiles-in-priority-order.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-use-swapfiles-in-priority-order.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: swap: use swapfiles in priority order

According to the swapon documentation

	Swap  pages  are  allocated  from  areas  in priority order,
	highest priority first.  For areas with different priorities, a
	higher-priority area is exhausted before using a lower-priority area.

A user reported that the reality is different. When multiple swap files
are enabled and a memory consumer started, the swap files are consumed in
pairs after the highest priority file is exhausted. Early in the lifetime
of the test, swapfile consumptions looks like

Filename                                Type            Size    Used    Priority
/testswap1                              file            100004  100004  8
/testswap2                              file            100004  23764   7
/testswap3                              file            100004  23764   6
/testswap4                              file            100004  0       5
/testswap5                              file            100004  0       4
/testswap6                              file            100004  0       3
/testswap7                              file            100004  0       2
/testswap8                              file            100004  0       1

This patch fixes the swap_list search in get_swap_page to use the swap files
in the correct order. When applied the swap file consumptions looks like

Filename				Type		Size	Used	Priority
/testswap1                              file		100004	100004	8
/testswap2                              file		100004	100004	7
/testswap3                              file		100004	29372	6
/testswap4                              file		100004	0	5
/testswap5                              file		100004	0	4
/testswap6                              file		100004	0	3
/testswap7                              file		100004	0	2
/testswap8                              file		100004	0	1

Signed-off-by: Mel Gorman <mgorman@suse.de>
Cc: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/swapfile.c~mm-swap-use-swapfiles-in-priority-order mm/swapfile.c
--- a/mm/swapfile.c~mm-swap-use-swapfiles-in-priority-order
+++ a/mm/swapfile.c
@@ -651,7 +651,7 @@ swp_entry_t get_swap_page(void)
 		goto noswap;
 	atomic_long_dec(&nr_swap_pages);
 
-	for (type = swap_list.next; type >= 0 && wrapped < 2; type = next) {
+	for (type = swap_list.head; type >= 0 && wrapped < 2; type = next) {
 		hp_index = atomic_xchg(&highest_priority_index, -1);
 		/*
 		 * highest_priority_index records current highest priority swap
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-hwpoison-release-page-on-pagehwpoison-in-__do_fault.patch
mm-close-pagetail-race.patch
mm-page_alloc-make-first_page-visible-before-pagetail.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch
mm-compaction-ignore-pageblock-skip-when-manually-invoking-compaction.patch
mm-optimize-put_mems_allowed-usage.patch
mm-vmstat-fix-up-zone-state-accounting.patch
fs-cachefiles-use-add_to_page_cache_lru.patch
lib-radix-tree-radix_tree_delete_item.patch
mm-shmem-save-one-radix-tree-lookup-when-truncating-swapped-pages.patch
mm-filemap-move-radix-tree-hole-searching-here.patch
mm-fs-prepare-for-non-page-entries-in-page-cache-radix-trees.patch
mm-fs-store-shadow-entries-in-page-cache.patch
mm-thrash-detection-based-file-cache-sizing.patch
lib-radix_tree-tree-node-interface.patch
mm-keep-page-cache-radix-tree-nodes-in-check.patch
mm-compaction-avoid-isolating-pinned-pages.patch
mm-rename-__do_fault-do_fault.patch
mm-do_fault-extract-to-call-vm_ops-do_fault-to-separate-function.patch
mm-introduce-do_read_fault.patch
mm-introduce-do_cow_fault.patch
mm-introduce-do_shared_fault-and-drop-do_fault.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite.patch
mm-consolidate-code-to-call-vm_ops-page_mkwrite-fix.patch
mm-consolidate-code-to-setup-pte.patch
mm-vmscan-restore-sc-gfp_mask-after-promoting-it-to-__gfp_highmem.patch
mm-vmscan-do-not-check-compaction_ready-on-promoted-zones.patch
mm-compaction-disallow-high-order-page-for-migration-target.patch
mm-compaction-do-not-call-suitable_migration_target-on-every-page.patch
mm-compaction-change-the-timing-to-check-to-drop-the-spinlock.patch
mm-compaction-check-pageblock-suitability-once-per-pageblock.patch
mm-compaction-clean-up-code-on-success-of-ballon-isolation.patch
mm-swap-use-swapfiles-in-priority-order.patch
linux-next.patch

