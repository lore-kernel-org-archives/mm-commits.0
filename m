From: akpm@linux-foundation.org
Subject: +
 mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute.patch added to -mm tree
Date: Tue, 02 Jun 2015 14:37:29 -0700
Message-ID: <556e2219.CnBhwQ+zvhqkeF46%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbbFBVha (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Jun 2015 17:37:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony.luck@intel.com, guohanjun@huawei.com, hpa@zytor.com, mingo@elte.hu, nao.horiguchi@gmail.com, qiuxishi@huawei.com, tglx@linutronix.de, xiexiuqi@huawei.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: add extra "flags" to memblock to allow selection of memory based on attribute
has been added to the -mm tree.  Its filename is
     mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: mm/memblock: add extra "flags" to memblock to allow selection of memory based on attribute

Some high end Intel Xeon systems report uncorrectable memory errors as a
recoverable machine check.  Linux has included code for some time to
process these and just signal the affected processes (or even recover
completely if the error was in a read only page that can be replaced by
reading from disk).

But we have no recovery path for errors encountered during kernel code
execution.  Except for some very specific cases were are unlikely to ever
be able to recover.

Enter memory mirroring. Actually 3rd generation of memory mirroing.

Gen1: All memory is mirrored
	Pro: No s/w enabling - h/w just gets good data from other side of the
	     mirror
	Con: Halves effective memory capacity available to OS/applications

Gen2: Partial memory mirror - just mirror memory begind some memory controllers
	Pro: Keep more of the capacity
	Con: Nightmare to enable. Have to choose between allocating from
	     mirrored memory for safety vs. NUMA local memory for performance

Gen3: Address range partial memory mirror - some mirror on each memory
      controller
	Pro: Can tune the amount of mirror and keep NUMA performance
	Con: I have to write memory management code to implement

The current plan is just to use mirrored memory for kernel allocations. 
This has been broken into two phases:

1) This patch series - find the mirrored memory, use it for boot time
   allocations

2) Wade into mm/page_alloc.c and define a ZONE_MIRROR to pick up the
   unused mirrored memory from mm/memblock.c and only give it out to
   select kernel allocations (this is still being scoped because
   page_alloc.c is scary).


This patch (of 3):


Add extra "flags" to memblock to allow selection of memory based on
attribute.  No functional changes

Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Xiexiuqi <xiexiuqi@huawei.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/kernel/crash_dump.c |    5 +-
 arch/sparc/mm/init_64.c       |    6 ++-
 arch/x86/kernel/check.c       |    3 +
 arch/x86/kernel/e820.c        |    3 +
 arch/x86/mm/init_32.c         |    2 -
 include/linux/memblock.h      |   41 +++++++++++++++--------
 mm/cma.c                      |    6 ++-
 mm/memblock.c                 |   55 ++++++++++++++++++++------------
 mm/memtest.c                  |    3 +
 mm/nobootmem.c                |    6 ++-
 10 files changed, 83 insertions(+), 47 deletions(-)

diff -puN arch/s390/kernel/crash_dump.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute arch/s390/kernel/crash_dump.c
--- a/arch/s390/kernel/crash_dump.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute
+++ a/arch/s390/kernel/crash_dump.c
@@ -33,11 +33,12 @@ static struct memblock_type oldmem_type
 };
 
 #define for_each_dump_mem_range(i, nid, p_start, p_end, p_nid)		\
-	for (i = 0, __next_mem_range(&i, nid, &memblock.physmem,	\
+	for (i = 0, __next_mem_range(&i, nid, MEMBLOCK_NONE,		\
+				     &memblock.physmem,			\
 				     &oldmem_type, p_start,		\
 				     p_end, p_nid);			\
 	     i != (u64)ULLONG_MAX;					\
-	     __next_mem_range(&i, nid, &memblock.physmem,		\
+	     __next_mem_range(&i, nid, MEMBLOCK_NONE, &memblock.physmem,\
 			      &oldmem_type,				\
 			      p_start, p_end, p_nid))
 
diff -puN arch/sparc/mm/init_64.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute arch/sparc/mm/init_64.c
--- a/arch/sparc/mm/init_64.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute
+++ a/arch/sparc/mm/init_64.c
@@ -1966,7 +1966,8 @@ static phys_addr_t __init available_memo
 	phys_addr_t pa_start, pa_end;
 	u64 i;
 
-	for_each_free_mem_range(i, NUMA_NO_NODE, &pa_start, &pa_end, NULL)
+	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &pa_start,
+				&pa_end, NULL)
 		available = available + (pa_end  - pa_start);
 
 	return available;
@@ -1992,7 +1993,8 @@ static void __init reduce_memory(phys_ad
 	if (limit_ram >= avail_ram)
 		return;
 
-	for_each_free_mem_range(i, NUMA_NO_NODE, &pa_start, &pa_end, NULL) {
+	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &pa_start,
+				&pa_end, NULL) {
 		phys_addr_t region_size = pa_end - pa_start;
 		phys_addr_t clip_start = pa_start;
 
diff -puN arch/x86/kernel/check.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute arch/x86/kernel/check.c
--- a/arch/x86/kernel/check.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute
+++ a/arch/x86/kernel/check.c
@@ -91,7 +91,8 @@ void __init setup_bios_corruption_check(
 
 	corruption_check_size = round_up(corruption_check_size, PAGE_SIZE);
 
-	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL) {
+	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end,
+				NULL) {
 		start = clamp_t(phys_addr_t, round_up(start, PAGE_SIZE),
 				PAGE_SIZE, corruption_check_size);
 		end = clamp_t(phys_addr_t, round_down(end, PAGE_SIZE),
diff -puN arch/x86/kernel/e820.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute arch/x86/kernel/e820.c
--- a/arch/x86/kernel/e820.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute
+++ a/arch/x86/kernel/e820.c
@@ -1123,7 +1123,8 @@ void __init memblock_find_dma_reserve(vo
 		nr_pages += end_pfn - start_pfn;
 	}
 
-	for_each_free_mem_range(u, NUMA_NO_NODE, &start, &end, NULL) {
+	for_each_free_mem_range(u, NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end,
+				NULL) {
 		start_pfn = min_t(unsigned long, PFN_UP(start), MAX_DMA_PFN);
 		end_pfn = min_t(unsigned long, PFN_DOWN(end), MAX_DMA_PFN);
 		if (start_pfn < end_pfn)
diff -puN arch/x86/mm/init_32.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute arch/x86/mm/init_32.c
--- a/arch/x86/mm/init_32.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute
+++ a/arch/x86/mm/init_32.c
@@ -433,7 +433,7 @@ void __init add_highpages_with_active_re
 	phys_addr_t start, end;
 	u64 i;
 
-	for_each_free_mem_range(i, nid, &start, &end, NULL) {
+	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
 		unsigned long pfn = clamp_t(unsigned long, PFN_UP(start),
 					    start_pfn, end_pfn);
 		unsigned long e_pfn = clamp_t(unsigned long, PFN_DOWN(end),
diff -puN include/linux/memblock.h~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute
+++ a/include/linux/memblock.h
@@ -21,7 +21,10 @@
 #define INIT_PHYSMEM_REGIONS	4
 
 /* Definition of memblock flags. */
-#define MEMBLOCK_HOTPLUG	0x1	/* hotpluggable region */
+enum {
+	MEMBLOCK_NONE		= 0x0,	/* No special request */
+	MEMBLOCK_HOTPLUG	= 0x1,	/* hotpluggable region */
+};
 
 struct memblock_region {
 	phys_addr_t base;
@@ -61,7 +64,7 @@ extern bool movable_node_enabled;
 
 phys_addr_t memblock_find_in_range_node(phys_addr_t size, phys_addr_t align,
 					    phys_addr_t start, phys_addr_t end,
-					    int nid);
+					    int nid, ulong flags);
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
 phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
@@ -85,11 +88,13 @@ int memblock_remove_range(struct membloc
 			  phys_addr_t base,
 			  phys_addr_t size);
 
-void __next_mem_range(u64 *idx, int nid, struct memblock_type *type_a,
+void __next_mem_range(u64 *idx, int nid, ulong flags,
+		      struct memblock_type *type_a,
 		      struct memblock_type *type_b, phys_addr_t *out_start,
 		      phys_addr_t *out_end, int *out_nid);
 
-void __next_mem_range_rev(u64 *idx, int nid, struct memblock_type *type_a,
+void __next_mem_range_rev(u64 *idx, int nid, ulong flags,
+			  struct memblock_type *type_a,
 			  struct memblock_type *type_b, phys_addr_t *out_start,
 			  phys_addr_t *out_end, int *out_nid);
 
@@ -103,16 +108,17 @@ void __next_reserved_mem_region(u64 *idx
  * @type_a: ptr to memblock_type to iterate
  * @type_b: ptr to memblock_type which excludes from the iteration
  * @nid: node selector, %NUMA_NO_NODE for all nodes
+ * @flags: pick from blocks based on memory attributes
  * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
  */
-#define for_each_mem_range(i, type_a, type_b, nid,			\
+#define for_each_mem_range(i, type_a, type_b, nid, flags,		\
 			   p_start, p_end, p_nid)			\
-	for (i = 0, __next_mem_range(&i, nid, type_a, type_b,		\
+	for (i = 0, __next_mem_range(&i, nid, flags, type_a, type_b,	\
 				     p_start, p_end, p_nid);		\
 	     i != (u64)ULLONG_MAX;					\
-	     __next_mem_range(&i, nid, type_a, type_b,			\
+	     __next_mem_range(&i, nid, flags, type_a, type_b,		\
 			      p_start, p_end, p_nid))
 
 /**
@@ -122,17 +128,18 @@ void __next_reserved_mem_region(u64 *idx
  * @type_a: ptr to memblock_type to iterate
  * @type_b: ptr to memblock_type which excludes from the iteration
  * @nid: node selector, %NUMA_NO_NODE for all nodes
+ * @flags: pick from blocks based on memory attributes
  * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
  */
-#define for_each_mem_range_rev(i, type_a, type_b, nid,			\
+#define for_each_mem_range_rev(i, type_a, type_b, nid, flags,		\
 			       p_start, p_end, p_nid)			\
 	for (i = (u64)ULLONG_MAX,					\
-		     __next_mem_range_rev(&i, nid, type_a, type_b,	\
+		     __next_mem_range_rev(&i, nid, flags, type_a, type_b,\
 					 p_start, p_end, p_nid);	\
 	     i != (u64)ULLONG_MAX;					\
-	     __next_mem_range_rev(&i, nid, type_a, type_b,		\
+	     __next_mem_range_rev(&i, nid, flags, type_a, type_b,	\
 				  p_start, p_end, p_nid))
 
 /**
@@ -199,13 +206,14 @@ void __next_mem_pfn_range(int *idx, int
  * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
+ * @flags: pick from blocks based on memory attributes
  *
  * Walks over free (memory && !reserved) areas of memblock.  Available as
  * soon as memblock is initialized.
  */
-#define for_each_free_mem_range(i, nid, p_start, p_end, p_nid)		\
+#define for_each_free_mem_range(i, nid, flags, p_start, p_end, p_nid)	\
 	for_each_mem_range(i, &memblock.memory, &memblock.reserved,	\
-			   nid, p_start, p_end, p_nid)
+			   nid, flags, p_start, p_end, p_nid)
 
 /**
  * for_each_free_mem_range_reverse - rev-iterate through free memblock areas
@@ -214,13 +222,15 @@ void __next_mem_pfn_range(int *idx, int
  * @p_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @p_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @p_nid: ptr to int for nid of the range, can be %NULL
+ * @flags: pick from blocks based on memory attributes
  *
  * Walks over free (memory && !reserved) areas of memblock in reverse
  * order.  Available as soon as memblock is initialized.
  */
-#define for_each_free_mem_range_reverse(i, nid, p_start, p_end, p_nid)	\
+#define for_each_free_mem_range_reverse(i, nid, flags, p_start, p_end,	\
+					p_nid)				\
 	for_each_mem_range_rev(i, &memblock.memory, &memblock.reserved,	\
-			       nid, p_start, p_end, p_nid)
+			       nid, flags, p_start, p_end, p_nid)
 
 static inline void memblock_set_region_flags(struct memblock_region *r,
 					     unsigned long flags)
@@ -291,7 +301,8 @@ static inline bool memblock_bottom_up(vo
 #define MEMBLOCK_ALLOC_ACCESSIBLE	0
 
 phys_addr_t __init memblock_alloc_range(phys_addr_t size, phys_addr_t align,
-					phys_addr_t start, phys_addr_t end);
+					phys_addr_t start, phys_addr_t end,
+					ulong flags);
 phys_addr_t memblock_alloc_base(phys_addr_t size, phys_addr_t align,
 				phys_addr_t max_addr);
 phys_addr_t __memblock_alloc_base(phys_addr_t size, phys_addr_t align,
diff -puN mm/cma.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute mm/cma.c
--- a/mm/cma.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute
+++ a/mm/cma.c
@@ -316,13 +316,15 @@ int __init cma_declare_contiguous(phys_a
 		 */
 		if (base < highmem_start && limit > highmem_start) {
 			addr = memblock_alloc_range(size, alignment,
-						    highmem_start, limit);
+						    highmem_start, limit,
+						    MEMBLOCK_NONE);
 			limit = highmem_start;
 		}
 
 		if (!addr) {
 			addr = memblock_alloc_range(size, alignment, base,
-						    limit);
+						    limit,
+						    MEMBLOCK_NONE);
 			if (!addr) {
 				ret = -ENOMEM;
 				goto err;
diff -puN mm/memblock.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute mm/memblock.c
--- a/mm/memblock.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute
+++ a/mm/memblock.c
@@ -107,6 +107,7 @@ static long __init_memblock memblock_ove
  * @size: size of free area to find
  * @align: alignment of free area to find
  * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
+ * @flags: pick from blocks based on memory attributes
  *
  * Utility called from memblock_find_in_range_node(), find free area bottom-up.
  *
@@ -115,12 +116,13 @@ static long __init_memblock memblock_ove
  */
 static phys_addr_t __init_memblock
 __memblock_find_range_bottom_up(phys_addr_t start, phys_addr_t end,
-				phys_addr_t size, phys_addr_t align, int nid)
+				phys_addr_t size, phys_addr_t align, int nid,
+				ulong flags)
 {
 	phys_addr_t this_start, this_end, cand;
 	u64 i;
 
-	for_each_free_mem_range(i, nid, &this_start, &this_end, NULL) {
+	for_each_free_mem_range(i, nid, flags, &this_start, &this_end, NULL) {
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
 
@@ -139,6 +141,7 @@ __memblock_find_range_bottom_up(phys_add
  * @size: size of free area to find
  * @align: alignment of free area to find
  * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
+ * @flags: pick from blocks based on memory attributes
  *
  * Utility called from memblock_find_in_range_node(), find free area top-down.
  *
@@ -147,12 +150,14 @@ __memblock_find_range_bottom_up(phys_add
  */
 static phys_addr_t __init_memblock
 __memblock_find_range_top_down(phys_addr_t start, phys_addr_t end,
-			       phys_addr_t size, phys_addr_t align, int nid)
+			       phys_addr_t size, phys_addr_t align, int nid,
+			       ulong flags)
 {
 	phys_addr_t this_start, this_end, cand;
 	u64 i;
 
-	for_each_free_mem_range_reverse(i, nid, &this_start, &this_end, NULL) {
+	for_each_free_mem_range_reverse(i, nid, flags, &this_start, &this_end,
+					NULL) {
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
 
@@ -174,6 +179,7 @@ __memblock_find_range_top_down(phys_addr
  * @start: start of candidate range
  * @end: end of candidate range, can be %MEMBLOCK_ALLOC_{ANYWHERE|ACCESSIBLE}
  * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
+ * @flags: pick from blocks based on memory attributes
  *
  * Find @size free area aligned to @align in the specified range and node.
  *
@@ -190,7 +196,7 @@ __memblock_find_range_top_down(phys_addr
  */
 phys_addr_t __init_memblock memblock_find_in_range_node(phys_addr_t size,
 					phys_addr_t align, phys_addr_t start,
-					phys_addr_t end, int nid)
+					phys_addr_t end, int nid, ulong flags)
 {
 	phys_addr_t kernel_end, ret;
 
@@ -215,7 +221,7 @@ phys_addr_t __init_memblock memblock_fin
 
 		/* ok, try bottom-up allocation first */
 		ret = __memblock_find_range_bottom_up(bottom_up_start, end,
-						      size, align, nid);
+						      size, align, nid, flags);
 		if (ret)
 			return ret;
 
@@ -233,7 +239,8 @@ phys_addr_t __init_memblock memblock_fin
 			     "memory hotunplug may be affected\n");
 	}
 
-	return __memblock_find_range_top_down(start, end, size, align, nid);
+	return __memblock_find_range_top_down(start, end, size, align, nid,
+					      flags);
 }
 
 /**
@@ -253,7 +260,7 @@ phys_addr_t __init_memblock memblock_fin
 					phys_addr_t align)
 {
 	return memblock_find_in_range_node(size, align, start, end,
-					    NUMA_NO_NODE);
+					    NUMA_NO_NODE, MEMBLOCK_NONE);
 }
 
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
@@ -814,6 +821,7 @@ void __init_memblock __next_reserved_mem
  * __next__mem_range - next function for for_each_free_mem_range() etc.
  * @idx: pointer to u64 loop variable
  * @nid: node selector, %NUMA_NO_NODE for all nodes
+ * @flags: pick from blocks based on memory attributes
  * @type_a: pointer to memblock_type from where the range is taken
  * @type_b: pointer to memblock_type which excludes memory from being taken
  * @out_start: ptr to phys_addr_t for start address of the range, can be %NULL
@@ -835,7 +843,7 @@ void __init_memblock __next_reserved_mem
  * As both region arrays are sorted, the function advances the two indices
  * in lockstep and returns each intersection.
  */
-void __init_memblock __next_mem_range(u64 *idx, int nid,
+void __init_memblock __next_mem_range(u64 *idx, int nid, ulong flags,
 				      struct memblock_type *type_a,
 				      struct memblock_type *type_b,
 				      phys_addr_t *out_start,
@@ -927,6 +935,7 @@ void __init_memblock __next_mem_range(u6
  *
  * @idx: pointer to u64 loop variable
  * @nid: nid: node selector, %NUMA_NO_NODE for all nodes
+ * @flags: pick from blocks based on memory attributes
  * @type_a: pointer to memblock_type from where the range is taken
  * @type_b: pointer to memblock_type which excludes memory from being taken
  * @out_start: ptr to phys_addr_t for start address of the range, can be %NULL
@@ -935,7 +944,7 @@ void __init_memblock __next_mem_range(u6
  *
  * Reverse of __next_mem_range().
  */
-void __init_memblock __next_mem_range_rev(u64 *idx, int nid,
+void __init_memblock __next_mem_range_rev(u64 *idx, int nid, ulong flags,
 					  struct memblock_type *type_a,
 					  struct memblock_type *type_b,
 					  phys_addr_t *out_start,
@@ -1082,14 +1091,15 @@ int __init_memblock memblock_set_node(ph
 
 static phys_addr_t __init memblock_alloc_range_nid(phys_addr_t size,
 					phys_addr_t align, phys_addr_t start,
-					phys_addr_t end, int nid)
+					phys_addr_t end, int nid, ulong flags)
 {
 	phys_addr_t found;
 
 	if (!align)
 		align = SMP_CACHE_BYTES;
 
-	found = memblock_find_in_range_node(size, align, start, end, nid);
+	found = memblock_find_in_range_node(size, align, start, end, nid,
+					    flags);
 	if (found && !memblock_reserve(found, size)) {
 		/*
 		 * The min_count is set to 0 so that memblock allocations are
@@ -1102,26 +1112,30 @@ static phys_addr_t __init memblock_alloc
 }
 
 phys_addr_t __init memblock_alloc_range(phys_addr_t size, phys_addr_t align,
-					phys_addr_t start, phys_addr_t end)
+					phys_addr_t start, phys_addr_t end,
+					ulong flags)
 {
-	return memblock_alloc_range_nid(size, align, start, end, NUMA_NO_NODE);
+	return memblock_alloc_range_nid(size, align, start, end, NUMA_NO_NODE,
+					flags);
 }
 
 static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
 					phys_addr_t align, phys_addr_t max_addr,
-					int nid)
+					int nid, ulong flags)
 {
-	return memblock_alloc_range_nid(size, align, 0, max_addr, nid);
+	return memblock_alloc_range_nid(size, align, 0, max_addr, nid, flags);
 }
 
 phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
 {
-	return memblock_alloc_base_nid(size, align, MEMBLOCK_ALLOC_ACCESSIBLE, nid);
+	return memblock_alloc_base_nid(size, align, MEMBLOCK_ALLOC_ACCESSIBLE,
+				       nid, MEMBLOCK_NONE);
 }
 
 phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
 {
-	return memblock_alloc_base_nid(size, align, max_addr, NUMA_NO_NODE);
+	return memblock_alloc_base_nid(size, align, max_addr, NUMA_NO_NODE,
+				       MEMBLOCK_NONE);
 }
 
 phys_addr_t __init memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
@@ -1205,13 +1219,14 @@ static void * __init memblock_virt_alloc
 
 again:
 	alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
-					    nid);
+					    nid, MEMBLOCK_NONE);
 	if (alloc)
 		goto done;
 
 	if (nid != NUMA_NO_NODE) {
 		alloc = memblock_find_in_range_node(size, align, min_addr,
-						    max_addr,  NUMA_NO_NODE);
+						    max_addr, NUMA_NO_NODE,
+						    MEMBLOCK_NONE);
 		if (alloc)
 			goto done;
 	}
diff -puN mm/memtest.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute mm/memtest.c
--- a/mm/memtest.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute
+++ a/mm/memtest.c
@@ -74,7 +74,8 @@ static void __init do_one_pass(u64 patte
 	u64 i;
 	phys_addr_t this_start, this_end;
 
-	for_each_free_mem_range(i, NUMA_NO_NODE, &this_start, &this_end, NULL) {
+	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &this_start,
+				&this_end, NULL) {
 		this_start = clamp(this_start, start, end);
 		this_end = clamp(this_end, start, end);
 		if (this_start < this_end) {
diff -puN mm/nobootmem.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute mm/nobootmem.c
--- a/mm/nobootmem.c~mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute
+++ a/mm/nobootmem.c
@@ -41,7 +41,8 @@ static void * __init __alloc_memory_core
 	if (limit > memblock.current_limit)
 		limit = memblock.current_limit;
 
-	addr = memblock_find_in_range_node(size, align, goal, limit, nid);
+	addr = memblock_find_in_range_node(size, align, goal, limit, nid,
+					   MEMBLOCK_NONE);
 	if (!addr)
 		return NULL;
 
@@ -124,7 +125,8 @@ static unsigned long __init free_low_mem
 	for_each_reserved_mem_region(i, &start, &end)
 		reserve_bootmem_region(start, end);
 
-	for_each_free_mem_range(i, NUMA_NO_NODE, &start, &end, NULL)
+	for_each_free_mem_range(i, NUMA_NO_NODE, MEMBLOCK_NONE, &start, &end,
+				NULL)
 		count += __free_memory_core(start, end);
 
 #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
_

Patches currently in -mm which might be from tony.luck@intel.com are

mm-hugetlb-reduce-arch-dependent-code-about-huge_pmd_unshare.patch
memblock-introduce-a-for_each_reserved_mem_region-iterator.patch
mm-meminit-move-page-initialization-into-a-separate-function.patch
mm-meminit-only-set-page-reserved-in-the-memblock-region.patch
mm-page_alloc-pass-pfn-to-__free_pages_bootmem.patch
mm-meminit-make-__early_pfn_to_nid-smp-safe-and-introduce-meminit_pfn_in_nid.patch
mm-meminit-inline-some-helper-functions.patch
mm-meminit-initialise-a-subset-of-struct-pages-if-config_deferred_struct_page_init-is-set.patch
mm-meminit-initialise-remaining-struct-pages-in-parallel-with-kswapd.patch
mm-meminit-minimise-number-of-pfn-page-lookups-during-initialisation.patch
x86-mm-enable-deferred-struct-page-initialisation-on-x86-64.patch
mm-meminit-free-pages-in-large-chunks-where-possible.patch
mm-meminit-reduce-number-of-times-pageblocks-are-set-during-struct-page-init.patch
mm-meminit-remove-mminit_verify_page_links.patch
mm-memory-failure-split-thp-earlier-in-memory-error-handling.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling.patch
mm-soft-offline-dont-free-target-page-in-successful-page-migration.patch
mm-memory-failure-me_huge_page-does-nothing-for-thp.patch
memory-failure-export-page_type-and-action-result.patch
memory-failure-change-type-of-action_results-param-3-to-enum.patch
tracing-add-trace-event-for-memory-failure.patch
tracing-add-trace-event-for-memory-failure-fix.patch
mm-memblock-add-extra-flags-to-memblock-to-allow-selection-of-memory-based-on-attribute.patch
mm-memblock-allocate-boot-time-data-structures-from-mirrored-memory.patch
x86-mirror-x86-enabling-find-mirrored-memory-ranges.patch
linux-next.patch

