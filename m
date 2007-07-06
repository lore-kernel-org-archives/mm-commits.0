From: akpm@linux-foundation.org
Subject: + memory-unplug-v7-memory-hotplug-cleanup.patch added to -mm tree
Date: Fri, 06 Jul 2007 15:31:43 -0700
Message-ID: <200707062231.l66MVhc8024142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56281 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754834AbXGFWbv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Jul 2007 18:31:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memory unplug: memory hotplug cleanup
has been added to the -mm tree.  Its filename is
     memory-unplug-v7-memory-hotplug-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: memory unplug: memory hotplug cleanup
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

A clean up patch for "scanning memory resource [start, end)" operation.

Now, find_next_system_ram() function is used in memory hotplug, but this
interface is not easy to use and codes are complicated.

This patch adds walk_memory_resouce(start,len,arg,func) function.
The function 'func' is called per valid memory resouce range in [start,pfn).

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/ioport.h         |    3 --
 include/linux/memory_hotplug.h |    8 +++++
 kernel/resource.c              |   26 +++++++++++++++++
 mm/memory_hotplug.c            |   45 +++++++++++++------------------
 4 files changed, 52 insertions(+), 30 deletions(-)

diff -puN include/linux/ioport.h~memory-unplug-v7-memory-hotplug-cleanup include/linux/ioport.h
--- a/include/linux/ioport.h~memory-unplug-v7-memory-hotplug-cleanup
+++ a/include/linux/ioport.h
@@ -110,9 +110,6 @@ extern int allocate_resource(struct reso
 int adjust_resource(struct resource *res, resource_size_t start,
 		    resource_size_t size);
 
-/* get registered SYSTEM_RAM resources in specified area */
-extern int find_next_system_ram(struct resource *res);
-
 /* Convenience shorthand with allocation */
 #define request_region(start,n,name)	__request_region(&ioport_resource, (start), (n), (name))
 #define request_mem_region(start,n,name) __request_region(&iomem_resource, (start), (n), (name))
diff -puN include/linux/memory_hotplug.h~memory-unplug-v7-memory-hotplug-cleanup include/linux/memory_hotplug.h
--- a/include/linux/memory_hotplug.h~memory-unplug-v7-memory-hotplug-cleanup
+++ a/include/linux/memory_hotplug.h
@@ -64,6 +64,14 @@ extern int online_pages(unsigned long, u
 extern int __add_pages(struct zone *zone, unsigned long start_pfn,
 	unsigned long nr_pages);
 
+/*
+ * Walk thorugh all memory which is registered as resource.
+ * arg is (start_pfn, nr_pages, private_arg_pointer)
+ */
+extern int walk_memory_resource(unsigned long start_pfn,
+			unsigned long nr_pages, void *arg,
+			int (*func)(unsigned long, unsigned long, void *));
+
 #ifdef CONFIG_NUMA
 extern int memory_add_physaddr_to_nid(u64 start);
 #else
diff -puN kernel/resource.c~memory-unplug-v7-memory-hotplug-cleanup kernel/resource.c
--- a/kernel/resource.c~memory-unplug-v7-memory-hotplug-cleanup
+++ a/kernel/resource.c
@@ -234,7 +234,7 @@ EXPORT_SYMBOL(release_resource);
  * the caller must specify res->start, res->end, res->flags.
  * If found, returns 0, res is overwritten, if not found, returns -1.
  */
-int find_next_system_ram(struct resource *res)
+static int find_next_system_ram(struct resource *res)
 {
 	resource_size_t start, end;
 	struct resource *p;
@@ -267,6 +267,30 @@ int find_next_system_ram(struct resource
 		res->end = p->end;
 	return 0;
 }
+int
+walk_memory_resource(unsigned long start_pfn, unsigned long nr_pages, void *arg,
+			int (*func)(unsigned long, unsigned long, void *))
+{
+	struct resource res;
+	unsigned long pfn, len;
+	u64 orig_end;
+	int ret;
+	res.start = (u64) start_pfn << PAGE_SHIFT;
+	res.end = ((u64)(start_pfn + nr_pages) << PAGE_SHIFT) - 1;
+	res.flags = IORESOURCE_MEM;
+	orig_end = res.end;
+	while ((res.start < res.end) && (find_next_system_ram(&res) >= 0)) {
+		pfn = (unsigned long)(res.start >> PAGE_SHIFT);
+		len = (unsigned long)((res.end + 1 - res.start) >> PAGE_SHIFT);
+		ret = (*func)(pfn, len, arg);
+		if (ret)
+			break;
+		res.start = res.end + 1;
+		res.end = orig_end;
+	}
+	return ret;
+}
+
 #endif
 
 /*
diff -puN mm/memory_hotplug.c~memory-unplug-v7-memory-hotplug-cleanup mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~memory-unplug-v7-memory-hotplug-cleanup
+++ a/mm/memory_hotplug.c
@@ -161,14 +161,27 @@ static void grow_pgdat_span(struct pglis
 					pgdat->node_start_pfn;
 }
 
-int online_pages(unsigned long pfn, unsigned long nr_pages)
+static int online_pages_range(unsigned long start_pfn, unsigned long nr_pages,
+			void *arg)
 {
 	unsigned long i;
+	unsigned long onlined_pages = *(unsigned long *)arg;
+	struct page *page;
+	if (PageReserved(pfn_to_page(start_pfn)))
+		for (i = 0; i < nr_pages; i++) {
+			page = pfn_to_page(start_pfn + i);
+			online_page(page);
+			onlined_pages++;
+		}
+	*(unsigned long *)arg = onlined_pages;
+	return 0;
+}
+
+
+int online_pages(unsigned long pfn, unsigned long nr_pages)
+{
 	unsigned long flags;
 	unsigned long onlined_pages = 0;
-	struct resource res;
-	u64 section_end;
-	unsigned long start_pfn;
 	struct zone *zone;
 	int need_zonelists_rebuild = 0;
 
@@ -191,28 +204,8 @@ int online_pages(unsigned long pfn, unsi
 	if (!populated_zone(zone))
 		need_zonelists_rebuild = 1;
 
-	res.start = (u64)pfn << PAGE_SHIFT;
-	res.end = res.start + ((u64)nr_pages << PAGE_SHIFT) - 1;
-	res.flags = IORESOURCE_MEM; /* we just need system ram */
-	section_end = res.end;
-
-	while ((res.start < res.end) && (find_next_system_ram(&res) >= 0)) {
-		start_pfn = (unsigned long)(res.start >> PAGE_SHIFT);
-		nr_pages = (unsigned long)
-                           ((res.end + 1 - res.start) >> PAGE_SHIFT);
-
-		if (PageReserved(pfn_to_page(start_pfn))) {
-			/* this region's page is not onlined now */
-			for (i = 0; i < nr_pages; i++) {
-				struct page *page = pfn_to_page(start_pfn + i);
-				online_page(page);
-				onlined_pages++;
-			}
-		}
-
-		res.start = res.end + 1;
-		res.end = section_end;
-	}
+	walk_memory_resource(pfn, nr_pages, &onlined_pages,
+		online_pages_range);
 	zone->present_pages += onlined_pages;
 	zone->zone_pgdat->node_present_pages += onlined_pages;
 
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

change-zonelist-order-zonelist-order-selection-logic.patch
change-zonelist-order-zonelist-order-selection-logic-add-check_highest_zone-to-build_zonelists_in_zone_order.patch
change-zonelist-order-v6-zonelist-fix.patch
change-zonelist-order-v6-zonelist-fix-2.patch
change-zonelist-order-auto-configuration.patch
change-zonelist-order-documentaion.patch
memory-unplug-v7-migration-by-kernel.patch
memory-unplug-v7-isolate_lru_page-fix.patch
memory-unplug-v7-memory-hotplug-cleanup.patch
memory-unplug-v7-page-isolation.patch
memory-unplug-v7-page-offline.patch
memory-unplug-v7-ia64-interface.patch
