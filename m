From: akpm@linux-foundation.org
Subject: [merged]
 mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:25:38 -0700
Message-ID: <51db1232.IYw61h+14gtGVWZg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab3GHTZu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:25:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, sanbai@taobao.com, riel@redhat.com, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dhowells@redhat.com, bernd.schubert@fastmail.fm, anserper@ya.ru, alexey.lyashkov@gmail.com, Trond.Myklebust@netapp.com, mgorman@suse.de

Subject: [merged] mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch removed from -mm tree
To: mgorman@suse.de,Trond.Myklebust@netapp.com,alexey.lyashkov@gmail.com,anserper@ya.ru,bernd.schubert@fastmail.fm,dhowells@redhat.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,riel@redhat.com,sanbai@taobao.com,tytso@mit.edu,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:25:38 -0700


The patch titled
     Subject: mm: activate !PageLRU pages on mark_page_accessed if page is on local pagevec
has been removed from the -mm tree.  Its filename was
     mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: mm: activate !PageLRU pages on mark_page_accessed if page is on local pagevec

If a page is on a pagevec then it is !PageLRU and mark_page_accessed() may
fail to move a page to the active list as expected.  Now that the LRU is
selected at LRU drain time, mark pages PageActive if they are on the local
pagevec so it gets moved to the correct list at LRU drain time.  Using a
debugging patch it was found that for a simple git checkout based workload
that pages were never added to the active file list in practice but with
this patch applied they are.

				before   after
LRU Add Active File                  0      750583
LRU Add Active Anon            2640587     2702818
LRU Add Inactive File          8833662     8068353
LRU Add Inactive Anon              207         200

Note that only pages on the local pagevec are considered on purpose.  A
!PageLRU page could be in the process of being released, reclaimed,
migrated or on a remote pagevec that is currently being drained.  Marking
it PageActive is vunerable to races where PageLRU and Active bits are
checked at the wrong time.  Page reclaim will trigger VM_BUG_ONs but
depending on when the race hits, it could also free a PageActive page to
the page allocator and trigger a bad_page warning.  Similarly a potential
race exists between a per-cpu drain on a pagevec list and an activation on
a remote CPU.

				lru_add_drain_cpu
				__pagevec_lru_add
				  lru = page_lru(page);
mark_page_accessed
  if (PageLRU(page))
    activate_page
  else
    SetPageActive
				  SetPageLRU(page);
				  add_page_to_lru_list(page, lruvec, lru);

In this case a PageActive page is added to the inactivate list and later
the inactive/active stats will get skewed.  While the PageActive checks in
vmscan could be removed and potentially dealt with, a skew in the
statistics would be very difficult to detect.  Hence this patch deals just
with the common case where a page being marked accessed has just been
added to the local pagevec.

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

 mm/swap.c |   41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff -puN mm/swap.c~mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec mm/swap.c
--- a/mm/swap.c~mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec
+++ a/mm/swap.c
@@ -432,6 +432,33 @@ void activate_page(struct page *page)
 }
 #endif
 
+static void __lru_cache_activate_page(struct page *page)
+{
+	struct pagevec *pvec = &get_cpu_var(lru_add_pvec);
+	int i;
+
+	/*
+	 * Search backwards on the optimistic assumption that the page being
+	 * activated has just been added to this pagevec. Note that only
+	 * the local pagevec is examined as a !PageLRU page could be in the
+	 * process of being released, reclaimed, migrated or on a remote
+	 * pagevec that is currently being drained. Furthermore, marking
+	 * a remote pagevec's page PageActive potentially hits a race where
+	 * a page is marked PageActive just after it is added to the inactive
+	 * list causing accounting errors and BUG_ON checks to trigger.
+	 */
+	for (i = pagevec_count(pvec) - 1; i >= 0; i--) {
+		struct page *pagevec_page = pvec->pages[i];
+
+		if (pagevec_page == page) {
+			SetPageActive(page);
+			break;
+		}
+	}
+
+	put_cpu_var(lru_add_pvec);
+}
+
 /*
  * Mark a page as having seen activity.
  *
@@ -442,8 +469,18 @@ void activate_page(struct page *page)
 void mark_page_accessed(struct page *page)
 {
 	if (!PageActive(page) && !PageUnevictable(page) &&
-			PageReferenced(page) && PageLRU(page)) {
-		activate_page(page);
+			PageReferenced(page)) {
+
+		/*
+		 * If the page is on the LRU, queue it for activation via
+		 * activate_page_pvecs. Otherwise, assume the page is on a
+		 * pagevec, mark it active and it'll be moved to the active
+		 * LRU on the next drain.
+		 */
+		if (PageLRU(page))
+			activate_page(page);
+		else
+			__lru_cache_activate_page(page);
 		ClearPageReferenced(page);
 	} else if (!PageReferenced(page)) {
 		SetPageReferenced(page);
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

