From: akpm@linux-foundation.org
Subject: +
 mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch added
 to -mm tree
Date: Fri, 15 Apr 2016 16:11:57 -0700
Message-ID: <5711753d.y0H2NO00obJDZkjk%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42536 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbcDOXL6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Apr 2016 19:11:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mgorman@techsingularity.net, brouer@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, page_alloc: use __dec_zone_state for order-0 page allocation
has been added to the -mm tree.  Its filename is
     mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch

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
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation
+++ a/mm/page_alloc.c
@@ -2444,6 +2444,7 @@ struct page *buffered_rmqueue(struct zon
 		else
 			page = list_first_entry(list, struct page, lru);
 
+		__dec_zone_state(zone, NR_ALLOC_BATCH);
 		list_del(&page->lru);
 		pcp->count--;
 	} else {
@@ -2465,11 +2466,11 @@ struct page *buffered_rmqueue(struct zon
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

Patches currently in -mm which might be from mgorman@techsingularity.net are

mm-page_alloc-only-check-pagecompound-for-high-order-pages.patch
mm-page_alloc-use-new-pageanonhead-helper-in-the-free-page-fast-path.patch
mm-page_alloc-reduce-branches-in-zone_statistics.patch
mm-page_alloc-inline-zone_statistics.patch
mm-page_alloc-inline-the-fast-path-of-the-zonelist-iterator.patch
mm-page_alloc-use-__dec_zone_state-for-order-0-page-allocation.patch
mm-page_alloc-avoid-unnecessary-zone-lookups-during-pageblock-operations.patch
mm-page_alloc-convert-alloc_flags-to-unsigned.patch
mm-page_alloc-convert-nr_fair_skipped-to-bool.patch
mm-page_alloc-remove-unnecessary-local-variable-in-get_page_from_freelist.patch
mm-page_alloc-remove-unnecessary-initialisation-in-get_page_from_freelist.patch
mm-page_alloc-remove-redundant-check-for-empty-zonelist.patch
mm-page_alloc-simplify-last-cpupid-reset.patch
mm-page_alloc-move-might_sleep_if-check-to-the-allocator-slowpath.patch
mm-page_alloc-move-__gfp_hardwall-modifications-out-of-the-fastpath.patch
mm-page_alloc-check-once-if-a-zone-has-isolated-pageblocks.patch
mm-page_alloc-shorten-the-page-allocator-fast-path.patch
mm-page_alloc-reduce-cost-of-fair-zone-allocation-policy-retry.patch
mm-page_alloc-shortcut-watermark-checks-for-order-0-pages.patch
mm-page_alloc-avoid-looking-up-the-first-zone-in-a-zonelist-twice.patch
mm-page_alloc-remove-field-from-alloc_context.patch
mm-page_alloc-check-multiple-page-fields-with-a-single-branch.patch
mm-page_alloc-remove-unnecessary-variable-from-free_pcppages_bulk.patch
mm-page_alloc-inline-pageblock-lookup-in-page-free-fast-paths.patch
mm-page_alloc-defer-debugging-checks-of-freed-pages-until-a-pcp-drain.patch
mm-page_alloc-defer-debugging-checks-of-pages-allocated-from-the-pcp.patch

