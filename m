From: akpm@linux-foundation.org
Subject: - i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:11:02 -0700
Message-ID: <200707192011.l6JKB2ou020731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47659 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761598AbXGSUSN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:18:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adurbin@google.com, ak@suse.de, johnstul@us.ibm.com, lenb@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     i386/x86_64: insert HPET firmware resource after PCI enumeration has completed
has been removed from the -mm tree.  Its filename was
     i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386/x86_64: insert HPET firmware resource after PCI enumeration has completed
From: Aaron Durbin <adurbin@google.com>

Insert HPET resources after pci probing has been completed in order to
avoid resource conflicts with PCI resource reservation.  With this change
the HPET firmware resources will be identified, but it should also not
cause issues when the HPET address falls on a BAR in a PCI device, and the
PCI enumeration cannot reserve the resources.

Signed-off-by: Aaron Durbin <adurbin@google.com>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/acpi/boot.c |   36 +++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff -puN arch/i386/kernel/acpi/boot.c~i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed arch/i386/kernel/acpi/boot.c
--- a/arch/i386/kernel/acpi/boot.c~i386-x86_64-insert-hpet-firmware-resource-after-pci-enumeration-has-completed
+++ a/arch/i386/kernel/acpi/boot.c
@@ -618,6 +618,8 @@ static int __init acpi_parse_sbf(struct 
 #ifdef CONFIG_HPET_TIMER
 #include <asm/hpet.h>
 
+static struct __initdata resource *hpet_res;
+
 static int __init acpi_parse_hpet(struct acpi_table_header *table)
 {
 	struct acpi_table_hpet *hpet_tbl;
@@ -638,8 +640,42 @@ static int __init acpi_parse_hpet(struct
 	printk(KERN_INFO PREFIX "HPET id: %#x base: %#lx\n",
 	       hpet_tbl->id, hpet_address);
 
+	/*
+	 * Allocate and initialize the HPET firmware resource for adding into
+	 * the resource tree during the lateinit timeframe.
+	 */
+#define HPET_RESOURCE_NAME_SIZE 9
+	hpet_res = alloc_bootmem(sizeof(*hpet_res) + HPET_RESOURCE_NAME_SIZE);
+
+	if (!hpet_res)
+		return 0;
+
+	memset(hpet_res, 0, sizeof(*hpet_res));
+	hpet_res->name = (void *)&hpet_res[1];
+	hpet_res->flags = IORESOURCE_MEM;
+	snprintf((char *)hpet_res->name, HPET_RESOURCE_NAME_SIZE, "HPET %u",
+		 hpet_tbl->sequence);
+
+	hpet_res->start = hpet_address;
+	hpet_res->end = hpet_address + (1 * 1024) - 1;
+
 	return 0;
 }
+
+/*
+ * hpet_insert_resource inserts the HPET resources used into the resource
+ * tree.
+ */
+static __init int hpet_insert_resource(void)
+{
+	if (!hpet_res)
+		return 1;
+
+	return insert_resource(&iomem_resource, hpet_res);
+}
+
+late_initcall(hpet_insert_resource);
+
 #else
 #define	acpi_parse_hpet	NULL
 #endif
_

Patches currently in -mm which might be from adurbin@google.com are

acpi-add-reboot-mechanism.patch
acpi-add-reboot-mechanism-fix.patch
x86_64-add-acpi-reboot-option.patch
x86_64-make-acpi-the-default-reset-option.patch
