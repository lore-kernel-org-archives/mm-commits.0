From: akpm@linux-foundation.org
Subject: + x86-serial-convert-legacy-com-ports-to-platform-devices.patch added to -mm tree
Date: Fri, 06 Apr 2007 17:21:08 -0700
Message-ID: <200704070021.l370L8oi023688@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40348 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933543AbXDGA3H (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 20:29:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bjorn.helgaas@hp.com, ambx1@neo.rr.com, castet.matthieu@free.fr, jt@hpl.hp.com, kaos@ocs.com.au, lenb@kernel.org, mjg59@srcf.ucam.org, rmk+serial@arm.linux.org.uk, samuel@sortiz.org, syrjala@sci.fi


The patch titled
     x86, serial: convert legacy COM ports to platform devices
has been added to the -mm tree.  Its filename is
     x86-serial-convert-legacy-com-ports-to-platform-devices.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86, serial: convert legacy COM ports to platform devices
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Make x86 COM ports into platform devices and don't probe for them
if we have PNP.

This prevents double discovery, where a device was found both by
the legacy probe and by 8250_pnp, e.g.,

    serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
    00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A

This also means IRDA devices without a UART PNP ID will no longer be
claimed by the serial driver, which might require changes in IRDA
drivers and administration.

In addition to this patch, you may need to configure a setserial init
script, e.g., /etc/init.d/setserial, so it doesn't poke legacy UART
stuff back in.  On Debian, "dpkg-reconfigure setserial" with the "kernel"
option does this.

To force the old legacy probe behavior even when we have PNPBIOS or
ACPI, load the new legacy_serial module (or build 8250 static) with
the "legacy_serial.force" option.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Keith Owens <kaos@ocs.com.au>
Cc: Len Brown <lenb@kernel.org>
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Matthieu CASTET <castet.matthieu@free.fr>
Cc: Jean Tourrilhes <jt@hpl.hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ville Syrjala <syrjala@sci.fi>
Cc: Russell King <rmk+serial@arm.linux.org.uk>
Cc: Samuel Ortiz <samuel@sortiz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +
 arch/i386/kernel/Makefile           |    1 
 arch/i386/kernel/legacy_serial.c    |   67 ++++++++++++++++++++++++++
 arch/x86_64/kernel/Makefile         |    1 
 drivers/serial/Kconfig              |   14 +++--
 include/asm-i386/serial.h           |   16 ------
 include/asm-x86_64/serial.h         |   16 ------
 7 files changed, 83 insertions(+), 37 deletions(-)

diff -puN Documentation/kernel-parameters.txt~x86-serial-convert-legacy-com-ports-to-platform-devices Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~x86-serial-convert-legacy-com-ports-to-platform-devices
+++ a/Documentation/kernel-parameters.txt
@@ -796,6 +796,11 @@ and is between 256 and 4096 characters. 
 	lasi=		[HW,SCSI] PARISC LASI driver for the 53c700 chip
 			Format: addr:<io>,irq:<irq>
 
+	legacy_serial.force [HW,IA-32,X86-64]
+			Probe for COM ports at legacy addresses even
+			if PNPBIOS or ACPI should describe them.  This
+			is for working around firmware defects.
+
 	llsc*=		[IA64] See function print_params() in
 			arch/ia64/sn/kernel/llsc4.c.
 
diff -puN arch/i386/kernel/Makefile~x86-serial-convert-legacy-com-ports-to-platform-devices arch/i386/kernel/Makefile
--- a/arch/i386/kernel/Makefile~x86-serial-convert-legacy-com-ports-to-platform-devices
+++ a/arch/i386/kernel/Makefile
@@ -35,6 +35,7 @@ obj-$(CONFIG_ACPI_SRAT) 	+= srat.o
 obj-$(CONFIG_EFI) 		+= efi.o efi_stub.o
 obj-$(CONFIG_MARKERS_ENABLE_OPTIMIZATION)	+= marker.o
 obj-$(CONFIG_DOUBLEFAULT) 	+= doublefault.o
+obj-$(CONFIG_SERIAL_8250)	+= legacy_serial.o
 obj-$(CONFIG_VM86)		+= vm86.o
 obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
diff -puN /dev/null arch/i386/kernel/legacy_serial.c
--- /dev/null
+++ a/arch/i386/kernel/legacy_serial.c
@@ -0,0 +1,67 @@
+/*
+ * Legacy COM port devices for x86 platforms without PNPBIOS or ACPI.
+ * Data taken from include/asm-i386/serial.h.
+ *
+ * (c) Copyright 2007 Hewlett-Packard Development Company, L.P.
+ *	Bjorn Helgaas <bjorn.helgaas@hp.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/pnp.h>
+#include <linux/serial_8250.h>
+
+/* Standard COM flags (except for COM4, because of the 8514 problem) */
+#ifdef CONFIG_SERIAL_DETECT_IRQ
+#define COM_FLAGS (UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_AUTO_IRQ)
+#define COM4_FLAGS (UPF_BOOT_AUTOCONF | UPF_AUTO_IRQ)
+#else
+#define COM_FLAGS (UPF_BOOT_AUTOCONF | UPF_SKIP_TEST)
+#define COM4_FLAGS UPF_BOOT_AUTOCONF
+#endif
+
+#define PORT(_base,_irq,_flags)				\
+	{						\
+		.iobase		= _base,		\
+		.irq		= _irq,			\
+		.uartclk	= 1843200,		\
+		.iotype		= UPIO_PORT,		\
+		.flags		= _flags,		\
+	}
+
+static struct plat_serial8250_port x86_com_data[] = {
+	PORT(0x3F8, 4, COM_FLAGS),
+	PORT(0x2F8, 3, COM_FLAGS),
+	PORT(0x3E8, 4, COM_FLAGS),
+	PORT(0x2E8, 3, COM4_FLAGS),
+	{ },
+};
+
+static struct platform_device x86_com_device = {
+	.name			= "serial8250",
+	.id			= PLAT8250_DEV_PLATFORM,
+	.dev			= {
+		.platform_data	= x86_com_data,
+	},
+};
+
+static int force_legacy_probe;
+module_param_named(force, force_legacy_probe, bool, 0);
+MODULE_PARM_DESC(force, "Force legacy serial port probe");
+
+static int __init serial8250_x86_com_init(void)
+{
+	if (pnp_platform_devices && !force_legacy_probe)
+		return -ENODEV;
+
+	return platform_device_register(&x86_com_device);
+}
+
+module_init(serial8250_x86_com_init);
+
+MODULE_AUTHOR("Bjorn Helgaas");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Generic 8250/16x50 legacy probe module");
diff -puN arch/x86_64/kernel/Makefile~x86-serial-convert-legacy-com-ports-to-platform-devices arch/x86_64/kernel/Makefile
--- a/arch/x86_64/kernel/Makefile~x86-serial-convert-legacy-com-ports-to-platform-devices
+++ a/arch/x86_64/kernel/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_prin
 obj-$(CONFIG_IOMMU)		+= pci-gart.o aperture.o
 obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary.o tce.o
 obj-$(CONFIG_SWIOTLB)		+= pci-swiotlb.o
+obj-$(CONFIG_SERIAL_8250)	+= legacy_serial.o
 obj-$(CONFIG_KPROBES)		+= kprobes.o
 obj-$(CONFIG_X86_PM_TIMER)	+= pmtimer.o
 obj-$(CONFIG_X86_VSMP)		+= vsmp.o
diff -puN drivers/serial/Kconfig~x86-serial-convert-legacy-com-ports-to-platform-devices drivers/serial/Kconfig
--- a/drivers/serial/Kconfig~x86-serial-convert-legacy-com-ports-to-platform-devices
+++ a/drivers/serial/Kconfig
@@ -73,17 +73,21 @@ config SERIAL_8250_PCI
 	depends on SERIAL_8250 && PCI
 	default SERIAL_8250
 	help
-	  This builds standard PCI serial support. You may be able to
-	  disable this feature if you only need legacy serial support.
-	  Saves about 9K.
+	  Say Y here if you have PCI serial ports.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called 8250_pci.
 
 config SERIAL_8250_PNP
 	tristate "8250/16550 PNP device support" if EMBEDDED
 	depends on SERIAL_8250 && PNP
 	default SERIAL_8250
 	help
-	  This builds standard PNP serial support. You may be able to
-	  disable this feature if you only need legacy serial support.
+	  Say Y here if you have serial ports described by PNPBIOS or ACPI.
+	  These are typically ports built into the system board.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called 8250_pnp.
 
 config SERIAL_8250_HP300
 	tristate
diff -puN include/asm-i386/serial.h~x86-serial-convert-legacy-com-ports-to-platform-devices include/asm-i386/serial.h
--- a/include/asm-i386/serial.h~x86-serial-convert-legacy-com-ports-to-platform-devices
+++ a/include/asm-i386/serial.h
@@ -11,19 +11,3 @@
  * megabits/second; but this requires the faster clock.
  */
 #define BASE_BAUD ( 1843200 / 16 )
-
-/* Standard COM flags (except for COM4, because of the 8514 problem) */
-#ifdef CONFIG_SERIAL_DETECT_IRQ
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ)
-#define STD_COM4_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
-#else
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
-#define STD_COM4_FLAGS ASYNC_BOOT_AUTOCONF
-#endif
-
-#define SERIAL_PORT_DFNS			\
-	/* UART CLK   PORT IRQ     FLAGS        */			\
-	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
-	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
-	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
-	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
diff -puN include/asm-x86_64/serial.h~x86-serial-convert-legacy-com-ports-to-platform-devices include/asm-x86_64/serial.h
--- a/include/asm-x86_64/serial.h~x86-serial-convert-legacy-com-ports-to-platform-devices
+++ a/include/asm-x86_64/serial.h
@@ -11,19 +11,3 @@
  * megabits/second; but this requires the faster clock.
  */
 #define BASE_BAUD ( 1843200 / 16 )
-
-/* Standard COM flags (except for COM4, because of the 8514 problem) */
-#ifdef CONFIG_SERIAL_DETECT_IRQ
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST | ASYNC_AUTO_IRQ)
-#define STD_COM4_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_AUTO_IRQ)
-#else
-#define STD_COM_FLAGS (ASYNC_BOOT_AUTOCONF | ASYNC_SKIP_TEST)
-#define STD_COM4_FLAGS ASYNC_BOOT_AUTOCONF
-#endif
-
-#define SERIAL_PORT_DFNS			\
-	/* UART CLK   PORT IRQ     FLAGS        */			\
-	{ 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },	/* ttyS0 */	\
-	{ 0, BASE_BAUD, 0x2F8, 3, STD_COM_FLAGS },	/* ttyS1 */	\
-	{ 0, BASE_BAUD, 0x3E8, 4, STD_COM_FLAGS },	/* ttyS2 */	\
-	{ 0, BASE_BAUD, 0x2E8, 3, STD_COM4_FLAGS },	/* ttyS3 */
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

git-ia64.patch
move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi.patch
pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled.patch
smsc-ircc2-tidy-up-module-parameter-checking.patch
smsc-ircc2-add-pnp-support.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
