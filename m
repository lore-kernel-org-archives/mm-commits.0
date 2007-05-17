From: akpm@linux-foundation.org
Subject: + driver-core-coding-style-cleanup.patch added to -mm tree
Date: Thu, 17 May 2007 11:40:11 -0700
Message-ID: <200705171840.l4HIeB77030201@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41205 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756519AbXEQSlr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 17 May 2007 14:41:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, greg@kroah.com


The patch titled
     Driver core: coding style cleanup
has been added to the -mm tree.  Its filename is
     driver-core-coding-style-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Driver core: coding style cleanup
From: Cornelia Huck <cornelia.huck@de.ibm.com>

This converts code of the form

	if ((error = some_func()))
		goto fixup;
to
	error = some_func();
	if (error)
		goto fixup;

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/bus.c  |    6 ++++--
 drivers/base/core.c |   12 ++++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff -puN drivers/base/bus.c~driver-core-coding-style-cleanup drivers/base/bus.c
--- a/drivers/base/bus.c~driver-core-coding-style-cleanup
+++ a/drivers/base/bus.c
@@ -608,7 +608,8 @@ int bus_add_driver(struct device_driver 
 	if (error)
 		goto out_put_bus;
 	drv->kobj.kset = &bus->drivers;
-	if ((error = kobject_register(&drv->kobj)))
+	error = kobject_register(&drv->kobj);
+	if (error)
 		goto out_put_bus;
 
 	if (drv->bus->drivers_autoprobe) {
@@ -758,7 +759,8 @@ static int bus_add_attrs(struct bus_type
 
 	if (bus->bus_attrs) {
 		for (i = 0; attr_name(bus->bus_attrs[i]); i++) {
-			if ((error = bus_create_file(bus,&bus->bus_attrs[i])))
+			error = bus_create_file(bus,&bus->bus_attrs[i]);
+			if (error)
 				goto Err;
 		}
 	}
diff -puN drivers/base/core.c~driver-core-coding-style-cleanup drivers/base/core.c
--- a/drivers/base/core.c~driver-core-coding-style-cleanup
+++ a/drivers/base/core.c
@@ -764,13 +764,17 @@ int device_add(struct device *dev)
 		if (error)
 			goto ueventattrError;
 	}
-	if ((error = device_add_class_symlinks(dev)))
+	error = device_add_class_symlinks(dev);
+	if (error)
 		goto SymlinkError;
-	if ((error = device_add_attrs(dev)))
+	error = device_add_attrs(dev);
+	if (error)
 		goto AttrsError;
-	if ((error = device_pm_add(dev)))
+	error = device_pm_add(dev);
+	if (error)
 		goto PMError;
-	if ((error = bus_add_device(dev)))
+	error = bus_add_device(dev);
+	if (error)
 		goto BusError;
 	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

driver-core-check-return-code-of-sysfs_create_link.patch
driver-core-coding-style-cleanup.patch
git-s390.patch
partitions-check-the-return-value-of-kobject_add-etc.patch
