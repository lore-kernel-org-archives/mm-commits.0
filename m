From: akpm@linux-foundation.org
Subject: + mm-defining-memblock_virt_alloc_try_nid_raw.patch added to -mm
 tree
Date: Fri, 13 Oct 2017 14:18:48 -0700
Message-ID: <59e12db8./PMSm/SCdKsVgY91%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58820 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdJMVSu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 13 Oct 2017 17:18:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, ard.biesheuvel@linaro.org, aryabinin@virtuozzo.com, bob.picco@oracle.com, borntraeger@de.ibm.com, catalin.marinas@arm.com, daniel.m.jordan@oracle.com, davem@davemloft.net, dvyukov@google.com, glider@google.com, heiko.carstens@de.ibm.com, hpa@zytor.com, mark.rutland@arm.com, mgorman@techsingularity.net, mhocko@kernel.org, mhocko@suse.com, mingo@redhat.com, sam@ravnborg.org, steven.sistare@oracle.com, tglx@linutronix.de, will.deacon@arm.com, willy@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: define memblock_virt_alloc_try_nid_raw
has been added to the -mm tree.  Its filename is
     mm-defining-memblock_virt_alloc_try_nid_raw.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-defining-memblock_virt_alloc_try_nid_raw.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-defining-memblock_virt_alloc_try_nid_raw.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -160,6 +160,9 @@ extern void *__alloc_bootmem_low_node(pg
 #define BOOTMEM_ALLOC_ANYWHERE		(~(phys_addr_t)0)
 
 /* FIXME: Move to memblock.h at a point where we remove nobootmem.c */
+void *memblock_virt_alloc_try_nid_raw(phys_addr_t size, phys_addr_t align,
+				      phys_addr_t min_addr,
+				      phys_addr_t max_addr, int nid);
 void *memblock_virt_alloc_try_nid_nopanic(phys_addr_t size,
 		phys_addr_t align, phys_addr_t min_addr,
 		phys_addr_t max_addr, int nid);
@@ -176,6 +179,14 @@ static inline void * __init memblock_vir
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
@@ -257,6 +268,14 @@ static inline void * __init memblock_vir
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
@@ -309,6 +328,14 @@ static inline void * __init memblock_vir
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
@@ -7299,18 +7299,17 @@ void *__init alloc_large_system_hash(con
 
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

mm-deferred_init_memmap-improvements.patch
x86-mm-setting-fields-in-deferred-pages.patch
sparc64-mm-setting-fields-in-deferred-pages.patch
sparc64-simplify-vmemmap_populate.patch
mm-defining-memblock_virt_alloc_try_nid_raw.patch
mm-zero-reserved-and-unavailable-struct-pages.patch
x86-kasan-add-and-use-kasan_map_populate.patch
arm64-kasan-add-and-use-kasan_map_populate.patch
mm-stop-zeroing-memory-during-allocation-in-vmemmap.patch
sparc64-optimized-struct-page-zeroing.patch
sparc64-ng4-memset-32-bits-overflow.patch

