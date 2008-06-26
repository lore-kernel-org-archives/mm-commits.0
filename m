From: akpm@linux-foundation.org
Subject: - acpi-pci-slot-detection-driver-fix.patch removed from -mm tree
Date: Thu, 26 Jun 2008 13:52:09 -0700
Message-ID: <200806262052.m5QKq9uj017593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34381 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752915AbYFZUx1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Jun 2008 16:53:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kaneshige.kenji@jp.fujitsu.com, achiang@hp.com, greg@kroah.com, kristen.c.accardi@intel.com, lenb@kernel.org, mm-commits@vger.kernel.org


The patch titled
     kobject: Export kobject_rename for pci_hotplug_core
has been removed from the -mm tree.  Its filename was
     acpi-pci-slot-detection-driver-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kobject: Export kobject_rename for pci_hotplug_core
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Export kobject_rename() to fix the following link error.  This happens
when pci_hotplug_core driver is compiled as a kernel module.

ERROR: "kobject_rename" [drivers/pci/hotplug/pci_hotplug.ko] undefined!
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2
make: *** Waiting for unfinished jobs....

Signed-off-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Acked-by: Greg KH <greg@kroah.com>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Alex Chiang <achiang@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/kobject.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/kobject.c~acpi-pci-slot-detection-driver-fix lib/kobject.c
--- a/lib/kobject.c~acpi-pci-slot-detection-driver-fix
+++ a/lib/kobject.c
@@ -489,6 +489,7 @@ out:
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(kobject_rename);
 
 /**
  * kobject_move - move object to another parent
_

Patches currently in -mm which might be from kaneshige.kenji@jp.fujitsu.com are

acpi-pci-slot-detection-driver-fix.patch

