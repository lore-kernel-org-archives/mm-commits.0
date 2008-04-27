From: akpm@linux-foundation.org
Subject: - mm-make-reserve_bootmem-can-crossed-the-nodes.patch removed from -mm tree
Date: Sun, 27 Apr 2008 11:36:38 -0700
Message-ID: <200804271836.m3RIacuG019359@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42213 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758447AbYD0SiC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 27 Apr 2008 14:38:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yhlu.kernel.send@gmail.com, ak@suse.de, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mingo@elte.hu, y-goto@jp.fujitsu.com, yhlu.kernel@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mm: make reserve_bootmem can crossed the nodes
has been removed from the -mm tree.  Its filename was
     mm-make-reserve_bootmem-can-crossed-the-nodes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make reserve_bootmem can crossed the nodes
From: Yinghai Lu <yhlu.kernel.send@gmail.com>

Split reserve_bootmem_core to two function, one check conflicts, and one set
bits.

And make reserve_bootmem to loop bdata_list to cross the nodes.

User could be crashkernel and ramdisk..., in case the range crosses the nodes

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/bootmem.c |   85 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 63 insertions(+), 22 deletions(-)

diff -puN mm/bootmem.c~mm-make-reserve_bootmem-can-crossed-the-nodes mm/bootmem.c
--- a/mm/bootmem.c~mm-make-reserve_bootmem-can-crossed-the-nodes
+++ a/mm/bootmem.c
@@ -111,44 +111,71 @@ static unsigned long __init init_bootmem
  * might be used for boot-time allocations - or it might get added
  * to the free page pool later on.
  */
-static int __init reserve_bootmem_core(bootmem_data_t *bdata,
+static int __init can_reserve_bootmem_core(bootmem_data_t *bdata,
 			unsigned long addr, unsigned long size, int flags)
 {
 	unsigned long sidx, eidx;
 	unsigned long i;
-	int ret;
+
+	BUG_ON(!size);
+
+	/* out of range, don't hold other */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return 0;
 
 	/*
-	 * round up, partially reserved pages are considered
-	 * fully reserved.
+	 * Round up to index to the range.
 	 */
+	if (addr > bdata->node_boot_start)
+		sidx= PFN_DOWN(addr - bdata->node_boot_start);
+	else
+		sidx = 0;
+
+	eidx = PFN_UP(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
+
+	for (i = sidx; i < eidx; i++)
+		if (test_bit(i, bdata->node_bootmem_map)) {
+			if (flags & BOOTMEM_EXCLUSIVE)
+				return -EBUSY;
+		}
+
+	return 0;
+
+}
+static void __init reserve_bootmem_core(bootmem_data_t *bdata,
+			unsigned long addr, unsigned long size, int flags)
+{
+	unsigned long sidx, eidx;
+	unsigned long i;
+
 	BUG_ON(!size);
-	BUG_ON(PFN_DOWN(addr) >= bdata->node_low_pfn);
-	BUG_ON(PFN_UP(addr + size) > bdata->node_low_pfn);
-	BUG_ON(addr < bdata->node_boot_start);
 
-	sidx = PFN_DOWN(addr - bdata->node_boot_start);
+	/* out of range */
+	if (addr + size < bdata->node_boot_start ||
+		PFN_DOWN(addr) > bdata->node_low_pfn)
+		return;
+
+	/*
+	 * Round up to index to the range.
+	 */
+	if (addr > bdata->node_boot_start)
+		sidx= PFN_DOWN(addr - bdata->node_boot_start);
+	else
+		sidx = 0;
+
 	eidx = PFN_UP(addr + size - bdata->node_boot_start);
+	if (eidx > bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start))
+		eidx = bdata->node_low_pfn - PFN_DOWN(bdata->node_boot_start);
 
 	for (i = sidx; i < eidx; i++)
 		if (test_and_set_bit(i, bdata->node_bootmem_map)) {
 #ifdef CONFIG_DEBUG_BOOTMEM
 			printk("hm, page %08lx reserved twice.\n", i*PAGE_SIZE);
 #endif
-			if (flags & BOOTMEM_EXCLUSIVE) {
-				ret = -EBUSY;
-				goto err;
-			}
 		}
-
-	return 0;
-
-err:
-	/* unreserve memory we accidentally reserved */
-	for (i--; i >= sidx; i--)
-		clear_bit(i, bdata->node_bootmem_map);
-
-	return ret;
 }
 
 static void __init free_bootmem_core(bootmem_data_t *bdata, unsigned long addr,
@@ -415,6 +442,11 @@ unsigned long __init init_bootmem_node(p
 void __init reserve_bootmem_node(pg_data_t *pgdat, unsigned long physaddr,
 				 unsigned long size, int flags)
 {
+	int ret;
+
+	ret = can_reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
+	if (ret < 0)
+		return;
 	reserve_bootmem_core(pgdat->bdata, physaddr, size, flags);
 }
 
@@ -440,7 +472,16 @@ unsigned long __init init_bootmem(unsign
 int __init reserve_bootmem(unsigned long addr, unsigned long size,
 			    int flags)
 {
-	return reserve_bootmem_core(NODE_DATA(0)->bdata, addr, size, flags);
+	int ret;
+	bootmem_data_t *bdata;
+	list_for_each_entry(bdata, &bdata_list, list) {
+		ret = can_reserve_bootmem_core(bdata, addr, size, flags);
+		if (ret < 0)
+			return ret;
+	}
+	list_for_each_entry(bdata, &bdata_list, list)
+		reserve_bootmem_core(bdata, addr, size, flags);
+	return 0;
 }
 #endif /* !CONFIG_HAVE_ARCH_BOOTMEM_NODE */
 
_

Patches currently in -mm which might be from yhlu.kernel.send@gmail.com are

origin.patch
x86_64-restore-mask_bits-in-msi-shutdown.patch

