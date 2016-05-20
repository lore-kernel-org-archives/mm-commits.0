From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch removed
 from -mm tree
Date: Fri, 20 May 2016 14:04:57 -0700
Message-ID: <573f7bf9.PtSHzxfIYfqSxqLs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47058 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbcETVE6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:04:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@techsingularity.net, mina86@mina86.com, minchan@kernel.org, mpe@ellerman.id.au, paulus@samba.org, riel@redhat.com, rjw@rjwysocki.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add same zone check in pfn_range_valid_gigantic()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/hugetlb: add same zone check in pfn_range_valid_gigantic()

This patchset deals with some problematic sites that iterate pfn ranges.

There is a system thats node's pfns are overlapped as follows:

-----pfn-------->
N0 N1 N2 N0 N1 N2

Therefore, we need to take care of this overlapping when iterating pfn
range.

I audit many iterating sites that uses pfn_valid(), pfn_valid_within(),
zone_start_pfn and etc.  and others looks safe to me.  This is a
preparation step for a new CMA implementation, ZONE_CMA
(https://lkml.org/lkml/2015/2/12/95), because it would be easily
overlapped with other zones.  But, zone overlap check is also needed for
the general case so I send it separately.



This patch (of 5):

alloc_gigantic_page() uses alloc_contig_range() and this requires that the
requested range is in a single zone.  To satisfy this requirement, add
this check to pfn_range_valid_gigantic().

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Rik van Riel <riel@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Laura Abbott <lauraa@codeaurora.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic
+++ a/mm/hugetlb.c
@@ -1031,8 +1031,8 @@ static int __alloc_gigantic_page(unsigne
 	return alloc_contig_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
 }
 
-static bool pfn_range_valid_gigantic(unsigned long start_pfn,
-				unsigned long nr_pages)
+static bool pfn_range_valid_gigantic(struct zone *z,
+			unsigned long start_pfn, unsigned long nr_pages)
 {
 	unsigned long i, end_pfn = start_pfn + nr_pages;
 	struct page *page;
@@ -1043,6 +1043,9 @@ static bool pfn_range_valid_gigantic(uns
 
 		page = pfn_to_page(i);
 
+		if (page_zone(page) != z)
+			return false;
+
 		if (PageReserved(page))
 			return false;
 
@@ -1075,7 +1078,7 @@ static struct page *alloc_gigantic_page(
 
 		pfn = ALIGN(z->zone_start_pfn, nr_pages);
 		while (zone_spans_last_pfn(z, pfn, nr_pages)) {
-			if (pfn_range_valid_gigantic(pfn, nr_pages)) {
+			if (pfn_range_valid_gigantic(z, pfn, nr_pages)) {
 				/*
 				 * We release the zone lock here because
 				 * alloc_contig_range() will also lock the zone
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


