From: akpm@osdl.org
Subject: - s390-use-dev-groups-for-subchannel-attributes.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:23:42 -0800
Message-ID: <200612062223.kB6MNg4t018551@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48309 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937730AbWLFWYQ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:24:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cornelia.huck@de.ibm.com, greg@kroah.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: use dev->groups for subchannel attributes
has been removed from the -mm tree.  Its filename was
     s390-use-dev-groups-for-subchannel-attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: s390: use dev->groups for subchannel attributes
From: Cornelia Huck <cornelia.huck@de.ibm.com>

Use dev->groups for adding/removing the subchannel attribute group.

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/s390/cio/css.c    |    5 +----
 drivers/s390/cio/css.h    |    1 +
 drivers/s390/cio/device.c |   16 +++++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff -puN drivers/s390/cio/css.c~s390-use-dev-groups-for-subchannel-attributes drivers/s390/cio/css.c
--- a/drivers/s390/cio/css.c~s390-use-dev-groups-for-subchannel-attributes
+++ a/drivers/s390/cio/css.c
@@ -137,6 +137,7 @@ css_register_subchannel(struct subchanne
 	sch->dev.parent = &css[0]->device;
 	sch->dev.bus = &css_bus_type;
 	sch->dev.release = &css_subchannel_release;
+	sch->dev.groups = subch_attr_groups;
 
 	/* make it known to the system */
 	ret = css_sch_device_register(sch);
@@ -146,10 +147,6 @@ css_register_subchannel(struct subchanne
 		return ret;
 	}
 	css_get_ssd_info(sch);
-	ret = subchannel_add_files(&sch->dev);
-	if (ret)
-		printk(KERN_WARNING "%s: could not add attributes to %s\n",
-		       __func__, sch->dev.bus_id);
 	return ret;
 }
 
diff -puN drivers/s390/cio/css.h~s390-use-dev-groups-for-subchannel-attributes drivers/s390/cio/css.h
--- a/drivers/s390/cio/css.h~s390-use-dev-groups-for-subchannel-attributes
+++ a/drivers/s390/cio/css.h
@@ -193,4 +193,5 @@ extern struct workqueue_struct *slow_pat
 extern struct work_struct slow_path_work;
 
 int subchannel_add_files (struct device *);
+extern struct attribute_group *subch_attr_groups[];
 #endif
diff -puN drivers/s390/cio/device.c~s390-use-dev-groups-for-subchannel-attributes drivers/s390/cio/device.c
--- a/drivers/s390/cio/device.c~s390-use-dev-groups-for-subchannel-attributes
+++ a/drivers/s390/cio/device.c
@@ -235,9 +235,11 @@ chpids_show (struct device * dev, struct
 	ssize_t ret = 0;
 	int chp;
 
-	for (chp = 0; chp < 8; chp++)
-		ret += sprintf (buf+ret, "%02x ", ssd->chpid[chp]);
-
+	if (ssd)
+		for (chp = 0; chp < 8; chp++)
+			ret += sprintf (buf+ret, "%02x ", ssd->chpid[chp]);
+	else
+		ret += sprintf (buf, "n/a");
 	ret += sprintf (buf+ret, "\n");
 	return min((ssize_t)PAGE_SIZE, ret);
 }
@@ -529,10 +531,10 @@ static struct attribute_group subch_attr
 	.attrs = subch_attrs,
 };
 
-int subchannel_add_files (struct device *dev)
-{
-	return sysfs_create_group(&dev->kobj, &subch_attr_group);
-}
+struct attribute_group *subch_attr_groups[] = {
+	&subch_attr_group,
+	NULL,
+};
 
 static struct attribute * ccwdev_attrs[] = {
 	&dev_attr_devtype.attr,
_

Patches currently in -mm which might be from cornelia.huck@de.ibm.com are

origin.patch
driver-core-per-subsystem-multithreaded-probing.patch
driver-core-dont-fail-attaching-the-device-if-it.patch
git-s390.patch
tty-switch-to-ktermios-sclp-fix.patch

