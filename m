From: akpm@linux-foundation.org
Subject: + mm-memblock-add-support-for-excluded-memory-areas.patch added
 to -mm tree
Date: Mon, 13 Jan 2014 16:34:25 -0800
Message-ID: <52d48611.5IpIqk0t2s+breeB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54677 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaANAe0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jan 2014 19:34:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zhangyanfei@cn.fujitsu.com, yinghai@kernel.org, tangchen@cn.fujitsu.com, schwidefsky@de.ibm.com, santosh.shilimkar@ti.com, qiuxishi@huawei.com, liuj97@gmail.com, grygorii.strashko@ti.com, dhowells@redhat.com, daeseok.youn@gmail.com, phacht@linux.vnet.ibm.com

Subject: + mm-memblock-add-support-for-excluded-memory-areas.patch added to -mm tree
To: phacht@linux.vnet.ibm.com,daeseok.youn@gmail.com,dhowells@redhat.com,grygorii.strashko@ti.com,liuj97@gmail.com,qiuxishi@huawei.com,santosh.shilimkar@ti.com,schwidefsky@de.ibm.com,tangchen@cn.fujitsu.com,yinghai@kernel.org,zhangyanfei@cn.fujitsu.com
From: akpm@linux-foundation.org
Date: Mon, 13 Jan 2014 16:34:25 -0800


The patch titled
     Subject: mm/memblock: Add support for excluded memory areas
has been added to the -mm tree.  Its filename is
     mm-memblock-add-support-for-excluded-memory-areas.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-add-support-for-excluded-memory-areas.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-add-support-for-excluded-memory-areas.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Subject: mm/memblock: Add support for excluded memory areas

While further working on the s390 migration to memblock it is desirable to
have memblock support unmapped (i.e.  completely forgotten and unused)
memory areas.  The usual way of just forgetting about them by means of
truncating the memblocks does not work for us because we still need the
information about the real full memory structure at a later time.

Add a new memory state "nomap" to memblock.  This can be used to truncate
the usable memory in the system without forgetting about what is really
installed.

Signed-off-by: Philipp Hachtmann <phacht@linux.vnet.ibm.com>
Cc: qiuxishi <qiuxishi@huawei.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Daeseok Youn <daeseok.youn@gmail.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Tang Chen <tangchen@cn.fujitsu.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/s390/Kconfig        |    1 
 include/linux/memblock.h |   50 +++++--
 mm/Kconfig               |    3 
 mm/memblock.c            |  263 ++++++++++++++++++++++++++++---------
 mm/nobootmem.c           |    9 +
 5 files changed, 255 insertions(+), 71 deletions(-)

diff -puN arch/s390/Kconfig~mm-memblock-add-support-for-excluded-memory-areas arch/s390/Kconfig
--- a/arch/s390/Kconfig~mm-memblock-add-support-for-excluded-memory-areas
+++ a/arch/s390/Kconfig
@@ -61,6 +61,7 @@ config PCI_QUIRKS
 config S390
 	def_bool y
 	select ARCH_DISCARD_MEMBLOCK
+	select ARCH_MEMBLOCK_NOMAP
 	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
 	select ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
diff -puN include/linux/memblock.h~mm-memblock-add-support-for-excluded-memory-areas include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-add-support-for-excluded-memory-areas
+++ a/include/linux/memblock.h
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 
 #define INIT_MEMBLOCK_REGIONS	128
+#define INIT_MEMBLOCK_NOMAP_REGIONS 4
 
 /* Definition of memblock flags. */
 #define MEMBLOCK_HOTPLUG	0x1	/* hotpluggable region */
@@ -43,6 +44,9 @@ struct memblock {
 	phys_addr_t current_limit;
 	struct memblock_type memory;
 	struct memblock_type reserved;
+#ifdef CONFIG_ARCH_MEMBLOCK_NOMAP
+	struct memblock_type nomap;
+#endif
 };
 
 extern struct memblock memblock;
@@ -68,6 +72,10 @@ int memblock_add(phys_addr_t base, phys_
 int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_free(phys_addr_t base, phys_addr_t size);
 int memblock_reserve(phys_addr_t base, phys_addr_t size);
+#ifdef CONFIG_ARCH_MEMBLOCK_NOMAP
+int memblock_nomap(phys_addr_t base, phys_addr_t size);
+int memblock_remap(phys_addr_t base, phys_addr_t size);
+#endif
 void memblock_trim_memory(phys_addr_t align);
 int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
 int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
@@ -113,8 +121,9 @@ void __next_mem_pfn_range(int *idx, int
 	     i >= 0; __next_mem_pfn_range(&i, nid, p_start, p_end, p_nid))
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
-void __next_free_mem_range(u64 *idx, int nid, phys_addr_t *out_start,
-			   phys_addr_t *out_end, int *out_nid);
+void __next_mem_range(u64 *idx, int nid, struct memblock_type *type_a,
+		      struct memblock_type *type_b, phys_addr_t *out_start,
+		      phys_addr_t *out_end, int *out_nid);
 
 /**
  * for_each_free_mem_range - iterate through free memblock areas
@@ -129,12 +138,31 @@ void __next_free_mem_range(u64 *idx, int
  */
 #define for_each_free_mem_range(i, nid, p_start, p_end, p_nid)		\
 	for (i = 0,							\
-	     __next_free_mem_range(&i, nid, p_start, p_end, p_nid);	\
+		     __next_mem_range(&i, nid, &memblock.memory,	\
+				      &memblock.reserved, p_start,	\
+				      p_end, p_nid);			\
+	     i != (u64)ULLONG_MAX;					\
+	     __next_mem_range(&i, nid, &memblock.memory,		\
+			       &memblock.reserved,			\
+			       p_start, p_end, p_nid))
+
+#ifdef CONFIG_ARCH_MEMBLOCK_NOMAP
+#define for_each_mapped_mem_range(i, nid, p_start, p_end, p_nid)	\
+	for (i = 0,							\
+		     __next_mem_range(&i, nid, &memblock.memory,	\
+				      &memblock.nomap, p_start,		\
+				      p_end, p_nid);			\
 	     i != (u64)ULLONG_MAX;					\
-	     __next_free_mem_range(&i, nid, p_start, p_end, p_nid))
+	     __next_mem_range(&i, nid, &memblock.memory,		\
+			       &memblock.nomap,				\
+			       p_start, p_end, p_nid))
+#endif
 
-void __next_free_mem_range_rev(u64 *idx, int nid, phys_addr_t *out_start,
-			       phys_addr_t *out_end, int *out_nid);
+void __next_mem_range_rev(u64 *idx, int nid,
+			  struct memblock_type *type_a,
+			  struct memblock_type *type_b,
+			  phys_addr_t *out_start,
+			  phys_addr_t *out_end, int *out_nid);
 
 /**
  * for_each_free_mem_range_reverse - rev-iterate through free memblock areas
@@ -149,9 +177,15 @@ void __next_free_mem_range_rev(u64 *idx,
  */
 #define for_each_free_mem_range_reverse(i, nid, p_start, p_end, p_nid)	\
 	for (i = (u64)ULLONG_MAX,					\
-	     __next_free_mem_range_rev(&i, nid, p_start, p_end, p_nid);	\
+		     __next_mem_range_rev(&i, nid,			\
+					  &memblock.memory,		\
+					  &memblock.reserved,		\
+					  p_start, p_end, p_nid);	\
 	     i != (u64)ULLONG_MAX;					\
-	     __next_free_mem_range_rev(&i, nid, p_start, p_end, p_nid))
+	     __next_mem_range_rev(&i, nid,				\
+				  &memblock.memory,			\
+				  &memblock.reserved,			\
+				  p_start, p_end, p_nid))
 
 static inline void memblock_set_region_flags(struct memblock_region *r,
 					     unsigned long flags)
diff -puN mm/Kconfig~mm-memblock-add-support-for-excluded-memory-areas mm/Kconfig
--- a/mm/Kconfig~mm-memblock-add-support-for-excluded-memory-areas
+++ a/mm/Kconfig
@@ -137,6 +137,9 @@ config HAVE_MEMBLOCK_NODE_MAP
 config ARCH_DISCARD_MEMBLOCK
 	boolean
 
+config ARCH_MEMBLOCK_NOMAP
+	boolean
+
 config NO_BOOTMEM
 	boolean
 
diff -puN mm/memblock.c~mm-memblock-add-support-for-excluded-memory-areas mm/memblock.c
--- a/mm/memblock.c~mm-memblock-add-support-for-excluded-memory-areas
+++ a/mm/memblock.c
@@ -28,6 +28,11 @@
 static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
 static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
 
+#ifdef CONFIG_ARCH_MEMBLOCK_NOMAP
+static struct memblock_region
+memblock_nomap_init_regions[INIT_MEMBLOCK_NOMAP_REGIONS] __initdata_memblock;
+#endif
+
 struct memblock memblock __initdata_memblock = {
 	.memory.regions		= memblock_memory_init_regions,
 	.memory.cnt		= 1,	/* empty dummy entry */
@@ -37,6 +42,11 @@ struct memblock memblock __initdata_memb
 	.reserved.cnt		= 1,	/* empty dummy entry */
 	.reserved.max		= INIT_MEMBLOCK_REGIONS,
 
+#ifdef CONFIG_ARCH_MEMBLOCK_NOMAP
+	.nomap.regions       = memblock_nomap_init_regions,
+	.nomap.cnt           = 1,	/* empty dummy entry */
+	.nomap.max           = INIT_MEMBLOCK_NOMAP_REGIONS,
+#endif
 	.bottom_up		= false,
 	.current_limit		= MEMBLOCK_ALLOC_ANYWHERE,
 };
@@ -292,7 +302,21 @@ phys_addr_t __init_memblock get_allocate
 			  memblock.memory.max);
 }
 
-#endif
+#ifdef CONFIG_ARCH_MEMBLOCK_NOMAP
+phys_addr_t __init_memblock get_allocated_memblock_nomap_regions_info(
+					phys_addr_t *addr)
+{
+	if (memblock.memory.regions == memblock_memory_init_regions)
+		return 0;
+
+	*addr = __pa(memblock.memory.regions);
+
+	return PAGE_ALIGN(sizeof(struct memblock_region) *
+			  memblock.memory.max);
+}
+
+#endif /* CONFIG_ARCH_MEMBLOCK_NOMAP */
+#endif /* CONFIG_ARCH_DISCARD_MEMBLOCK */
 
 /**
  * memblock_double_array - double the size of the memblock regions array
@@ -757,18 +781,78 @@ int __init_memblock memblock_clear_hotpl
 	return 0;
 }
 
+#ifdef CONFIG_ARCH_MEMBLOCK_NOMAP
+/*
+ * memblock_nomap() - mark a memory range as completely unusable
+ *
+ * This can be used to exclude memory regions from every further treatment
+ * in the running system. Ranges which are added to the nomap list will
+ * also be marked as reserved. So they won't either be allocated by memblock
+ * nor freed to the page allocator.
+ *
+ * The usable (i.e. not in nomap list) memory can be iterated
+ * via for_each_mapped_mem_range().
+ *
+ * memblock_start_of_DRAM() and memblock_end_of_DRAM() still refer to the
+ * whole system memory.
+ */
+int __init_memblock memblock_nomap(phys_addr_t base, phys_addr_t size)
+{
+	int ret;
+	memblock_dbg("memblock_nomap: [%#016llx-%#016llx] %pF\n",
+		     (unsigned long long)base,
+		     (unsigned long long)base + size,
+		     (void *)_RET_IP_);
+
+	ret = memblock_add_region(&memblock.reserved, base,
+				  size, MAX_NUMNODES, 0);
+	if (ret)
+		return ret;
+
+	return memblock_add_region(&memblock.nomap, base,
+				   size, MAX_NUMNODES, 0);
+}
+
+/*
+ * memblock_remap() - remove a memory range from the nomap list
+ *
+ * This is the inverse function to memblock_nomap().
+ */
+int __init_memblock memblock_remap(phys_addr_t base, phys_addr_t size)
+{
+	int ret;
+	memblock_dbg("memblock_remap: [%#016llx-%#016llx] %pF\n",
+		     (unsigned long long)base,
+		     (unsigned long long)base + size,
+		     (void *)_RET_IP_);
+
+	ret = __memblock_remove(&memblock.reserved, base, size);
+	if (ret)
+		return ret;
+
+	return __memblock_remove(&memblock.nomap, base, size);
+}
+
+#endif
+
 /**
- * __next_free_mem_range - next function for for_each_free_mem_range()
+ * __next_mem_range - generic next function for for_each_*_range()
+ *
+ * Finds the next range from type_a which is not marked as unsuitable
+ * in type_b.
+ *
  * @idx: pointer to u64 loop variable
  * @nid: node selector, %NUMA_NO_NODE for all nodes
+ * @type_a: pointer to memblock_type from where the range is taken
+ * @type_b: pointer to memblock_type which excludes memory from being taken
  * @out_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @out_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @out_nid: ptr to int for nid of the range, can be %NULL
  *
- * Find the first free area from *@idx which matches @nid, fill the out
+ * Find the first present area from *@idx which matches @nid, fill the out
  * parameters, and update *@idx for the next iteration.  The lower 32bit of
- * *@idx contains index into memory region and the upper 32bit indexes the
- * areas before each reserved region.  For example, if reserved regions
+ * *@idx contains index into type_a region and the upper 32bit indexes the
+ * areas before each type_b region.  For example, if type_a regions
  * look like the following,
  *
  *	0:[0-16), 1:[32-48), 2:[128-130)
@@ -780,96 +864,120 @@ int __init_memblock memblock_clear_hotpl
  * As both region arrays are sorted, the function advances the two indices
  * in lockstep and returns each intersection.
  */
-void __init_memblock __next_free_mem_range(u64 *idx, int nid,
-					   phys_addr_t *out_start,
-					   phys_addr_t *out_end, int *out_nid)
+void __init_memblock __next_mem_range(u64 *idx, int nid,
+				      struct memblock_type *type_a,
+				      struct memblock_type *type_b,
+				      phys_addr_t *out_start,
+				      phys_addr_t *out_end, int *out_nid)
 {
-	struct memblock_type *mem = &memblock.memory;
-	struct memblock_type *rsv = &memblock.reserved;
-	int mi = *idx & 0xffffffff;
-	int ri = *idx >> 32;
+	int idx_a = *idx & 0xffffffff;
+	int idx_b = *idx >> 32;
 
 	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
 		nid = NUMA_NO_NODE;
 
-	for ( ; mi < mem->cnt; mi++) {
-		struct memblock_region *m = &mem->regions[mi];
+	for (; idx_a < type_a->cnt; idx_a++) {
+		struct memblock_region *m = &type_a->regions[idx_a];
 		phys_addr_t m_start = m->base;
 		phys_addr_t m_end = m->base + m->size;
+		int         m_nid = memblock_get_region_node(m);
 
 		/* only memory regions are associated with nodes, check it */
 		if (nid != NUMA_NO_NODE && nid != memblock_get_region_node(m))
 			continue;
 
-		/* scan areas before each reservation for intersection */
-		for ( ; ri < rsv->cnt + 1; ri++) {
-			struct memblock_region *r = &rsv->regions[ri];
-			phys_addr_t r_start = ri ? r[-1].base + r[-1].size : 0;
-			phys_addr_t r_end = ri < rsv->cnt ? r->base : ULLONG_MAX;
+		/* With type_b NULL we only iterate through type_a */
+		if (type_b == NULL) {
+			if (out_start)
+				*out_start = m_start;
+			if (out_end)
+				*out_end = m_end;
+			if (out_nid)
+				*out_nid = m_nid;
+			idx_a++;
+			*idx = (u32)idx_a;
+			return;
+		}
+
+		/* scan areas before each reservation */
+		for (; idx_b < type_b->cnt + 1; idx_b++) {
+			struct memblock_region *r;
+			phys_addr_t r_start;
+			phys_addr_t r_end;
+
+			r = &type_b->regions[idx_b];
+			r_start = idx_b ? r[-1].base + r[-1].size : 0;
+			r_end = idx_b < type_b->cnt ?
+				r->base : ULLONG_MAX;
 
-			/* if ri advanced past mi, break out to advance mi */
+			/*
+			 *if idx_b advanced past idx_a,
+			 * break out to advance idx_a
+			 */
 			if (r_start >= m_end)
 				break;
 			/* if the two regions intersect, we're done */
 			if (m_start < r_end) {
 				if (out_start)
-					*out_start = max(m_start, r_start);
+					*out_start =
+						max(m_start, r_start);
 				if (out_end)
 					*out_end = min(m_end, r_end);
 				if (out_nid)
-					*out_nid = memblock_get_region_node(m);
+					*out_nid = m_nid;
+
 				/*
-				 * The region which ends first is advanced
-				 * for the next iteration.
+				 * The region which ends first is
+				 * advanced for the next iteration.
 				 */
 				if (m_end <= r_end)
-					mi++;
+					idx_a++;
 				else
-					ri++;
-				*idx = (u32)mi | (u64)ri << 32;
+					idx_b++;
+				*idx = (u32)idx_a | (u64)idx_b << 32;
 				return;
 			}
 		}
 	}
-
 	/* signal end of iteration */
 	*idx = ULLONG_MAX;
 }
 
 /**
- * __next_free_mem_range_rev - next function for for_each_free_mem_range_reverse()
+ * __next_mem_range_rev - generic next function for for_each_*_range_rev()
+ *
+ * Finds the next range from type_a which is not marked as unsuitable
+ * in type_b.
+ *
  * @idx: pointer to u64 loop variable
  * @nid: nid: node selector, %NUMA_NO_NODE for all nodes
+ * @type_a: pointer to memblock_type from where the range is taken
+ * @type_b: pointer to memblock_type which excludes memory from being taken
  * @out_start: ptr to phys_addr_t for start address of the range, can be %NULL
  * @out_end: ptr to phys_addr_t for end address of the range, can be %NULL
  * @out_nid: ptr to int for nid of the range, can be %NULL
  *
- * Reverse of __next_free_mem_range().
- *
- * Linux kernel cannot migrate pages used by itself. Memory hotplug users won't
- * be able to hot-remove hotpluggable memory used by the kernel. So this
- * function skip hotpluggable regions if needed when allocating memory for the
- * kernel.
- */
-void __init_memblock __next_free_mem_range_rev(u64 *idx, int nid,
-					   phys_addr_t *out_start,
-					   phys_addr_t *out_end, int *out_nid)
+ * Reverse of __next_mem_range().
+ */
+void __init_memblock __next_mem_range_rev(u64 *idx, int nid,
+					  struct memblock_type *type_a,
+					  struct memblock_type *type_b,
+					  phys_addr_t *out_start,
+					  phys_addr_t *out_end, int *out_nid)
 {
-	struct memblock_type *mem = &memblock.memory;
-	struct memblock_type *rsv = &memblock.reserved;
-	int mi = *idx & 0xffffffff;
-	int ri = *idx >> 32;
+	int idx_a = *idx & 0xffffffff;
+	int idx_b = *idx >> 32;
 
 	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
 		nid = NUMA_NO_NODE;
 
 	if (*idx == (u64)ULLONG_MAX) {
-		mi = mem->cnt - 1;
-		ri = rsv->cnt;
+		idx_a = type_a->cnt - 1;
+		idx_b = type_b->cnt;
 	}
 
-	for ( ; mi >= 0; mi--) {
-		struct memblock_region *m = &mem->regions[mi];
+	for (; idx_a >= 0; idx_a--) {
+		struct memblock_region *m = &type_a->regions[idx_a];
 		phys_addr_t m_start = m->base;
 		phys_addr_t m_end = m->base + m->size;
 
@@ -877,17 +985,34 @@ void __init_memblock __next_free_mem_ran
 		if (nid != NUMA_NO_NODE && nid != memblock_get_region_node(m))
 			continue;
 
-		/* skip hotpluggable memory regions if needed */
-		if (movable_node_is_enabled() && memblock_is_hotpluggable(m))
-			continue;
-
-		/* scan areas before each reservation for intersection */
-		for ( ; ri >= 0; ri--) {
-			struct memblock_region *r = &rsv->regions[ri];
-			phys_addr_t r_start = ri ? r[-1].base + r[-1].size : 0;
-			phys_addr_t r_end = ri < rsv->cnt ? r->base : ULLONG_MAX;
+		/* With type_b NULL we only iterate through type_a */
+		if (type_b == NULL) {
+			if (out_start)
+				*out_start = m_start;
+			if (out_end)
+				*out_end = m_end;
+			if (out_nid)
+				*out_nid = memblock_get_region_node(m);
+			idx_a--;
+			*idx = (u32)idx_a;
+			return;
+		}
 
-			/* if ri advanced past mi, break out to advance mi */
+		/* scan areas before each reservation */
+		for (; idx_b >= 0; idx_b--) {
+			struct memblock_region *r;
+			phys_addr_t r_start;
+			phys_addr_t r_end;
+			int m_nid = memblock_get_region_node(m);
+
+			r = &type_b->regions[idx_b];
+			r_start = idx_b ? r[-1].base + r[-1].size : 0;
+			r_end = idx_b < type_b->cnt ?
+				r->base : ULLONG_MAX;
+			/*
+			 * if idx_b advanced past idx_a,
+			 * break out to advance idx_a
+			 */
 			if (r_end <= m_start)
 				break;
 			/* if the two regions intersect, we're done */
@@ -897,18 +1022,17 @@ void __init_memblock __next_free_mem_ran
 				if (out_end)
 					*out_end = min(m_end, r_end);
 				if (out_nid)
-					*out_nid = memblock_get_region_node(m);
-
+					*out_nid = m_nid;
 				if (m_start >= r_start)
-					mi--;
+					idx_a--;
 				else
-					ri--;
-				*idx = (u32)mi | (u64)ri << 32;
+					idx_b--;
+				*idx = (u32)idx_a | (u64)idx_b << 32;
 				return;
 			}
 		}
 	}
-
+	/* signal end of iteration */
 	*idx = ULLONG_MAX;
 }
 
@@ -1294,6 +1418,9 @@ void __init memblock_enforce_memory_limi
 	/* truncate both memory and reserved regions */
 	__memblock_remove(&memblock.memory, max_addr, (phys_addr_t)ULLONG_MAX);
 	__memblock_remove(&memblock.reserved, max_addr, (phys_addr_t)ULLONG_MAX);
+#ifdef ARCH_MEMBLOCK_NOMAP
+	__memblock_remove(&memblock.nomap, max_addr, (phys_addr_t)ULLONG_MAX);
+#endif
 }
 
 static int __init_memblock memblock_search(struct memblock_type *type, phys_addr_t addr)
@@ -1438,12 +1565,22 @@ static void __init_memblock memblock_dum
 void __init_memblock __memblock_dump_all(void)
 {
 	pr_info("MEMBLOCK configuration:\n");
+#ifndef CONFIG_ARCH_MEMBLOCK_NOMAP
 	pr_info(" memory size = %#llx reserved size = %#llx\n",
 		(unsigned long long)memblock.memory.total_size,
 		(unsigned long long)memblock.reserved.total_size);
+#else
+	pr_info(" memory size = %#llx reserved size = %#llx nomap size = %#llx\n",
+		(unsigned long long)memblock.memory.total_size,
+		(unsigned long long)memblock.reserved.total_size,
+		(unsigned long long)memblock.nomap.total_size);
+#endif
 
 	memblock_dump(&memblock.memory, "memory");
 	memblock_dump(&memblock.reserved, "reserved");
+#ifdef CONFIG_ARCH_MEMBLOCK_NOMAP
+	memblock_dump(&memblock.nomap, "nomap");
+#endif
 }
 
 void __init memblock_allow_resize(void)
diff -puN mm/nobootmem.c~mm-memblock-add-support-for-excluded-memory-areas mm/nobootmem.c
--- a/mm/nobootmem.c~mm-memblock-add-support-for-excluded-memory-areas
+++ a/mm/nobootmem.c
@@ -133,6 +133,15 @@ static unsigned long __init free_low_mem
 	size = get_allocated_memblock_memory_regions_info(&start);
 	if (size)
 		count += __free_memory_core(start, start + size);
+
+#ifdef CONFIG_ARCH_MEMBLOCK_NOMAP
+
+	/* Free memblock.nomap array if it was allocated */
+	size = get_allocated_memblock_memory_regions_info(&start);
+	if (size)
+		count += __free_memory_core(start, start + size);
+
+#endif
 #endif
 
 	return count;
_

Patches currently in -mm which might be from phacht@linux.vnet.ibm.com are

mm-nobootmemc-add-return-value-check-in-__alloc_memory_core_early.patch
mm-free-memblockmemory-in-free_all_bootmem.patch
mm-free-memblockmemory-in-free_all_bootmem-fix.patch
mm-nobootmem-free_all_bootmem-again.patch
mm-memblock-add-support-for-excluded-memory-areas.patch

