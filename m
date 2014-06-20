From: akpm@linux-foundation.org
Subject: + mem-hotplug-improve-zone_movable_is_highmem-logic.patch added
 to -mm tree
Date: Fri, 20 Jun 2014 15:18:27 -0700
Message-ID: <53a4b333.2ovew6zflEKfzRty%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948AbaFTWS2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jun 2014 18:18:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangzhen@huawei.com, yinghai@kernel.org, mgorman@suse.de, lizefan@huawei.com, liuj97@gmail.com, wangnan0@huawei.com


The patch titled
     Subject: mem-hotplug: improve zone_movable_is_highmem logic
has been added to the -mm tree.  Its filename is
     mem-hotplug-improve-zone_movable_is_highmem-logic.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-improve-zone_movable_is_highmem-logic.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-improve-zone_movable_is_highmem-logic.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mem-hotplug-improve-zone_movable_is_highmem-logic.patch

