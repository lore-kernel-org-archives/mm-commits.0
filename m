From: akpm@linux-foundation.org
Subject: + alpha-fixes-for-specific-machine-types.patch added to -mm tree
Date: Wed, 11 Apr 2007 12:58:05 -0700
Message-ID: <200704111958.l3BJw6Zx012997@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:58440 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030339AbXDKT6L (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 15:58:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ink@jurassic.park.msu.ru, jay.estabrook@hp.com, rth@twiddle.net


The patch titled
     ALPHA: fixes for specific machine types
has been added to the -mm tree.  Its filename is
     alpha-fixes-for-specific-machine-types.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ALPHA: fixes for specific machine types
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>

Files:

arch/alpha/kernel/core_mcpcia.c
arch/alpha/kernel/sys_rawhide.c
include/asm-alpha/core_mcpcia.h

	Determine correct hose configuration; RAWHIDE family can have
        2 or 4 hoses, so make sure non-existent hoses are ignored.

arch/alpha/kernel/err_titan.c

	Supply a needed #include <asm/irq_regs.h>

arch/alpha/kernel/module.c

	Add some useful output to the relocation overflow messages.

arch/alpha/kernel/sys_noritake.c

	Supply necessary noritake_end_irq() to correct interrupt handling.
	This fixes a problem first noted by hangs during boot probing with
	a DE500-BA TULIP NIC present.

arch/alpha/kernel/sys_sio.c

	Correct saving of original PIRQ register (PCI IRQ routing);
	change default PIRQ setting to leave PCI IRQs 9 and 14 free to
	be used for sound (Multia) and IDE (any), respectively.

include/asm-alpha/io.h

	Supply the "isa_virt_to_bus" routine.

Signed-off-by: Jay Estabrook <jay.estabrook@hp.com>
Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/kernel/core_mcpcia.c  |    2 --
 arch/alpha/kernel/err_titan.c    |    1 +
 arch/alpha/kernel/module.c       |    8 ++++----
 arch/alpha/kernel/sys_noritake.c |    9 ++++++++-
 arch/alpha/kernel/sys_rawhide.c  |   15 +++++++++++++++
 arch/alpha/kernel/sys_sio.c      |   14 +++++++++-----
 include/asm-alpha/core_mcpcia.h  |    2 ++
 include/asm-alpha/io.h           |    1 +
 8 files changed, 40 insertions(+), 12 deletions(-)

diff -puN arch/alpha/kernel/core_mcpcia.c~alpha-fixes-for-specific-machine-types arch/alpha/kernel/core_mcpcia.c
--- a/arch/alpha/kernel/core_mcpcia.c~alpha-fixes-for-specific-machine-types
+++ a/arch/alpha/kernel/core_mcpcia.c
@@ -40,8 +40,6 @@
 # define DBG_CFG(args)
 #endif
 
-#define MCPCIA_MAX_HOSES 4
-
 /*
  * Given a bus, device, and function number, compute resulting
  * configuration space address and setup the MCPCIA_HAXR2 register
diff -puN arch/alpha/kernel/err_titan.c~alpha-fixes-for-specific-machine-types arch/alpha/kernel/err_titan.c
--- a/arch/alpha/kernel/err_titan.c~alpha-fixes-for-specific-machine-types
+++ a/arch/alpha/kernel/err_titan.c
@@ -16,6 +16,7 @@
 #include <asm/smp.h>
 #include <asm/err_common.h>
 #include <asm/err_ev6.h>
+#include <asm/irq_regs.h>
 
 #include "err_impl.h"
 #include "proto.h"
diff -puN arch/alpha/kernel/module.c~alpha-fixes-for-specific-machine-types arch/alpha/kernel/module.c
--- a/arch/alpha/kernel/module.c~alpha-fixes-for-specific-machine-types
+++ a/arch/alpha/kernel/module.c
@@ -285,12 +285,12 @@ apply_relocate_add(Elf64_Shdr *sechdrs, 
 		reloc_overflow:
 			if (ELF64_ST_TYPE (sym->st_info) == STT_SECTION)
 			  printk(KERN_ERR
-			         "module %s: Relocation overflow vs section %d\n",
-			         me->name, sym->st_shndx);
+			         "module %s: Relocation (type %lu) overflow vs section %d\n",
+			         me->name, r_type, sym->st_shndx);
 			else
 			  printk(KERN_ERR
-			         "module %s: Relocation overflow vs %s\n",
-			         me->name, strtab + sym->st_name);
+			         "module %s: Relocation (type %lu) overflow vs %s\n",
+			         me->name, r_type, strtab + sym->st_name);
 			return -ENOEXEC;
 		}
 	}
diff -puN arch/alpha/kernel/sys_noritake.c~alpha-fixes-for-specific-machine-types arch/alpha/kernel/sys_noritake.c
--- a/arch/alpha/kernel/sys_noritake.c~alpha-fixes-for-specific-machine-types
+++ a/arch/alpha/kernel/sys_noritake.c
@@ -66,6 +66,13 @@ noritake_startup_irq(unsigned int irq)
 	return 0;
 }
 
+static void
+noritake_end_irq(unsigned int irq)
+{
+        if (!(irq_desc[irq].status & (IRQ_DISABLED|IRQ_INPROGRESS)))
+                noritake_enable_irq(irq);
+}
+
 static struct hw_interrupt_type noritake_irq_type = {
 	.typename	= "NORITAKE",
 	.startup	= noritake_startup_irq,
@@ -73,7 +80,7 @@ static struct hw_interrupt_type noritake
 	.enable		= noritake_enable_irq,
 	.disable	= noritake_disable_irq,
 	.ack		= noritake_disable_irq,
-	.end		= noritake_enable_irq,
+	.end		= noritake_end_irq,
 };
 
 static void 
diff -puN arch/alpha/kernel/sys_rawhide.c~alpha-fixes-for-specific-machine-types arch/alpha/kernel/sys_rawhide.c
--- a/arch/alpha/kernel/sys_rawhide.c~alpha-fixes-for-specific-machine-types
+++ a/arch/alpha/kernel/sys_rawhide.c
@@ -52,6 +52,9 @@ rawhide_update_irq_hw(int hose, int mask
 	*(vuip)MCPCIA_INT_MASK0(MCPCIA_HOSE2MID(hose));
 }
 
+#define hose_exists(h) \
+  (((h) < MCPCIA_MAX_HOSES) && (cached_irq_masks[(h)] != 0))
+
 static inline void 
 rawhide_enable_irq(unsigned int irq)
 {
@@ -59,6 +62,9 @@ rawhide_enable_irq(unsigned int irq)
 
 	irq -= 16;
 	hose = irq / 24;
+	if (!hose_exists(hose)) /* if hose non-existent, exit */
+		return;
+
 	irq -= hose * 24;
 	mask = 1 << irq;
 
@@ -76,6 +82,9 @@ rawhide_disable_irq(unsigned int irq)
 
 	irq -= 16;
 	hose = irq / 24;
+	if (!hose_exists(hose)) /* if hose non-existent, exit */
+		return;
+
 	irq -= hose * 24;
 	mask = ~(1 << irq) | hose_irq_masks[hose];
 
@@ -93,6 +102,9 @@ rawhide_mask_and_ack_irq(unsigned int ir
 
 	irq -= 16;
 	hose = irq / 24;
+	if (!hose_exists(hose)) /* if hose non-existent, exit */
+		return;
+
 	irq -= hose * 24;
 	mask1 = 1 << irq;
 	mask = ~mask1 | hose_irq_masks[hose];
@@ -169,6 +181,9 @@ rawhide_init_irq(void)
 
 	mcpcia_init_hoses();
 
+	/* Clear them all; only hoses that exist will be non-zero. */
+	for (i = 0; i < MCPCIA_MAX_HOSES; i++) cached_irq_masks[i] = 0;
+
 	for (hose = hose_head; hose; hose = hose->next) {
 		unsigned int h = hose->index;
 		unsigned int mask = hose_irq_masks[h];
diff -puN arch/alpha/kernel/sys_sio.c~alpha-fixes-for-specific-machine-types arch/alpha/kernel/sys_sio.c
--- a/arch/alpha/kernel/sys_sio.c~alpha-fixes-for-specific-machine-types
+++ a/arch/alpha/kernel/sys_sio.c
@@ -84,12 +84,16 @@ alphabook1_init_arch(void)
 static void __init
 sio_pci_route(void)
 {
-#if defined(ALPHA_RESTORE_SRM_SETUP)
-	/* First, read and save the original setting. */
+	unsigned int orig_route_tab;
+
+	/* First, ALWAYS read and print the original setting. */
 	pci_bus_read_config_dword(pci_isa_hose->bus, PCI_DEVFN(7, 0), 0x60,
-				  &saved_config.orig_route_tab);
+				  &orig_route_tab);
 	printk("%s: PIRQ original 0x%x new 0x%x\n", __FUNCTION__,
-	       saved_config.orig_route_tab, alpha_mv.sys.sio.route_tab);
+	       orig_route_tab, alpha_mv.sys.sio.route_tab);
+
+#if defined(ALPHA_RESTORE_SRM_SETUP)
+	saved_config.orig_route_tab = orig_route_tab;
 #endif
 
 	/* Now override with desired setting. */
@@ -334,7 +338,7 @@ struct alpha_machine_vector avanti_mv __
 	.pci_swizzle		= common_swizzle,
 
 	.sys = { .sio = {
-		.route_tab	= 0x0b0a0e0f,
+		.route_tab	= 0x0b0a050f, /* leave 14 for IDE, 9 for SND */
 	}}
 };
 ALIAS_MV(avanti)
diff -puN include/asm-alpha/core_mcpcia.h~alpha-fixes-for-specific-machine-types include/asm-alpha/core_mcpcia.h
--- a/include/asm-alpha/core_mcpcia.h~alpha-fixes-for-specific-machine-types
+++ a/include/asm-alpha/core_mcpcia.h
@@ -72,6 +72,8 @@
  *
  */
 
+#define MCPCIA_MAX_HOSES 4
+
 #define MCPCIA_MID(m)		((unsigned long)(m) << 33)
 
 /* Dodge has PCI0 and PCI1 at MID 4 and 5 respectively. 
diff -puN include/asm-alpha/io.h~alpha-fixes-for-specific-machine-types include/asm-alpha/io.h
--- a/include/asm-alpha/io.h~alpha-fixes-for-specific-machine-types
+++ a/include/asm-alpha/io.h
@@ -113,6 +113,7 @@ static inline unsigned long virt_to_bus(
 	unsigned long bus = phys + __direct_map_base;
 	return phys <= __direct_map_size ? bus : 0;
 }
+#define isa_virt_to_bus virt_to_bus
 
 static inline void *bus_to_virt(unsigned long address)
 {
_

Patches currently in -mm which might be from ink@jurassic.park.msu.ru are

account-for-module-percpu-space-separately-from-kernel.patch
round_up-macro-cleanup-in-arch-alpha-kernel-osf_sysc.patch
alpha-fix-bootp-image-creation.patch
alpha-prctl-macros.patch
alpha-fixes-for-specific-machine-types.patch
alpha-more-fixes-for-specific-machine-types.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
fixes-and-cleanups-for-earlyprintk-aka-boot-console.patch
lutimesat-extend-do_utimes-with-flags.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
local_t-alpha-extension.patch
markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
make-sure-nobodys-leaking-resources.patch
