From: akpm@linux-foundation.org
Subject: + acpi-enable-c3-power-state-on-dell-inspiron-8200.patch added to -mm tree
Date: Tue, 03 Jul 2007 16:09:33 -0700
Message-ID: <200707032309.l63N9X8G021945@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49765 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759928AbXGCXJ5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 3 Jul 2007 19:09:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: arjan@infradead.org, dag@bakke.com, lenb@kernel.org


The patch titled
     acpi: enable C3 Power State on Dell Inspiron 8200
has been added to the -mm tree.  Its filename is
     acpi-enable-c3-power-state-on-dell-inspiron-8200.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: acpi: enable C3 Power State on Dell Inspiron 8200
From: Arjan van de Ven <arjan@infradead.org>

Taken from http://bugzilla.kernel.org/show_bug.cgi?id=8703

Cc: Dag Bakke <dag@bakke.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_idle.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/processor_idle.c~acpi-enable-c3-power-state-on-dell-inspiron-8200 drivers/acpi/processor_idle.c
--- a/drivers/acpi/processor_idle.c~acpi-enable-c3-power-state-on-dell-inspiron-8200
+++ a/drivers/acpi/processor_idle.c
@@ -67,6 +67,8 @@ ACPI_MODULE_NAME("processor_idle");
 #define C2_OVERHEAD			1	/* 1us */
 #define C3_OVERHEAD			1	/* 1us */
 
+static int forced_c3;
+
 void acpi_max_cstate_changed(void)
 {
 	/* Driver will reset devices' max cstate limit */
@@ -115,6 +117,20 @@ static int set_max_cstate(struct dmi_sys
 	return 0;
 }
 
+/*
+ * Some (Dell) machines have a too large C3 latency set, but it still works completely.
+ * Dell provides a driver for other operating systems to hack around this bug, so we know
+ * it's safe.
+ */
+static int dmi_force_c3(struct dmi_system_id *id)
+{
+	forced_c3 = 1;
+
+	printk(KERN_NOTICE PREFIX "%s detected - Force enabling C3.", id->ident);
+
+	return 0;
+}
+
 /* Actually this shouldn't be __cpuinitdata, would be better to fix the
    callers to only run once -AK */
 static struct dmi_system_id __cpuinitdata processor_power_dmi_table[] = {
@@ -173,6 +189,9 @@ static struct dmi_system_id __cpuinitdat
 	  DMI_MATCH(DMI_BIOS_VENDOR,"Phoenix Technologies LTD"),
 	  DMI_MATCH(DMI_BIOS_VERSION,"SHE845M0.86C.0013.D.0302131307")},
 	 (void *)2},
+	{ dmi_force_c3, "Dell Inspiron 8200", {
+	  DMI_MATCH(DMI_SYS_VENDOR,"Dell Computer Corporation"),
+	  DMI_MATCH(DMI_PRODUCT_NAME,"Inspiron 8200") }, NULL},
 	{},
 };
 
@@ -487,11 +506,12 @@ static void acpi_processor_power_verify_
 	 * C3 latency must be less than or equal to 1000
 	 * microseconds.
 	 */
-	else if (cx->latency > ACPI_PROCESSOR_MAX_C3_LATENCY) {
+	if (cx->latency > ACPI_PROCESSOR_MAX_C3_LATENCY && !forced_c3) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "latency too large [%d]\n", cx->latency));
 		return;
-	}
+	} else if (forced_c3)
+		cx->latency = ACPI_PROCESSOR_MAX_C3_LATENCY;
 
 	/*
 	 * PIIX4 Erratum #18: We don't support C3 when Type-F (fast)
_

Patches currently in -mm which might be from arjan@infradead.org are

acpi-enable-c3-power-state-on-dell-inspiron-8200.patch
vdso-print-fatal-signals.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-pci-generic-helper-function-fix.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-iova-allocation-and-management-routines-fix.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-intel-iommu-driver-fix.patch
intel-iommu-intel-iommu-driver-fix-2.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
intel-iommu-iommu-floppy-workaround-fix.patch
