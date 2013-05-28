From: akpm@linux-foundation.org
Subject: +
 mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch added to -mm tree
Date: Tue, 28 May 2013 13:06:14 -0700
Message-ID: <51a50e36.N14sxlGcTlRNwkDe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755033Ab3E1UGP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 16:06:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tytso@mit.edu, sanbai@taobao.com, riel@redhat.com, jack@suse.cz, hughd@google.com, hannes@cmpxchg.org, dhowells@redhat.com, bernd.schubert@fastmail.fm, anserper@ya.ru, alexey.lyashkov@gmail.com, Trond.Myklebust@netapp.com, mgorman@suse.de

Subject: + mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch added to -mm tree
To: mgorman@suse.de,Trond.Myklebust@netapp.com,alexey.lyashkov@gmail.com,anserper@ya.ru,bernd.schubert@fastmail.fm,dhowells@redhat.com,hannes@cmpxchg.org,hughd@google.com,jack@suse.cz,riel@redhat.com,sanbai@taobao.com,tytso@mit.edu
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 13:06:14 -0700


The patch titled
     Subject: mm: activate !PageLRU pages on mark_page_accessed if page is on local pagevec
has been added to the -mm tree.  Its filename is
     mm-activate-pagelru-pages-on-mark_page_accessed-if-page-is-on-local-pagevec.patch

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

