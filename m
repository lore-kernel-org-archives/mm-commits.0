From: akpm@linux-foundation.org
Subject: + thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch added to -mm tree
Date: Wed, 17 Jul 2013 14:03:56 -0700
Message-ID: <51e706bc.gIQ4zc+gzaDOTb3A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081Ab3GQVD5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 17 Jul 2013 17:03:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, kosaki.motohiro@jp.fujitsu.com, dave.hansen@linux.intel.com, kirill.shutemov@linux.intel.com

Subject: + thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch added to -mm tree
To: kirill.shutemov@linux.intel.com,dave.hansen@linux.intel.com,kosaki.motohiro@jp.fujitsu.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com
From: akpm@linux-foundation.org
Date: Wed, 17 Jul 2013 14:03:56 -0700


The patch titled
     Subject: thp, mm: avoid PageUnevictable on active/inactive lru lists
has been added to the -mm tree.  Its filename is
     thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-swapc-clear-pageactive-before-adding-pages-onto-unevictable-list.patch
thp-mm-avoid-pageunevictable-on-active-inactive-lru-lists.patch
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
mm-drop-actor-argument-of-do_generic_file_read.patch
mm-drop-actor-argument-of-do_shmem_file_read.patch

