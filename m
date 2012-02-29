From: akpm@linux-foundation.org
Subject: + memcg-fix-deadlock-by-inverting-lrucare-nesting.patch added to -mm tree
Date: Wed, 29 Feb 2012 13:58:48 -0800
Message-ID: <20120229215848.D2980A0201@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:41670 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab2B2V6x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 Feb 2012 16:58:53 -0500
Received: by bkcjm19 with SMTP id jm19so34902bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 29 Feb 2012 13:58:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hughd@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, khlebnikov@openvz.org


The patch titled
     Subject: memcg: fix deadlock by inverting lrucare nesting
has been added to the -mm tree.  Its filename is
     memcg-fix-deadlock-by-inverting-lrucare-nesting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: memcg: fix deadlock by inverting lrucare nesting

We have forgotten the rules of lock nesting: the irq-safe ones must be
taken inside the non-irq-safe ones, otherwise we are open to deadlock:

CPU0                          CPU1
----                          ----
lock(&(&pc->lock)->rlock);
                              local_irq_disable();
                              lock(&(&zone->lru_lock)->rlock);
                              lock(&(&pc->lock)->rlock);
<Interrupt>
lock(&(&zone->lru_lock)->rlock);

To check a different locking issue, I happened to add a spin_lock to
memcg's bit_spin_lock in lock_page_cgroup(), and lockdep very quickly
complained about __mem_cgroup_commit_charge_lrucare() (on CPU1 above).

So delete __mem_cgroup_commit_charge_lrucare(), passing a bool lrucare to
__mem_cgroup_commit_charge() instead, taking zone->lru_lock under
lock_page_cgroup() in the lrucare case.

The original was using spin_lock_irqsave, but we'd be in more trouble if
it were ever called at interrupt time: unconditional _irq is enough.  And
ClearPageLRU before del from lru, SetPageLRU before add to lru: no strong
reason, but that is the ordering used consistently elsewhere.

Fixes 36b62ad539498d00c2d280a151a ("memcg: simplify corner case handling
of LRU").

Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   72 +++++++++++++++++++++++-----------------------
 1 file changed, 37 insertions(+), 35 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-deadlock-by-inverting-lrucare-nesting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-deadlock-by-inverting-lrucare-nesting
+++ a/mm/memcontrol.c
@@ -2408,8 +2408,12 @@ static void __mem_cgroup_commit_charge(s
 				       struct page *page,
 				       unsigned int nr_pages,
 				       struct page_cgroup *pc,
-				       enum charge_type ctype)
+				       enum charge_type ctype,
+				       bool lrucare)
 {
+	struct zone *uninitialized_var(zone);
+	bool was_on_lru = false;
+
 	lock_page_cgroup(pc);
 	if (unlikely(PageCgroupUsed(pc))) {
 		unlock_page_cgroup(pc);
@@ -2420,6 +2424,21 @@ static void __mem_cgroup_commit_charge(s
 	 * we don't need page_cgroup_lock about tail pages, becase they are not
 	 * accessed by any other context at this point.
 	 */
+
+	/*
+	 * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
+	 * may already be on some other mem_cgroup's LRU.  Take care of it.
+	 */
+	if (lrucare) {
+		zone = page_zone(page);
+		spin_lock_irq(&zone->lru_lock);
+		if (PageLRU(page)) {
+			ClearPageLRU(page);
+			del_page_from_lru_list(zone, page, page_lru(page));
+			was_on_lru = true;
+		}
+	}
+
 	pc->mem_cgroup = memcg;
 	/*
 	 * We access a page_cgroup asynchronously without lock_page_cgroup().
@@ -2443,9 +2462,18 @@ static void __mem_cgroup_commit_charge(s
 		break;
 	}
 
+	if (lrucare) {
+		if (was_on_lru) {
+			VM_BUG_ON(PageLRU(page));
+			SetPageLRU(page);
+			add_page_to_lru_list(zone, page, page_lru(page));
+		}
+		spin_unlock_irq(&zone->lru_lock);
+	}
+
 	mem_cgroup_charge_statistics(memcg, PageCgroupCache(pc), nr_pages);
 	unlock_page_cgroup(pc);
-	WARN_ON_ONCE(PageLRU(page));
+
 	/*
 	 * "charge_statistics" updated event counter. Then, check it.
 	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
@@ -2643,7 +2671,7 @@ static int mem_cgroup_charge_common(stru
 	ret = __mem_cgroup_try_charge(mm, gfp_mask, nr_pages, &memcg, oom);
 	if (ret == -ENOMEM)
 		return ret;
-	__mem_cgroup_commit_charge(memcg, page, nr_pages, pc, ctype);
+	__mem_cgroup_commit_charge(memcg, page, nr_pages, pc, ctype, false);
 	return 0;
 }
 
@@ -2663,35 +2691,6 @@ static void
 __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr,
 					enum charge_type ctype);
 
-static void
-__mem_cgroup_commit_charge_lrucare(struct page *page, struct mem_cgroup *memcg,
-					enum charge_type ctype)
-{
-	struct page_cgroup *pc = lookup_page_cgroup(page);
-	struct zone *zone = page_zone(page);
-	unsigned long flags;
-	bool removed = false;
-
-	/*
-	 * In some case, SwapCache, FUSE(splice_buf->radixtree), the page
-	 * is already on LRU. It means the page may on some other page_cgroup's
-	 * LRU. Take care of it.
-	 */
-	spin_lock_irqsave(&zone->lru_lock, flags);
-	if (PageLRU(page)) {
-		del_page_from_lru_list(zone, page, page_lru(page));
-		ClearPageLRU(page);
-		removed = true;
-	}
-	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype);
-	if (removed) {
-		add_page_to_lru_list(zone, page, page_lru(page));
-		SetPageLRU(page);
-	}
-	spin_unlock_irqrestore(&zone->lru_lock, flags);
-	return;
-}
-
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
@@ -2769,13 +2768,16 @@ static void
 __mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *memcg,
 					enum charge_type ctype)
 {
+	struct page_cgroup *pc;
+
 	if (mem_cgroup_disabled())
 		return;
 	if (!memcg)
 		return;
 	cgroup_exclude_rmdir(&memcg->css);
 
-	__mem_cgroup_commit_charge_lrucare(page, memcg, ctype);
+	pc = lookup_page_cgroup(page);
+	__mem_cgroup_commit_charge(memcg, page, 1, pc, ctype, true);
 	/*
 	 * Now swap is on-memory. This means this page may be
 	 * counted both as mem and swap....double count.
@@ -3248,7 +3250,7 @@ int mem_cgroup_prepare_migration(struct 
 		ctype = MEM_CGROUP_CHARGE_TYPE_CACHE;
 	else
 		ctype = MEM_CGROUP_CHARGE_TYPE_SHMEM;
-	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, ctype);
+	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, ctype, false);
 	return ret;
 }
 
@@ -3332,7 +3334,7 @@ void mem_cgroup_replace_page_cache(struc
 	 * the newpage may be on LRU(or pagevec for LRU) already. We lock
 	 * LRU while we overwrite pc->mem_cgroup.
 	 */
-	__mem_cgroup_commit_charge_lrucare(newpage, memcg, type);
+	__mem_cgroup_commit_charge(memcg, newpage, 1, pc, type, true);
 }
 
 #ifdef CONFIG_DEBUG_VM
_
Subject: Subject: memcg: fix deadlock by inverting lrucare nesting

Patches currently in -mm which might be from hughd@google.com are

linux-next.patch
memcg-fix-deadlock-by-inverting-lrucare-nesting.patch
mm-add-rss-counters-consistency-check.patch
mm-vmscan-fix-misused-nr_reclaimed-in-shrink_mem_cgroup_zone.patch
make-swapin-readahead-skip-over-holes.patch
make-swapin-readahead-skip-over-holes-fix.patch
compact_pgdat-workaround-lockdep-warning-in-kswapd.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix.patch
mm-vmscan-forcibly-scan-highmem-if-there-are-too-many-buffer_heads-pinning-highmem-fix-fix.patch
mm-hugetlb-defer-freeing-pages-when-gathering-surplus-pages.patch
rmap-anon_vma_prepare-reduce-code-duplication-by-calling-anon_vma_chain_link.patch
mm-vmscan-handle-isolated-pages-with-lru-lock-released.patch
mm-hugetlb-bail-out-unmapping-after-serving-reference-page.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
tmpfs-security-xattr-setting-on-inode-creation.patch
mm-fix-move-migrate_pages-race-on-task-struct.patch
memcg-replace-mem_cont-by-mem_res_ctlr.patch
memcg-replace-mem-and-mem_cont-stragglers.patch
memcg-lru_size-instead-of-mem_cgroup_zstat.patch
memcg-enum-lru_list-lru.patch
memcg-remove-redundant-returns.patch
idr-make-idr_get_next-good-for-rcu_read_lock.patch
cgroup-revert-ss_id_lock-to-spinlock.patch
memcg-let-css_get_next-rely-upon-rcu_read_lock.patch
memcg-remove-pcg_cache-page_cgroup-flag.patch
memcg-remove-pcg_cache-page_cgroup-flag-checkpatch-fixes.patch
prio_tree-debugging-patch.patch

