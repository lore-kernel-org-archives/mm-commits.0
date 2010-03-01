From: akpm@linux-foundation.org
Subject: + acpiphp-execute-acpi-_reg-method-for-hotadded-devices.patch added to -mm tree
Date: Mon, 01 Mar 2010 14:00:51 -0800
Message-ID: <201003012200.o21M0piG002220@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752860Ab0CAWBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Mar 2010 17:01:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: shaohua.li@intel.com, jbarnes@virtuousgeek.org, lenb@kernel.org, pm@debian.org


The patch titled
     acpiphp: execute ACPI _REG method for hotadded devices
has been added to the -mm tree.  Its filename is
     acpiphp-execute-acpi-_reg-method-for-hotadded-devices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
acpiphp-execute-acpi-_reg-method-for-hotadded-devices.patch

