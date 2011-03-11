From: akpm@linux-foundation.org
Subject: [folded] memcg-fix-leak-on-wrong-lru-with-fuse-update.patch removed from -mm tree
Date: Thu, 10 Mar 2011 16:00:29 -0800
Message-ID: <201103110000.p2B00TCg004321@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754086Ab1CKABY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Mar 2011 19:01:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hannes@cmpxchg.org, miklos@szeredi.hu, nishimura@mxp.nes.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg-fix-leak-on-wrong-lru-with-fuse-update
has been removed from the -mm tree.  Its filename was
     memcg-fix-leak-on-wrong-lru-with-fuse-update.patch

This patch was dropped because it was folded into memcg-fix-leak-on-wrong-lru-with-fuse.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg-fix-leak-on-wrong-lru-with-fuse-update
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Changelog v3=v4:
  - moved PageLRU() check into the leaf function.
  - added comments

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-leak-on-wrong-lru-with-fuse-update mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-leak-on-wrong-lru-with-fuse-update
+++ a/mm/memcontrol.c
@@ -937,6 +937,17 @@ static void mem_cgroup_lru_del_before_co
 	struct zone *zone = page_zone(page);
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 
+	/*
+	 * Doing this check without taking ->lru_lock seems wrong but this
+	 * is safe. Because if page_cgroup's USED bit is unset, the page
+	 * will not be added to any memcg's LRU. If page_cgroup's USED bit is
+	 * set, the commit after this will fail, anyway.
+	 * This all charge/uncharge is done under some mutual execustion.
+	 * So, we don't need to taking care of changes in USED bit.
+	 */
+	if (likely(!PageLRU(page)))
+		return;
+
 	spin_lock_irqsave(&zone->lru_lock, flags);
 	/*
 	 * Forget old LRU when this page_cgroup is *not* used. This Used bit
@@ -953,6 +964,9 @@ static void mem_cgroup_lru_add_after_com
 	struct zone *zone = page_zone(page);
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 
+	/* taking care of that the page is added to LRU while we commit it */
+	if (likely(!PageLRU(page)))
+		return;
 	spin_lock_irqsave(&zone->lru_lock, flags);
 	/* link when the page is linked to LRU but page_cgroup isn't */
 	if (PageLRU(page) && !PageCgroupAcctLRU(pc))
@@ -2440,11 +2454,9 @@ __mem_cgroup_commit_charge_lrucare(struc
 	 * is already on LRU. It means the page may on some other page_cgroup's
 	 * LRU. Take care of it.
 	 */
-	if (unlikely(PageLRU(page)))
-		mem_cgroup_lru_del_before_commit(page);
+	mem_cgroup_lru_del_before_commit(page);
 	__mem_cgroup_commit_charge(mem, page, 1, pc, ctype);
-	if (unlikely(PageLRU(page)))
-		mem_cgroup_lru_add_after_commit(page);
+	mem_cgroup_lru_add_after_commit(page);
 	return;
 }
 
@@ -2490,6 +2502,12 @@ int mem_cgroup_cache_charge(struct page 
 		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &mem, true);
 		if (ret || !mem)
 			return ret;
+
+		/*
+		 * FUSE reuses pages without going through the final
+		 * put that would remove them from the LRU list, make
+		 * sure that they get relinked properly.
+		 */
 		__mem_cgroup_commit_charge_lrucare(page, mem,
 					MEM_CGROUP_CHARGE_TYPE_CACHE);
 		return ret;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-oom-kill.patch
oom-suppress-show_mem-for-many-nodes-in-irq-context-on-page-alloc-failure.patch
oom-suppress-nodes-that-are-not-allowed-from-meminfo-on-page-alloc-failure.patch
mm-add-replace_page_cache_page-function.patch
mm-add-replace_page_cache_page-function-add-freepage-hook.patch
mm-introduce-delete_from_page_cache.patch
mm-hugetlbfs-change-remove_from_page_cache.patch
mm-shmem-change-remove_from_page_cache.patch
mm-truncate-change-remove_from_page_cache.patch
mm-good-bye-remove_from_page_cache.patch
mm-change-__remove_from_page_cache.patch
mm-rename-drop_anon_vma-to-put_anon_vma.patch
mm-move-anon_vma-ref-out-from-under-config_foo.patch
mm-simplify-anon_vma-refcounts.patch
memcg-move-memcg-reclaimable-page-into-tail-of-inactive-list.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration.patch
mm-compaction-minimise-the-time-irqs-are-disabled-while-isolating-pages-for-migration-fix.patch
mm-add-__gfp_other_node-flag.patch
mm-use-__gfp_other_node-for-transparent-huge-pages.patch
mm-add-vm-counters-for-transparent-hugepages.patch
oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch
sys_swapon-use-vzalloc-instead-of-vmalloc-memset.patch
sys_swapon-remove-changelog-from-function-comment.patch
sys_swapon-separate-swap_info-allocation.patch
sys_swapon-simplify-error-return-from-swap_info-allocation.patch
sys_swapon-simplify-error-flow-in-alloc_swap_info.patch
sys_swapon-remove-initial-value-of-name-variable.patch
sys_swapon-move-setting-of-error-nearer-use.patch
sys_swapon-remove-did_down-variable.patch
sys_swapon-remove-bdev-variable.patch
sys_swapon-do-only-cleanup-in-the-cleanup-blocks.patch
sys_swapon-use-a-single-error-label.patch
sys_swapon-separate-bdev-claim-and-inode-lock.patch
sys_swapon-simplify-error-flow-in-claim_swapfile.patch
sys_swapon-move-setting-of-swapfilepages-near-use.patch
sys_swapon-separate-parsing-of-swapfile-header.patch
sys_swapon-simplify-error-flow-in-read_swap_header.patch
sys_swapon-call-swap_cgroup_swapon-earlier.patch
sys_swapon-separate-parsing-of-bad-blocks-and-extents.patch
sys_swapon-simplify-error-flow-in-setup_swap_map_and_extents.patch
sys_swapon-remove-nr_good_pages-variable.patch
sys_swapon-move-printk-outside-lock.patch
sys_swapoff-change-order-to-match-sys_swapon.patch
sys_swapon-separate-final-enabling-of-the-swapfile.patch
mm-remove-inline-from-scan_swap_map.patch
vmalloc-remove-confusing-comment-on-vwrite.patch
memcg-res_counter_read_u64-fix-potential-races-on-32-bit-machines.patch
memcg-fix-ugly-initialization-of-return-value-is-in-caller.patch
memcg-soft-limit-reclaim-should-end-at-limit-not-below.patch
memcg-simplify-the-way-memory-limits-are-checked.patch
memcg-remove-unused-page-flag-bitfield-defines.patch
memcg-remove-impossible-conditional-when-committing.patch
memcg-remove-null-check-from-lookup_page_cgroup-result.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update.patch
memcg-add-memcg-sanity-checks-at-allocating-and-freeing-pages-update-fix.patch
memcg-no-uncharged-pages-reach-page_cgroup_zoneinfo.patch
memcg-change-page_cgroup_zoneinfo-signature.patch
memcg-fold-__mem_cgroup_move_account-into-caller.patch
memcg-condense-page_cgroup-to-page-lookup-points.patch
memcg-remove-direct-page_cgroup-to-page-pointer.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch
memcg-charged-pages-always-have-valid-per-memcg-zone-info.patch
memcg-remove-memcg-reclaim_param_lock.patch
memcg-keep-only-one-charge-cancelling-function.patch
memcg-keep-only-one-charge-cancelling-function-fix.patch
memcg-convert-per-cpu-stock-from-bytes-to-page-granularity.patch
memcg-convert-uncharge-batching-from-bytes-to-page-granularity.patch
memcg-unify-charge-uncharge-quantities-to-units-of-pages.patch
memcg-break-out-event-counters-from-other-stats.patch
memcg-use-native-word-page-statistics-counters.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp.patch
memcg-use-native-word-page-statistics-counters-fix-event-counter-breakage-with-thp-checkpatch-fixes.patch
mm-memcontrolc-suppress-uninitializer-var-warning-with-older-gccs.patch
page_cgroup-reduce-allocation-overhead-for-page_cgroup-array-for-config_sparsemem.patch
memcg-page_cgroup-array-is-never-stored-on-reserved-pages.patch
memcg-fix-leak-on-wrong-lru-with-fuse.patch

