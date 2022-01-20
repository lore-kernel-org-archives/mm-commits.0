Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3240C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:29:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347945AbiATV3T (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377902AbiATV3S (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:29:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9CFDC061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:29:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1CEEB81E6B
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E0AC340E3;
        Thu, 20 Jan 2022 21:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642714155;
        bh=w8Qi2ur8kA2sGGC1E72nWEPab1qUagSwA67TnaDbg2Y=;
        h=Date:From:To:Subject:From;
        b=r4EekxhHGRNAoTCl9Jd40usKcTvgcUYxeiRjeOUUz6og2VL+qgeM8CA9iIEbWEdsC
         0wj1yBDpEMX5hMwqb7tfYCrdXS1cwdVBhlwKI3TEFbX5cKuCzYIgjwnkc5aEamQN5W
         FTDHmkMaD9QQDbkvabs1ndmVb+fYN0qT8PJXX/t8=
Date:   Thu, 20 Jan 2022 13:29:14 -0800
From:   akpm@linux-foundation.org
To:     aou@eecs.berkeley.edu, benh@kernel.crashing.org, bp@alien8.de,
        catalin.marinas@arm.com, cl@linux.com, dave.hansen@linux.intel.com,
        davem@davemloft.net, dennis@kernel.org, gregkh@linuxfoundation.org,
        hpa@zytor.com, mingo@redhat.com, mm-commits@vger.kernel.org,
        mpe@ellerman.id.au, palmer@dabbelt.com, paul.walmsley@sifive.com,
        paulus@samba.org, rafael@kernel.org, tglx@linutronix.de,
        tj@kernel.org, tsbogend@alpha.franken.de,
        wangkefeng.wang@huawei.com, will@kernel.org
Subject:  [merged] mm-percpu-generalize-percpu-related-config.patch
 removed from -mm tree
Message-ID: <20220120212914.wXE4WL1mF%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: percpu: generalize percpu related config
has been removed from the -mm tree.  Its filename was
     mm-percpu-generalize-percpu-related-config.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: percpu: generalize percpu related config

Patch series "mm: percpu: Cleanup percpu first chunk function".


When supporting page mapping percpu first chunk allocator on arm64, we
found there are lots of duplicated codes in percpu embed/page first chunk
allocator.  This patchset is aimed to cleanup them and should no function
change.  

The currently supported status about 'embed' and 'page' in Archs shows
below,

embed: NEED_PER_CPU_PAGE_FIRST_CHUNK
page:  NEED_PER_CPU_EMBED_FIRST_CHUNK

	embed	page
------------------------
arm64	  Y	 Y
mips	  Y	 N
powerpc	  Y	 Y
riscv	  Y	 N
sparc	  Y	 Y
x86	  Y	 Y
------------------------

There are two interfaces about percpu first chunk allocator,

 extern int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
                                size_t atom_size,
                                pcpu_fc_cpu_distance_fn_t cpu_distance_fn,
-                               pcpu_fc_alloc_fn_t alloc_fn,
-                               pcpu_fc_free_fn_t free_fn);
+                               pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn);


 extern int __init pcpu_page_first_chunk(size_t reserved_size,
-                               pcpu_fc_alloc_fn_t alloc_fn,
-                               pcpu_fc_free_fn_t free_fn,
-                               pcpu_fc_populate_pte_fn_t populate_pte_fn);
+                               pcpu_fc_cpu_to_node_fn_t cpu_to_nd_fn);


The pcpu_fc_alloc_fn_t/pcpu_fc_free_fn_t is killed, we provide generic
pcpu_fc_alloc() and pcpu_fc_free() function, which are called in the
pcpu_embed/page_first_chunk().

1) For pcpu_embed_first_chunk(), pcpu_fc_cpu_to_node_fn_t is needed to be
   provided when archs supported NUMA.

2) For pcpu_page_first_chunk(), the pcpu_fc_populate_pte_fn_t is killed too,
   a generic pcpu_populate_pte() which marked '__weak' is provided, if you
   need a different function to populate pte on the arch(like x86), please
   provide its own implementation.

[1] https://github.com/kevin78/linux.git percpu-cleanup


This patch (of 4):

The HAVE_SETUP_PER_CPU_AREA/NEED_PER_CPU_EMBED_FIRST_CHUNK/
NEED_PER_CPU_PAGE_FIRST_CHUNK/USE_PERCPU_NUMA_NODE_ID configs, which have
duplicate definitions on platforms that subscribe it.

Move them into mm, drop these redundant definitions and instead just
select it on applicable platforms.

Link: https://lkml.kernel.org/r/20211216112359.103822-1-wangkefeng.wang@huawei.com
Link: https://lkml.kernel.org/r/20211216112359.103822-2-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>	[arm64]
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig   |   20 ++++----------------
 arch/ia64/Kconfig    |    9 ++-------
 arch/mips/Kconfig    |   10 ++--------
 arch/powerpc/Kconfig |   17 ++++-------------
 arch/riscv/Kconfig   |   10 ++--------
 arch/sparc/Kconfig   |   12 +++---------
 arch/x86/Kconfig     |   17 ++++-------------
 mm/Kconfig           |   12 ++++++++++++
 8 files changed, 33 insertions(+), 74 deletions(-)

--- a/arch/arm64/Kconfig~mm-percpu-generalize-percpu-related-config
+++ a/arch/arm64/Kconfig
@@ -1135,6 +1135,10 @@ config NUMA
 	select GENERIC_ARCH_NUMA
 	select ACPI_NUMA if ACPI
 	select OF_NUMA
+	select HAVE_SETUP_PER_CPU_AREA
+	select NEED_PER_CPU_EMBED_FIRST_CHUNK
+	select NEED_PER_CPU_PAGE_FIRST_CHUNK
+	select USE_PERCPU_NUMA_NODE_ID
 	help
 	  Enable NUMA (Non-Uniform Memory Access) support.
 
@@ -1151,22 +1155,6 @@ config NODES_SHIFT
 	  Specify the maximum number of NUMA Nodes available on the target
 	  system.  Increases memory reserved to accommodate various tables.
 
-config USE_PERCPU_NUMA_NODE_ID
-	def_bool y
-	depends on NUMA
-
-config HAVE_SETUP_PER_CPU_AREA
-	def_bool y
-	depends on NUMA
-
-config NEED_PER_CPU_EMBED_FIRST_CHUNK
-	def_bool y
-	depends on NUMA
-
-config NEED_PER_CPU_PAGE_FIRST_CHUNK
-	def_bool y
-	depends on NUMA
-
 source "kernel/Kconfig.hz"
 
 config ARCH_SPARSEMEM_ENABLE
--- a/arch/ia64/Kconfig~mm-percpu-generalize-percpu-related-config
+++ a/arch/ia64/Kconfig
@@ -32,6 +32,7 @@ config IA64
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_DYNAMIC_FTRACE if (!ITANIUM)
 	select HAVE_FUNCTION_TRACER
+	select HAVE_SETUP_PER_CPU_AREA
 	select TTY
 	select HAVE_ARCH_TRACEHOOK
 	select HAVE_VIRT_CPU_ACCOUNTING
@@ -88,9 +89,6 @@ config GENERIC_CALIBRATE_DELAY
 	bool
 	default y
 
-config HAVE_SETUP_PER_CPU_AREA
-	def_bool y
-
 config DMI
 	bool
 	default y
@@ -292,6 +290,7 @@ config NUMA
 	bool "NUMA support"
 	depends on !FLATMEM
 	select SMP
+	select USE_PERCPU_NUMA_NODE_ID
 	help
 	  Say Y to compile the kernel to support NUMA (Non-Uniform Memory
 	  Access).  This option is for configuring high-end multiprocessor
@@ -311,10 +310,6 @@ config HAVE_ARCH_NODEDATA_EXTENSION
 	def_bool y
 	depends on NUMA
 
-config USE_PERCPU_NUMA_NODE_ID
-	def_bool y
-	depends on NUMA
-
 config HAVE_MEMORYLESS_NODES
 	def_bool NUMA
 
--- a/arch/mips/Kconfig~mm-percpu-generalize-percpu-related-config
+++ a/arch/mips/Kconfig
@@ -2666,6 +2666,8 @@ config NUMA
 	bool "NUMA Support"
 	depends on SYS_SUPPORTS_NUMA
 	select SMP
+	select HAVE_SETUP_PER_CPU_AREA
+	select NEED_PER_CPU_EMBED_FIRST_CHUNK
 	help
 	  Say Y to compile the kernel to support NUMA (Non-Uniform Memory
 	  Access).  This option improves performance on systems with more
@@ -2676,14 +2678,6 @@ config NUMA
 config SYS_SUPPORTS_NUMA
 	bool
 
-config HAVE_SETUP_PER_CPU_AREA
-	def_bool y
-	depends on NUMA
-
-config NEED_PER_CPU_EMBED_FIRST_CHUNK
-	def_bool y
-	depends on NUMA
-
 config RELOCATABLE
 	bool "Relocatable kernel"
 	depends on SYS_SUPPORTS_RELOCATABLE
--- a/arch/powerpc/Kconfig~mm-percpu-generalize-percpu-related-config
+++ a/arch/powerpc/Kconfig
@@ -55,15 +55,6 @@ config ARCH_MMAP_RND_COMPAT_BITS_MIN
 	default 9 if PPC_16K_PAGES	#  9 = 23 (8MB) - 14 (16K)
 	default 11			# 11 = 23 (8MB) - 12 (4K)
 
-config HAVE_SETUP_PER_CPU_AREA
-	def_bool PPC64
-
-config NEED_PER_CPU_EMBED_FIRST_CHUNK
-	def_bool y if PPC64
-
-config NEED_PER_CPU_PAGE_FIRST_CHUNK
-	def_bool y if PPC64
-
 config NR_IRQS
 	int "Number of virtual interrupt numbers"
 	range 32 1048576
@@ -240,6 +231,7 @@ config PPC
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE
 	select HAVE_RSEQ
+	select HAVE_SETUP_PER_CPU_AREA		if PPC64
 	select HAVE_SOFTIRQ_ON_OWN_STACK
 	select HAVE_STACKPROTECTOR		if PPC32 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r2)
 	select HAVE_STACKPROTECTOR		if PPC64 && $(cc-option,-mstack-protector-guard=tls -mstack-protector-guard-reg=r13)
@@ -254,6 +246,8 @@ config PPC
 	select MMU_GATHER_RCU_TABLE_FREE
 	select MODULES_USE_ELF_RELA
 	select NEED_DMA_MAP_STATE		if PPC64 || NOT_COHERENT_CACHE
+	select NEED_PER_CPU_EMBED_FIRST_CHUNK	if PPC64
+	select NEED_PER_CPU_PAGE_FIRST_CHUNK	if PPC64
 	select NEED_SG_DMA_LENGTH
 	select OF
 	select OF_DMA_DEFAULT_COHERENT		if !NOT_COHERENT_CACHE
@@ -659,6 +653,7 @@ config NUMA
 	bool "NUMA Memory Allocation and Scheduler Support"
 	depends on PPC64 && SMP
 	default y if PPC_PSERIES || PPC_POWERNV
+	select USE_PERCPU_NUMA_NODE_ID
 	help
 	  Enable NUMA (Non-Uniform Memory Access) support.
 
@@ -672,10 +667,6 @@ config NODES_SHIFT
 	default "4"
 	depends on NUMA
 
-config USE_PERCPU_NUMA_NODE_ID
-	def_bool y
-	depends on NUMA
-
 config HAVE_MEMORYLESS_NODES
 	def_bool y
 	depends on NUMA
--- a/arch/riscv/Kconfig~mm-percpu-generalize-percpu-related-config
+++ a/arch/riscv/Kconfig
@@ -334,6 +334,8 @@ config NUMA
 	select GENERIC_ARCH_NUMA
 	select OF_NUMA
 	select ARCH_SUPPORTS_NUMA_BALANCING
+	select USE_PERCPU_NUMA_NODE_ID
+	select NEED_PER_CPU_EMBED_FIRST_CHUNK
 	help
 	  Enable NUMA (Non-Uniform Memory Access) support.
 
@@ -349,14 +351,6 @@ config NODES_SHIFT
 	  Specify the maximum number of NUMA Nodes available on the target
 	  system.  Increases memory reserved to accommodate various tables.
 
-config USE_PERCPU_NUMA_NODE_ID
-	def_bool y
-	depends on NUMA
-
-config NEED_PER_CPU_EMBED_FIRST_CHUNK
-	def_bool y
-	depends on NUMA
-
 config RISCV_ISA_C
 	bool "Emit compressed instructions when building Linux"
 	default y
--- a/arch/sparc/Kconfig~mm-percpu-generalize-percpu-related-config
+++ a/arch/sparc/Kconfig
@@ -97,6 +97,9 @@ config SPARC64
 	select PCI_DOMAINS if PCI
 	select ARCH_HAS_GIGANTIC_PAGE
 	select HAVE_SOFTIRQ_ON_OWN_STACK
+	select HAVE_SETUP_PER_CPU_AREA
+	select NEED_PER_CPU_EMBED_FIRST_CHUNK
+	select NEED_PER_CPU_PAGE_FIRST_CHUNK
 
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
@@ -123,15 +126,6 @@ config AUDIT_ARCH
 	bool
 	default y
 
-config HAVE_SETUP_PER_CPU_AREA
-	def_bool y if SPARC64
-
-config NEED_PER_CPU_EMBED_FIRST_CHUNK
-	def_bool y if SPARC64
-
-config NEED_PER_CPU_PAGE_FIRST_CHUNK
-	def_bool y if SPARC64
-
 config MMU
 	bool
 	default y
--- a/arch/x86/Kconfig~mm-percpu-generalize-percpu-related-config
+++ a/arch/x86/Kconfig
@@ -240,6 +240,7 @@ config X86
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RELIABLE_STACKTRACE		if X86_64 && (UNWINDER_FRAME_POINTER || UNWINDER_ORC) && STACK_VALIDATION
 	select HAVE_FUNCTION_ARG_ACCESS_API
+	select HAVE_SETUP_PER_CPU_AREA
 	select HAVE_SOFTIRQ_ON_OWN_STACK
 	select HAVE_STACKPROTECTOR		if CC_HAS_SANE_STACKPROTECTOR
 	select HAVE_STACK_VALIDATION		if X86_64
@@ -253,6 +254,8 @@ config X86
 	select HAVE_GENERIC_VDSO
 	select HOTPLUG_SMT			if SMP
 	select IRQ_FORCED_THREADING
+	select NEED_PER_CPU_EMBED_FIRST_CHUNK
+	select NEED_PER_CPU_PAGE_FIRST_CHUNK
 	select NEED_SG_DMA_LENGTH
 	select PCI_DOMAINS			if PCI
 	select PCI_LOCKLESS_CONFIG		if PCI
@@ -332,15 +335,6 @@ config ARCH_HAS_CPU_RELAX
 config ARCH_HAS_FILTER_PGPROT
 	def_bool y
 
-config HAVE_SETUP_PER_CPU_AREA
-	def_bool y
-
-config NEED_PER_CPU_EMBED_FIRST_CHUNK
-	def_bool y
-
-config NEED_PER_CPU_PAGE_FIRST_CHUNK
-	def_bool y
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 
@@ -1558,6 +1552,7 @@ config NUMA
 	depends on SMP
 	depends on X86_64 || (X86_32 && HIGHMEM64G && X86_BIGSMP)
 	default y if X86_BIGSMP
+	select USE_PERCPU_NUMA_NODE_ID
 	help
 	  Enable NUMA (Non-Uniform Memory Access) support.
 
@@ -2432,10 +2427,6 @@ config ARCH_HAS_ADD_PAGES
 config ARCH_MHP_MEMMAP_ON_MEMORY_ENABLE
 	def_bool y
 
-config USE_PERCPU_NUMA_NODE_ID
-	def_bool y
-	depends on NUMA
-
 menu "Power management and ACPI options"
 
 config ARCH_HIBERNATION_HEADER
--- a/mm/Kconfig~mm-percpu-generalize-percpu-related-config
+++ a/mm/Kconfig
@@ -432,6 +432,18 @@ config NEED_PER_CPU_KM
 	bool
 	default y
 
+config NEED_PER_CPU_EMBED_FIRST_CHUNK
+	bool
+
+config NEED_PER_CPU_PAGE_FIRST_CHUNK
+	bool
+
+config USE_PERCPU_NUMA_NODE_ID
+	bool
+
+config HAVE_SETUP_PER_CPU_AREA
+	bool
+
 config CLEANCACHE
 	bool "Enable cleancache driver to cache clean pages if tmem is present"
 	help
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are


