From: akpm@linux-foundation.org
Subject: - acpi-use-_sta-bit-names-rather-than-0x0f.patch removed from -mm tree
Date: Wed, 25 Apr 2007 23:59:20 -0700
Message-ID: <200704260659.l3Q6xKqe023133@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:55565 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933219AbXDZHAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Apr 2007 03:00:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bjorn.helgaas@hp.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     ACPI: use _STA bit names rather than 0x0F
has been removed from the -mm tree.  Its filename was
     acpi-use-_sta-bit-names-rather-than-0x0f.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ACPI: use _STA bit names rather than 0x0F
From: Bjorn Helgaas <bjorn.helgaas@hp.com>

Be explicit about what "device->status = 0x0F" really means.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/bus.c  |    4 +++-
 drivers/acpi/scan.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/bus.c~acpi-use-_sta-bit-names-rather-than-0x0f drivers/acpi/bus.c
--- a/drivers/acpi/bus.c~acpi-use-_sta-bit-names-rather-than-0x0f
+++ a/drivers/acpi/bus.c
@@ -103,7 +103,9 @@ int acpi_bus_get_status(struct acpi_devi
 	else if (device->parent)
 		device->status = device->parent->status;
 	else
-		STRUCT_TO_INT(device->status) = 0x0F;
+		STRUCT_TO_INT(device->status) =
+		    ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED |
+		    ACPI_STA_DEVICE_UI      | ACPI_STA_DEVICE_FUNCTIONING;
 
 	if (device->status.functional && !device->status.present) {
 		printk(KERN_WARNING PREFIX "Device [%s] status [%08x]: "
diff -puN drivers/acpi/scan.c~acpi-use-_sta-bit-names-rather-than-0x0f drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-use-_sta-bit-names-rather-than-0x0f
+++ a/drivers/acpi/scan.c
@@ -1068,7 +1068,9 @@ acpi_add_single_object(struct acpi_devic
 		}
 		break;
 	default:
-		STRUCT_TO_INT(device->status) = 0x0F;
+		STRUCT_TO_INT(device->status) =
+		    ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED |
+		    ACPI_STA_DEVICE_UI      | ACPI_STA_DEVICE_FUNCTIONING;
 		break;
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
