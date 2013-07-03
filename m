From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix.patch removed from -mm tree
Date: Wed, 03 Jul 2013 14:32:25 -0700
Message-ID: <51d49869.3TdHUMSOUoB2bDUE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40031 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932417Ab3GCVc0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:32:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, fengguang.wu@intel.com, mgorman@suse.de

Subject: [folded-merged] mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix.patch removed from -mm tree
To: mgorman@suse.de,fengguang.wu@intel.com,mhocko@suse.cz,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:32:25 -0700


The patch titled
     Subject: mm: Clear page active before releasing pages
has been removed from the -mm tree.  Its filename was
     mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix.patch

This patch was dropped because it was folded into mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: Clear page active before releasing pages

Active pages should not be freed to the page allocator as it triggers a
bad page state warning.  Fengguang Wu reported the following bug and
bisected it to the patch "mm: remove lru parameter from __lru_cache_add
and lru_cache_add_lru" which is currently in mmotm as
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch

[   84.212960] BUG: Bad page state in process rm  pfn:0b0c9
[   84.214682] page:ffff88000d646240 count:0 mapcount:0 mapping:          (null) index:0x0
[   84.216883] page flags: 0x20000000004c(referenced|uptodate|active)
[   84.218697] CPU: 1 PID: 283 Comm: rm Not tainted 3.10.0-rc4-04361-geeb9bfc #49
[   84.220729]  ffff88000d646240 ffff88000d179bb8 ffffffff82562956 ffff88000d179bd8
[   84.223242]  ffffffff811333f1 000020000000004c ffff88000d646240 ffff88000d179c28
[   84.225387]  ffffffff811346a4 ffff880000270000 0000000000000000 0000000000000006
[   84.227294] Call Trace:
[   84.227867]  [<ffffffff82562956>] dump_stack+0x27/0x30
[   84.229045]  [<ffffffff811333f1>] bad_page+0x130/0x158
[   84.230261]  [<ffffffff811346a4>] free_pages_prepare+0x8b/0x1e3
[   84.231765]  [<ffffffff8113542a>] free_hot_cold_page+0x28/0x1cf
[   84.233171]  [<ffffffff82585830>] ? _raw_spin_unlock_irqrestore+0x6b/0xc6
[   84.234822]  [<ffffffff81135b59>] free_hot_cold_page_list+0x30/0x5a
[   84.236311]  [<ffffffff8113a4ed>] release_pages+0x251/0x267
[   84.237653]  [<ffffffff8112a88d>] ? delete_from_page_cache+0x48/0x9e
[   84.239142]  [<ffffffff8113ad93>] __pagevec_release+0x2b/0x3d
[   84.240473]  [<ffffffff8113b45a>] truncate_inode_pages_range+0x1b0/0x7ce
[   84.242032]  [<ffffffff810e76ab>] ? put_lock_stats.isra.20+0x1c/0x53
[   84.243480]  [<ffffffff810e77f5>] ? lock_release_holdtime+0x113/0x11f
[   84.244935]  [<ffffffff8113ba8c>] truncate_inode_pages+0x14/0x1d
[   84.246337]  [<ffffffff8119b3ef>] evict+0x11f/0x232
[   84.247501]  [<ffffffff8119c527>] iput+0x1a5/0x218
[   84.248607]  [<ffffffff8118f015>] do_unlinkat+0x19b/0x25a
[   84.249828]  [<ffffffff810ea993>] ? trace_hardirqs_on_caller+0x210/0x2ce
[   84.251382]  [<ffffffff8144372e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   84.252879]  [<ffffffff8118f10d>] SyS_unlinkat+0x39/0x4c
[   84.254174]  [<ffffffff825874d6>] system_call_fastpath+0x1a/0x1f
[   84.255596] Disabling lock debugging due to kernel taint

The problem was that a page marked for activation was released via
pagevec. This patch clears the active bit before freeing in this case.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reported-and-Tested-by: Fengguang Wu <fengguang.wu@intel.com>
Tested-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/swap.c~mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix mm/swap.c
--- a/mm/swap.c~mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix
+++ a/mm/swap.c
@@ -739,6 +739,9 @@ void release_pages(struct page **pages,
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		}
 
+		/* Clear Active bit in case of parallel mark_page_accessed */
+		ClearPageActive(page);
+
 		list_add(&page->lru, &pages_to_free);
 	}
 	if (zone)
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-vmscan-stall-page-reclaim-and-writeback-pages-based-on-dirty-writepage-pages-encountered-v3.patch
mm-vmscan-stall-page-reclaim-after-a-list-of-pages-have-been-processed-v3.patch
mm-vmscan-set-zone-flags-before-blocking.patch
mm-vmscan-move-direct-reclaim-wait_iff_congested-into-shrink_list.patch
mm-vmscan-treat-pages-marked-for-immediate-reclaim-as-zone-congestion.patch
mm-vmscan-take-page-buffers-dirty-and-locked-state-into-account-v3.patch
fs-nfs-inform-the-vm-about-pages-being-committed-or-unstable.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru-fix-2.patch
mm-fix-the-tlb-range-flushed-when-__tlb_remove_page-runs-out-of-slots.patch
mm-introduce-helper-function-mem_init_print_info-to-simplify-mem_init.patch
mm-kill-global-variable-num_physpages.patch
documentation-update-address_space_operations.patch
documentation-document-the-is_dirty_writeback-aops-callback.patch

