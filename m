From: akpm@linux-foundation.org
Subject: + solve-section-mismatch-for-free_area_init_core.patch added to -mm tree
Date: Fri, 22 Feb 2008 23:32:31 -0800
Message-ID: <200802230733.m1N7XKne018208@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:55488 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759221AbYBWIEb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 23 Feb 2008 03:04:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: heukelum@mailshack.com, geert@linux-m68k.org, heukelum@fastmail.fm, sam@ravnborg.org


The patch titled
     Solve section mismatch for free_area_init_core.
has been added to the -mm tree.  Its filename is
     solve-section-mismatch-for-free_area_init_core.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Solve section mismatch for free_area_init_core.
From: Alexander van Heukelum <heukelum@mailshack.com>

WARNING: vmlinux.o(.meminit.text+0x649):
Section mismatch in reference from the
function free_area_init_core() to the function .init.text:setup_usemap()
The function __meminit free_area_init_core() references
a function __init setup_usemap().
If free_area_init_core is only used by setup_usemap then
annotate free_area_init_core with a matching annotation.

The warning is covers this stack of functions in mm/page_alloc.c:

alloc_bootmem_node must be marked __init.
alloc_bootmem_node is used by setup_usemap, if !SPARSEMEM.
(usemap_size is only used by setup_usemap, if !SPARSEMEM.)
setup_usemap is only used by free_area_init_core.
free_area_init_core is only used by free_area_init_node.

free_area_init_node is used by:
arch/alpha/mm/numa.c: __init paging_init()
arch/arm/mm/init.c: __init bootmem_init_node()
arch/avr32/mm/init.c: __init paging_init()
arch/cris/arch-v10/mm/init.c: __init paging_init()
arch/cris/arch-v32/mm/init.c: __init paging_init()
arch/m32r/mm/discontig.c: __init zone_sizes_init()
arch/m32r/mm/init.c: __init zone_sizes_init()
arch/m68k/mm/motorola.c: __init paging_init()
arch/m68k/mm/sun3mmu.c: __init paging_init()
arch/mips/sgi-ip27/ip27-memory.c: __init paging_init()
arch/parisc/mm/init.c: __init paging_init()
arch/sparc/mm/srmmu.c: __init srmmu_paging_init()
arch/sparc/mm/sun4c.c: __init sun4c_paging_init()
arch/sparc64/mm/init.c: __init paging_init()
mm/page_alloc.c: __init free_area_init_nodes()
mm/page_alloc.c: __init free_area_init()
and
mm/memory_hotplug.c: hotadd_new_pgdat()

hotadd_new_pgdat can not be an __init function, but:

It is compiled for MEMORY_HOTPLUG configurations only
MEMORY_HOTPLUG depends on SPARSEMEM || X86_64_ACPI_NUMA
X86_64_ACPI_NUMA depends on X86_64
ARCH_FLATMEM_ENABLE depends on X86_32
ARCH_DISCONTIGMEM_ENABLE depends on X86_32
So X86_64_ACPI_NUMA implies SPARSEMEM, right?

So we can mark the stack of functions __init for !SPARSEMEM, but we must mark
them __meminit for SPARSEMEM configurations.  This is ok, because then the
calls to alloc_bootmem_node are also avoided.

Compile-tested on:
silly minimal config
defconfig x86_32
defconfig x86_64
defconfig x86_64 -HIBERNATION +MEMORY_HOTPLUG

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>
Reviewed-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/internal.h   |   13 +++++++++++++
 mm/page_alloc.c |    4 ++--
 2 files changed, 15 insertions(+), 2 deletions(-)

diff -puN mm/internal.h~solve-section-mismatch-for-free_area_init_core mm/internal.h
--- a/mm/internal.h~solve-section-mismatch-for-free_area_init_core
+++ a/mm/internal.h
@@ -47,4 +47,17 @@ static inline unsigned long page_order(s
 	VM_BUG_ON(!PageBuddy(page));
 	return page_private(page);
 }
+
+/*
+ * FLATMEM and DISCONTIGMEM configurations use alloc_bootmem_node,
+ * so all functions starting at paging_init should be marked __init
+ * in those cases. SPARSEMEM, however, allows for memory hotplug,
+ * and alloc_bootmem_node is not used.
+ */
+#ifdef CONFIG_SPARSEMEM
+#define __paginginit __meminit
+#else
+#define __paginginit __init
+#endif
+
 #endif
diff -puN mm/page_alloc.c~solve-section-mismatch-for-free_area_init_core mm/page_alloc.c
--- a/mm/page_alloc.c~solve-section-mismatch-for-free_area_init_core
+++ a/mm/page_alloc.c
@@ -3314,7 +3314,7 @@ static inline int pageblock_default_orde
  *   - mark all memory queues empty
  *   - clear the memory bitmaps
  */
-static void __meminit free_area_init_core(struct pglist_data *pgdat,
+static void __paginginit free_area_init_core(struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long *zholes_size)
 {
 	enum zone_type j;
@@ -3438,7 +3438,7 @@ static void __init_refok alloc_node_mem_
 #endif /* CONFIG_FLAT_NODE_MEM_MAP */
 }
 
-void __meminit free_area_init_node(int nid, struct pglist_data *pgdat,
+void __paginginit free_area_init_node(int nid, struct pglist_data *pgdat,
 		unsigned long *zones_size, unsigned long node_start_pfn,
 		unsigned long *zholes_size)
 {
_

Patches currently in -mm which might be from heukelum@mailshack.com are

solve-section-mismatch-for-free_area_init_core.patch
