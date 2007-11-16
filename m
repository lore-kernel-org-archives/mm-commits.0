From: akpm@linux-foundation.org
Subject: + x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2.patch added to -mm tree
Date: Fri, 16 Nov 2007 15:52:32 -0800
Message-ID: <200711162352.lAGNqWRt010065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39930 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763504AbXKPXxU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Nov 2007 18:53:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clameter@sgi.com, ak@suse.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86_64: make sparsemem/vmemmap the default memory model
has been added to the -mm tree.  Its filename is
     x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: make sparsemem/vmemmap the default memory model
From: Christoph Lameter <clameter@sgi.com>

Use sparsemem as the only memory model for UP, SMP and NUMA.  Measurements
indicate that DISCONTIGMEM has a higher overhead than sparsemem.  And
FLATMEMs benefits are minimal.  So I think its best to simply standardize
on sparsemem.

Results of page allocator tests (test can be had via git from slab git
tree branch tests)

Measurements in cycle counts. 1000 allocations were performed and then the
average cycle count was calculated.

Order	FlatMem	Discontig	SparseMem
0	  639	  665		  641
1	  567	  647		  593
2	  679	  774		  692
3	  763	  967		  781
4	  961	 1501		  962
5	 1356	 2344		 1392
6	 2224	 3982		 2336
7	 4869	 7225		 5074
8	12500	14048		12732
9	27926	28223		28165
10	58578	58714		58682

(Note that FlatMem is an SMP config and the rest NUMA configurations)

Memory use:

SMP Sparsemem
-------------

Kernel size:

   text    data     bss     dec     hex filename
3849268  397739 1264856 5511863  541ab7 vmlinux

             total       used       free     shared    buffers     cached
Mem:       8242252      41164    8201088          0        352      11512
-/+ buffers/cache:      29300    8212952
Swap:      9775512          0    9775512

SMP Flatmem
-----------

Kernel size:

   text    data     bss     dec     hex filename
3844612  397739 1264536 5506887  540747 vmlinux

So 4.5k growth in text size vs. FLATMEM.

             total       used       free     shared    buffers     cached
Mem:       8244052      40544    8203508          0        352      11484
-/+ buffers/cache:      28708    8215344

2k growth in overall memory use after boot.

NUMA discontig:

   text    data     bss     dec     hex filename
3888124  470659 1276504 5635287  55fcd7 vmlinux

             total       used       free     shared    buffers     cached
Mem:       8256256      56908    8199348          0        352      11496
-/+ buffers/cache:      45060    8211196
Swap:      9775512          0    9775512

NUMA sparse:

   text    data     bss     dec     hex filename
3896428  470659 1276824 5643911  561e87 vmlinux

8k text growth. Given that we fully inline virt_to_page and friends now
that is rather good.

             total       used       free     shared    buffers     cached
Mem:       8264720      57240    8207480          0        352      11516
-/+ buffers/cache:      45372    8219348
Swap:      9775512          0    9775512

The total available memory is increased by 8k.

This patch makes sparsemem the default and removes discontig and
flatmem support from x86.

Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig                   |   20 +++------
 arch/x86/configs/x86_64_defconfig  |    9 ----
 arch/x86/kernel/machine_kexec_64.c |    5 --
 arch/x86/mm/init_64.c              |   30 --------------
 arch/x86/mm/ioremap_64.c           |   17 --------
 arch/x86/mm/numa_64.c              |   21 ---------
 arch/x86/mm/srat_64.c              |   57 ---------------------------
 include/asm-x86/mmzone_64.h        |    6 --
 include/asm-x86/page_64.h          |    3 -
 include/asm-x86/sparsemem_64.h     |    4 -
 10 files changed, 8 insertions(+), 164 deletions(-)

diff -puN arch/x86/Kconfig~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2 arch/x86/Kconfig
--- a/arch/x86/Kconfig~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2
+++ a/arch/x86/Kconfig
@@ -911,19 +911,23 @@ config HAVE_ARCH_ALLOC_REMAP
 
 config ARCH_FLATMEM_ENABLE
 	def_bool y
-	depends on (X86_32 && ARCH_SELECT_MEMORY_MODEL && X86_PC) || (X86_64 && !NUMA)
+	depends on X86_32 && ARCH_SELECT_MEMORY_MODEL && X86_PC
 
 config ARCH_DISCONTIGMEM_ENABLE
 	def_bool y
-	depends on NUMA
+	depends on NUMA && X86_32
 
 config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y
-	depends on NUMA
+	depends on NUMA && X86_32
+
+config ARCH_SPARSEMEM_DEFAULT
+	def_bool y
+	depends on X86_64
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
-	depends on NUMA || (EXPERIMENTAL && (X86_PC || X86_64))
+	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_PC)
 	select SPARSEMEM_STATIC if X86_32
 	select SPARSEMEM_VMEMMAP_ENABLE if X86_64
 
@@ -1227,18 +1231,10 @@ config ARCH_ENABLE_MEMORY_HOTPLUG
 	def_bool y
 	depends on X86_64 || (X86_32 && HIGHMEM)
 
-config MEMORY_HOTPLUG_RESERVE
-	def_bool X86_64
-	depends on (MEMORY_HOTPLUG && DISCONTIGMEM)
-
 config HAVE_ARCH_EARLY_PFN_TO_NID
 	def_bool X86_64
 	depends on NUMA
 
-config OUT_OF_LINE_PFN_TO_PAGE
-	def_bool X86_64
-	depends on DISCONTIGMEM
-
 menu "Power management options"
 	depends on !X86_VOYAGER
 
diff -puN arch/x86/configs/x86_64_defconfig~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2 arch/x86/configs/x86_64_defconfig
--- a/arch/x86/configs/x86_64_defconfig~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2
+++ a/arch/x86/configs/x86_64_defconfig
@@ -145,15 +145,6 @@ CONFIG_K8_NUMA=y
 CONFIG_NODES_SHIFT=6
 CONFIG_X86_64_ACPI_NUMA=y
 CONFIG_NUMA_EMU=y
-CONFIG_ARCH_DISCONTIGMEM_ENABLE=y
-CONFIG_ARCH_DISCONTIGMEM_DEFAULT=y
-CONFIG_ARCH_SPARSEMEM_ENABLE=y
-CONFIG_SELECT_MEMORY_MODEL=y
-# CONFIG_FLATMEM_MANUAL is not set
-CONFIG_DISCONTIGMEM_MANUAL=y
-# CONFIG_SPARSEMEM_MANUAL is not set
-CONFIG_DISCONTIGMEM=y
-CONFIG_FLAT_NODE_MEM_MAP=y
 CONFIG_NEED_MULTIPLE_NODES=y
 # CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPLIT_PTLOCK_CPUS=4
diff -puN arch/x86/kernel/machine_kexec_64.c~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2 arch/x86/kernel/machine_kexec_64.c
--- a/arch/x86/kernel/machine_kexec_64.c~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2
+++ a/arch/x86/kernel/machine_kexec_64.c
@@ -234,10 +234,5 @@ NORET_TYPE void machine_kexec(struct kim
 void arch_crash_save_vmcoreinfo(void)
 {
 	VMCOREINFO_SYMBOL(init_level4_pgt);
-
-#ifdef CONFIG_ARCH_DISCONTIGMEM_ENABLE
-	VMCOREINFO_SYMBOL(node_data);
-	VMCOREINFO_LENGTH(node_data, MAX_NUMNODES);
-#endif
 }
 
diff -puN arch/x86/mm/init_64.c~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2 arch/x86/mm/init_64.c
--- a/arch/x86/mm/init_64.c~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2
+++ a/arch/x86/mm/init_64.c
@@ -486,34 +486,6 @@ EXPORT_SYMBOL_GPL(memory_add_physaddr_to
 
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-#ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-/*
- * Memory Hotadd without sparsemem. The mem_maps have been allocated in advance,
- * just online the pages.
- */
-int __add_pages(struct zone *z, unsigned long start_pfn, unsigned long nr_pages)
-{
-	int err = -EIO;
-	unsigned long pfn;
-	unsigned long total = 0, mem = 0;
-	for (pfn = start_pfn; pfn < start_pfn + nr_pages; pfn++) {
-		if (pfn_valid(pfn)) {
-			online_page(pfn_to_page(pfn));
-			err = 0;
-			mem++;
-		}
-		total++;
-	}
-	if (!err) {
-		z->spanned_pages += total;
-		z->present_pages += mem;
-		z->zone_pgdat->node_spanned_pages += total;
-		z->zone_pgdat->node_present_pages += mem;
-	}
-	return err;
-}
-#endif
-
 static struct kcore_list kcore_mem, kcore_vmalloc, kcore_kernel, kcore_modules,
 			 kcore_vsyscall;
 
@@ -739,7 +711,6 @@ const char *arch_vma_name(struct vm_area
 	return NULL;
 }
 
-#ifdef CONFIG_SPARSEMEM_VMEMMAP
 /*
  * Initialise the sparsemem vmemmap using huge-pages at the PMD level.
  */
@@ -782,4 +753,3 @@ int __meminit vmemmap_populate(struct pa
 
 	return 0;
 }
-#endif
diff -puN arch/x86/mm/ioremap_64.c~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2 arch/x86/mm/ioremap_64.c
--- a/arch/x86/mm/ioremap_64.c~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2
+++ a/arch/x86/mm/ioremap_64.c
@@ -86,23 +86,6 @@ void __iomem * __ioremap(unsigned long p
 	if (phys_addr >= ISA_START_ADDRESS && last_addr < ISA_END_ADDRESS)
 		return (__force void __iomem *)phys_to_virt(phys_addr);
 
-#ifdef CONFIG_FLATMEM
-	/*
-	 * Don't allow anybody to remap normal RAM that we're using..
-	 */
-	if (last_addr < virt_to_phys(high_memory)) {
-		char *t_addr, *t_end;
- 		struct page *page;
-
-		t_addr = __va(phys_addr);
-		t_end = t_addr + (size - 1);
-	   
-		for(page = virt_to_page(t_addr); page <= virt_to_page(t_end); page++)
-			if(!PageReserved(page))
-				return NULL;
-	}
-#endif
-
 	pgprot = __pgprot(_PAGE_PRESENT | _PAGE_RW | _PAGE_GLOBAL
 			  | _PAGE_DIRTY | _PAGE_ACCESSED | flags);
 	/*
diff -puN arch/x86/mm/numa_64.c~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2 arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2
+++ a/arch/x86/mm/numa_64.c
@@ -150,12 +150,10 @@ int __init compute_hash_shift(struct boo
 	return shift;
 }
 
-#ifdef CONFIG_SPARSEMEM
 int early_pfn_to_nid(unsigned long pfn)
 {
 	return phys_to_nid(pfn << PAGE_SHIFT);
 }
-#endif
 
 static void * __init
 early_node_mem(int nodeid, unsigned long start, unsigned long end,
@@ -626,23 +624,4 @@ EXPORT_SYMBOL(cpu_to_node);
 EXPORT_SYMBOL(node_to_cpumask);
 EXPORT_SYMBOL(node_data);
 
-#ifdef CONFIG_DISCONTIGMEM
-/*
- * Functions to convert PFNs from/to per node page addresses.
- * These are out of line because they are quite big.
- * They could be all tuned by pre caching more state.
- * Should do that.
- */
 
-int pfn_valid(unsigned long pfn)
-{
-	unsigned nid;
-	if (pfn >= num_physpages)
-		return 0;
-	nid = pfn_to_nid(pfn);
-	if (nid == 0xff)
-		return 0;
-	return pfn >= node_start_pfn(nid) && (pfn) < node_end_pfn(nid);
-}
-EXPORT_SYMBOL(pfn_valid);
-#endif
diff -puN arch/x86/mm/srat_64.c~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2 arch/x86/mm/srat_64.c
--- a/arch/x86/mm/srat_64.c~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2
+++ a/arch/x86/mm/srat_64.c
@@ -151,62 +151,6 @@ acpi_numa_processor_affinity_init(struct
 	       pxm, pa->apic_id, node);
 }
 
-#ifdef CONFIG_MEMORY_HOTPLUG_RESERVE
-/*
- * Protect against too large hotadd areas that would fill up memory.
- */
-static int hotadd_enough_memory(struct bootnode *nd)
-{
-	static unsigned long allocated;
-	static unsigned long last_area_end;
-	unsigned long pages = (nd->end - nd->start) >> PAGE_SHIFT;
-	long mem = pages * sizeof(struct page);
-	unsigned long addr;
-	unsigned long allowed;
-	unsigned long oldpages = pages;
-
-	if (mem < 0)
-		return 0;
-	allowed = (end_pfn - absent_pages_in_range(0, end_pfn)) * PAGE_SIZE;
-	allowed = (allowed / 100) * hotadd_percent;
-	if (allocated + mem > allowed) {
-		unsigned long range;
-		/* Give them at least part of their hotadd memory upto hotadd_percent
-		   It would be better to spread the limit out
-		   over multiple hotplug areas, but that is too complicated
-		   right now */
-		if (allocated >= allowed)
-			return 0;
-		range = allowed - allocated;
-		pages = (range / PAGE_SIZE);
-		mem = pages * sizeof(struct page);
-		nd->end = nd->start + range;
-	}
-	/* Not completely fool proof, but a good sanity check */
-	addr = find_e820_area(last_area_end, end_pfn<<PAGE_SHIFT, mem);
-	if (addr == -1UL)
-		return 0;
-	if (pages != oldpages)
-		printk(KERN_NOTICE "SRAT: Hotadd area limited to %lu bytes\n",
-			pages << PAGE_SHIFT);
-	last_area_end = addr + mem;
-	allocated += mem;
-	return 1;
-}
-
-static int update_end_of_memory(unsigned long end)
-{
-	found_add_area = 1;
-	if ((end >> PAGE_SHIFT) > end_pfn)
-		end_pfn = end >> PAGE_SHIFT;
-	return 1;
-}
-
-static inline int save_add_info(void)
-{
-	return hotadd_percent > 0;
-}
-#else
 int update_end_of_memory(unsigned long end) {return -1;}
 static int hotadd_enough_memory(struct bootnode *nd) {return 1;}
 #ifdef CONFIG_MEMORY_HOTPLUG_SPARSE
@@ -214,7 +158,6 @@ static inline int save_add_info(void) {r
 #else
 static inline int save_add_info(void) {return 0;}
 #endif
-#endif
 /*
  * Update nodes_add and decide if to include add are in the zone.
  * Both SPARSE and RESERVE need nodes_add infomation.
diff -puN include/asm-x86/mmzone_64.h~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2 include/asm-x86/mmzone_64.h
--- a/include/asm-x86/mmzone_64.h~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2
+++ a/include/asm-x86/mmzone_64.h
@@ -41,12 +41,6 @@ static inline __attribute__((pure)) int 
 #define node_end_pfn(nid)       (NODE_DATA(nid)->node_start_pfn + \
 				 NODE_DATA(nid)->node_spanned_pages)
 
-#ifdef CONFIG_DISCONTIGMEM
-#define pfn_to_nid(pfn) phys_to_nid((unsigned long)(pfn) << PAGE_SHIFT)
-
-extern int pfn_valid(unsigned long pfn);
-#endif
-
 #ifdef CONFIG_NUMA_EMU
 #define FAKE_NODE_MIN_SIZE	(64*1024*1024)
 #define FAKE_NODE_MIN_HASH_MASK	(~(FAKE_NODE_MIN_SIZE - 1uL))
diff -puN include/asm-x86/page_64.h~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2 include/asm-x86/page_64.h
--- a/include/asm-x86/page_64.h~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2
+++ a/include/asm-x86/page_64.h
@@ -121,9 +121,6 @@ extern unsigned long __phys_addr(unsigne
 #define __va(x)			((void *)((unsigned long)(x)+PAGE_OFFSET))
 #define __boot_va(x)		__va(x)
 #define __boot_pa(x)		__pa(x)
-#ifdef CONFIG_FLATMEM
-#define pfn_valid(pfn)		((pfn) < end_pfn)
-#endif
 
 #define virt_to_page(kaddr)	pfn_to_page(__pa(kaddr) >> PAGE_SHIFT)
 #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
diff -puN include/asm-x86/sparsemem_64.h~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2 include/asm-x86/sparsemem_64.h
--- a/include/asm-x86/sparsemem_64.h~x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2
+++ a/include/asm-x86/sparsemem_64.h
@@ -1,8 +1,6 @@
 #ifndef _ASM_X86_64_SPARSEMEM_H
 #define _ASM_X86_64_SPARSEMEM_H 1
 
-#ifdef CONFIG_SPARSEMEM
-
 /*
  * generic non-linear memory support:
  *
@@ -21,6 +19,4 @@
 
 extern int early_pfn_to_nid(unsigned long pfn);
 
-#endif /* CONFIG_SPARSEMEM */
-
 #endif /* _ASM_X86_64_SPARSEMEM_H */
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
ia64-slim-down-__clear_bit_unlock.patch
ia64-slim-down-__clear_bit_unlock-checkpatch-fixes.patch
iucv-axplicitly-code-allocpercpu-calls.patch
mem-policy-fix-mempolicy-usage-in-pci-driver.patch
git-unionfs.patch
git-x86.patch
x86_64-clean-up-stack-allocation-and-free.patch
x86_64-configure-stack-size.patch
x86_64-configure-stack-size-fix.patch
x86_64-make-sparsemem-vmemmap-the-default-memory-model-v2.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix.patch
pagecache-zeroing-zero_user_segment-zero_user_segments-and-zero_user-fix-2.patch
move-vmalloc_to_page-to-mm-vmalloc.patch
vmalloc-add-const-to-void-parameters.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
is_vmalloc_addr-check-if-an-address-is-within-the-vmalloc-boundaries.patch
vmalloc-clean-up-page-array-indexing.patch
vunmap-return-page-array-passed-on-vmap.patch
slub-move-count_partial.patch
slub-rename-numa-defrag_ratio-to-remote_node_defrag_ratio.patch
slub-consolidate-add_partial-and-add_partial_tail-to-one-function.patch
slub-use-non-atomic-bit-unlock.patch
slub-fix-coding-style-violations.patch
slub-fix-coding-style-violations-checkpatch-fixes.patch
slub-noinline-some-functions-to-avoid-them-being-folded-into-alloc-free.patch
slub-move-kmem_cache_node-determination-into-add_full-and-add_partial.patch
slub-avoid-checking-for-a-valid-object-before-zeroing-on-the-fast-path.patch
slub-__slab_alloc-exit-path-consolidation.patch
slub-provide-unique-end-marker-for-each-slab.patch
slub-provide-unique-end-marker-for-each-slab-fix.patch
slub-avoid-referencing-kmem_cache-structure-in-__slab_alloc.patch
slub-optional-fast-path-using-cmpxchg_local.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-checkpatch-fixes.patch
slub-do-our-own-locking-via-slab_lock-and-slab_unlock-fix.patch
slub-restructure-slab-alloc.patch
slub-comment-kmem_cache_cpu-structure.patch
vm-allow-get_page_unless_zero-on-compound-pages.patch
bufferhead-revert-constructor-removal.patch
bufferhead-revert-constructor-removal-checkpatch-fixes.patch
swapin_readahead-excise-numa-bogosity.patch
page-allocator-clean-up-pcp-draining-functions.patch
vmstat-small-revisions-to-refresh_cpu_vm_stats.patch
page-allocator-get-rid-of-the-list-of-cold-pages.patch
page-allocator-get-rid-of-the-list-of-cold-pages-fix.patch
mm-sparsec-check-the-return-value-of-sparse_index_alloc.patch
revoke-core-code.patch
slab-api-remove-useless-ctor-parameter-and-reorder-parameters-vs-revoke.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
oom-add-sysctl-to-enable-task-memory-dump.patch
add-cmpxchg_local-to-asm-generic-for-per-cpu-atomic-operations.patch
add-cmpxchg_local-cmpxchg64-and-cmpxchg64_local-to-ia64.patch
dentries-extract-common-code-to-remove-dentry-from-lru.patch
dentries-extract-common-code-to-remove-dentry-from-lru-fix.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch
