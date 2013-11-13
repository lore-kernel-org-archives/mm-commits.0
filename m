From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-populated_zone-instead-of-ifzone-present_pages.patch removed from
 -mm tree
Date: Wed, 13 Nov 2013 12:37:59 -0800
Message-ID: <5283e327.wsucOYuxzDIIQeQ1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42514 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3KMUh7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:37:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com

Subject: [merged] mm-use-populated_zone-instead-of-ifzone-present_pages.patch removed from -mm tree
To: qiuxishi@huawei.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:37:59 -0800


The patch titled
     Subject: mm: use populated_zone() instead of if(zone->present_pages)
has been removed from the -mm tree.  Its filename was
     mm-use-populated_zone-instead-of-ifzone-present_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: use populated_zone() instead of if(zone->present_pages)

Use "if (zone->present_pages)" instead of "if (zone->present_pages)".
Simplify the code, no functional change.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/page_alloc.c~mm-use-populated_zone-instead-of-ifzone-present_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-populated_zone-instead-of-ifzone-present_pages
+++ a/mm/page_alloc.c
@@ -4266,7 +4266,7 @@ static __meminit void zone_pcp_init(stru
 	 */
 	zone->pageset = &boot_pageset;
 
-	if (zone->present_pages)
+	if (populated_zone(zone))
 		printk(KERN_DEBUG "  %s zone: %lu pages, LIFO batch:%u\n",
 			zone->name, zone->present_pages,
 					 zone_batchsize(zone));
@@ -5160,7 +5160,7 @@ static void check_for_memory(pg_data_t *
 
 	for (zone_type = 0; zone_type <= ZONE_MOVABLE - 1; zone_type++) {
 		struct zone *zone = &pgdat->node_zones[zone_type];
-		if (zone->present_pages) {
+		if (populated_zone(zone)) {
 			node_set_state(nid, N_HIGH_MEMORY);
 			if (N_NORMAL_MEMORY != N_HIGH_MEMORY &&
 			    zone_type <= ZONE_NORMAL)
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

origin.patch
linux-next.patch

