From: akpm@linux-foundation.org
Subject: [merged] thp-cleanup-split_huge_page.patch removed from -mm tree
Date: Wed, 16 Mar 2016 12:57:02 -0700
Message-ID: <56e9ba8e.rh7BYmdFRz+DOAgk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39083 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335AbcCPT5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: cleanup split_huge_page()
has been removed from the -mm tree.  Its filename was
     thp-cleanup-split_huge_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp: cleanup split_huge_page()

After one of bugfixes to freeze_page(), we don't have freezed pages in
rmap, therefore mapcount of all subpages of freezed THP is zero.  And we
have assert for that.

Let's drop code which deal with non-zero mapcount of subpages.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff -puN mm/huge_memory.c~thp-cleanup-split_huge_page mm/huge_memory.c
--- a/mm/huge_memory.c~thp-cleanup-split_huge_page
+++ a/mm/huge_memory.c
@@ -3220,28 +3220,26 @@ static void unfreeze_page(struct anon_vm
 	}
 }
 
-static int __split_huge_page_tail(struct page *head, int tail,
+static void __split_huge_page_tail(struct page *head, int tail,
 		struct lruvec *lruvec, struct list_head *list)
 {
-	int mapcount;
 	struct page *page_tail = head + tail;
 
-	mapcount = atomic_read(&page_tail->_mapcount) + 1;
+	VM_BUG_ON_PAGE(atomic_read(&page_tail->_mapcount) != -1, page_tail);
 	VM_BUG_ON_PAGE(atomic_read(&page_tail->_count) != 0, page_tail);
 
 	/*
 	 * tail_page->_count is zero and not changing from under us. But
 	 * get_page_unless_zero() may be running from under us on the
-	 * tail_page. If we used atomic_set() below instead of atomic_add(), we
+	 * tail_page. If we used atomic_set() below instead of atomic_inc(), we
 	 * would then run atomic_set() concurrently with
 	 * get_page_unless_zero(), and atomic_set() is implemented in C not
 	 * using locked ops. spin_unlock on x86 sometime uses locked ops
 	 * because of PPro errata 66, 92, so unless somebody can guarantee
 	 * atomic_set() here would be safe on all archs (and not only on x86),
-	 * it's safer to use atomic_add().
+	 * it's safer to use atomic_inc().
 	 */
-	atomic_add(mapcount + 1, &page_tail->_count);
-
+	atomic_inc(&page_tail->_count);
 
 	page_tail->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
 	page_tail->flags |= (head->flags &
@@ -3275,8 +3273,6 @@ static int __split_huge_page_tail(struct
 	page_tail->index = head->index + tail;
 	page_cpupid_xchg_last(page_tail, page_cpupid_last(head));
 	lru_add_page_tail(head, page_tail, lruvec, list);
-
-	return mapcount;
 }
 
 static void __split_huge_page(struct page *page, struct list_head *list)
@@ -3284,7 +3280,7 @@ static void __split_huge_page(struct pag
 	struct page *head = compound_head(page);
 	struct zone *zone = page_zone(head);
 	struct lruvec *lruvec;
-	int i, tail_mapcount;
+	int i;
 
 	/* prevent PageLRU to go away from under us, and freeze lru stats */
 	spin_lock_irq(&zone->lru_lock);
@@ -3293,10 +3289,8 @@ static void __split_huge_page(struct pag
 	/* complete memcg works before add pages to LRU */
 	mem_cgroup_split_huge_fixup(head);
 
-	tail_mapcount = 0;
 	for (i = HPAGE_PMD_NR - 1; i >= 1; i--)
-		tail_mapcount += __split_huge_page_tail(head, i, lruvec, list);
-	atomic_sub(tail_mapcount, &head->_count);
+		__split_huge_page_tail(head, i, lruvec, list);
 
 	ClearPageCompound(head);
 	spin_unlock_irq(&zone->lru_lock);
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-vmstats-count-deferred-split-events.patch
mm-tracing-refresh-__def_vmaflag_names.patch
mm-cleanup-pte_alloc-interfaces.patch
rmap-introduce-rmap_walk_locked.patch
rmap-extend-try_to_unmap-to-be-usable-by-split_huge_page.patch
mm-make-remove_migration_ptes-beyond-mm-migrationc.patch
thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers.patch
thp-rewrite-freeze_page-unfreeze_page-with-generic-rmap-walkers-fix.patch
thp-fix-deadlock-in-split_huge_pmd.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

