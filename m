From: akpm@linux-foundation.org
Subject: +
 mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
 added to -mm tree
Date: Mon, 04 Aug 2014 13:39:22 -0700
Message-ID: <53dfef7a.k5ZZJCXvKraSjm8r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:34767 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbaHDUjX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2014 16:39:23 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so944934yhl.1
        for <mm-commits@vger.kernel.org>; Mon, 04 Aug 2014 13:39:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: avoid charge statistics churn during page migration
has been added to the -mm tree.  Its filename is
     mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch

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
Subject: mm: memcontrol: avoid charge statistics churn during page migration

Charge migration currently disables IRQs twice to update the charge
statistics for the old page and then again for the new page.

But migration is a seamless transition of a charge from one physical page
to another one of the same size, so this should be a non-event from an
accounting point of view.  Leave the statistics alone.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   35 ++++++++++-------------------------
 1 file changed, 10 insertions(+), 25 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrol-avoid-charge-statistics-churn-during-page-migration mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrol-avoid-charge-statistics-churn-during-page-migration
+++ a/mm/memcontrol.c
@@ -2728,7 +2728,7 @@ static void unlock_page_lru(struct page
 }
 
 static void commit_charge(struct page *page, struct mem_cgroup *memcg,
-			  unsigned int nr_pages, bool lrucare)
+			  bool lrucare)
 {
 	struct page_cgroup *pc = lookup_page_cgroup(page);
 	int isolated;
@@ -2765,16 +2765,6 @@ static void commit_charge(struct page *p
 
 	if (lrucare)
 		unlock_page_lru(page, isolated);
-
-	local_irq_disable();
-	mem_cgroup_charge_statistics(memcg, page, nr_pages);
-	/*
-	 * "charge_statistics" updated event counter. Then, check it.
-	 * Insert ancestor (and ancestor's ancestors), to softlimit RB-tree.
-	 * if they exceeds softlimit.
-	 */
-	memcg_check_events(memcg, page);
-	local_irq_enable();
 }
 
 static DEFINE_MUTEX(set_limit_mutex);
@@ -6460,12 +6450,17 @@ void mem_cgroup_commit_charge(struct pag
 	if (!memcg)
 		return;
 
+	commit_charge(page, memcg, lrucare);
+
 	if (PageTransHuge(page)) {
 		nr_pages <<= compound_order(page);
 		VM_BUG_ON_PAGE(!PageTransHuge(page), page);
 	}
 
-	commit_charge(page, memcg, nr_pages, lrucare);
+	local_irq_disable();
+	mem_cgroup_charge_statistics(memcg, page, nr_pages);
+	memcg_check_events(memcg, page);
+	local_irq_enable();
 
 	if (do_swap_account && PageSwapCache(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
@@ -6651,7 +6646,6 @@ void mem_cgroup_uncharge_list(struct lis
 void mem_cgroup_migrate(struct page *oldpage, struct page *newpage,
 			bool lrucare)
 {
-	unsigned int nr_pages = 1;
 	struct page_cgroup *pc;
 	int isolated;
 
@@ -6660,6 +6654,8 @@ void mem_cgroup_migrate(struct page *old
 	VM_BUG_ON_PAGE(!lrucare && PageLRU(oldpage), oldpage);
 	VM_BUG_ON_PAGE(!lrucare && PageLRU(newpage), newpage);
 	VM_BUG_ON_PAGE(PageAnon(oldpage) != PageAnon(newpage), newpage);
+	VM_BUG_ON_PAGE(PageTransHuge(oldpage) != PageTransHuge(newpage),
+		       newpage);
 
 	if (mem_cgroup_disabled())
 		return;
@@ -6677,12 +6673,6 @@ void mem_cgroup_migrate(struct page *old
 	VM_BUG_ON_PAGE(!(pc->flags & PCG_MEM), oldpage);
 	VM_BUG_ON_PAGE(do_swap_account && !(pc->flags & PCG_MEMSW), oldpage);
 
-	if (PageTransHuge(oldpage)) {
-		nr_pages <<= compound_order(oldpage);
-		VM_BUG_ON_PAGE(!PageTransHuge(oldpage), oldpage);
-		VM_BUG_ON_PAGE(!PageTransHuge(newpage), newpage);
-	}
-
 	if (lrucare)
 		lock_page_lru(oldpage, &isolated);
 
@@ -6691,12 +6681,7 @@ void mem_cgroup_migrate(struct page *old
 	if (lrucare)
 		unlock_page_lru(oldpage, isolated);
 
-	local_irq_disable();
-	mem_cgroup_charge_statistics(pc->mem_cgroup, oldpage, -nr_pages);
-	memcg_check_events(pc->mem_cgroup, oldpage);
-	local_irq_enable();
-
-	commit_charge(newpage, pc->mem_cgroup, nr_pages, lrucare);
+	commit_charge(newpage, pc->mem_cgroup, lrucare);
 }
 
 /*
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
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
mm-memcontrol-rewrite-charge-api-fix-shmem_unuse.patch
mm-memcontrol-rewrite-charge-api-fix-hugetlb-charging.patch
mm-memcontrol-rewrite-uncharge-api.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-4.patch
mm-memcontrol-rewrite-uncharge-api-fix-5.patch
mm-memcontrol-rewrite-uncharge-api-fix-uncharge-from-irq-context.patch
mm-memcontrol-rewrite-uncharge-api-fix-double-migration-v2.patch
mm-memcontrol-rewrite-uncharge-api-fix-migrate-before-re-mapping.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration.patch
mm-memcontrol-rewrite-uncharge-api-fix-page-cache-migration-2.patch
mm-memcontrol-rewrite-uncharge-api-fix-clear-page-mapping-in-migration.patch
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
slub-remove-kmemcg-id-from-create_unique_id.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
mm-oom-remove-unnecessary-check-for-null-zonelist.patch
mm-oom-rename-zonelist-locking-functions.patch
mm-thp-restructure-thp-avoidance-of-light-synchronous-migration.patch
mm-vmscan-fix-an-outdated-comment-still-mentioning-get_scan_ratio.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages.patch
memcg-vmscan-fix-forced-scan-of-anonymous-pages-fix-cleanups.patch
mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch

