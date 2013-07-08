From: akpm@linux-foundation.org
Subject: [merged]
 mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:36 -0700
Message-ID: <51db1230.iqN2AgL54szJ7KfI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab3GHTZm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, sanbai@taobao.com, riel@redhat.com, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dhowells@redhat.com, bernd.schubert@fastmail.fm, anserper@ya.ru, alexey.lyashkov@gmail.com, Trond.Myklebust@netapp.com, mgorman@suse.de

Subject: [merged] mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch removed from -mm tree
To: mgorman@suse.de,Trond.Myklebust@netapp.com,alexey.lyashkov@gmail.com,anserper@ya.ru,bernd.schubert@fastmail.fm,dhowells@redhat.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,riel@redhat.com,sanbai@taobao.com,tytso@mit.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:36 -0700


The patch titled
     Subject: mm: pagevec: defer deciding which LRU to add a page to until pagevec drain time
has been removed from the -mm tree.  Its filename was
     mm-pagevec-defer-deciding-what-lru-to-add-a-page-to-until-pagevec-drain-time.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

