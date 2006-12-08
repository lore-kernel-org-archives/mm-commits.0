From: akpm@osdl.org
Subject: - s390-add-modalias-to-uevent-for-ccw-devices.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:05:03 -0800
Message-ID: <200612081105.kB8B531Z018611@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48759 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425375AbWLHLFm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:05:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bastian@waldi.eu.org, heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     s390: add MODALIAS to uevent for ccw devices
has been removed from the -mm tree.  Its filename was
     s390-add-modalias-to-uevent-for-ccw-devices.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: s390: add MODALIAS to uevent for ccw devices
From: Bastian Blank <bastian@waldi.eu.org>


Add a MODALIAS line to the uevents generated for ccw devices.  udev uses
them to load modules.

Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/s390/cio/device.c |   40 ++++++++++++++++++++++++++----------
 1 files changed, 29 insertions(+), 11 deletions(-)

diff -puN drivers/s390/cio/device.c~s390-add-modalias-to-uevent-for-ccw-devices drivers/s390/cio/device.c
--- devel/drivers/s390/cio/device.c~s390-add-modalias-to-uevent-for-ccw-devices	2006-03-05 23:11:56.000000000 -0800
+++ devel-akpm/drivers/s390/cio/device.c	2006-03-05 23:12:18.000000000 -0800
@@ -35,7 +35,7 @@
  * subsystem driver and one channel system per machine, but
  * we still use the abstraction. T.R. says it's a good idea. */
 static int
-ccw_bus_match (struct device * dev, struct device_driver * drv)
+ccw_bus_match (struct device *dev, struct device_driver *drv)
 {
 	struct ccw_device *cdev = to_ccwdev(dev);
 	struct ccw_driver *cdrv = to_ccwdrv(drv);
@@ -53,6 +53,22 @@ ccw_bus_match (struct device * dev, stru
 	return 1;
 }
 
+static ssize_t
+modalias_print (struct ccw_device *cdev, char *buf, size_t size)
+{
+	struct ccw_device_id *id = &(cdev->id);
+	ssize_t len;
+
+	len = snprintf(buf, size, "ccw:t%04Xm%02X",
+			id->cu_type, id->cu_model);
+	if (id->dev_type != 0)
+		len += snprintf(buf + len, size - len, "dt%04Xdm%02X",
+				id->dev_type, id->dev_model);
+	else
+		len += snprintf(buf + len, size - len, "dtdm");
+	return len;
+}
+
 /*
  * Hotplugging interface for ccw devices.
  * Heavily modeled on pci and usb hotplug.
@@ -100,6 +116,14 @@ ccw_uevent (struct device *dev, char **e
 			   cdev->id.dev_model);
 	if ((buffer_size - length <= 0) || (i >= num_envp))
 		return -ENOMEM;
+	++length;
+	buffer += length;
+
+	envp[i++] = buffer;
+	length += scnprintf(buffer, buffer_size - length, "MODALIAS=");
+	length += modalias_print(cdev, buffer + length, buffer_size - length);
+	if ((buffer_size - length <= 0) || (i >= num_envp))
+		return -ENOMEM;
 
 	envp[i] = 0;
 
@@ -251,17 +275,11 @@ static ssize_t
 modalias_show (struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct ccw_device *cdev = to_ccwdev(dev);
-	struct ccw_device_id *id = &(cdev->id);
-	int ret;
+	ssize_t len;
 
-	ret = sprintf(buf, "ccw:t%04Xm%02X",
-			id->cu_type, id->cu_model);
-	if (id->dev_type != 0)
-		ret += sprintf(buf + ret, "dt%04Xdm%02X\n",
-				id->dev_type, id->dev_model);
-	else
-		ret += sprintf(buf + ret, "dtdm\n");
-	return ret;
+	len = modalias_print(cdev, buf, PAGE_SIZE);
+	len += snprintf(buf + len, PAGE_SIZE - len, "\n");
+	return len;
 }
 
 static ssize_t
_

Patches currently in -mm which might be from bastian@waldi.eu.org are


