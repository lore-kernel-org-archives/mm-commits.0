From: akpm@linux-foundation.org
Subject: [merged] mm-defining-memblock_virt_alloc_try_nid_raw.patch
 removed from -mm tree
Date: Thu, 16 Nov 2017 12:03:05 -0800
Message-ID: <20171116200305.gtctmfGDd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46898 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935293AbdKPUDH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Nov 2017 15:03:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, bob.picco@oracle.com, borntraeger@de.ibm.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mingo@redhat.com, mm-commits@vger.kernel.org, pasha.tatashin@oracle.com, sam@ravnborg.org, steven.sistare@oracle.com, tglx@linutronix.de, will.deacon@arm.com, willy@infradead.org


The patch titled
     Subject: mm: define memblock_virt_alloc_try_nid_raw
has been removed from the -mm tree.  Its filename was
     mm-defining-memblock_virt_alloc_try_nid_raw.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: mm: define memblock_virt_alloc_try_nid_raw

* A new variant of memblock_virt_alloc_* allocations:
memblock_virt_alloc_try_nid_raw()
    - Does not zero the allocated memory
    - Does not panic if request cannot be satisfied

* optimize early system hash allocations

Clients can call alloc_large_system_hash() with flag: HASH_ZERO to specify
that memory that was allocated for system hash needs to be zeroed,
otherwise the memory does not need to be zeroed, and client will
initialize it.

If memory does not need to be zero'd, call the new
memblock_virt_alloc_raw() interface, and thus improve the boot
performance.

* debug for raw alloctor

When CONFIG_DEBUG_VM is enabled, this patch sets all the memory that is
returned by memblock_virt_alloc_try_nid_raw() to ones to ensure that no
places excpect zeroed memory.

Link: http://lkml.kernel.org/r/20171013173214.27300-6-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Bob Picco <bob.picco@oracle.com>
Tested-by: Bob Picco <bob.picco@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bootmem.h |   27 +++++++++++++++++
 mm/memblock.c           |   60 +++++++++++++++++++++++++++++++++-----
 mm/page_alloc.c         |   15 ++++-----
 3 files changed, 87 insertions(+), 15 deletions(-)

diff -puN include/linux/bootmem.h~mm-defining-memblock_virt_alloc_try_nid_raw include/linux/bootmem.h
--- a/include/linux/bootmem.h~mm-defining-memblock_virt_alloc_try_nid_raw
+++ a/include/linux/bootmem.h
@@ -161,6 +161,9 @@ extern void *__alloc_bootmem_low_node(pg
 #define BOOTMEM_ALLOC_ANYWHERE		(~(phys_addr_t)0)
 
 /* FIXME: Move to memblock.h at a point where we remove nobootmem.c */
+void *memblock_virt_alloc_try_nid_raw(phys_addr_t size, phys_addr_t align,
+				      phys_addr_t min_addr,
+				      phys_addr_t max_addr, int nid);
 void *memblock_virt_alloc_try_nid_nopanic(phys_addr_t size,
 		phys_addr_t align, phys_addr_t min_addr,
 		phys_addr_t max_addr, int nid);
@@ -177,6 +180,14 @@ static inline void * __init memblock_vir
 					    NUMA_NO_NODE);
 }
 
+static inline void * __init memblock_virt_alloc_raw(
+					phys_addr_t size,  phys_addr_t align)
+{
+	return memblock_virt_alloc_try_nid_raw(size, align, BOOTMEM_LOW_LIMIT,
+					    BOOTMEM_ALLOC_ACCESSIBLE,
+					    NUMA_NO_NODE);
+}
+
 static inline void * __init memblock_virt_alloc_nopanic(
 					phys_addr_t size, phys_addr_t align)
 {
@@ -258,6 +269,14 @@ static inline void * __init memblock_vir
 	return __alloc_bootmem(size, align, BOOTMEM_LOW_LIMIT);
 }
 
+static inline void * __init memblock_virt_alloc_raw(
+					phys_addr_t size,  phys_addr_t align)
+{
+	if (!align)
+		align = SMP_CACHE_BYTES;
+	return __alloc_bootmem_nopanic(size, align, BOOTMEM_LOW_LIMIT);
+}
+
 static inline void * __init memblock_virt_alloc_nopanic(
 					phys_addr_t size, phys_addr_t align)
 {
@@ -310,6 +329,14 @@ static inline void * __init memblock_vir
 					  min_addr);
 }
 
+static inline void * __init memblock_virt_alloc_try_nid_raw(
+			phys_addr_t size, phys_addr_t align,
+			phys_addr_t min_addr, phys_addr_t max_addr, int nid)
+{
+	return ___alloc_bootmem_node_nopanic(NODE_DATA(nid), size, align,
+				min_addr, max_addr);
+}
+
 static inline void * __init memblock_virt_alloc_try_nid_nopanic(
 			phys_addr_t size, phys_addr_t align,
 			phys_addr_t min_addr, phys_addr_t max_addr, int nid)
diff -puN mm/memblock.c~mm-defining-memblock_virt_alloc_try_nid_raw mm/memblock.c
--- a/mm/memblock.c~mm-defining-memblock_virt_alloc_try_nid_raw
+++ a/mm/memblock.c
@@ -1327,7 +1327,6 @@ again:
 	return NULL;
 done:
 	ptr = phys_to_virt(alloc);
-	memset(ptr, 0, size);
 
 	/*
 	 * The min_count is set to 0 so that bootmem allocated blocks
@@ -1341,6 +1340,45 @@ done:
 }
 
 /**
+ * memblock_virt_alloc_try_nid_raw - allocate boot memory block without zeroing
+ * memory and without panicking
+ * @size: size of memory block to be allocated in bytes
+ * @align: alignment of the region and block's size
+ * @min_addr: the lower bound of the memory region from where the allocation
+ *	  is preferred (phys address)
+ * @max_addr: the upper bound of the memory region from where the allocation
+ *	      is preferred (phys address), or %BOOTMEM_ALLOC_ACCESSIBLE to
+ *	      allocate only from memory limited by memblock.current_limit value
+ * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
+ *
+ * Public function, provides additional debug information (including caller
+ * info), if enabled. Does not zero allocated memory, does not panic if request
+ * cannot be satisfied.
+ *
+ * RETURNS:
+ * Virtual address of allocated memory block on success, NULL on failure.
+ */
+void * __init memblock_virt_alloc_try_nid_raw(
+			phys_addr_t size, phys_addr_t align,
+			phys_addr_t min_addr, phys_addr_t max_addr,
+			int nid)
+{
+	void *ptr;
+
+	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=0x%llx max_addr=0x%llx %pF\n",
+		     __func__, (u64)size, (u64)align, nid, (u64)min_addr,
+		     (u64)max_addr, (void *)_RET_IP_);
+
+	ptr = memblock_virt_alloc_internal(size, align,
+					   min_addr, max_addr, nid);
+#ifdef CONFIG_DEBUG_VM
+	if (ptr && size > 0)
+		memset(ptr, 0xff, size);
+#endif
+	return ptr;
+}
+
+/**
  * memblock_virt_alloc_try_nid_nopanic - allocate boot memory block
  * @size: size of memory block to be allocated in bytes
  * @align: alignment of the region and block's size
@@ -1351,8 +1389,8 @@ done:
  *	      allocate only from memory limited by memblock.current_limit value
  * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
  *
- * Public version of _memblock_virt_alloc_try_nid_nopanic() which provides
- * additional debug information (including caller info), if enabled.
+ * Public function, provides additional debug information (including caller
+ * info), if enabled. This function zeroes the allocated memory.
  *
  * RETURNS:
  * Virtual address of allocated memory block on success, NULL on failure.
@@ -1362,11 +1400,17 @@ void * __init memblock_virt_alloc_try_ni
 				phys_addr_t min_addr, phys_addr_t max_addr,
 				int nid)
 {
+	void *ptr;
+
 	memblock_dbg("%s: %llu bytes align=0x%llx nid=%d from=0x%llx max_addr=0x%llx %pF\n",
 		     __func__, (u64)size, (u64)align, nid, (u64)min_addr,
 		     (u64)max_addr, (void *)_RET_IP_);
-	return memblock_virt_alloc_internal(size, align, min_addr,
-					     max_addr, nid);
+
+	ptr = memblock_virt_alloc_internal(size, align,
+					   min_addr, max_addr, nid);
+	if (ptr)
+		memset(ptr, 0, size);
+	return ptr;
 }
 
 /**
@@ -1380,7 +1424,7 @@ void * __init memblock_virt_alloc_try_ni
  *	      allocate only from memory limited by memblock.current_limit value
  * @nid: nid of the free area to find, %NUMA_NO_NODE for any node
  *
- * Public panicking version of _memblock_virt_alloc_try_nid_nopanic()
+ * Public panicking version of memblock_virt_alloc_try_nid_nopanic()
  * which provides debug information (including caller info), if enabled,
  * and panics if the request can not be satisfied.
  *
@@ -1399,8 +1443,10 @@ void * __init memblock_virt_alloc_try_ni
 		     (u64)max_addr, (void *)_RET_IP_);
 	ptr = memblock_virt_alloc_internal(size, align,
 					   min_addr, max_addr, nid);
-	if (ptr)
+	if (ptr) {
+		memset(ptr, 0, size);
 		return ptr;
+	}
 
 	panic("%s: Failed to allocate %llu bytes align=0x%llx nid=%d from=0x%llx max_addr=0x%llx\n",
 	      __func__, (u64)size, (u64)align, nid, (u64)min_addr,
diff -puN mm/page_alloc.c~mm-defining-memblock_virt_alloc_try_nid_raw mm/page_alloc.c
--- a/mm/page_alloc.c~mm-defining-memblock_virt_alloc_try_nid_raw
+++ a/mm/page_alloc.c
@@ -7313,18 +7313,17 @@ void *__init alloc_large_system_hash(con
 
 	log2qty = ilog2(numentries);
 
-	/*
-	 * memblock allocator returns zeroed memory already, so HASH_ZERO is
-	 * currently not used when HASH_EARLY is specified.
-	 */
 	gfp_flags = (flags & HASH_ZERO) ? GFP_ATOMIC | __GFP_ZERO : GFP_ATOMIC;
 	do {
 		size = bucketsize << log2qty;
-		if (flags & HASH_EARLY)
-			table = memblock_virt_alloc_nopanic(size, 0);
-		else if (hashdist)
+		if (flags & HASH_EARLY) {
+			if (flags & HASH_ZERO)
+				table = memblock_virt_alloc_nopanic(size, 0);
+			else
+				table = memblock_virt_alloc_raw(size, 0);
+		} else if (hashdist) {
 			table = __vmalloc(size, gfp_flags, PAGE_KERNEL);
-		else {
+		} else {
 			/*
 			 * If bucketsize is not a power-of-two, we may free
 			 * some pages at the end of hash table which
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

sparc64-ng4-memset-32-bits-overflow.patch

