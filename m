From: akpm@linux-foundation.org
Subject: - mm-normalize-internal-argument-passing-of-bootmem-data.patch removed from -mm tree
Date: Thu, 24 Jul 2008 16:21:08 -0700
Message-ID: <200807242321.m6ONL81x010383@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55490 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753336AbYGXXVi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 24 Jul 2008 19:21:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@saeurebad.de, apw@shadowen.org, cl@linux-foundation.org, mel@csn.ul.ie, mingo@elte.hu, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: normalize internal argument passing of bootmem data
has been removed from the -mm tree.  Its filename was
     mm-normalize-internal-argument-passing-of-bootmem-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: normalize internal argument passing of bootmem data
From: Johannes Weiner <hannes@saeurebad.de>

All _core functions only need the bootmem data, not the whole node descriptor.
Adjust the two functions that take the node descriptor unneededly.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andy Whitcroft <apw@shadowen.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/bootmem.c~mm-normalize-internal-argument-passing-of-bootmem-data mm/bootmem.c
--- a/mm/bootmem.c~mm-normalize-internal-argument-passing-of-bootmem-data
+++ a/mm/bootmem.c
@@ -87,10 +87,9 @@ static unsigned long __init get_mapsize(
 /*
  * Called once to set up the allocator itself.
  */
-static unsigned long __init init_bootmem_core(pg_data_t *pgdat,
+static unsigned long __init init_bootmem_core(bootmem_data_t *bdata,
 	unsigned long mapstart, unsigned long start, unsigned long end)
 {
-	bootmem_data_t *bdata = pgdat->bdata;
 	unsigned long mapsize;
 
 	mminit_validate_memmodel_limits(&start, &end);
@@ -372,11 +371,10 @@ found:
 	return ret;
 }
 
-static unsigned long __init free_all_bootmem_core(pg_data_t *pgdat)
+static unsigned long __init free_all_bootmem_core(bootmem_data_t *bdata)
 {
 	struct page *page;
 	unsigned long pfn;
-	bootmem_data_t *bdata = pgdat->bdata;
 	unsigned long i, count;
 	unsigned long idx;
 	unsigned long *map; 
@@ -441,7 +439,7 @@ static unsigned long __init free_all_boo
 unsigned long __init init_bootmem_node(pg_data_t *pgdat, unsigned long freepfn,
 				unsigned long startpfn, unsigned long endpfn)
 {
-	return init_bootmem_core(pgdat, freepfn, startpfn, endpfn);
+	return init_bootmem_core(pgdat->bdata, freepfn, startpfn, endpfn);
 }
 
 int __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
@@ -466,14 +464,14 @@ void __init free_bootmem_node(pg_data_t 
 unsigned long __init free_all_bootmem_node(pg_data_t *pgdat)
 {
 	register_page_bootmem_info_node(pgdat);
-	return free_all_bootmem_core(pgdat);
+	return free_all_bootmem_core(pgdat->bdata);
 }
 
 unsigned long __init init_bootmem(unsigned long start, unsigned long pages)
 {
 	max_low_pfn = pages;
 	min_low_pfn = start;
-	return init_bootmem_core(NODE_DATA(0), start, 0, pages);
+	return init_bootmem_core(NODE_DATA(0)->bdata, start, 0, pages);
 }
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
@@ -504,7 +502,7 @@ void __init free_bootmem(unsigned long a
 
 unsigned long __init free_all_bootmem(void)
 {
-	return free_all_bootmem_core(NODE_DATA(0));
+	return free_all_bootmem_core(NODE_DATA(0)->bdata);
 }
 
 void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
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

