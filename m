From: akpm@linux-foundation.org
Subject: + mm-normalize-internal-argument-passing-of-bootmem-data.patch added to -mm tree
Date: Wed, 30 Apr 2008 12:30:07 -0700
Message-ID: <200804301930.m3UJU7aP031164@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36023 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761541AbYD3Tag (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 15:30:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de, apw@shadowen.org, clameter@sgi.com, mel@csn.ul.ie, mingo@elte.hu, yhlu.kernel@gmail.com


The patch titled
     mm: normalize internal argument passing of bootmem data
has been added to the -mm tree.  Its filename is
     mm-normalize-internal-argument-passing-of-bootmem-data.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: normalize internal argument passing of bootmem data
From: Johannes Weiner <hannes@saeurebad.de>

All _core functions only need the bootmem data, not the whole node descriptor.
Adjust the two functions that take the node descriptor unneededly.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Christoph Lameter <clameter@sgi.com>
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
 
 void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
@@ -464,14 +462,14 @@ void __init free_bootmem_node(pg_data_t 
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
@@ -502,7 +500,7 @@ void __init free_bootmem(unsigned long a
 
 unsigned long __init free_all_bootmem(void)
 {
-	return free_all_bootmem_core(NODE_DATA(0));
+	return free_all_bootmem_core(NODE_DATA(0)->bdata);
 }
 
 void * __init __alloc_bootmem_nopanic(unsigned long size, unsigned long align,
_

Patches currently in -mm which might be from hannes@saeurebad.de are

origin.patch
git-mips.patch
parisc-remove-redundant-display-of-free-swap-space-in-show_mem.patch
git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch

