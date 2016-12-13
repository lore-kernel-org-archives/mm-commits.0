From: akpm@linux-foundation.org
Subject: [patch 082/123] mm, page_alloc: keep pcp count and list contents
 in sync if struct page is corrupted
Date: Mon, 12 Dec 2016 16:44:41 -0800
Message-ID: <584f4479.3Amqr1QJHJYXC2yP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41622 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932298AbcLMAon (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Dec 2016 19:44:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, cl@linux.com, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, iamjoonsoo.kim@lge.com, mgorman@suse.de, mhocko@suse.com, stable@vger.kernel.org, vbabka@suse.cz

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
