From: akpm@linux-foundation.org
Subject: [merged]
 mm-memblock-allocate-boot-time-data-structures-from-mirrored-memory.patch
 removed from -mm tree
Date: Mon, 29 Jun 2015 13:39:05 -0700
Message-ID: <5591ace9.RB2UjI1n2QGluSsN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50524 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbbF2UjG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Jun 2015 16:39:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tony.luck@intel.com, guohanjun@huawei.com, hpa@zytor.com, mingo@elte.hu, nao.horiguchi@gmail.com, qiuxishi@huawei.com, tglx@linutronix.de, xiexiuqi@huawei.com, yinghai@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memblock: allocate boot time data structures from mirrored memory
has been removed from the -mm tree.  Its filename was
     mm-memblock-allocate-boot-time-data-structures-from-mirrored-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Tony Luck <tony.luck@intel.com>
Subject: mm/memblock: allocate boot time data structures from mirrored memory

Try to allocate all boot time kernel data structures from mirrored memory.
 If we run out of mirrored memory print warnings, but fall back to using
non-mirrored memory to make sure that we still boot.

By number of bytes, most of what we allocate at boot time is the page
structures.  64 bytes per 4K page on x86_64 ...  or about 1.5% of total
system memory.  For workloads where the bulk of memory is allocated to
applications this may represent a useful improvement to system
availability since 1.5% of total memory might be a third of the memory
allocated to the kernel.

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

 include/linux/memblock.h |    8 +++
 mm/memblock.c            |   78 +++++++++++++++++++++++++++++++------
 mm/nobootmem.c           |   10 ++++
 3 files changed, 84 insertions(+), 12 deletions(-)

diff -puN include/linux/memblock.h~mm-memblock-allocate-boot-time-data-structures-from-mirrored-memory include/linux/memblock.h
--- a/include/linux/memblock.h~mm-memblock-allocate-boot-time-data-structures-from-mirrored-memory
+++ a/include/linux/memblock.h
@@ -24,6 +24,7 @@
 enum {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
 	MEMBLOCK_HOTPLUG	= 0x1,	/* hotpluggable region */
+	MEMBLOCK_MIRROR		= 0x2,	/* mirrored region */
 };
 
 struct memblock_region {
@@ -78,6 +79,8 @@ int memblock_reserve(phys_addr_t base, p
 void memblock_trim_memory(phys_addr_t align);
 int memblock_mark_hotplug(phys_addr_t base, phys_addr_t size);
 int memblock_clear_hotplug(phys_addr_t base, phys_addr_t size);
+int memblock_mark_mirror(phys_addr_t base, phys_addr_t size);
+ulong choose_memblock_flags(void);
 
 /* Low level functions */
 int memblock_add_range(struct memblock_type *type,
@@ -160,6 +163,11 @@ static inline bool movable_node_is_enabl
 }
 #endif
 
+static inline bool memblock_is_mirror(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_MIRROR;
+}
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
diff -puN mm/memblock.c~mm-memblock-allocate-boot-time-data-structures-from-mirrored-memory mm/memblock.c
--- a/mm/memblock.c~mm-memblock-allocate-boot-time-data-structures-from-mirrored-memory
+++ a/mm/memblock.c
@@ -54,10 +54,16 @@ int memblock_debug __initdata_memblock;
 #ifdef CONFIG_MOVABLE_NODE
 bool movable_node_enabled __initdata_memblock = false;
 #endif
+static bool system_has_some_mirror __initdata_memblock = false;
 static int memblock_can_resize __initdata_memblock;
 static int memblock_memory_in_slab __initdata_memblock = 0;
 static int memblock_reserved_in_slab __initdata_memblock = 0;
 
+ulong __init_memblock choose_memblock_flags(void)
+{
+	return system_has_some_mirror ? MEMBLOCK_MIRROR : MEMBLOCK_NONE;
+}
+
 /* inline so we don't get a warning when pr_debug is compiled out */
 static __init_memblock const char *
 memblock_type_name(struct memblock_type *type)
@@ -259,8 +265,21 @@ phys_addr_t __init_memblock memblock_fin
 					phys_addr_t end, phys_addr_t size,
 					phys_addr_t align)
 {
-	return memblock_find_in_range_node(size, align, start, end,
-					    NUMA_NO_NODE, MEMBLOCK_NONE);
+	phys_addr_t ret;
+	ulong flags = choose_memblock_flags();
+
+again:
+	ret = memblock_find_in_range_node(size, align, start, end,
+					    NUMA_NO_NODE, flags);
+
+	if (!ret && (flags & MEMBLOCK_MIRROR)) {
+		pr_warn("Could not allocate %pap bytes of mirrored memory\n",
+			&size);
+		flags &= ~MEMBLOCK_MIRROR;
+		goto again;
+	}
+
+	return ret;
 }
 
 static void __init_memblock memblock_remove_region(struct memblock_type *type, unsigned long r)
@@ -786,6 +805,21 @@ int __init_memblock memblock_clear_hotpl
 }
 
 /**
+ * memblock_mark_mirror - Mark mirrored memory with flag MEMBLOCK_MIRROR.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Return 0 on succees, -errno on failure.
+ */
+int __init_memblock memblock_mark_mirror(phys_addr_t base, phys_addr_t size)
+{
+	system_has_some_mirror = true;
+
+	return memblock_setclr_flag(base, size, 1, MEMBLOCK_MIRROR);
+}
+
+
+/**
  * __next__mem_range - next function for for_each_free_mem_range() etc.
  * @idx: pointer to u64 loop variable
  * @nid: node selector, %NUMA_NO_NODE for all nodes
@@ -839,6 +873,10 @@ void __init_memblock __next_mem_range(u6
 		if (movable_node_is_enabled() && memblock_is_hotpluggable(m))
 			continue;
 
+		/* if we want mirror memory skip non-mirror memory regions */
+		if ((flags & MEMBLOCK_MIRROR) && !memblock_is_mirror(m))
+			continue;
+
 		if (!type_b) {
 			if (out_start)
 				*out_start = m_start;
@@ -944,6 +982,10 @@ void __init_memblock __next_mem_range_re
 		if (movable_node_is_enabled() && memblock_is_hotpluggable(m))
 			continue;
 
+		/* if we want mirror memory skip non-mirror memory regions */
+		if ((flags & MEMBLOCK_MIRROR) && !memblock_is_mirror(m))
+			continue;
+
 		if (!type_b) {
 			if (out_start)
 				*out_start = m_start;
@@ -1096,8 +1138,18 @@ static phys_addr_t __init memblock_alloc
 
 phys_addr_t __init memblock_alloc_nid(phys_addr_t size, phys_addr_t align, int nid)
 {
-	return memblock_alloc_base_nid(size, align, MEMBLOCK_ALLOC_ACCESSIBLE,
-				       nid, MEMBLOCK_NONE);
+	ulong flags = choose_memblock_flags();
+	phys_addr_t ret;
+
+again:
+	ret = memblock_alloc_base_nid(size, align, MEMBLOCK_ALLOC_ACCESSIBLE,
+				      nid, flags);
+
+	if (!ret && (flags & MEMBLOCK_MIRROR)) {
+		flags &= ~MEMBLOCK_MIRROR;
+		goto again;
+	}
+	return ret;
 }
 
 phys_addr_t __init __memblock_alloc_base(phys_addr_t size, phys_addr_t align, phys_addr_t max_addr)
@@ -1167,6 +1219,7 @@ static void * __init memblock_virt_alloc
 {
 	phys_addr_t alloc;
 	void *ptr;
+	ulong flags = choose_memblock_flags();
 
 	if (WARN_ONCE(nid == MAX_NUMNODES, "Usage of MAX_NUMNODES is deprecated. Use NUMA_NO_NODE instead\n"))
 		nid = NUMA_NO_NODE;
@@ -1187,14 +1240,14 @@ static void * __init memblock_virt_alloc
 
 again:
 	alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
-					    nid, MEMBLOCK_NONE);
+					    nid, flags);
 	if (alloc)
 		goto done;
 
 	if (nid != NUMA_NO_NODE) {
 		alloc = memblock_find_in_range_node(size, align, min_addr,
 						    max_addr, NUMA_NO_NODE,
-						    MEMBLOCK_NONE);
+						    flags);
 		if (alloc)
 			goto done;
 	}
@@ -1202,10 +1255,16 @@ again:
 	if (min_addr) {
 		min_addr = 0;
 		goto again;
-	} else {
-		goto error;
 	}
 
+	if (flags & MEMBLOCK_MIRROR) {
+		flags &= ~MEMBLOCK_MIRROR;
+		pr_warn("Could not allocate %pap bytes of mirrored memory\n",
+			&size);
+		goto again;
+	}
+
+	return NULL;
 done:
 	memblock_reserve(alloc, size);
 	ptr = phys_to_virt(alloc);
@@ -1220,9 +1279,6 @@ done:
 	kmemleak_alloc(ptr, size, 0, 0);
 
 	return ptr;
-
-error:
-	return NULL;
 }
 
 /**
diff -puN mm/nobootmem.c~mm-memblock-allocate-boot-time-data-structures-from-mirrored-memory mm/nobootmem.c
--- a/mm/nobootmem.c~mm-memblock-allocate-boot-time-data-structures-from-mirrored-memory
+++ a/mm/nobootmem.c
@@ -37,12 +37,20 @@ static void * __init __alloc_memory_core
 {
 	void *ptr;
 	u64 addr;
+	ulong flags = choose_memblock_flags();
 
 	if (limit > memblock.current_limit)
 		limit = memblock.current_limit;
 
+again:
 	addr = memblock_find_in_range_node(size, align, goal, limit, nid,
-					   MEMBLOCK_NONE);
+					   flags);
+	if (!addr && (flags & MEMBLOCK_MIRROR)) {
+		flags &= ~MEMBLOCK_MIRROR;
+		pr_warn("Could not allocate %pap bytes of mirrored memory\n",
+			&size);
+		goto again;
+	}
 	if (!addr)
 		return NULL;
 
_

Patches currently in -mm which might be from tony.luck@intel.com are

origin.patch
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
linux-next.patch

