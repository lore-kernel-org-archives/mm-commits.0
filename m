From: akpm@linux-foundation.org
Subject: [patch 092/117] mm, page_alloc: use __dec_zone_state for order-0
 page allocation
Date: Thu, 19 May 2016 17:13:33 -0700
Message-ID: <573e56ad.ZF1d4x5W8VIvd4BX%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932955AbcETANe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:13:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm, page_alloc: use __dec_zone_state for order-0 page allocation

__dec_zone_state is cheaper to use for removing an order-0 page as it has
fewer conditions to check.

The performance difference on a page allocator microbenchmark is;

                                           4.6.0-rc2                  4.6.0-rc2
                                       optiter-v1r20              decstat-v1r20
Min      alloc-odr0-1               382.00 (  0.00%)           381.00 (  0.26%)
Min      alloc-odr0-2               282.00 (  0.00%)           275.00 (  2.48%)
Min      alloc-odr0-4               233.00 (  0.00%)           229.00 (  1.72%)
Min      alloc-odr0-8               203.00 (  0.00%)           199.00 (  1.97%)
Min      alloc-odr0-16              188.00 (  0.00%)           186.00 (  1.06%)
Min      alloc-odr0-32              182.00 (  0.00%)           179.00 (  1.65%)
Min      alloc-odr0-64              177.00 (  0.00%)           174.00 (  1.69%)
Min      alloc-odr0-128             175.00 (  0.00%)           172.00 (  1.71%)
Min      alloc-odr0-256             184.00 (  0.00%)           181.00 (  1.63%)
Min      alloc-odr0-512             197.00 (  0.00%)           193.00 (  2.03%)
Min      alloc-odr0-1024            203.00 (  0.00%)           201.00 (  0.99%)
Min      alloc-odr0-2048            209.00 (  0.00%)           206.00 (  1.44%)
Min      alloc-odr0-4096            214.00 (  0.00%)           212.00 (  0.93%)
Min      alloc-odr0-8192            218.00 (  0.00%)           215.00 (  1.38%)
Min      alloc-odr0-16384           219.00 (  0.00%)           216.00 (  1.37%)

Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation
+++ a/mm/page_alloc.c
@@ -2417,6 +2417,7 @@ struct page *buffered_rmqueue(struct zon
 		else
 			page = list_first_entry(list, struct page, lru);
 
+		__dec_zone_state(zone, NR_ALLOC_BATCH);
 		list_del(&page->lru);
 		pcp->count--;
 	} else {
@@ -2438,11 +2439,11 @@ struct page *buffered_rmqueue(struct zon
 		spin_unlock(&zone->lock);
 		if (!page)
 			goto failed;
+		__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
 		__mod_zone_freepage_state(zone, -(1 << order),
 					  get_pcppage_migratetype(page));
 	}
 
-	__mod_zone_page_state(zone, NR_ALLOC_BATCH, -(1 << order));
 	if (atomic_long_read(&zone->vm_stat[NR_ALLOC_BATCH]) <= 0 &&
 	    !test_bit(ZONE_FAIR_DEPLETED, &zone->flags))
 		set_bit(ZONE_FAIR_DEPLETED, &zone->flags);
_
