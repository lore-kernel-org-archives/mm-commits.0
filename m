From: akpm@linux-foundation.org
Subject: + x86_64-allocate-sparsemem-memmap-above-4g.patch added to -mm tree
Date: Thu, 17 May 2007 20:22:37 -0700
Message-ID: <200705180322.l4I3MatH006742@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45027 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754296AbXERD0u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 23:26:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nanhai.zou@intel.com, ak@suse.de, stable@kernel.org, suresh.b.siddha@intel.com


The patch titled
     x86_64: allocate sparsemem memmap above 4G
has been added to the -mm tree.  Its filename is
     x86_64-allocate-sparsemem-memmap-above-4g.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 arch/x86_64/mm/init.c |    6 ++++++
 mm/sparse.c           |   11 +++++++++++
 2 files changed, 17 insertions(+)

diff -puN arch/x86_64/mm/init.c~x86_64-allocate-sparsemem-memmap-above-4g arch/x86_64/mm/init.c
--- a/arch/x86_64/mm/init.c~x86_64-allocate-sparsemem-memmap-above-4g
+++ a/arch/x86_64/mm/init.c
@@ -770,3 +770,9 @@ const char *arch_vma_name(struct vm_area
 		return "[vsyscall]";
 	return NULL;
 }
+
+void *alloc_bootmem_high_node(pg_data_t *pgdat, unsigned long size)
+{
+	return __alloc_bootmem_core(pgdat->bdata, size,
+			SMP_CACHE_BYTES, (4UL*1024*1024*1024), 0);
+}
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

git-ia64.patch
x86_64-allocate-sparsemem-memmap-above-4g.patch
x86_64-allocate-sparsemem-memmap-above-4g-fix.patch
