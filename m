From: akpm@linux-foundation.org
Subject: + mm-use-populated_zone-instead-of-ifzone-present_pages.patch
 added to -mm tree
Date: Wed, 18 Sep 2013 16:17:15 -0700
Message-ID: <523a347b.IMzMU7r9aAtIEtWr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47894 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3IRXRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 19:17:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, qiuxishi@huawei.com

Subject: + mm-use-populated_zone-instead-of-ifzone-present_pages.patch added to -mm tree
To: qiuxishi@huawei.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 16:17:15 -0700


The patch titled
     Subject: mm: use populated_zone() instead of if(zone->present_pages)
has been added to the -mm tree.  Its filename is
     mm-use-populated_zone-instead-of-ifzone-present_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-populated_zone-instead-of-ifzone-present_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-populated_zone-instead-of-ifzone-present_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-arch-use-__free_reserved_page-to-simplify-the-code.patch
drivers-video-acornfbc-use-__free_reserved_page-to-simplify-the-code.patch
mm-use-pgdat_end_pfn-to-simplify-the-code-in-arch.patch
mm-use-pgdat_end_pfn-to-simplify-the-code-in-others.patch
mm-use-populated_zone-instead-of-ifzone-present_pages.patch
documentation-dma-attributestxt-fix-typo.patch

