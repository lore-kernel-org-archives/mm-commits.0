From: akpm@linux-foundation.org
Subject: [patch 067/117] power: add zone range overlapping check
Date: Thu, 19 May 2016 17:12:16 -0700
Message-ID: <573e5660.5OgTfdj4zHFIZd4R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46330 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932816AbcETAMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2016 20:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mpe@ellerman.id.au, paulus@samba.org, riel@redhat.com, rjw@rjwysocki.net, vbabka@suse.cz

From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: power: add zone range overlapping check

There is a system thats node's pfns are overlapped as follows:

-----pfn-------->
N0 N1 N2 N0 N1 N2

Therefore, we need to care this overlapping when iterating pfn range.

mark_free_pages() iterates requested zone's pfn range and unset all
range's bitmap first.  And then it marks freepages in a zone to the
bitmap.  If there is an overlapping zone, above unset could clear previous
marked bit and reference to this bitmap in the future will cause the
problem.  To prevent it, this patch adds a zone check in
mark_free_pages().

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

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/page_alloc.c~power-add-zone-range-overlapping-check mm/page_alloc.c
--- a/mm/page_alloc.c~power-add-zone-range-overlapping-check
+++ a/mm/page_alloc.c
@@ -2156,6 +2156,10 @@ void mark_free_pages(struct zone *zone)
 	for (pfn = zone->zone_start_pfn; pfn < max_zone_pfn; pfn++)
 		if (pfn_valid(pfn)) {
 			page = pfn_to_page(pfn);
+
+			if (page_zone(page) != zone)
+				continue;
+
 			if (!swsusp_page_is_forbidden(page))
 				swsusp_unset_page_free(page);
 		}
_
