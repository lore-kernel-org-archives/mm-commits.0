From: akpm@linux-foundation.org
Subject: + ibmebus-dynamic-addition-removal-of-adapters-some-code-cleanup.patch added to -mm tree
Date: Thu, 15 Mar 2007 14:09:15 -0700
Message-ID: <200703152109.l2FL9F09026482@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40855 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbXCOVJ2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Mar 2007 17:09:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: fenkes@de.ibm.com, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     ibmebus: dynamic addition/removal of adapters, some code cleanup
has been added to the -mm tree.  Its filename is
     ibmebus-dynamic-addition-removal-of-adapters-some-code-cleanup.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ibmebus: dynamic addition/removal of adapters, some code cleanup
From: Joachim Fenkes <fenkes@de.ibm.com>

This adds two sysfs attributes to /sys/bus/ibmebus which can be used to notify
the ebus driver of added / removed ebus devices in the OF device tree.

Echoing the device's location code (as found in the OFDT "ibm,loc-code"
property) into the "probe" attribute will notify ebus of addition of the
device and cause the appropriate device driver's probe function to be called
on the device.

Likewise, echoing the location code into the "remove" attribute will cause
the device to be removed from the system.

The writes will block until the respective operation has finished and return
an error code if the operation failed.

In addition, two minor tidbits are fixed:

- The fake root device used to provide a common parent for all ebus devices
  is now based on device instead of of_device - it had no associated devtree
  node. This saves several checks throughout the ebus driver.

- The sysfs attributes are now generated automagically by device_register()
  instead of by the ibmebus code, which saves a few compiler warnings about
  unused return codes.

Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/ibmebus.c |  167 +++++++++++++++++++++++++-------
 include/asm-powerpc/ibmebus.h |    2 
 2 files changed, 134 insertions(+), 35 deletions(-)

diff -puN arch/powerpc/kernel/ibmebus.c~ibmebus-dynamic-addition-removal-of-adapters-some-code-cleanup arch/powerpc/kernel/ibmebus.c
--- a/arch/powerpc/kernel/ibmebus.c~ibmebus-dynamic-addition-removal-of-adapters-some-code-cleanup
+++ a/arch/powerpc/kernel/ibmebus.c
@@ -2,6 +2,7 @@
  * IBM PowerPC IBM eBus Infrastructure Support.
  *
  * Copyright (c) 2005 IBM Corporation
+ *  Joachim Fenkes <fenkes@de.ibm.com>
  *  Heiko J Schick <schickhj@de.ibm.com>
  *
  * All rights reserved.
@@ -43,12 +44,14 @@
 #include <asm/ibmebus.h>
 #include <asm/abs_addr.h>
 
-static struct ibmebus_dev ibmebus_bus_device = { /* fake "parent" device */
-	.name = ibmebus_bus_device.ofdev.dev.bus_id,
-	.ofdev.dev.bus_id = "ibmebus",
-	.ofdev.dev.bus    = &ibmebus_bus_type,
+#define MAX_LOC_CODE_LENGTH 80
+
+static struct device ibmebus_bus_device = { /* fake "parent" device */
+	.bus_id = "ibmebus",
 };
 
+struct bus_type ibmebus_bus_type;
+
 static void *ibmebus_alloc_coherent(struct device *dev,
 				    size_t size,
 				    dma_addr_t *dma_handle,
@@ -158,21 +161,12 @@ static void __devinit ibmebus_dev_releas
 	kfree(to_ibmebus_dev(dev));
 }
 
-static ssize_t ibmebusdev_show_name(struct device *dev,
-				    struct device_attribute *attr, char *buf)
-{
-	return sprintf(buf, "%s\n", to_ibmebus_dev(dev)->name);
-}
-static DEVICE_ATTR(name, S_IRUSR | S_IRGRP | S_IROTH, ibmebusdev_show_name,
-		   NULL);
-
-static struct ibmebus_dev* __devinit ibmebus_register_device_common(
+static int __devinit ibmebus_register_device_common(
 	struct ibmebus_dev *dev, const char *name)
 {
 	int err = 0;
 
-	dev->name = name;
-	dev->ofdev.dev.parent  = &ibmebus_bus_device.ofdev.dev;
+	dev->ofdev.dev.parent  = &ibmebus_bus_device;
 	dev->ofdev.dev.bus     = &ibmebus_bus_type;
 	dev->ofdev.dev.release = ibmebus_dev_release;
 
@@ -186,12 +180,10 @@ static struct ibmebus_dev* __devinit ibm
 	if ((err = of_device_register(&dev->ofdev)) != 0) {
 		printk(KERN_ERR "%s: failed to register device (%d).\n",
 		       __FUNCTION__, err);
-		return NULL;
+		return -ENODEV;
 	}
 
-	device_create_file(&dev->ofdev.dev, &dev_attr_name);
-
-	return dev;
+	return 0;
 }
 
 static struct ibmebus_dev* __devinit ibmebus_register_device_node(
@@ -205,18 +197,18 @@ static struct ibmebus_dev* __devinit ibm
 	if (!loc_code) {
                 printk(KERN_WARNING "%s: node %s missing 'ibm,loc-code'\n",
 		       __FUNCTION__, dn->name ? dn->name : "<unknown>");
-		return NULL;
+		return ERR_PTR(-EINVAL);
         }
 
 	if (strlen(loc_code) == 0) {
 	        printk(KERN_WARNING "%s: 'ibm,loc-code' is invalid\n",
 		       __FUNCTION__);
-		return NULL;
+		return ERR_PTR(-EINVAL);
 	}
 
 	dev = kzalloc(sizeof(struct ibmebus_dev), GFP_KERNEL);
 	if (!dev) {
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	}
 
 	dev->ofdev.node = of_node_get(dn);
@@ -227,9 +219,9 @@ static struct ibmebus_dev* __devinit ibm
 		min(length, BUS_ID_SIZE - 1));
 
 	/* Register with generic device framework. */
-	if (ibmebus_register_device_common(dev, dn->name) == NULL) {
+	if (ibmebus_register_device_common(dev, dn->name) != 0) {
 		kfree(dev);
-		return NULL;
+		return ERR_PTR(-ENODEV);
 	}
 
 	return dev;
@@ -240,9 +232,8 @@ static void ibmebus_probe_of_nodes(char*
 	struct device_node *dn = NULL;
 
 	while ((dn = of_find_node_by_name(dn, name))) {
-		if (ibmebus_register_device_node(dn) == NULL) {
+		if (IS_ERR(ibmebus_register_device_node(dn))) {
 			of_node_put(dn);
-
 			return;
 		}
 	}
@@ -262,9 +253,15 @@ static void ibmebus_add_devices_by_id(st
 	return;
 }
 
-static int ibmebus_match_helper(struct device *dev, void *data)
+static int ibmebus_match_helper_name(struct device *dev, void *data)
 {
-	if (strcmp((char*)data, to_ibmebus_dev(dev)->name) == 0)
+	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
+	char *name;
+
+	name = (char*)get_property(
+		ebus_dev->ofdev.node, "name", NULL);
+
+	if (name && (strcmp((char*)data, name) == 0))
 		return 1;
 
 	return 0;
@@ -272,7 +269,6 @@ static int ibmebus_match_helper(struct d
 
 static int ibmebus_unregister_device(struct device *dev)
 {
-	device_remove_file(dev, &dev_attr_name);
 	of_device_unregister(to_of_device(dev));
 
 	return 0;
@@ -285,11 +281,10 @@ static void ibmebus_remove_devices_by_id
 	while (strlen(idt->name) > 0) {
 		while ((dev = bus_find_device(&ibmebus_bus_type, NULL,
 					      (void*)idt->name,
-					      ibmebus_match_helper))) {
+					      ibmebus_match_helper_name))) {
 			ibmebus_unregister_device(dev);
 		}
 		idt++;
-
 	}
 
 	return;
@@ -307,6 +302,9 @@ int ibmebus_register_driver(struct ibmeb
 	if ((err = driver_register(&drv->driver) != 0))
 		return err;
 
+	/* remove all supported devices first, in case someone
+	 * probed them manually before registering the driver */
+	ibmebus_remove_devices_by_id(drv->id_table);
 	ibmebus_add_devices_by_id(drv->id_table);
 
 	return 0;
@@ -361,9 +359,110 @@ static int ibmebus_bus_match(struct devi
 	return 0;
 }
 
+static ssize_t name_show(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
+	char *name = (char*)get_property(ebus_dev->ofdev.node, "name", NULL);
+	return sprintf(buf, "%s\n", name);
+}
+
+static struct device_attribute ibmebus_dev_attrs[] = {
+	__ATTR_RO(name),
+	__ATTR_NULL
+};
+
+static int ibmebus_match_helper_loc_code(struct device *dev, void *data)
+{
+	const struct ibmebus_dev *ebus_dev = to_ibmebus_dev(dev);
+	char *loc_code;
+
+	loc_code = (char*)get_property(
+		ebus_dev->ofdev.node, "ibm,loc-code", NULL);
+
+	if (loc_code && (strcmp((char*)data, loc_code) == 0))
+		return 1;
+
+	return 0;
+}
+
+static ssize_t ibmebus_store_probe(struct bus_type *bus,
+				   const char *buf, size_t count)
+{
+	struct device_node *dn = NULL;
+	struct ibmebus_dev *dev;
+	char *loc_code;
+	char parm[MAX_LOC_CODE_LENGTH];
+
+	if (count >= MAX_LOC_CODE_LENGTH)
+		return -EINVAL;
+	memcpy(parm, buf, count);
+	parm[count] = '\0';
+	if (parm[count-1] == '\n')
+		parm[count-1] = '\0';
+
+	if (bus_find_device(&ibmebus_bus_type, NULL, parm,
+			     ibmebus_match_helper_loc_code)) {
+		printk(KERN_WARNING "%s: loc_code %s has already been probed\n",
+		       __FUNCTION__, parm);
+		return -EINVAL;
+	}
+
+	while ((dn = of_find_all_nodes(dn))) {
+		loc_code = (char *)get_property(dn, "ibm,loc-code", NULL);
+		if (loc_code && (strncmp(loc_code, parm, count) == 0)) {
+			dev = ibmebus_register_device_node(dn);
+			if (IS_ERR(dev)) {
+				of_node_put(dn);
+				return PTR_ERR(dev);
+			} else
+				return count; /* success */
+		}
+	}
+
+	/* if we drop out of the loop, the loc code was invalid */
+	printk(KERN_WARNING "%s: no device with loc_code %s found\n",
+	       __FUNCTION__, parm);
+	return -ENODEV;
+}
+
+static ssize_t ibmebus_store_remove(struct bus_type *bus,
+				    const char *buf, size_t count)
+{
+	struct device *dev;
+	char parm[MAX_LOC_CODE_LENGTH];
+
+	if (count >= MAX_LOC_CODE_LENGTH)
+		return -EINVAL;
+	memcpy(parm, buf, count);
+	parm[count] = '\0';
+	if (parm[count-1] == '\n')
+		parm[count-1] = '\0';
+
+	/* The location code is unique, so we will find one device at most */
+	if ((dev = bus_find_device(&ibmebus_bus_type, NULL, parm,
+				   ibmebus_match_helper_loc_code))) {
+		ibmebus_unregister_device(dev);
+	} else {
+		printk(KERN_WARNING "%s: loc_code %s not on the bus\n",
+		       __FUNCTION__, parm);
+		return -ENODEV;
+	}
+
+	return count;
+}
+
+static struct bus_attribute ibmebus_bus_attrs[] = {
+	__ATTR(probe, S_IWUSR, NULL, ibmebus_store_probe),
+	__ATTR(remove, S_IWUSR, NULL, ibmebus_store_remove),
+	__ATTR_NULL
+};
+
 struct bus_type ibmebus_bus_type = {
-	.name = "ibmebus",
-	.match = ibmebus_bus_match,
+	.name      = "ibmebus",
+	.match     = ibmebus_bus_match,
+	.dev_attrs = ibmebus_dev_attrs,
+	.bus_attrs = ibmebus_bus_attrs
 };
 EXPORT_SYMBOL(ibmebus_bus_type);
 
@@ -380,7 +479,7 @@ static int __init ibmebus_bus_init(void)
 		return err;
 	}
 
-	err = device_register(&ibmebus_bus_device.ofdev.dev);
+	err = device_register(&ibmebus_bus_device);
 	if (err) {
 		printk(KERN_WARNING "%s: device_register returned %i\n",
 		       __FUNCTION__, err);
diff -puN include/asm-powerpc/ibmebus.h~ibmebus-dynamic-addition-removal-of-adapters-some-code-cleanup include/asm-powerpc/ibmebus.h
--- a/include/asm-powerpc/ibmebus.h~ibmebus-dynamic-addition-removal-of-adapters-some-code-cleanup
+++ a/include/asm-powerpc/ibmebus.h
@@ -2,6 +2,7 @@
  * IBM PowerPC eBus Infrastructure Support.
  *
  * Copyright (c) 2005 IBM Corporation
+ *  Joachim Fenkes <fenkes@de.ibm.com>
  *  Heiko J Schick <schickhj@de.ibm.com>
  *
  * All rights reserved.
@@ -47,7 +48,6 @@
 extern struct bus_type ibmebus_bus_type;
 
 struct ibmebus_dev {
-	const char *name;
 	struct of_device ofdev;
 };
 
_

Patches currently in -mm which might be from fenkes@de.ibm.com are

ibmebus-whitespace-fixes.patch
ibmebus-dynamic-addition-removal-of-adapters-some-code-cleanup.patch
ibmebus-uevent-support.patch
