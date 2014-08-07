From: akpm@linux-foundation.org
Subject: [merged]
 memory-hotplug-ia64-suitable-memory-should-go-to-zone_movable.patch removed from -mm tree
Date: Thu, 07 Aug 2014 13:06:09 -0700
Message-ID: <53e3dc31.qb3gs3YoMMCSQ3N9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:42360 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaHGUGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:10 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1177914pab.1
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:09 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangnan0@huawei.com, benh@kernel.crashing.org, cmetcalf@tilera.com, dave.hansen@intel.com, hpa@zytor.com, mgorman@suse.de, mingo@redhat.com, paulus@samba.org, tglx@linutronix.de, tony.luck@intel.com, yinghai@kernel.org, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: ia64: suitable memory should go to ZONE_MOVABLE
has been removed from the -mm tree.  Its filename was
     memory-hotplug-ia64-suitable-memory-should-go-to-zone_movable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Nan <wangnan0@huawei.com>
Subject: memory-hotplug: ia64: suitable memory should go to ZONE_MOVABLE

This patch introduces zone_for_memory() to arch_add_memory() on ia64 to
ensure new, higher memory added into ZONE_MOVABLE if movable zone has
already setup.

Signed-off-by: Wang Nan <wangnan0@huawei.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Mel Gorman" <mgorman@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/ia64/mm/init.c~memory-hotplug-ia64-suitable-memory-should-go-to-zone_movable arch/ia64/mm/init.c
--- a/arch/ia64/mm/init.c~memory-hotplug-ia64-suitable-memory-should-go-to-zone_movable
+++ a/arch/ia64/mm/init.c
@@ -631,7 +631,8 @@ int arch_add_memory(int nid, u64 start,
 
 	pgdat = NODE_DATA(nid);
 
-	zone = pgdat->node_zones + ZONE_NORMAL;
+	zone = pgdat->node_zones +
+		zone_for_memory(nid, start, size, ZONE_NORMAL);
 	ret = __add_pages(nid, zone, start_pfn, nr_pages);
 
 	if (ret)
_

Patches currently in -mm which might be from wangnan0@huawei.com are

origin.patch

