From: akpm@linux-foundation.org
Subject: [merged]
 mm-page-migration-avoid-touching-newpage-until-no-going-back.patch removed
 from -mm tree
Date: Fri, 06 Nov 2015 12:16:55 -0800
Message-ID: <563d0ab7.fvWFC31UnbGaZmcD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032012AbbKFUQ4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Nov 2015 15:16:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page migration avoid touching newpage until no going back
has been removed from the -mm tree.  Its filename was
     mm-page-migration-avoid-touching-newpage-until-no-going-back.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: page migration avoid touching newpage until no going back

We have had trouble in the past from the way in which page migration's
newpage is initialized in dribs and drabs - see commit 8bdd63809160 ("mm:
fix direct reclaim writeback regression") which proposed a cleanup.

We have no actual problem now, but I think the procedure would be clearer
(and alternative get_new_page pools safer to implement) if we assert that
newpage is not touched until we are sure that it's going to be used -
except for taking the trylock on it in __unmap_and_move().

So shift the early initializations from move_to_new_page() into
migrate_page_move_mapping(), mapping and NULL-mapping paths.  Similarly
migrate_huge_page_move_mapping(), but its NULL-mapping path can just be
deleted: you cannot reach hugetlbfs_migrate_page() with a NULL mapping.

Adjust stages 3 to 8 in the Documentation file accordingly.

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_migration |   19 +++++------
 mm/migrate.c                    |   49 ++++++++++++------------------
 2 files changed, 30 insertions(+), 38 deletions(-)

diff -puN Documentation/vm/page_migration~mm-page-migration-avoid-touching-newpage-until-no-going-back Documentation/vm/page_migration
--- a/Documentation/vm/page_migration~mm-page-migration-avoid-touching-newpage-until-no-going-back
+++ a/Documentation/vm/page_migration
@@ -92,27 +92,26 @@ Steps:
 
 2. Insure that writeback is complete.
 
-3. Prep the new page that we want to move to. It is locked
-   and set to not being uptodate so that all accesses to the new
-   page immediately lock while the move is in progress.
+3. Lock the new page that we want to move to. It is locked so that accesses to
+   this (not yet uptodate) page immediately lock while the move is in progress.
 
-4. The new page is prepped with some settings from the old page so that
-   accesses to the new page will discover a page with the correct settings.
-
-5. All the page table references to the page are converted to migration
+4. All the page table references to the page are converted to migration
    entries. This decreases the mapcount of a page. If the resulting
    mapcount is not zero then we do not migrate the page. All user space
    processes that attempt to access the page will now wait on the page lock.
 
-6. The radix tree lock is taken. This will cause all processes trying
+5. The radix tree lock is taken. This will cause all processes trying
    to access the page via the mapping to block on the radix tree spinlock.
 
-7. The refcount of the page is examined and we back out if references remain
+6. The refcount of the page is examined and we back out if references remain
    otherwise we know that we are the only one referencing this page.
 
-8. The radix tree is checked and if it does not contain the pointer to this
+7. The radix tree is checked and if it does not contain the pointer to this
    page then we back out because someone else modified the radix tree.
 
+8. The new page is prepped with some settings from the old page so that
+   accesses to the new page will discover a page with the correct settings.
+
 9. The radix tree is changed to point to the new page.
 
 10. The reference count of the old page is dropped because the radix tree
diff -puN mm/migrate.c~mm-page-migration-avoid-touching-newpage-until-no-going-back mm/migrate.c
--- a/mm/migrate.c~mm-page-migration-avoid-touching-newpage-until-no-going-back
+++ a/mm/migrate.c
@@ -320,6 +320,14 @@ int migrate_page_move_mapping(struct add
 		/* Anonymous page without mapping */
 		if (page_count(page) != expected_count)
 			return -EAGAIN;
+
+		/* No turning back from here */
+		set_page_memcg(newpage, page_memcg(page));
+		newpage->index = page->index;
+		newpage->mapping = page->mapping;
+		if (PageSwapBacked(page))
+			SetPageSwapBacked(newpage);
+
 		return MIGRATEPAGE_SUCCESS;
 	}
 
@@ -355,8 +363,15 @@ int migrate_page_move_mapping(struct add
 	}
 
 	/*
-	 * Now we know that no one else is looking at the page.
+	 * Now we know that no one else is looking at the page:
+	 * no turning back from here.
 	 */
+	set_page_memcg(newpage, page_memcg(page));
+	newpage->index = page->index;
+	newpage->mapping = page->mapping;
+	if (PageSwapBacked(page))
+		SetPageSwapBacked(newpage);
+
 	get_page(newpage);	/* add cache reference */
 	if (PageSwapCache(page)) {
 		SetPageSwapCache(newpage);
@@ -403,12 +418,6 @@ int migrate_huge_page_move_mapping(struc
 	int expected_count;
 	void **pslot;
 
-	if (!mapping) {
-		if (page_count(page) != 1)
-			return -EAGAIN;
-		return MIGRATEPAGE_SUCCESS;
-	}
-
 	spin_lock_irq(&mapping->tree_lock);
 
 	pslot = radix_tree_lookup_slot(&mapping->page_tree,
@@ -426,6 +435,9 @@ int migrate_huge_page_move_mapping(struc
 		return -EAGAIN;
 	}
 
+	set_page_memcg(newpage, page_memcg(page));
+	newpage->index = page->index;
+	newpage->mapping = page->mapping;
 	get_page(newpage);
 
 	radix_tree_replace_slot(pslot, newpage);
@@ -730,21 +742,6 @@ static int move_to_new_page(struct page
 	VM_BUG_ON_PAGE(!PageLocked(page), page);
 	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
 
-	/* Prepare mapping for the new page.*/
-	newpage->index = page->index;
-	newpage->mapping = page->mapping;
-	if (PageSwapBacked(page))
-		SetPageSwapBacked(newpage);
-
-	/*
-	 * Indirectly called below, migrate_page_copy() copies PG_dirty and thus
-	 * needs newpage's memcg set to transfer memcg dirty page accounting.
-	 * So perform memcg migration in two steps:
-	 * 1. set newpage->mem_cgroup (here)
-	 * 2. clear page->mem_cgroup (below)
-	 */
-	set_page_memcg(newpage, page_memcg(page));
-
 	mapping = page_mapping(page);
 	if (!mapping)
 		rc = migrate_page(mapping, newpage, page, mode);
@@ -767,9 +764,6 @@ static int move_to_new_page(struct page
 		set_page_memcg(page, NULL);
 		if (!PageAnon(page))
 			page->mapping = NULL;
-	} else {
-		set_page_memcg(newpage, NULL);
-		newpage->mapping = NULL;
 	}
 	return rc;
 }
@@ -971,10 +965,9 @@ out:
 	 * it.  Otherwise, putback_lru_page() will drop the reference grabbed
 	 * during isolation.
 	 */
-	if (put_new_page) {
-		ClearPageSwapBacked(newpage);
+	if (put_new_page)
 		put_new_page(newpage, private);
-	} else if (unlikely(__is_movable_balloon_page(newpage))) {
+	else if (unlikely(__is_movable_balloon_page(newpage))) {
 		/* drop our reference, page already in the balloon */
 		put_page(newpage);
 	} else
_

Patches currently in -mm which might be from hughd@google.com are

osd-fs-__r4w_get_page-rely-on-pageuptodate-for-uptodate.patch
mm-use-unsigned-int-for-page-order-fix-2.patch

