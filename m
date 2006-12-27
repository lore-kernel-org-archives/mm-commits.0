From: akpm@osdl.org
Subject: + altix-acpi-_prt-support.patch added to -mm tree
Date: Tue, 26 Dec 2006 23:33:33 -0800
Message-ID: <200612270733.kBR7XXuZ004474@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:36708 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932959AbWL0HeU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 02:34:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jpk@sgi.com, lenb@kernel.org, tony.luck@intel.com


The patch titled
     Altix: ACPI _PRT support
has been added to the -mm tree.  Its filename is
     altix-acpi-_prt-support.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Altix: ACPI _PRT support
From: John Keller <jpk@sgi.com>

Provide ACPI _PRT support for SN Altix systems.

The SN Altix platform does not conform to the IOSAPIC IRQ routing model, so
a new acpi_irq_model (ACPI_IRQ_MODEL_PLATFORM) has been defined.  The SN
platform specific code sets acpi_irq_model to this new value, and keys off
of it in acpi_register_gsi() to avoid the iosapic code path.

Signed-off-by: John Keller <jpk@sgi.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/ia64/kernel/acpi.c            |    3 +++
 arch/ia64/sn/kernel/io_acpi_init.c |    3 +++
 drivers/acpi/bus.c                 |    3 +++
 include/linux/acpi.h               |    1 +
 4 files changed, 10 insertions(+)

diff -puN arch/ia64/kernel/acpi.c~altix-acpi-_prt-support arch/ia64/kernel/acpi.c
--- a/arch/ia64/kernel/acpi.c~altix-acpi-_prt-support
+++ a/arch/ia64/kernel/acpi.c
@@ -590,6 +590,9 @@ void __init acpi_numa_arch_fixup(void)
  */
 int acpi_register_gsi(u32 gsi, int triggering, int polarity)
 {
+	if (acpi_irq_model == ACPI_IRQ_MODEL_PLATFORM)
+		return gsi;
+
 	if (has_8259 && gsi < 16)
 		return isa_irq_to_vector(gsi);
 
diff -puN arch/ia64/sn/kernel/io_acpi_init.c~altix-acpi-_prt-support arch/ia64/sn/kernel/io_acpi_init.c
--- a/arch/ia64/sn/kernel/io_acpi_init.c~altix-acpi-_prt-support
+++ a/arch/ia64/sn/kernel/io_acpi_init.c
@@ -489,6 +489,9 @@ sn_io_acpi_init(void)
 	u64 result;
 	s64 status;
 
+	/* SN Altix does not follow the IOSAPIC IRQ routing model */
+	acpi_irq_model = ACPI_IRQ_MODEL_PLATFORM;
+
 	acpi_bus_register_driver(&acpi_sn_hubdev_driver);
 	status = sal_ioif_init(&result);
 	if (status || result)
diff -puN drivers/acpi/bus.c~altix-acpi-_prt-support drivers/acpi/bus.c
--- a/drivers/acpi/bus.c~altix-acpi-_prt-support
+++ a/drivers/acpi/bus.c
@@ -561,6 +561,9 @@ static int __init acpi_bus_init_irq(void
 	case ACPI_IRQ_MODEL_IOSAPIC:
 		message = "IOSAPIC";
 		break;
+	case ACPI_IRQ_MODEL_PLATFORM:
+		message = "platform specific model";
+		break;
 	default:
 		printk(KERN_WARNING PREFIX "Unknown interrupt routing model\n");
 		return -ENODEV;
diff -puN include/linux/acpi.h~altix-acpi-_prt-support include/linux/acpi.h
--- a/include/linux/acpi.h~altix-acpi-_prt-support
+++ a/include/linux/acpi.h
@@ -47,6 +47,7 @@ enum acpi_irq_model_id {
 	ACPI_IRQ_MODEL_PIC = 0,
 	ACPI_IRQ_MODEL_IOAPIC,
 	ACPI_IRQ_MODEL_IOSAPIC,
+	ACPI_IRQ_MODEL_PLATFORM,
 	ACPI_IRQ_MODEL_COUNT
 };
 
_

Patches currently in -mm which might be from jpk@sgi.com are

altix-acpi-ssdt-pci-device-support.patch
altix-add-acpi-ssdt-pci-device-support-hotplug.patch
altix-acpi-_prt-support.patch

