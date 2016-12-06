From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-keep-pcp-count-and-list-contents-in-sync-if-struct-page-is-corrupted.patch added to -mm tree
Date: Tue, 06 Dec 2016 11:15:27 -0800
Message-ID: <58470e4f.rmDli9HyBXcyUJhJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51076 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752605AbcLFTO6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Dec 2016 14:14:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, cl@linux.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mhocko@suse.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: keep pcp count and list contents in sync if struct page is corrupted
has been added to the -mm tree.  Its filename is
     mm-page_alloc-keep-pcp-count-and-list-contents-in-sync-if-struct-page-is-corrupted.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-keep-pcp-count-and-list-contents-in-sync-if-struct-page-is-corrupted.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-keep-pcp-count-and-list-contents-in-sync-if-struct-page-is-corrupted.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: keep pcp count and list contents in sync if struct page is corrupted

Vlastimil Babka pointed out that 479f854a207c ("mm, page_alloc: defer
debugging checks of pages allocated from the PCP") will allow the per-cpu
list counter to be out of sync with the per-cpu list contents if a struct
page is corrupted.

The consequence is an infinite loop if the per-cpu lists get fully drained
by free_pcppages_bulk because all the lists are empty but the count is
positive.  The infinite loop occurs here

                do {
                        batch_free++;
                        if (++migratetype == MIGRATE_PCPTYPES)
                                migratetype = 0;
                        list = &pcp->lists[migratetype];
                } while (list_empty(list));

What the user sees is a bad page warning followed by a soft lockup with
interrupts disabled in free_pcppages_bulk().

This patch keeps the accounting in sync.

Fixes: 479f854a207c ("mm, page_alloc: defer debugging checks of pages allocated from the PCP")
Link: http://lkml.kernel.org/r/20161202112951.23346-2-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: <stable@vger.kernel.org>	[4.7+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-keep-pcp-count-and-list-contents-in-sync-if-struct-page-is-corrupted mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-keep-pcp-count-and-list-contents-in-sync-if-struct-page-is-corrupted
+++ a/mm/page_alloc.c
@@ -2218,7 +2218,7 @@ static int rmqueue_bulk(struct zone *zon
 			unsigned long count, struct list_head *list,
 			int migratetype, bool cold)
 {
-	int i;
+	int i, alloced = 0;
 
 	spin_lock(&zone->lock);
 	for (i = 0; i < count; ++i) {
@@ -2243,13 +2243,21 @@ static int rmqueue_bulk(struct zone *zon
 		else
 			list_add_tail(&page->lru, list);
 		list = &page->lru;
+		alloced++;
 		if (is_migrate_cma(get_pcppage_migratetype(page)))
 			__mod_zone_page_state(zone, NR_FREE_CMA_PAGES,
 					      -(1 << order));
 	}
+
+	/*
+	 * i pages were removed from the buddy list even if some leak due
+	 * to check_pcp_refill failing so adjust NR_FREE_PAGES based
+	 * on i. Do not confuse with 'alloced' which is the number of
+	 * pages added to the pcp list.
+	 */
 	__mod_zone_page_state(zone, NR_FREE_PAGES, -(i << order));
 	spin_unlock(&zone->lock);
-	return i;
+	return alloced;
 }
 
 #ifdef CONFIG_NUMA
_

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-keep-pcp-count-and-list-contents-in-sync-if-struct-page-is-corrupted.patch

