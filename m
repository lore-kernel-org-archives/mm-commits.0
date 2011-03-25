From: akpm@linux-foundation.org
Subject: [merged] rapidio-add-new-sysfs-attributes.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:26:01 -0700
Message-ID: <201103250725.p2P7PtGS026085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754164Ab1CYH0k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:26:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com, mm-commits@vger.kernel.org


The patch titled
     rapidio: add new sysfs attributes
has been removed from the -mm tree.  Its filename was
     rapidio-add-new-sysfs-attributes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rapidio: add new sysfs attributes
From: Alexandre Bounine <alexandre.bounine@idt.com>

Add new sysfs attributes.

1. Routing information required to to reach the RIO device:
destid - device destination ID (real for for endpoint, route for switch)
hopcount - hopcount for maintenance requests (switches only)

2. device linking information:
lprev - name of device that precedes the given device in the enumeration
        or discovery order (displayed along with of the port to which it
        is attached).
lnext - names of devices (with corresponding port numbers) that are
        attached to the given device as next in the enumeration or
        discovery order (switches only)

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-sysfs.c |   41 +++++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff -puN drivers/rapidio/rio-sysfs.c~rapidio-add-new-sysfs-attributes drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-add-new-sysfs-attributes
+++ a/drivers/rapidio/rio-sysfs.c
@@ -33,6 +33,8 @@ rio_config_attr(device_rev, "0x%08x\n");
 rio_config_attr(asm_did, "0x%04x\n");
 rio_config_attr(asm_vid, "0x%04x\n");
 rio_config_attr(asm_rev, "0x%04x\n");
+rio_config_attr(destid, "0x%04x\n");
+rio_config_attr(hopcount, "0x%02x\n");
 
 static ssize_t routes_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
@@ -52,6 +54,35 @@ static ssize_t routes_show(struct device
 	return (str - buf);
 }
 
+static ssize_t lprev_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct rio_dev *rdev = to_rio_dev(dev);
+
+	return sprintf(buf, "%s\n",
+			(rdev->prev) ? rio_name(rdev->prev) : "root");
+}
+
+static ssize_t lnext_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct rio_dev *rdev = to_rio_dev(dev);
+	char *str = buf;
+	int i;
+
+	if (rdev->pef & RIO_PEF_SWITCH) {
+		for (i = 0; i < RIO_GET_TOTAL_PORTS(rdev->swpinfo); i++) {
+			if (rdev->rswitch->nextdev[i])
+				str += sprintf(str, "%s\n",
+					rio_name(rdev->rswitch->nextdev[i]));
+			else
+				str += sprintf(str, "null\n");
+		}
+	}
+
+	return str - buf;
+}
+
 struct device_attribute rio_dev_attrs[] = {
 	__ATTR_RO(did),
 	__ATTR_RO(vid),
@@ -59,10 +90,14 @@ struct device_attribute rio_dev_attrs[] 
 	__ATTR_RO(asm_did),
 	__ATTR_RO(asm_vid),
 	__ATTR_RO(asm_rev),
+	__ATTR_RO(lprev),
+	__ATTR_RO(destid),
 	__ATTR_NULL,
 };
 
 static DEVICE_ATTR(routes, S_IRUGO, routes_show, NULL);
+static DEVICE_ATTR(lnext, S_IRUGO, lnext_show, NULL);
+static DEVICE_ATTR(hopcount, S_IRUGO, hopcount_show, NULL);
 
 static ssize_t
 rio_read_config(struct file *filp, struct kobject *kobj,
@@ -218,7 +253,9 @@ int rio_create_sysfs_dev_files(struct ri
 	err = device_create_bin_file(&rdev->dev, &rio_config_attr);
 
 	if (!err && (rdev->pef & RIO_PEF_SWITCH)) {
-		err = device_create_file(&rdev->dev, &dev_attr_routes);
+		err |= device_create_file(&rdev->dev, &dev_attr_routes);
+		err |= device_create_file(&rdev->dev, &dev_attr_lnext);
+		err |= device_create_file(&rdev->dev, &dev_attr_hopcount);
 		if (!err && rdev->rswitch->sw_sysfs)
 			err = rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_CREATE);
 	}
@@ -241,6 +278,8 @@ void rio_remove_sysfs_dev_files(struct r
 	device_remove_bin_file(&rdev->dev, &rio_config_attr);
 	if (rdev->pef & RIO_PEF_SWITCH) {
 		device_remove_file(&rdev->dev, &dev_attr_routes);
+		device_remove_file(&rdev->dev, &dev_attr_lnext);
+		device_remove_file(&rdev->dev, &dev_attr_hopcount);
 		if (rdev->rswitch->sw_sysfs)
 			rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_REMOVE);
 	}
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

