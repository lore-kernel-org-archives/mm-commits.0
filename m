From: akpm@linux-foundation.org
Subject: [merged]
 memory-hotplug-sh-suitable-memory-should-go-to-zone_movable.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:06:13 -0700
Message-ID: <53e3dc35.Sc/GjuyVpoNs7eWf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f201.google.com ([209.85.223.201]:36183 "EHLO
	mail-ie0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaHGUGO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:06:14 -0400
Received: by mail-ie0-f201.google.com with SMTP id tr6so841681ieb.4
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:06:13 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangnan0@huawei.com, benh@kernel.crashing.org, cmetcalf@tilera.com, dave.hansen@intel.com, hpa@zytor.com, mgorman@suse.de, mingo@redhat.com, paulus@samba.org, tglx@linutronix.de, tony.luck@intel.com, yinghai@kernel.org, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: sh: suitable memory should go to ZONE_MOVABLE
has been removed from the -mm tree.  Its filename was
     memory-hotplug-sh-suitable-memory-should-go-to-zone_movable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Nan <wangnan0@huawei.com>
Subject: memory-hotplug: sh: suitable memory should go to ZONE_MOVABLE

This patch introduces zone_for_memory() to arch_add_memory() on sh to
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

 arch/sh/mm/init.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN arch/sh/mm/init.c~memory-hotplug-sh-suitable-memory-should-go-to-zone_movable arch/sh/mm/init.c
--- a/arch/sh/mm/init.c~memory-hotplug-sh-suitable-memory-should-go-to-zone_movable
+++ a/arch/sh/mm/init.c
@@ -495,8 +495,9 @@ int arch_add_memory(int nid, u64 start,
 	pgdat = NODE_DATA(nid);
 
 	/* We only have ZONE_NORMAL, so this is easy.. */
-	ret = __add_pages(nid, pgdat->node_zones + ZONE_NORMAL,
-				start_pfn, nr_pages);
+	ret = __add_pages(nid, pgdat->node_zones +
+			zone_for_memory(nid, start, size, ZONE_NORMAL),
+			start_pfn, nr_pages);
 	if (unlikely(ret))
 		printk("%s: Failed, __add_pages() == %d\n", __func__, ret);
 
_

Patches currently in -mm which might be from wangnan0@huawei.com are

origin.patch

