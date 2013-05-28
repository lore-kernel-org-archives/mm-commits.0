From: akpm@linux-foundation.org
Subject: +
 mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
 added to -mm tree
Date: Tue, 28 May 2013 13:06:20 -0700
Message-ID: <51a50e3c.L2lIoeObPbmPG0wc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab3E1UGV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 16:06:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, sanbai@taobao.com, riel@redhat.com, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dhowells@redhat.com, bernd.schubert@fastmail.fm, anserper@ya.ru, alexey.lyashkov@gmail.com, Trond.Myklebust@netapp.com, mgorman@suse.de

Subject: + mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch added to -mm tree
To: mgorman@suse.de,Trond.Myklebust@netapp.com,alexey.lyashkov@gmail.com,anserper@ya.ru,bernd.schubert@fastmail.fm,dhowells@redhat.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,riel@redhat.com,sanbai@taobao.com,tytso@mit.edu
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 13:06:20 -0700


The patch titled
     Subject: mm: remove lru parameter from __lru_cache_add and lru_cache_add_lru
has been added to the -mm tree.  Its filename is
     mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Signed-off-by: Mel Gorman <mgorman@suse.de>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   11 +++++++----
 mm/rmap.c            |    7 ++++---
 mm/swap.c            |   14 ++++----------
 mm/vmscan.c          |    4 +---
 4 files changed, 16 insertions(+), 20 deletions(-)

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
@@ -561,8 +560,7 @@ redo:
 		 * unevictable page on [in]active list.
 		 * We know how to handle that.
 		 */
-		lru = active + page_lru_base_type(page);
-		lru_cache_add_lru(page, lru);
+		lru_cache_add(page);
 	} else {
 		/*
 		 * Put unevictable pages directly on zone's unevictable
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-page_alloc-factor-out-setting-of-pcp-high-and-pcp-batch.patch
mm-page_alloc-prevent-concurrent-updaters-of-pcp-batch-and-high.patch
mm-page_alloc-insert-memory-barriers-to-allow-async-update-of-pcp-batch-and-high.patch
mm-page_alloc-protect-pcp-batch-accesses-with-access_once.patch
mm-page_alloc-convert-zone_pcp_update-to-rely-on-memory-barriers-instead-of-stop_machine.patch
mm-page_alloc-when-handling-percpu_pagelist_fraction-dont-unneedly-recalulate-high.patch
mm-page_alloc-factor-setup_pageset-into-pageset_init-and-pageset_set_batch.patch
mm-page_alloc-relocate-comment-to-be-directly-above-code-it-refers-to.patch
mm-page_alloc-factor-zone_pageset_init-out-of-setup_zone_pageset.patch
mm-page_alloc-in-zone_pcp_update-uze-zone_pageset_init.patch
mm-page_alloc-rename-setup_pagelist_highmark-to-match-naming-of-pageset_set_batch.patch
mm-vmscan-limit-the-number-of-pages-kswapd-reclaims-at-each-priority.patch
mm-vmscan-obey-proportional-scanning-requirements-for-kswapd.patch
mm-vmscan-flatten-kswapd-priority-loop.patch
mm-vmscan-decide-whether-to-compact-the-pgdat-based-on-reclaim-progress.patch
mm-vmscan-do-not-allow-kswapd-to-scan-at-maximum-priority.patch
mm-vmscan-have-kswapd-writeback-pages-based-on-dirty-pages-encountered-not-priority.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback.patch
mm-vmscan-block-kswapd-if-it-is-encountering-pages-under-writeback-fix.patch
mm-vmscan-check-if-kswapd-should-writepage-once-per-pgdat-scan.patch
mm-vmscan-move-logic-from-balance_pgdat-to-kswapd_shrink_zone.patch
mm-add-tracepoints-for-lru-activation-and-insertions.patch
mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch
mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch
mm-remove-lru-parameter-from-__pagevec_lru_add-and-remove-parts-of-pagevec-api.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-memmap_init_zone-performance-improvement.patch

