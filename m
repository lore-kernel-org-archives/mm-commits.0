From: akpm@linux-foundation.org
Subject: + bootmem-revisit-bitmap-size-calculations.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:35:21 -0700
Message-ID: <200806082335.m58NZLRL025602@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49424 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754214AbYFHXgY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:36:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de


The patch titled
     bootmem: revisit bitmap size calculations
has been added to the -mm tree.  Its filename is
     bootmem-revisit-bitmap-size-calculations.patch

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
 
 	bdebug("nid=%d start=%lx map=%lx end=%lx mapsize=%lx\n",
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

git-xtensa.patch
mm-move-bootmem-descriptors-definition-to-a-single-place.patch
mm-fix-free_all_bootmem_core-alignment-check.patch
mm-normalize-internal-argument-passing-of-bootmem-data.patch
mm-unexport-__alloc_bootmem_core.patch
mm-drop-unneeded-pgdat-argument-from-free_area_init_node.patch
hugetlb-guarantee-that-cow-faults-for-a-process-that-called-mmapmap_private-on-hugetlbfs-will-succeed-fix.patch
huge-page-private-reservation-review-cleanups.patch
huge-page-private-reservation-review-cleanups-fix.patch
mm-record-map_noreserve-status-on-vmas-and-fix-small-page-mprotect-reservations.patch
hugetlb-move-reservation-region-support-earlier.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations.patch
hugetlb-allow-huge-page-mappings-to-be-created-without-reservations-cleanups.patch
bootmem-reorder-code-to-match-new-bootmem-structure.patch
bootmem-clean-up-bootmemc-file-header.patch
bootmem-add-documentation-to-api-functions.patch
bootmem-add-debugging-framework.patch
bootmem-revisit-bitmap-size-calculations.patch
bootmem-revisit-bootmem-descriptor-list-handling.patch
bootmem-clean-up-free_all_bootmem_core.patch
bootmem-clean-up-alloc_bootmem_core.patch
bootmem-free-reserve-helpers.patch
bootmem-factor-out-the-marking-of-a-pfn-range.patch
bootmem-respect-goal-more-likely.patch
bootmem-make-__alloc_bootmem_low_node-fall-back-to-other-nodes.patch
bootmem-revisit-alloc_bootmem_section.patch
bootmem-replace-node_boot_start-in-struct-bootmem_data.patch

