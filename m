From: akpm@linux-foundation.org
Subject: +
 mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch added to -mm tree
Date: Tue, 28 May 2013 13:06:10 -0700
Message-ID: <51a50e32.8f+WsMFQaKXcTC7x%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60713 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3E1UGL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 16:06:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, sanbai@taobao.com, riel@redhat.com, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dhowells@redhat.com, bernd.schubert@fastmail.fm, anserper@ya.ru, alexey.lyashkov@gmail.com, Trond.Myklebust@netapp.com, mgorman@suse.de

Subject: + mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch added to -mm tree
To: mgorman@suse.de,Trond.Myklebust@netapp.com,alexey.lyashkov@gmail.com,anserper@ya.ru,bernd.schubert@fastmail.fm,dhowells@redhat.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,riel@redhat.com,sanbai@taobao.com,tytso@mit.edu
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 13:06:10 -0700


The patch titled
     Subject: mm: pagevec: defer deciding which LRU to add a page to until pagevec drain time
has been added to the -mm tree.  Its filename is
     mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch

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
Subject: mm: pagevec: defer deciding which LRU to add a page to until pagevec drain time

mark_page_accessed() cannot activate an inactive page that is located on
an inactive LRU pagevec.  Hints from filesystems may be ignored as a
result.  In preparation for fixing that problem, this patch removes the
per-LRU pagevecs and leaves just one pagevec.  The final LRU the page is
added to is deferred until the pagevec is drained.

This means that fewer pagevecs are available and potentially there is
greater contention on the LRU lock.  However, this only applies in the
case where there is an almost perfect mix of file, anon, active and
inactive pages being added to the LRU.  In practice I expect that we are
adding stream of pages of a particular time and that the changes in
contention will barely be measurable.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Jan Kara <jack@suse.cz>
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

 mm/swap.c |   49 ++++++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 27 deletions(-)

diff -puN mm/swap.c~mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time mm/swap.c
--- a/mm/swap.c~mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time
+++ a/mm/swap.c
@@ -40,7 +40,7 @@
 /* How many pages do we try to swap or page in/out together? */
 int page_cluster;
 
-static DEFINE_PER_CPU(struct pagevec[NR_LRU_LISTS], lru_add_pvecs);
+static DEFINE_PER_CPU(struct pagevec, lru_add_pvec);
 static DEFINE_PER_CPU(struct pagevec, lru_rotate_pvecs);
 static DEFINE_PER_CPU(struct pagevec, lru_deactivate_pvecs);
 
@@ -452,22 +452,25 @@ void mark_page_accessed(struct page *pag
 EXPORT_SYMBOL(mark_page_accessed);
 
 /*
- * Order of operations is important: flush the pagevec when it's already
- * full, not when adding the last page, to make sure that last page is
- * not added to the LRU directly when passed to this function. Because
- * mark_page_accessed() (called after this when writing) only activates
- * pages that are on the LRU, linear writes in subpage chunks would see
- * every PAGEVEC_SIZE page activated, which is unexpected.
+ * Queue the page for addition to the LRU via pagevec. The decision on whether
+ * to add the page to the [in]active [file|anon] list is deferred until the
+ * pagevec is drained. This gives a chance for the caller of __lru_cache_add()
+ * have the page added to the active list using mark_page_accessed().
  */
 void __lru_cache_add(struct page *page, enum lru_list lru)
 {
-	struct pagevec *pvec = &get_cpu_var(lru_add_pvecs)[lru];
+	struct pagevec *pvec = &get_cpu_var(lru_add_pvec);
+
+	if (is_active_lru(lru))
+		SetPageActive(page);
+	else
+		ClearPageActive(page);
 
 	page_cache_get(page);
 	if (!pagevec_space(pvec))
 		__pagevec_lru_add(pvec, lru);
 	pagevec_add(pvec, page);
-	put_cpu_var(lru_add_pvecs);
+	put_cpu_var(lru_add_pvec);
 }
 EXPORT_SYMBOL(__lru_cache_add);
 
@@ -480,13 +483,11 @@ void lru_cache_add_lru(struct page *page
 {
 	if (PageActive(page)) {
 		VM_BUG_ON(PageUnevictable(page));
-		ClearPageActive(page);
 	} else if (PageUnevictable(page)) {
 		VM_BUG_ON(PageActive(page));
-		ClearPageUnevictable(page);
 	}
 
-	VM_BUG_ON(PageLRU(page) || PageActive(page) || PageUnevictable(page));
+	VM_BUG_ON(PageLRU(page));
 	__lru_cache_add(page, lru);
 }
 
@@ -587,15 +588,10 @@ static void lru_deactivate_fn(struct pag
  */
 void lru_add_drain_cpu(int cpu)
 {
-	struct pagevec *pvecs = per_cpu(lru_add_pvecs, cpu);
-	struct pagevec *pvec;
-	int lru;
-
-	for_each_lru(lru) {
-		pvec = &pvecs[lru - LRU_BASE];
-		if (pagevec_count(pvec))
-			__pagevec_lru_add(pvec, lru);
-	}
+	struct pagevec *pvec = &per_cpu(lru_add_pvec, cpu);
+
+	if (pagevec_count(pvec))
+		__pagevec_lru_add(pvec, NR_LRU_LISTS);
 
 	pvec = &per_cpu(lru_rotate_pvecs, cpu);
 	if (pagevec_count(pvec)) {
@@ -799,17 +795,16 @@ void lru_add_page_tail(struct page *page
 static void __pagevec_lru_add_fn(struct page *page, struct lruvec *lruvec,
 				 void *arg)
 {
-	enum lru_list lru = (enum lru_list)arg;
-	int file = is_file_lru(lru);
-	int active = is_active_lru(lru);
+	enum lru_list requested_lru = (enum lru_list)arg;
+	int file = page_is_file_cache(page);
+	int active = PageActive(page);
+	enum lru_list lru = page_lru(page);
 
-	VM_BUG_ON(PageActive(page));
+	WARN_ON_ONCE(requested_lru < NR_LRU_LISTS && requested_lru != lru);
 	VM_BUG_ON(PageUnevictable(page));
 	VM_BUG_ON(PageLRU(page));
 
 	SetPageLRU(page);
-	if (active)
-		SetPageActive(page);
 	add_page_to_lru_list(page, lruvec, lru);
 	update_page_reclaim_stat(lruvec, file, active);
 	trace_mm_lru_insertion(page, page_to_pfn(page), lru, trace_pagemap_flags(page));
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

