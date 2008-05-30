From: akpm@linux-foundation.org
Subject: - pci-hotplug-export-kobject_rename-for-pci_hotplug_core.patch removed from -mm tree
Date: Fri, 30 May 2008 15:16:55 -0700
Message-ID: <200805302216.m4UMGtbB013984@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751346AbYE3WRq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 May 2008 18:17:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaneshige.kenji@jp.fujitsu.com, achiang@hp.com, greg@kroah.com, kristen.c.accardi@intel.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     pci hotplug: export kobject_rename for pci_hotplug_core
has been removed from the -mm tree.  Its filename was
     pci-hotplug-export-kobject_rename-for-pci_hotplug_core.patch

This patch was dropped because yup, these got wrecked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pci hotplug: export kobject_rename for pci_hotplug_core
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Export kobject_rename() to fix the following link error.  This happens when
pci_hotplug_core driver is compiled as a kernel module.

ERROR: "kobject_rename" [drivers/pci/hotplug/pci_hotplug.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Acked-by: Alex Chiang <achiang@hp.com>
Cc: Greg KH <greg@kroah.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/kobject.c~pci-hotplug-export-kobject_rename-for-pci_hotplug_core lib/kobject.c
--- a/lib/kobject.c~pci-hotplug-export-kobject_rename-for-pci_hotplug_core
+++ a/lib/kobject.c
@@ -489,6 +489,7 @@ out:
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(kobject_rename);
 
 /**
  * kobject_move - move object to another parent
_

Patches currently in -mm which might be from kaneshige.kenji@jp.fujitsu.com are

origin.patch
linux-next.patch
pci-hotplug-export-kobject_rename-for-pci_hotplug_core.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-introduce-pci_slot-rpaphp-correctly-call-pci_hp_register-for-empty-pci-slots.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch

