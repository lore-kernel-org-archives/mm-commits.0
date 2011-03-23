From: akpm@linux-foundation.org
Subject: [merged] mm-batch-free-pcp-list-if-possible.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:36:12 -0700
Message-ID: <201103232039.p2NKdmRL028438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933329Ab1CWUkZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:40:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: namhyung@gmail.com, hannes@cmpxchg.org, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     mm: batch-free pcp list if possible
has been removed from the -mm tree.  Its filename was
     mm-batch-free-pcp-list-if-possible.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: batch-free pcp list if possible
From: Namhyung Kim <namhyung@gmail.com>

free_pcppages_bulk() frees pages from pcp lists in a round-robin fashion
by keeping batch_free counter.  But it doesn't need to spin if there is
only one non-empty list.  This can be checked by batch_free ==
MIGRATE_PCPTYPES.

[akpm@linux-foundation.org: fix comment]
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~mm-batch-free-pcp-list-if-possible mm/page_alloc.c
--- a/mm/page_alloc.c~mm-batch-free-pcp-list-if-possible
+++ a/mm/page_alloc.c
@@ -614,6 +614,10 @@ static void free_pcppages_bulk(struct zo
 			list = &pcp->lists[migratetype];
 		} while (list_empty(list));
 
+		/* This is the only non-empty list. Free them all. */
+		if (batch_free == MIGRATE_PCPTYPES)
+			batch_free = to_free;
+
 		do {
 			page = list_entry(list->prev, struct page, lru);
 			/* must delete as __free_one_page list manipulates */
_

Patches currently in -mm which might be from namhyung@gmail.com are

origin.patch
linux-next.patch

