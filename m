From: akpm@osdl.org
Subject: + mips-turbochannel-support-for-the-decstation.patch added to -mm tree
Date: Wed, 20 Dec 2006 20:57:54 -0800
Message-ID: <200612210457.kBL4vs6u016086@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:38082 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422717AbWLUE6C (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Dec 2006 23:58:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: macro@linux-mips.org, ralf@linux-mips.org


The patch titled
     mips: TURBOchannel support for the DECstation
has been added to the -mm tree.  Its filename is
     mips-turbochannel-support-for-the-decstation.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mips: TURBOchannel support for the DECstation
From: "Maciej W. Rozycki" <macro@linux-mips.org>

This is the platform-specific part of TURBOchannel bus support for the
DECstation.  It implements determining whether the bus is actually there,
getting bus parameters, IRQ assignments for devices and protected accesses to
possibly unoccupied slots that may trigger bus error exceptions.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/mips/dec/Makefile        |    1 
 arch/mips/dec/prom/identify.c |    3 +
 arch/mips/dec/setup.c         |    2 
 arch/mips/dec/tc.c            |   95 ++++++++++++++++++++++++++++++++
 include/asm-mips/dec/system.h |    3 -
 5 files changed, 103 insertions(+), 1 deletion(-)

diff -puN arch/mips/dec/Makefile~mips-turbochannel-support-for-the-decstation arch/mips/dec/Makefile
--- a/arch/mips/dec/Makefile~mips-turbochannel-support-for-the-decstation
+++ a/arch/mips/dec/Makefile
@@ -6,6 +6,7 @@ obj-y		:= ecc-berr.o int-handler.o ioasi
 		   kn02-irq.o kn02xa-berr.o reset.o setup.o time.o
 
 obj-$(CONFIG_PROM_CONSOLE)	+= promcon.o
+obj-$(CONFIG_TC)		+= tc.o
 obj-$(CONFIG_CPU_HAS_WB)	+= wbflush.o
 
 EXTRA_AFLAGS := $(CFLAGS)
diff -puN arch/mips/dec/prom/identify.c~mips-turbochannel-support-for-the-decstation arch/mips/dec/prom/identify.c
--- a/arch/mips/dec/prom/identify.c~mips-turbochannel-support-for-the-decstation
+++ a/arch/mips/dec/prom/identify.c
@@ -88,6 +88,7 @@ static inline void prom_init_kn02(void)
 {
 	dec_kn_slot_base = KN02_SLOT_BASE;
 	dec_kn_slot_size = KN02_SLOT_SIZE;
+	dec_tc_bus = 1;
 
 	dec_rtc_base = (void *)CKSEG1ADDR(dec_kn_slot_base + KN02_RTC);
 }
@@ -96,6 +97,7 @@ static inline void prom_init_kn02xa(void
 {
 	dec_kn_slot_base = KN02XA_SLOT_BASE;
 	dec_kn_slot_size = IOASIC_SLOT_SIZE;
+	dec_tc_bus = 1;
 
 	ioasic_base = (void *)CKSEG1ADDR(dec_kn_slot_base + IOASIC_IOCTL);
 	dec_rtc_base = (void *)CKSEG1ADDR(dec_kn_slot_base + IOASIC_TOY);
@@ -105,6 +107,7 @@ static inline void prom_init_kn03(void)
 {
 	dec_kn_slot_base = KN03_SLOT_BASE;
 	dec_kn_slot_size = IOASIC_SLOT_SIZE;
+	dec_tc_bus = 1;
 
 	ioasic_base = (void *)CKSEG1ADDR(dec_kn_slot_base + IOASIC_IOCTL);
 	dec_rtc_base = (void *)CKSEG1ADDR(dec_kn_slot_base + IOASIC_TOY);
diff -puN arch/mips/dec/setup.c~mips-turbochannel-support-for-the-decstation arch/mips/dec/setup.c
--- a/arch/mips/dec/setup.c~mips-turbochannel-support-for-the-decstation
+++ a/arch/mips/dec/setup.c
@@ -53,6 +53,8 @@ unsigned long dec_kn_slot_base, dec_kn_s
 EXPORT_SYMBOL(dec_kn_slot_base);
 EXPORT_SYMBOL(dec_kn_slot_size);
 
+int dec_tc_bus;
+
 spinlock_t ioasic_ssr_lock;
 
 volatile u32 *ioasic_base;
diff -puN /dev/null arch/mips/dec/tc.c
--- /dev/null
+++ a/arch/mips/dec/tc.c
@@ -0,0 +1,95 @@
+/*
+ *	TURBOchannel architecture calls.
+ *
+ *	Copyright (c) Harald Koerfgen, 1998
+ *	Copyright (c) 2001, 2003, 2005, 2006  Maciej W. Rozycki
+ *	Copyright (c) 2005  James Simmons
+ *
+ *	This file is subject to the terms and conditions of the GNU
+ *	General Public License.  See the file "COPYING" in the main
+ *	directory of this archive for more details.
+ */
+#include <linux/compiler.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/tc.h>
+#include <linux/types.h>
+
+#include <asm/addrspace.h>
+#include <asm/bootinfo.h>
+#include <asm/paccess.h>
+
+#include <asm/dec/interrupts.h>
+#include <asm/dec/prom.h>
+#include <asm/dec/system.h>
+
+/*
+ * Protected read byte from TURBOchannel slot space.
+ */
+int tc_preadb(u8 *valp, void __iomem *addr)
+{
+	return get_dbe(*valp, (u8 *)addr);
+}
+
+/*
+ * Get TURBOchannel bus information as specified by the spec, plus
+ * the slot space base address and the number of slots.
+ */
+int __init tc_bus_get_info(struct tc_bus *tbus)
+{
+	if (!dec_tc_bus)
+		return -ENXIO;
+
+	memcpy(&tbus->info, rex_gettcinfo(), sizeof(tbus->info));
+	tbus->slot_base = CPHYSADDR((long)rex_slot_address(0));
+
+	switch (mips_machtype) {
+	case MACH_DS5000_200:
+		tbus->num_tcslots = 7;
+		break;
+	case MACH_DS5000_2X0:
+	case MACH_DS5900:
+		tbus->ext_slot_base = 0x20000000;
+		tbus->ext_slot_size = 0x20000000;
+		/* fall through */
+	case MACH_DS5000_1XX:
+		tbus->num_tcslots = 3;
+		break;
+	case MACH_DS5000_XX:
+		tbus->num_tcslots = 2;
+	default:
+		break;
+	}
+	return 0;
+}
+
+/*
+ * Get the IRQ for the specified slot.
+ */
+void __init tc_device_get_irq(struct tc_dev *tdev)
+{
+	switch (tdev->slot) {
+	case 0:
+		tdev->interrupt = dec_interrupt[DEC_IRQ_TC0];
+		break;
+	case 1:
+		tdev->interrupt = dec_interrupt[DEC_IRQ_TC1];
+		break;
+	case 2:
+		tdev->interrupt = dec_interrupt[DEC_IRQ_TC2];
+		break;
+	/*
+	 * Yuck! DS5000/200 onboard devices
+	 */
+	case 5:
+		tdev->interrupt = dec_interrupt[DEC_IRQ_TC5];
+		break;
+	case 6:
+		tdev->interrupt = dec_interrupt[DEC_IRQ_TC6];
+		break;
+	default:
+		tdev->interrupt = -1;
+		break;
+	}
+}
diff -puN include/asm-mips/dec/system.h~mips-turbochannel-support-for-the-decstation include/asm-mips/dec/system.h
--- a/include/asm-mips/dec/system.h~mips-turbochannel-support-for-the-decstation
+++ a/include/asm-mips/dec/system.h
@@ -3,7 +3,7 @@
  *
  *	Generic DECstation/DECsystem bits.
  *
- *	Copyright (C) 2005  Maciej W. Rozycki
+ *	Copyright (C) 2005, 2006  Maciej W. Rozycki
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License
@@ -14,5 +14,6 @@
 #define __ASM_DEC_SYSTEM_H
 
 extern unsigned long dec_kn_slot_base, dec_kn_slot_size;
+extern int dec_tc_bus;
 
 #endif /* __ASM_DEC_SYSTEM_H */
_

Patches currently in -mm which might be from macro@linux-mips.org are

mips-if_fddih-add-a-missing-inclusion.patch
mips-turbochannel-update-to-the-driver-model.patch
mips-turbochannel-support-for-the-decstation.patch
mips-eisa-registration-with-config_eisa.patch
mips-declance-driver-model-for-the-pmad-a.patch
mips-pmag-ba-fb-convert-to-the-driver-model.patch
mips-pmagb-b-fb-convert-to-the-driver-model.patch
mips-dec_esp-driver-model-for-the-pmaz-a.patch
i386-io_apic-fix-a-typo-in-an-irq-handler-name.patch
tgafb-switch-to-framebuffer_alloc.patch
tgafb-fix-copying-overlapping-areas.patch
tgafb-support-the-directcolor-visual.patch
tgafb-fix-the-mode-register-setting.patch
tgafb-module-support-fixes.patch
tgafb-sync-on-green-support-fixes.patch
tgafb-fix-the-pci-id-table.patch

