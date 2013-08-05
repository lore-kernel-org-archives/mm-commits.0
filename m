From: akpm@linux-foundation.org
Subject: [merged]
 thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch removed
 from -mm tree
Date: Mon, 05 Aug 2013 12:05:53 -0700
Message-ID: <51fff791.BNY+j5vTrISfCgB8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42040 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab3HETGE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Aug 2013 15:06:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: [merged] thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch removed from -mm tree
To: kirill.shutemov@linux.intel.com,dave.hansen@linux.intel.com,kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 05 Aug 2013 12:05:53 -0700


The patch titled
     Subject: thp, mm: avoid PageUnevictable on active/inactive lru lists
has been removed from the -mm tree.  Its filename was
     thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: thp, mm: avoid PageUnevictable on active/inactive lru lists

active/inactive lru lists can contain unevicable pages (i.e.  ramfs pages
that have been placed on the LRU lists when first allocated), but these
pages must not have PageUnevictable set - otherwise shrink_[in]active_list
goes crazy:

kernel BUG at /home/space/kas/git/public/linux-next/mm/vmscan.c:1122!

1090 static unsigned long isolate_lru_pages(unsigned long nr_to_scan,
1091                 struct lruvec *lruvec, struct list_head *dst,
1092                 unsigned long *nr_scanned, struct scan_control *sc,
1093                 isolate_mode_t mode, enum lru_list lru)
1094 {
...
1108                 switch (__isolate_lru_page(page, mode)) {
1109                 case 0:
...
1116                 case -EBUSY:
...
1121                 default:
1122                         BUG();
1123                 }
1124         }
...
1130 }

__isolate_lru_page() returns EINVAL for PageUnevictable(page).

For lru_add_page_tail(), it means we should not set PageUnevictable() for
tail pages unless we're sure that it will go to LRU_UNEVICTABLE.  Let's
just copy PG_active and PG_unevictable from head page in
__split_huge_page_refcount(), it will simplify lru_add_page_tail().

This will fix one more bug in lru_add_page_tail(): if
page_evictable(page_tail) is false and PageLRU(page) is true, page_tail
will go to the same lru as page, but nobody cares to sync page_tail
active/inactive state with page.  So we can end up with inactive page on
active lru.  The patch will fix it as well since we copy PG_active from
head page.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 +++-
 mm/swap.c        |   20 ++------------------
 2 files changed, 5 insertions(+), 19 deletions(-)

diff -puN mm/huge_memory.c~thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists mm/huge_memory.c
--- a/mm/huge_memory.c~thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists
+++ a/mm/huge_memory.c
@@ -1620,7 +1620,9 @@ static void __split_huge_page_refcount(s
 				     ((1L << PG_referenced) |
 				      (1L << PG_swapbacked) |
 				      (1L << PG_mlocked) |
-				      (1L << PG_uptodate)));
+				      (1L << PG_uptodate) |
+				      (1L << PG_active) |
+				      (1L << PG_unevictable)));
 		page_tail->flags |= (1L << PG_dirty);
 
 		/* clear PageTail before overwriting first_page */
diff -puN mm/swap.c~thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists mm/swap.c
--- a/mm/swap.c~thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists
+++ a/mm/swap.c
@@ -770,8 +770,6 @@ EXPORT_SYMBOL(__pagevec_release);
 void lru_add_page_tail(struct page *page, struct page *page_tail,
 		       struct lruvec *lruvec, struct list_head *list)
 {
-	int uninitialized_var(active);
-	enum lru_list lru;
 	const int file = 0;
 
 	VM_BUG_ON(!PageHead(page));
@@ -783,20 +781,6 @@ void lru_add_page_tail(struct page *page
 	if (!list)
 		SetPageLRU(page_tail);
 
-	if (page_evictable(page_tail)) {
-		if (PageActive(page)) {
-			SetPageActive(page_tail);
-			active = 1;
-			lru = LRU_ACTIVE_ANON;
-		} else {
-			active = 0;
-			lru = LRU_INACTIVE_ANON;
-		}
-	} else {
-		SetPageUnevictable(page_tail);
-		lru = LRU_UNEVICTABLE;
-	}
-
 	if (likely(PageLRU(page)))
 		list_add_tail(&page_tail->lru, &page->lru);
 	else if (list) {
@@ -812,13 +796,13 @@ void lru_add_page_tail(struct page *page
 		 * Use the standard add function to put page_tail on the list,
 		 * but then correct its position so they all end up in order.
 		 */
-		add_page_to_lru_list(page_tail, lruvec, lru);
+		add_page_to_lru_list(page_tail, lruvec, page_lru(page_tail));
 		list_head = page_tail->lru.prev;
 		list_move_tail(&page_tail->lru, list_head);
 	}
 
 	if (!PageUnevictable(page))
-		update_page_reclaim_stat(lruvec, file, active);
+		update_page_reclaim_stat(lruvec, file, PageActive(page_tail));
 }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_shmem_file_read.patch
thp-account-anon-transparent-huge-pages-into-nr_anon_pages.patch
mm-cleanup-add_to_page_cache_locked.patch
thp-move-maybe_pmd_mkwrite-out-of-mk_huge_pmd.patch
thp-do_huge_pmd_anonymous_page-cleanup.patch
thp-consolidate-code-between-handle_mm_fault-and-do_huge_pmd_anonymous_page.patch
mm-fix-potential-null-pointer-dereference.patch
thp-mm-locking-tail-page-is-a-bug.patch
linux-next.patch
fs-bump-inode-and-dentry-counters-to-long.patch
super-fix-calculation-of-shrinkable-objects-for-small-numbers.patch
dcache-convert-dentry_statnr_unused-to-per-cpu-counters.patch
dentry-move-to-per-sb-lru-locks.patch
dcache-remove-dentries-from-lru-before-putting-on-dispose-list.patch
mm-new-shrinker-api.patch
shrinker-convert-superblock-shrinkers-to-new-api.patch
list-add-a-new-lru-list-type.patch
inode-convert-inode-lru-list-to-generic-lru-list-code.patch
dcache-convert-to-use-new-lru-list-infrastructure.patch
list_lru-per-node-list-infrastructure.patch
list_lru-per-node-api.patch
shrinker-add-node-awareness.patch
vmscan-per-node-deferred-work.patch
fs-convert-inode-and-dentry-shrinking-to-be-node-aware.patch
xfs-convert-buftarg-lru-to-generic-code.patch
xfs-rework-buffer-dispose-list-tracking.patch
xfs-convert-dquot-cache-lru-to-list_lru.patch
fs-convert-fs-shrinkers-to-new-scan-count-api.patch
drivers-convert-shrinkers-to-new-count-scan-api.patch
i915-bail-out-earlier-when-shrinker-cannot-acquire-mutex.patch
shrinker-convert-remaining-shrinkers-to-count-scan-api.patch
hugepage-convert-huge-zero-page-shrinker-to-new-shrinker-api.patch
shrinker-kill-old-shrink-api.patch
list_lru-dynamically-adjust-node-arrays.patch

