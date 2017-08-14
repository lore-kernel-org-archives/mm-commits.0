From: akpm@linux-foundation.org
Subject: + mm-discard-memblock-data-later.patch added to -mm tree
Date: Mon, 14 Aug 2017 14:50:42 -0700
Message-ID: <59921b32.NG5D++wI83kButoj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58900 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752437AbdHNVuo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2017 17:50:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, bob.picco@oracle.com, daniel.m.jordan@oracle.com, mgorman@techsingularity.net, mhocko@suse.com, stable@vger.kernel.org, steven.sistare@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: discard memblock data later
has been added to the -mm tree.  Its filename is
     mm-discard-memblock-data-later.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-discard-memblock-data-later.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-discard-memblock-data-later.patch

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
Subject: mm: discard memblock data later

There is existing use after free bug when deferred struct pages are
enabled:

The memblock_add() allocates memory for the memory array if more than 128
entries are needed.  See comment in e820__memblock_setup():

  * The bootstrap memblock region count maximum is 128 entries
  * (INIT_MEMBLOCK_REGIONS), but EFI might pass us more E820 entries
  * than that - so allow memblock resizing.

This memblock memory is freed here:
        free_low_memory_core_early()

We access the freed memblock.memory later in boot when deferred pages are
initialized in this path:

        deferred_init_memmap()
                for_each_mem_pfn_range()
                  __next_mem_pfn_range()
                    type = &memblock.memory;

One possible explanation for why this use-after-free hasn't been hit
before is that the limit of INIT_MEMBLOCK_REGIONS has never been exceeded
at least on systems where deferred struct pages were enabled.

Tested by reducing INIT_MEMBLOCK_REGIONS down to 4 from the current 128,
and verifying in qemu that this code is getting excuted and that the freed
pages are sane.

Link: http://lkml.kernel.org/r/1502485554-318703-2-git-send-email-pasha.tatashin@oracle.com
Fixes: 7e18adb4f80b ("mm: meminit: initialise remaining struct pages in parallel with kswapd")
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
Reviewed-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Reviewed-by: Bob Picco <bob.picco@oracle.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memblock.h |    6 +++--
 mm/memblock.c            |   40 ++++++++++++++++---------------------
 mm/nobootmem.c           |   16 --------------
 mm/page_alloc.c          |    4 +++
 4 files changed, 26 insertions(+), 40 deletions(-)

diff -puN include/linux/memblock.h~mm-discard-memblock-data-later include/linux/memblock.h
--- a/include/linux/memblock.h~mm-discard-memblock-data-later
+++ a/include/linux/memblock.h
@@ -61,6 +61,7 @@ extern int memblock_debug;
 #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
 #define __init_memblock __meminit
 #define __initdata_memblock __meminitdata
+void memblock_discard(void);
 #else
 #define __init_memblock
 #define __initdata_memblock
@@ -74,8 +75,6 @@ phys_addr_t memblock_find_in_range_node(
 					int nid, ulong flags);
 phys_addr_t memblock_find_in_range(phys_addr_t start, phys_addr_t end,
 				   phys_addr_t size, phys_addr_t align);
-phys_addr_t get_allocated_memblock_reserved_regions_info(phys_addr_t *addr);
-phys_addr_t get_allocated_memblock_memory_regions_info(phys_addr_t *addr);
 void memblock_allow_resize(void);
 int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_add(phys_addr_t base, phys_addr_t size);
@@ -110,6 +109,9 @@ void __next_mem_range_rev(u64 *idx, int
 void __next_reserved_mem_region(u64 *idx, phys_addr_t *out_start,
 				phys_addr_t *out_end);
 
+void __memblock_free_early(phys_addr_t base, phys_addr_t size);
+void __memblock_free_late(phys_addr_t base, phys_addr_t size);
+
 /**
  * for_each_mem_range - iterate through memblock areas from type_a and not
  * included in type_b. Or just type_a if type_b is NULL.
diff -puN mm/memblock.c~mm-discard-memblock-data-later mm/memblock.c
--- a/mm/memblock.c~mm-discard-memblock-data-later
+++ a/mm/memblock.c
@@ -285,31 +285,27 @@ static void __init_memblock memblock_rem
 }
 
 #ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
-
-phys_addr_t __init_memblock get_allocated_memblock_reserved_regions_info(
-					phys_addr_t *addr)
-{
-	if (memblock.reserved.regions == memblock_reserved_init_regions)
-		return 0;
-
-	*addr = __pa(memblock.reserved.regions);
-
-	return PAGE_ALIGN(sizeof(struct memblock_region) *
-			  memblock.reserved.max);
-}
-
-phys_addr_t __init_memblock get_allocated_memblock_memory_regions_info(
-					phys_addr_t *addr)
+/**
+ * Discard memory and reserved arrays if they were allocated
+ */
+void __init memblock_discard(void)
 {
-	if (memblock.memory.regions == memblock_memory_init_regions)
-		return 0;
+	phys_addr_t addr, size;
 
-	*addr = __pa(memblock.memory.regions);
-
-	return PAGE_ALIGN(sizeof(struct memblock_region) *
-			  memblock.memory.max);
+	if (memblock.reserved.regions != memblock_reserved_init_regions) {
+		addr = __pa(memblock.reserved.regions);
+		size = PAGE_ALIGN(sizeof(struct memblock_region) *
+				  memblock.reserved.max);
+		__memblock_free_late(addr, size);
+	}
+
+	if (memblock.memory.regions == memblock_memory_init_regions) {
+		addr = __pa(memblock.memory.regions);
+		size = PAGE_ALIGN(sizeof(struct memblock_region) *
+				  memblock.memory.max);
+		__memblock_free_late(addr, size);
+	}
 }
-
 #endif
 
 /**
diff -puN mm/nobootmem.c~mm-discard-memblock-data-later mm/nobootmem.c
--- a/mm/nobootmem.c~mm-discard-memblock-data-later
+++ a/mm/nobootmem.c
@@ -146,22 +146,6 @@ static unsigned long __init free_low_mem
 				NULL)
 		count += __free_memory_core(start, end);
 
-#ifdef CONFIG_ARCH_DISCARD_MEMBLOCK
-	{
-		phys_addr_t size;
-
-		/* Free memblock.reserved array if it was allocated */
-		size = get_allocated_memblock_reserved_regions_info(&start);
-		if (size)
-			count += __free_memory_core(start, start + size);
-
-		/* Free memblock.memory array if it was allocated */
-		size = get_allocated_memblock_memory_regions_info(&start);
-		if (size)
-			count += __free_memory_core(start, start + size);
-	}
-#endif
