From: akpm@linux-foundation.org
Subject: + acpi-add-reboot-mechanism.patch added to -mm tree
Date: Mon, 16 Jul 2007 14:57:51 -0700
Message-ID: <200707162157.l6GLvpRa006234@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34971 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751707AbXGPV6N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:58:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adurbin@google.com, ak@suse.de, lenb@kernel.org


The patch titled
     ACPI: Add reboot mechanism
has been added to the -mm tree.  Its filename is
     acpi-add-reboot-mechanism.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ACPI: Add reboot mechanism
From: Aaron Durbin <adurbin@google.com>

Add the ability to reset the machine using the RESET_REG in ACPI's FADT table.

Signed-off-by: Aaron Durbin <adurbin@google.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/Makefile |    2 -
 drivers/acpi/reboot.c |   45 ++++++++++++++++++++++++++++++++++++++++
 include/acpi/reboot.h |   10 ++++++++
 3 files changed, 56 insertions(+), 1 deletion(-)

diff -puN drivers/acpi/Makefile~acpi-add-reboot-mechanism drivers/acpi/Makefile
--- a/drivers/acpi/Makefile~acpi-add-reboot-mechanism
+++ a/drivers/acpi/Makefile
@@ -21,7 +21,7 @@ obj-$(CONFIG_X86)		+= blacklist.o
 #
 # ACPI Core Subsystem (Interpreter)
 #
-obj-y				+= osl.o utils.o \
+obj-y				+= osl.o utils.o reboot.o \
 				   dispatcher/ events/ executer/ hardware/ \
 				   namespace/ parser/ resources/ tables/ \
 				   utilities/
diff -puN /dev/null drivers/acpi/reboot.c
--- /dev/null
+++ a/drivers/acpi/reboot.c
@@ -0,0 +1,45 @@
+
+#include <linux/pci.h>
+#include <acpi/acpi.h>
+
+void acpi_reboot(void)
+{
+	struct acpi_generic_address *rr;
+	struct pci_bus *bus0;
+	u8 reset_value;
+	unsigned int devfn;
+
+	rr = &acpi_gbl_FADT.reset_register;
+
+	/* Is the reset register supported? */
+	if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER) ||
+	    rr->bit_width != 8 || rr->bit_offset != 0)
+		return;
+
+	reset_value = acpi_gbl_FADT.reset_value;
+
+	/* The reset register can only exist in I/O, Memory or PCI config space
+	 * on a device on bus 0. */
+	switch (rr->space_id) {
+		case ACPI_ADR_SPACE_PCI_CONFIG:
+			/* The reset register can only live on bus 0. */
+			bus0 = pci_find_bus(0, 0);
+			if (!bus0)
+				return;
+			/* Form PCI device/function pair. */
+			devfn = PCI_DEVFN((rr->address >> 32) & 0xffff,
+					  (rr->address >> 16) & 0xffff);
+			printk(KERN_DEBUG "Resetting with ACPI PCI RESET_REG.");
+			/* Write the value that resets us. */
+			pci_bus_write_config_byte(bus0, devfn,
+					(rr->address & 0xffff), reset_value);
+			break;
+
+		case ACPI_ADR_SPACE_SYSTEM_MEMORY:
+		case ACPI_ADR_SPACE_SYSTEM_IO:
+			printk(KERN_DEBUG "ACPI MEMORY or I/O RESET_REG.");
+			acpi_hw_low_level_write(8, reset_value, rr);
+			break;
+	}
+}
+
diff -puN /dev/null include/acpi/reboot.h
--- /dev/null
+++ a/include/acpi/reboot.h
@@ -0,0 +1,10 @@
+#ifndef __ACPI_REBOOT_H
+#define __ACPI_REBOOT_H
+
+#ifdef CONFIG_ACPI
+extern void acpi_reboot(void);
+#else
+#define acpi_reboot()
+#endif
+
+#endif
_

Patches currently in -mm which might be from adurbin@google.com are

acpi-add-reboot-mechanism.patch
x86_64-add-acpi-reboot-option.patch
x86_64-make-acpi-the-default-reset-option.patch
mmconfig-x86_64-i386-insert-unclaimed-mmconfig-resources.patch
i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed.patch
