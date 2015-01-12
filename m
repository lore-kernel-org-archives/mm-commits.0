From: akpm@linux-foundation.org
Subject: +
 mm-use-correct-format-specifiers-when-printing-address-ranges.patch added
 to -mm tree
Date: Mon, 12 Jan 2015 15:26:43 -0800
Message-ID: <54b45833.YvULJ4rJc8Q/Enb7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36740 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbbALX0o (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 12 Jan 2015 18:26:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jgross@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use correct format specifiers when printing address ranges
has been added to the -mm tree.  Its filename is
     mm-use-correct-format-specifiers-when-printing-address-ranges.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-correct-format-specifiers-when-printing-address-ranges.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-correct-format-specifiers-when-printing-address-ranges.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Juergen Gross <jgross@suse.com>
Subject: mm: use correct format specifiers when printing address ranges

Especially on 32 bit kernels memory node ranges are printed with 32 bit
wide addresses only.  Use u64 types and %llx specifiers to print full
width of addresses.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff -puN mm/page_alloc.c~mm-use-correct-format-specifiers-when-printing-address-ranges mm/page_alloc.c
--- a/mm/page_alloc.c~mm-use-correct-format-specifiers-when-printing-address-ranges
+++ a/mm/page_alloc.c
@@ -4994,8 +4994,8 @@ void __paginginit free_area_init_node(in
 	pgdat->node_start_pfn = node_start_pfn;
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
-	printk(KERN_INFO "Initmem setup node %d [mem %#010Lx-%#010Lx]\n", nid,
-			(u64) start_pfn << PAGE_SHIFT, (u64) (end_pfn << PAGE_SHIFT) - 1);
+	pr_info("Initmem setup node %d [mem %#018Lx-%#018Lx]\n", nid,
+		(u64)start_pfn << PAGE_SHIFT, ((u64)end_pfn << PAGE_SHIFT) - 1);
 #endif
 	calculate_node_totalpages(pgdat, start_pfn, end_pfn,
 				  zones_size, zholes_size);
@@ -5367,9 +5367,10 @@ void __init free_area_init_nodes(unsigne
 				arch_zone_highest_possible_pfn[i])
 			pr_cont("empty\n");
 		else
-			pr_cont("[mem %0#10lx-%0#10lx]\n",
-				arch_zone_lowest_possible_pfn[i] << PAGE_SHIFT,
-				(arch_zone_highest_possible_pfn[i]
+			pr_cont("[mem %#018Lx-%#018Lx]\n",
+				(u64)arch_zone_lowest_possible_pfn[i]
+					<< PAGE_SHIFT,
+				((u64)arch_zone_highest_possible_pfn[i]
 					<< PAGE_SHIFT) - 1);
 	}
 
@@ -5377,15 +5378,16 @@ void __init free_area_init_nodes(unsigne
 	pr_info("Movable zone start for each node\n");
 	for (i = 0; i < MAX_NUMNODES; i++) {
 		if (zone_movable_pfn[i])
-			pr_info("  Node %d: %#010lx\n", i,
-			       zone_movable_pfn[i] << PAGE_SHIFT);
+			pr_info("  Node %d: %#018Lx\n", i,
+			       (u64)zone_movable_pfn[i] << PAGE_SHIFT);
 	}
 
 	/* Print out the early node map */
 	pr_info("Early memory node ranges\n");
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid)
-		pr_info("  node %3d: [mem %#010lx-%#010lx]\n", nid,
-		       start_pfn << PAGE_SHIFT, (end_pfn << PAGE_SHIFT) - 1);
+		pr_info("  node %3d: [mem %#018Lx-%#018Lx]\n", nid,
+			(u64)start_pfn << PAGE_SHIFT,
+			((u64)end_pfn << PAGE_SHIFT) - 1);
 
 	/* Initialise every node */
 	mminit_verify_pageflags_layout();
_

Patches currently in -mm which might be from jgross@suse.com are

mm-use-correct-format-specifiers-when-printing-address-ranges.patch

