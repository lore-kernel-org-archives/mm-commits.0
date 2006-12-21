From: akpm@osdl.org
Subject: - virtual-memmap-on-sparsemem-v3-ia64-support.patch removed from -mm tree
Date: Wed, 20 Dec 2006 23:26:25 -0800
Message-ID: <200612210726.kBL7QPxd018734@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:45864 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422818AbWLUHjl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Dec 2006 02:39:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, apw@shadowen.org, clameter@engr.sgi.com, haveblue@us.ibm.com, mbligh@google.com, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     virtual memmap on sparsemem: ia64 support
has been removed from the -mm tree.  Its filename was
     virtual-memmap-on-sparsemem-v3-ia64-support.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: virtual memmap on sparsemem: ia64 support
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

ia64 support for sparsemem/vmem_map.
* defines mem_map[] and set its value (by static way).
* changes definitions of VMALLOC_START.
* adds CONFIGS.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/Kconfig              |    8 ++++++++
 arch/ia64/kernel/vmlinux.lds.S |    4 ++++
 include/asm-ia64/pgtable.h     |   16 ++++++++++++----
 include/asm-ia64/sparsemem.h   |    9 +++++++++
 4 files changed, 33 insertions(+), 4 deletions(-)

diff -puN arch/ia64/Kconfig~virtual-memmap-on-sparsemem-v3-ia64-support arch/ia64/Kconfig
--- a/arch/ia64/Kconfig~virtual-memmap-on-sparsemem-v3-ia64-support
+++ a/arch/ia64/Kconfig
@@ -341,6 +341,14 @@ config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on ARCH_DISCONTIGMEM_ENABLE
 
+config ARCH_SPARSEMEM_VMEMMAP
+	def_bool y
+	depends on ARCH_SPARSEMEM_ENABLE
+
+config ARCH_SPARSEMEM_VMEMMAP_STATIC
+	def_bool y
+	depends on SPARSEMEM_VMEMMAP
+
 config ARCH_DISCONTIGMEM_DEFAULT
 	def_bool y if (IA64_SGI_SN2 || IA64_GENERIC || IA64_HP_ZX1 || IA64_HP_ZX1_SWIOTLB)
 	depends on ARCH_DISCONTIGMEM_ENABLE
diff -puN arch/ia64/kernel/vmlinux.lds.S~virtual-memmap-on-sparsemem-v3-ia64-support arch/ia64/kernel/vmlinux.lds.S
--- a/arch/ia64/kernel/vmlinux.lds.S~virtual-memmap-on-sparsemem-v3-ia64-support
+++ a/arch/ia64/kernel/vmlinux.lds.S
@@ -2,6 +2,7 @@
 #include <asm/cache.h>
 #include <asm/ptrace.h>
 #include <asm/system.h>
+#include <asm/sparsemem.h>
 #include <asm/pgtable.h>
 
 #define LOAD_OFFSET	(KERNEL_START - KERNEL_TR_PAGE_SIZE)
@@ -34,6 +35,9 @@ SECTIONS
 
   v = PAGE_OFFSET;	/* this symbol is here to make debugging easier... */
   phys_start = _start - LOAD_OFFSET;
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+  mem_map = VIRTUAL_MEM_MAP_START;
+#endif
 
   code : { } :code
   . = KERNEL_START;
diff -puN include/asm-ia64/pgtable.h~virtual-memmap-on-sparsemem-v3-ia64-support include/asm-ia64/pgtable.h
--- a/include/asm-ia64/pgtable.h~virtual-memmap-on-sparsemem-v3-ia64-support
+++ a/include/asm-ia64/pgtable.h
@@ -230,13 +230,21 @@ ia64_phys_addr_valid (unsigned long addr
 #define set_pte(ptep, pteval)	(*(ptep) = (pteval))
 #define set_pte_at(mm,addr,ptep,pteval) set_pte(ptep,pteval)
 
+#if defined(CONFIG_SPARSEMEM_VMEMMAP)
+#define VMALLOC_START	(VIRTUAL_MEM_MAP_END)
+#define VMALLOC_END	(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 9)))
+
+#elif defined(CONFIG_VIRTUAL_MEM_MAP)
 #define VMALLOC_START		(RGN_BASE(RGN_GATE) + 0x200000000UL)
-#ifdef CONFIG_VIRTUAL_MEM_MAP
-# define VMALLOC_END_INIT	(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 9)))
-# define VMALLOC_END		vmalloc_end
-  extern unsigned long vmalloc_end;
+
+#defineVMALLOC_END_INIT    (RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 9)))
+#define VMALLOC_END		vmalloc_end
+extern unsigned long vmalloc_end;
 #else
+
+#define VMALLOC_START		(RGN_BASE(RGN_GATE) + 0x200000000UL)
 # define VMALLOC_END		(RGN_BASE(RGN_GATE) + (1UL << (4*PAGE_SHIFT - 9)))
+
 #endif
 
 /* fs/proc/kcore.c */
diff -puN include/asm-ia64/sparsemem.h~virtual-memmap-on-sparsemem-v3-ia64-support include/asm-ia64/sparsemem.h
--- a/include/asm-ia64/sparsemem.h~virtual-memmap-on-sparsemem-v3-ia64-support
+++ a/include/asm-ia64/sparsemem.h
@@ -16,5 +16,14 @@
 #endif
 #endif
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+#define VIRTUAL_MEM_MAP_START	(RGN_BASE(RGN_GATE) + 0x200000000)
+
+#ifndef __ASSEMBLY__
+#define VIRTUAL_MEM_MAP_SIZE	((1UL << (MAX_PHYSMEM_BITS - PAGE_SHIFT)) * sizeof(struct page))
+#define VIRTUAL_MEM_MAP_END	(VIRTUAL_MEM_MAP_START + VIRTUAL_MEM_MAP_SIZE)
+#endif
+#endif
+
 #endif /* CONFIG_SPARSEMEM */
 #endif /* _ASM_IA64_SPARSEMEM_H */
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

virtual-memmap-on-sparsemem-v3-ia64-support.patch
virtual-memmap-on-sparsemem-v3-ia64-support-update.patch
mm-only-sched-add-a-few-scheduler-event-counters.patch
reiser4-hardirq-include-fix.patch

