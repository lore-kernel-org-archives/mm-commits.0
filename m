From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:42 -0700
Message-ID: <51db1236.pUSEM8pNhgAf8TQK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50459 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3GHTZn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, sanbai@taobao.com, riel@redhat.com, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, gang.chen@asianux.com, dhowells@redhat.com, bernd.schubert@fastmail.fm, anserper@ya.ru, alexey.lyashkov@gmail.com, Trond.Myklebust@netapp.com, mgorman@suse.de

Subject: [merged] mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch removed from -mm tree
To: mgorman@suse.de,Trond.Myklebust@netapp.com,alexey.lyashkov@gmail.com,anserper@ya.ru,bernd.schubert@fastmail.fm,dhowells@redhat.com,gang.chen@asianux.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,riel@redhat.com,sanbai@taobao.com,tytso@mit.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:42 -0700


The patch titled
     Subject: mm: remove lru parameter from __lru_cache_add and lru_cache_add_lru
has been removed from the -mm tree.  Its filename was
     mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: remove lru parameter from __lru_cache_add and lru_cache_add_lru

Similar to __pagevec_lru_add, this patch removes the LRU parameter from
__lru_cache_add and lru_cache_add_lru as the caller does not control the
exact LRU the page gets added to.  lru_cache_add_lru gets renamed to
lru_cache_add the name is silly without the lru parameter.  With the
parameter removed, it is required that the caller indicate if they want
the page added to the active or inactive list by setting or clearing
PageActive respectively.

[akpm@linux-foundation.org: Suggested the patch]
[gang.chen@asianux.com: fix used-unintialized warning]
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Chen Gang <gang.chen@asianux.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alexey Lyahkov <alexey.lyashkov@gmail.com>
Cc: Andrew Perepechko <anserper@ya.ru>
Cc: Robin Dong <sanbai@taobao.com>
Cc: Theodore Tso <tytso@mit.edu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   11 +++++++----
 mm/rmap.c            |    7 ++++---
 mm/swap.c            |   17 +++++++----------
 mm/vmscan.c          |    5 ++---
 4 files changed, 20 insertions(+), 20 deletions(-)

diff -puN include/linux/swap.h~mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru include/linux/swap.h
--- a/include/linux/swap.h~mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru
+++ a/include/linux/swap.h
@@ -10,6 +10,7 @@
 #include <linux/node.h>
 #include <linux/fs.h>
 #include <linux/atomic.h>
+#include <linux/page-flags.h>
 #include <asm/page.h>
 
 struct notifier_block;
@@ -233,8 +234,8 @@ extern unsigned long nr_free_pagecache_p
 
 
 /* linux/mm/swap.c */
-extern void __lru_cache_add(struct page *, enum lru_list lru);
-extern void lru_cache_add_lru(struct page *, enum lru_list lru);
+extern void __lru_cache_add(struct page *);
+extern void lru_cache_add(struct page *);
 extern void lru_add_page_tail(struct page *page, struct page *page_tail,
 			 struct lruvec *lruvec, struct list_head *head);
 extern void activate_page(struct page *);
@@ -254,12 +255,14 @@ extern void add_page_to_unevictable_list
  */
 static inline void lru_cache_add_anon(struct page *page)
 {
-	__lru_cache_add(page, LRU_INACTIVE_ANON);
+	ClearPageActive(page);
+	__lru_cache_add(page);
 }
 
 static inline void lru_cache_add_file(struct page *page)
 {
-	__lru_cache_add(page, LRU_INACTIVE_FILE);
+	ClearPageActive(page);
+	__lru_cache_add(page);
 }
 
 /* linux/mm/vmscan.c */
diff -puN mm/rmap.c~mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru mm/rmap.c
--- a/mm/rmap.c~mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru
+++ a/mm/rmap.c
@@ -1093,9 +1093,10 @@ void page_add_new_anon_rmap(struct page
 	else
 		__inc_zone_page_state(page, NR_ANON_TRANSPARENT_HUGEPAGES);
 	__page_set_anon_rmap(page, vma, address, 1);
-	if (!mlocked_vma_newpage(vma, page))
-		lru_cache_add_lru(page, LRU_ACTIVE_ANON);
-	else
+	if (!mlocked_vma_newpage(vma, page)) {
+		SetPageActive(page);
+		lru_cache_add(page);
+	} else
 		add_page_to_unevictable_list(page);
 }
 
diff -puN mm/swap.c~mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru mm/swap.c
--- a/mm/swap.c~mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru
+++ a/mm/swap.c
@@ -494,15 +494,10 @@ EXPORT_SYMBOL(mark_page_accessed);
  * pagevec is drained. This gives a chance for the caller of __lru_cache_add()
  * have the page added to the active list using mark_page_accessed().
  */
-void __lru_cache_add(struct page *page, enum lru_list lru)
+void __lru_cache_add(struct page *page)
 {
 	struct pagevec *pvec = &get_cpu_var(lru_add_pvec);
 
-	if (is_active_lru(lru))
-		SetPageActive(page);
-	else
-		ClearPageActive(page);
-
 	page_cache_get(page);
 	if (!pagevec_space(pvec))
 		__pagevec_lru_add(pvec);
@@ -512,11 +507,10 @@ void __lru_cache_add(struct page *page,
 EXPORT_SYMBOL(__lru_cache_add);
 
 /**
- * lru_cache_add_lru - add a page to a page list
+ * lru_cache_add - add a page to a page list
  * @page: the page to be added to the LRU.
- * @lru: the LRU list to which the page is added.
  */
-void lru_cache_add_lru(struct page *page, enum lru_list lru)
+void lru_cache_add(struct page *page)
 {
 	if (PageActive(page)) {
 		VM_BUG_ON(PageUnevictable(page));
@@ -525,7 +519,7 @@ void lru_cache_add_lru(struct page *page
 	}
 
 	VM_BUG_ON(PageLRU(page));
-	__lru_cache_add(page, lru);
+	__lru_cache_add(page);
 }
 
 /**
@@ -745,6 +739,9 @@ void release_pages(struct page **pages,
 			del_page_from_lru_list(page, lruvec, page_off_lru(page));
 		}
 
+		/* Clear Active bit in case of parallel mark_page_accessed */
+		ClearPageActive(page);
+
 		list_add(&page->lru, &pages_to_free);
 	}
 	if (zone)
diff -puN mm/vmscan.c~mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru mm/vmscan.c
--- a/mm/vmscan.c~mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru
+++ a/mm/vmscan.c
@@ -546,7 +546,6 @@ int remove_mapping(struct address_space
 void putback_lru_page(struct page *page)
 {
 	int lru;
-	int active = !!TestClearPageActive(page);
 	int was_unevictable = PageUnevictable(page);
 
 	VM_BUG_ON(PageLRU(page));
@@ -561,8 +560,8 @@ redo:
 		 * unevictable page on [in]active list.
 		 * We know how to handle that.
 		 */
-		lru = active + page_lru_base_type(page);
-		lru_cache_add_lru(page, lru);
+		lru = page_lru_base_type(page);
+		lru_cache_add(page);
 	} else {
 		/*
 		 * Put unevictable pages directly on zone's unevictable
_

Patches currently in -mm which might be from mgorman@suse.de are

origin.patch
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
zbud-add-to-mm.patch
zswap-add-to-mm.patch
zswap-add-documentation.patch
mm-vmscan-do-not-continue-scanning-if-reclaim-was-aborted-for-compaction.patch
mm-vmscan-do-not-scale-writeback-pages-when-deciding-whether-to-set-zone_writeback.patch
mm-memmap_init_zone-performance-improvement.patch

