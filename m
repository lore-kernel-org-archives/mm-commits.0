From: akpm@linux-foundation.org
Subject: [withdrawn]
 memory-hotplug-tile-suitable-memory-should-go-to-zone_movable.patch removed from -mm tree
Date: Tue, 22 Jul 2014 13:08:24 -0700
Message-ID: <53cec4b8.WyCtb9m6twDJJ12F%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f73.google.com ([209.85.218.73]:46270 "EHLO
	mail-oi0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756765AbaGVUI0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jul 2014 16:08:26 -0400
Received: by mail-oi0-f73.google.com with SMTP id u20so39158oif.2
        for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2014 13:08:25 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wangnan0@huawei.com, benh@kernel.crashing.org, cmetcalf@tilera.com, dave.hansen@intel.com, hpa@zytor.com, mgorman@suse.de, mingo@redhat.com, paulus@samba.org, tglx@linutronix.de, tony.luck@intel.com, yinghai@kernel.org, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memory-hotplug: tile: suitable memory should go to ZONE_MOVABLE
has been removed from the -mm tree.  Its filename was
     memory-hotplug-tile-suitable-memory-should-go-to-zone_movable.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Wang Nan <wangnan0@huawei.com>
Subject: memory-hotplug: tile: suitable memory should go to ZONE_MOVABLE

This patch introduces zone_for_memory() to arch_add_memory() on tile to
ensure new, higher memory added into ZONE_MOVABLE if movable zone has
already setup.

This patch also fix a problem: on tile, new memory should be added into
ZONE_HIGHMEM by default, not MAX_NR_ZONES-1, which is ZONE_MOVABLE.

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

 arch/tile/mm/init.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/tile/mm/init.c~memory-hotplug-tile-suitable-memory-should-go-to-zone_movable arch/tile/mm/init.c
--- a/arch/tile/mm/init.c~memory-hotplug-tile-suitable-memory-should-go-to-zone_movable
+++ a/arch/tile/mm/init.c
@@ -872,7 +872,8 @@ void __init mem_init(void)
 int arch_add_memory(u64 start, u64 size)
 {
 	struct pglist_data *pgdata = &contig_page_data;
-	struct zone *zone = pgdata->node_zones + MAX_NR_ZONES-1;
+	struct zone *zone = pgdata->node_zones +
+		zone_for_memory(nid, start, size, ZONE_HIGHMEM);
 	unsigned long start_pfn = start >> PAGE_SHIFT;
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 
_

Patches currently in -mm which might be from wangnan0@huawei.com are

mem-hotplug-improve-zone_movable_is_highmem-logic.patch
memory-hotplug-add-zone_for_memory-for-selecting-zone-for-new-memory.patch
memory-hotplug-x86_64-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-x86_32-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-ia64-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-ppc-suitable-memory-should-go-to-zone_movable.patch
memory-hotplug-sh-suitable-memory-should-go-to-zone_movable.patch
linux-next.patch

