From: akpm@linux-foundation.org
Subject: +
 mem-hotplug-fix-wrong-check-for-zone-pageset-initialization-in-online_pages.patch added to -mm tree
Date: Tue, 04 Nov 2014 12:37:06 -0800
Message-ID: <545938f2.DgoULAqDp5Mf8gNP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47627 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaKDUhG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Nov 2014 15:37:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, grygorii.strashko@ti.com, guz.fnst@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, phacht@linux.vnet.ibm.com, qiuxishi@huawei.com, santosh.shilimkar@ti.com, wangnan0@huawei.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: Fix wrong check for zone->pageset initialization in online_pages().
has been added to the -mm tree.  Its filename is
     mem-hotplug-fix-wrong-check-for-zone-pageset-initialization-in-online_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-fix-wrong-check-for-zone-pageset-initialization-in-online_pages.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-fix-wrong-check-for-zone-pageset-initialization-in-online_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: mem-hotplug: Fix wrong check for zone->pageset initialization in online_pages().

When we are doing memory hot-add, the following functions are called:

add_memory()
|--> hotadd_new_pgdat()
     |--> free_area_init_node()
          |--> free_area_init_core()
               |--> zone->present_pages = realsize;           /* 1. zone is populated */
                    |--> zone_pcp_init()
                         |--> zone->pageset = &boot_pageset;  /* 2. zone->pageset is set to boot_pageset */

There are two problems here:
1. Zones could be populated before any memory is onlined.
2. All the zones on a newly added node have the same pageset pointing to boot_pageset.

The above two problems will result in the following problem:
When we online memory on one node, e.g node2, the following code is executed:

online_pages()
{
        ......
        if (!populated_zone(zone)) {
                need_zonelists_rebuild = 1;
                build_all_zonelists(NULL, zone);
        }
        ......
}

Because of problem 1, the zone has been populated, and the build_all_zonelists()
                      will never called. zone->pageset won't be updated.
Because of problem 2, All the zones on a newly added node have the same pageset
                      pointing to boot_pageset.
And as a result, when we online memory on node2, node3's meminfo will corrupt.
Pages on node2 may be freed to node3.

# for ((i = 2048; i < 2064; i++)); do echo online_movable > /sys/devices/system/node/node2/memory$i/state; done
# cat /sys/devices/system/node/node2/meminfo
Node 2 MemTotal:       33554432 kB
Node 2 MemFree:        33549092 kB
Node 2 MemUsed:            5340 kB
......
# cat /sys/devices/system/node/node3/meminfo
Node 3 MemTotal:              0 kB
Node 3 MemFree:               248 kB                    /* corrupted */
Node 3 MemUsed:               0 kB
......

We have to populate some zones before onlining memory, otherwise no memory could be onlined.
So when onlining pages, we should also check if zone->pageset is pointing to boot_pageset.

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Cc: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h  |    1 +
 mm/memory_hotplug.c |    6 +++++-
 mm/page_alloc.c     |    5 +++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff -puN include/linux/mm.h~mem-hotplug-fix-wrong-check-for-zone-pageset-initialization-in-online_pages include/linux/mm.h
--- a/include/linux/mm.h~mem-hotplug-fix-wrong-check-for-zone-pageset-initialization-in-online_pages
+++ a/include/linux/mm.h
@@ -1732,6 +1732,7 @@ void warn_alloc_failed(gfp_t gfp_mask, i
 
 extern void setup_per_cpu_pageset(void);
 
+extern bool zone_pcp_initialized(struct zone *zone);
 extern void zone_pcp_update(struct zone *zone);
 extern void zone_pcp_reset(struct zone *zone);
 
diff -puN mm/memory_hotplug.c~mem-hotplug-fix-wrong-check-for-zone-pageset-initialization-in-online_pages mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-fix-wrong-check-for-zone-pageset-initialization-in-online_pages
+++ a/mm/memory_hotplug.c
@@ -1013,9 +1013,13 @@ int __ref online_pages(unsigned long pfn
 	 * If this zone is not populated, then it is not in zonelist.
 	 * This means the page allocator ignores this zone.
 	 * So, zonelist must be updated after online.
+	 *
+	 * If this zone is populated, zone->pageset could be initialized
+	 * to boot_pageset for the first time a node is added. If so,
+	 * zone->pageset should be allocated.
 	 */
 	mutex_lock(&zonelists_mutex);
-	if (!populated_zone(zone)) {
+	if (!populated_zone(zone) || !zone_pcp_initialized(zone)) {
 		need_zonelists_rebuild = 1;
 		build_all_zonelists(NULL, zone);
 	}
diff -puN mm/page_alloc.c~mem-hotplug-fix-wrong-check-for-zone-pageset-initialization-in-online_pages mm/page_alloc.c
--- a/mm/page_alloc.c~mem-hotplug-fix-wrong-check-for-zone-pageset-initialization-in-online_pages
+++ a/mm/page_alloc.c
@@ -6453,6 +6453,11 @@ void __meminit zone_pcp_update(struct zo
 }
 #endif
 
+bool zone_pcp_initialized(struct zone *zone)
+{
+	return (zone->pageset != &boot_pageset);
+}
+
 void zone_pcp_reset(struct zone *zone)
 {
 	unsigned long flags;
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat.patch
mem-hotplug-fix-wrong-check-for-zone-pageset-initialization-in-online_pages.patch

