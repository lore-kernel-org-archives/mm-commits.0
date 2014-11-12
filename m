From: akpm@linux-foundation.org
Subject: +
 mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat.patch
 added to -mm tree
Date: Wed, 12 Nov 2014 13:28:41 -0800
Message-ID: <5463d109.ZivfffXPZwi4BL1g%akpm__30540.4651714072$1415827739$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49276 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbaKLV2m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 12 Nov 2014 16:28:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tangchen@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mem-hotplug: reset node managed pages when hot-adding a new pgdat
has been added to the -mm tree.  Its filename is
     mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat.patch
		echo and later at
		echo  http://ozlabs.org/~akpm/mmotm/broken-out/mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat.patch

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
Subject: mem-hotplug: reset node managed pages when hot-adding a new pgdat

In free_area_init_core(), zone->managed_pages is set to an approximate
value for lowmem, and will be adjusted when the bootmem allocator frees
pages into the buddy system.  But free_area_init_core() is also called by
hotadd_new_pgdat() when hot-adding memory.  As a result,
zone->managed_pages of the newly added node's pgdat is set to an
approximate value in the very beginning.  Even if the memory on that node
has node been onlined, /sys/device/system/node/nodeXXX/meminfo has wrong
value.

hot-add node2 (memory not onlined)
cat /sys/device/system/node/node2/meminfo
Node 2 MemTotal:       33554432 kB
Node 2 MemFree:               0 kB
Node 2 MemUsed:        33554432 kB
Node 2 Active:                0 kB

This patch fixes this problem by reset node managed pages to 0 after
hot-adding a new node.

1. Move reset_managed_pages_done from reset_node_managed_pages() to
   reset_all_zones_managed_pages()
2. Make reset_node_managed_pages() non-static
3. Call reset_node_managed_pages() in hotadd_new_pgdat() after pgdat
   is initialized

Signed-off-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: <stable@vger.kernel.org>	[3.16+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |    1 +
 mm/bootmem.c            |    9 +++++----
 mm/memory_hotplug.c     |    9 +++++++++
 mm/nobootmem.c          |    8 +++++---
 4 files changed, 20 insertions(+), 7 deletions(-)

diff -puN include/linux/bootmem.h~mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat include/linux/bootmem.h
--- a/include/linux/bootmem.h~mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat
+++ a/include/linux/bootmem.h
@@ -46,6 +46,7 @@ extern unsigned long init_bootmem_node(p
 extern unsigned long init_bootmem(unsigned long addr, unsigned long memend);
 
 extern unsigned long free_all_bootmem(void);
+extern void reset_node_managed_pages(pg_data_t *pgdat);
 extern void reset_all_zones_managed_pages(void);
 
 extern void free_bootmem_node(pg_data_t *pgdat,
diff -puN mm/bootmem.c~mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat mm/bootmem.c
--- a/mm/bootmem.c~mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat
+++ a/mm/bootmem.c
@@ -243,13 +243,10 @@ static unsigned long __init free_all_boo
 
 static int reset_managed_pages_done __initdata;
 
-static inline void __init reset_node_managed_pages(pg_data_t *pgdat)
+void reset_node_managed_pages(pg_data_t *pgdat)
 {
 	struct zone *z;
 
-	if (reset_managed_pages_done)
-		return;
-
 	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
 		z->managed_pages = 0;
 }
@@ -258,8 +255,12 @@ void __init reset_all_zones_managed_page
 {
 	struct pglist_data *pgdat;
 
+	if (reset_managed_pages_done)
+		return;
+
 	for_each_online_pgdat(pgdat)
 		reset_node_managed_pages(pgdat);
+
 	reset_managed_pages_done = 1;
 }
 
diff -puN mm/memory_hotplug.c~mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat
+++ a/mm/memory_hotplug.c
@@ -31,6 +31,7 @@
 #include <linux/stop_machine.h>
 #include <linux/hugetlb.h>
 #include <linux/memblock.h>
+#include <linux/bootmem.h>
 
 #include <asm/tlbflush.h>
 
@@ -1096,6 +1097,14 @@ static pg_data_t __ref *hotadd_new_pgdat
 	build_all_zonelists(pgdat, NULL);
 	mutex_unlock(&zonelists_mutex);
 
+	/*
+	 * zone->managed_pages is set to an approximate value in
+	 * free_area_init_core(), which will cause
+	 * /sys/device/system/node/nodeX/meminfo has wrong data.
+	 * So reset it to 0 before any memory is onlined.
+	 */
+	reset_node_managed_pages(pgdat);
+
 	return pgdat;
 }
 
diff -puN mm/nobootmem.c~mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat mm/nobootmem.c
--- a/mm/nobootmem.c~mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat
+++ a/mm/nobootmem.c
@@ -145,12 +145,10 @@ static unsigned long __init free_low_mem
 
 static int reset_managed_pages_done __initdata;
 
-static inline void __init reset_node_managed_pages(pg_data_t *pgdat)
+void reset_node_managed_pages(pg_data_t *pgdat)
 {
 	struct zone *z;
 
-	if (reset_managed_pages_done)
-		return;
 	for (z = pgdat->node_zones; z < pgdat->node_zones + MAX_NR_ZONES; z++)
 		z->managed_pages = 0;
 }
@@ -159,8 +157,12 @@ void __init reset_all_zones_managed_page
 {
 	struct pglist_data *pgdat;
 
+	if (reset_managed_pages_done)
+		return;
+
 	for_each_online_pgdat(pgdat)
 		reset_node_managed_pages(pgdat);
+
 	reset_managed_pages_done = 1;
 }
 
_

Patches currently in -mm which might be from tangchen@cn.fujitsu.com are

mm-page_alloc-fix-incorrect-isolation-behavior-by-rechecking-migratetype.patch
mm-page_alloc-add-freepage-on-isolate-pageblock-to-correct-buddy-list.patch
mm-page_alloc-move-freepage-counting-logic-to-__free_one_page.patch
mm-page_alloc-restrict-max-order-of-merging-on-isolated-pageblock.patch
mem-hotplug-reset-node-managed-pages-when-hot-adding-a-new-pgdat.patch
mem-hotplug-reset-node-present-pages-when-hot-adding-a-new-pgdat.patch
memblock-refactor-functions-to-set-clear-memblock_hotplug.patch

