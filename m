From: akpm@linux-foundation.org
Subject: [merged]
 mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch
 removed from -mm tree
Date: Tue, 12 Aug 2014 12:38:08 -0700
Message-ID: <53ea6d20.hulZsW7OHr65OCMA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yk0-f201.google.com ([209.85.160.201]:58546 "EHLO
	mail-yk0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaHLTiK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:38:10 -0400
Received: by mail-yk0-f201.google.com with SMTP id 142so1308815ykq.2
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:38:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: avoid charge statistics churn during page migration
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-avoid-charge-statistics-churn-during-page-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: memcontrol: avoid charge statistics churn during page migration

Charge migration currently disables IRQs twice to update the charge
statistics for the old page and then again for the new page.

But migration is a seamless transition of a charge from one physical page
to another one of the same size, so this should be a non-event from an
accounting point of view.  Leave the statistics alone.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
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
