From: akpm@linux-foundation.org
Subject: [merged]
 mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:43:47 -0700
Message-ID: <52321973.BYZGf+DMftUR3zxr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58250 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab3ILTnr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:43:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, cody@linux.vnet.ibm.com, qiuxishi@huawei.com

Subject: [merged] mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch removed from -mm tree
To: qiuxishi@huawei.com,cody@linux.vnet.ibm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:43:47 -0700


The patch titled
     Subject: mm: use zone_is_empty() instead of if(zone->spanned_pages)
has been removed from the -mm tree.  Its filename was
     mm-use-zone_is_empty-instead-of-ifzone-spanned_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Xishi Qiu <qiuxishi@huawei.com>
Subject: mm: use zone_is_empty() instead of if(zone->spanned_pages)

Use "zone_is_empty()" instead of "if (zone->spanned_pages)".
Simplify the code, no functional change.

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |    6 +++---
 mm/page_alloc.c     |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff -puN mm/memory_hotplug.c~mm-use-zone_is_empty-instead-of-ifzone-spanned_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-use-zone_is_empty-instead-of-ifzone-spanned_pages
+++ a/mm/memory_hotplug.c
@@ -230,7 +230,7 @@ static void grow_zone_span(struct zone *
 	zone_span_writelock(zone);
 
 	old_zone_end_pfn = zone_end_pfn(zone);
-	if (!zone->spanned_pages || start_pfn < zone->zone_start_pfn)
+	if (zone_is_empty(zone) || start_pfn < zone->zone_start_pfn)
 		zone->zone_start_pfn = start_pfn;
 
 	zone->spanned_pages = max(old_zone_end_pfn, end_pfn) -
@@ -305,7 +305,7 @@ static int __meminit move_pfn_range_left
 		goto out_fail;
 
 	/* use start_pfn for z1's start_pfn if z1 is empty */
-	if (z1->spanned_pages)
+	if (!zone_is_empty(z1))
 		z1_start_pfn = z1->zone_start_pfn;
 	else
 		z1_start_pfn = start_pfn;
@@ -347,7 +347,7 @@ static int __meminit move_pfn_range_righ
 		goto out_fail;
 
 	/* use end_pfn for z2's end_pfn if z2 is empty */
-	if (z2->spanned_pages)
+	if (!zone_is_empty(z2))
 		z2_end_pfn = zone_end_pfn(z2);
 	else
 		z2_end_pfn = end_pfn;
diff -puN mm/page_alloc.c~mm-use-zone_is_empty-instead-of-ifzone-spanned_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-zone_is_empty-instead-of-ifzone-spanned_pages
+++ a/mm/page_alloc.c
@@ -1306,7 +1306,7 @@ void mark_free_pages(struct zone *zone)
 	int order, t;
 	struct list_head *curr;
 
-	if (!zone->spanned_pages)
+	if (zone_is_empty(zone))
 		return;
 
 	spin_lock_irqsave(&zone->lock, flags);
_

Patches currently in -mm which might be from qiuxishi@huawei.com are

origin.patch

