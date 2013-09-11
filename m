From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-page_alloc-fair-zone-allocator-policy-v2-fix-2.patch removed from -mm
 tree
Date: Wed, 11 Sep 2013 13:54:21 -0700
Message-ID: <5230d87d.PxZqkhz+CxOw1vWZ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49008 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab3IKUyX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Sep 2013 16:54:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, khilman@linaro.org, hannes@cmpxchg.org

Subject: [folded-merged] mm-page_alloc-fair-zone-allocator-policy-v2-fix-2.patch removed from -mm tree
To: hannes@cmpxchg.org,khilman@linaro.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 11 Sep 2013 13:54:21 -0700


The patch titled
     Subject: mm: page_alloc: use vmstats for fair zone allocation batching fix
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fair-zone-allocator-policy-v2-fix-2.patch

This patch was dropped because it was folded into mm-page_alloc-fair-zone-allocator-policy.patch

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_alloc: use vmstats for fair zone allocation batching fix

Initialize the per-cpu counters before modifying them.  Otherwise:

[    0.000000] Booting Linux on physical CPU 0x0
[    0.000000] Linux version 3.11.0-rc5-next-20130816 (khilman@paris) (gcc version 4.7.2 (Ubuntu/Linaro 4.7.2-1ubuntu1) ) #30 SMP Fri Aug 16 09:47:32 PDT 2013
[    0.000000] CPU: ARMv7 Processor [413fc082] revision 2 (ARMv7), cr=10c53c7d
[    0.000000] CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
[    0.000000] Machine: Generic AM33XX (Flattened Device Tree), model: TI AM335x BeagleBone
[    0.000000] bootconsole [earlycon0] enabled
[    0.000000] Memory policy: ECC disabled, Data cache writeback
[    0.000000] On node 0 totalpages: 130816
[    0.000000] free_area_init_node: node 0, pgdat c081d400, node_mem_map c12fc000
[    0.000000]   Normal zone: 1024 pages used for memmap
[    0.000000]   Normal zone: 0 pages reserved
[    0.000000] Unable to handle kernel NULL pointer dereference at virtual address 00000026
[    0.000000] pgd = c0004000
[    0.000000] [00000026] *pgd=00000000
[    0.000000] Internal error: Oops: 5 [#1] SMP ARM
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 3.11.0-rc5-next-20130816 #30
[    0.000000] task: c0793c70 ti: c0788000 task.ti: c0788000
[    0.000000] PC is at __mod_zone_page_state+0x2c/0xb4
[    0.000000] LR is at mod_zone_page_state+0x2c/0x4c

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Kevin Hilman <khilman@linaro.org>
Tested-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fair-zone-allocator-policy-v2-fix-2 mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fair-zone-allocator-policy-v2-fix-2
+++ a/mm/page_alloc.c
@@ -4797,11 +4797,11 @@ static void __paginginit free_area_init_
 		spin_lock_init(&zone->lru_lock);
 		zone_seqlock_init(zone);
 		zone->zone_pgdat = pgdat;
+		zone_pcp_init(zone);
 
 		/* For bootup, initialized properly in watermark setup */
 		mod_zone_page_state(zone, NR_ALLOC_BATCH, zone->managed_pages);
 
-		zone_pcp_init(zone);
 		lruvec_init(&zone->lruvec);
 		if (!size)
 			continue;
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-kill-one-if-loop-in-__free_pages_bootmem.patch
mm-vmscan-fix-numa-reclaim-balance-problem-in-kswapd.patch
mm-page_alloc-rearrange-watermark-checking-in-get_page_from_freelist.patch
mm-page_alloc-fair-zone-allocator-policy.patch
mm-revert-page-writebackc-subtract-min_free_kbytes-from-dirtyable-memory.patch
mm-page_alloc-add-unlikely-macro-to-help-compiler-optimization.patch
mm-move-pgtable-related-functions-to-right-place.patch
swap-clean-up-ifdef-in-page_mapping.patch
mm-vmalloc-remove-useless-variable-in-vmap_block.patch
mm-vmalloc-use-well-defined-find_last_bit-func.patch
kmemcg-dont-allocate-extra-memory-for-root-memcg_cache_params-v2.patch
mm-fix-aio-performance-regression-for-database-caused-by-thp.patch
mm-putback_lru_page-remove-unnecessary-call-to-page_lru_base_type.patch
mm-munlock-remove-unnecessary-call-to-lru_add_drain.patch
mm-munlock-batch-non-thp-page-isolation-and-munlockputback-using-pagevec.patch
mm-munlock-batch-nr_mlock-zone-state-updates.patch
mm-munlock-bypass-per-cpu-pvec-for-putback_lru_page.patch
mm-munlock-remove-redundant-get_page-put_page-pair-on-the-fast-path.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask.patch
mm-munlock-manual-pte-walk-in-fast-path-instead-of-follow_page_mask-v3.patch
mm-vmscan-fix-do_try_to_free_pages-livelock.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix.patch
mm-vmscan-fix-do_try_to_free_pages-livelock-fix-2.patch
mm-sparse-introduce-alloc_usemap_and_memmap.patch
mm-writeback-make-writeback_inodes_wb-static.patch
mm-vmalloc-use-wrapper-function-get_vm_area_size-to-caculate-size-of-vm-area.patch
memcg-fix-multiple-large-threshold-notifications.patch

