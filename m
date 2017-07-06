From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix.patch removed from -mm tree
Date: Thu, 06 Jul 2017 15:15:19 -0700
Message-ID: <595eb677.a5oPeIWgrzVxI0Xs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60626 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751974AbdGFWPV (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 6 Jul 2017 18:15:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard.weiyang@gmail.com, mhocko@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux/mmzone.h: simplify zone_intersects()
has been removed from the -mm tree.  Its filename was
     mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix.patch

This patch was dropped because it was folded into mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online.patch

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: include/linux/mmzone.h: simplify zone_intersects()

To make sure a range intersects a zone, only two comparisons are
necessary.  Simplify the function a little.

Link: http://lkml.kernel.org/r/20170616092335.5177-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff -puN include/linux/mmzone.h~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix
+++ a/include/linux/mmzone.h
@@ -541,15 +541,11 @@ static inline bool zone_intersects(struc
 {
 	if (zone_is_empty(zone))
 		return false;
-	if (start_pfn >= zone_end_pfn(zone))
+	if (start_pfn >= zone_end_pfn(zone) ||
+	    start_pfn + nr_pages <= zone->zone_start_pfn)
 		return false;
 
-	if (zone->zone_start_pfn <= start_pfn)
-		return true;
-	if (start_pfn + nr_pages > zone->zone_start_pfn)
-		return true;
