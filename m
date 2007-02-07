From: akpm@linux-foundation.org
Subject: - cxgb3-vs-gregkh-driver-network-device.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:53:04 -0800
Message-ID: <200702071953.l17Jr4Wh025294@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33769 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422907AbXBGTxn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:53:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: divy@chelsio.com, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     cxgb3: sysfs attributes in -mm tree
has been removed from the -mm tree.  Its filename was
     cxgb3-vs-gregkh-driver-network-device.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: cxgb3: sysfs attributes in -mm tree
From: Divy Le Ray <divy@chelsio.com>

This patch fixes the usage of sysfs attributes in cxgb3 for the -mm tree.
It is built against the driver commited in the -mm tree.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/cxgb3/cxgb3_main.c |   86 ++++++++++++++++---------------
 1 file changed, 45 insertions(+), 41 deletions(-)

diff -puN drivers/net/cxgb3/cxgb3_main.c~cxgb3-vs-gregkh-driver-network-device drivers/net/cxgb3/cxgb3_main.c
--- a/drivers/net/cxgb3/cxgb3_main.c~cxgb3-vs-gregkh-driver-network-device
+++ a/drivers/net/cxgb3/cxgb3_main.c
@@ -74,8 +74,6 @@ enum {
 
 #define EEPROM_MAGIC 0x38E2F10C
 
-#define to_net_dev(class) container_of(class, struct net_device, class_dev)
-
 #define CH_DEVICE(devid, ssid, idx) \
 	{ PCI_VENDOR_ID_CHELSIO, devid, PCI_ANY_ID, ssid, 0, 0, idx }
 
@@ -434,11 +432,12 @@ static int setup_sge_qsets(struct adapte
 	return 0;
 }
 
-static ssize_t attr_show(struct class_device *cd, char *buf,
+static ssize_t attr_show(struct device *d, struct device_attribute *attr,
+			 char *buf,
 			 ssize_t(*format) (struct adapter *, char *))
 {
 	ssize_t len;
-	struct adapter *adap = to_net_dev(cd)->priv;
+	struct adapter *adap = to_net_dev(d)->priv;
 
 	/* Synchronize with ioctls that may shut down the device */
 	rtnl_lock();
@@ -447,14 +446,15 @@ static ssize_t attr_show(struct class_de
 	return len;
 }
 
-static ssize_t attr_store(struct class_device *cd, const char *buf, size_t len,
+static ssize_t attr_store(struct device *d, struct device_attribute *attr,
+			  const char *buf, size_t len,
 			  ssize_t(*set) (struct adapter *, unsigned int),
 			  unsigned int min_val, unsigned int max_val)
 {
 	char *endp;
 	ssize_t ret;
 	unsigned int val;
-	struct adapter *adap = to_net_dev(cd)->priv;
+	struct adapter *adap = to_net_dev(d)->priv;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -476,9 +476,10 @@ static ssize_t format_##name(struct adap
 { \
 	return sprintf(buf, "%u\n", val_expr); \
 } \
-static ssize_t show_##name(struct class_device *cd, char *buf) \
+static ssize_t show_##name(struct device *d, struct device_attribute *attr, \
+			   char *buf) \
 { \
-	return attr_show(cd, buf, format_##name); \
+	return attr_show(d, attr, buf, format_##name); \
 }
 
 static ssize_t set_nfilters(struct adapter *adap, unsigned int val)
@@ -493,10 +494,10 @@ static ssize_t set_nfilters(struct adapt
 	return 0;
 }
 
-static ssize_t store_nfilters(struct class_device *cd, const char *buf,
-			      size_t len)
+static ssize_t store_nfilters(struct device *d, struct device_attribute *attr,
+			      const char *buf, size_t len)
 {
-	return attr_store(cd, buf, len, set_nfilters, 0, ~0);
+	return attr_store(d, attr, buf, len, set_nfilters, 0, ~0);
 }
 
 static ssize_t set_nservers(struct adapter *adap, unsigned int val)
@@ -509,38 +510,39 @@ static ssize_t set_nservers(struct adapt
 	return 0;
 }
 
-static ssize_t store_nservers(struct class_device *cd, const char *buf,
-			      size_t len)
+static ssize_t store_nservers(struct device *d, struct device_attribute *attr,
+			      const char *buf, size_t len)
 {
-	return attr_store(cd, buf, len, set_nservers, 0, ~0);
+	return attr_store(d, attr, buf, len, set_nservers, 0, ~0);
 }
 
 #define CXGB3_ATTR_R(name, val_expr) \
 CXGB3_SHOW(name, val_expr) \
-static CLASS_DEVICE_ATTR(name, S_IRUGO, show_##name, NULL)
+static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL)
 
 #define CXGB3_ATTR_RW(name, val_expr, store_method) \
 CXGB3_SHOW(name, val_expr) \
-static CLASS_DEVICE_ATTR(name, S_IRUGO | S_IWUSR, show_##name, store_method)
+static DEVICE_ATTR(name, S_IRUGO | S_IWUSR, show_##name, store_method)
 
 CXGB3_ATTR_R(cam_size, t3_mc5_size(&adap->mc5));
 CXGB3_ATTR_RW(nfilters, adap->params.mc5.nfilters, store_nfilters);
 CXGB3_ATTR_RW(nservers, adap->params.mc5.nservers, store_nservers);
 
 static struct attribute *cxgb3_attrs[] = {
-	&class_device_attr_cam_size.attr,
-	&class_device_attr_nfilters.attr,
-	&class_device_attr_nservers.attr,
+	&dev_attr_cam_size.attr,
+	&dev_attr_nfilters.attr,
+	&dev_attr_nservers.attr,
 	NULL
 };
 
 static struct attribute_group cxgb3_attr_group = {.attrs = cxgb3_attrs };
 
-static ssize_t tm_attr_show(struct class_device *cd, char *buf, int sched)
+static ssize_t tm_attr_show(struct device *d, struct device_attribute *attr,
+			    char *buf, int sched)
 {
 	ssize_t len;
 	unsigned int v, addr, bpt, cpt;
-	struct adapter *adap = to_net_dev(cd)->priv;
+	struct adapter *adap = to_net_dev(d)->priv;
 
 	addr = A_TP_TX_MOD_Q1_Q0_RATE_LIMIT - sched / 2;
 	rtnl_lock();
@@ -560,13 +562,13 @@ static ssize_t tm_attr_show(struct class
 	return len;
 }
 
-static ssize_t tm_attr_store(struct class_device *cd, const char *buf,
-			     size_t len, int sched)
+static ssize_t tm_attr_store(struct device *d, struct device_attribute *attr,
+			     const char *buf, size_t len, int sched)
 {
 	char *endp;
 	ssize_t ret;
 	unsigned int val;
-	struct adapter *adap = to_net_dev(cd)->priv;
+	struct adapter *adap = to_net_dev(d)->priv;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
@@ -584,15 +586,17 @@ static ssize_t tm_attr_store(struct clas
 }
 
 #define TM_ATTR(name, sched) \
-static ssize_t show_##name(struct class_device *cd, char *buf) \
+static ssize_t show_##name(struct device *d, struct device_attribute *attr, \
+			   char *buf) \
 { \
-	return tm_attr_show(cd, buf, sched); \
+	return tm_attr_show(d, attr, buf, sched); \
 } \
-static ssize_t store_##name(struct class_device *cd, const char *buf, size_t len) \
+static ssize_t store_##name(struct device *d, struct device_attribute *attr, \
+			    const char *buf, size_t len) \
 { \
-	return tm_attr_store(cd, buf, len, sched); \
+	return tm_attr_store(d, attr, buf, len, sched); \
 } \
-static CLASS_DEVICE_ATTR(name, S_IRUGO | S_IWUSR, show_##name, store_##name)
+static DEVICE_ATTR(name, S_IRUGO | S_IWUSR, show_##name, store_##name)
 
 TM_ATTR(sched0, 0);
 TM_ATTR(sched1, 1);
@@ -604,14 +608,14 @@ TM_ATTR(sched6, 6);
 TM_ATTR(sched7, 7);
 
 static struct attribute *offload_attrs[] = {
-	&class_device_attr_sched0.attr,
-	&class_device_attr_sched1.attr,
-	&class_device_attr_sched2.attr,
-	&class_device_attr_sched3.attr,
-	&class_device_attr_sched4.attr,
-	&class_device_attr_sched5.attr,
-	&class_device_attr_sched6.attr,
-	&class_device_attr_sched7.attr,
+	&dev_attr_sched0.attr,
+	&dev_attr_sched1.attr,
+	&dev_attr_sched2.attr,
+	&dev_attr_sched3.attr,
+	&dev_attr_sched4.attr,
+	&dev_attr_sched5.attr,
+	&dev_attr_sched6.attr,
+	&dev_attr_sched7.attr,
 	NULL
 };
 
@@ -836,7 +840,7 @@ static int offload_open(struct net_devic
 	init_smt(adapter);
 
 	/* Never mind if the next step fails */
-	sysfs_create_group(&tdev->lldev->class_dev.kobj, &offload_attr_group);
+	sysfs_create_group(&tdev->lldev->dev.kobj, &offload_attr_group);
 
 	/* Call back all registered clients */
 	cxgb3_add_clients(tdev);
@@ -861,7 +865,7 @@ static int offload_close(struct t3cdev *
 	/* Call back all registered clients */
 	cxgb3_remove_clients(tdev);
 
-	sysfs_remove_group(&tdev->lldev->class_dev.kobj, &offload_attr_group);
+	sysfs_remove_group(&tdev->lldev->dev.kobj, &offload_attr_group);
 
 	tdev->lldev = NULL;
 	cxgb3_set_dummy_ops(tdev);
@@ -2420,7 +2424,7 @@ static int __devinit init_one(struct pci
 	else if (msi > 0 && pci_enable_msi(pdev) == 0)
 		adapter->flags |= USING_MSI;
 
-	err = sysfs_create_group(&adapter->port[0]->class_dev.kobj,
+	err = sysfs_create_group(&adapter->port[0]->dev.kobj,
 				 &cxgb3_attr_group);
 
 	print_port_info(adapter, ai);
@@ -2452,7 +2456,7 @@ static void __devexit remove_one(struct 
 		struct adapter *adapter = dev->priv;
 
 		t3_sge_stop(adapter);
-		sysfs_remove_group(&adapter->port[0]->class_dev.kobj,
+		sysfs_remove_group(&adapter->port[0]->dev.kobj,
 				   &cxgb3_attr_group);
 
 		for_each_port(adapter, i)
_

Patches currently in -mm which might be from divy@chelsio.com are

git-netdev-all.patch
