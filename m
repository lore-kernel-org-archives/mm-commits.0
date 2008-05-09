From: akpm@linux-foundation.org
Subject: + pci-hotplug-export-kobject_rename-for-pci_hotplug_core.patch added to -mm tree
Date: Fri, 09 May 2008 12:41:31 -0700
Message-ID: <200805091941.m49JfVlW022539@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47216 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753678AbYEITly (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 May 2008 15:41:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaneshige.kenji@jp.fujitsu.com, achiang@hp.com, greg@kroah.com, kristen.c.accardi@intel.com, lenb@kernel.org


The patch titled
     pci hotplug: export kobject_rename for pci_hotplug_core
has been added to the -mm tree.  Its filename is
     pci-hotplug-export-kobject_rename-for-pci_hotplug_core.patch

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
@@ -483,6 +483,7 @@ out:
 
 	return error;
 }
+EXPORT_SYMBOL_GPL(kobject_rename);
 
 /**
  * kobject_move - move object to another parent
_

Patches currently in -mm which might be from kaneshige.kenji@jp.fujitsu.com are

pci-acpi-fix-uninitialized-variable-in-__pci_osc_support_set.patch
pci-hotplug-construct-one-fakephp-slot-per-pci-slot.patch
pci-hotplug-export-kobject_rename-for-pci_hotplug_core.patch
pci-hotplug-introduce-pci_slot.patch
pci-hotplug-acpi-pci-slot-detection-driver.patch

