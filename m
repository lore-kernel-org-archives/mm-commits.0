From: akpm@linux-foundation.org
Subject: + pci-hotplug-introduce-pci_slot-fix-3.patch added to -mm tree
Date: Fri, 28 Mar 2008 11:02:56 -0700
Message-ID: <200803281802.m2SI2uFA002811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754053AbYC1SDo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Mar 2008 14:03:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: achiang@hp.com, greg@kroah.com, kaneshige.kenji@jp.fujitsu.com, kristen.c.accardi@intel.com, lenb@kernel.org, matthew@wil.cx


The patch titled
     remove rpaphp 'address_read_file'
has been added to the -mm tree.  Its filename is
     pci-hotplug-introduce-pci_slot-fix-3.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: remove rpaphp 'address_read_file'
From: Alex Chiang <achiang@hp.com>

Physical pci_slot removed ->get_address methods from individual
PCI hotplug drivers, but overlooked rpaphp, causing build errors.

Remove rpaphp's 'address_read_file' as well.

Signed-off-by: Alex Chiang <achiang@hp.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/rpaphp_slot.c |   37 ----------------------------
 1 file changed, 37 deletions(-)

diff -puN drivers/pci/hotplug/rpaphp_slot.c~pci-hotplug-introduce-pci_slot-fix-3 drivers/pci/hotplug/rpaphp_slot.c
--- a/drivers/pci/hotplug/rpaphp_slot.c~pci-hotplug-introduce-pci_slot-fix-3
+++ a/drivers/pci/hotplug/rpaphp_slot.c
@@ -33,33 +33,6 @@
 #include <asm/rtas.h>
 #include "rpaphp.h"
 
-static ssize_t address_read_file (struct hotplug_slot *php_slot, char *buf)
-{
-	int retval;
-	struct slot *slot = (struct slot *)php_slot->private;
-	struct pci_bus *bus;
-
-	if (!slot)
-		return -ENOENT;
-
-	bus = slot->bus;
-	if (!bus)
-		return -ENOENT;
-
-	if (bus->self)
-		retval = sprintf(buf, pci_name(bus->self));
-	else
-		retval = sprintf(buf, "%04x:%02x:00.0",
-		        pci_domain_nr(bus), bus->number);
-
-	return retval;
-}
-
-static struct hotplug_slot_attribute php_attr_address = {
-	.attr = {.name = "address", .mode = S_IFREG | S_IRUGO},
-	.show = address_read_file,
-};
-
 /* free up the memory used by a slot */
 static void rpaphp_release_slot(struct hotplug_slot *hotplug_slot)
 {
@@ -135,9 +108,6 @@ int rpaphp_deregister_slot(struct slot *
 
 	list_del(&slot->rpaphp_slot_list);
 	
-	/* remove "address" file */
-	sysfs_remove_file(&php_slot->kobj, &php_attr_address.attr);
-
 	retval = pci_hp_deregister(php_slot);
 	if (retval)
 		err("Problem unregistering a slot %s\n", slot->name);
@@ -169,13 +139,6 @@ int rpaphp_register_slot(struct slot *sl
 		return retval;
 	}
 
-	/* create "address" file */
-	retval = sysfs_create_file(&php_slot->kobj, &php_attr_address.attr);
-	if (retval) {
-		err("sysfs_create_file failed with error %d\n", retval);
-		goto sysfs_fail;
-	}
