From: akpm@linux-foundation.org
Subject: + rpadlpar_sysfsc-unbork.patch added to -mm tree
Date: Thu, 08 Nov 2007 20:09:50 -0800
Message-ID: <200711090409.lA949pQ7028701@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49311 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688AbXKIEKx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Nov 2007 23:10:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamalesh@linux.vnet.ibm.com, greg@kroah.com, pbadari@us.ibm.com


The patch titled
     rpadlpar_sysfs.c: unbork
has been added to the -mm tree.  Its filename is
     rpadlpar_sysfsc-unbork.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rpadlpar_sysfs.c: unbork
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

On Tue, Nov 06, 2007 at 10:19:28AM -0800, Badari Pulavarty wrote:
> On Tue, 2007-11-06 at 21:04 +0530, Kamalesh Babulal wrote:
> > Hi Andrew,
> >
> > The build fails with following error
> >
> >   CC      drivers/pci/hotplug/rpadlpar_sysfs.o
> > drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: initializer element is not constant
> > drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: (near initialization for `dlpar_io_kset.kobj.parent')
> > drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: initializer element is not constant
> > drivers/pci/hotplug/rpadlpar_sysfs.c:133: error: (near initialization for `dlpar_io_kset.kobj')
> > drivers/pci/hotplug/rpadlpar_sysfs.c:134: error: unknown field `ktype' specified in initializer
> > drivers/pci/hotplug/rpadlpar_sysfs.c:134: warning: initialization from incompatible pointer type
> > make[3]: *** [drivers/pci/hotplug/rpadlpar_sysfs.o] Error 1
> > make[2]: *** [drivers/pci/hotplug] Error 2
> > make[1]: *** [drivers/pci] Error 2
> > make: *** [drivers] Error 2
> >
> > The patch, gregkh-driver-kset-convert-pci-hotplug-to-use-kset_create_and_register.patch
> > is causing the build failure.
>
> Here is the fix (against 24-rc1 mm-brokenout). Can you try it ?
>
> Thanks,
> Badari

Hi Badari,

This patch fixes the buidl failure.

Tested-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/hotplug/rpadlpar_sysfs.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN drivers/pci/hotplug/rpadlpar_sysfs.c~rpadlpar_sysfsc-unbork drivers/pci/hotplug/rpadlpar_sysfs.c
--- a/drivers/pci/hotplug/rpadlpar_sysfs.c~rpadlpar_sysfsc-unbork
+++ a/drivers/pci/hotplug/rpadlpar_sysfs.c
@@ -129,14 +129,13 @@ struct kobj_type ktype_dlpar_io = {
 };
 
 struct kset dlpar_io_kset = {
-	.kobj = {.ktype = &ktype_dlpar_io,
-		 .parent = &pci_hotplug_slots_kset->kobj},
-	.ktype = &ktype_dlpar_io,
+	.kobj = {.ktype = &ktype_dlpar_io},
 };
 
 int dlpar_sysfs_init(void)
 {
 	kobject_set_name(&dlpar_io_kset.kobj, DLPAR_KOBJ_NAME);
+	dlpar_io_kset.kobj.parent = &pci_hotplug_slots_kset->kobj;
 	if (kset_register(&dlpar_io_kset)) {
 		printk(KERN_ERR "rpadlpar_io: cannot register kset for %s\n",
 				kobject_name(&dlpar_io_kset.kobj));
_

Patches currently in -mm which might be from kamalesh@linux.vnet.ibm.com are

origin.patch
rpadlpar_sysfsc-unbork.patch
sclp_cpi_sysc-unbork.patch
add-dma-engine-driver-for-freescale-mpc85xx-processors-fix.patch
