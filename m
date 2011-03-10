From: akpm@linux-foundation.org
Subject: + memcg-fix-leak-on-wrong-lru-with-fuse.patch added to -mm tree
Date: Wed, 09 Mar 2011 16:42:42 -0800
Message-ID: <201103100042.p2A0ggtC005557@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55943 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254Ab1CJAnI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Mar 2011 19:43:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, hannes@cmpxchg.org, miklos@szeredi.hu


The patch titled
     memcg: fix leak on wrong LRU with FUSE
has been added to the -mm tree.  Its filename is
     memcg-fix-leak-on-wrong-lru-with-fuse.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: fix leak on wrong LRU with FUSE
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

fs/fuse/dev.c::fuse_try_move_page() does

   (1) remove a page by ->steal()
   (2) re-add the page to page cache
   (3) link the page to LRU if it was not on LRU at (1)

This implies the page is _on_ LRU when it's added to radix-tree.  So, the
page is added to memory cgroup while it's on LRU.  because LRU is lazy and
no one flushs it.

This is the same behavior as SwapCache and needs special care as
 - remove page from LRU before overwrite pc->mem_cgroup.
 - add page to LRU after overwrite pc->mem_cgroup.

And we need to taking care of pagevec.

If PageLRU(page) is set before we add PCG_USED bit, the page will not be
added to memcg's LRU (in short period).  So, regardlress of PageLRU(page)
value before commit_charge(), we need to check PageLRU(page) after
commit_charge().

Changelog v2=>v3:
  - fixed double accounting.

Changelog v1=>v2:
  - clean up.
  - cover !PageLRU() by pagevec case.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   54 +++++++++++++++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-leak-on-wrong-lru-with-fuse mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-leak-on-wrong-lru-with-fuse
+++ a/mm/memcontrol.c
@@ -926,13 +926,12 @@ void mem_cgroup_add_lru_list(struct page
 }
 
 /*
- * At handling SwapCache, pc->mem_cgroup may be changed while it's linked to
- * lru because the page may.be reused after it's fully uncharged (because of
- * SwapCache behavior).To handle that, unlink page_cgroup from LRU when charge
- * it again. This function is only used to charge SwapCache. It's done under
- * lock_page and expected that zone->lru_lock is never held.
+ * At handling SwapCache and other FUSE stuff, pc->mem_cgroup may be changed
+ * while it's linked to lru because the page may be reused after it's fully
+ * uncharged. To handle that, unlink page_cgroup from LRU when charge it again.
+ * It's done under lock_page and expected that zone->lru_lock isnever held.
  */
-static void mem_cgroup_lru_del_before_commit_swapcache(struct page *page)
+static void mem_cgroup_lru_del_before_commit(struct page *page)
 {
 	unsigned long flags;
 	struct zone *zone = page_zone(page);
@@ -948,7 +947,7 @@ static void mem_cgroup_lru_del_before_co
 	spin_unlock_irqrestore(&zone->lru_lock, flags);
 }
 
-static void mem_cgroup_lru_add_after_commit_swapcache(struct page *page)
+static void mem_cgroup_lru_add_after_commit(struct page *page)
 {
 	unsigned long flags;
 	struct zone *zone = page_zone(page);
@@ -2431,9 +2430,28 @@ static void
 __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr,
 					enum charge_type ctype);
 
+static void
+__mem_cgroup_commit_charge_lrucare(struct page *page, struct mem_cgroup *mem,
+					enum charge_type ctype)
+{
+	struct page_cgroup *pc = lookup_page_cgroup(page);
+	/*
+	 * In some case, SwapCache, FUSE(splice_buf->radixtree), the page
+	 * is already on LRU. It means the page may on some other page_cgroup's
+	 * LRU. Take care of it.
+	 */
+	if (unlikely(PageLRU(page)))
+		mem_cgroup_lru_del_before_commit(page);
+	__mem_cgroup_commit_charge(mem, page, 1, pc, ctype);
+	if (unlikely(PageLRU(page)))
+		mem_cgroup_lru_add_after_commit(page);
+	return;
+}
+
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
+	struct mem_cgroup *mem = NULL;
 	int ret;
 
 	if (mem_cgroup_disabled())
@@ -2468,14 +2486,16 @@ int mem_cgroup_cache_charge(struct page 
 	if (unlikely(!mm))
 		mm = &init_mm;
 
-	if (page_is_file_cache(page))
-		return mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_CACHE);
-
+	if (page_is_file_cache(page)) {
+		ret = __mem_cgroup_try_charge(mm, gfp_mask, 1, &mem, true);
+		if (ret || !mem)
+			return ret;
+		__mem_cgroup_commit_charge_lrucare(page, mem,
+					MEM_CGROUP_CHARGE_TYPE_CACHE);
+		return ret;
+	}
 	/* shmem */
 	if (PageSwapCache(page)) {
-		struct mem_cgroup *mem;
-
 		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &mem);
 		if (!ret)
 			__mem_cgroup_commit_charge_swapin(page, mem,
@@ -2532,17 +2552,13 @@ static void
 __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr,
 					enum charge_type ctype)
 {
-	struct page_cgroup *pc;
-
 	if (mem_cgroup_disabled())
 		return;
 	if (!ptr)
 		return;
 	cgroup_exclude_rmdir(&ptr->css);
-	pc = lookup_page_cgroup(page);
-	mem_cgroup_lru_del_before_commit_swapcache(page);
-	__mem_cgroup_commit_charge(ptr, page, 1, pc, ctype);
-	mem_cgroup_lru_add_after_commit_swapcache(page);
+
+	__mem_cgroup_commit_charge_lrucare(page, ptr, ctype);
 	/*
 	 * Now swap is on-memory. This means this page may be
 	 * counted both as mem and swap....double count.
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

