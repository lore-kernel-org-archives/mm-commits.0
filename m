Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D483C07E96
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 662996117A
	for <mm-commits@archiver.kernel.org>; Tue,  6 Jul 2021 19:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231822AbhGFTSC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Jul 2021 15:18:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231811AbhGFTSC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 6 Jul 2021 15:18:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED2CD60FDB;
        Tue,  6 Jul 2021 19:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625598923;
        bh=VTR2NwJQRSenKcFNla4cmn6LCseBJ2msTmtx+O4LCXA=;
        h=Date:From:To:Subject:From;
        b=l9egX7kCuT1wNU+Qat+kME1o1oeM14S95TcIvilst7agJdtv8RblCFdFgIQN+C9Wf
         oVW1Yhznw2m8HelGPrE7+Ev+1oAhxv1aE4Ze2hVSHrkaSYxLU9Cfh8vVO9TKwrLdCL
         xm33cVayDKbzTg3NeZSpCgTP9Yv0b40LiijUkFqw=
Date:   Tue, 06 Jul 2021 12:15:22 -0700
From:   akpm@linux-foundation.org
To:     arnd@arndb.de, corbet@lwn.net, david@redhat.com,
        geert@linux-m68k.org, ink@jurassic.park.msu.ru, mattst88@gmail.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, rth@twiddle.net,
        vgupta@synopsys.com
Subject:  [merged] alpha-remove-discontigmem-and-numa.patch removed
 from -mm tree
Message-ID: <20210706191522.VkZ0o0LHF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: alpha: remove DISCONTIGMEM and NUMA
has been removed from the -mm tree.  Its filename was
     alpha-remove-discontigmem-and-numa.patch

This patch was dropped because it was merged into mainline or a subsystem t=
ree

------------------------------------------------------
=46rom: Mike Rapoport <rppt@linux.ibm.com>
Subject: alpha: remove DISCONTIGMEM and NUMA

Patch series "Remove DISCONTIGMEM memory model", v3.

SPARSEMEM memory model was supposed to entirely replace DISCONTIGMEM a
(long) while ago.  The last architectures that used DISCONTIGMEM were
updated to use other memory models in v5.11 and it is about the time to
entirely remove DISCONTIGMEM from the kernel.

This set removes DISCONTIGMEM from alpha, arc and m68k, simplifies memory
model selection in mm/Kconfig and replaces usage of redundant
CONFIG_NEED_MULTIPLE_NODES and CONFIG_FLAT_NODE_MEM_MAP with CONFIG_NUMA
and CONFIG_FLATMEM respectively. =20

I've also removed NUMA support on alpha that was BROKEN for more than 15
years.

There were also minor updates all over arch/ to remove mentions of
DISCONTIGMEM in comments and #ifdefs.


This patch (of 9):

NUMA is marked broken on alpha for more than 15 years and DISCONTIGMEM was
replaced with SPARSEMEM in v5.11.

Remove both NUMA and DISCONTIGMEM support from alpha.

Link: https://lkml.kernel.org/r/20210608091316.3622-1-rppt@kernel.org
Link: https://lkml.kernel.org/r/20210608091316.3622-2-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig                |   22 --
 arch/alpha/include/asm/machvec.h  |    6=20
 arch/alpha/include/asm/mmzone.h   |  100 ------------
 arch/alpha/include/asm/pgtable.h  |    4=20
 arch/alpha/include/asm/topology.h |   39 ----
 arch/alpha/kernel/core_marvel.c   |   53 ------
 arch/alpha/kernel/core_wildfire.c |   29 ---
 arch/alpha/kernel/pci_iommu.c     |   29 ---
 arch/alpha/kernel/proto.h         |    8 -
 arch/alpha/kernel/setup.c         |   16 --
 arch/alpha/kernel/sys_marvel.c    |    5=20
 arch/alpha/kernel/sys_wildfire.c  |    5=20
 arch/alpha/mm/Makefile            |    2=20
 arch/alpha/mm/init.c              |    3=20
 arch/alpha/mm/numa.c              |  223 ----------------------------
 15 files changed, 4 insertions(+), 540 deletions(-)

--- a/arch/alpha/include/asm/machvec.h~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/include/asm/machvec.h
@@ -99,12 +99,6 @@ struct alpha_machine_vector
=20
 	const char *vector_name;
=20
-	/* NUMA information */
-	int (*pa_to_nid)(unsigned long);
-	int (*cpuid_to_nid)(int);
-	unsigned long (*node_mem_start)(int);
-	unsigned long (*node_mem_size)(int);
-
 	/* System specific parameters.  */
 	union {
 	    struct {
--- a/arch/alpha/include/asm/mmzone.h
+++ /dev/null
@@ -1,100 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Written by Kanoj Sarcar (kanoj@sgi.com) Aug 99
- * Adapted for the alpha wildfire architecture Jan 2001.
- */
-#ifndef _ASM_MMZONE_H_
-#define _ASM_MMZONE_H_
-
-#ifdef CONFIG_DISCONTIGMEM
-
-#include <asm/smp.h>
-
-/*
- * Following are macros that are specific to this numa platform.
- */
-
-extern pg_data_t node_data[];
-
-#define alpha_pa_to_nid(pa)		\
-        (alpha_mv.pa_to_nid 		\
-	 ? alpha_mv.pa_to_nid(pa)	\
-	 : (0))
-#define node_mem_start(nid)		\
-        (alpha_mv.node_mem_start 	\
-	 ? alpha_mv.node_mem_start(nid) \
-	 : (0UL))
-#define node_mem_size(nid)		\
-        (alpha_mv.node_mem_size 	\
-	 ? alpha_mv.node_mem_size(nid) 	\
-	 : ((nid) ? (0UL) : (~0UL)))
-
-#define pa_to_nid(pa)		alpha_pa_to_nid(pa)
-#define NODE_DATA(nid)		(&node_data[(nid)])
-
-#define node_localnr(pfn, nid)	((pfn) - NODE_DATA(nid)->node_start_pfn)
-
-#if 1
-#define PLAT_NODE_DATA_LOCALNR(p, n)	\
-	(((p) >> PAGE_SHIFT) - PLAT_NODE_DATA(n)->gendata.node_start_pfn)
-#else
-static inline unsigned long
-PLAT_NODE_DATA_LOCALNR(unsigned long p, int n)
-{
-	unsigned long temp;
-	temp =3D p >> PAGE_SHIFT;
-	return temp - PLAT_NODE_DATA(n)->gendata.node_start_pfn;
-}
-#endif
-
-/*
- * Following are macros that each numa implementation must define.
- */
-
-/*
- * Given a kernel address, find the home node of the underlying memory.
- */
-#define kvaddr_to_nid(kaddr)	pa_to_nid(__pa(kaddr))
-
-/*
- * Given a kaddr, LOCAL_BASE_ADDR finds the owning node of the memory
- * and returns the kaddr corresponding to first physical page in the
- * node's mem_map.
- */
-#define LOCAL_BASE_ADDR(kaddr)						  \
-    ((unsigned long)__va(NODE_DATA(kvaddr_to_nid(kaddr))->node_start_pfn  \
-			 << PAGE_SHIFT))
-
-/* XXX: FIXME -- nyc */
-#define kern_addr_valid(kaddr)	(0)
-
-#define mk_pte(page, pgprot)						     \
-({								 	     \
-	pte_t pte;                                                           \
-	unsigned long pfn;                                                   \
-									     \
-	pfn =3D page_to_pfn(page) << 32; \
-	pte_val(pte) =3D pfn | pgprot_val(pgprot);			     \
-									     \
-	pte;								     \
-})
-
-#define pte_page(x)							\
-({									\
-       	unsigned long kvirt;						\
-	struct page * __xx;						\
-									\
-	kvirt =3D (unsigned long)__va(pte_val(x) >> (32-PAGE_SHIFT));	\
-	__xx =3D virt_to_page(kvirt);					\
-									\
-	__xx;                                                           \
-})
-
-#define pfn_to_nid(pfn)		pa_to_nid(((u64)(pfn) << PAGE_SHIFT))
-#define pfn_valid(pfn)							\
-	(((pfn) - node_start_pfn(pfn_to_nid(pfn))) <			\
-	 node_spanned_pages(pfn_to_nid(pfn)))					\
-
-#endif /* CONFIG_DISCONTIGMEM */
-
-#endif /* _ASM_MMZONE_H_ */
--- a/arch/alpha/include/asm/pgtable.h~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/include/asm/pgtable.h
@@ -206,7 +206,6 @@ extern unsigned long __zero_page(void);
 #define page_to_pa(page)	(page_to_pfn(page) << PAGE_SHIFT)
 #define pte_pfn(pte)	(pte_val(pte) >> 32)
=20
-#ifndef CONFIG_DISCONTIGMEM
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 #define mk_pte(page, pgprot)						\
 ({									\
@@ -215,7 +214,6 @@ extern unsigned long __zero_page(void);
 	pte_val(pte) =3D (page_to_pfn(page) << 32) | pgprot_val(pgprot);	\
 	pte;								\
 })
-#endif
=20
 extern inline pte_t pfn_pte(unsigned long physpfn, pgprot_t pgprot)
 { pte_t pte; pte_val(pte) =3D (PHYS_TWIDDLE(physpfn) << 32) | pgprot_val(p=
gprot); return pte; }
@@ -330,9 +328,7 @@ extern inline pte_t mk_swap_pte(unsigned
 #define __pte_to_swp_entry(pte)	((swp_entry_t) { pte_val(pte) })
 #define __swp_entry_to_pte(x)	((pte_t) { (x).val })
=20
-#ifndef CONFIG_DISCONTIGMEM
 #define kern_addr_valid(addr)	(1)
-#endif
=20
 #define pte_ERROR(e) \
 	printk("%s:%d: bad pte %016lx.\n", __FILE__, __LINE__, pte_val(e))
--- a/arch/alpha/include/asm/topology.h~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/include/asm/topology.h
@@ -7,45 +7,6 @@
 #include <linux/numa.h>
 #include <asm/machvec.h>
=20
-#ifdef CONFIG_NUMA
-static inline int cpu_to_node(int cpu)
-{
-	int node;
-=09
-	if (!alpha_mv.cpuid_to_nid)
-		return 0;
-
-	node =3D alpha_mv.cpuid_to_nid(cpu);
-
-#ifdef DEBUG_NUMA
-	BUG_ON(node < 0);
-#endif
-
-	return node;
-}
-
-extern struct cpumask node_to_cpumask_map[];
-/* FIXME: This is dumb, recalculating every time.  But simple. */
-static const struct cpumask *cpumask_of_node(int node)
-{
-	int cpu;
-
-	if (node =3D=3D NUMA_NO_NODE)
-		return cpu_all_mask;
-
-	cpumask_clear(&node_to_cpumask_map[node]);
-
-	for_each_online_cpu(cpu) {
-		if (cpu_to_node(cpu) =3D=3D node)
-			cpumask_set_cpu(cpu, node_to_cpumask_map[node]);
-	}
-
-	return &node_to_cpumask_map[node];
-}
-
-#define cpumask_of_pcibus(bus)	(cpu_online_mask)
-
-#endif /* !CONFIG_NUMA */
 # include <asm-generic/topology.h>
=20
 #endif /* _ASM_ALPHA_TOPOLOGY_H */
--- a/arch/alpha/Kconfig~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/Kconfig
@@ -549,29 +549,12 @@ config NR_CPUS
 	  MARVEL support can handle a maximum of 32 CPUs, all the others
 	  with working support have a maximum of 4 CPUs.
=20
-config ARCH_DISCONTIGMEM_ENABLE
-	bool "Discontiguous Memory Support"
-	depends on BROKEN
-	help
-	  Say Y to support efficient handling of discontiguous physical memory,
-	  for architectures which are either NUMA (Non-Uniform Memory Access)
-	  or have huge holes in the physical address space for other reasons.
-	  See <file:Documentation/vm/numa.rst> for more.
-
 config ARCH_SPARSEMEM_ENABLE
 	bool "Sparse Memory Support"
 	help
 	  Say Y to support efficient handling of discontiguous physical memory,
 	  for systems that have huge holes in the physical address space.
=20
-config NUMA
-	bool "NUMA Support (EXPERIMENTAL)"
-	depends on DISCONTIGMEM && BROKEN
-	help
-	  Say Y to compile the kernel to support NUMA (Non-Uniform Memory
-	  Access).  This option is for configuring high-end multiprocessor
-	  server machines.  If in doubt, say N.
-
 config ALPHA_WTINT
 	bool "Use WTINT" if ALPHA_SRM || ALPHA_GENERIC
 	default y if ALPHA_QEMU
@@ -596,11 +579,6 @@ config ALPHA_WTINT
=20
 	  If unsure, say N.
=20
-config NODES_SHIFT
-	int
-	default "7"
-	depends on NEED_MULTIPLE_NODES
-
 # LARGE_VMALLOC is racy, if you *really* need it then fix it first
 config ALPHA_LARGE_VMALLOC
 	bool
--- a/arch/alpha/kernel/core_marvel.c~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/kernel/core_marvel.c
@@ -287,8 +287,7 @@ io7_init_hose(struct io7 *io7, int port)
 	/*
 	 * Set up window 0 for scatter-gather 8MB at 8MB.
 	 */
-	hose->sg_isa =3D iommu_arena_new_node(marvel_cpuid_to_nid(io7->pe),
-					    hose, 0x00800000, 0x00800000, 0);
+	hose->sg_isa =3D iommu_arena_new_node(0, hose, 0x00800000, 0x00800000, 0);
 	hose->sg_isa->align_entry =3D 8;	/* cache line boundary */
 	csrs->POx_WBASE[0].csr =3D=20
 		hose->sg_isa->dma_base | wbase_m_ena | wbase_m_sg;
@@ -305,8 +304,7 @@ io7_init_hose(struct io7 *io7, int port)
 	/*
 	 * Set up window 2 for scatter-gather (up-to) 1GB at 3GB.
 	 */
-	hose->sg_pci =3D iommu_arena_new_node(marvel_cpuid_to_nid(io7->pe),
-					    hose, 0xc0000000, 0x40000000, 0);
+	hose->sg_pci =3D iommu_arena_new_node(0, hose, 0xc0000000, 0x40000000, 0);
 	hose->sg_pci->align_entry =3D 8;	/* cache line boundary */
 	csrs->POx_WBASE[2].csr =3D=20
 		hose->sg_pci->dma_base | wbase_m_ena | wbase_m_sg;
@@ -843,53 +841,8 @@ EXPORT_SYMBOL(marvel_ioportmap);
 EXPORT_SYMBOL(marvel_ioread8);
 EXPORT_SYMBOL(marvel_iowrite8);
 #endif
-=0C
-/*
- * NUMA Support
- */
-/**********
- * FIXME - for now each cpu is a node by itself=20
- *              -- no real support for striped mode=20
- **********
- */
-int
-marvel_pa_to_nid(unsigned long pa)
-{
-	int cpuid;
=20
-	if ((pa >> 43) & 1) 	/* I/O */=20
-		cpuid =3D (~(pa >> 35) & 0xff);
-	else			/* mem */
-		cpuid =3D ((pa >> 34) & 0x3) | ((pa >> (37 - 2)) & (0x1f << 2));
-
-	return marvel_cpuid_to_nid(cpuid);
-}
-
-int
-marvel_cpuid_to_nid(int cpuid)
-{
-	return cpuid;
-}
-
-unsigned long
-marvel_node_mem_start(int nid)
-{
-	unsigned long pa;
-
-	pa =3D (nid & 0x3) | ((nid & (0x1f << 2)) << 1);
-	pa <<=3D 34;
-
-	return pa;
-}
-
-unsigned long
-marvel_node_mem_size(int nid)
-{
-	return 16UL * 1024 * 1024 * 1024; /* 16GB */
-}
-
-=0C
-/*=20
+/*
  * AGP GART Support.
  */
 #include <linux/agp_backend.h>
--- a/arch/alpha/kernel/core_wildfire.c~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/kernel/core_wildfire.c
@@ -434,39 +434,12 @@ wildfire_write_config(struct pci_bus *bu
 	return PCIBIOS_SUCCESSFUL;
 }
=20
-struct pci_ops wildfire_pci_ops =3D=20
+struct pci_ops wildfire_pci_ops =3D
 {
 	.read =3D		wildfire_read_config,
 	.write =3D	wildfire_write_config,
 };
=20
-=0C
-/*
- * NUMA Support
- */
-int wildfire_pa_to_nid(unsigned long pa)
-{
-	return pa >> 36;
-}
-
-int wildfire_cpuid_to_nid(int cpuid)
-{
-	/* assume 4 CPUs per node */
-	return cpuid >> 2;
-}
-
-unsigned long wildfire_node_mem_start(int nid)
-{
-	/* 64GB per node */
-	return (unsigned long)nid * (64UL * 1024 * 1024 * 1024);
-}
-
-unsigned long wildfire_node_mem_size(int nid)
-{
-	/* 64GB per node */
-	return 64UL * 1024 * 1024 * 1024;
-}
-
 #if DEBUG_DUMP_REGS
=20
 static void __init
--- a/arch/alpha/kernel/pci_iommu.c~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -71,33 +71,6 @@ iommu_arena_new_node(int nid, struct pci
 	if (align < mem_size)
 		align =3D mem_size;
=20
-
-#ifdef CONFIG_DISCONTIGMEM
-
-	arena =3D memblock_alloc_node(sizeof(*arena), align, nid);
-	if (!NODE_DATA(nid) || !arena) {
-		printk("%s: couldn't allocate arena from node %d\n"
-		       "    falling back to system-wide allocation\n",
-		       __func__, nid);
-		arena =3D memblock_alloc(sizeof(*arena), SMP_CACHE_BYTES);
-		if (!arena)
-			panic("%s: Failed to allocate %zu bytes\n", __func__,
-			      sizeof(*arena));
-	}
-
-	arena->ptes =3D memblock_alloc_node(sizeof(*arena), align, nid);
-	if (!NODE_DATA(nid) || !arena->ptes) {
-		printk("%s: couldn't allocate arena ptes from node %d\n"
-		       "    falling back to system-wide allocation\n",
-		       __func__, nid);
-		arena->ptes =3D memblock_alloc(mem_size, align);
-		if (!arena->ptes)
-			panic("%s: Failed to allocate %lu bytes align=3D0x%lx\n",
-			      __func__, mem_size, align);
-	}
-
-#else /* CONFIG_DISCONTIGMEM */
-
 	arena =3D memblock_alloc(sizeof(*arena), SMP_CACHE_BYTES);
 	if (!arena)
 		panic("%s: Failed to allocate %zu bytes\n", __func__,
@@ -107,8 +80,6 @@ iommu_arena_new_node(int nid, struct pci
 		panic("%s: Failed to allocate %lu bytes align=3D0x%lx\n",
 		      __func__, mem_size, align);
=20
-#endif /* CONFIG_DISCONTIGMEM */
-
 	spin_lock_init(&arena->lock);
 	arena->hose =3D hose;
 	arena->dma_base =3D base;
--- a/arch/alpha/kernel/proto.h~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/kernel/proto.h
@@ -49,10 +49,6 @@ extern void marvel_init_arch(void);
 extern void marvel_kill_arch(int);
 extern void marvel_machine_check(unsigned long, unsigned long);
 extern void marvel_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t=
);
-extern int marvel_pa_to_nid(unsigned long);
-extern int marvel_cpuid_to_nid(int);
-extern unsigned long marvel_node_mem_start(int);
-extern unsigned long marvel_node_mem_size(int);
 extern struct _alpha_agp_info *marvel_agp_info(void);
 struct io7 *marvel_find_io7(int pe);
 struct io7 *marvel_next_io7(struct io7 *prev);
@@ -101,10 +97,6 @@ extern void wildfire_init_arch(void);
 extern void wildfire_kill_arch(int);
 extern void wildfire_machine_check(unsigned long vector, unsigned long la_=
ptr);
 extern void wildfire_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr=
_t);
-extern int wildfire_pa_to_nid(unsigned long);
-extern int wildfire_cpuid_to_nid(int);
-extern unsigned long wildfire_node_mem_start(int);
-extern unsigned long wildfire_node_mem_size(int);
=20
 /* console.c */
 #ifdef CONFIG_VGA_HOSE
--- a/arch/alpha/kernel/setup.c~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/kernel/setup.c
@@ -79,11 +79,6 @@ int alpha_l3_cacheshape;
 unsigned long alpha_verbose_mcheck =3D CONFIG_VERBOSE_MCHECK_ON;
 #endif
=20
-#ifdef CONFIG_NUMA
-struct cpumask node_to_cpumask_map[MAX_NUMNODES] __read_mostly;
-EXPORT_SYMBOL(node_to_cpumask_map);
-#endif
-
 /* Which processor we booted from.  */
 int boot_cpuid;
=20
@@ -305,7 +300,6 @@ move_initrd(unsigned long mem_limit)
 }
 #endif
=20
-#ifndef CONFIG_DISCONTIGMEM
 static void __init
 setup_memory(void *kernel_end)
 {
@@ -389,9 +383,6 @@ setup_memory(void *kernel_end)
 	}
 #endif /* CONFIG_BLK_DEV_INITRD */
 }
-#else
-extern void setup_memory(void *);
-#endif /* !CONFIG_DISCONTIGMEM */
=20
 int __init
 page_is_ram(unsigned long pfn)
@@ -618,13 +609,6 @@ setup_arch(char **cmdline_p)
 	       "VERBOSE_MCHECK "
 #endif
=20
-#ifdef CONFIG_DISCONTIGMEM
-	       "DISCONTIGMEM "
-#ifdef CONFIG_NUMA
-	       "NUMA "
-#endif
-#endif
-
 #ifdef CONFIG_DEBUG_SPINLOCK
 	       "DEBUG_SPINLOCK "
 #endif
--- a/arch/alpha/kernel/sys_marvel.c~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/kernel/sys_marvel.c
@@ -461,10 +461,5 @@ struct alpha_machine_vector marvel_ev7_m
 	.kill_arch		=3D marvel_kill_arch,
 	.pci_map_irq		=3D marvel_map_irq,
 	.pci_swizzle		=3D common_swizzle,
-
-	.pa_to_nid		=3D marvel_pa_to_nid,
-	.cpuid_to_nid		=3D marvel_cpuid_to_nid,
-	.node_mem_start		=3D marvel_node_mem_start,
-	.node_mem_size		=3D marvel_node_mem_size,
 };
 ALIAS_MV(marvel_ev7)
--- a/arch/alpha/kernel/sys_wildfire.c~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/kernel/sys_wildfire.c
@@ -337,10 +337,5 @@ struct alpha_machine_vector wildfire_mv
 	.kill_arch		=3D wildfire_kill_arch,
 	.pci_map_irq		=3D wildfire_map_irq,
 	.pci_swizzle		=3D common_swizzle,
-
-	.pa_to_nid		=3D wildfire_pa_to_nid,
-	.cpuid_to_nid		=3D wildfire_cpuid_to_nid,
-	.node_mem_start		=3D wildfire_node_mem_start,
-	.node_mem_size		=3D wildfire_node_mem_size,
 };
 ALIAS_MV(wildfire)
--- a/arch/alpha/mm/init.c~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/mm/init.c
@@ -235,8 +235,6 @@ callback_init(void * kernel_end)
 	return kernel_end;
 }
=20
-
-#ifndef CONFIG_DISCONTIGMEM
 /*
  * paging_init() sets up the memory map.
  */
@@ -257,7 +255,6 @@ void __init paging_init(void)
 	/* Initialize the kernel's ZERO_PGE. */
 	memset((void *)ZERO_PGE, 0, PAGE_SIZE);
 }
-#endif /* CONFIG_DISCONTIGMEM */
=20
 #if defined(CONFIG_ALPHA_GENERIC) || defined(CONFIG_ALPHA_SRM)
 void
--- a/arch/alpha/mm/Makefile~alpha-remove-discontigmem-and-numa
+++ a/arch/alpha/mm/Makefile
@@ -6,5 +6,3 @@
 ccflags-y :=3D -Werror
=20
 obj-y	:=3D init.o fault.o
-
-obj-$(CONFIG_DISCONTIGMEM) +=3D numa.o
--- a/arch/alpha/mm/numa.c
+++ /dev/null
@@ -1,223 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-/*
- *  linux/arch/alpha/mm/numa.c
- *
- *  DISCONTIGMEM NUMA alpha support.
- *
- *  Copyright (C) 2001 Andrea Arcangeli <andrea@suse.de> SuSE
- */
-
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/mm.h>
-#include <linux/memblock.h>
-#include <linux/swap.h>
-#include <linux/initrd.h>
-#include <linux/pfn.h>
-#include <linux/module.h>
-
-#include <asm/hwrpb.h>
-#include <asm/sections.h>
-
-pg_data_t node_data[MAX_NUMNODES];
-EXPORT_SYMBOL(node_data);
-
-#undef DEBUG_DISCONTIG
-#ifdef DEBUG_DISCONTIG
-#define DBGDCONT(args...) printk(args)
-#else
-#define DBGDCONT(args...)
-#endif
-
-#define for_each_mem_cluster(memdesc, _cluster, i)		\
-	for ((_cluster) =3D (memdesc)->cluster, (i) =3D 0;		\
-	     (i) < (memdesc)->numclusters; (i)++, (_cluster)++)
-
-static void __init show_mem_layout(void)
-{
-	struct memclust_struct * cluster;
-	struct memdesc_struct * memdesc;
-	int i;
-
-	/* Find free clusters, and init and free the bootmem accordingly.  */
-	memdesc =3D (struct memdesc_struct *)
-	  (hwrpb->mddt_offset + (unsigned long) hwrpb);
-
-	printk("Raw memory layout:\n");
-	for_each_mem_cluster(memdesc, cluster, i) {
-		printk(" memcluster %2d, usage %1lx, start %8lu, end %8lu\n",
-		       i, cluster->usage, cluster->start_pfn,
-		       cluster->start_pfn + cluster->numpages);
-	}
-}
-
-static void __init
-setup_memory_node(int nid, void *kernel_end)
-{
-	extern unsigned long mem_size_limit;
-	struct memclust_struct * cluster;
-	struct memdesc_struct * memdesc;
-	unsigned long start_kernel_pfn, end_kernel_pfn;
-	unsigned long start, end;
-	unsigned long node_pfn_start, node_pfn_end;
-	unsigned long node_min_pfn, node_max_pfn;
-	int i;
-	int show_init =3D 0;
-
-	/* Find the bounds of current node */
-	node_pfn_start =3D (node_mem_start(nid)) >> PAGE_SHIFT;
-	node_pfn_end =3D node_pfn_start + (node_mem_size(nid) >> PAGE_SHIFT);
-=09
-	/* Find free clusters, and init and free the bootmem accordingly.  */
-	memdesc =3D (struct memdesc_struct *)
-	  (hwrpb->mddt_offset + (unsigned long) hwrpb);
-
-	/* find the bounds of this node (node_min_pfn/node_max_pfn) */
-	node_min_pfn =3D ~0UL;
-	node_max_pfn =3D 0UL;
-	for_each_mem_cluster(memdesc, cluster, i) {
-		/* Bit 0 is console/PALcode reserved.  Bit 1 is
-		   non-volatile memory -- we might want to mark
-		   this for later.  */
-		if (cluster->usage & 3)
-			continue;
-
-		start =3D cluster->start_pfn;
-		end =3D start + cluster->numpages;
-
-		if (start >=3D node_pfn_end || end <=3D node_pfn_start)
-			continue;
-
-		if (!show_init) {
-			show_init =3D 1;
-			printk("Initializing bootmem allocator on Node ID %d\n", nid);
-		}
-		printk(" memcluster %2d, usage %1lx, start %8lu, end %8lu\n",
-		       i, cluster->usage, cluster->start_pfn,
-		       cluster->start_pfn + cluster->numpages);
-
-		if (start < node_pfn_start)
-			start =3D node_pfn_start;
-		if (end > node_pfn_end)
-			end =3D node_pfn_end;
-
-		if (start < node_min_pfn)
-			node_min_pfn =3D start;
-		if (end > node_max_pfn)
-			node_max_pfn =3D end;
-	}
-
-	if (mem_size_limit && node_max_pfn > mem_size_limit) {
-		static int msg_shown =3D 0;
-		if (!msg_shown) {
-			msg_shown =3D 1;
-			printk("setup: forcing memory size to %ldK (from %ldK).\n",
-			       mem_size_limit << (PAGE_SHIFT - 10),
-			       node_max_pfn    << (PAGE_SHIFT - 10));
-		}
-		node_max_pfn =3D mem_size_limit;
-	}
-
-	if (node_min_pfn >=3D node_max_pfn)
-		return;
-
-	/* Update global {min,max}_low_pfn from node information. */
-	if (node_min_pfn < min_low_pfn)
-		min_low_pfn =3D node_min_pfn;
-	if (node_max_pfn > max_low_pfn)
-		max_pfn =3D max_low_pfn =3D node_max_pfn;
-
-#if 0 /* we'll try this one again in a little while */
-	/* Cute trick to make sure our local node data is on local memory */
-	node_data[nid] =3D (pg_data_t *)(__va(node_min_pfn << PAGE_SHIFT));
-#endif
-	printk(" Detected node memory:   start %8lu, end %8lu\n",
-	       node_min_pfn, node_max_pfn);
-
-	DBGDCONT(" DISCONTIG: node_data[%d]   is at 0x%p\n", nid, NODE_DATA(nid));
-
-	/* Find the bounds of kernel memory.  */
-	start_kernel_pfn =3D PFN_DOWN(KERNEL_START_PHYS);
-	end_kernel_pfn =3D PFN_UP(virt_to_phys(kernel_end));
-
-	if (!nid && (node_max_pfn < end_kernel_pfn || node_min_pfn > start_kernel=
_pfn))
-		panic("kernel loaded out of ram");
-
-	memblock_add_node(PFN_PHYS(node_min_pfn),
-			  (node_max_pfn - node_min_pfn) << PAGE_SHIFT, nid);
-
-	/* Zone start phys-addr must be 2^(MAX_ORDER-1) aligned.
-	   Note that we round this down, not up - node memory
-	   has much larger alignment than 8Mb, so it's safe. */
-	node_min_pfn &=3D ~((1UL << (MAX_ORDER-1))-1);
-
-	NODE_DATA(nid)->node_start_pfn =3D node_min_pfn;
-	NODE_DATA(nid)->node_present_pages =3D node_max_pfn - node_min_pfn;
-
-	node_set_online(nid);
-}
-
-void __init
-setup_memory(void *kernel_end)
-{
-	unsigned long kernel_size;
-	int nid;
-
-	show_mem_layout();
-
-	nodes_clear(node_online_map);
-
-	min_low_pfn =3D ~0UL;
-	max_low_pfn =3D 0UL;
-	for (nid =3D 0; nid < MAX_NUMNODES; nid++)
-		setup_memory_node(nid, kernel_end);
-
-	kernel_size =3D virt_to_phys(kernel_end) - KERNEL_START_PHYS;
-	memblock_reserve(KERNEL_START_PHYS, kernel_size);
-
-#ifdef CONFIG_BLK_DEV_INITRD
-	initrd_start =3D INITRD_START;
-	if (initrd_start) {
-		extern void *move_initrd(unsigned long);
-
-		initrd_end =3D initrd_start+INITRD_SIZE;
-		printk("Initial ramdisk at: 0x%p (%lu bytes)\n",
-		       (void *) initrd_start, INITRD_SIZE);
-
-		if ((void *)initrd_end > phys_to_virt(PFN_PHYS(max_low_pfn))) {
-			if (!move_initrd(PFN_PHYS(max_low_pfn)))
-				printk("initrd extends beyond end of memory "
-				       "(0x%08lx > 0x%p)\ndisabling initrd\n",
-				       initrd_end,
-				       phys_to_virt(PFN_PHYS(max_low_pfn)));
-		} else {
-			nid =3D kvaddr_to_nid(initrd_start);
-			memblock_reserve(virt_to_phys((void *)initrd_start),
-					 INITRD_SIZE);
-		}
-	}
-#endif /* CONFIG_BLK_DEV_INITRD */
-}
-
-void __init paging_init(void)
-{
-	unsigned long   max_zone_pfn[MAX_NR_ZONES] =3D {0, };
-	unsigned long	dma_local_pfn;
-
-	/*
-	 * The old global MAX_DMA_ADDRESS per-arch API doesn't fit
-	 * in the NUMA model, for now we convert it to a pfn and
-	 * we interpret this pfn as a local per-node information.
-	 * This issue isn't very important since none of these machines
-	 * have legacy ISA slots anyways.
-	 */
-	dma_local_pfn =3D virt_to_phys((char *)MAX_DMA_ADDRESS) >> PAGE_SHIFT;
-
-	max_zone_pfn[ZONE_DMA] =3D dma_local_pfn;
-	max_zone_pfn[ZONE_NORMAL] =3D max_pfn;
-
-	free_area_init(max_zone_pfn);
-
-	/* Initialize the kernel's ZERO_PGE. */
-	memset((void *)ZERO_PGE, 0, PAGE_SIZE);
-}
_

Patches currently in -mm which might be from rppt@linux.ibm.com are

mmap-make-mlock_future_check-global.patch
riscv-kconfig-make-direct-map-manipulation-options-depend-on-mmu.patch
set_memory-allow-querying-whether-set_direct_map_-is-actually-enabled.patch
mm-introduce-memfd_secret-system-call-to-create-secret-memory-areas.patch
pm-hibernate-disable-when-there-are-active-secretmem-users.patch
arch-mm-wire-up-memfd_secret-system-call-where-relevant.patch
secretmem-test-add-basic-selftest-for-memfd_secret2.patch

