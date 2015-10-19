From: akpm@linux-foundation.org
Subject: +
 mm-page-migration-avoid-touching-newpage-until-no-going-back.patch added to -mm tree
Date: Mon, 19 Oct 2015 15:03:40 -0700
Message-ID: <562568bc.neZYymwijNNF1kIC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637AbbJSWDl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 19 Oct 2015 18:03:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, andreyknvl@google.com, cl@linux.com, dave@stgolabs.net, dvyukov@google.com, kirill.shutemov@linux.intel.com, kosaki.motohiro@jp.fujitsu.com, oleg@redhat.com, riel@redhat.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page migration avoid touching newpage until no going back
has been added to the -mm tree.  Its filename is
     mm-page-migration-avoid-touching-newpage-until-no-going-back.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page-migration-avoid-touching-newpage-until-no-going-back.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page-migration-avoid-touching-newpage-until-no-going-back.patch

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
Cc: Andrey Konovalov <andreyknvl@google.com>
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

memcg-simplify-and-inline-__mem_cgroup_from_kmem-fix-2.patch
mm-documentation-undoc-non-linear-vmas.patch
mm-rmap-use-pte-lock-not-mmap_sem-to-set-pagemlocked.patch
mm-page-migration-fix-pagemlocked-on-migrated-pages.patch
mm-rename-mem_cgroup_migrate-to-mem_cgroup_replace_page.patch
mm-correct-a-couple-of-page-migration-comments.patch
mm-page-migration-use-the-put_new_page-whenever-necessary.patch
mm-page-migration-trylock-newpage-at-same-level-as-oldpage.patch
mm-page-migration-remove_migration_ptes-at-lockunlock-level.patch
mm-simplify-page-migrations-anon_vma-comment-and-flow.patch
mm-page-migration-use-migration-entry-for-swapcache-too.patch
mm-page-migration-avoid-touching-newpage-until-no-going-back.patch
mm-migrate-dirty-page-without-clear_page_dirty_for_io-etc.patch
mm-use-unsigned-int-for-page-order-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-4.patch

