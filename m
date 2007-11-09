From: akpm@linux-foundation.org
Subject: + acpi-cleanup-linux-acpih.patch added to -mm tree
Date: Fri, 09 Nov 2007 13:38:32 -0800
Message-ID: <200711092138.lA9LcWbv000652@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37847 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763610AbXKIVih (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Nov 2007 16:38:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jdelvare@suse.de


The patch titled
     acpi: cleanup <linux/acpi.h>
has been added to the -mm tree.  Its filename is
     acpi-cleanup-linux-acpih.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: cleanup <linux/acpi.h>
From: Jean Delvare <jdelvare@suse.de>

Two cleanups to <linux/acpi.h>:
* Stop defining acpi_mp_config, it isn't used anywhere.
* Discard nested "#ifdef CONFIG_ACPI", they are useless and
  error-prone.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acpi.h |   14 --------------
 1 file changed, 14 deletions(-)

diff -puN include/linux/acpi.h~acpi-cleanup-linux-acpih include/linux/acpi.h
--- a/include/linux/acpi.h~acpi-cleanup-linux-acpih
+++ a/include/linux/acpi.h
@@ -42,8 +42,6 @@
 #include <asm/acpi.h>
 
 
-#ifdef CONFIG_ACPI
-
 enum acpi_irq_model_id {
 	ACPI_IRQ_MODEL_PIC = 0,
 	ACPI_IRQ_MODEL_IOAPIC,
@@ -115,20 +113,12 @@ int acpi_unmap_lsapic(int cpu);
 int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base);
 int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base);
 
-extern int acpi_mp_config;
-
 extern struct acpi_mcfg_allocation *pci_mmcfg_config;
 extern int pci_mmcfg_config_num;
 
 extern int sbf_port;
 extern unsigned long acpi_realmode_flags;
 
-#else	/* !CONFIG_ACPI */
-
-#define acpi_mp_config	0
-
-#endif 	/* !CONFIG_ACPI */
-
 int acpi_register_gsi (u32 gsi, int triggering, int polarity);
 int acpi_gsi_to_irq (u32 gsi, unsigned int *irq);
 
@@ -139,8 +129,6 @@ int acpi_gsi_to_irq (u32 gsi, unsigned i
  */
 void acpi_unregister_gsi (u32 gsi);
 
-#ifdef CONFIG_ACPI
-
 struct acpi_prt_entry {
 	struct list_head	node;
 	struct acpi_pci_id	id;
@@ -173,8 +161,6 @@ struct acpi_pci_driver {
 int acpi_pci_register_driver(struct acpi_pci_driver *driver);
 void acpi_pci_unregister_driver(struct acpi_pci_driver *driver);
 
-#endif /* CONFIG_ACPI */
-
 #ifdef CONFIG_ACPI_EC
 
 extern int ec_read(u8 addr, u8 *val);
_

Patches currently in -mm which might be from jdelvare@suse.de are

acpi-cleanup-linux-acpih.patch
export-acpi_check_resource_conflict.patch
export-acpi_check_resource_conflict-update.patch
check-for-acpi-resource-conflicts-in-i2c-bus-drivers.patch
check-for-acpi-resource-conflicts-in-hwmon-drivers.patch
