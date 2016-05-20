From: akpm@linux-foundation.org
Subject: [merged] mm-page_owner-add-zone-range-overlapping-check.patch
 removed from -mm tree
Date: Fri, 20 May 2016 14:05:06 -0700
Message-ID: <573f7c02.qyCy8ER702Rr9Tq5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47112 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbcETVFH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:05:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@techsingularity.net, mina86@mina86.com, minchan@kernel.org, mpe@ellerman.id.au, paulus@samba.org, riel@redhat.com, rjw@rjwysocki.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_owner: add zone range overlapping check
has been removed from the -mm tree.  Its filename was
     mm-page_owner-add-zone-range-overlapping-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/page_owner: add zone range overlapping check

There is a system thats node's pfns are overlapped as follows:

-----pfn-------->
N0 N1 N2 N0 N1 N2

Therefore, we need to care this overlapping when iterating pfn range.

There are one place in page_owner.c that iterates pfn range and
it doesn't consider this overlapping. Add it.

Without this patch, above system could over count early allocated
page number before page_owner is activated.

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

 mm/page_owner.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/page_owner.c~mm-page_owner-add-zone-range-overlapping-check mm/page_owner.c
--- a/mm/page_owner.c~mm-page_owner-add-zone-range-overlapping-check
+++ a/mm/page_owner.c
@@ -301,6 +301,9 @@ static void init_pages_in_zone(pg_data_t
 
 			page = pfn_to_page(pfn);
 
+			if (page_zone(page) != zone)
+				continue;
+
 			/*
 			 * We are safe to check buddy flag and order, because
 			 * this is init stage and only single thread runs.
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


