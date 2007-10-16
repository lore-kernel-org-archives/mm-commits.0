From: akpm@linux-foundation.org
Subject: - sparc64-sparsemem_vmemmap-support.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:30:33 -0700
Message-ID: <200710162030.l9GKUX29014417@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37743 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966213AbXJPVs5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:48:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davem@davemloft.net, apw@shadowen.org, clameter@sgi.com, kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     SPARC64: SPARSEMEM_VMEMMAP support
has been removed from the -mm tree.  Its filename was
     sparc64-sparsemem_vmemmap-support.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SPARC64: SPARSEMEM_VMEMMAP support
From: David Miller <davem@davemloft.net>

[apw@shadowen.org: style fixups]
[apw@shadowen.org: vmemmap sparc64: convert to new config options]
Signed-off-by: Andy Whitcroft <apw@shadowen.org>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc64/Kconfig          |    2 -
 arch/sparc64/kernel/ktlb.S    |   16 +++++++++
 arch/sparc64/mm/init.c        |   52 ++++++++++++++++++++++++++++++++
 include/asm-sparc64/pgtable.h |    3 +
 4 files changed, 72 insertions(+), 1 deletion(-)

diff -puN arch/sparc64/Kconfig~sparc64-sparsemem_vmemmap-support arch/sparc64/Kconfig
--- a/arch/sparc64/Kconfig~sparc64-sparsemem_vmemmap-support
+++ a/arch/sparc64/Kconfig
@@ -240,10 +240,10 @@ config ARCH_SELECT_MEMORY_MODEL
 
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
+	select SPARSEMEM_VMEMMAP_ENABLE
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
-	select SPARSEMEM_STATIC
 
 source "mm/Kconfig"
 
diff -puN arch/sparc64/kernel/ktlb.S~sparc64-sparsemem_vmemmap-support arch/sparc64/kernel/ktlb.S
--- a/arch/sparc64/kernel/ktlb.S~sparc64-sparsemem_vmemmap-support
+++ a/arch/sparc64/kernel/ktlb.S
@@ -226,6 +226,15 @@ kvmap_dtlb_load:
 	ba,pt		%xcc, sun4v_dtlb_load
 	 mov		%g5, %g3
 
+kvmap_vmemmap:
+	sub		%g4, %g5, %g5
+	srlx		%g5, 22, %g5
+	sethi		%hi(vmemmap_table), %g1
+	sllx		%g5, 3, %g5
+	or		%g1, %lo(vmemmap_table), %g1
+	ba,pt		%xcc, kvmap_dtlb_load
+	 ldx		[%g1 + %g5], %g5
+
 kvmap_dtlb_nonlinear:
 	/* Catch kernel NULL pointer derefs.  */
 	sethi		%hi(PAGE_SIZE), %g5
@@ -233,6 +242,13 @@ kvmap_dtlb_nonlinear:
 	bleu,pn		%xcc, kvmap_dtlb_longpath
 	 nop
 
+	/* Do not use the TSB for vmemmap.  */
+	mov		(VMEMMAP_BASE >> 24), %g5
+	sllx		%g5, 24, %g5
+	cmp		%g4,%g5
+	bgeu,pn		%xcc, kvmap_vmemmap
+	 nop
+
 	KERN_TSB_LOOKUP_TL1(%g4, %g6, %g5, %g1, %g2, %g3, kvmap_dtlb_load)
 
 kvmap_dtlb_tsbmiss:
diff -puN arch/sparc64/mm/init.c~sparc64-sparsemem_vmemmap-support arch/sparc64/mm/init.c
--- a/arch/sparc64/mm/init.c~sparc64-sparsemem_vmemmap-support
+++ a/arch/sparc64/mm/init.c
@@ -1645,6 +1645,58 @@ EXPORT_SYMBOL(_PAGE_E);
 unsigned long _PAGE_CACHE __read_mostly;
 EXPORT_SYMBOL(_PAGE_CACHE);
 
+#ifdef CONFIG_SPARSEMEM_VMEMMAP
+
+#define VMEMMAP_CHUNK_SHIFT	22
+#define VMEMMAP_CHUNK		(1UL << VMEMMAP_CHUNK_SHIFT)
+#define VMEMMAP_CHUNK_MASK	~(VMEMMAP_CHUNK - 1UL)
+#define VMEMMAP_ALIGN(x)	(((x)+VMEMMAP_CHUNK-1UL)&VMEMMAP_CHUNK_MASK)
+
+#define VMEMMAP_SIZE	((((1UL << MAX_PHYSADDR_BITS) >> PAGE_SHIFT) * \
+			  sizeof(struct page *)) >> VMEMMAP_CHUNK_SHIFT)
+unsigned long vmemmap_table[VMEMMAP_SIZE];
+
+int __meminit vmemmap_populate(struct page *start, unsigned long nr, int node)
+{
+	unsigned long vstart = (unsigned long) start;
+	unsigned long vend = (unsigned long) (start + nr);
+	unsigned long phys_start = (vstart - VMEMMAP_BASE);
+	unsigned long phys_end = (vend - VMEMMAP_BASE);
+	unsigned long addr = phys_start & VMEMMAP_CHUNK_MASK;
+	unsigned long end = VMEMMAP_ALIGN(phys_end);
+	unsigned long pte_base;
+
+	pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4U |
+		    _PAGE_CP_4U | _PAGE_CV_4U |
+		    _PAGE_P_4U | _PAGE_W_4U);
+	if (tlb_type == hypervisor)
+		pte_base = (_PAGE_VALID | _PAGE_SZ4MB_4V |
+			    _PAGE_CP_4V | _PAGE_CV_4V |
+			    _PAGE_P_4V | _PAGE_W_4V);
+
+	for (; addr < end; addr += VMEMMAP_CHUNK) {
+		unsigned long *vmem_pp =
+			vmemmap_table + (addr >> VMEMMAP_CHUNK_SHIFT);
+		void *block;
+
+		if (!(*vmem_pp & _PAGE_VALID)) {
+			block = vmemmap_alloc_block(1UL << 22, node);
+			if (!block)
+				return -ENOMEM;
+
+			*vmem_pp = pte_base | __pa(block);
+
+			printk(KERN_INFO "[%p-%p] page_structs=%lu "
+			       "node=%d entry=%lu/%lu\n", start, block, nr,
+			       node,
+			       addr >> VMEMMAP_CHUNK_SHIFT,
+			       VMEMMAP_SIZE >> VMEMMAP_CHUNK_SHIFT);
+		}
+	}
+	return 0;
+}
+#endif /* CONFIG_SPARSEMEM_VMEMMAP */
+
 static void prot_init_common(unsigned long page_none,
 			     unsigned long page_shared,
 			     unsigned long page_copy,
diff -puN include/asm-sparc64/pgtable.h~sparc64-sparsemem_vmemmap-support include/asm-sparc64/pgtable.h
--- a/include/asm-sparc64/pgtable.h~sparc64-sparsemem_vmemmap-support
+++ a/include/asm-sparc64/pgtable.h
@@ -42,6 +42,9 @@
 #define HI_OBP_ADDRESS		_AC(0x0000000100000000,UL)
 #define VMALLOC_START		_AC(0x0000000100000000,UL)
 #define VMALLOC_END		_AC(0x0000000200000000,UL)
+#define VMEMMAP_BASE		_AC(0x0000000200000000,UL)
+
+#define vmemmap			((struct page *)VMEMMAP_BASE)
 
 /* XXX All of this needs to be rethought so we can take advantage
  * XXX cheetah's full 64-bit virtual address space, ie. no more hole
_

Patches currently in -mm which might be from davem@davemloft.net are

origin.patch
uml-header_ops-conversion-needed-for-non-ethernet-drivers.patch
net-dccp-fix-link-error-with-config_sysctl.patch
ucc_geth-fix-build-break-introduced-by-commit-09f75cd7bf13720738e6a196cc0107ce9a5bd5a0-checkpatch-fixes.patch
git-scsi-misc.patch
sparc-support-for-new-termios.patch
sparc-support-for-new-termios-checkpatch-fixes.patch
git-wireless.patch
unexport-asm-shmparamh.patch
kconfig-make-instrumentation-support-non-experimental.patch
remove-dma_cache_wbackinvwback_inv-functions.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
update-dma-mapping-documentation.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-broken-netfilter-binary-sysctls.patch
sysctl-update-sysctl_checks-list-of-binary-paths.patch
bitops-introduce-lock-ops.patch
