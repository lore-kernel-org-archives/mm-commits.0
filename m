From: akpm@linux-foundation.org
Subject: + x86-print-physical-addresses-consistently-with-other-parts-of-kernel.patch added to -mm tree
Date: Mon, 30 Apr 2012 16:27:21 -0700
Message-ID: <20120430232721.5856CA04B2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51326 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757370Ab2D3X1W (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 30 Apr 2012 19:27:22 -0400
Received: by qcsp5 with SMTP id p5so404657qcs.1
        for <mm-commits@vger.kernel.org>; Mon, 30 Apr 2012 16:27:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bhelgaas@google.com, hpa@zytor.com, konrad.wilk@oracle.com, mingo@elte.hu, tglx@linutronix.de, yinghai@kernel.org


The patch titled
     Subject: x86: print physical addresses consistently with other parts of kernel
has been added to the -mm tree.  Its filename is
     x86-print-physical-addresses-consistently-with-other-parts-of-kernel.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Bjorn Helgaas <bhelgaas@google.com>
Subject: x86: print physical addresses consistently with other parts of kernel

Print physical address info in a style consistent with the %pR style used
elsewhere in the kernel.  For example:

    -found SMP MP-table at [ffff8800000fce90] fce90
    +found SMP MP-table at [mem 0x000fce90-0x000fce9f] mapped at [ffff8800000fce90]
    -initial memory mapped : 0 - 20000000
    +initial memory mapped: [mem 0x00000000-0x1fffffff]
    -Base memory trampoline at [ffff88000009c000] 9c000 size 8192
    +Base memory trampoline [mem 0x0009c000-0x0009dfff] mapped at [ffff88000009c000]
    -SRAT: Node 0 PXM 0 0-80000000
    +SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/mpparse.c    |   10 ++++---
 arch/x86/kernel/setup.c      |   16 ++++++------
 arch/x86/kernel/trampoline.c |    5 ++-
 arch/x86/mm/init.c           |   16 +++++++-----
 arch/x86/mm/numa.c           |   32 ++++++++++++-------------
 arch/x86/mm/numa_emulation.c |    4 +--
 arch/x86/mm/pat.c            |   42 ++++++++++++++-------------------
 arch/x86/mm/srat.c           |    5 ++-
 8 files changed, 66 insertions(+), 64 deletions(-)

diff -puN arch/x86/kernel/mpparse.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel arch/x86/kernel/mpparse.c
--- a/arch/x86/kernel/mpparse.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel
+++ a/arch/x86/kernel/mpparse.c
@@ -573,8 +573,8 @@ static int __init smp_scan_config(unsign
 	struct mpf_intel *mpf;
 	unsigned long mem;
 
-	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n",
-			bp, length);
+	apic_printk(APIC_VERBOSE, "Scan for SMP in [mem %#010lx-%#010lx]\n",
+		    base, base + length - 1);
 	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
@@ -589,8 +589,10 @@ static int __init smp_scan_config(unsign
 #endif
 			mpf_found = mpf;
 
-			printk(KERN_INFO "found SMP MP-table at [%p] %llx\n",
-			       mpf, (u64)virt_to_phys(mpf));
+			printk(KERN_INFO "found SMP MP-table at [mem %#010llx-%#010llx] mapped at [%p]\n",
+			       (unsigned long long) virt_to_phys(mpf),
+			       (unsigned long long) virt_to_phys(mpf) +
+			       sizeof(*mpf) - 1, mpf);
 
 			mem = virt_to_phys(mpf);
 			memblock_reserve(mem, sizeof(*mpf));
diff -puN arch/x86/kernel/setup.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel arch/x86/kernel/setup.c
--- a/arch/x86/kernel/setup.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel
+++ a/arch/x86/kernel/setup.c
@@ -341,8 +341,8 @@ static void __init relocate_initrd(void)
 	memblock_reserve(ramdisk_here, area_size);
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
-	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
-			 ramdisk_here, ramdisk_here + ramdisk_size);
+	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
+			 ramdisk_here, ramdisk_here + ramdisk_size - 1);
 
 	q = (char *)initrd_start;
 
@@ -373,8 +373,8 @@ static void __init relocate_initrd(void)
 	/* high pages is not converted by early_res_to_bootmem */
 	ramdisk_image = boot_params.hdr.ramdisk_image;
 	ramdisk_size  = boot_params.hdr.ramdisk_size;
-	printk(KERN_INFO "Move RAMDISK from %016llx - %016llx to"
-		" %08llx - %08llx\n",
+	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
+		" [mem %#010llx-%#010llx]\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 }
@@ -400,8 +400,8 @@ static void __init reserve_initrd(void)
 		return;
 	}
 
-	printk(KERN_INFO "RAMDISK: %08llx - %08llx\n", ramdisk_image,
-			ramdisk_end);
+	printk(KERN_INFO "RAMDISK: [mem %#010llx-%#010llx]\n", ramdisk_image,
+			ramdisk_end - 1);
 
 
 	if (ramdisk_end <= end_of_lowmem) {
@@ -917,8 +917,8 @@ void __init setup_arch(char **cmdline_p)
 	setup_bios_corruption_check();
 #endif
 
-	printk(KERN_DEBUG "initial memory mapped : 0 - %08lx\n",
-			max_pfn_mapped<<PAGE_SHIFT);
+	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
+			(max_pfn_mapped<<PAGE_SHIFT) - 1);
 
 	setup_trampolines();
 
diff -puN arch/x86/kernel/trampoline.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel arch/x86/kernel/trampoline.c
--- a/arch/x86/kernel/trampoline.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel
+++ a/arch/x86/kernel/trampoline.c
@@ -20,8 +20,9 @@ void __init setup_trampolines(void)
 	x86_trampoline_base = __va(mem);
 	memblock_reserve(mem, size);
 
-	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
-	       x86_trampoline_base, (unsigned long long)mem, size);
+	printk(KERN_DEBUG "Base memory trampoline [mem %#010llx-%#010llx] mapped at [%p]\n",
+	       (unsigned long long) mem, (unsigned long long) mem + size - 1,
+	       x86_trampoline_base);
 
 	memcpy(x86_trampoline_base, x86_trampoline_start, size);
 }
diff -puN arch/x86/mm/init.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel arch/x86/mm/init.c
--- a/arch/x86/mm/init.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel
+++ a/arch/x86/mm/init.c
@@ -84,8 +84,9 @@ static void __init find_early_table_spac
 	pgt_buf_end = pgt_buf_start;
 	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
 
-	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
+	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx]\n",
+		end - 1, pgt_buf_start << PAGE_SHIFT,
+		(pgt_buf_top << PAGE_SHIFT) - 1);
 }
 
 void __init native_pagetable_reserve(u64 start, u64 end)
@@ -132,7 +133,8 @@ unsigned long __init_refok init_memory_m
 	int nr_range, i;
 	int use_pse, use_gbpages;
 
-	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
+	printk(KERN_INFO "init_memory_mapping: [mem %#010lx-%#010lx]\n",
+	       start, end - 1);
 
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 	/*
@@ -251,8 +253,8 @@ unsigned long __init_refok init_memory_m
 	}
 
 	for (i = 0; i < nr_range; i++)
-		printk(KERN_DEBUG " %010lx - %010lx page %s\n",
-				mr[i].start, mr[i].end,
+		printk(KERN_DEBUG " [mem %#010lx-%#010lx] page %s\n",
+				mr[i].start, mr[i].end - 1,
 			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
 			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
 
@@ -350,8 +352,8 @@ void free_init_pages(char *what, unsigne
 	 * create a kernel page fault:
 	 */
 #ifdef CONFIG_DEBUG_PAGEALLOC
-	printk(KERN_INFO "debug: unmapping init memory %08lx..%08lx\n",
-		begin, end);
+	printk(KERN_INFO "debug: unmapping init [mem %#010lx-%#010lx]\n",
+		begin, end - 1);
 	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
 #else
 	/*
diff -puN arch/x86/mm/numa.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel arch/x86/mm/numa.c
--- a/arch/x86/mm/numa.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel
+++ a/arch/x86/mm/numa.c
@@ -141,8 +141,8 @@ static int __init numa_add_memblk_to(int
 
 	/* whine about and ignore invalid blks */
 	if (start > end || nid < 0 || nid >= MAX_NUMNODES) {
-		pr_warning("NUMA: Warning: invalid memblk node %d (%Lx-%Lx)\n",
-			   nid, start, end);
+		pr_warning("NUMA: Warning: invalid memblk node %d [mem %#010Lx-%#010Lx]\n",
+			   nid, start, end - 1);
 		return 0;
 	}
 
@@ -210,8 +210,8 @@ static void __init setup_node_data(int n
 
 	start = roundup(start, ZONE_ALIGN);
 
-	printk(KERN_INFO "Initmem setup node %d %016Lx-%016Lx\n",
-	       nid, start, end);
+	printk(KERN_INFO "Initmem setup node %d [mem %#010Lx-%#010Lx]\n",
+	       nid, start, end - 1);
 
 	/*
 	 * Allocate node data.  Try remap allocator first, node-local
@@ -232,7 +232,7 @@ static void __init setup_node_data(int n
 	}
 
 	/* report and initialize */
-	printk(KERN_INFO "  NODE_DATA [%016Lx - %016Lx]%s\n",
+	printk(KERN_INFO "  NODE_DATA [mem %#010Lx-%#010Lx]%s\n",
 	       nd_pa, nd_pa + nd_size - 1, remapped ? " (remapped)" : "");
 	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
 	if (!remapped && tnid != nid)
@@ -291,14 +291,14 @@ int __init numa_cleanup_meminfo(struct n
 			 */
 			if (bi->end > bj->start && bi->start < bj->end) {
 				if (bi->nid != bj->nid) {
-					pr_err("NUMA: node %d (%Lx-%Lx) overlaps with node %d (%Lx-%Lx)\n",
-					       bi->nid, bi->start, bi->end,
-					       bj->nid, bj->start, bj->end);
+					pr_err("NUMA: node %d [mem %#010Lx-%#010Lx] overlaps with node %d [mem %#010Lx-%#010Lx]\n",
+					       bi->nid, bi->start, bi->end - 1,
+					       bj->nid, bj->start, bj->end - 1);
 					return -EINVAL;
 				}
-				pr_warning("NUMA: Warning: node %d (%Lx-%Lx) overlaps with itself (%Lx-%Lx)\n",
-					   bi->nid, bi->start, bi->end,
-					   bj->start, bj->end);
+				pr_warning("NUMA: Warning: node %d [mem %#010Lx-%#010Lx] overlaps with itself [mem %#010Lx-%#010Lx]\n",
+					   bi->nid, bi->start, bi->end - 1,
+					   bj->start, bj->end - 1);
 			}
 
 			/*
@@ -320,9 +320,9 @@ int __init numa_cleanup_meminfo(struct n
 			}
 			if (k < mi->nr_blks)
 				continue;
-			printk(KERN_INFO "NUMA: Node %d [%Lx,%Lx) + [%Lx,%Lx) -> [%Lx,%Lx)\n",
-			       bi->nid, bi->start, bi->end, bj->start, bj->end,
-			       start, end);
+			printk(KERN_INFO "NUMA: Node %d [mem %#010Lx-%#010Lx] + [mem %#010Lx-%#010Lx] -> [mem %#010Lx-%#010Lx]\n",
+			       bi->nid, bi->start, bi->end - 1, bj->start,
+			       bj->end - 1, start, end - 1);
 			bi->start = start;
 			bi->end = end;
 			numa_remove_memblk_from(j--, mi);
@@ -616,8 +616,8 @@ static int __init dummy_numa_init(void)
 {
 	printk(KERN_INFO "%s\n",
 	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
-	printk(KERN_INFO "Faking a node at %016Lx-%016Lx\n",
-	       0LLU, PFN_PHYS(max_pfn));
+	printk(KERN_INFO "Faking a node at [mem %#018Lx-%#018Lx]\n",
+	       0LLU, PFN_PHYS(max_pfn) - 1);
 
 	node_set(0, numa_nodes_parsed);
 	numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
diff -puN arch/x86/mm/numa_emulation.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel arch/x86/mm/numa_emulation.c
--- a/arch/x86/mm/numa_emulation.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel
+++ a/arch/x86/mm/numa_emulation.c
@@ -68,8 +68,8 @@ static int __init emu_setup_memblk(struc
 		numa_remove_memblk_from(phys_blk, pi);
 	}
 
-	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
-	       eb->start, eb->end, (eb->end - eb->start) >> 20);
+	printk(KERN_INFO "Faking node %d at [mem %#018Lx-%#018Lx] (%LuMB)\n",
+	       nid, eb->start, eb->end - 1, (eb->end - eb->start) >> 20);
 	return 0;
 }
 
diff -puN arch/x86/mm/pat.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel arch/x86/mm/pat.c
--- a/arch/x86/mm/pat.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel
+++ a/arch/x86/mm/pat.c
@@ -209,9 +209,8 @@ static int reserve_ram_pages_type(u64 st
 		page = pfn_to_page(pfn);
 		type = get_page_memtype(page);
 		if (type != -1) {
-			printk(KERN_INFO "reserve_ram_pages_type failed "
-				"0x%Lx-0x%Lx, track 0x%lx, req 0x%lx\n",
-				start, end, type, req_type);
+			printk(KERN_INFO "reserve_ram_pages_type failed [mem %#010Lx-%#010Lx], track 0x%lx, req 0x%lx\n",
+				start, end - 1, type, req_type);
 			if (new_type)
 				*new_type = type;
 
@@ -314,9 +313,9 @@ int reserve_memtype(u64 start, u64 end, 
 
 	err = rbt_memtype_check_insert(new, new_type);
 	if (err) {
-		printk(KERN_INFO "reserve_memtype failed 0x%Lx-0x%Lx, "
-		       "track %s, req %s\n",
-		       start, end, cattr_name(new->type), cattr_name(req_type));
+		printk(KERN_INFO "reserve_memtype failed [mem %#010Lx-%#010Lx], track %s, req %s\n",
+		       start, end - 1,
+		       cattr_name(new->type), cattr_name(req_type));
 		kfree(new);
 		spin_unlock(&memtype_lock);
 
@@ -325,8 +324,8 @@ int reserve_memtype(u64 start, u64 end, 
 
 	spin_unlock(&memtype_lock);
 
-	dprintk("reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
-		start, end, cattr_name(new->type), cattr_name(req_type),
+	dprintk("reserve_memtype added [mem %#010Lx-%#010Lx], track %s, req %s, ret %s\n",
+		start, end - 1, cattr_name(new->type), cattr_name(req_type),
 		new_type ? cattr_name(*new_type) : "-");
 
 	return err;
@@ -360,14 +359,14 @@ int free_memtype(u64 start, u64 end)
 	spin_unlock(&memtype_lock);
 
 	if (!entry) {
-		printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
-			current->comm, current->pid, start, end);
+		printk(KERN_INFO "%s:%d freeing invalid memtype [mem %#010Lx-%#010Lx]\n",
+		       current->comm, current->pid, start, end - 1);
 		return -EINVAL;
 	}
 
 	kfree(entry);
 
-	dprintk("free_memtype request 0x%Lx-0x%Lx\n", start, end);
+	dprintk("free_memtype request [mem %#010Lx-%#010Lx]\n", start, end - 1);
 
 	return 0;
 }
@@ -491,9 +490,8 @@ static inline int range_is_allowed(unsig
 
 	while (cursor < to) {
 		if (!devmem_is_allowed(pfn)) {
-			printk(KERN_INFO
-		"Program %s tried to access /dev/mem between %Lx->%Lx.\n",
-				current->comm, from, to);
+			printk(KERN_INFO "Program %s tried to access /dev/mem between [mem %#010Lx-%#010Lx]\n",
+				current->comm, from, to - 1);
 			return 0;
 		}
 		cursor += PAGE_SIZE;
@@ -554,12 +552,11 @@ int kernel_map_sync_memtype(u64 base, un
 				size;
 
 	if (ioremap_change_attr((unsigned long)__va(base), id_sz, flags) < 0) {
-		printk(KERN_INFO
-			"%s:%d ioremap_change_attr failed %s "
-			"for %Lx-%Lx\n",
+		printk(KERN_INFO "%s:%d ioremap_change_attr failed %s "
+			"for [mem %#010Lx-%#010Lx]\n",
 			current->comm, current->pid,
 			cattr_name(flags),
-			base, (unsigned long long)(base + size));
+			base, (unsigned long long)(base + size-1));
 		return -EINVAL;
 	}
 	return 0;
@@ -591,12 +588,11 @@ static int reserve_pfn_range(u64 paddr, 
 
 		flags = lookup_memtype(paddr);
 		if (want_flags != flags) {
-			printk(KERN_WARNING
-			"%s:%d map pfn RAM range req %s for %Lx-%Lx, got %s\n",
+			printk(KERN_WARNING "%s:%d map pfn RAM range req %s for [mem %#010Lx-%#010Lx], got %s\n",
 				current->comm, current->pid,
 				cattr_name(want_flags),
 				(unsigned long long)paddr,
-				(unsigned long long)(paddr + size),
+				(unsigned long long)(paddr + size - 1),
 				cattr_name(flags));
 			*vma_prot = __pgprot((pgprot_val(*vma_prot) &
 					      (~_PAGE_CACHE_MASK)) |
@@ -614,11 +610,11 @@ static int reserve_pfn_range(u64 paddr, 
 		    !is_new_memtype_allowed(paddr, size, want_flags, flags)) {
 			free_memtype(paddr, paddr + size);
 			printk(KERN_ERR "%s:%d map pfn expected mapping type %s"
-				" for %Lx-%Lx, got %s\n",
+				" for [mem %#010Lx-%#010Lx], got %s\n",
 				current->comm, current->pid,
 				cattr_name(want_flags),
 				(unsigned long long)paddr,
-				(unsigned long long)(paddr + size),
+				(unsigned long long)(paddr + size - 1),
 				cattr_name(flags));
 			return -EINVAL;
 		}
diff -puN arch/x86/mm/srat.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel arch/x86/mm/srat.c
--- a/arch/x86/mm/srat.c~x86-print-physical-addresses-consistently-with-other-parts-of-kernel
+++ a/arch/x86/mm/srat.c
@@ -176,8 +176,9 @@ acpi_numa_memory_affinity_init(struct ac
 		return;
 	}
 
-	printk(KERN_INFO "SRAT: Node %u PXM %u %Lx-%Lx\n", node, pxm,
-	       start, end);
+	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
+	       node, pxm,
+	       (unsigned long long) start, (unsigned long long) end - 1);
 }
 
 void __init acpi_numa_arch_fixup(void) {}
_
Subject: Subject: x86: print physical addresses consistently with other parts of kernel

Patches currently in -mm which might be from bhelgaas@google.com are

linux-next.patch
x86-print-e820-physical-addresses-consistently-with-other-parts-of-kernel.patch
x86-print-physical-addresses-consistently-with-other-parts-of-kernel.patch
swiotlb-print-physical-addresses-consistently-with-other-parts-of-kernel.patch
mm-print-physical-addresses-consistently-with-other-parts-of-kernel.patch

