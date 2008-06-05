From: akpm@linux-foundation.org
Subject: + kobject-export-kobject_rename-for-pci_hotplug_core.patch added to -mm tree
Date: Wed, 04 Jun 2008 22:49:06 -0700
Message-ID: <200806050549.m555n6Ri028117@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751733AbYFEFuI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jun 2008 01:50:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kaneshige.kenji@jp.fujitsu.com, achiang@hp.com, greg@kroah.com, kristen.c.accardi@intel.com, lenb@kernel.org


The patch titled
     kobject: Export kobject_rename for pci_hotplug_core
has been added to the -mm tree.  Its filename is
     kobject-export-kobject_rename-for-pci_hotplug_core.patch

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

diff -puN lib/kobject.c~kobject-export-kobject_rename-for-pci_hotplug_core lib/kobject.c
--- a/lib/kobject.c~kobject-export-kobject_rename-for-pci_hotplug_core
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
fakephp-construct-one-fakephp-slot-per-pci-slot.patch
kobject-export-kobject_rename-for-pci_hotplug_core.patch
pci-introduce-pci_slot.patch
acpi-pci-slot-detection-driver.patch

