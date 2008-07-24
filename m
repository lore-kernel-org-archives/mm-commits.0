From: akpm@linux-foundation.org
Subject: - bootmem-revisit-bitmap-size-calculations.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:23:54 -0700
Message-ID: <200807242323.m6ONNsMT010727@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49728 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753120AbYGXXX6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:23:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, mm-commits@vger.kernel.org


The patch titled
     bootmem: revisit bitmap size calculations
has been removed from the -mm tree.  Its filename was
     bootmem-revisit-bitmap-size-calculations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: bootmem: revisit bitmap size calculations
From: Johannes Weiner <hannes@saeurebad.de>

Reincarnate get_mapsize as bootmap_bytes and implement
bootmem_bootmap_pages on top of it.

Adjust users of these helpers and make free_all_bootmem_core use
bootmem_bootmap_pages instead of open-coding it.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff -puN mm/bootmem.c~bootmem-revisit-bitmap-size-calculations mm/bootmem.c
--- a/mm/bootmem.c~bootmem-revisit-bitmap-size-calculations
+++ a/mm/bootmem.c
@@ -50,17 +50,11 @@ early_param("bootmem_debug", bootmem_deb
 			__FUNCTION__, ## args);		\
 })
 
-/*
- * Given an initialised bdata, it returns the size of the boot bitmap
- */
-static unsigned long __init get_mapsize(bootmem_data_t *bdata)
+static unsigned long __init bootmap_bytes(unsigned long pages)
 {
-	unsigned long mapsize;
-	unsigned long start = PFN_DOWN(bdata->node_boot_start);
-	unsigned long end = bdata->node_low_pfn;
+	unsigned long bytes = (pages + 7) / 8;
 
-	mapsize = ((end - start) + 7) / 8;
-	return ALIGN(mapsize, sizeof(long));
+	return ALIGN(bytes, sizeof(long));
 }
 
 /**
@@ -69,13 +63,9 @@ static unsigned long __init get_mapsize(
  */
 unsigned long __init bootmem_bootmap_pages(unsigned long pages)
 {
-	unsigned long mapsize;
-
-	mapsize = (pages+7)/8;
-	mapsize = (mapsize + ~PAGE_MASK) & PAGE_MASK;
-	mapsize >>= PAGE_SHIFT;
+	unsigned long bytes = bootmap_bytes(pages);
 
-	return mapsize;
+	return PAGE_ALIGN(bytes) >> PAGE_SHIFT;
 }
 
 /*
@@ -117,7 +107,7 @@ static unsigned long __init init_bootmem
 	 * Initially all pages are reserved - setup_arch() has to
 	 * register free RAM areas explicitly.
 	 */
-	mapsize = get_mapsize(bdata);
+	mapsize = bootmap_bytes(end - start);
 	memset(bdata->node_bootmem_map, 0xff, mapsize);
 
 	bdebug("nid=%td start=%lx map=%lx end=%lx mapsize=%lx\n",
@@ -160,7 +150,7 @@ static unsigned long __init free_all_boo
 	struct page *page;
 	unsigned long pfn;
 	unsigned long i, count;
-	unsigned long idx;
+	unsigned long idx, pages;
 	unsigned long *map;
 	int gofast = 0;
 
@@ -211,7 +201,8 @@ static unsigned long __init free_all_boo
 	 * needed anymore:
 	 */
 	page = virt_to_page(bdata->node_bootmem_map);
-	idx = (get_mapsize(bdata) + PAGE_SIZE-1) >> PAGE_SHIFT;
+	pages = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
+	idx = bootmem_bootmap_pages(pages);
 	for (i = 0; i < idx; i++, page++)
 		__free_pages_bootmem(page, 0);
 	count += i;
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

