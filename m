From: akpm@linux-foundation.org
Subject: [merged]
 mm-page_alloc-convert-boot-printks-without-log-level-to-pr_info.patch
 removed from -mm tree
Date: Thu, 11 Dec 2014 10:56:08 -0800
Message-ID: <5489e8c8.4dTXHYQULNCIN5MG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45101 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582AbaLKS4J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Dec 2014 13:56:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anton@samba.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: convert boot printks without log level to pr_info
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-convert-boot-printks-without-log-level-to-pr_info.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Anton Blanchard <anton@samba.org>
Subject: mm/page_alloc.c: convert boot printks without log level to pr_info

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff -puN mm/page_alloc.c~mm-page_alloc-convert-boot-printks-without-log-level-to-pr_info mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-convert-boot-printks-without-log-level-to-pr_info
+++ a/mm/page_alloc.c
@@ -3893,14 +3893,14 @@ void __ref build_all_zonelists(pg_data_t
 	else
 		page_group_by_mobility_disabled = 0;
 
-	printk("Built %i zonelists in %s order, mobility grouping %s.  "
+	pr_info("Built %i zonelists in %s order, mobility grouping %s.  "
 		"Total pages: %ld\n",
 			nr_online_nodes,
 			zonelist_order_name[current_zonelist_order],
 			page_group_by_mobility_disabled ? "off" : "on",
 			vm_total_pages);
 #ifdef CONFIG_NUMA
-	printk("Policy zone: %s\n", zone_names[policy_zone]);
+	pr_info("Policy zone: %s\n", zone_names[policy_zone]);
 #endif
 }
 
@@ -5334,33 +5334,33 @@ void __init free_area_init_nodes(unsigne
 	find_zone_movable_pfns_for_nodes();
 
 	/* Print out the zone ranges */
-	printk("Zone ranges:\n");
+	pr_info("Zone ranges:\n");
 	for (i = 0; i < MAX_NR_ZONES; i++) {
 		if (i == ZONE_MOVABLE)
 			continue;
-		printk(KERN_CONT "  %-8s ", zone_names[i]);
+		pr_info("  %-8s ", zone_names[i]);
 		if (arch_zone_lowest_possible_pfn[i] ==
 				arch_zone_highest_possible_pfn[i])
-			printk(KERN_CONT "empty\n");
+			pr_cont("empty\n");
 		else
-			printk(KERN_CONT "[mem %0#10lx-%0#10lx]\n",
+			pr_cont("[mem %0#10lx-%0#10lx]\n",
 				arch_zone_lowest_possible_pfn[i] << PAGE_SHIFT,
 				(arch_zone_highest_possible_pfn[i]
 					<< PAGE_SHIFT) - 1);
 	}
 
 	/* Print out the PFNs ZONE_MOVABLE begins at in each node */
-	printk("Movable zone start for each node\n");
+	pr_info("Movable zone start for each node\n");
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		if (zone_movable_pfn[i])
-			printk("  Node %d: %#010lx\n", i,
+			pr_info("  Node %d: %#010lx\n", i,
 			       zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
 	/* Print out the early node map */
-	printk("Early memory node ranges\n");
+	pr_info("Early memory node ranges\n");
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
-		printk("  node %3d: [mem %#010lx-%#010lx]\n", nid,
+		pr_info("  node %3d: [mem %#010lx-%#010lx]\n", nid,
 		       start_pfn << PAGE_SHIFT, (end_pfn << PAGE_SHIFT) - 1);
 
 	/* Initialise every node */
@@ -5496,7 +5496,7 @@ void __init mem_init_print_info(const ch
 
 #undef	adj_init_size
 
-	printk("Memory: %luK/%luK available "
+	pr_info("Memory: %luK/%luK available "
 	       "(%luK kernel code, %luK rwdata, %luK rodata, "
 	       "%luK init, %luK bss, %luK reserved"
 #ifdef	CONFIG_HIGHMEM
_

Patches currently in -mm which might be from anton@samba.org are

origin.patch
linux-next.patch

