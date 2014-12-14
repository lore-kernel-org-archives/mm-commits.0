From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-the-highmem-zones-memmap-in-the-highmem-zone.patch removed from
 -mm tree
Date: Sat, 13 Dec 2014 20:08:14 -0800
Message-ID: <548d0d2e.o1aODj82ED4kFxAo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47692 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102AbaLNEIG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sat, 13 Dec 2014 23:08:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bocui107@gmail.com, hongbo.zhong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove the highmem zones' memmap in the highmem zone
has been removed from the -mm tree.  Its filename was
     mm-remove-the-highmem-zones-memmap-in-the-highmem-zone.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Zhong Hongbo <bocui107@gmail.com>
Subject: mm: remove the highmem zones' memmap in the highmem zone

Since 01cefaef40c4 ("mm: provide more accurate estimation
of pages occupied by memmap") allocate the pages from lowmem for the
highmem zones' memmap. So It is not need to reserver the memmap's for
the highmem.

A 2G DDR3 for the arm platform:
On node 0 totalpages: 524288
free_area_init_node: node 0, pgdat 80ccd380, node_mem_map 80d38000
  DMA zone: 3568 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 456704 pages, LIFO batch:31
  HighMem zone: 528 pages used for memmap
  HighMem zone: 67584 pages, LIFO batch:15

On node 0 totalpages: 524288
free_area_init_node: node 0, pgdat 80cd6f40, node_mem_map 80d42000
  DMA zone: 3568 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 456704 pages, LIFO batch:31
  HighMem zone: 67584 pages, LIFO batch:15

Signed-off-by: Hongbo Zhong <hongbo.zhong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff -puN mm/page_alloc.c~mm-remove-the-highmem-zones-memmap-in-the-highmem-zone mm/page_alloc.c
--- a/mm/page_alloc.c~mm-remove-the-highmem-zones-memmap-in-the-highmem-zone
+++ a/mm/page_alloc.c
@@ -4937,16 +4937,18 @@ static void __paginginit free_area_init_
 		 * and per-cpu initialisations
 		 */
 		memmap_pages = calc_memmap_size(size, realsize);
-		if (freesize >= memmap_pages) {
-			freesize -= memmap_pages;
-			if (memmap_pages)
-				printk(KERN_DEBUG
-				       "  %s zone: %lu pages used for memmap\n",
-				       zone_names[j], memmap_pages);
-		} else
-			printk(KERN_WARNING
-				"  %s zone: %lu pages exceeds freesize %lu\n",
-				zone_names[j], memmap_pages, freesize);
+		if (!is_highmem_idx(j)) {
+			if (freesize >= memmap_pages) {
+				freesize -= memmap_pages;
+				if (memmap_pages)
+					printk(KERN_DEBUG
+					       "  %s zone: %lu pages used for memmap\n",
+					       zone_names[j], memmap_pages);
+			} else
+				printk(KERN_WARNING
+					"  %s zone: %lu pages exceeds freesize %lu\n",
+					zone_names[j], memmap_pages, freesize);
+		}
 
 		/* Account for reserved pages */
 		if (j == 0 && freesize > dma_reserve) {
_

Patches currently in -mm which might be from bocui107@gmail.com are

origin.patch

