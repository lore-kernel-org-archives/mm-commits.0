From: akpm@linux-foundation.org
Subject: [merged] alpha-convert-u64-to-unsigned-long-long.patch removed from -mm tree
Date: Wed, 01 Apr 2009 11:39:13 -0700
Message-ID: <200904011839.n31IdDOZ008614@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56166 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754875AbZDATHP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Apr 2009 15:07:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, akpm@linux-foundation.org, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     alpha: convert u64 to unsigned long long
has been removed from the -mm tree.  Its filename was
     alpha-convert-u64-to-unsigned-long-long.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: alpha: convert u64 to unsigned long long
From: Randy Dunlap <randy.dunlap@oracle.com>

Convert alpha architecture to use u64 as unsigned long long.  This is
being done so that (a) all arches use u64 as unsigned long long and (b)
printk of a u64 as %ll[ux] will not generate format warnings by gcc.

The only gcc cross-compiler that I have is 4.0.2, which generates errors
about miscompiling __weak references, so I have commented out that line in
compiler-gcc4.h so that most of these compile, but more builds and real
machine testing would be Real Good.

[akpm@linux-foundation.org: fix warning]
[akpm@linux-foundation.org: fix build]
[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/machvec.h |    2 -
 arch/alpha/include/asm/types.h   |    5 +++
 arch/alpha/kernel/err_ev6.c      |    4 +-
 arch/alpha/kernel/err_ev7.c      |    6 ++--
 arch/alpha/kernel/err_marvel.c   |   40 ++++++++++++++---------------
 arch/alpha/kernel/err_titan.c    |   28 ++++++++++----------
 arch/alpha/kernel/pci.c          |    2 -
 arch/alpha/kernel/pci_iommu.c    |   34 ++++++++++++------------
 arch/alpha/kernel/proto.h        |   16 +++++------
 arch/alpha/kernel/setup.c        |    2 -
 arch/alpha/kernel/smc37c669.c    |    4 +-
 arch/alpha/kernel/sys_jensen.c   |    3 --
 arch/alpha/kernel/sys_sable.c    |    4 +-
 arch/alpha/kernel/traps.c        |    2 -
 14 files changed, 78 insertions(+), 74 deletions(-)

diff -puN arch/alpha/include/asm/machvec.h~alpha-convert-u64-to-unsigned-long-long arch/alpha/include/asm/machvec.h
--- a/arch/alpha/include/asm/machvec.h~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/include/asm/machvec.h
@@ -80,7 +80,7 @@ struct alpha_machine_vector
 	void (*update_irq_hw)(unsigned long, unsigned long, int);
 	void (*ack_irq)(unsigned long);
 	void (*device_interrupt)(unsigned long vector);
-	void (*machine_check)(u64 vector, u64 la);
+	void (*machine_check)(unsigned long vector, unsigned long la);
 
 	void (*smp_callin)(void);
 	void (*init_arch)(void);
diff -puN arch/alpha/include/asm/types.h~alpha-convert-u64-to-unsigned-long-long arch/alpha/include/asm/types.h
--- a/arch/alpha/include/asm/types.h~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/include/asm/types.h
@@ -8,7 +8,12 @@
  * not a major issue.  However, for interoperability, libraries still
  * need to be careful to avoid a name clashes.
  */
+
+#ifdef __KERNEL__
+#include <asm-generic/int-ll64.h>
+#else
 #include <asm-generic/int-l64.h>
+#endif
 
 #ifndef __ASSEMBLY__
 
diff -puN arch/alpha/kernel/err_ev6.c~alpha-convert-u64-to-unsigned-long-long arch/alpha/kernel/err_ev6.c
--- a/arch/alpha/kernel/err_ev6.c~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/kernel/err_ev6.c
@@ -157,8 +157,8 @@ ev6_parse_cbox(u64 c_addr, u64 c1_syn, u
 		       err_print_prefix,
 		       streamname[stream], bitsname[bits], sourcename[source]);
 
-	printk("%s    Address: 0x%016lx\n"
-	         "    Syndrome[upper.lower]: %02lx.%02lx\n", 
+	printk("%s    Address: 0x%016llx\n"
+	         "    Syndrome[upper.lower]: %02llx.%02llx\n",
 	       err_print_prefix,
 	       c_addr,
 	       c2_syn, c1_syn);
diff -puN arch/alpha/kernel/err_ev7.c~alpha-convert-u64-to-unsigned-long-long arch/alpha/kernel/err_ev7.c
--- a/arch/alpha/kernel/err_ev7.c~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/kernel/err_ev7.c
@@ -246,13 +246,13 @@ ev7_process_pal_subpacket(struct el_subp
 
 	switch(header->type) {
 	case EL_TYPE__PAL__LOGOUT_FRAME:
-		printk("%s*** MCHK occurred on LPID %ld (RBOX %lx)\n",
+		printk("%s*** MCHK occurred on LPID %ld (RBOX %llx)\n",
 		       err_print_prefix,
 		       packet->by_type.logout.whami, 
 		       packet->by_type.logout.rbox_whami);
 		el_print_timestamp(&packet->by_type.logout.timestamp);
-		printk("%s  EXC_ADDR: %016lx\n"
-		         "  HALT_CODE: %lx\n", 
+		printk("%s  EXC_ADDR: %016llx\n"
+		         "  HALT_CODE: %llx\n",
 		       err_print_prefix,
 		       packet->by_type.logout.exc_addr,
 		       packet->by_type.logout.halt_code);
diff -puN arch/alpha/kernel/err_marvel.c~alpha-convert-u64-to-unsigned-long-long arch/alpha/kernel/err_marvel.c
--- a/arch/alpha/kernel/err_marvel.c~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/kernel/err_marvel.c
@@ -129,7 +129,7 @@ marvel_print_po7_crrct_sym(u64 crrct_sym
 
 
 	printk("%s      Correctable Error Symptoms:\n"
-	       "%s        Syndrome: 0x%lx\n",
+	       "%s        Syndrome: 0x%llx\n",
 	       err_print_prefix,
 	       err_print_prefix, EXTRACT(crrct_sym, IO7__PO7_CRRCT_SYM__SYN));
 	marvel_print_err_cyc(EXTRACT(crrct_sym, IO7__PO7_CRRCT_SYM__ERR_CYC));
@@ -186,7 +186,7 @@ marvel_print_po7_uncrr_sym(u64 uncrr_sym
 	uncrr_sym &= valid_mask;
 
 	if (EXTRACT(valid_mask, IO7__PO7_UNCRR_SYM__SYN))
-		printk("%s        Syndrome: 0x%lx\n",
+		printk("%s        Syndrome: 0x%llx\n",
 		       err_print_prefix, 
 		       EXTRACT(uncrr_sym, IO7__PO7_UNCRR_SYM__SYN));
 
@@ -307,7 +307,7 @@ marvel_print_po7_ugbge_sym(u64 ugbge_sym
 		sprintf(opcode_str, "BlkIO");
 		break;
 	default:
-		sprintf(opcode_str, "0x%lx\n", 
+		sprintf(opcode_str, "0x%llx\n",
 			EXTRACT(ugbge_sym, IO7__PO7_UGBGE_SYM__UPH_OPCODE));
 		break;
 	}
@@ -321,7 +321,7 @@ marvel_print_po7_ugbge_sym(u64 ugbge_sym
 	       opcode_str);
 
 	if (0xC5 != EXTRACT(ugbge_sym, IO7__PO7_UGBGE_SYM__UPH_OPCODE))
-		printk("%s        Packet Offset 0x%08lx\n",
+		printk("%s        Packet Offset 0x%08llx\n",
 		       err_print_prefix,
 		       EXTRACT(ugbge_sym, IO7__PO7_UGBGE_SYM__UPH_PKT_OFF));
 }
@@ -480,8 +480,8 @@ marvel_print_po7_err_sum(struct ev7_pal_
 		printk("%s    Lost Error\n", err_print_prefix);
 
 	printk("%s    Failing Packet:\n"
-	       "%s      Cycle 1: %016lx\n"
-	       "%s      Cycle 2: %016lx\n",
+	       "%s      Cycle 1: %016llx\n"
+	       "%s      Cycle 2: %016llx\n",
 	       err_print_prefix,
 	       err_print_prefix, io->po7_err_pkt0,
 	       err_print_prefix, io->po7_err_pkt1);
@@ -515,9 +515,9 @@ marvel_print_pox_tlb_err(u64 tlb_err)
 	if (!(tlb_err & IO7__POX_TLBERR__ERR_VALID))
 		return;
 
-	printk("%s      TLB Error on index 0x%lx:\n"
+	printk("%s      TLB Error on index 0x%llx:\n"
 	       "%s        - %s\n"
-	       "%s        - Addr: 0x%016lx\n",
+	       "%s        - Addr: 0x%016llx\n",
 	       err_print_prefix,
 	       EXTRACT(tlb_err, IO7__POX_TLBERR__ERR_TLB_PTR),
 	       err_print_prefix,
@@ -579,7 +579,7 @@ marvel_print_pox_spl_cmplt(u64 spl_cmplt
 		sprintf(message, "Uncorrectable Split Write Data Error");
 		break;
 	default:
-		sprintf(message, "%08lx\n", 
+		sprintf(message, "%08llx\n",
 			EXTRACT(spl_cmplt, IO7__POX_SPLCMPLT__MESSAGE));
 		break;
 	}
@@ -620,9 +620,9 @@ marvel_print_pox_trans_sum(u64 trans_sum
 		return;
 
 	printk("%s      Transaction Summary:\n"
-	       "%s        Command: 0x%lx - %s\n"
-	       "%s        Address: 0x%016lx%s\n"
-	       "%s        PCI-X Master Slot: 0x%lx\n",
+	       "%s        Command: 0x%llx - %s\n"
+	       "%s        Address: 0x%016llx%s\n"
+	       "%s        PCI-X Master Slot: 0x%llx\n",
 	       err_print_prefix, 
 	       err_print_prefix, 
 	       EXTRACT(trans_sum, IO7__POX_TRANSUM__PCIX_CMD),
@@ -964,12 +964,12 @@ marvel_process_io_error(struct ev7_lf_su
 
 #if 0
 		printk("%s  PORT 7 ERROR:\n"
-		       "%s    PO7_ERROR_SUM: %016lx\n"
-		       "%s    PO7_UNCRR_SYM: %016lx\n"
-		       "%s    PO7_CRRCT_SYM: %016lx\n"
-		       "%s    PO7_UGBGE_SYM: %016lx\n"
-		       "%s    PO7_ERR_PKT0:  %016lx\n"
-		       "%s    PO7_ERR_PKT1:  %016lx\n",
+		       "%s    PO7_ERROR_SUM: %016llx\n"
+		       "%s    PO7_UNCRR_SYM: %016llx\n"
+		       "%s    PO7_CRRCT_SYM: %016llx\n"
+		       "%s    PO7_UGBGE_SYM: %016llx\n"
+		       "%s    PO7_ERR_PKT0:  %016llx\n"
+		       "%s    PO7_ERR_PKT1:  %016llx\n",
 		       err_print_prefix,
 		       err_print_prefix, io->po7_error_sum,
 		       err_print_prefix, io->po7_uncrr_sym,
@@ -987,12 +987,12 @@ marvel_process_io_error(struct ev7_lf_su
 		if (!MARVEL_IO_ERR_VALID(io->ports[i].pox_err_sum))
 			continue;
 
-		printk("%s  PID %u PORT %d POx_ERR_SUM: %016lx\n", 
+		printk("%s  PID %u PORT %d POx_ERR_SUM: %016llx\n",
 		       err_print_prefix, 
 		       lf_subpackets->io_pid, i, io->ports[i].pox_err_sum);
 		marvel_print_pox_err(io->ports[i].pox_err_sum, &io->ports[i]);
 
-		printk("%s  [ POx_FIRST_ERR: %016lx ]\n", 
+		printk("%s  [ POx_FIRST_ERR: %016llx ]\n",
 		       err_print_prefix, io->ports[i].pox_first_err);
 		marvel_print_pox_err(io->ports[i].pox_first_err, 
 				     &io->ports[i]);
diff -puN arch/alpha/kernel/err_titan.c~alpha-convert-u64-to-unsigned-long-long arch/alpha/kernel/err_titan.c
--- a/arch/alpha/kernel/err_titan.c~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/kernel/err_titan.c
@@ -107,12 +107,12 @@ titan_parse_p_serror(int which, u64 serr
 	if (!print)
 		return status;
 
-	printk("%s  PChip %d SERROR: %016lx\n", 
+	printk("%s  PChip %d SERROR: %016llx\n",
 	       err_print_prefix, which, serror);
 	if (serror & TITAN__PCHIP_SERROR__ECCMASK) {
 		printk("%s    %sorrectable ECC Error:\n"
 		       "      Source: %-6s  Command: %-8s  Syndrome: 0x%08x\n"
-		       "      Address: 0x%lx\n", 
+		       "      Address: 0x%llx\n",
 		       err_print_prefix,
 		       (serror & TITAN__PCHIP_SERROR__UECC) ? "Unc" : "C",
 		       serror_src[EXTRACT(serror, TITAN__PCHIP_SERROR__SRC)],
@@ -223,7 +223,7 @@ titan_parse_p_perror(int which, int port
 	if (!print) 
 		return status;
 
-	printk("%s  PChip %d %cPERROR: %016lx\n", 
+	printk("%s  PChip %d %cPERROR: %016llx\n",
 	       err_print_prefix, which, 
 	       port ? 'A' : 'G', perror);
 	if (perror & TITAN__PCHIP_PERROR__IPTPW)
@@ -316,7 +316,7 @@ titan_parse_p_agperror(int which, u64 ag
 	addr = EXTRACT(agperror, TITAN__PCHIP_AGPERROR__ADDR) << 3;
 	len = EXTRACT(agperror, TITAN__PCHIP_AGPERROR__LEN);
 
-	printk("%s  PChip %d AGPERROR: %016lx\n", err_print_prefix,
+	printk("%s  PChip %d AGPERROR: %016llx\n", err_print_prefix,
 	       which, agperror);
 	if (agperror & TITAN__PCHIP_AGPERROR__NOWINDOW)
 		printk("%s    No Window\n", err_print_prefix);
@@ -597,16 +597,16 @@ privateer_process_680_frame(struct el_co
 		return status;
 
 	/* TODO - decode instead of just dumping... */
-	printk("%s  Summary Flags:         %016lx\n"
- 	         "  CChip DIRx:            %016lx\n"
-		 "  System Management IR:  %016lx\n"
-		 "  CPU IR:                %016lx\n"
-		 "  Power Supply IR:       %016lx\n"
-		 "  LM78 Fault Status:     %016lx\n"
-		 "  System Doors:          %016lx\n"
-		 "  Temperature Warning:   %016lx\n"
-		 "  Fan Control:           %016lx\n"
-		 "  Fatal Power Down Code: %016lx\n",
+	printk("%s  Summary Flags:         %016llx\n"
+ 	         "  CChip DIRx:            %016llx\n"
+		 "  System Management IR:  %016llx\n"
+		 "  CPU IR:                %016llx\n"
+		 "  Power Supply IR:       %016llx\n"
+		 "  LM78 Fault Status:     %016llx\n"
+		 "  System Doors:          %016llx\n"
+		 "  Temperature Warning:   %016llx\n"
+		 "  Fan Control:           %016llx\n"
+		 "  Fatal Power Down Code: %016llx\n",
 	       err_print_prefix,
 	       emchk->summary,
 	       emchk->c_dirx,
diff -puN arch/alpha/kernel/pci.c~alpha-convert-u64-to-unsigned-long-long arch/alpha/kernel/pci.c
--- a/arch/alpha/kernel/pci.c~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/kernel/pci.c
@@ -168,7 +168,7 @@ pcibios_align_resource(void *data, struc
 		 */
 
 		/* Align to multiple of size of minimum base.  */
-		alignto = max(0x1000UL, align);
+		alignto = max_t(resource_size_t, 0x1000, align);
 		start = ALIGN(start, alignto);
 		if (hose->sparse_mem_base && size <= 7 * 16*MB) {
 			if (((start / (16*MB)) & 0x7) == 0) {
diff -puN arch/alpha/kernel/pci_iommu.c~alpha-convert-u64-to-unsigned-long-long arch/alpha/kernel/pci_iommu.c
--- a/arch/alpha/kernel/pci_iommu.c~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/kernel/pci_iommu.c
@@ -247,7 +247,7 @@ pci_map_single_1(struct pci_dev *pdev, v
 	    && paddr + size <= __direct_map_size) {
 		ret = paddr + __direct_map_base;
 
-		DBGA2("pci_map_single: [%p,%lx] -> direct %lx from %p\n",
+		DBGA2("pci_map_single: [%p,%zx] -> direct %llx from %p\n",
 		      cpu_addr, size, ret, __builtin_return_address(0));
 
 		return ret;
@@ -258,7 +258,7 @@ pci_map_single_1(struct pci_dev *pdev, v
 	if (dac_allowed) {
 		ret = paddr + alpha_mv.pci_dac_offset;
 
-		DBGA2("pci_map_single: [%p,%lx] -> DAC %lx from %p\n",
+		DBGA2("pci_map_single: [%p,%zx] -> DAC %llx from %p\n",
 		      cpu_addr, size, ret, __builtin_return_address(0));
 
 		return ret;
@@ -299,7 +299,7 @@ pci_map_single_1(struct pci_dev *pdev, v
 	ret = arena->dma_base + dma_ofs * PAGE_SIZE;
 	ret += (unsigned long)cpu_addr & ~PAGE_MASK;
 
-	DBGA2("pci_map_single: [%p,%lx] np %ld -> sg %lx from %p\n",
+	DBGA2("pci_map_single: [%p,%zx] np %ld -> sg %llx from %p\n",
 	      cpu_addr, size, npages, ret, __builtin_return_address(0));
 
 	return ret;
@@ -355,14 +355,14 @@ pci_unmap_single(struct pci_dev *pdev, d
 	    && dma_addr < __direct_map_base + __direct_map_size) {
 		/* Nothing to do.  */
 
-		DBGA2("pci_unmap_single: direct [%lx,%lx] from %p\n",
+		DBGA2("pci_unmap_single: direct [%llx,%zx] from %p\n",
 		      dma_addr, size, __builtin_return_address(0));
 
 		return;
 	}
 
 	if (dma_addr > 0xffffffff) {
-		DBGA2("pci64_unmap_single: DAC [%lx,%lx] from %p\n",
+		DBGA2("pci64_unmap_single: DAC [%llx,%zx] from %p\n",
 		      dma_addr, size, __builtin_return_address(0));
 		return;
 	}
@@ -373,9 +373,9 @@ pci_unmap_single(struct pci_dev *pdev, d
 
 	dma_ofs = (dma_addr - arena->dma_base) >> PAGE_SHIFT;
 	if (dma_ofs * PAGE_SIZE >= arena->size) {
-		printk(KERN_ERR "Bogus pci_unmap_single: dma_addr %lx "
-		       " base %lx size %x\n", dma_addr, arena->dma_base,
-		       arena->size);
+		printk(KERN_ERR "Bogus pci_unmap_single: dma_addr %llx "
+		       " base %llx size %x\n",
+		       dma_addr, arena->dma_base, arena->size);
 		return;
 		BUG();
 	}
@@ -394,7 +394,7 @@ pci_unmap_single(struct pci_dev *pdev, d
 
 	spin_unlock_irqrestore(&arena->lock, flags);
 
-	DBGA2("pci_unmap_single: sg [%lx,%lx] np %ld from %p\n",
+	DBGA2("pci_unmap_single: sg [%llx,%zx] np %ld from %p\n",
 	      dma_addr, size, npages, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(pci_unmap_single);
@@ -444,7 +444,7 @@ try_again:
 		goto try_again;
 	}
 		
-	DBGA2("pci_alloc_consistent: %lx -> [%p,%x] from %p\n",
+	DBGA2("pci_alloc_consistent: %zx -> [%p,%llx] from %p\n",
 	      size, cpu_addr, *dma_addrp, __builtin_return_address(0));
 
 	return cpu_addr;
@@ -464,7 +464,7 @@ pci_free_consistent(struct pci_dev *pdev
 	pci_unmap_single(pdev, dma_addr, size, PCI_DMA_BIDIRECTIONAL);
 	free_pages((unsigned long)cpu_addr, get_order(size));
 
-	DBGA2("pci_free_consistent: [%x,%lx] from %p\n",
+	DBGA2("pci_free_consistent: [%llx,%zx] from %p\n",
 	      dma_addr, size, __builtin_return_address(0));
 }
 EXPORT_SYMBOL(pci_free_consistent);
@@ -551,7 +551,7 @@ sg_fill(struct device *dev, struct scatt
 		out->dma_address = paddr + __direct_map_base;
 		out->dma_length = size;
 
-		DBGA("    sg_fill: [%p,%lx] -> direct %lx\n",
+		DBGA("    sg_fill: [%p,%lx] -> direct %llx\n",
 		     __va(paddr), size, out->dma_address);
 
 		return 0;
@@ -563,7 +563,7 @@ sg_fill(struct device *dev, struct scatt
 		out->dma_address = paddr + alpha_mv.pci_dac_offset;
 		out->dma_length = size;
 
-		DBGA("    sg_fill: [%p,%lx] -> DAC %lx\n",
+		DBGA("    sg_fill: [%p,%lx] -> DAC %llx\n",
 		     __va(paddr), size, out->dma_address);
 
 		return 0;
@@ -589,7 +589,7 @@ sg_fill(struct device *dev, struct scatt
 	out->dma_address = arena->dma_base + dma_ofs*PAGE_SIZE + paddr;
 	out->dma_length = size;
 
-	DBGA("    sg_fill: [%p,%lx] -> sg %lx np %ld\n",
+	DBGA("    sg_fill: [%p,%lx] -> sg %llx np %ld\n",
 	     __va(paddr), size, out->dma_address, npages);
 
 	/* All virtually contiguous.  We need to find the length of each
@@ -752,7 +752,7 @@ pci_unmap_sg(struct pci_dev *pdev, struc
 
 		if (addr > 0xffffffff) {
 			/* It's a DAC address -- nothing to do.  */
-			DBGA("    (%ld) DAC [%lx,%lx]\n",
+			DBGA("    (%ld) DAC [%llx,%zx]\n",
 			      sg - end + nents, addr, size);
 			continue;
 		}
@@ -760,12 +760,12 @@ pci_unmap_sg(struct pci_dev *pdev, struc
 		if (addr >= __direct_map_base
 		    && addr < __direct_map_base + __direct_map_size) {
 			/* Nothing to do.  */
-			DBGA("    (%ld) direct [%lx,%lx]\n",
+			DBGA("    (%ld) direct [%llx,%zx]\n",
 			      sg - end + nents, addr, size);
 			continue;
 		}
 
-		DBGA("    (%ld) sg [%lx,%lx]\n",
+		DBGA("    (%ld) sg [%llx,%zx]\n",
 		     sg - end + nents, addr, size);
 
 		npages = iommu_num_pages(addr, size, PAGE_SIZE);
diff -puN arch/alpha/kernel/proto.h~alpha-convert-u64-to-unsigned-long-long arch/alpha/kernel/proto.h
--- a/arch/alpha/kernel/proto.h~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/kernel/proto.h
@@ -20,7 +20,7 @@ struct pci_controller;
 extern struct pci_ops apecs_pci_ops;
 extern void apecs_init_arch(void);
 extern void apecs_pci_clr_err(void);
-extern void apecs_machine_check(u64, u64);
+extern void apecs_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void apecs_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_cia.c */
@@ -29,7 +29,7 @@ extern void cia_init_pci(void);
 extern void cia_init_arch(void);
 extern void pyxis_init_arch(void);
 extern void cia_kill_arch(int);
-extern void cia_machine_check(u64, u64);
+extern void cia_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void cia_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_irongate.c */
@@ -42,7 +42,7 @@ extern void irongate_machine_check(u64, 
 /* core_lca.c */
 extern struct pci_ops lca_pci_ops;
 extern void lca_init_arch(void);
-extern void lca_machine_check(u64, u64);
+extern void lca_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void lca_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_marvel.c */
@@ -64,7 +64,7 @@ void io7_clear_errors(struct io7 *io7);
 extern struct pci_ops mcpcia_pci_ops;
 extern void mcpcia_init_arch(void);
 extern void mcpcia_init_hoses(void);
-extern void mcpcia_machine_check(u64, u64);
+extern void mcpcia_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void mcpcia_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_polaris.c */
@@ -72,14 +72,14 @@ extern struct pci_ops polaris_pci_ops;
 extern int polaris_read_config_dword(struct pci_dev *, int, u32 *);
 extern int polaris_write_config_dword(struct pci_dev *, int, u32);
 extern void polaris_init_arch(void);
-extern void polaris_machine_check(u64, u64);
+extern void polaris_machine_check(unsigned long vector, unsigned long la_ptr);
 #define polaris_pci_tbi ((void *)0)
 
 /* core_t2.c */
 extern struct pci_ops t2_pci_ops;
 extern void t2_init_arch(void);
 extern void t2_kill_arch(int);
-extern void t2_machine_check(u64, u64);
+extern void t2_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void t2_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_titan.c */
@@ -94,14 +94,14 @@ extern struct _alpha_agp_info *titan_agp
 extern struct pci_ops tsunami_pci_ops;
 extern void tsunami_init_arch(void);
 extern void tsunami_kill_arch(int);
-extern void tsunami_machine_check(u64, u64);
+extern void tsunami_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void tsunami_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 
 /* core_wildfire.c */
 extern struct pci_ops wildfire_pci_ops;
 extern void wildfire_init_arch(void);
 extern void wildfire_kill_arch(int);
-extern void wildfire_machine_check(u64, u64);
+extern void wildfire_machine_check(unsigned long vector, unsigned long la_ptr);
 extern void wildfire_pci_tbi(struct pci_controller *, dma_addr_t, dma_addr_t);
 extern int wildfire_pa_to_nid(unsigned long);
 extern int wildfire_cpuid_to_nid(int);
diff -puN arch/alpha/kernel/setup.c~alpha-convert-u64-to-unsigned-long-long arch/alpha/kernel/setup.c
--- a/arch/alpha/kernel/setup.c~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/kernel/setup.c
@@ -1255,7 +1255,7 @@ show_cpuinfo(struct seq_file *f, void *s
 		       platform_string(), nr_processors);
 
 #ifdef CONFIG_SMP
-	seq_printf(f, "cpus active\t\t: %d\n"
+	seq_printf(f, "cpus active\t\t: %u\n"
 		      "cpu active mask\t\t: %016lx\n",
 		       num_online_cpus(), cpus_addr(cpu_possible_map)[0]);
 #endif
diff -puN arch/alpha/kernel/smc37c669.c~alpha-convert-u64-to-unsigned-long-long arch/alpha/kernel/smc37c669.c
--- a/arch/alpha/kernel/smc37c669.c~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/kernel/smc37c669.c
@@ -2542,8 +2542,8 @@ void __init SMC669_Init ( int index )
         SMC37c669_display_device_info( );
 #endif
 	local_irq_restore(flags);
-        printk( "SMC37c669 Super I/O Controller found @ 0x%lx\n",
-		(unsigned long) SMC_base );
+        printk( "SMC37c669 Super I/O Controller found @ 0x%p\n",
+		SMC_base );
     }
     else {
 	local_irq_restore(flags);
diff -puN arch/alpha/kernel/sys_jensen.c~alpha-convert-u64-to-unsigned-long-long arch/alpha/kernel/sys_jensen.c
--- a/arch/alpha/kernel/sys_jensen.c~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/kernel/sys_jensen.c
@@ -244,12 +244,11 @@ jensen_init_arch(void)
 }
 
 static void
-jensen_machine_check (u64 vector, u64 la)
+jensen_machine_check(unsigned long vector, unsigned long la)
 {
 	printk(KERN_CRIT "Machine check\n");
 }
 
-
 /*
  * The System Vector
  */
diff -puN arch/alpha/kernel/sys_sable.c~alpha-convert-u64-to-unsigned-long-long arch/alpha/kernel/sys_sable.c
--- a/arch/alpha/kernel/sys_sable.c~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/kernel/sys_sable.c
@@ -453,7 +453,7 @@ sable_lynx_enable_irq(unsigned int irq)
 	sable_lynx_irq_swizzle->update_irq_hw(bit, mask);
 	spin_unlock(&sable_lynx_irq_lock);
 #if 0
-	printk("%s: mask 0x%lx bit 0x%x irq 0x%x\n",
+	printk("%s: mask 0x%lx bit 0x%lx irq 0x%x\n",
 	       __func__, mask, bit, irq);
 #endif
 }
@@ -469,7 +469,7 @@ sable_lynx_disable_irq(unsigned int irq)
 	sable_lynx_irq_swizzle->update_irq_hw(bit, mask);
 	spin_unlock(&sable_lynx_irq_lock);
 #if 0
-	printk("%s: mask 0x%lx bit 0x%x irq 0x%x\n",
+	printk("%s: mask 0x%lx bit 0x%lx irq 0x%x\n",
 	       __func__, mask, bit, irq);
 #endif
 }
diff -puN arch/alpha/kernel/traps.c~alpha-convert-u64-to-unsigned-long-long arch/alpha/kernel/traps.c
--- a/arch/alpha/kernel/traps.c~alpha-convert-u64-to-unsigned-long-long
+++ a/arch/alpha/kernel/traps.c
@@ -623,7 +623,7 @@ do_entUna(void * va, unsigned long opcod
 	}
 
 	lock_kernel();
-	printk("Bad unaligned kernel access at %016lx: %p %lx %ld\n",
+	printk("Bad unaligned kernel access at %016lx: %p %lx %lu\n",
 		pc, va, opcode, reg);
 	do_exit(SIGSEGV);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
es-input-allow-certain-ev_abs-events-to-bypass-all-filtering-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
esp-fix-section-mismatch-warning.patch
qla2x-fix-printk-format-warnings.patch
max3100-spi-uart-driver.patch
mm-add-proc-controls-for-pdflush-threads-fix-99.patch
cs553x-gpio-add-amd-cs5535-cs5536-gpio-driver-support-fix.patch
documentation-ignore-byproducts-from-latex.patch
cpusets-replace-zone-allowed-functions-with-node-allowed.patch
namespaces-move-proc_net_get_sb-to-a-generic-fs-superc-helper-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix.patch
kexec-add-dmesg-log-symbols-to-proc-vmcoreinfo-lists-fix-fix-fix-fix.patch
linuxpps-core-support.patch
linuxpps-core-support-v2.patch
auditsc-fix-kernel-doc-notation.patch
reiser4-export-remove_from_page_cache-fix.patch

