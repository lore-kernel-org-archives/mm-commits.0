From: akpm@linux-foundation.org
Subject: [merged]
 rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:25:57 -0700
Message-ID: <53446965.FojLafm1iewEPOPK%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56989 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756232AbaDHVZ6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:25:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stef.van.os@prodrive-technologies.com, rob@landley.net, mporter@kernel.crashing.org, leoli@freescale.com, jerry.jacobs@prodrive-technologies.com, galak@kernel.crashing.org, arno.tiemersma@prodrive-technologies.com, andre.van.herk@prodrive-technologies.com, alexandre.bounine@idt.com

Subject: [merged] rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices.patch removed from -mm tree
To: alexandre.bounine@idt.com,andre.van.herk@prodrive-technologies.com,arno.tiemersma@prodrive-technologies.com,galak@kernel.crashing.org,jerry.jacobs@prodrive-technologies.com,leoli@freescale.com,mporter@kernel.crashing.org,rob@landley.net,stef.van.os@prodrive-technologies.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:25:57 -0700


The patch titled
     Subject: rapidio: rework device hierarchy and introduce mport class of devices
has been removed from the -mm tree.  Its filename was
     rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: rework device hierarchy and introduce mport class of devices

This patch removes an artificial RapidIO bus root device and establishes
actual device hierarchy by providing reference to real parent devices.  It
also introduces device class for RapidIO controller devices (on-chip or an
eternal bridge, known as "mport").

Existing implementation was sufficient for SoC-based platforms that have a
single RapidIO controller.  With introduction of devices using multiple
RapidIO controllers and PCIe-to-RapidIO bridges the old scheme is very
limiting or does not work at all.  The implemented changes allow to
properly reference platform's local RapidIO mport devices and provide
device details needed for upper layers.

This change to RapidIO device hierarchy does not break any known existing
kernel or user space interfaces.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@prodrive-technologies.com>
Cc: Stef van Os <stef.van.os@prodrive-technologies.com>
Cc: Jerry Jacobs <jerry.jacobs@prodrive-technologies.com>
Cc: Arno Tiemersma <arno.tiemersma@prodrive-technologies.com>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/rapidio/sysfs.txt  |   66 +++++++++++++++++++++++++----
 arch/powerpc/sysdev/fsl_rio.c    |    1 
 drivers/net/rionet.c             |    1 
 drivers/rapidio/devices/tsi721.c |    1 
 drivers/rapidio/rio-driver.c     |   22 ++++++---
 drivers/rapidio/rio-scan.c       |    1 
 drivers/rapidio/rio-sysfs.c      |   40 +++++++++++++++++
 drivers/rapidio/rio.c            |   11 ++++
 drivers/rapidio/rio.h            |    1 
 include/linux/rio.h              |    5 +-
 10 files changed, 133 insertions(+), 16 deletions(-)

diff -puN Documentation/rapidio/sysfs.txt~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices Documentation/rapidio/sysfs.txt
--- a/Documentation/rapidio/sysfs.txt~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices
+++ a/Documentation/rapidio/sysfs.txt
@@ -2,8 +2,8 @@
 
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
-1. Device Subdirectories
-------------------------
+1. RapidIO Device Subdirectories
+--------------------------------
 
 For each RapidIO device, the RapidIO subsystem creates files in an individual
 subdirectory with the following name, /sys/bus/rapidio/devices/<device_name>.
@@ -25,8 +25,8 @@ seen by the enumerating host (destID = 1
 NOTE: An enumerating or discovering endpoint does not create a sysfs entry for
 itself, this is why an endpoint with destID=1 is not shown in the list.
 
-2. Attributes Common for All Devices
-------------------------------------
+2. Attributes Common for All RapidIO Devices
+--------------------------------------------
 
 Each device subdirectory contains the following informational read-only files:
 
@@ -52,16 +52,16 @@ This attribute is similar in behavior to
 and provides an access to the RapidIO device registers using standard file read
 and write operations.
 
-3. Endpoint Device Attributes
------------------------------
+3. RapidIO Endpoint Device Attributes
+-------------------------------------
 
 Currently Linux RapidIO subsystem does not create any endpoint specific sysfs
 attributes. It is possible that RapidIO master port drivers and endpoint device
 drivers will add their device-specific sysfs attributes but such attributes are
 outside the scope of this document.
 
-4. Switch Device Attributes
----------------------------
+4. RapidIO Switch Device Attributes
+-----------------------------------
 
 RapidIO switches have additional attributes in sysfs. RapidIO subsystem supports
 common and device-specific sysfs attributes for switches. Because switches are
@@ -106,3 +106,53 @@ attribute:
 	 for that controller always will be 0.
 	 To initiate RapidIO enumeration/discovery on all available mports
 	 a user must write '-1' (or RIO_MPORT_ANY) into this attribute file.
+
+
+6. RapidIO Bus Controllers/Ports
+--------------------------------
+
+On-chip RapidIO controllers and PCIe-to-RapidIO bridges (referenced as
+"Master Port" or "mport") are presented in sysfs as the special class of
+devices: "rapidio_port".
+
+The /sys/class/rapidio_port subdirectory contains individual subdirectories
+named as "rapidioN" where N = mport ID registered with RapidIO subsystem.
+
+NOTE: An mport ID is not a RapidIO destination ID assigned to a given local
+mport device.
+
+Each mport device subdirectory in addition to standard entries contains the
+following device-specific attributes:
+
+   port_destid - reports RapidIO destination ID assigned to the given RapidIO
+                 mport device. If value 0xFFFFFFFF is returned this means that
+                 no valid destination ID have been assigned to the mport (yet).
+                 Normally, before enumeration/discovery have been executed only
+                 fabric enumerating mports have a valid destination ID assigned
+                 to them using "hdid=..." rapidio module parameter.
+      sys_size - reports RapidIO common transport system size:
+                   0 = small (8-bit destination ID, max. 256 devices),
+                   1 = large (16-bit destination ID, max. 65536 devices).
+
+After enumeration or discovery was performed for a given mport device,
+the corresponding subdirectory will also contain subdirectories for each
+child RapidIO device connected to the mport. Naming conventions for RapidIO
+devices are described in Section 1 above.
+
+The example below shows mport device subdirectory with several child RapidIO
+devices attached to it.
+
+[rio@rapidio ~]$ ls /sys/class/rapidio_port/rapidio0/ -l
+total 0
+drwxr-xr-x 3 root root    0 Feb 11 15:10 00:e:0001
+drwxr-xr-x 3 root root    0 Feb 11 15:10 00:e:0004
+drwxr-xr-x 3 root root    0 Feb 11 15:10 00:e:0007
+drwxr-xr-x 3 root root    0 Feb 11 15:10 00:s:0002
+drwxr-xr-x 3 root root    0 Feb 11 15:10 00:s:0003
+drwxr-xr-x 3 root root    0 Feb 11 15:10 00:s:0005
+lrwxrwxrwx 1 root root    0 Feb 11 15:11 device -> ../../../0000:01:00.0
+-r--r--r-- 1 root root 4096 Feb 11 15:11 port_destid
+drwxr-xr-x 2 root root    0 Feb 11 15:11 power
+lrwxrwxrwx 1 root root    0 Feb 11 15:04 subsystem -> ../../../../../../class/rapidio_port
+-r--r--r-- 1 root root 4096 Feb 11 15:11 sys_size
+-rw-r--r-- 1 root root 4096 Feb 11 15:04 uevent
diff -puN arch/powerpc/sysdev/fsl_rio.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices arch/powerpc/sysdev/fsl_rio.c
--- a/arch/powerpc/sysdev/fsl_rio.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices
+++ a/arch/powerpc/sysdev/fsl_rio.c
@@ -531,6 +531,7 @@ int fsl_rio_setup(struct platform_device
 		sprintf(port->name, "RIO mport %d", i);
 
 		priv->dev = &dev->dev;
+		port->dev.parent = &dev->dev;
 		port->ops = ops;
 		port->priv = priv;
 		port->phys_efptr = 0x100;
diff -puN drivers/net/rionet.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices drivers/net/rionet.c
--- a/drivers/net/rionet.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices
+++ a/drivers/net/rionet.c
@@ -493,6 +493,7 @@ static int rionet_setup_netdev(struct ri
 	ndev->netdev_ops = &rionet_netdev_ops;
 	ndev->mtu = RIO_MAX_MSG_SIZE - 14;
 	ndev->features = NETIF_F_LLTX;
+	SET_NETDEV_DEV(ndev, &mport->dev);
 	SET_ETHTOOL_OPS(ndev, &rionet_ethtool_ops);
 
 	spin_lock_init(&rnet->lock);
diff -puN drivers/rapidio/devices/tsi721.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices drivers/rapidio/devices/tsi721.c
--- a/drivers/rapidio/devices/tsi721.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices
+++ a/drivers/rapidio/devices/tsi721.c
@@ -2256,6 +2256,7 @@ static int tsi721_setup_mport(struct tsi
 	mport->phy_type = RIO_PHY_SERIAL;
 	mport->priv = (void *)priv;
 	mport->phys_efptr = 0x100;
+	mport->dev.parent = &pdev->dev;
 	priv->mport = mport;
 
 	INIT_LIST_HEAD(&mport->dbells);
diff -puN drivers/rapidio/rio-driver.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices drivers/rapidio/rio-driver.c
--- a/drivers/rapidio/rio-driver.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices
+++ a/drivers/rapidio/rio-driver.c
@@ -167,7 +167,6 @@ void rio_unregister_driver(struct rio_dr
 void rio_attach_device(struct rio_dev *rdev)
 {
 	rdev->dev.bus = &rio_bus_type;
-	rdev->dev.parent = &rio_bus;
 }
 EXPORT_SYMBOL_GPL(rio_attach_device);
 
@@ -216,9 +215,12 @@ static int rio_uevent(struct device *dev
 	return 0;
 }
 
-struct device rio_bus = {
-	.init_name = "rapidio",
+struct class rio_mport_class = {
+	.name		= "rapidio_port",
+	.owner		= THIS_MODULE,
+	.dev_groups	= rio_mport_groups,
 };
+EXPORT_SYMBOL_GPL(rio_mport_class);
 
 struct bus_type rio_bus_type = {
 	.name = "rapidio",
@@ -233,14 +235,20 @@ struct bus_type rio_bus_type = {
 /**
  *  rio_bus_init - Register the RapidIO bus with the device model
  *
- *  Registers the RIO bus device and RIO bus type with the Linux
+ *  Registers the RIO mport device class and RIO bus type with the Linux
  *  device model.
  */
 static int __init rio_bus_init(void)
 {
-	if (device_register(&rio_bus) < 0)
-		printk("RIO: failed to register RIO bus device\n");
-	return bus_register(&rio_bus_type);
+	int ret;
+
+	ret = class_register(&rio_mport_class);
+	if (!ret) {
+		ret = bus_register(&rio_bus_type);
+		if (ret)
+			class_unregister(&rio_mport_class);
+	}
+	return ret;
 }
 
 postcore_initcall(rio_bus_init);
diff -puN drivers/rapidio/rio-scan.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices
+++ a/drivers/rapidio/rio-scan.c
@@ -461,6 +461,7 @@ static struct rio_dev *rio_setup_device(
 			     rdev->comp_tag & RIO_CTAG_UDEVID);
 	}
 
+	rdev->dev.parent = &port->dev;
 	rio_attach_device(rdev);
 
 	device_initialize(&rdev->dev);
diff -puN drivers/rapidio/rio-sysfs.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices drivers/rapidio/rio-sysfs.c
--- a/drivers/rapidio/rio-sysfs.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices
+++ a/drivers/rapidio/rio-sysfs.c
@@ -341,3 +341,43 @@ const struct attribute_group *rio_bus_gr
 	&rio_bus_group,
 	NULL,
 };
+
+static ssize_t
+port_destid_show(struct device *dev, struct device_attribute *attr,
+		 char *buf)
+{
+	struct rio_mport *mport = to_rio_mport(dev);
+
+	if (mport)
+		return sprintf(buf, "0x%04x\n", mport->host_deviceid);
+	else
+		return -ENODEV;
+}
+static DEVICE_ATTR_RO(port_destid);
+
+static ssize_t sys_size_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	struct rio_mport *mport = to_rio_mport(dev);
+
+	if (mport)
+		return sprintf(buf, "%u\n", mport->sys_size);
+	else
+		return -ENODEV;
+}
+static DEVICE_ATTR_RO(sys_size);
+
+static struct attribute *rio_mport_attrs[] = {
+	&dev_attr_port_destid.attr,
+	&dev_attr_sys_size.attr,
+	NULL,
+};
+
+static const struct attribute_group rio_mport_group = {
+	.attrs = rio_mport_attrs,
+};
+
+const struct attribute_group *rio_mport_groups[] = {
+	&rio_mport_group,
+	NULL,
+};
diff -puN drivers/rapidio/rio.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices
+++ a/drivers/rapidio/rio.c
@@ -1884,6 +1884,7 @@ static int rio_get_hdid(int index)
 int rio_register_mport(struct rio_mport *port)
 {
 	struct rio_scan_node *scan = NULL;
+	int res = 0;
 
 	if (next_portid >= RIO_MAX_MPORTS) {
 		pr_err("RIO: reached specified max number of mports\n");
@@ -1894,6 +1895,16 @@ int rio_register_mport(struct rio_mport
 	port->host_deviceid = rio_get_hdid(port->id);
 	port->nscan = NULL;
 
+	dev_set_name(&port->dev, "rapidio%d", port->id);
+	port->dev.class = &rio_mport_class;
+
+	res = device_register(&port->dev);
+	if (res)
+		dev_err(&port->dev, "RIO: mport%d registration failed ERR=%d\n",
+			port->id, res);
+	else
+		dev_dbg(&port->dev, "RIO: mport%d registered\n", port->id);
+
 	mutex_lock(&rio_mport_list_lock);
 	list_add_tail(&port->node, &rio_mports);
 
diff -puN drivers/rapidio/rio.h~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices
+++ a/drivers/rapidio/rio.h
@@ -50,6 +50,7 @@ extern int rio_mport_scan(int mport_id);
 /* Structures internal to the RIO core code */
 extern const struct attribute_group *rio_dev_groups[];
 extern const struct attribute_group *rio_bus_groups[];
+extern const struct attribute_group *rio_mport_groups[];
 
 #define RIO_GET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x00ff0000) >> 16))
 #define RIO_SET_DID(size, x)	(size ? (x & 0xffff) : ((x & 0x000000ff) << 16))
diff -puN include/linux/rio.h~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices include/linux/rio.h
--- a/include/linux/rio.h~rapidio-rework-device-hierarchy-and-introduce-mport-class-of-devices
+++ a/include/linux/rio.h
@@ -83,7 +83,7 @@
 #define RIO_CTAG_UDEVID	0x0001ffff /* Unique device identifier */
 
 extern struct bus_type rio_bus_type;
-extern struct device rio_bus;
+extern struct class rio_mport_class;
 
 struct rio_mport;
 struct rio_dev;
@@ -201,6 +201,7 @@ struct rio_dev {
 #define rio_dev_f(n) list_entry(n, struct rio_dev, net_list)
 #define	to_rio_dev(n) container_of(n, struct rio_dev, dev)
 #define sw_to_rio_dev(n) container_of(n, struct rio_dev, rswitch[0])
+#define	to_rio_mport(n) container_of(n, struct rio_mport, dev)
 
 /**
  * struct rio_msg - RIO message event
@@ -248,6 +249,7 @@ enum rio_phy_type {
  * @phy_type: RapidIO phy type
  * @phys_efptr: RIO port extended features pointer
  * @name: Port name string
+ * @dev: device structure associated with an mport
  * @priv: Master port private data
  * @dma: DMA device associated with mport
  * @nscan: RapidIO network enumeration/discovery operations
@@ -272,6 +274,7 @@ struct rio_mport {
 	enum rio_phy_type phy_type;	/* RapidIO phy type */
 	u32 phys_efptr;
 	unsigned char name[RIO_MAX_MPORT_NAME];
+	struct device dev;
 	void *priv;		/* Master port private data */
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 	struct dma_device	dma;
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

origin.patch

