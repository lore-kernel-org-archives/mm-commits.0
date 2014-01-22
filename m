From: akpm@linux-foundation.org
Subject: [merged]
 lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch removed
 from -mm tree
Date: Wed, 22 Jan 2014 12:14:08 -0800
Message-ID: <52e02690.iTezsIgyek0qoQve%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54813 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbaAVUOJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:14:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, grygorii.strashko@ti.com, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, santosh.shilimkar@ti.com

Subject: [merged] lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch removed from -mm tree
To: santosh.shilimkar@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,grygorii.strashko@ti.com,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,tj@kernel.org,tony@atomide.com,yinghai@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:14:08 -0800


The patch titled
     Subject: lib/swiotlb.c: use memblock apis for early memory allocations
has been removed from the -mm tree.  Its filename was
     lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: lib/swiotlb.c: use memblock apis for early memory allocations

Switch to memblock interfaces for early memory allocator instead of
bootmem allocator.  No functional change in beahvior than what it is in
current code from bootmem users points of view.

Archs already converted to NO_BOOTMEM now directly use memblock interfaces
instead of bootmem wrappers build on top of memblock.  And the archs which
still uses bootmem, these new apis just fallback to exiting bootmem APIs.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/swiotlb.c |   35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff -puN lib/swiotlb.c~lib-swiotlbc-use-memblock-apis-for-early-memory-allocations lib/swiotlb.c
--- a/lib/swiotlb.c~lib-swiotlbc-use-memblock-apis-for-early-memory-allocations
+++ a/lib/swiotlb.c
@@ -172,8 +172,9 @@ int __init swiotlb_init_with_tbl(char *t
 	/*
 	 * Get the overflow emergency buffer
 	 */
-	v_overflow_buffer = alloc_bootmem_low_pages_nopanic(
-						PAGE_ALIGN(io_tlb_overflow));
+	v_overflow_buffer = memblock_virt_alloc_nopanic(
+						PAGE_ALIGN(io_tlb_overflow),
+						PAGE_SIZE);
 	if (!v_overflow_buffer)
 		return -ENOMEM;
 
@@ -184,11 +185,15 @@ int __init swiotlb_init_with_tbl(char *t
 	 * to find contiguous free memory regions of size up to IO_TLB_SEGSIZE
 	 * between io_tlb_start and io_tlb_end.
 	 */
-	io_tlb_list = alloc_bootmem_pages(PAGE_ALIGN(io_tlb_nslabs * sizeof(int)));
+	io_tlb_list = memblock_virt_alloc(
+				PAGE_ALIGN(io_tlb_nslabs * sizeof(int)),
+				PAGE_SIZE);
 	for (i = 0; i < io_tlb_nslabs; i++)
  		io_tlb_list[i] = IO_TLB_SEGSIZE - OFFSET(i, IO_TLB_SEGSIZE);
 	io_tlb_index = 0;
-	io_tlb_orig_addr = alloc_bootmem_pages(PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
+	io_tlb_orig_addr = memblock_virt_alloc(
+				PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)),
+				PAGE_SIZE);
 
 	if (verbose)
 		swiotlb_print_info();
@@ -215,13 +220,13 @@ swiotlb_init(int verbose)
 	bytes = io_tlb_nslabs << IO_TLB_SHIFT;
 
 	/* Get IO TLB memory from the low pages */
-	vstart = alloc_bootmem_low_pages_nopanic(PAGE_ALIGN(bytes));
+	vstart = memblock_virt_alloc_nopanic(PAGE_ALIGN(bytes), PAGE_SIZE);
 	if (vstart && !swiotlb_init_with_tbl(vstart, io_tlb_nslabs, verbose))
 		return;
 
 	if (io_tlb_start)
-		free_bootmem(io_tlb_start,
-				 PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
+		memblock_free_early(io_tlb_start,
+				    PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
 	pr_warn("Cannot allocate SWIOTLB buffer");
 	no_iotlb_memory = true;
 }
@@ -357,14 +362,14 @@ void __init swiotlb_free(void)
 		free_pages((unsigned long)phys_to_virt(io_tlb_start),
 			   get_order(io_tlb_nslabs << IO_TLB_SHIFT));
 	} else {
-		free_bootmem_late(io_tlb_overflow_buffer,
-				  PAGE_ALIGN(io_tlb_overflow));
-		free_bootmem_late(__pa(io_tlb_orig_addr),
-				  PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
-		free_bootmem_late(__pa(io_tlb_list),
-				  PAGE_ALIGN(io_tlb_nslabs * sizeof(int)));
-		free_bootmem_late(io_tlb_start,
-				  PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
+		memblock_free_late(io_tlb_overflow_buffer,
+				   PAGE_ALIGN(io_tlb_overflow));
+		memblock_free_late(__pa(io_tlb_orig_addr),
+				   PAGE_ALIGN(io_tlb_nslabs * sizeof(phys_addr_t)));
+		memblock_free_late(__pa(io_tlb_list),
+				   PAGE_ALIGN(io_tlb_nslabs * sizeof(int)));
+		memblock_free_late(io_tlb_start,
+				   PAGE_ALIGN(io_tlb_nslabs << IO_TLB_SHIFT));
 	}
 	io_tlb_nslabs = 0;
 }
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

origin.patch
mm-nobootmem-free_all_bootmem-again.patch
linux-next.patch

