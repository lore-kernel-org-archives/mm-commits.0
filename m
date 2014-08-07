From: akpm@linux-foundation.org
Subject: [merged] mem-hotplug-improve-zone_movable_is_highmem-logic.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:04:43 -0700
Message-ID: <53e3dbdb.KvMgR+js+mt5UsFz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:53160 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573AbaHGUEo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:04:44 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so1175891pab.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:04:43 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangnan0@huawei.com, liuj97@gmail.com, lizefan@huawei.com, mgorman@suse.de, yinghai@kernel.org, zhangzhen@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: improve zone_movable_is_highmem logic
has been removed from the -mm tree.  Its filename was
     mem-hotplug-improve-zone_movable_is_highmem-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Nan <wangnan0@huawei.com>
Subject: mem-hotplug: improve zone_movable_is_highmem logic

In original code, zone_movable_is_highmem() assumes ZONE_MOVABLE not
highmem if CONFIG_HAVE_MEMBLOCK_NODE_MAP is not set.  In online_pages, it
extracts pages from the previous zone before ZONE_MOVABLE.  Which is
logically inconsistent:

If HAVE_MEMBLOCK_NODE_MAP is turned off but HIGHMEM is on,
zone_movable_is_highmem() makes movable zone not highmem, but
online_pages() extracts pages from ZONE_HIGHMEM.

This inconsistency doesn't cause real problem currently, because all
architectures support online_pages also have HAVE_MEMBLOCK_NODE_MAP. 
However, fixing it makes code clear, and also helps futher coding.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Zhang Zhen <zhangzhen@huawei.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/mmzone.h~mem-hotplug-improve-zone_movable_is_highmem-logic include/linux/mmzone.h
--- a/include/linux/mmzone.h~mem-hotplug-improve-zone_movable_is_highmem-logic
+++ a/include/linux/mmzone.h
@@ -872,6 +872,8 @@ static inline int zone_movable_is_highme
 {
 #if defined(CONFIG_HIGHMEM) && defined(CONFIG_HAVE_MEMBLOCK_NODE_MAP)
 	return movable_zone == ZONE_HIGHMEM;
+#elif defined(CONFIG_HIGHMEM)
+	return (ZONE_MOVABLE - 1) == ZONE_HIGHMEM;
 #else
 	return 0;
 #endif
_

Patches currently in -mm which might be from wangnan0@huawei.com are

origin.patch

