From: akpm@linux-foundation.org
Subject: - bootmem-add-debugging-framework.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:52 -0700
Message-ID: <200807242323.m6ONNq1t010724@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44921 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754649AbYGXXX5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, mm-commits@vger.kernel.org


The patch titled
     bootmem: add debugging framework
has been removed from the -mm tree.  Its filename was
     bootmem-add-debugging-framework.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: add debugging framework
From: Johannes Weiner <hannes@saeurebad.de>

Introduce the bootmem_debug kernel parameter that enables very verbose
diagnostics regarding all range operations of bootmem as well as the
initialization and release of nodes.

[akpm@linux-foundation.org: fix printk warnings]
Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   51 ++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 7 deletions(-)

diff -puN mm/bootmem.c~bootmem-add-debugging-framework mm/bootmem.c
--- a/mm/bootmem.c~bootmem-add-debugging-framework
+++ a/mm/bootmem.c
@@ -34,6 +34,22 @@ unsigned long saved_max_pfn;
 
 bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
 
+static int bootmem_debug;
+
+static int __init bootmem_debug_setup(char *buf)
+{
+	bootmem_debug = 1;
+	return 0;
+}
+early_param("bootmem_debug", bootmem_debug_setup);
+
+#define bdebug(fmt, args...) ({				\
+	if (unlikely(bootmem_debug))			\
+		printk(KERN_INFO			\
+			"bootmem::%s " fmt,		\
+			__FUNCTION__, ## args);		\
+})
+
 /*
  * Given an initialised bdata, it returns the size of the boot bitmap
  */
@@ -104,6 +120,9 @@ static unsigned long __init init_bootmem
 	mapsize = get_mapsize(bdata);
 	memset(bdata->node_bootmem_map, 0xff, mapsize);
 
+	bdebug("nid=%td start=%lx map=%lx end=%lx mapsize=%lx\n",
+		bdata - bootmem_node_data, start, mapstart, end, mapsize);
+
 	return mapsize;
 }
 
@@ -198,6 +217,8 @@ static unsigned long __init free_all_boo
 	count += i;
 	bdata->node_bootmem_map = NULL;
 
+	bdebug("nid=%td released=%lx\n", bdata - bootmem_node_data, count);
+
 	return count;
 }
 
@@ -255,6 +276,10 @@ static void __init free_bootmem_core(boo
 	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
 		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
+	bdebug("nid=%td start=%lx end=%lx\n", bdata - bootmem_node_data,
+		sidx + PFN_DOWN(bdata->node_boot_start),
+		eidx + PFN_DOWN(bdata->node_boot_start));
+
 	for (i = sidx; i < eidx; i++) {
 		if (unlikely(!test_and_clear_bit(i, bdata->node_bootmem_map)))
 			BUG();
@@ -360,13 +385,16 @@ static void __init reserve_bootmem_core(
 	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
 		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
-	for (i = sidx; i < eidx; i++) {
-		if (test_and_set_bit(i, bdata->node_bootmem_map)) {
-#ifdef CONFIG_DEBUG_BOOTMEM
-			printk("hm, page %08lx reserved twice.\n", i*PAGE_SIZE);
-#endif
-		}
-	}
+	bdebug("nid=%td start=%lx end=%lx flags=%x\n",
+		bdata - bootmem_node_data,
+		sidx + PFN_DOWN(bdata->node_boot_start),
+		eidx + PFN_DOWN(bdata->node_boot_start),
+		flags);
+
+	for (i = sidx; i < eidx; i++)
+		if (test_and_set_bit(i, bdata->node_bootmem_map))
+			bdebug("hm, page %lx reserved twice.\n",
+				PFN_DOWN(bdata->node_boot_start) + i);
 }
 
 /**
@@ -455,6 +483,10 @@ alloc_bootmem_core(struct bootmem_data *
 	if (!bdata->node_bootmem_map)
 		return NULL;
 
+	bdebug("nid=%td size=%lx [%lu pages] align=%lx goal=%lx limit=%lx\n",
+		bdata - bootmem_node_data, size, PAGE_ALIGN(size) >> PAGE_SHIFT,
+		align, goal, limit);
+
 	/* bdata->node_boot_start is supposed to be (12+6)bits alignment on x86_64 ? */
 	node_boot_start = bdata->node_boot_start;
 	node_bootmem_map = bdata->node_bootmem_map;
@@ -562,6 +594,11 @@ found:
 		ret = phys_to_virt(start * PAGE_SIZE + node_boot_start);
 	}
 
+	bdebug("nid=%td start=%lx end=%lx\n",
+		bdata - bootmem_node_data,
+		start + PFN_DOWN(bdata->node_boot_start),
+		start + areasize + PFN_DOWN(bdata->node_boot_start));
+
 	/*
 	 * Reserve the area now:
 	 */
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
linux-next.patch
git-xtensa.patch
documentation-update-codingstyle-tips-for-emacs-users-v2.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
alpha-use-generic-show_mem.patch
avr32-use-generic-show_mem.patch
blackfin-use-generic-show_mem.patch
xtensa-use-generic-show_mem.patch
x86-use-generic-show_mem.patch
um-use-generic-show_mem.patch
sparc64-use-generic-show_mem.patch
sh-use-generic-show_mem.patch
s390-use-generic-show_mem.patch
powerpc-use-generic-show_mem.patch
mn10300-use-generic-show_mem.patch
h8300-use-generic-show_mem.patch
mips-use-generic-show_mem.patch
m68knommu-use-generic-show_mem.patch
m68k-use-generic-show_mem.patch
m32r-use-generic-show_mem.patch
frv-use-generic-show_mem.patch
cris-use-generic-show_mem.patch

