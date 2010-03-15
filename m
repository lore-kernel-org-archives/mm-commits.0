From: akpm@linux-foundation.org
Subject: [merged] acpiphp-execute-acpi-_reg-method-for-hotadded-devices.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:05:21 -0400
Message-ID: <201003150705.o2F75sXx017127@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933035Ab0COHGG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:06:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: shaohua.li@intel.com, jbarnes@virtuousgeek.org, lenb@kernel.org, pm@debian.org, mm-commits@vger.kernel.org


The patch titled
     acpiphp: execute ACPI _REG method for hotadded devices
has been removed from the -mm tree.  Its filename was
     acpiphp-execute-acpi-_reg-method-for-hotadded-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: acpiphp: execute ACPI _REG method for hotadded devices
From: Shaohua Li <shaohua.li@intel.com>

Per ACPI spec, _ERG method should be executed before device driver gets
control for hotpluged device.  Firmware might do some configuration there.
 See http://bugzilla.kernel.org/show_bug.cgi?id=10805.  In this machine,
_REG method of docked device will configure cardbus bridge.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Tested-by: Paul Martin <pm@debian.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/acpiphp_glue.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff -puN drivers/pci/hotplug/acpiphp_glue.c~acpiphp-execute-acpi-_reg-method-for-hotadded-devices drivers/pci/hotplug/acpiphp_glue.c
--- a/drivers/pci/hotplug/acpiphp_glue.c~acpiphp-execute-acpi-_reg-method-for-hotadded-devices
+++ a/drivers/pci/hotplug/acpiphp_glue.c
@@ -749,6 +749,24 @@ static int acpiphp_bus_trim(acpi_handle 
 	return retval;
 }
 
+static void acpiphp_set_acpi_region(struct acpiphp_slot *slot)
+{
+	struct acpiphp_func *func;
+	union acpi_object params[2];
+	struct acpi_object_list arg_list;
+
+	list_for_each_entry(func, &slot->funcs, sibling) {
+		arg_list.count = 2;
+		arg_list.pointer = params;
+		params[0].type = ACPI_TYPE_INTEGER;
+		params[0].integer.value = ACPI_ADR_SPACE_PCI_CONFIG;
+		params[1].type = ACPI_TYPE_INTEGER;
+		params[1].integer.value = 1;
+		/* _REG is optional, we don't care about if there is failure */
+		acpi_evaluate_object(func->handle, "_REG", &arg_list, NULL);
+	}
+}
+
 /**
  * enable_device - enable, configure a slot
  * @slot: slot to be enabled
@@ -805,6 +823,7 @@ static int __ref enable_device(struct ac
 	pci_bus_assign_resources(bus);
 	acpiphp_sanitize_bus(bus);
 	acpiphp_set_hpp_values(bus);
+	acpiphp_set_acpi_region(slot);
 	pci_enable_bridges(bus);
 	pci_bus_add_devices(bus);
 
_

Patches currently in -mm which might be from shaohua.li@intel.com are

origin.patch

