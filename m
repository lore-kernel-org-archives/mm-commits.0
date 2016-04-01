From: akpm@linux-foundation.org
Subject: +
 mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch added to
 -mm tree
Date: Fri, 01 Apr 2016 15:57:01 -0700
Message-ID: <56fefcbd.WOI3ZBYzR6oM6JXN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55016 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898AbcDAW5D (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2016 18:57:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mpe@ellerman.id.au, paulus@samba.org, riel@redhat.com, rjw@rjwysocki.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: add same zone check in pfn_range_valid_gigantic()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Cc: Mel Gorman <mgorman@suse.de>
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

mm-slab-hold-a-slab_mutex-when-calling-__kmem_cache_shrink.patch
mm-slab-remove-bad_alien_magic-again.patch
mm-slab-drain-the-free-slab-as-much-as-possible.patch
mm-slab-factor-out-kmem_cache_node-initialization-code.patch
mm-slab-clean-up-kmem_cache_node-setup.patch
mm-slab-dont-keep-free-slabs-if-free_objects-exceeds-free_limit.patch
mm-slab-racy-access-modify-the-slab-color.patch
mm-slab-make-cache_grow-handle-the-page-allocated-on-arbitrary-node.patch
mm-slab-separate-cache_grow-to-two-parts.patch
mm-slab-refill-cpu-cache-through-a-new-slab-without-holding-a-node-lock.patch
mm-slab-lockless-decision-to-grow-cache.patch
mm-page_ref-use-page_ref-helper-instead-of-direct-modification-of-_count.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount.patch
mm-rename-_count-field-of-the-struct-page-to-_refcount-fix-fix-fix.patch
mm-hugetlb-add-same-zone-check-in-pfn_range_valid_gigantic.patch
mm-memory_hotplug-add-comment-to-some-functions-related-to-memory-hotplug.patch
mm-vmstat-add-zone-range-overlapping-check.patch
mm-page_owner-add-zone-range-overlapping-check.patch
power-add-zone-range-overlapping-check.patch

