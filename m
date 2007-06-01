From: akpm@linux-foundation.org
Subject: - x86_64-allocate-sparsemem-memmap-above-4g.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:46:55 -0700
Message-ID: <200706011746.l51HksUb015093@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:48740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760379AbXFARrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nanhai.zou@intel.com, ak@suse.de, stable@kernel.org, suresh.b.siddha@intel.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: allocate sparsemem memmap above 4G
has been removed from the -mm tree.  Its filename was
     x86_64-allocate-sparsemem-memmap-above-4g.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: allocate sparsemem memmap above 4G
From: Zou Nan hai <nanhai.zou@intel.com>

On systems with huge amount of physical memory, VFS cache and memory memmap
may eat all available system memory under 4G, then the system may fail to
allocate swiotlb bounce buffer.

There was a fix for this issue in arch/x86_64/mm/numa.c, but that fix dose
not cover sparsemem model.

This patch add fix to sparsemem model by first try to allocate memmap above
4G.

Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <ak@suse.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/mm/init.c   |    6 ++++++
 include/linux/bootmem.h |    1 +
 mm/sparse.c             |   11 +++++++++++
 3 files changed, 18 insertions(+)

diff -puN arch/x86_64/mm/init.c~x86_64-allocate-sparsemem-memmap-above-4g arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~x86_64-allocate-sparsemem-memmap-above-4g
+++ a/arch/x86_64/mm/init.c
@@ -761,3 +761,9 @@ int in_gate_area_no_task(unsigned long a
 {
 	return (addr >= VSYSCALL_START) && (addr < VSYSCALL_END);
 }
+
+void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
+{
+	return __alloc_bootmem_core(pgdat->bdata, size,
+			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
+}
diff -puN include/linux/bootmem.h~x86_64-allocate-sparsemem-memmap-above-4g include/linux/bootmem.h
--- a/include/linux/bootmem.h~x86_64-allocate-sparsemem-memmap-above-4g
+++ a/include/linux/bootmem.h
@@ -59,6 +59,7 @@ extern void *__alloc_bootmem_core(struct
 				  unsigned long align,
 				  unsigned long goal,
 				  unsigned long limit);
+extern void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size);
 
 #ifndef CONFIG_HAVE_ARCH_BOOTMEM_NODE
 extern void reserve_bootmem(unsigned long addr, unsigned long size);
diff -puN mm/sparse.c~x86_64-allocate-sparsemem-memmap-above-4g mm/sparse.c
--- a/mm/sparse.c~x86_64-allocate-sparsemem-memmap-above-4g
+++ a/mm/sparse.c
@@ -209,6 +209,12 @@ static int __meminit sparse_init_one_sec
 	return 1;
 }
 
+__attribute__((weak))
+void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
+{
+	return NULL;
+}
+
 static struct page __init *sparse_early_mem_map_alloc(unsigned long pnum)
 {
 	struct page *map;
@@ -219,6 +225,11 @@ static struct page __init *sparse_early_
 	if (map)
 		return map;
 
+  	map = alloc_bootmem_high_node(NODE_DATA(nid),
+                       sizeof(struct page) * PAGES_PER_SECTION);
+	if (map)
+		return map;
+
 	map = alloc_bootmem_node(NODE_DATA(nid),
 			sizeof(struct page) * PAGES_PER_SECTION);
 	if (map)
_

Patches currently in -mm which might be from nanhai.zou@intel.com are

origin.patch
revert-x86_64-mm-allocate-sparsemem-memmap-above-4g-on-x86_64.patch
x86_64-irq-check-remote-irr-bit-before-migrating-level-triggered-irq-v3.patch
