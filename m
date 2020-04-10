From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 09/35] mm: cma: NUMA node interface
Date: Fri, 10 Apr 2020 14:32:42 -0700
Message-ID: <20200410213242.zhwK7YuKI%akpm@linux-foundation.org>
References: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726582AbgDJVcn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 10 Apr 2020 17:32:43 -0400
In-Reply-To: <20200410143047.bf34a933ce1affdc042c7c80@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreas.schaufler@gmx.de, aslan@fb.com, guro@fb.com, js1304@gmail.com, linux-mm@kvack.org, mhocko@kernel.org, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, riel@surriel.com, torvalds@linux-foundation.org

From: Aslan Bakirov <aslan@fb.com>
Subject: mm: cma: NUMA node interface

I've noticed that there is no interfaces exposed by CMA which would let me
to declare contigous memory on particular NUMA node.

This patchset adds the ability to try to allocate contiguous memory on
specific node.  It will fallback to other nodes if the specified one
doesn't work.

Implement a new method for declaring contigous memory on particular node
and keep cma_declare_contiguous() as a wrapper.

[akpm@linux-foundation.org: build fix]
Link: http://lkml.kernel.org/r/20200407163840.92263-2-guro@fb.com
Signed-off-by: Aslan Bakirov <aslan@fb.com>
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Michal Hocko <mhocko@kernel.org>
Cc: Andreas Schaufler <andreas.schaufler@gmx.de>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Joonsoo Kim <js1304@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cma.h      |   14 ++++++++++++--
 include/linux/memblock.h |    3 +++
 mm/cma.c                 |   16 +++++++++-------
 mm/memblock.c            |    2 +-
 4 files changed, 25 insertions(+), 10 deletions(-)

--- a/include/linux/cma.h~mm-cma-numa-node-interface
+++ a/include/linux/cma.h
@@ -4,6 +4,7 @@
 
 #include <linux/init.h>
 #include <linux/types.h>
+#include <linux/numa.h>
 
 /*
  * There is always at least global CMA area and a few optional
@@ -24,10 +25,19 @@ extern phys_addr_t cma_get_base(const st
 extern unsigned long cma_get_size(const struct cma *cma);
 extern const char *cma_get_name(const struct cma *cma);
 
-extern int __init cma_declare_contiguous(phys_addr_t base,
+extern int __init cma_declare_contiguous_nid(phys_addr_t base,
 			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
-			bool fixed, const char *name, struct cma **res_cma);
+			bool fixed, const char *name, struct cma **res_cma,
+			int nid);
+static inline int __init cma_declare_contiguous(phys_addr_t base,
+			phys_addr_t size, phys_addr_t limit,
+			phys_addr_t alignment, unsigned int order_per_bit,
+			bool fixed, const char *name, struct cma **res_cma)
+{
+	return cma_declare_contiguous_nid(base, size, limit, alignment,
+			order_per_bit, fixed, name, res_cma, NUMA_NO_NODE);
+}
 extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 					unsigned int order_per_bit,
 					const char *name,
--- a/include/linux/memblock.h~mm-cma-numa-node-interface
+++ a/include/linux/memblock.h
@@ -348,6 +348,9 @@ static inline int memblock_get_region_no
 
 phys_addr_t memblock_phys_alloc_range(phys_addr_t size, phys_addr_t align,
 				      phys_addr_t start, phys_addr_t end);
+phys_addr_t memblock_alloc_range_nid(phys_addr_t size,
+				      phys_addr_t align, phys_addr_t start,
+				      phys_addr_t end, int nid, bool exact_nid);
 phys_addr_t memblock_phys_alloc_try_nid(phys_addr_t size, phys_addr_t align, int nid);
 
 static inline phys_addr_t memblock_phys_alloc(phys_addr_t size,
--- a/mm/cma.c~mm-cma-numa-node-interface
+++ a/mm/cma.c
@@ -220,7 +220,7 @@ int __init cma_init_reserved_mem(phys_ad
 }
 
 /**
- * cma_declare_contiguous() - reserve custom contiguous area
+ * cma_declare_contiguous_nid() - reserve custom contiguous area
  * @base: Base address of the reserved area optional, use 0 for any
  * @size: Size of the reserved area (in bytes),
  * @limit: End address of the reserved memory (optional, 0 for any).
@@ -229,6 +229,7 @@ int __init cma_init_reserved_mem(phys_ad
  * @fixed: hint about where to place the reserved area
  * @name: The name of the area. See function cma_init_reserved_mem()
  * @res_cma: Pointer to store the created cma region.
+ * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
  *
  * This function reserves memory from early allocator. It should be
  * called by arch specific code once the early allocator (memblock or bootmem)
@@ -238,10 +239,11 @@ int __init cma_init_reserved_mem(phys_ad
  * If @fixed is true, reserve contiguous area at exactly @base.  If false,
  * reserve in range from @base to @limit.
  */
-int __init cma_declare_contiguous(phys_addr_t base,
+int __init cma_declare_contiguous_nid(phys_addr_t base,
 			phys_addr_t size, phys_addr_t limit,
 			phys_addr_t alignment, unsigned int order_per_bit,
-			bool fixed, const char *name, struct cma **res_cma)
+			bool fixed, const char *name, struct cma **res_cma,
+			int nid)
 {
 	phys_addr_t memblock_end = memblock_end_of_DRAM();
 	phys_addr_t highmem_start;
@@ -336,14 +338,14 @@ int __init cma_declare_contiguous(phys_a
 		 * memory in case of failure.
 		 */
 		if (base < highmem_start && limit > highmem_start) {
-			addr = memblock_phys_alloc_range(size, alignment,
-							 highmem_start, limit);
+			addr = memblock_alloc_range_nid(size, alignment,
+					highmem_start, limit, nid, false);
 			limit = highmem_start;
 		}
 
 		if (!addr) {
-			addr = memblock_phys_alloc_range(size, alignment, base,
-							 limit);
+			addr = memblock_alloc_range_nid(size, alignment, base,
+					limit, nid, false);
 			if (!addr) {
 				ret = -ENOMEM;
 				goto err;
--- a/mm/memblock.c~mm-cma-numa-node-interface
+++ a/mm/memblock.c
@@ -1349,7 +1349,7 @@ __next_mem_pfn_range_in_zone(u64 *idx, s
  * Return:
  * Physical address of allocated memory block on success, %0 on failure.
  */
-static phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
+phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
 					phys_addr_t align, phys_addr_t start,
 					phys_addr_t end, int nid,
 					bool exact_nid)
_
