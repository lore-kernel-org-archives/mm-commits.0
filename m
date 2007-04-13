From: akpm@linux-foundation.org
Subject: - driver-core-suppress-uevents-via-filter.patch removed from -mm tree
Date: Fri, 13 Apr 2007 16:28:43 -0700
Message-ID: <200704132328.l3DNShbx012544@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60398 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161053AbXDMX3B (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Apr 2007 19:29:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, eric.rannaud@gmail.com, greg@kroah.com, heiko.carstens@de.ibm.com, kay.sievers@vrfy.org, mm-commits@vger.kernel.org


The patch titled
     Driver core: suppress uevents via filter
has been removed from the -mm tree.  Its filename was
     driver-core-suppress-uevents-via-filter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/base/core.c~driver-core-suppress-uevents-via-filter drivers/base/core.c
--- a/drivers/base/core.c~driver-core-suppress-uevents-via-filter
+++ a/drivers/base/core.c
@@ -120,6 +120,8 @@ static int dev_uevent_filter(struct kset
 
 	if (ktype == &ktype_device) {
 		struct device *dev = to_dev(kobj);
+		if (dev->uevent_suppress)
+			return 0;
 		if (dev->bus)
 			return 1;
 		if (dev->class)
@@ -675,8 +677,7 @@ int device_add(struct device *dev)
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

s390-cio-delay-uevents-for-subchannels.patch
uevent-use-add_uevent_var-instead-of-open-coding-it.patch
device_schedule_callback-needs-a-module-reference-fix.patch
git-s390.patch
partitions-check-the-return-value-of-kobject_add-etc.patch
kprobes-the-on-off-knob-thru-debugfs-updated-s390-fix.patch
