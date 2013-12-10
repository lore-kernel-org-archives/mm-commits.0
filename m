From: akpm@linux-foundation.org
Subject: + mm-memblock-add-memblock-memory-allocation-apis.patch added to
 -mm tree
Date: Mon, 09 Dec 2013 16:29:11 -0800
Message-ID: <52a66057.dSxA6QwidXnWuxao%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55628 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab3LJA3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Dec 2013 19:29:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, yinghai@kernel.org, tony@atomide.com, tj@kernel.org, rjw@sisk.pl, pavel@ucw.cz, paul@pwsan.com, mhocko@suse.cz, linux@arm.linux.org.uk, konrad.wilk@oracle.com, kamezawa.hiroyu@jp.fujitsu.com, hpa@zytor.com, hannes@cmpxchg.org, grygorii.strashko@ti.com, gregkh@linuxfoundation.org, cl@linux-foundation.org, arnd@arndb.de, santosh.shilimkar@ti.com

Subject: + mm-memblock-add-memblock-memory-allocation-apis.patch added to -mm tree
To: santosh.shilimkar@ti.com,arnd@arndb.de,cl@linux-foundation.org,gregkh@linuxfoundation.org,grygorii.strashko@ti.com,hannes@cmpxchg.org,hpa@zytor.com,kamezawa.hiroyu@jp.fujitsu.com,konrad.wilk@oracle.com,linux@arm.linux.org.uk,mhocko@suse.cz,paul@pwsan.com,pavel@ucw.cz,rjw@sisk.pl,tj@kernel.org,tony@atomide.com,yinghai@kernel.org
From: akpm@linux-foundation.org
Date: Mon, 09 Dec 2013 16:29:11 -0800


The patch titled
     Subject: mm/memblock: add memblock memory allocation apis
has been added to the -mm tree.  Its filename is
     mm-memblock-add-memblock-memory-allocation-apis.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memblock-add-memblock-memory-allocation-apis.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memblock-add-memblock-memory-allocation-apis.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: mm/memblock: add memblock memory allocation apis

Introduce memblock memory allocation APIs which allow to support PAE or
LPAE extension on 32 bits archs where the physical memory start address
can be beyond 4GB.  In such cases, existing bootmem APIs which operate on
32 bit addresses won't work and needs memblock layer which operates on 64
bit addresses.

So we add equivalent APIs so that we can replace usage of bootmem with
memblock interfaces.  Architectures already converted to NO_BOOTMEM use
these new memblock interfaces.  The architectures which are still not
converted to NO_BOOTMEM continue to function as is because we still
maintain the fal lback option of bootmem back-end supporting these new
interfaces.  So no functional change as such.

In long run, once all the architectures moves to NO_BOOTMEM, we can get
rid of bootmem layer completely.  This is one step to remove the core code
dependency with bootmem and also gives path for architectures to move away
from bootmem.

The proposed interface will became active if both CONFIG_HAVE_MEMBLOCK and
CONFIG_NO_BOOTMEM are specified by arch.  In case !CONFIG_NO_BOOTMEM, the
memblock() wrappers will fallback to the existing bootmem apis so that
arch's not converted to NO_BOOTMEM continue to work as is.

The meaning of MEMBLOCK_ALLOC_ACCESSIBLE and MEMBLOCK_ALLOC_ANYWHERE
is kept same.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |  151 ++++++++++++++++++++++++++++
 mm/memblock.c           |  198 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 349 insertions(+)

diff -puN include/linux/bootmem.h~mm-memblock-add-memblock-memory-allocation-apis include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-memblock-add-memblock-memory-allocation-apis
+++ a/include/linux/bootmem.h
@@ -141,6 +141,157 @@ extern void *__alloc_bootmem_low_node(pg
 #define alloc_bootmem_low_pages_node(pgdat, x) \
 	__alloc_bootmem_low_node(pgdat, x, PAGE_SIZE, 0)
 
+
+#if defined(CONFIG_HAVE_MEMBLOCK) && defined(CONFIG_NO_BOOTMEM)
+
+/* FIXME: use MEMBLOCK_ALLOC_* variants here */
+#define BOOTMEM_ALLOC_ACCESSIBLE	0
+#define BOOTMEM_ALLOC_ANYWHERE		(~(phys_addr_t)0)
+
+/* FIXME: Move to memblock.h at a point where we remove nobootmem.c */
+void *memblock_virt_alloc_try_nid_nopanic(phys_addr_t size,
+		phys_addr_t align, phys_addr_t min_addr,
+		phys_addr_t max_addr, int nid);
+void *memblock_virt_alloc_try_nid(phys_addr_t size, phys_addr_t align,
+		phys_addr_t min_addr, phys_addr_t max_addr, int nid);
+void __memblock_free_early(phys_addr_t base, phys_addr_t size);
+void __memblock_free_late(phys_addr_t base, phys_addr_t size);
+
+static inline void * __init memblock_virt_alloc(
+					phys_addr_t size,  phys_addr_t align)
+{
+	return memblock_virt_alloc_try_nid(size, align, BOOTMEM_LOW_LIMIT,
+					    BOOTMEM_ALLOC_ACCESSIBLE,
+					    NUMA_NO_NODE);
+}
+
+static inline void * __init memblock_virt_alloc_nopanic(
+					phys_addr_t size, phys_addr_t align)
+{
+	return memblock_virt_alloc_try_nid_nopanic(size, align,
+						    BOOTMEM_LOW_LIMIT,
+						    BOOTMEM_ALLOC_ACCESSIBLE,
+						    NUMA_NO_NODE);
+}
+
+static inline void * __init memblock_virt_alloc_from_nopanic(
+		phys_addr_t size, phys_addr_t align, phys_addr_t min_addr)
+{
+	return memblock_virt_alloc_try_nid_nopanic(size, align, min_addr,
+						    BOOTMEM_ALLOC_ACCESSIBLE,
+						    NUMA_NO_NODE);
+}
+
+static inline void * __init memblock_virt_alloc_node(
+						phys_addr_t size, int nid)
+{
+	return memblock_virt_alloc_try_nid(size, 0, BOOTMEM_LOW_LIMIT,
+					    BOOTMEM_ALLOC_ACCESSIBLE, nid);
+}
+
+static inline void * __init memblock_virt_alloc_node_nopanic(
+						phys_addr_t size, int nid)
+{
+	return memblock_virt_alloc_try_nid_nopanic(size, 0, BOOTMEM_LOW_LIMIT,
+						    BOOTMEM_ALLOC_ACCESSIBLE,
+						    nid);
+}
+
+static inline void __init memblock_free_early(
+					phys_addr_t base, phys_addr_t size)
+{
+	__memblock_free_early(base, size);
+}
+
+static inline void __init memblock_free_early_nid(
+				phys_addr_t base, phys_addr_t size, int nid)
+{
+	__memblock_free_early(base, size);
+}
+
+static inline void __init memblock_free_late(
+					phys_addr_t base, phys_addr_t size)
+{
+	__memblock_free_late(base, size);
+}
+
+#else
+
+#define BOOTMEM_ALLOC_ACCESSIBLE	0
+
+
+/* Fall back to all the existing bootmem APIs */
+static inline void * __init memblock_virt_alloc(
+					phys_addr_t size,  phys_addr_t align)
+{
+	if (!align)
+		align = SMP_CACHE_BYTES;
+	return __alloc_bootmem(size, align, BOOTMEM_LOW_LIMIT);
+}
+
+static inline void * __init memblock_virt_alloc_nopanic(
+					phys_addr_t size, phys_addr_t align)
+{
+	if (!align)
+		align = SMP_CACHE_BYTES;
+	return __alloc_bootmem_nopanic(size, align, BOOTMEM_LOW_LIMIT);
+}
+
+static inline void * __init memblock_virt_alloc_from_nopanic(
+		phys_addr_t size, phys_addr_t align, phys_addr_t min_addr)
+{
+	return __alloc_bootmem_nopanic(size, align, min_addr);
+}
+
+static inline void * __init memblock_virt_alloc_node(
+						phys_addr_t size, int nid)
+{
+	return __alloc_bootmem_node(NODE_DATA(nid), size, SMP_CACHE_BYTES,
+				     BOOTMEM_LOW_LIMIT);
+}
+
+static inline void * __init memblock_virt_alloc_node_nopanic(
+						phys_addr_t size, int nid)
+{
+	return __alloc_bootmem_node_nopanic(NODE_DATA(nid), size,
+					     SMP_CACHE_BYTES,
+					     BOOTMEM_LOW_LIMIT);
+}
+
+static inline void * __init memblock_virt_alloc_try_nid(phys_addr_t size,
+	phys_addr_t align, phys_addr_t min_addr, phys_addr_t max_addr, int nid)
+{
+	return __alloc_bootmem_node_high(NODE_DATA(nid), size, align,
+					  min_addr);
+}
+
+static inline void * __init memblock_virt_alloc_try_nid_nopanic(
+			phys_addr_t size, phys_addr_t align,
+			phys_addr_t min_addr, phys_addr_t max_addr, int nid)
+{
+	return ___alloc_bootmem_node_nopanic(NODE_DATA(nid), size, align,
+				min_addr, max_addr);
+}
+
+static inline void __init memblock_free_early(
+					phys_addr_t base, phys_addr_t size)
+{
+	free_bootmem(base, size);
+}
+
+static inline void __init memblock_free_early_nid(
+				phys_addr_t base, phys_addr_t size, int nid)
+{
+	free_bootmem_node(NODE_DATA(nid), base, size);
+}
+
+static inline void __init memblock_free_late(
+					phys_addr_t base, phys_addr_t size)
+{
+	free_bootmem_late(base, size);
+}
+#endif /* defined(CONFIG_HAVE_MEMBLOCK) && defined(CONFIG_NO_BOOTMEM) */
+
 #ifdef CONFIG_HAVE_ARCH_ALLOC_REMAP
 extern void *alloc_remap(int nid, unsigned long size);
 #else
diff -puN mm/memblock.c~mm-memblock-add-memblock-memory-allocation-apis mm/memblock.c
--- a/mm/memblock.c~mm-memblock-add-memblock-memory-allocation-apis
+++ a/mm/memblock.c
@@ -21,6 +21,9 @@
 #include <linux/memblock.h>
 
 #include <asm-generic/sections.h>
+#include <linux/io.h>
+
+#include "internal.h"
 
 static struct memblock_region memblock_memory_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
 static struct memblock_region memblock_reserved_init_regions[INIT_MEMBLOCK_REGIONS] __initdata_memblock;
@@ -1029,6 +1032,201 @@ phys_addr_t __init memblock_alloc_try_ni
 	return memblock_alloc_base(size, align, MEMBLOCK_ALLOC_ACCESSIBLE);
 }
 
+/**
+ * memblock_virt_alloc_internal - allocate boot memory block
+ * @size: size of memory block to be allocated in bytes
+ * @align: alignment of the region and block's size
+ * @min_addr: the lower bound of the memory region to allocate (phys address)
+ * @max_addr: the upper bound of the memory region to allocate (phys address)
+ * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
+ *
+ * The @min_addr limit is dropped if it can not be satisfied and the allocation
+ * will fall back to memory below @min_addr. Also, allocation may fall back
+ * to any node in the system if the specified node can not
+ * hold the requested memory.
+ *
+ * The allocation is performed from memory region limited by
+ * memblock.current_limit if @max_addr == %BOOTMEM_ALLOC_ACCESSIBLE.
+ *
+ * The memory block is aligned on SMP_CACHE_BYTES if @align == 0.
+ *
+ * The phys address of allocated boot memory block is converted to virtual and
+ * allocated memory is reset to 0.
+ *
+ * In addition, function sets the min_count to 0 using kmemleak_alloc for
+ * allocated boot memory block, so that it is never reported as leaks.
+ *
+ * RETURNS:
+ * Virtual address of allocated memory block on success, NULL on failure.
+ */
+static void * __init memblock_virt_alloc_internal(
+				phys_addr_t size, phys_addr_t align,
+				phys_addr_t min_addr, phys_addr_t max_addr,
+				int nid)
+{
+	phys_addr_t alloc;
+	void *ptr;
+
+	if (nid == MAX_NUMNODES)
+		pr_warn("%s: usage of MAX_NUMNODES is depricated. Use NUMA_NO_NODE\n",
+			__func__);
+
+	if (WARN_ON_ONCE(slab_is_available()))
+		return kzalloc_node(size, GFP_NOWAIT, nid);
+
+	if (!align)
+		align = SMP_CACHE_BYTES;
+
+	/* align @size to avoid excessive fragmentation on reserved array */
+	size = round_up(size, align);
+
+again:
+	alloc = memblock_find_in_range_node(size, align, min_addr, max_addr,
+					    nid);
+	if (alloc)
+		goto done;
+
+	if (nid != NUMA_NO_NODE) {
+		alloc = memblock_find_in_range_node(size, align, min_addr,
+						    max_addr,  NUMA_NO_NODE);
+		if (alloc)
+			goto done;
+	}
+
+	if (min_addr) {
+		min_addr = 0;
+		goto again;
+	} else {
+		goto error;
+	}
+
+done:
+	memblock_reserve(alloc, size);
+	ptr = phys_to_virt(alloc);
+	memset(ptr, 0, size);
+
+	/*
+	 * The min_count is set to 0 so that bootmem allocated blocks
+	 * are never reported as leaks.
+	 */
+	kmemleak_alloc(ptr, size, 0, 0);
+
+	return ptr;
+
+error:
+	return NULL;
+}
+
+/**
+ * memblock_virt_alloc_try_nid_nopanic - allocate boot memory block
+ * @size: size of memory block to be allocated in bytes
+ * @align: alignment of the region and block's size
+ * @min_addr: the lower bound of the memory region from where the allocation
+ *	  is preferred (phys address)
+ * @max_addr: the upper bound of the memory region from where the allocation
+ *	      is preferred (phys address), or %BOOTMEM_ALLOC_ACCESSIBLE to
+ *	      allocate only from memory limited by memblock.current_limit value
+ * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
+ *
+ * Public version of _memblock_virt_alloc_try_nid_nopanic() which provides
+ * additional debug information (including caller info), if enabled.
+ *
+ * RETURNS:
+ * Virtual address of allocated memory block on success, NULL on failure.
+ */
+void * __init memblock_virt_alloc_try_nid_nopanic(
+				phys_addr_t size, phys_addr_t align,
+				phys_addr_t min_addr, phys_addr_t max_addr,
+				int nid)
+{
+	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=0x%llx max_addr=0x%llx %pF\n",
+		     __func__, (u64)size, (u64)align, nid, (u64)min_addr,
+		     (u64)max_addr, (void *)_RET_IP_);
+	return memblock_virt_alloc_internal(size, align, min_addr,
+					     max_addr, nid);
+}
+
+/**
+ * memblock_virt_alloc_try_nid - allocate boot memory block with panicking
+ * @size: size of memory block to be allocated in bytes
+ * @align: alignment of the region and block's size
+ * @min_addr: the lower bound of the memory region from where the allocation
+ *	  is preferred (phys address)
+ * @max_addr: the upper bound of the memory region from where the allocation
+ *	      is preferred (phys address), or %BOOTMEM_ALLOC_ACCESSIBLE to
+ *	      allocate only from memory limited by memblock.current_limit value
+ * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
+ *
+ * Public panicking version of _memblock_virt_alloc_try_nid_nopanic()
+ * which provides debug information (including caller info), if enabled,
+ * and panics if the request can not be satisfied.
+ *
+ * RETURNS:
+ * Virtual address of allocated memory block on success, NULL on failure.
+ */
+void * __init memblock_virt_alloc_try_nid(
+			phys_addr_t size, phys_addr_t align,
+			phys_addr_t min_addr, phys_addr_t max_addr,
+			int nid)
+{
+	void *ptr;
+
+	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=0x%llx max_addr=0x%llx %pF\n",
+		     __func__, (u64)size, (u64)align, nid, (u64)min_addr,
+		     (u64)max_addr, (void *)_RET_IP_);
+	ptr = memblock_virt_alloc_internal(size, align,
+					   min_addr, max_addr, nid);
+	if (ptr)
+		return ptr;
+
+	panic("%s: Failed to allocate %llu bytes align=0x%llx nid=%d from=0x%llx max_addr=0x%llx\n",
+	      __func__, (u64)size, (u64)align, nid, (u64)min_addr,
+	      (u64)max_addr);
+	return NULL;
+}
+
+/**
+ * __memblock_free_early - free boot memory block
+ * @base: phys starting address of the  boot memory block
+ * @size: size of the boot memory block in bytes
+ *
+ * Free boot memory block previously allocated by memblock_virt_alloc_xx() API.
+ * The freeing memory will not be released to the buddy allocator.
+ */
+void __init __memblock_free_early(phys_addr_t base, phys_addr_t size)
+{
+	memblock_dbg("%s: [%#016llx-%#016llx] %pF\n",
+		     __func__, (u64)base, (u64)base + size - 1,
+		     (void *)_RET_IP_);
+	kmemleak_free_part(__va(base), size);
+	__memblock_remove(&memblock.reserved, base, size);
+}
+
+/*
+ * __memblock_free_late - free bootmem block pages directly to buddy allocator
+ * @addr: phys starting address of the  boot memory block
+ * @size: size of the boot memory block in bytes
+ *
+ * This is only useful when the bootmem allocator has already been torn
+ * down, but we are still initializing the system.  Pages are released directly
+ * to the buddy allocator, no bootmem metadata is updated because it is gone.
+ */
+void __init __memblock_free_late(phys_addr_t base, phys_addr_t size)
+{
+	u64 cursor, end;
+
+	memblock_dbg("%s: [%#016llx-%#016llx] %pF\n",
+		     __func__, (u64)base, (u64)base + size - 1,
+		     (void *)_RET_IP_);
+	kmemleak_free_part(__va(base), size);
+	cursor = PFN_UP(base);
+	end = PFN_DOWN(base + size);
+
+	for (; cursor < end; cursor++) {
+		__free_pages_bootmem(pfn_to_page(cursor), 0);
+		totalram_pages++;
+	}
+}
 
 /*
  * Remaining API functions
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

mm-memblock-debug-correct-displaying-of-upper-memory-boundary.patch
mm-memblock-debug-dont-free-reserved-array-if-arch_discard_memblock.patch
mm-bootmem-remove-duplicated-declaration-of-__free_pages_bootmem.patch
mm-memblock-remove-unnecessary-inclusions-of-bootmemh.patch
mm-memblock-drop-warn-and-use-smp_cache_bytes-as-a-default-alignment.patch
mm-memblock-reorder-parameters-of-memblock_find_in_range_node.patch
mm-memblock-switch-to-use-numa_no_node-instead-of-max_numnodes.patch
mm-memblock-add-memblock-memory-allocation-apis.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
mm-init-use-memblock-apis-for-early-memory-allocations.patch
mm-printk-use-memblock-apis-for-early-memory-allocations.patch
mm-page_alloc-use-memblock-apis-for-early-memory-allocations.patch
mm-power-use-memblock-apis-for-early-memory-allocations.patch
lib-swiotlbc-use-memblock-apis-for-early-memory-allocations.patch
lib-cpumaskc-use-memblock-apis-for-early-memory-allocations.patch
mm-sparse-use-memblock-apis-for-early-memory-allocations.patch
mm-hugetlb-use-memblock-apis-for-early-memory-allocations.patch
mm-page_cgroup-use-memblock-apis-for-early-memory-allocations.patch
mm-percpu-use-memblock-apis-for-early-memory-allocations.patch
mm-memory_hotplug-use-memblock-apis-for-early-memory-allocations.patch
drivers-firmware-memmapc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-kernel-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mm-initc-use-memblock-apis-for-early-memory-allocations.patch
arch-arm-mach-omap2-omap_hwmodc-use-memblock-apis-for-early-memory-allocations.patch
linux-next.patch

