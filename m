From: akpm@linux-foundation.org
Subject: + bootmem-add-debugging-framework.patch added to -mm tree
Date: Sun, 08 Jun 2008 16:35:19 -0700
Message-ID: <200806082335.m58NZJka025599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753902AbYFHXgW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jun 2008 19:36:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@saeurebad.de


The patch titled
     bootmem: add debugging framework
has been added to the -mm tree.  Its filename is
     bootmem-add-debugging-framework.patch

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
Subject: bootmem: add debugging framework
From: Johannes Weiner <hannes@saeurebad.de>

Introduce the bootmem_debug kernel parameter that enables very verbose
diagnostics regarding all range operations of bootmem as well as the
initialization and release of nodes.

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
 
+	bdebug("nid=%d start=%lx map=%lx end=%lx mapsize=%lx\n",
+		bdata - bootmem_node_data, start, mapstart, end, mapsize);
+
 	return mapsize;
 }
 
@@ -198,6 +217,8 @@ static unsigned long __init free_all_boo
 	count += i;
 	bdata->node_bootmem_map = NULL;
 
+	bdebug("nid=%d released=%lx\n", bdata - bootmem_node_data, count);
+
 	return count;
 }
 
@@ -255,6 +276,10 @@ static void __init free_bootmem_core(boo
 	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
 		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
+	bdebug("nid=%d start=%lx end=%lx\n", bdata - bootmem_node_data,
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
+	bdebug("nid=%d start=%lx end=%lx flags=%x\n",
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
@@ -454,6 +482,10 @@ alloc_bootmem_core(struct bootmem_data *
 	if (!bdata->node_bootmem_map)
 		return NULL;
 
+	bdebug("nid=%d size=%lx [%lu pages] align=%lx goal=%lx limit=%lx\n",
+		bdata - bootmem_node_data, size, PAGE_ALIGN(size) >> PAGE_SHIFT,
+		align, goal, limit);
+
 	/* bdata->node_boot_start is supposed to be (12+6)bits alignment on x86_64 ? */
 	node_boot_start = bdata->node_boot_start;
 	node_bootmem_map = bdata->node_bootmem_map;
@@ -561,6 +593,11 @@ found:
 		ret = phys_to_virt(start * PAGE_SIZE + node_boot_start);
 	}
 
+	bdebug("nid=%d start=%lx end=%lx\n",
+		bdata - bootmem_node_data,
+		start + PFN_DOWN(bdata->node_boot_start),
+		start + areasize + PFN_DOWN(bdata->node_boot_start));
+
 	/*
 	 * Reserve the area now:
 	 */
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

