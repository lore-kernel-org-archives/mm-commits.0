From: akpm@linux-foundation.org
Subject: - alpha-support-graphics-on-non-zero-pci-domains.patch removed from -mm tree
Date: Fri, 01 Jun 2007 10:48:07 -0700
Message-ID: <200706011748.l51Hm60T015176@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:42315 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761383AbXFARsT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jun 2007 13:48:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jay.estabrook@hp.com, ink@jurassic.park.msu.ru, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     ALPHA: support graphics on non-zero PCI domains
has been removed from the -mm tree.  Its filename was
     alpha-support-graphics-on-non-zero-pci-domains.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ALPHA: support graphics on non-zero PCI domains
From: Jay Estabrook <jay.estabrook@hp.com>

This code replaces earlier and incomplete handling of graphics on non-zero PCI
domains (aka hoses or peer PCI buses).

An option (CONFIG_VGA_HOSE) is set TRUE if configuring a GENERIC kernel, or a
kernel for MARVEL, TITAN, or TSUNAMI machines, as these are the machines whose
SRM consoles are capable of configuring and handling graphics options on
non-zero hoses.  All other machines have the option set FALSE.

A routine, "find_console_vga_hose()", is used to find the graphics device
which the machine's firmware believes is the console device, and it sets a
global (pci_vga_hose) for later use in managing access to the device.  This is
called in "init_arch" on TITAN and TSUNAMI machines; MARVEL machines use a
custom version of this routine because of extra complexity.

A routine, "locate_and_init_vga()", is used to find the graphics device and
set a global (pci_vga_hose) for later use in managing access to the device, in
the case where "find_console_vga_hose" has failed.

Various adjustments are made to the ioremap and ioportmap routines for
detecting and translating "legacy" VGA register and memory references to the
real PCI domain.

[akpm@linux-foundation.org: don't statically init bss]
[akpm@linux-foundation.org: build fix]
Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/Kconfig               |   16 ++++++
 arch/alpha/kernel/console.c      |   70 +++++++++++++++++++----------
 arch/alpha/kernel/core_marvel.c  |   43 +++++++----------
 arch/alpha/kernel/core_titan.c   |   70 ++++++++++++-----------------
 arch/alpha/kernel/core_tsunami.c |   24 +++++++++
 arch/alpha/kernel/proto.h        |    9 +++
 arch/alpha/kernel/sys_dp264.c    |   11 ++++
 arch/alpha/kernel/sys_marvel.c   |    4 -
 arch/alpha/kernel/sys_titan.c    |    2 
 include/asm-alpha/core_titan.h   |    7 --
 include/asm-alpha/core_tsunami.h |   15 +-----
 include/asm-alpha/vga.h          |   31 ++++++++++++
 12 files changed, 190 insertions(+), 112 deletions(-)

diff -puN arch/alpha/Kconfig~alpha-support-graphics-on-non-zero-pci-domains arch/alpha/Kconfig
--- a/arch/alpha/Kconfig~alpha-support-graphics-on-non-zero-pci-domains
+++ a/arch/alpha/Kconfig
@@ -481,6 +481,15 @@ config ALPHA_BROKEN_IRQ_MASK
 	depends on ALPHA_GENERIC || ALPHA_PC164
 	default y
 
+config VGA_HOSE
+	bool
+	depends on ALPHA_GENERIC || ALPHA_TITAN || ALPHA_MARVEL || ALPHA_TSUNAMI
+	default y
+	help
+	  Support VGA on an arbitrary hose; needed for several platforms
+	  which always have multiple hoses, and whose consoles support it.
+
+
 config ALPHA_SRM
 	bool "Use SRM as bootloader" if ALPHA_CABRIOLET || ALPHA_AVANTI_CH || ALPHA_EB64P || ALPHA_PC164 || ALPHA_TAKARA || ALPHA_EB164 || ALPHA_ALCOR || ALPHA_MIATA || ALPHA_LX164 || ALPHA_SX164 || ALPHA_NAUTILUS || ALPHA_NONAME
 	default y if ALPHA_JENSEN || ALPHA_MIKASA || ALPHA_SABLE || ALPHA_LYNX || ALPHA_NORITAKE || ALPHA_DP264 || ALPHA_RAWHIDE || ALPHA_EIGER || ALPHA_WILDFIRE || ALPHA_TITAN || ALPHA_SHARK || ALPHA_MARVEL
@@ -644,6 +653,13 @@ source "arch/alpha/oprofile/Kconfig"
 
 source "arch/alpha/Kconfig.debug"
 
+# DUMMY_CONSOLE may be defined in drivers/video/console/Kconfig
+# but we also need it if VGA_HOSE is set
+config DUMMY_CONSOLE
+	bool
+	depends on VGA_HOSE
+	default y
+
 source "security/Kconfig"
 
 source "crypto/Kconfig"
diff -puN arch/alpha/kernel/console.c~alpha-support-graphics-on-non-zero-pci-domains arch/alpha/kernel/console.c
--- a/arch/alpha/kernel/console.c~alpha-support-graphics-on-non-zero-pci-domains
+++ a/arch/alpha/kernel/console.c
@@ -9,16 +9,20 @@
 #include <linux/init.h>
 #include <linux/tty.h>
 #include <linux/console.h>
+#include <linux/vt.h>
 #include <asm/vga.h>
 #include <asm/machvec.h>
 
+#include "pci_impl.h"
+
 #ifdef CONFIG_VGA_HOSE
 
-/*
- * Externally-visible vga hose bases
- */
-unsigned long __vga_hose_io_base = 0;	/* base for default hose */
-unsigned long __vga_hose_mem_base = 0;	/* base for default hose */
+struct pci_controller *pci_vga_hose;
+static struct resource alpha_vga = {
+	.name	= "alpha-vga+",
+	.start	= 0x3C0,
+	.end	= 0x3DF
+};
 
 static struct pci_controller * __init 
 default_vga_hose_select(struct pci_controller *h1, struct pci_controller *h2)
@@ -30,36 +34,58 @@ default_vga_hose_select(struct pci_contr
 }
 
 void __init 
-set_vga_hose(struct pci_controller *hose)
-{
-	if (hose) {
-		__vga_hose_io_base = hose->io_space->start;
-		__vga_hose_mem_base = hose->mem_space->start;
-	}
-}
-
-void __init 
 locate_and_init_vga(void *(*sel_func)(void *, void *))
 {
 	struct pci_controller *hose = NULL;
 	struct pci_dev *dev = NULL;
 
+	/* Default the select function */
 	if (!sel_func) sel_func = (void *)default_vga_hose_select;
 
+	/* Find the console VGA device */
 	for(dev=NULL; (dev=pci_get_class(PCI_CLASS_DISPLAY_VGA << 8, dev));) {
-		if (!hose) hose = dev->sysdata;
-		else hose = sel_func(hose, dev->sysdata);
+		if (!hose)
+			hose = dev->sysdata;
+		else
+			hose = sel_func(hose, dev->sysdata);
 	}
 
-	/* Did we already inititialize the correct one? */
-	if (conswitchp == &vga_con &&
-	    __vga_hose_io_base == hose->io_space->start &&
-	    __vga_hose_mem_base == hose->mem_space->start)
+	/* Did we already initialize the correct one? Is there one? */
+	if (!hose || (conswitchp == &vga_con && pci_vga_hose == hose))
 		return;
 
-	/* Set the VGA hose and init the new console */
-	set_vga_hose(hose);
+	/* Create a new VGA ioport resource WRT the hose it is on. */
+	alpha_vga.start += hose->io_space->start;
+	alpha_vga.end += hose->io_space->start;
+	request_resource(hose->io_space, &alpha_vga);
+
+	/* Set the VGA hose and init the new console. */
+	pci_vga_hose = hose;
 	take_over_console(&vga_con, 0, MAX_NR_CONSOLES-1, 1);
 }
 
+void __init
+find_console_vga_hose(void)
+{
+	u64 *pu64 = (u64 *)((u64)hwrpb + hwrpb->ctbt_offset);
+
+	if (pu64[7] == 3) {	/* TERM_TYPE == graphics */
+		struct pci_controller *hose;
+		int h = (pu64[30] >> 24) & 0xff;	/* console hose # */
+
+		/*
+		 * Our hose numbering DOES match the console's, so find
+		 * the right one...
+		 */
+		for (hose = hose_head; hose; hose = hose->next) {
+			if (hose->index == h) break;
+		}
+
+		if (hose) {
+			printk("Console graphics on hose %d\n", h);
+			pci_vga_hose = hose;
+		}
+	}
+}
+
 #endif
diff -puN arch/alpha/kernel/core_marvel.c~alpha-support-graphics-on-non-zero-pci-domains arch/alpha/kernel/core_marvel.c
--- a/arch/alpha/kernel/core_marvel.c~alpha-support-graphics-on-non-zero-pci-domains
+++ a/arch/alpha/kernel/core_marvel.c
@@ -25,6 +25,7 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/rtc.h>
+#include <asm/vga.h>
 
 #include "proto.h"
 #include "pci_impl.h"
@@ -367,9 +368,8 @@ marvel_io7_present(gct6_node *node)
 }
 
 static void __init
-marvel_init_vga_hose(void)
+marvel_find_console_vga_hose(void)
 {
-#ifdef CONFIG_VGA_HOSE
 	u64 *pu64 = (u64 *)((u64)hwrpb + hwrpb->ctbt_offset);
 
 	if (pu64[7] == 3) {	/* TERM_TYPE == graphics */
@@ -403,7 +403,6 @@ marvel_init_vga_hose(void)
 			pci_vga_hose = hose;
 		}
 	}
-#endif /* CONFIG_VGA_HOSE */
 }
 
 gct6_search_struct gct_wanted_node_list[] = {
@@ -459,7 +458,7 @@ marvel_init_arch(void)
 		marvel_init_io7(io7);
 
 	/* Check for graphic console location (if any).  */
-	marvel_init_vga_hose();
+	marvel_find_console_vga_hose();
 }
 
 void
@@ -684,9 +683,6 @@ __marvel_rtc_io(u8 b, unsigned long addr
 /*
  * IO map support.
  */
-
-#define __marvel_is_mem_vga(a)	(((a) >= 0xa0000) && ((a) <= 0xc0000))
-
 void __iomem *
 marvel_ioremap(unsigned long addr, unsigned long size)
 {
@@ -698,13 +694,9 @@ marvel_ioremap(unsigned long addr, unsig
 	unsigned long pfn;
 
 	/*
-	 * Adjust the addr.
+	 * Adjust the address.
 	 */ 
-#ifdef CONFIG_VGA_HOSE
-	if (pci_vga_hose && __marvel_is_mem_vga(addr)) {
-		addr += pci_vga_hose->mem_space->start;
-	}
-#endif
+	FIXUP_MEMADDR_VGA(addr);
 
 	/*
 	 * Find the hose.
@@ -781,7 +773,9 @@ marvel_ioremap(unsigned long addr, unsig
 		return (void __iomem *) vaddr;
 	}
 
-	return NULL;
+	/* Assume it was already a reasonable address */
+	vaddr = baddr + hose->mem_space->start;
+	return (void __iomem *) vaddr;
 }
 
 void
@@ -803,21 +797,12 @@ marvel_is_mmio(const volatile void __iom
 		return (addr & 0xFF000000UL) == 0;
 }
 
-#define __marvel_is_port_vga(a)	\
-  (((a) >= 0x3b0) && ((a) < 0x3e0) && ((a) != 0x3b3) && ((a) != 0x3d3))
 #define __marvel_is_port_kbd(a)	(((a) == 0x60) || ((a) == 0x64))
 #define __marvel_is_port_rtc(a)	(((a) == 0x70) || ((a) == 0x71))
 
 void __iomem *marvel_ioportmap (unsigned long addr)
 {
-	if (__marvel_is_port_rtc (addr) || __marvel_is_port_kbd(addr))
-		;
-#ifdef CONFIG_VGA_HOSE
-	else if (__marvel_is_port_vga (addr) && pci_vga_hose)
-		addr += pci_vga_hose->io_space->start;
-#endif
-	else
-		return NULL;
+	FIXUP_IOADDR_VGA(addr);
 	return (void __iomem *)addr;
 }
 
@@ -829,8 +814,14 @@ marvel_ioread8(void __iomem *xaddr)
 		return 0;
 	else if (__marvel_is_port_rtc(addr))
 		return __marvel_rtc_io(0, addr, 0);
-	else
+	else if (marvel_is_ioaddr(addr))
 		return __kernel_ldbu(*(vucp)addr);
+	else
+		/* this should catch other legacy addresses
+		   that would normally fail on MARVEL,
+		   because there really is nothing there...
+		*/
+		return ~0;
 }
 
 void
@@ -841,7 +832,7 @@ marvel_iowrite8(u8 b, void __iomem *xadd
 		return;
 	else if (__marvel_is_port_rtc(addr)) 
 		__marvel_rtc_io(b, addr, 1);
-	else
+	else if (marvel_is_ioaddr(addr))
 		__kernel_stb(b, *(vucp)addr);
 }
 
diff -puN arch/alpha/kernel/core_titan.c~alpha-support-graphics-on-non-zero-pci-domains arch/alpha/kernel/core_titan.c
--- a/arch/alpha/kernel/core_titan.c~alpha-support-graphics-on-non-zero-pci-domains
+++ a/arch/alpha/kernel/core_titan.c
@@ -21,6 +21,7 @@
 #include <asm/smp.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
+#include <asm/vga.h>
 
 #include "proto.h"
 #include "pci_impl.h"
@@ -35,6 +36,11 @@ struct
 } saved_config[4] __attribute__((common));
 
 /*
+ * Is PChip 1 present? No need to query it more than once.
+ */
+static int titan_pchip1_present;
+
+/*
  * BIOS32-style PCI interface:
  */
 
@@ -344,43 +350,17 @@ titan_init_one_pachip_port(titan_pachip_
 static void __init
 titan_init_pachips(titan_pachip *pachip0, titan_pachip *pachip1)
 {
-	int pchip1_present = TITAN_cchip->csc.csr & 1L<<14;
+	titan_pchip1_present = TITAN_cchip->csc.csr & 1L<<14;
 
 	/* Init the ports in hose order... */
 	titan_init_one_pachip_port(&pachip0->g_port, 0);	/* hose 0 */
-	if (pchip1_present)
+	if (titan_pchip1_present)
 		titan_init_one_pachip_port(&pachip1->g_port, 1);/* hose 1 */
 	titan_init_one_pachip_port(&pachip0->a_port, 2);	/* hose 2 */
-	if (pchip1_present)
+	if (titan_pchip1_present)
 		titan_init_one_pachip_port(&pachip1->a_port, 3);/* hose 3 */
 }
 
-static void __init
-titan_init_vga_hose(void)
-{
-#ifdef CONFIG_VGA_HOSE
-	u64 *pu64 = (u64 *)((u64)hwrpb + hwrpb->ctbt_offset);
-
-	if (pu64[7] == 3) {	/* TERM_TYPE == graphics */
-		struct pci_controller *hose;
-		int h = (pu64[30] >> 24) & 0xff;	/* console hose # */
-
-		/*
-		 * Our hose numbering matches the console's, so just find
-		 * the right one...
-		 */
-		for (hose = hose_head; hose; hose = hose->next) {
-			if (hose->index == h) break;
-		}
-
-		if (hose) {
-			printk("Console graphics on hose %d\n", hose->index);
-			pci_vga_hose = hose;
-		}
-	}
-#endif /* CONFIG_VGA_HOSE */
-}
-
 void __init
 titan_init_arch(void)
 {
@@ -406,6 +386,7 @@ titan_init_arch(void)
 
 	/* With multiple PCI busses, we play with I/O as physical addrs.  */
 	ioport_resource.end = ~0UL;
+	iomem_resource.end = ~0UL;
 
 	/* PCI DMA Direct Mapping is 1GB at 2GB.  */
 	__direct_map_base = 0x80000000;
@@ -415,7 +396,7 @@ titan_init_arch(void)
 	titan_init_pachips(TITAN_pachip0, TITAN_pachip1);
 
 	/* Check for graphic console location (if any).  */
-	titan_init_vga_hose();
+	find_console_vga_hose();
 }
 
 static void
@@ -441,9 +422,7 @@ titan_kill_one_pachip_port(titan_pachip_
 static void
 titan_kill_pachips(titan_pachip *pachip0, titan_pachip *pachip1)
 {
-	int pchip1_present = TITAN_cchip->csc.csr & 1L<<14;
-
-	if (pchip1_present) {
+	if (titan_pchip1_present) {
 		titan_kill_one_pachip_port(&pachip1->g_port, 1);
 		titan_kill_one_pachip_port(&pachip1->a_port, 3);
 	}
@@ -463,6 +442,14 @@ titan_kill_arch(int mode)
  */
 
 void __iomem *
+titan_ioportmap(unsigned long addr)
+{
+	FIXUP_IOADDR_VGA(addr);
+	return (void __iomem *)(addr + TITAN_IO_BIAS);
+}
+
+
+void __iomem *
 titan_ioremap(unsigned long addr, unsigned long size)
 {
 	int h = (addr & TITAN_HOSE_MASK) >> TITAN_HOSE_SHIFT;
@@ -475,14 +462,12 @@ titan_ioremap(unsigned long addr, unsign
 	unsigned long pfn;
 
 	/*
-	 * Adjust the addr.
+	 * Adjust the address and hose, if necessary.
 	 */ 
-#ifdef CONFIG_VGA_HOSE
-	if (pci_vga_hose && __titan_is_mem_vga(addr)) {
+	if (pci_vga_hose && __is_mem_vga(addr)) {
 		h = pci_vga_hose->index;
 		addr += pci_vga_hose->mem_space->start;
 	}
-#endif
 
 	/*
 	 * Find the hose.
@@ -521,8 +506,10 @@ titan_ioremap(unsigned long addr, unsign
 		 * Map it
 		 */
 		area = get_vm_area(size, VM_IOREMAP);
-		if (!area)
+		if (!area) {
+			printk("ioremap failed... no vm_area...\n");
 			return NULL;
+		}
 
 		ptes = hose->sg_pci->ptes;
 		for (vaddr = (unsigned long)area->addr; 
@@ -539,7 +526,7 @@ titan_ioremap(unsigned long addr, unsign
 			if (__alpha_remap_area_pages(vaddr,
 						     pfn << PAGE_SHIFT, 
 						     PAGE_SIZE, 0)) {
-				printk("FAILED to map...\n");
+				printk("FAILED to remap_area_pages...\n");
 				vfree(area->addr);
 				return NULL;
 			}
@@ -551,7 +538,8 @@ titan_ioremap(unsigned long addr, unsign
 		return (void __iomem *) vaddr;
 	}
 
-	return NULL;
+	/* Assume a legacy (read: VGA) address, and return appropriately. */
+	return (void __iomem *)(addr + TITAN_MEM_BIAS);
 }
 
 void
@@ -574,6 +562,7 @@ titan_is_mmio(const volatile void __iome
 }
 
 #ifndef CONFIG_ALPHA_GENERIC
+EXPORT_SYMBOL(titan_ioportmap);
 EXPORT_SYMBOL(titan_ioremap);
 EXPORT_SYMBOL(titan_iounmap);
 EXPORT_SYMBOL(titan_is_mmio);
@@ -750,6 +739,7 @@ titan_agp_info(void)
 	if (titan_query_agp(port))
 		hosenum = 2;
 	if (hosenum < 0 && 
+	    titan_pchip1_present &&
 	    titan_query_agp(port = &TITAN_pachip1->a_port)) 
 		hosenum = 3;
 	
diff -puN arch/alpha/kernel/core_tsunami.c~alpha-support-graphics-on-non-zero-pci-domains arch/alpha/kernel/core_tsunami.c
--- a/arch/alpha/kernel/core_tsunami.c~alpha-support-graphics-on-non-zero-pci-domains
+++ a/arch/alpha/kernel/core_tsunami.c
@@ -19,6 +19,7 @@
 
 #include <asm/ptrace.h>
 #include <asm/smp.h>
+#include <asm/vga.h>
 
 #include "proto.h"
 #include "pci_impl.h"
@@ -349,6 +350,26 @@ tsunami_init_one_pchip(tsunami_pchip *pc
 	tsunami_pci_tbi(hose, 0, -1);
 }
 
+
+void __iomem *
+tsunami_ioportmap(unsigned long addr)
+{
+	FIXUP_IOADDR_VGA(addr);
+	return (void __iomem *)(addr + TSUNAMI_IO_BIAS);
+}
+
+void __iomem *
+tsunami_ioremap(unsigned long addr, unsigned long size)
+{
+	FIXUP_MEMADDR_VGA(addr);
+	return (void __iomem *)(addr + TSUNAMI_MEM_BIAS);
+}
+
+#ifndef CONFIG_ALPHA_GENERIC
+EXPORT_SYMBOL(tsunami_ioportmap);
+EXPORT_SYMBOL(tsunami_ioremap);
+#endif
+
 void __init
 tsunami_init_arch(void)
 {
@@ -393,6 +414,9 @@ tsunami_init_arch(void)
 	tsunami_init_one_pchip(TSUNAMI_pchip0, 0);
 	if (TSUNAMI_cchip->csc.csr & 1L<<14)
 		tsunami_init_one_pchip(TSUNAMI_pchip1, 1);
+
+	/* Check for graphic console location (if any).  */
+	find_console_vga_hose();
 }
 
 static void
diff -puN arch/alpha/kernel/proto.h~alpha-support-graphics-on-non-zero-pci-domains arch/alpha/kernel/proto.h
--- a/arch/alpha/kernel/proto.h~alpha-support-graphics-on-non-zero-pci-domains
+++ a/arch/alpha/kernel/proto.h
@@ -108,6 +108,15 @@ extern int wildfire_cpuid_to_nid(int);
 extern unsigned long wildfire_node_mem_start(int);
 extern unsigned long wildfire_node_mem_size(int);
 
+/* console.c */
+#ifdef CONFIG_VGA_HOSE
+extern void find_console_vga_hose(void);
+extern void locate_and_init_vga(void *(*)(void *, void *));
+#else
+static inline void find_console_vga_hose(void) { }
+static inline void locate_and_init_vga(void *(*sel_func)(void *, void *)) { }
+#endif
+
 /* setup.c */
 extern unsigned long srm_hae;
 extern int boot_cpuid;
diff -puN arch/alpha/kernel/sys_dp264.c~alpha-support-graphics-on-non-zero-pci-domains arch/alpha/kernel/sys_dp264.c
--- a/arch/alpha/kernel/sys_dp264.c~alpha-support-graphics-on-non-zero-pci-domains
+++ a/arch/alpha/kernel/sys_dp264.c
@@ -543,6 +543,7 @@ dp264_init_pci(void)
 {
 	common_init_pci();
 	SMC669_Init(0);
+	locate_and_init_vga(NULL);
 }
 
 static void __init
@@ -551,6 +552,14 @@ monet_init_pci(void)
 	common_init_pci();
 	SMC669_Init(1);
 	es1888_init();
+	locate_and_init_vga(NULL);
+}
+
+static void __init
+clipper_init_pci(void)
+{
+	common_init_pci();
+	locate_and_init_vga(NULL);
 }
 
 static void __init
@@ -655,7 +664,7 @@ struct alpha_machine_vector clipper_mv _
 	.init_arch		= tsunami_init_arch,
 	.init_irq		= clipper_init_irq,
 	.init_rtc		= common_init_rtc,
-	.init_pci		= common_init_pci,
+	.init_pci		= clipper_init_pci,
 	.kill_arch		= tsunami_kill_arch,
 	.pci_map_irq		= clipper_map_irq,
 	.pci_swizzle		= common_swizzle,
diff -puN arch/alpha/kernel/sys_marvel.c~alpha-support-graphics-on-non-zero-pci-domains arch/alpha/kernel/sys_marvel.c
--- a/arch/alpha/kernel/sys_marvel.c~alpha-support-graphics-on-non-zero-pci-domains
+++ a/arch/alpha/kernel/sys_marvel.c
@@ -22,6 +22,7 @@
 #include <asm/core_marvel.h>
 #include <asm/hwrpb.h>
 #include <asm/tlbflush.h>
+#include <asm/vga.h>
 
 #include "proto.h"
 #include "err_impl.h"
@@ -412,10 +413,7 @@ marvel_init_pci(void)
 
 	pci_probe_only = 1;
 	common_init_pci();
-
-#ifdef CONFIG_VGA_HOSE
 	locate_and_init_vga(NULL);
-#endif
 
 	/* Clear any io7 errors.  */
 	for (io7 = NULL; (io7 = marvel_next_io7(io7)) != NULL; ) 
diff -puN arch/alpha/kernel/sys_titan.c~alpha-support-graphics-on-non-zero-pci-domains arch/alpha/kernel/sys_titan.c
--- a/arch/alpha/kernel/sys_titan.c~alpha-support-graphics-on-non-zero-pci-domains
+++ a/arch/alpha/kernel/sys_titan.c
@@ -331,9 +331,7 @@ titan_init_pci(void)
 	pci_probe_only = 1;
 	common_init_pci();
 	SMC669_Init(0);
-#ifdef CONFIG_VGA_HOSE
 	locate_and_init_vga(NULL);
-#endif
 }
 
 
diff -puN include/asm-alpha/core_titan.h~alpha-support-graphics-on-non-zero-pci-domains include/asm-alpha/core_titan.h
--- a/include/asm-alpha/core_titan.h~alpha-support-graphics-on-non-zero-pci-domains
+++ a/include/asm-alpha/core_titan.h
@@ -380,12 +380,7 @@ struct el_PRIVATEER_envdata_mcheck {
 /*
  * Memory functions.  all accesses are done through linear space.
  */
-
-__EXTERN_INLINE void __iomem *titan_ioportmap(unsigned long addr)
-{
-	return (void __iomem *)(addr + TITAN_IO_BIAS);
-}
-
+extern void __iomem *titan_ioportmap(unsigned long addr);
 extern void __iomem *titan_ioremap(unsigned long addr, unsigned long size);
 extern void titan_iounmap(volatile void __iomem *addr);
 
diff -puN include/asm-alpha/core_tsunami.h~alpha-support-graphics-on-non-zero-pci-domains include/asm-alpha/core_tsunami.h
--- a/include/asm-alpha/core_tsunami.h~alpha-support-graphics-on-non-zero-pci-domains
+++ a/include/asm-alpha/core_tsunami.h
@@ -2,6 +2,7 @@
 #define __ALPHA_TSUNAMI__H__
 
 #include <linux/types.h>
+#include <linux/pci.h>
 #include <asm/compiler.h>
 
 /*
@@ -302,18 +303,8 @@ struct el_TSUNAMI_sysdata_mcheck {
 /*
  * Memory functions.  all accesses are done through linear space.
  */
-
-__EXTERN_INLINE void __iomem *tsunami_ioportmap(unsigned long addr)
-{
-	return (void __iomem *)(addr + TSUNAMI_IO_BIAS);
-}
-
-__EXTERN_INLINE void __iomem *tsunami_ioremap(unsigned long addr, 
-					      unsigned long size)
-{
-	return (void __iomem *)(addr + TSUNAMI_MEM_BIAS);
-}
-
+extern void __iomem *tsunami_ioportmap(unsigned long addr);
+extern void __iomem *tsunami_ioremap(unsigned long addr, unsigned long size);
 __EXTERN_INLINE int tsunami_is_ioaddr(unsigned long addr)
 {
 	return addr >= TSUNAMI_BASE;
diff -puN include/asm-alpha/vga.h~alpha-support-graphics-on-non-zero-pci-domains include/asm-alpha/vga.h
--- a/include/asm-alpha/vga.h~alpha-support-graphics-on-non-zero-pci-domains
+++ a/include/asm-alpha/vga.h
@@ -46,6 +46,37 @@ extern void scr_memcpyw(u16 *d, const u1
 #define vga_readb(a)	readb((u8 __iomem *)(a))
 #define vga_writeb(v,a)	writeb(v, (u8 __iomem *)(a))
 
+#ifdef CONFIG_VGA_HOSE
+#include <linux/ioport.h>
+#include <linux/pci.h>
+
+extern struct pci_controller *pci_vga_hose;
+
+# define __is_port_vga(a)       \
+	(((a) >= 0x3b0) && ((a) < 0x3e0) && \
+	 ((a) != 0x3b3) && ((a) != 0x3d3))
+
+# define __is_mem_vga(a) \
+	(((a) >= 0xa0000) && ((a) <= 0xc0000))
+
+# define FIXUP_IOADDR_VGA(a) do {                       \
+	if (pci_vga_hose && __is_port_vga(a))     \
+		(a) += pci_vga_hose->io_space->start;	  \
+ } while(0)
+
+# define FIXUP_MEMADDR_VGA(a) do {                       \
+	if (pci_vga_hose && __is_mem_vga(a))     \
+		(a) += pci_vga_hose->mem_space->start; \
+ } while(0)
+
+#else /* CONFIG_VGA_HOSE */
+# define pci_vga_hose 0
+# define __is_port_vga(a) 0
+# define __is_mem_vga(a) 0
+# define FIXUP_IOADDR_VGA(a)
+# define FIXUP_MEMADDR_VGA(a)
+#endif /* CONFIG_VGA_HOSE */
+
 #define VGA_MAP_MEM(x,s)	((unsigned long) ioremap(x, s))
 
 #endif
_

Patches currently in -mm which might be from jay.estabrook@hp.com are

origin.patch
