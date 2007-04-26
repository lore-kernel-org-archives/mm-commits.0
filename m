From: akpm@linux-foundation.org
Subject: - acpi-remove-duplicate-definitions-for-_sta-bits.patch removed from -mm tree
Date: Wed, 25 Apr 2007 23:59:18 -0700
Message-ID: <200704260659.l3Q6xIUC023130@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933213AbXDZHAk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 03:00:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: remove duplicate definitions for _STA bits
has been removed from the -mm tree.  Its filename was
     acpi-remove-duplicate-definitions-for-_sta-bits.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: remove duplicate definitions for _STA bits
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

No need to duplicate the existing definitions in include/acpi/actypes.h.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/acpi_memhotplug.c |   13 ++++---------
 drivers/acpi/container.c       |    6 ++----
 drivers/acpi/processor_core.c  |    4 +---
 3 files changed, 7 insertions(+), 16 deletions(-)

diff -puN drivers/acpi/acpi_memhotplug.c~acpi-remove-duplicate-definitions-for-_sta-bits drivers/acpi/acpi_memhotplug.c
--- a/drivers/acpi/acpi_memhotplug.c~acpi-remove-duplicate-definitions-for-_sta-bits
+++ a/drivers/acpi/acpi_memhotplug.c
@@ -44,11 +44,6 @@ MODULE_AUTHOR("Naveen B S <naveen.b.s@in
 MODULE_DESCRIPTION("Hotplug Mem Driver");
 MODULE_LICENSE("GPL");
 
-/* ACPI _STA method values */
-#define ACPI_MEMORY_STA_PRESENT		(0x00000001UL)
-#define ACPI_MEMORY_STA_ENABLED		(0x00000002UL)
-#define ACPI_MEMORY_STA_FUNCTIONAL	(0x00000008UL)
-
 /* Memory Device States */
 #define MEMORY_INVALID_STATE	0
 #define MEMORY_POWER_ON_STATE	1
@@ -204,9 +199,9 @@ static int acpi_memory_check_device(stru
 	 * Check for device status. Device should be
 	 * present/enabled/functioning.
 	 */
-	if (!((current_status & ACPI_MEMORY_STA_PRESENT)
-	      && (current_status & ACPI_MEMORY_STA_ENABLED)
-	      && (current_status & ACPI_MEMORY_STA_FUNCTIONAL)))
+	if (!((current_status & ACPI_STA_DEVICE_PRESENT)
+	      && (current_status & ACPI_STA_DEVICE_ENABLED)
+	      && (current_status & ACPI_STA_DEVICE_FUNCTIONING)))
 		return -ENODEV;
 
 	return 0;
@@ -286,7 +281,7 @@ static int acpi_memory_powerdown_device(
 		return -ENODEV;
 
 	/* Check for device status.  Device should be disabled */
-	if (current_status & ACPI_MEMORY_STA_ENABLED)
+	if (current_status & ACPI_STA_DEVICE_ENABLED)
 		return -EINVAL;
 
 	return 0;
diff -puN drivers/acpi/container.c~acpi-remove-duplicate-definitions-for-_sta-bits drivers/acpi/container.c
--- a/drivers/acpi/container.c~acpi-remove-duplicate-definitions-for-_sta-bits
+++ a/drivers/acpi/container.c
@@ -49,8 +49,6 @@ MODULE_AUTHOR("Anil S Keshavamurthy");
 MODULE_DESCRIPTION("ACPI container driver");
 MODULE_LICENSE("GPL");
 
-#define ACPI_STA_PRESENT		(0x00000001)
-
 static int acpi_container_add(struct acpi_device *device);
 static int acpi_container_remove(struct acpi_device *device, int type);
 
@@ -75,13 +73,13 @@ static int is_device_present(acpi_handle
 
 	status = acpi_get_handle(handle, "_STA", &temp);
 	if (ACPI_FAILURE(status))
-		return 1;	/* _STA not found, assmue device present */
+		return 1;	/* _STA not found, assume device present */
 
 	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
 	if (ACPI_FAILURE(status))
 		return 0;	/* Firmware error */
 
-	return ((sta & ACPI_STA_PRESENT) == ACPI_STA_PRESENT);
+	return ((sta & ACPI_STA_DEVICE_PRESENT) == ACPI_STA_DEVICE_PRESENT);
 }
 
 /*******************************************************************/
diff -puN drivers/acpi/processor_core.c~acpi-remove-duplicate-definitions-for-_sta-bits drivers/acpi/processor_core.c
--- a/drivers/acpi/processor_core.c~acpi-remove-duplicate-definitions-for-_sta-bits
+++ a/drivers/acpi/processor_core.c
@@ -71,8 +71,6 @@
 #define ACPI_PROCESSOR_LIMIT_USER	0
 #define ACPI_PROCESSOR_LIMIT_THERMAL	1
 
-#define ACPI_STA_PRESENT 0x00000001
-
 #define _COMPONENT		ACPI_PROCESSOR_COMPONENT
 ACPI_MODULE_NAME("processor_core");
 
@@ -780,7 +778,7 @@ static int is_processor_present(acpi_han
 
 
 	status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
-	if (ACPI_FAILURE(status) || !(sta & ACPI_STA_PRESENT)) {
+	if (ACPI_FAILURE(status) || !(sta & ACPI_STA_DEVICE_PRESENT)) {
 		ACPI_EXCEPTION((AE_INFO, status, "Processor Device is not present"));
 		return 0;
 	}
_

Patches currently in -mm which might be from bjorn.helgaas@hp.com are

git-acpi.patch
git-ia64.patch
move-free-pages-between-lists-on-steal-avoid-unsafe-use-of-struct-pages-in-move_freepages-when-config_holes_in_zone-is-set.patch
pnpacpi-sets-pnpdev-devarchdata.patch
pnpacpi-sets-pnpdev-devarchdata-fix.patch
efi-warn-only-for-pre-100-system-tables.patch
pnpbios-conert-to-use-the-kthread-api.patch
pnp-notice-whether-we-have-pnp-devices-pnpbios-or-pnpacpi.patch
pnp-workaround-hp-bios-defect-that-leaves-smcf010-device-partly-enabled.patch
smsc-ircc2-tidy-up-module-parameter-checking.patch
smsc-ircc2-add-pnp-support.patch
x86-serial-convert-legacy-com-ports-to-platform-devices.patch
x86-serial-convert-legacy-com-ports-to-platform-devices-fix.patch
use-menuconfig-objects-pnp.patch
