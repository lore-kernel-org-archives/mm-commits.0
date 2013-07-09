From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-unused-functions-is_normal_idx-normal-dma32-dma.patch removed
 from -mm tree
Date: Tue, 09 Jul 2013 16:19:53 -0700
Message-ID: <51dc9a99.hoZEP8nettzga+d+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab3GIXTx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jul 2013 19:19:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com

Subject: [merged] mm-remove-unused-functions-is_normal_idx-normal-dma32-dma.patch removed from -mm tree
To: zhangyanfei@cn.fujitsu.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 09 Jul 2013 16:19:53 -0700


The patch titled
     Subject: mm: remove unused functions is_{normal_idx, normal, dma32, dma}
has been removed from the -mm tree.  Its filename was
     mm-remove-unused-functions-is_normal_idx-normal-dma32-dma.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: mm: remove unused functions is_{normal_idx, normal, dma32, dma}

These functions are nowhere used, so remove them.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   28 ----------------------------
 1 file changed, 28 deletions(-)

diff -puN include/linux/mmzone.h~mm-remove-unused-functions-is_normal_idx-normal-dma32-dma include/linux/mmzone.h
--- a/include/linux/mmzone.h~mm-remove-unused-functions-is_normal_idx-normal-dma32-dma
+++ a/include/linux/mmzone.h
@@ -869,11 +869,6 @@ static inline int is_highmem_idx(enum zo
 #endif
 }
 
-static inline int is_normal_idx(enum zone_type idx)
-{
-	return (idx == ZONE_NORMAL);
-}
-
 /**
  * is_highmem - helper function to quickly check if a struct zone is a 
  *              highmem zone or not.  This is an attempt to keep references
@@ -890,29 +885,6 @@ static inline int is_highmem(struct zone
 #else
 	return 0;
 #endif
-}
-
-static inline int is_normal(struct zone *zone)
-{
-	return zone == zone->zone_pgdat->node_zones + ZONE_NORMAL;
-}
-
-static inline int is_dma32(struct zone *zone)
-{
-#ifdef CONFIG_ZONE_DMA32
-	return zone == zone->zone_pgdat->node_zones + ZONE_DMA32;
-#else
-	return 0;
-#endif
-}
