From: akpm@linux-foundation.org
Subject: + rapidio-modify-sysfs-initialization-for-switches.patch added to -mm tree
Date: Tue, 14 Sep 2010 15:21:23 -0700
Message-ID: <201009142221.o8EMLNHI021810@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48518 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755178Ab0INWWA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Sep 2010 18:22:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: alexandre.bounine@idt.com, galak@kernel.crashing.org, leoli@freescale.com, micha@neli.hopto.org, mporter@kernel.crashing.org, thomas.moll@sysgo.com


The patch titled
     rapidio: modify sysfs initialization for switches
has been added to the -mm tree.  Its filename is
     rapidio-modify-sysfs-initialization-for-switches.patch

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
Subject: rapidio: modify sysfs initialization for switches
From: Alexandre Bounine <alexandre.bounine@idt.com>

1. Change to create attribute "routes" only for switches.

2. Add a switch-specific callback to create/remove proprietary attributes.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Thomas Moll <thomas.moll@sysgo.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Micha Nelissen <micha@neli.hopto.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-sysfs.c |   26 +++++++++++++++++++-------
 include/linux/rio.h         |    6 ++++++
 2 files changed, 25 insertions(+), 7 deletions(-)

diff -puN drivers/rapidio/rio-sysfs.c~rapidio-modify-sysfs-initialization-for-switches drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-modify-sysfs-initialization-for-switches
+++ a/drivers/rapidio/rio-sysfs.c
@@ -40,9 +40,6 @@ static ssize_t routes_show(struct device
 	char *str = buf;
 	int i;
 
-	if (!rdev->rswitch)
-		goto out;
-
 	for (i = 0; i < RIO_MAX_ROUTE_ENTRIES(rdev->net->hport->sys_size);
 			i++) {
 		if (rdev->rswitch->route_table[i] == RIO_INVALID_ROUTE)
@@ -52,7 +49,6 @@ static ssize_t routes_show(struct device
 			    rdev->rswitch->route_table[i]);
 	}
 
-      out:
 	return (str - buf);
 }
 
@@ -63,10 +59,11 @@ struct device_attribute rio_dev_attrs[] 
 	__ATTR_RO(asm_did),
 	__ATTR_RO(asm_vid),
 	__ATTR_RO(asm_rev),
-	__ATTR_RO(routes),
 	__ATTR_NULL,
 };
 
+static DEVICE_ATTR(routes, S_IRUGO, routes_show, NULL);
+
 static ssize_t
 rio_read_config(struct file *filp, struct kobject *kobj,
 		struct bin_attribute *bin_attr,
@@ -218,7 +215,17 @@ int rio_create_sysfs_dev_files(struct ri
 {
 	int err = 0;
 
-	err = sysfs_create_bin_file(&rdev->dev.kobj, &rio_config_attr);
+	err = device_create_bin_file(&rdev->dev, &rio_config_attr);
+
+	if (!err && rdev->rswitch) {
+		err = device_create_file(&rdev->dev, &dev_attr_routes);
+		if (!err && rdev->rswitch->sw_sysfs)
+			err = rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_CREATE);
+	}
+
+	if (err)
+		pr_warning("RIO: Failed to create attribute file(s) for %s\n",
+			   rio_name(rdev));
 
 	return err;
 }
@@ -231,5 +238,10 @@ int rio_create_sysfs_dev_files(struct ri
  */
 void rio_remove_sysfs_dev_files(struct rio_dev *rdev)
 {
-	sysfs_remove_bin_file(&rdev->dev.kobj, &rio_config_attr);
+	device_remove_bin_file(&rdev->dev, &rio_config_attr);
+	if (rdev->rswitch) {
+		device_remove_file(&rdev->dev, &dev_attr_routes);
+		if (rdev->rswitch->sw_sysfs)
+			rdev->rswitch->sw_sysfs(rdev, RIO_SW_SYSFS_REMOVE);
+	}
 }
diff -puN include/linux/rio.h~rapidio-modify-sysfs-initialization-for-switches include/linux/rio.h
--- a/include/linux/rio.h~rapidio-modify-sysfs-initialization-for-switches
+++ a/include/linux/rio.h
@@ -218,6 +218,10 @@ struct rio_net {
 	unsigned char id;	/* RIO network ID */
 };
 
+/* Definitions used by switch sysfs initialization callback */
+#define RIO_SW_SYSFS_CREATE	1	/* Create switch attributes */
+#define RIO_SW_SYSFS_REMOVE	0	/* Remove switch attributes */
+
 /**
  * struct rio_switch - RIO switch info
  * @node: Node in global list of switches
@@ -234,6 +238,7 @@ struct rio_net {
  * @get_domain: Callback for switch-specific domain get function
  * @em_init: Callback for switch-specific error management initialization function
  * @em_handle: Callback for switch-specific error management handler function
+ * @sw_sysfs: Callback that initializes switch-specific sysfs attributes
  * @nextdev: Array of per-port pointers to the next attached device
  */
 struct rio_switch {
@@ -256,6 +261,7 @@ struct rio_switch {
 			   u8 *sw_domain);
 	int (*em_init) (struct rio_dev *dev);
 	int (*em_handle) (struct rio_dev *dev, u8 swport);
+	int (*sw_sysfs) (struct rio_dev *dev, int create);
 	struct rio_dev *nextdev[0];
 };
 
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-fix-rapidio-sysfs-hierarchy.patch
rapidio-powerpc-85xx-modify-rio-port-write-interrupt-handler.patch
rapidio-use-stored-ingress-port-number-instead-of-register-read.patch
rapidio-add-relation-links-between-rio-device-structures.patch
rapidio-add-default-handler-for-error-stopped-state.patch
rapidio-modify-sysfs-initialization-for-switches.patch
rapidio-add-handling-of-orphan-port-write-message.patch
rapidio-add-device-access-check-into-the-enumeration.patch
rapidio-add-support-for-idt-cps-gen2-switches.patch
rapidio-add-handling-of-redundant-routes.patch

