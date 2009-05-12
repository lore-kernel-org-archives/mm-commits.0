From: akpm@linux-foundation.org
Subject: + rio-warn_unused_result-warnings-fix.patch added to -mm tree
Date: Tue, 12 May 2009 15:11:34 -0700
Message-ID: <200905122211.n4CMBYAL020276@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52014 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753343AbZELWP3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 May 2009 18:15:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: leoli@freescale.com, benh@kernel.crashing.org, galak@gate.crashing.org, mporter@kernel.crashing.org, zw@zh-kernel.org


The patch titled
     rio: warn_unused_result warnings fix
has been added to the -mm tree.  Its filename is
     rio-warn_unused_result-warnings-fix.patch

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
Subject: rio: warn_unused_result warnings fix
From: Li Yang <leoli@freescale.com>

Adding failure path for the following two cases.

warning: ignoring return value of 'device_add', declared with attribute warn_unused_result
warning: ignoring return value of 'sysfs_create_bin_file', declared with attribute warn_unused_result

Signed-off-by: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Zhang Wei <zw@zh-kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/rio-scan.c  |   44 ++++++++++++++++++++--------------
 drivers/rapidio/rio-sysfs.c |    6 +++-
 2 files changed, 31 insertions(+), 19 deletions(-)

diff -puN drivers/rapidio/rio-scan.c~rio-warn_unused_result-warnings-fix drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rio-warn_unused_result-warnings-fix
+++ a/drivers/rapidio/rio-scan.c
@@ -263,15 +263,21 @@ static void rio_route_set_ops(struct rio
  * device to the RIO device list.  Creates the generic sysfs nodes
  * for an RIO device.
  */
-static void __devinit rio_add_device(struct rio_dev *rdev)
+static int __devinit rio_add_device(struct rio_dev *rdev)
 {
-	device_add(&rdev->dev);
+	int err;
+
+	err = device_add(&rdev->dev);
+	if (err)
+		return err;
 
 	spin_lock(&rio_global_list_lock);
 	list_add_tail(&rdev->global_list, &rio_devices);
 	spin_unlock(&rio_global_list_lock);
 
 	rio_create_sysfs_dev_files(rdev);
+
+	return 0;
 }
 
 /**
@@ -294,13 +300,14 @@ static struct rio_dev *rio_setup_device(
 					struct rio_mport *port, u16 destid,
 					u8 hopcount, int do_enum)
 {
+	int ret = 0;
 	struct rio_dev *rdev;
-	struct rio_switch *rswitch;
+	struct rio_switch *rswitch = NULL;
 	int result, rdid;
 
 	rdev = kzalloc(sizeof(struct rio_dev), GFP_KERNEL);
 	if (!rdev)
-		goto out;
+		return NULL;
 
 	rdev->net = net;
 	rio_mport_read_config_32(port, destid, hopcount, RIO_DEV_ID_CAR,
@@ -343,23 +350,16 @@ static struct rio_dev *rio_setup_device(
 		rio_mport_read_config_32(port, destid, hopcount,
 					 RIO_SWP_INFO_CAR, &rdev->swpinfo);
 		rswitch = kmalloc(sizeof(struct rio_switch), GFP_KERNEL);
-		if (!rswitch) {
-			kfree(rdev);
-			rdev = NULL;
-			goto out;
-		}
+		if (!rswitch)
+			goto cleanup;
 		rswitch->switchid = next_switchid;
 		rswitch->hopcount = hopcount;
 		rswitch->destid = destid;
 		rswitch->route_table = kzalloc(sizeof(u8)*
 					RIO_MAX_ROUTE_ENTRIES(port->sys_size),
 					GFP_KERNEL);
-		if (!rswitch->route_table) {
-			kfree(rdev);
-			rdev = NULL;
-			kfree(rswitch);
-			goto out;
-		}
+		if (!rswitch->route_table)
+			goto cleanup;
 		/* Initialize switch route table */
 		for (rdid = 0; rdid < RIO_MAX_ROUTE_ENTRIES(port->sys_size);
 				rdid++)
@@ -390,10 +390,20 @@ static struct rio_dev *rio_setup_device(
 		rio_init_dbell_res(&rdev->riores[RIO_DOORBELL_RESOURCE],
 				   0, 0xffff);
 
-	rio_add_device(rdev);
+	ret = rio_add_device(rdev);
+	if (ret)
+		goto cleanup;
 
-      out:
 	return rdev;
+
+cleanup:
+	if (rswitch) {
+		if (rswitch->route_table)
+			kfree(rswitch->route_table);
+		kfree(rswitch);
+	}
+	kfree(rdev);
+	return NULL;
 }
 
 /**
diff -puN drivers/rapidio/rio-sysfs.c~rio-warn_unused_result-warnings-fix drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rio-warn_unused_result-warnings-fix
+++ a/drivers/rapidio/rio-sysfs.c
@@ -214,9 +214,11 @@ static struct bin_attribute rio_config_a
  */
 int rio_create_sysfs_dev_files(struct rio_dev *rdev)
 {
-	sysfs_create_bin_file(&rdev->dev.kobj, &rio_config_attr);
+	int err = 0;
 
-	return 0;
+	err = sysfs_create_bin_file(&rdev->dev.kobj, &rio_config_attr);
+
+	return err;
 }
 
 /**
_

Patches currently in -mm which might be from leoli@freescale.com are

rapidio-add-common-mapping-apis-for-rapidio-memory-access.patch
powerpc-fsl_rio-use-law-address-from-device-tree.patch
powerpc-add-memory-map-support-to-freescale-rapidio-block.patch
rionet-add-memory-access-to-simulated-ethernet-over-rapidio.patch
rio-warn_unused_result-warnings-fix.patch
rio-fix-section-mismatch.patch

