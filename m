From: akpm@linux-foundation.org
Subject: + rapidio-add-new-sysfs-attributes.patch added to -mm tree
Date: Fri, 10 Dec 2010 15:24:31 -0800
Message-ID: <201012102324.oBANOVqJ009040@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48044 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531Ab0LJXZE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 10 Dec 2010 18:25:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: add new sysfs attributes
has been added to the -mm tree.  Its filename is
     rapidio-add-new-sysfs-attributes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

 drivers/rapidio/rio-sysfs.c |   39 +++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

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
@@ -52,6 +54,33 @@ static ssize_t routes_show(struct device
 	return (str - buf);
 }
 
+static ssize_t lprev_show(struct device *dev,
+			  struct device_attribute *attr, char *buf)
+{
+	struct rio_dev *rdev = to_rio_dev(dev);
+
+	return sprintf(buf, "%02d %s\n", RIO_GET_PORT_NUM(rdev->swpinfo),
+		       (rdev->prev) ? rio_name(rdev->prev) : "host");
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
+				str += sprintf(str, "%02d %s\n", i,
+					rio_name(rdev->rswitch->nextdev[i]));
+		}
+	}
+
+	return str - buf;
+}
+
 struct device_attribute rio_dev_attrs[] = {
 	__ATTR_RO(did),
 	__ATTR_RO(vid),
@@ -59,10 +88,14 @@ struct device_attribute rio_dev_attrs[] 
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
@@ -218,7 +251,9 @@ int rio_create_sysfs_dev_files(struct ri
 	err = device_create_bin_file(&rdev->dev, &rio_config_attr);
 
 	if (!err && (rdev->pef & RIO_PEF_SWITCH)) {
-		err = device_create_file(&rdev->dev, &dev_attr_routes);
+		err |= device_create_file(&rdev->dev, &dev_attr_routes);
+		err |= device_create_file(&rdev->dev, &dev_attr_lnext);
+		err |= device_create_file(&rdev->dev, &dev_attr_hopcount);
 		if (!err && rdev->rswitch->sw_sysfs)
 			err = rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_CREATE);
 	}
@@ -241,6 +276,8 @@ void rio_remove_sysfs_dev_files(struct r
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

rapidio-use-common-destid-storage-for-endpoints-and-switches.patch
rapidio-integrate-rio_switch-into-rio_dev.patch
rapidio-add-definitions-of-component-tag-fields.patch
rapidio-add-device-object-linking-into-discovery.patch
rapidio-use-component-tag-for-unified-switch-identification.patch
rapidio-add-new-sysfs-attributes.patch
rapidio-add-new-idt-srio-switches.patch

