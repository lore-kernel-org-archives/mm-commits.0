From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-reset-the-zone-watermark_boost-early.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:18:19 -0700
Message-ID: <20200604171819.UbN9gjnQF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730116AbgFDRSU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:18:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bhe@redhat.com, charante@codeaurora.org, mm-commits@vger.kernel.org, vinmenon@codeaurora.org


The patch titled
     Subject: mm, page_alloc: reset the zone->watermark_boost early
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-reset-the-zone-watermark_boost-early.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Charan Teja Reddy <charante@codeaurora.org>
Subject: mm, page_alloc: reset the zone->watermark_boost early

Updating the zone watermarks by any means, like min_free_kbytes,
water_mark_scale_factor etc, when ->watermark_boost is set will result in
higher low and high watermarks than the user asked.

Below are the steps to reproduce the problem on system setup of Android
kernel running on Snapdragon hardware.

1) Default settings of the system are as below:

   #cat /proc/sys/vm/min_free_kbytes = 5162
   #cat /proc/zoneinfo | grep -e boost -e low -e "high " -e min -e Node
	Node 0, zone   Normal
		min      797
		low      8340
		high     8539

2) Monitor the zone->watermark_boost(by adding a debug print in the
   kernel) and whenever it is greater than zero value, write the same
   value of min_free_kbytes obtained from step 1.

   #echo 5162 > /proc/sys/vm/min_free_kbytes

3) Then read the zone watermarks in the system while the
   ->watermark_boost is zero.  This should show the same values of
   watermarks as step 1 but shown a higher values than asked.

   #cat /proc/zoneinfo | grep -e boost -e low -e "high " -e min -e Node
	Node 0, zone   Normal
		min      797
		low      21148
		high     21347

These higher values are because of updating the zone watermarks using the
macro min_wmark_pages(zone) which also adds the zone->watermark_boost.

	#define min_wmark_pages(z) (z->_watermark[WMARK_MIN] +
					z->watermark_boost)

So the steps that lead to the issue are:

1) On the extfrag event, watermarks are boosted by storing the required
   value in ->watermark_boost.

2) User tries to update the zone watermarks level in the system through
   min_free_kbytes or watermark_scale_factor.

3) Later, when kswapd woke up, it resets the zone->watermark_boost to
   zero.

In step 2), we use the min_wmark_pages() macro to store the watermarks
in the zone structure thus the values are always offsetted by
->watermark_boost value. This can be avoided by resetting the
->watermark_boost to zero before it is used.

Link: http://lkml.kernel.org/r/1589457511-4255-1-git-send-email-charante@codeaurora.org
Signed-off-by: Charan Teja Reddy <charante@codeaurora.org>
Reviewed-by: Baoquan He <bhe@redhat.com>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-reset-the-zone-watermark_boost-early
+++ a/mm/page_alloc.c
@@ -7788,9 +7788,9 @@ static void __setup_per_zone_wmarks(void
 			    mult_frac(zone_managed_pages(zone),
 				      watermark_scale_factor, 10000));
 
+		zone->watermark_boost = 0;
 		zone->_watermark[WMARK_LOW]  = min_wmark_pages(zone) + tmp;
 		zone->_watermark[WMARK_HIGH] = min_wmark_pages(zone) + tmp * 2;
-		zone->watermark_boost = 0;
 
 		spin_unlock_irqrestore(&zone->lock, flags);
 	}
_

Patches currently in -mm which might be from charante@codeaurora.org are

mm-page_alloc-skip-waternark_boost-for-atomic-order-0-allocations.patch
