From: akpm@linux-foundation.org
Subject: + fix-3-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch added to -mm tree
Date: Tue, 18 Sep 2007 09:52:36 -0700
Message-ID: <200709181652.l8IGqam7013634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52642 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759893AbXIRQxN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Sep 2007 12:53:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com, greg@kroah.com


The patch titled
     fix gregkh-driver-kobject-remove-the-static-array-for-the-name 3
has been added to the -mm tree.  Its filename is
     fix-3-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fix gregkh-driver-kobject-remove-the-static-array-for-the-name 3
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

Using the kobject_set_name function to set the kobject k_name.

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/rpadlpar_sysfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/pci/hotplug/rpadlpar_sysfs.c~fix-3-gregkh-driver-kobject-remove-the-static-array-for-the-name drivers/pci/hotplug/rpadlpar_sysfs.c
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c~fix-3-gregkh-driver-kobject-remove-the-static-array-for-the-name
+++ a/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -129,17 +129,17 @@ struct kobj_type ktype_dlpar_io = {
 };
 
 struct kset dlpar_io_kset = {
-	.kobj = {.name = DLPAR_KOBJ_NAME,
-		 .ktype = &ktype_dlpar_io,
-		 .parent = &pci_hotplug_slots_subsys.kobj},
+	.kobj = {.ktype = &ktype_dlpar_io,
+		.parent = &pci_hotplug_slots_subsys.kobj},
 	.ktype = &ktype_dlpar_io,
 };
 
 int dlpar_sysfs_init(void)
 {
+	kobject_set_name(&dlpar_io_kset.kobj, DLPAR_KOBJ_NAME);
 	if (kset_register(&dlpar_io_kset)) {
 		printk(KERN_ERR "rpadlpar_io: cannot register kset for %s\n",
-				dlpar_io_kset.kobj.name);
+				dlpar_io_kset.kobj.k_name);
 		return -EINVAL;
 	}
 
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

fix-3-gregkh-driver-kobject-remove-the-static-array-for-the-name.patch
memoryless-nodes-fixup-uses-of-node_online_map-in-generic-code-fix.patch
