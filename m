From: akpm@linux-foundation.org
Subject: [merged] mm-vmstat-add-zone-range-overlapping-check.patch removed from -mm tree
Date: Fri, 20 May 2016 14:05:03 -0700
Message-ID: <573f7bff.l/Q/7ZmDS+AD00DV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47095 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbcETVFF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 May 2016 17:05:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, aneesh.kumar@linux.vnet.ibm.com, benh@kernel.crashing.org, hannes@cmpxchg.org, lauraa@codeaurora.org, m.szyprowski@samsung.com, mgorman@suse.de, mina86@mina86.com, minchan@kernel.org, mpe@ellerman.id.au, paulus@samba.org, riel@redhat.com, rjw@rjwysocki.net, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmstat: add zone range overlapping check
has been removed from the -mm tree.  Its filename was
     mm-vmstat-add-zone-range-overlapping-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/vmstat: add zone range overlapping check

There is a system thats node's pfns are overlapped as follows:

-----pfn-------->
N0 N1 N2 N0 N1 N2

Therefore, we need to care this overlapping when iterating pfn range.

There are two places in vmstat.c that iterates pfn range and they don't
consider this overlapping.  Add it.

Without this patch, above system could over count pageblock number on a
zone.

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

 mm/vmstat.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/vmstat.c~mm-vmstat-add-zone-range-overlapping-check mm/vmstat.c
--- a/mm/vmstat.c~mm-vmstat-add-zone-range-overlapping-check
+++ a/mm/vmstat.c
@@ -1010,6 +1010,9 @@ static void pagetypeinfo_showblockcount_
 		if (!memmap_valid_within(pfn, page, zone))
 			continue;
 
+		if (page_zone(page) != zone)
+			continue;
+
 		mtype = get_pageblock_migratetype(page);
 
 		if (mtype < MIGRATE_TYPES)
@@ -1076,6 +1079,10 @@ static void pagetypeinfo_showmixedcount_
 				continue;
 
 			page = pfn_to_page(pfn);
+
+			if (page_zone(page) != zone)
+				continue;
+
 			if (PageBuddy(page)) {
 				pfn += (1UL << page_order(page)) - 1;
 				continue;
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are


