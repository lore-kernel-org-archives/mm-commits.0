From: akpm@linux-foundation.org
Subject: [merged] mm-numa-cleanup-flow-of-transhuge-page-migration.patch removed from -mm tree
Date: Mon, 25 Feb 2013 12:52:49 -0800
Message-ID: <20130225205249.D352F5A426D@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:60347 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759002Ab3BYUwv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Feb 2013 15:52:51 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so348219yhz.1
        for <mm-commits@vger.kernel.org>; Mon, 25 Feb 2013 12:52:50 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, a.p.zijlstra@chello.nl, aarcange@redhat.com, liwanp@linux.vnet.ibm.com, mgorman@suse.de, mingo@kernel.org, simon.jeons@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: numa: cleanup flow of transhuge page migration
has been removed from the -mm tree.  Its filename was
     mm-numa-cleanup-flow-of-transhuge-page-migration.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: numa: cleanup flow of transhuge page migration

When correcting commit 04fa5d6a ("mm: migrate: check page_count of THP
before migrating") Hugh Dickins noted that the control flow for transhuge
migration was difficult to follow.  Unconditionally calling put_page() in
numamigrate_isolate_page() made the failure paths of both
migrate_misplaced_transhuge_page() and migrate_misplaced_page() more
complex that they should be.  Further, he was extremely wary that an
unlock_page() should ever happen after a put_page() even if the put_page()
should never be the final put_page.

Hugh implemented the following cleanup to simplify the path by calling
putback_lru_page() inside numamigrate_isolate_page() if it failed to
isolate and always calling unlock_page() within
migrate_misplaced_transhuge_page().  There is no functional change after
this patch is applied but the code is easier to follow and unlock_page()
always happens before put_page().

[mgorman@suse.de: changelog only]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Simon Jeons <simon.jeons@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   28 ++++--------
 mm/migrate.c     |   97 ++++++++++++++++++++-------------------------
 2 files changed, 53 insertions(+), 72 deletions(-)

diff -puN mm/huge_memory.c~mm-numa-cleanup-flow-of-transhuge-page-migration mm/huge_memory.c
--- a/mm/huge_memory.c~mm-numa-cleanup-flow-of-transhuge-page-migration
+++ a/mm/huge_memory.c
@@ -1296,7 +1296,6 @@ int do_huge_pmd_numa_page(struct mm_stru
 	int target_nid;
 	int current_nid = -1;
 	bool migrated;
-	bool page_locked = false;
 
 	spin_lock(&mm->page_table_lock);
 	if (unlikely(!pmd_same(pmd, *pmdp)))
@@ -1318,7 +1317,6 @@ int do_huge_pmd_numa_page(struct mm_stru
 	/* Acquire the page lock to serialise THP migrations */
 	spin_unlock(&mm->page_table_lock);
 	lock_page(page);
-	page_locked = true;
 
 	/* Confirm the PTE did not while locked */
 	spin_lock(&mm->page_table_lock);
@@ -1331,34 +1329,26 @@ int do_huge_pmd_numa_page(struct mm_stru
 
 	/* Migrate the THP to the requested node */
 	migrated = migrate_misplaced_transhuge_page(mm, vma,
-				pmdp, pmd, addr,
-				page, target_nid);
-	if (migrated)
-		current_nid = target_nid;
-	else {
-		spin_lock(&mm->page_table_lock);
-		if (unlikely(!pmd_same(pmd, *pmdp))) {
-			unlock_page(page);
-			goto out_unlock;
-		}
-		goto clear_pmdnuma;
-	}
+				pmdp, pmd, addr, page, target_nid);
+	if (!migrated)
+		goto check_same;
 
-	task_numa_fault(current_nid, HPAGE_PMD_NR, migrated);
+	task_numa_fault(target_nid, HPAGE_PMD_NR, true);
 	return 0;
 
+check_same:
+	spin_lock(&mm->page_table_lock);
+	if (unlikely(!pmd_same(pmd, *pmdp)))
+		goto out_unlock;
 clear_pmdnuma:
 	pmd = pmd_mknonnuma(pmd);
 	set_pmd_at(mm, haddr, pmdp, pmd);
 	VM_BUG_ON(pmd_numa(*pmdp));
 	update_mmu_cache_pmd(vma, addr, pmdp);
-	if (page_locked)
-		unlock_page(page);
-
 out_unlock:
 	spin_unlock(&mm->page_table_lock);
 	if (current_nid != -1)
-		task_numa_fault(current_nid, HPAGE_PMD_NR, migrated);
+		task_numa_fault(current_nid, HPAGE_PMD_NR, false);
 	return 0;
 }
 
diff -puN mm/migrate.c~mm-numa-cleanup-flow-of-transhuge-page-migration mm/migrate.c
--- a/mm/migrate.c~mm-numa-cleanup-flow-of-transhuge-page-migration
+++ a/mm/migrate.c
@@ -1557,41 +1557,40 @@ bool numamigrate_update_ratelimit(pg_dat
 
 int numamigrate_isolate_page(pg_data_t *pgdat, struct page *page)
 {
-	int ret = 0;
+	int page_lru;
 
 	VM_BUG_ON(compound_order(page) && !PageTransHuge(page));
 
 	/* Avoid migrating to a node that is nearly full */
-	if (migrate_balanced_pgdat(pgdat, 1UL << compound_order(page))) {
-		int page_lru;
+	if (!migrate_balanced_pgdat(pgdat, 1UL << compound_order(page)))
+		return 0;
 
-		if (isolate_lru_page(page)) {
-			put_page(page);
-			return 0;
-		}
-
-		/* Page is isolated */
-		ret = 1;
-		page_lru = page_is_file_cache(page);
-		if (!PageTransHuge(page))
-			inc_zone_page_state(page, NR_ISOLATED_ANON + page_lru);
-		else
-			mod_zone_page_state(page_zone(page),
-					NR_ISOLATED_ANON + page_lru,
-					HPAGE_PMD_NR);
+	if (isolate_lru_page(page))
+		return 0;
+
+	/*
+	 * migrate_misplaced_transhuge_page() skips page migration's usual
+	 * check on page_count(), so we must do it here, now that the page
+	 * has been isolated: a GUP pin, or any other pin, prevents migration.
+	 * The expected page count is 3: 1 for page's mapcount and 1 for the
+	 * caller's pin and 1 for the reference taken by isolate_lru_page().
+	 */
+	if (PageTransHuge(page) && page_count(page) != 3) {
+		putback_lru_page(page);
+		return 0;
 	}
 
+	page_lru = page_is_file_cache(page);
+	mod_zone_page_state(page_zone(page), NR_ISOLATED_ANON + page_lru,
+				hpage_nr_pages(page));
+
 	/*
-	 * Page is either isolated or there is not enough space on the target
-	 * node. If isolated, then it has taken a reference count and the
-	 * callers reference can be safely dropped without the page
-	 * disappearing underneath us during migration. Otherwise the page is
-	 * not to be migrated but the callers reference should still be
-	 * dropped so it does not leak.
+	 * Isolating the page has taken another reference, so the
+	 * caller's reference can be safely dropped without the page
+	 * disappearing underneath us during migration.
 	 */
 	put_page(page);
-
-	return ret;
+	return 1;
 }
 
 /*
@@ -1602,7 +1601,7 @@ int numamigrate_isolate_page(pg_data_t *
 int migrate_misplaced_page(struct page *page, int node)
 {
 	pg_data_t *pgdat = NODE_DATA(node);
-	int isolated = 0;
+	int isolated;
 	int nr_remaining;
 	LIST_HEAD(migratepages);
 
@@ -1610,20 +1609,16 @@ int migrate_misplaced_page(struct page *
 	 * Don't migrate pages that are mapped in multiple processes.
 	 * TODO: Handle false sharing detection instead of this hammer
 	 */
-	if (page_mapcount(page) != 1) {
-		put_page(page);
+	if (page_mapcount(page) != 1)
 		goto out;
-	}
 
 	/*
 	 * Rate-limit the amount of data that is being migrated to a node.
 	 * Optimal placement is no good if the memory bus is saturated and
 	 * all the time is being spent migrating!
 	 */
-	if (numamigrate_update_ratelimit(pgdat, 1)) {
-		put_page(page);
+	if (numamigrate_update_ratelimit(pgdat, 1))
 		goto out;
-	}
 
 	isolated = numamigrate_isolate_page(pgdat, page);
 	if (!isolated)
@@ -1640,12 +1635,19 @@ int migrate_misplaced_page(struct page *
 	} else
 		count_vm_numa_event(NUMA_PAGE_MIGRATE);
 	BUG_ON(!list_empty(&migratepages));
-out:
 	return isolated;
+
+out:
+	put_page(page);
+	return 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
 
 #if defined(CONFIG_NUMA_BALANCING) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
+/*
+ * Migrates a THP to a given target node. page must be locked and is unlocked
+ * before returning.
+ */
 int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 				struct vm_area_struct *vma,
 				pmd_t *pmd, pmd_t entry,
@@ -1676,29 +1678,15 @@ int migrate_misplaced_transhuge_page(str
 
 	new_page = alloc_pages_node(node,
 		(GFP_TRANSHUGE | GFP_THISNODE) & ~__GFP_WAIT, HPAGE_PMD_ORDER);
-	if (!new_page) {
-		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
-		goto out_dropref;
-	}
+	if (!new_page)
+		goto out_fail;
+
 	page_xchg_last_nid(new_page, page_last_nid(page));
 
 	isolated = numamigrate_isolate_page(pgdat, page);
-
-	/*
-	 * Failing to isolate or a GUP pin prevents migration. The expected
-	 * page count is 2. 1 for anonymous pages without a mapping and 1
-	 * for the callers pin. If the page was isolated, the page will
-	 * need to be put back on the LRU.
-	 */
-	if (!isolated || page_count(page) != 2) {
-		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
+	if (!isolated) {
 		put_page(new_page);
-		if (isolated) {
-			putback_lru_page(page);
-			isolated = 0;
-			goto out;
-		}
-		goto out_keep_locked;
+		goto out_fail;
 	}
 
 	/* Prepare a page as a migration target */
@@ -1730,6 +1718,7 @@ int migrate_misplaced_transhuge_page(str
 		putback_lru_page(page);
 
 		count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
+		isolated = 0;
 		goto out;
 	}
 
@@ -1774,9 +1763,11 @@ out:
 			-HPAGE_PMD_NR);
 	return isolated;
 
+out_fail:
+	count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 out_dropref:
+	unlock_page(page);
 	put_page(page);
-out_keep_locked:
 	return 0;
 }
 #endif /* CONFIG_NUMA_BALANCING */
_

Patches currently in -mm which might be from hughd@google.com are

origin.patch
revert-x86-mm-make-spurious_fault-check-explicitly-check-the-present-bit.patch
pageattr-prevent-pse-and-gloabl-leftovers-to-confuse-pmd-pte_present-and-pmd_huge.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch

