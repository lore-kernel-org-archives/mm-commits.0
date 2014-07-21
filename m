From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch added to
 -mm tree
Date: Mon, 21 Jul 2014 13:42:06 -0700
Message-ID: <53cd7b1e.XY3nC5Z5nqAt+lDR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pd0-f201.google.com ([209.85.192.201]:43183 "EHLO
	mail-pd0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbaGUUmH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 16:42:07 -0400
Received: by mail-pd0-f201.google.com with SMTP id g10so1698586pdj.0
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 13:42:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, mhocko@suse.cz, miklos@szeredi.hu, mm-commits@vger.kernel.org


The patch titled
     Date: Fri, 18 Jul 2014 09:48:42 -0400
has been added to the -mm tree.  Its filename is
     mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Fri, 18 Jul 2014 09:48:42 -0400
Subject: mm: memcontrol: rewrite uncharge API fix - page cache migration

It was known that the target page in migration could be on the LRU -
clarify this in mem_cgroup_migrate() and correct the VM_BUG_ON_PAGE().

However, during page cache replacement, the source page can also be on
the LRU, and two things need to be considered:

1.  charge moving can race and change pc->mem_cgroup from under us: grab
the page lock in mem_cgroup_move_account() to prevent that.

2.  the lruvec of the page changes as we uncharge it, and putback can race
with us: grab the lru lock and isolate the page iff on LRU to prevent
races and to ensure the page is on the right lruvec afterward.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Michal Hocko <mhocko@suse.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   83 +++++++++++++++++++++++++++++++---------------
 1 file changed, 57 insertions(+), 26 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration
+++ a/mm/memcontrol.c
@@ -2696,13 +2696,42 @@ struct mem_cgroup *try_get_mem_cgroup_fr
 	return memcg;
 }
 
+static void lock_page_lru(struct page *page, int *isolated)
+{
+	struct zone *zone = page_zone(page);
+
+	spin_lock_irq(&zone->lru_lock);
+	if (PageLRU(page)) {
+		struct lruvec *lruvec;
+
+		lruvec = mem_cgroup_page_lruvec(page, zone);
+		ClearPageLRU(page);
+		del_page_from_lru_list(page, lruvec, page_lru(page));
+		*isolated = 1;
+	} else
+		*isolated = 0;
+}
+
+static void unlock_page_lru(struct page *page, int isolated)
+{
+	struct zone *zone = page_zone(page);
+
+	if (isolated) {
+		struct lruvec *lruvec;
+
+		lruvec = mem_cgroup_page_lruvec(page, zone);
+		VM_BUG_ON_PAGE(PageLRU(page), page);
+		SetPageLRU(page);
+		add_page_to_lru_list(page, lruvec, page_lru(page));
+	}
+	spin_unlock_irq(&zone->lru_lock);
+}
+
 static void commit_charge(struct page *page, struct mem_cgroup *memcg,
 			  unsigned int nr_pages, bool lrucare)
 {
 	struct page_cgroup *pc = lookup_page_cgroup(page);
-	struct zone *uninitialized_var(zone);
-	bool was_on_lru = false;
-	struct lruvec *lruvec;
+	int isolated;
 
 	VM_BUG_ON_PAGE(PageCgroupUsed(pc), page);
 	/*
@@ -2714,16 +2743,8 @@ static void commit_charge(struct page *p
 	 * In some cases, SwapCache and FUSE(splice_buf->radixtree), the page
 	 * may already be on some other mem_cgroup's LRU.  Take care of it.
 	 */
-	if (lrucare) {
-		zone = page_zone(page);
-		spin_lock_irq(&zone->lru_lock);
-		if (PageLRU(page)) {
-			lruvec = mem_cgroup_zone_lruvec(zone, pc->mem_cgroup);
-			ClearPageLRU(page);
-			del_page_from_lru_list(page, lruvec, page_lru(page));
-			was_on_lru = true;
-		}
-	}
+	if (lrucare)
+		lock_page_lru(page, &isolated);
 
 	/*
 	 * Nobody should be changing or seriously looking at
@@ -2742,15 +2763,8 @@ static void commit_charge(struct page *p
 	pc->mem_cgroup = memcg;
 	pc->flags = PCG_USED | PCG_MEM | (do_swap_account ? PCG_MEMSW : 0);
 
-	if (lrucare) {
-		if (was_on_lru) {
-			lruvec = mem_cgroup_zone_lruvec(zone, pc->mem_cgroup);
-			VM_BUG_ON_PAGE(PageLRU(page), page);
-			SetPageLRU(page);
-			add_page_to_lru_list(page, lruvec, page_lru(page));
-		}
-		spin_unlock_irq(&zone->lru_lock);
-	}
+	if (lrucare)
+		unlock_page_lru(page, isolated);
 
 	local_irq_disable();
 	mem_cgroup_charge_statistics(memcg, page, nr_pages);
@@ -3450,9 +3464,17 @@ static int mem_cgroup_move_account(struc
 	if (nr_pages > 1 && !PageTransHuge(page))
 		goto out;
 
+	/*
+	 * Prevent mem_cgroup_migrate() from looking at pc->mem_cgroup
+	 * of its source page while we change it: page migration takes
+	 * both pages off the LRU, but page cache replacement doesn't.
+	 */
+	if (!trylock_page(page))
+		goto out;
+
 	ret = -EINVAL;
 	if (!PageCgroupUsed(pc) || pc->mem_cgroup != from)
-		goto out;
+		goto out_unlock;
 
 	move_lock_mem_cgroup(from, &flags);
 
@@ -3487,6 +3509,8 @@ static int mem_cgroup_move_account(struc
 	mem_cgroup_charge_statistics(from, page, -nr_pages);
 	memcg_check_events(from, page);
 	local_irq_enable();
+out_unlock:
+	unlock_page(page);
 out:
 	return ret;
 }
@@ -6577,7 +6601,7 @@ out:
  * mem_cgroup_migrate - migrate a charge to another page
  * @oldpage: currently charged page
  * @newpage: page to transfer the charge to
- * @lrucare: page might be on LRU already
+ * @lrucare: both pages might be on the LRU already
  *
  * Migrate the charge from @oldpage to @newpage.
  *
@@ -6588,11 +6612,12 @@ void mem_cgroup_migrate(struct page *old
 {
 	unsigned int nr_pages = 1;
 	struct page_cgroup *pc;
+	int isolated;
 
 	VM_BUG_ON_PAGE(!PageLocked(oldpage), oldpage);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
-	VM_BUG_ON_PAGE(PageLRU(oldpage), oldpage);
-	VM_BUG_ON_PAGE(PageLRU(newpage), newpage);
+	VM_BUG_ON_PAGE(!lrucare && PageLRU(oldpage), oldpage);
+	VM_BUG_ON_PAGE(!lrucare && PageLRU(newpage), newpage);
 	VM_BUG_ON_PAGE(PageAnon(oldpage) != PageAnon(newpage), newpage);
 
 	if (mem_cgroup_disabled())
@@ -6611,8 +6636,14 @@ void mem_cgroup_migrate(struct page *old
 		VM_BUG_ON_PAGE(!PageTransHuge(newpage), newpage);
 	}
 
+	if (lrucare)
+		lock_page_lru(oldpage, &isolated);
+
 	pc->flags = 0;
 
+	if (lrucare)
+		unlock_page_lru(oldpage, isolated);
+
 	local_irq_disable();
 	mem_cgroup_charge_statistics(pc->mem_cgroup, oldpage, -nr_pages);
 	memcg_check_events(pc->mem_cgroup, oldpage);
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

shmem-fix-faulting-into-a-hole-not-taking-i_mutex.patch
shmem-fix-splicing-from-a-hole-while-its-punched.patch
mm-page-writebackc-fix-divide-by-zero-in-bdi_dirty_limits.patch
vmalloc-use-rcu-list-iterator-to-reduce-vmap_area_lock-contention.patch
mm-page-flags-clean-up-the-page-flag-test-set-clear-macros.patch
mm-memcontrol-fold-mem_cgroup_do_charge.patch
mm-memcontrol-rearrange-charging-fast-path.patch
mm-memcontrol-reclaim-at-least-once-for-__gfp_noretry.patch
mm-huge_memory-use-gfp_transhuge-when-charging-huge-pages.patch
mm-memcontrol-retry-reclaim-for-oom-disabled-and-__gfp_nofail-charges.patch
mm-memcontrol-remove-explicit-oom-parameter-in-charge-path.patch
mm-memcontrol-simplify-move-precharge-function.patch
mm-memcontrol-catch-root-bypass-in-move-precharge.patch
mm-memcontrol-use-root_mem_cgroup-res_counter.patch
mm-memcontrol-remove-ordering-between-pc-mem_cgroup-and-pagecgroupused.patch
mm-memcontrol-do-not-acquire-page_cgroup-lock-for-kmem-pages.patch
mm-memcontrol-rewrite-charge-api.patch
mm-memcontrol-rewrite-charge-api-fix-3.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch
mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch
mm-memcontrol-use-page-lists-for-uncharge-batching.patch
mm-memcontrol-use-page-lists-for-uncharge-batching-fix-hugetlb-page-lru.patch
page-cgroup-trivial-cleanup.patch
page-cgroup-get-rid-of-nr_pcg_flags.patch
memcg-remove-lookup_cgroup_page-prototype.patch
mm-vmscan-remove-remains-of-kswapd-managed-zone-all_unreclaimable.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim.patch
mm-vmscan-rework-compaction-ready-signaling-in-direct-reclaim-fix.patch
mm-vmscan-remove-all_unreclaimable.patch
mm-vmscan-remove-all_unreclaimable-fix.patch
mm-vmscan-move-swappiness-out-of-scan_control.patch
mm-vmscan-clean-up-struct-scan_control-v2.patch
mm-export-nr_shmem-via-sysinfo2-si_meminfo-interfaces.patch
mm-replace-init_page_accessed-by-__setpagereferenced.patch
mm-update-the-description-for-vm_total_pages.patch
mm-vmscan-report-the-number-of-file-anon-pages-respectively.patch
mm-pagemap-avoid-unnecessary-overhead-when-tracepoints-are-deactivated.patch
mm-rearrange-zone-fields-into-read-only-page-alloc-statistics-and-page-reclaim-lines.patch
mm-move-zone-pages_scanned-into-a-vmstat-counter.patch
mm-vmscan-only-update-per-cpu-thresholds-for-online-cpu.patch
mm-page_alloc-abort-fair-zone-allocation-policy-when-remotes-nodes-are-encountered.patch
mm-page_alloc-reduce-cost-of-the-fair-zone-allocation-policy.patch
mm-writeback-prevent-race-when-calculating-dirty-limits.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

