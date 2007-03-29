From: akpm@linux-foundation.org
Subject: + driver-core-suppress-uevents-via-filter.patch added to -mm tree
Date: Thu, 29 Mar 2007 15:06:04 -0700
Message-ID: <200703292206.l2TM64fX013330@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40796 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422671AbXC2WG6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 29 Mar 2007 18:06:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: cornelia.huck@de.ibm.com, eric.rannaud@gmail.com, greg@kroah.com, heiko.carstens@de.ibm.com, kay.sievers@vrfy.org


The patch titled
     Driver core: suppress uevents via filter
has been added to the -mm tree.  Its filename is
     driver-core-suppress-uevents-via-filter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Driver core: suppress uevents via filter
From: Cornelia Huck <cornelia.huck@de.ibm.com>

Suppress uevents for devices if uevent_suppress is set via
dev_uevent_filter().  This makes the driver core suppress all device uevents,
not just the add event in device_add().

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg K-H <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Eric Rannaud <eric.rannaud@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/core.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/base/core.c~driver-core-suppress-uevents-via-filter drivers/base/core.c
--- a/drivers/base/core.c~driver-core-suppress-uevents-via-filter
+++ a/drivers/base/core.c
@@ -134,6 +134,8 @@ static int dev_uevent_filter(struct kset
 
 	if (ktype == &ktype_device) {
 		struct device *dev = to_dev(kobj);
+		if (dev->uevent_suppress)
+			return 0;
 		if (dev->bus)
 			return 1;
 		if (dev->class)
@@ -689,8 +691,7 @@ int device_add(struct device *dev)
 		goto PMError;
 	if ((error = bus_add_device(dev)))
 		goto BusError;
-	if (!dev->uevent_suppress)
-		kobject_uevent(&dev->kobj, KOBJ_ADD);
+	kobject_uevent(&dev->kobj, KOBJ_ADD);
 	bus_attach_device(dev);
 	if (parent)
 		klist_add_tail(&dev->knode_parent, &parent->klist_children);
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

origin.patch
driver-core-suppress-uevents-via-filter.patch
driver-core-switch-firmware_class-to.patch
s390-cio-delay-uevents-for-subchannels.patch
git-s390.patch
