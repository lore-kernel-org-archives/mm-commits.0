From: akpm@osdl.org
Subject: - ipmi-pass-sysfs-name-from-lower-level-driver.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:17:31 -0800
Message-ID: <200612072317.kB7NHVBZ030934@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:53855 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163860AbWLGXRe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:17:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minyard@acm.org, mm-commits@vger.kernel.org


The patch titled
     IPMI: pass sysfs name from lower level driver
has been removed from the -mm tree.  Its filename was
     ipmi-pass-sysfs-name-from-lower-level-driver.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: IPMI: pass sysfs name from lower level driver
From: Corey Minyard <minyard@acm.org>

Pass in the sysfs name from the lower-level IPMI driver, as the coming IPMI
serial driver will need that to link properly from the serial device sysfs
directory.

Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/char/ipmi/ipmi_msghandler.c |   34 +++++++++++++++++++++-----
 drivers/char/ipmi/ipmi_si_intf.c    |    1 
 include/linux/ipmi_smi.h            |    1 
 3 files changed, 30 insertions(+), 6 deletions(-)

diff -puN drivers/char/ipmi/ipmi_msghandler.c~ipmi-pass-sysfs-name-from-lower-level-driver drivers/char/ipmi/ipmi_msghandler.c
--- a/drivers/char/ipmi/ipmi_msghandler.c~ipmi-pass-sysfs-name-from-lower-level-driver
+++ a/drivers/char/ipmi/ipmi_msghandler.c
@@ -205,6 +205,7 @@ struct ipmi_smi
 
 	struct bmc_device *bmc;
 	char *my_dev_name;
+	char *sysfs_name;
 
 	/* This is the lower-layer's sender routine. */
 	struct ipmi_smi_handlers *handlers;
@@ -2004,7 +2005,11 @@ static void ipmi_bmc_unregister(ipmi_smi
 {
 	struct bmc_device *bmc = intf->bmc;
 
-	sysfs_remove_link(&intf->si_dev->kobj, "bmc");
+	if (intf->sysfs_name) {
+		sysfs_remove_link(&intf->si_dev->kobj, intf->sysfs_name);
+		kfree(intf->sysfs_name);
+		intf->sysfs_name = NULL;
+	}
 	if (intf->my_dev_name) {
 		sysfs_remove_link(&bmc->dev->dev.kobj, intf->my_dev_name);
 		kfree(intf->my_dev_name);
@@ -2140,7 +2145,8 @@ out:
 	return err;
 }
 
-static int ipmi_bmc_register(ipmi_smi_t intf)
+static int ipmi_bmc_register(ipmi_smi_t intf, int ifnum,
+			     const char *sysfs_name)
 {
 	int               rv;
 	struct bmc_device *bmc = intf->bmc;
@@ -2257,29 +2263,44 @@ static int ipmi_bmc_register(ipmi_smi_t 
 	 * create symlink from system interface device to bmc device
 	 * and back.
 	 */
+	intf->sysfs_name = kstrdup(sysfs_name, GFP_KERNEL);
+	if (!intf->sysfs_name) {
+		rv = -ENOMEM;
+		printk(KERN_ERR
+		       "ipmi_msghandler: allocate link to BMC: %d\n",
+		       rv);
+		goto out_err;
+	}
+
 	rv = sysfs_create_link(&intf->si_dev->kobj,
-			       &bmc->dev->dev.kobj, "bmc");
+			       &bmc->dev->dev.kobj, intf->sysfs_name);
 	if (rv) {
+		kfree(intf->sysfs_name);
+		intf->sysfs_name = NULL;
 		printk(KERN_ERR
 		       "ipmi_msghandler: Unable to create bmc symlink: %d\n",
 		       rv);
 		goto out_err;
 	}
 
-	size = snprintf(dummy, 0, "ipmi%d", intf->intf_num);
+	size = snprintf(dummy, 0, "ipmi%d", ifnum);
 	intf->my_dev_name = kmalloc(size+1, GFP_KERNEL);
 	if (!intf->my_dev_name) {
+		kfree(intf->sysfs_name);
+		intf->sysfs_name = NULL;
 		rv = -ENOMEM;
 		printk(KERN_ERR
 		       "ipmi_msghandler: allocate link from BMC: %d\n",
 		       rv);
 		goto out_err;
 	}
-	snprintf(intf->my_dev_name, size+1, "ipmi%d", intf->intf_num);
+	snprintf(intf->my_dev_name, size+1, "ipmi%d", ifnum);
 
 	rv = sysfs_create_link(&bmc->dev->dev.kobj, &intf->si_dev->kobj,
 			       intf->my_dev_name);
 	if (rv) {
+		kfree(intf->sysfs_name);
+		intf->sysfs_name = NULL;
 		kfree(intf->my_dev_name);
 		intf->my_dev_name = NULL;
 		printk(KERN_ERR
@@ -2464,6 +2485,7 @@ int ipmi_register_smi(struct ipmi_smi_ha
 		      void		       *send_info,
 		      struct ipmi_device_id    *device_id,
 		      struct device            *si_dev,
+		      const char               *sysfs_name,
 		      unsigned char            slave_addr)
 {
 	int              i, j;
@@ -2579,7 +2601,7 @@ int ipmi_register_smi(struct ipmi_smi_ha
 	if (rv == 0)
 		rv = add_proc_entries(intf, i);
 
-	rv = ipmi_bmc_register(intf);
+	rv = ipmi_bmc_register(intf, i, sysfs_name);
 
  out:
 	if (rv) {
diff -puN drivers/char/ipmi/ipmi_si_intf.c~ipmi-pass-sysfs-name-from-lower-level-driver drivers/char/ipmi/ipmi_si_intf.c
--- a/drivers/char/ipmi/ipmi_si_intf.c~ipmi-pass-sysfs-name-from-lower-level-driver
+++ a/drivers/char/ipmi/ipmi_si_intf.c
@@ -2362,6 +2362,7 @@ static int try_smi_init(struct smi_info 
 			       new_smi,
 			       &new_smi->device_id,
 			       new_smi->dev,
+			       "bmc",
 			       new_smi->slave_addr);
 	if (rv) {
 		printk(KERN_ERR
diff -puN include/linux/ipmi_smi.h~ipmi-pass-sysfs-name-from-lower-level-driver include/linux/ipmi_smi.h
--- a/include/linux/ipmi_smi.h~ipmi-pass-sysfs-name-from-lower-level-driver
+++ a/include/linux/ipmi_smi.h
@@ -173,6 +173,7 @@ int ipmi_register_smi(struct ipmi_smi_ha
 		      void                     *send_info,
 		      struct ipmi_device_id    *device_id,
 		      struct device            *dev,
+		      const char               *sysfs_name,
 		      unsigned char            slave_addr);
 
 /*
_

Patches currently in -mm which might be from minyard@acm.org are

origin.patch

