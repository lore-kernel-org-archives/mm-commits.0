From: akpm@linux-foundation.org
Subject: + mm-print-physical-addresses-consistently-with-other-parts-of-kernel.patch added to -mm tree
Date: Mon, 30 Apr 2012 16:27:27 -0700
Message-ID: <20120430232727.473F7A04B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:45014 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab2D3X12 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 19:27:28 -0400
Received: by yenq2 with SMTP id q2so402228yen.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 16:27:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhelgaas@google.com, hpa@zytor.com, konrad.wilk@oracle.com, mingo@elte.hu, tglx@linutronix.de, yinghai@kernel.org


The patch titled
     Subject: mm: print physical addresses consistently with other parts of kernel
has been added to the -mm tree.  Its filename is
     mm-print-physical-addresses-consistently-with-other-parts-of-kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: mm: print physical addresses consistently with other parts of kernel

Print physical address info in a style consistent with the %pR style used
elsewhere in the kernel.  For example:

    -Zone PFN ranges:
    +Zone ranges:
    -  DMA32    0x00000010 -> 0x00100000
    +  DMA32    [mem 0x00010000-0xffffffff]
    -  Normal   0x00100000 -> 0x01080000
    +  Normal   [mem 0x100000000-0x107fffffff]

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory_hotplug.c |   14 ++++++++------
 mm/page_alloc.c     |   19 +++++++++++--------
 2 files changed, 19 insertions(+), 14 deletions(-)

diff -puN mm/memory_hotplug.c~mm-print-physical-addresses-consistently-with-other-parts-of-kernel mm/memory_hotplug.c
--- a/mm/memory_hotplug.c~mm-print-physical-addresses-consistently-with-other-parts-of-kernel
+++ a/mm/memory_hotplug.c
@@ -74,8 +74,7 @@ static struct resource *register_memory_
 	res->end = start + size - 1;
 	res->flags = IORESOURCE_MEM | IORESOURCE_BUSY;
 	if (request_resource(&iomem_resource, res) < 0) {
-		printk("System RAM resource %llx - %llx cannot be added\n",
-		(unsigned long long)res->start, (unsigned long long)res->end);
+		printk("System RAM resource %pR cannot be added\n", res);
 		kfree(res);
 		res = NULL;
 	}
@@ -502,8 +501,10 @@ int __ref online_pages(unsigned long pfn
 		online_pages_range);
 	if (ret) {
 		mutex_unlock(&zonelists_mutex);
-		printk(KERN_DEBUG "online_pages %lx at %lx failed\n",
-			nr_pages, pfn);
+		printk(KERN_DEBUG "online_pages [mem %#010llx-%#010llx] failed\n",
+		       (unsigned long long) pfn << PAGE_SHIFT,
+		       (((unsigned long long) pfn + nr_pages)
+			    << PAGE_SHIFT) - 1);
 		memory_notify(MEM_CANCEL_ONLINE, &arg);
 		unlock_memory_hotplug();
 		return ret;
@@ -977,8 +978,9 @@ repeat:
 	return 0;
 
 failed_removal:
-	printk(KERN_INFO "memory offlining %lx to %lx failed\n",
-		start_pfn, end_pfn);
+	printk(KERN_INFO "memory offlining [mem %#010llx-%#010llx] failed\n",
+	       (unsigned long long) start_pfn << PAGE_SHIFT,
+	       ((unsigned long long) end_pfn << PAGE_SHIFT) - 1);
 	memory_notify(MEM_CANCEL_OFFLINE, &arg);
 	/* pushback to free area */
 	undo_isolate_page_range(start_pfn, end_pfn, MIGRATE_MOVABLE);
diff -puN mm/page_alloc.c~mm-print-physical-addresses-consistently-with-other-parts-of-kernel mm/page_alloc.c
--- a/mm/page_alloc.c~mm-print-physical-addresses-consistently-with-other-parts-of-kernel
+++ a/mm/page_alloc.c
@@ -4815,7 +4815,7 @@ void __init free_area_init_nodes(unsigne
 	find_zone_movable_pfns_for_nodes();
 
 	/* Print out the zone ranges */
-	printk("Zone PFN ranges:\n");
+	printk("Zone ranges:\n");
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		if (i == ZONE_MOVABLE)
 			continue;
@@ -4824,22 +4824,25 @@ void __init free_area_init_nodes(unsigne
 				arch_zone_highest_possible_pfn[i])
 			printk("empty\n");
 		else
-			printk("%0#10lx -> %0#10lx\n",
-				arch_zone_lowest_possible_pfn[i],
-				arch_zone_highest_possible_pfn[i]);
+			printk("[mem %0#10lx-%0#10lx]\n",
+				arch_zone_lowest_possible_pfn[i] << PAGE_SHIFT,
+				(arch_zone_highest_possible_pfn[i]
+					<< PAGE_SHIFT) - 1);
 	}
 
 	/* Print out the PFNs ZONE_MOVABLE begins at in each node */
-	printk("Movable zone start PFN for each node\n");
+	printk("Movable zone start for each node\n");
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		if (zone_movable_pfn[i])
-			printk("  Node %d: %lu\n", i, zone_movable_pfn[i]);
+			printk("  Node %d: %#010lx\n", i,
+			       zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
 	/* Print out the early_node_map[] */
-	printk("Early memory PFN ranges\n");
+	printk("Early memory node ranges\n");
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
-		printk("  %3d: %0#10lx -> %0#10lx\n", nid, start_pfn, end_pfn);
+		printk("  node %3d: [mem %#010lx-%#010lx]\n", nid,
+		       start_pfn << PAGE_SHIFT, (end_pfn << PAGE_SHIFT) - 1);
 
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
_
Subject: Subject: mm: print physical addresses consistently with other parts of kernel

Patches currently in -mm which might be from bhelgaas@google.com are

linux-next.patch
x86-print-e820-physical-addresses-consistently-with-other-parts-of-kernel.patch
x86-print-physical-addresses-consistently-with-other-parts-of-kernel.patch
swiotlb-print-physical-addresses-consistently-with-other-parts-of-kernel.patch
mm-print-physical-addresses-consistently-with-other-parts-of-kernel.patch

