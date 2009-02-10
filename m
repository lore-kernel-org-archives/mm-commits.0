From: akpm@linux-foundation.org
Subject: [to-be-updated] powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch removed from -mm tree
Date: Tue, 10 Feb 2009 09:54:34 -0800
Message-ID: <200902101754.n1AHsYdK008531@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752728AbZBJRy5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Feb 2009 12:54:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chandru@in.ibm.com, benh@kernel.crashing.org, chandru@linux.vnet.ibm.com, dave@linux.vnet.ibm.com, hannes@cmpxchg.org, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     powerpc: fix code for reserved memory spanning across nodes
has been removed from the -mm tree.  Its filename was
     powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: fix code for reserved memory spanning across nodes
From: Chandru <chandru@in.ibm.com>

When booted with crashkernel=224M@32M or any memory size less than this,
the system boots properly.  The following was the observation..  The
system comes up with two nodes (0-256M and 256M-4GB).  The crashkernel
memory reservation spans across these two nodes.  The
mark_reserved_regions_for_nid() in arch/powerpc/mm/numa.c resizes the
reserved part of the memory within it as:

	if (end_pfn > node_ar.end_pfn)
		reserve_size = (node_ar.end_pfn << PAGE_SHIFT)
				- (start_pfn << PAGE_SHIFT);


but the reserve_bootmem_node() in mm/bootmem.c raises the pfn value of end 

	end = PFN_UP(physaddr + size);

This causes end to get a value past the last page in the 0-256M node. 
Again when reserve_bootmem_node() returns, mark_reserved_regions_for_nid()
loops around to set the rest of the crashkernel memory in the next node as
reserved.  It references NODE_DATA(node_ar.nid) and this causes another
'Oops: kernel access of bad area' problem.  The following changes made the
system to boot with any amount of crashkernel memory size.

Signed-off-by: Chandru S <chandru@linux.vnet.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c |    7 ++++---
 mm/bootmem.c           |    4 ++++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN arch/powerpc/mm/numa.c~powerpc-fix-code-for-reserved-memory-spanning-across-nodes arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~powerpc-fix-code-for-reserved-memory-spanning-across-nodes
+++ a/arch/powerpc/mm/numa.c
@@ -1001,10 +1001,11 @@ void __init do_init_bootmem(void)
 				  start_pfn, end_pfn);
 
 		free_bootmem_with_active_regions(nid, end_pfn);
+	}
+
+	for_each_online_node(nid) {
 		/*
-		 * Be very careful about moving this around.  Future
-		 * calls to careful_zallocation() depend on this getting
-		 * done correctly.
+		 * Be very careful about moving this around.
 		 */
 		mark_reserved_regions_for_nid(nid);
 		sparse_memory_present_with_active_regions(nid);
diff -puN mm/bootmem.c~powerpc-fix-code-for-reserved-memory-spanning-across-nodes mm/bootmem.c
--- a/mm/bootmem.c~powerpc-fix-code-for-reserved-memory-spanning-across-nodes
+++ a/mm/bootmem.c
@@ -375,10 +375,14 @@ int __init reserve_bootmem_node(pg_data_
 				 unsigned long size, int flags)
 {
 	unsigned long start, end;
+	bootmem_data_t *bdata = pgdat->bdata;
 
 	start = PFN_DOWN(physaddr);
 	end = PFN_UP(physaddr + size);
 
+	if (end > bdata->node_low_pfn)
+		end = bdata->node_low_pfn;
+
 	return mark_bootmem_node(pgdat->bdata, start, end, 1, flags);
 }
 
_

Patches currently in -mm which might be from chandru@in.ibm.com are

powerpc-fix-code-for-reserved-memory-spanning-across-nodes.patch

