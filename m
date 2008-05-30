From: akpm@linux-foundation.org
Subject: - pci-hotplug-introduce-pci_slot-rpaphp-correctly-call-pci_hp_register-for-empty-pci-slots.patch removed from -mm tree
Date: Fri, 30 May 2008 15:16:59 -0700
Message-ID: <200805302216.m4UMGxVe013990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbYE3WSW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:18:22 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: achiang@hp.com, greg@kroah.com, jbarnes@virtuousgeek.org, kaneshige.kenji@jp.fujitsu.com, kristen.c.accardi@intel.com, lenb@kernel.org, matthew@wil.cx, pbadari@us.ibm.com, mm-commits@


The patch titled
     rpaphp: correctly call pci_hp_register for empty PCI slots
has been removed from the -mm tree.  Its filename was
     pci-hotplug-introduce-pci_slot-rpaphp-correctly-call-pci_hp_register-for-empty-pci-slots.patch

This patch was dropped because yup, these got wrecked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rpaphp: correctly call pci_hp_register for empty PCI slots
From: Alex Chiang <achiang@hp.com>

Unpopulated device_node slots do not have children, and attempting to
dereference them will result in a panic.

Instead, attempt to derive the PCI slot number from the bus itself, and
failing that, default to 0.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Tested-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/rpaphp_slot.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff -puN drivers/pci/hotplug/rpaphp_slot.c~pci-hotplug-introduce-pci_slot-rpaphp-correctly-call-pci_hp_register-for-empty-pci-slots drivers/pci/hotplug/rpaphp_slot.c
--- a/drivers/pci/hotplug/rpaphp_slot.c~pci-hotplug-introduce-pci_slot-rpaphp-correctly-call-pci_hp_register-for-empty-pci-slots
+++ a/drivers/pci/hotplug/rpaphp_slot.c
@@ -121,6 +121,7 @@ int rpaphp_register_slot(struct slot *sl
 {
 	struct hotplug_slot *php_slot = slot->hotplug_slot;
 	int retval;
+	int slot_nr;
 
 	dbg("%s registering slot:path[%s] index[%x], name[%s] pdomain[%x] type[%d]\n", 
 		__func__, slot->dn->full_name, slot->index, slot->name,
@@ -132,8 +133,11 @@ int rpaphp_register_slot(struct slot *sl
 		return -EAGAIN;
 	}	
 
-	retval = pci_hp_register(php_slot, slot->bus,
-				 PCI_SLOT(PCI_DN(slot->dn->child)->devfn));
+	if (slot->bus->self)
+		slot_nr = PCI_SLOT(slot->bus->self->devfn);
+	else
+		slot_nr = 0;
+	retval = pci_hp_register(php_slot, slot->bus, slot_nr);
 	if (retval) {
 		err("pci_hp_register failed with error %d\n", retval);
 		return retval;
_

Patches currently in -mm which might be from achiang@hp.com are

pci-hotplug-introduce-pci_slot-rpaphp-correctly-call-pci_hp_register-for-empty-pci-slots.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch

