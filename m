From: akpm@linux-foundation.org
Subject: - x86_64-acpi-make-kernel-to-be-compiled-when-config_acpi_numa-is-set-and-power-management-with-acpi-is-not-enabled.patch removed from -mm tree
Date: Fri, 13 Apr 2007 13:34:03 -0700
Message-ID: <200704132034.l3DKY3cc008795@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49853 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030185AbXDMUfV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 16:35:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yinghai.lu@amd.com, ak@suse.de, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64/acpi: make kernel to be compiled when CONFIG_ACPI_NUMA is set and power management with acpi is not enabled
has been removed from the -mm tree.  Its filename was
     x86_64-acpi-make-kernel-to-be-compiled-when-config_acpi_numa-is-set-and-power-management-with-acpi-is-not-enabled.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: x86_64/acpi: make kernel to be compiled when CONFIG_ACPI_NUMA is set and power management with acpi is not enabled
From: "Yinghai Lu" <yinghai.lu@amd.com>

When CONFIG_ACPI_NUMA is set, and power management with acpi is not used.  the
kernel can not be compiled.  so use CONFIG_ACPI_POWER and CONFIG_ACPI_SYTEM to
comment function about set/get power and event.

Signed-off-by: Yinghai Lu <yinghai.lu@amd.com> 
Cc: Andi Kleen <ak@suse.de>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/bus.c     |    4 ++++
 drivers/pci/pci-acpi.c |    6 ++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/bus.c~x86_64-acpi-make-kernel-to-be-compiled-when-config_acpi_numa-is-set-and-power-management-with-acpi-is-not-enabled drivers/acpi/bus.c
--- a/drivers/acpi/bus.c~x86_64-acpi-make-kernel-to-be-compiled-when-config_acpi_numa-is-set-and-power-management-with-acpi-is-not-enabled
+++ a/drivers/acpi/bus.c
@@ -121,6 +121,7 @@ int acpi_bus_get_status(struct acpi_devi
 
 EXPORT_SYMBOL(acpi_bus_get_status);
 
+#ifdef CONFIG_ACPI_POWER
 /* --------------------------------------------------------------------------
                                  Power Management
    -------------------------------------------------------------------------- */
@@ -269,7 +270,9 @@ int acpi_bus_set_power(acpi_handle handl
 }
 
 EXPORT_SYMBOL(acpi_bus_set_power);
+#endif
 
+#ifdef CONFIG_ACPI_SYSTEM
 /* --------------------------------------------------------------------------
                                 Event Management
    -------------------------------------------------------------------------- */
@@ -358,6 +361,7 @@ int acpi_bus_receive_event(struct acpi_b
 }
 
 EXPORT_SYMBOL(acpi_bus_receive_event);
+#endif
 
 /* --------------------------------------------------------------------------
                              Notification Handling
diff -puN drivers/pci/pci-acpi.c~x86_64-acpi-make-kernel-to-be-compiled-when-config_acpi_numa-is-set-and-power-management-with-acpi-is-not-enabled drivers/pci/pci-acpi.c
--- a/drivers/pci/pci-acpi.c~x86_64-acpi-make-kernel-to-be-compiled-when-config_acpi_numa-is-set-and-power-management-with-acpi-is-not-enabled
+++ a/drivers/pci/pci-acpi.c
@@ -255,7 +255,7 @@ static int acpi_pci_choose_state(struct 
 
 	return -ENODEV;
 }
-
+#ifdef CONFIG_ACPI_POWER
 static int acpi_pci_set_power_state(struct pci_dev *dev, pci_power_t state)
 {
 	acpi_handle handle = DEVICE_ACPI_HANDLE(&dev->dev);
@@ -272,7 +272,7 @@ static int acpi_pci_set_power_state(stru
 		return -ENODEV;
 	return acpi_bus_set_power(handle, acpi_state);
 }
-
+#endif
 
 /* ACPI bus type */
 static int acpi_pci_find_device(struct device *dev, acpi_handle *handle)
@@ -321,7 +321,9 @@ static int __init acpi_pci_init(void)
 	if (ret)
 		return 0;
 	platform_pci_choose_state = acpi_pci_choose_state;
+#ifdef CONFIG_ACPI_POWER
 	platform_pci_set_power_state = acpi_pci_set_power_state;
+#endif
 	return 0;
 }
 arch_initcall(acpi_pci_init);
_

Patches currently in -mm which might be from yinghai.lu@amd.com are
