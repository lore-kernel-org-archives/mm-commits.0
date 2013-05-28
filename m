From: akpm@linux-foundation.org
Subject: [merged] rapidio-make-enumeration-discovery-configurable.patch
 removed from -mm tree
Date: Tue, 28 May 2013 12:36:34 -0700
Message-ID: <51a50742.70vcPhuDY/mDuJdp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab3E1Tgf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 May 2013 15:36:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mporter@kernel.crashing.org, micha.nelissen@Prodrive.nl, leoli@freescale.com, galak@kernel.crashing.org, andre.van.herk@Prodrive.nl, alexandre.bounine@idt.com

Subject: [merged] rapidio-make-enumeration-discovery-configurable.patch removed from -mm tree
To: alexandre.bounine@idt.com,andre.van.herk@Prodrive.nl,galak@kernel.crashing.org,leoli@freescale.com,micha.nelissen@Prodrive.nl,mporter@kernel.crashing.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 May 2013 12:36:34 -0700


The patch titled
     Subject: rapidio: make enumeration/discovery configurable
has been removed from the -mm tree.  Its filename was
     rapidio-make-enumeration-discovery-configurable.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Alexandre Bounine <alexandre.bounine@idt.com>
Subject: rapidio: make enumeration/discovery configurable

Systems that use RapidIO fabric may need to implement their own
enumeration and discovery methods which are better suitable for needs of a
target application.

The following set of patches is intended to simplify process of
introduction of new RapidIO fabric enumeration/discovery methods.

The first patch offers ability to add new RapidIO enumeration/discovery
methods using kernel configuration options.  This new configuration option
mechanism allows to select statically linked or modular
enumeration/discovery method(s) from the list of existing methods or use
external module(s).

This patch also updates the currently existing enumeration/discovery code
to be used as a statically linked or modular method.  The corresponding
configuration option is named "Basic enumeration/discovery" method.  This
is the only one configuration option available today but new methods are
expected to be introduced after adoption of provided patches.

The second patch address a long time complaint of RapidIO subsystem users
regarding fabric enumeration/discovery start sequence.  Existing
implementation offers only a boot-time enumeration/discovery start which
requires synchronized boot of all endpoints in RapidIO network.  While it
works for small closed configurations with limited number of endpoints,
using this approach in systems with large number of endpoints is quite
challenging.

To eliminate requirement for synchronized start the second patch
introduces RapidIO enumeration/discovery start from user space.

For compatibility with the existing RapidIO subsystem implementation,
automatic boot time enumeration/discovery start can be configured in by
specifying "rio-scan.scan=1" command line parameter if statically linked
basic enumeration method is selected.



This patch:

Rework to implement RapidIO enumeration/discovery method selection
combined with ability to use enumeration/discovery as a kernel module.

This patch adds ability to introduce new RapidIO enumeration/discovery
methods using kernel configuration options.  Configuration option
mechanism allows to select statically linked or modular
enumeration/discovery method from the list of existing methods or use
external modules.  If a modular enumeration/discovery is selected each
RapidIO mport device can have its own method attached to it.

The existing enumeration/discovery code was updated to be used as
statically linked or modular method.  This configuration option is named
"Basic enumeration/discovery" method.

Several common routines have been moved from rio-scan.c to make them
available to other enumeration methods and reduce number of exported
symbols.

Signed-off-by: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Li Yang <leoli@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>
Cc: Andre van Herk <andre.van.herk@Prodrive.nl>
Cc: Micha Nelissen <micha.nelissen@Prodrive.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rapidio/Kconfig      |   20 ++
 drivers/rapidio/Makefile     |    3 
 drivers/rapidio/rio-driver.c |    7 +
 drivers/rapidio/rio-scan.c   |  166 +++++-------------------
 drivers/rapidio/rio.c        |  222 +++++++++++++++++++++++++++++++--
 drivers/rapidio/rio.h        |   11 +
 include/linux/rio.h          |   13 +
 include/linux/rio_drv.h      |    1 
 8 files changed, 304 insertions(+), 139 deletions(-)

diff -puN drivers/rapidio/Kconfig~rapidio-make-enumeration-discovery-configurable drivers/rapidio/Kconfig
--- a/drivers/rapidio/Kconfig~rapidio-make-enumeration-discovery-configurable
+++ a/drivers/rapidio/Kconfig
@@ -47,4 +47,24 @@ config RAPIDIO_DEBUG
 
 	  If you are unsure about this, say N here.
 
+choice
+	prompt "Enumeration method"
+	depends on RAPIDIO
+	default RAPIDIO_ENUM_BASIC
+	help
+	  There are different enumeration and discovery mechanisms offered
+	  for RapidIO subsystem. You may select single built-in method or
+	  or any number of methods to be built as modules.
+	  Selecting a built-in method disables use of loadable methods.
+
+	  If unsure, select Basic built-in.
+
+config RAPIDIO_ENUM_BASIC
+	tristate "Basic"
+	help
+	  This option includes basic RapidIO fabric enumeration and discovery
+	  mechanism similar to one described in RapidIO specification Annex 1.
+
+endchoice
+
 source "drivers/rapidio/switches/Kconfig"
diff -puN drivers/rapidio/Makefile~rapidio-make-enumeration-discovery-configurable drivers/rapidio/Makefile
--- a/drivers/rapidio/Makefile~rapidio-make-enumeration-discovery-configurable
+++ a/drivers/rapidio/Makefile
@@ -1,7 +1,8 @@
 #
 # Makefile for RapidIO interconnect services
 #
-obj-y += rio.o rio-access.o rio-driver.o rio-scan.o rio-sysfs.o
+obj-y += rio.o rio-access.o rio-driver.o rio-sysfs.o
+obj-$(CONFIG_RAPIDIO_ENUM_BASIC) += rio-scan.o
 
 obj-$(CONFIG_RAPIDIO)		+= switches/
 obj-$(CONFIG_RAPIDIO)		+= devices/
diff -puN drivers/rapidio/rio-driver.c~rapidio-make-enumeration-discovery-configurable drivers/rapidio/rio-driver.c
--- a/drivers/rapidio/rio-driver.c~rapidio-make-enumeration-discovery-configurable
+++ a/drivers/rapidio/rio-driver.c
@@ -164,6 +164,13 @@ void rio_unregister_driver(struct rio_dr
 	driver_unregister(&rdrv->driver);
 }
 
+void rio_attach_device(struct rio_dev *rdev)
+{
+	rdev->dev.bus = &rio_bus_type;
+	rdev->dev.parent = &rio_bus;
+}
+EXPORT_SYMBOL_GPL(rio_attach_device);
+
 /**
  *  rio_match_bus - Tell if a RIO device structure has a matching RIO driver device id structure
  *  @dev: the standard device structure to match against
diff -puN drivers/rapidio/rio-scan.c~rapidio-make-enumeration-discovery-configurable drivers/rapidio/rio-scan.c
--- a/drivers/rapidio/rio-scan.c~rapidio-make-enumeration-discovery-configurable
+++ a/drivers/rapidio/rio-scan.c
@@ -37,12 +37,8 @@
 
 #include "rio.h"
 
-LIST_HEAD(rio_devices);
-
 static void rio_init_em(struct rio_dev *rdev);
 
-DEFINE_SPINLOCK(rio_global_list_lock);
-
 static int next_destid = 0;
 static int next_comptag = 1;
 
@@ -327,127 +323,6 @@ static int rio_is_switch(struct rio_dev
 }
 
 /**
- * rio_switch_init - Sets switch operations for a particular vendor switch
- * @rdev: RIO device
- * @do_enum: Enumeration/Discovery mode flag
- *
- * Searches the RIO switch ops table for known switch types. If the vid
- * and did match a switch table entry, then call switch initialization
- * routine to setup switch-specific routines.
- */
-static void rio_switch_init(struct rio_dev *rdev, int do_enum)
-{
-	struct rio_switch_ops *cur = __start_rio_switch_ops;
-	struct rio_switch_ops *end = __end_rio_switch_ops;
-
-	while (cur < end) {
-		if ((cur->vid == rdev->vid) && (cur->did == rdev->did)) {
-			pr_debug("RIO: calling init routine for %s\n",
-				 rio_name(rdev));
-			cur->init_hook(rdev, do_enum);
-			break;
-		}
-		cur++;
-	}
-
-	if ((cur >= end) && (rdev->pef & RIO_PEF_STD_RT)) {
-		pr_debug("RIO: adding STD routing ops for %s\n",
-			rio_name(rdev));
-		rdev->rswitch->add_entry = rio_std_route_add_entry;
-		rdev->rswitch->get_entry = rio_std_route_get_entry;
-		rdev->rswitch->clr_table = rio_std_route_clr_table;
-	}
-
-	if (!rdev->rswitch->add_entry || !rdev->rswitch->get_entry)
-		printk(KERN_ERR "RIO: missing routing ops for %s\n",
-		       rio_name(rdev));
-}
-
-/**
- * rio_add_device- Adds a RIO device to the device model
- * @rdev: RIO device
- *
- * Adds the RIO device to the global device list and adds the RIO
- * device to the RIO device list.  Creates the generic sysfs nodes
- * for an RIO device.
- */
-static int rio_add_device(struct rio_dev *rdev)
-{
-	int err;
-
-	err = device_add(&rdev->dev);
-	if (err)
-		return err;
-
-	spin_lock(&rio_global_list_lock);
-	list_add_tail(&rdev->global_list, &rio_devices);
-	spin_unlock(&rio_global_list_lock);
-
-	rio_create_sysfs_dev_files(rdev);
-
-	return 0;
-}
-
-/**
- * rio_enable_rx_tx_port - enable input receiver and output transmitter of
- * given port
- * @port: Master port associated with the RIO network
- * @local: local=1 select local port otherwise a far device is reached
- * @destid: Destination ID of the device to check host bit
- * @hopcount: Number of hops to reach the target
- * @port_num: Port (-number on switch) to enable on a far end device
- *
- * Returns 0 or 1 from on General Control Command and Status Register
- * (EXT_PTR+0x3C)
- */
-inline int rio_enable_rx_tx_port(struct rio_mport *port,
-				 int local, u16 destid,
-				 u8 hopcount, u8 port_num) {
-#ifdef CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS
-	u32 regval;
-	u32 ext_ftr_ptr;
-
-	/*
-	* enable rx input tx output port
-	*/
-	pr_debug("rio_enable_rx_tx_port(local = %d, destid = %d, hopcount = "
-		 "%d, port_num = %d)\n", local, destid, hopcount, port_num);
-
-	ext_ftr_ptr = rio_mport_get_physefb(port, local, destid, hopcount);
-
-	if (local) {
-		rio_local_read_config_32(port, ext_ftr_ptr +
-				RIO_PORT_N_CTL_CSR(0),
-				&regval);
-	} else {
-		if (rio_mport_read_config_32(port, destid, hopcount,
-		ext_ftr_ptr + RIO_PORT_N_CTL_CSR(port_num), &regval) < 0)
-			return -EIO;
-	}
-
-	if (regval & RIO_PORT_N_CTL_P_TYP_SER) {
-		/* serial */
-		regval = regval | RIO_PORT_N_CTL_EN_RX_SER
-				| RIO_PORT_N_CTL_EN_TX_SER;
-	} else {
-		/* parallel */
-		regval = regval | RIO_PORT_N_CTL_EN_RX_PAR
-				| RIO_PORT_N_CTL_EN_TX_PAR;
-	}
-
-	if (local) {
-		rio_local_write_config_32(port, ext_ftr_ptr +
-					  RIO_PORT_N_CTL_CSR(0), regval);
-	} else {
-		if (rio_mport_write_config_32(port, destid, hopcount,
-		    ext_ftr_ptr + RIO_PORT_N_CTL_CSR(port_num), regval) < 0)
-			return -EIO;
-	}
-#endif
-	return 0;
-}
-
-/**
  * rio_setup_device- Allocates and sets up a RIO device
  * @net: RIO network
  * @port: Master port to send transactions
@@ -587,8 +462,7 @@ static struct rio_dev *rio_setup_device(
 			     rdev->destid);
 	}
 
-	rdev->dev.bus = &rio_bus_type;
-	rdev->dev.parent = &rio_bus;
+	rio_attach_device(rdev);
 
 	device_initialize(&rdev->dev);
 	rdev->dev.release = rio_release_dev;
@@ -1421,3 +1295,41 @@ enum_done:
 bail:
 	return -EBUSY;
 }
+
+static struct rio_scan rio_scan_ops = {
+	.enumerate = rio_enum_mport,
+	.discover = rio_disc_mport,
+};
+
+static bool scan;
+module_param(scan, bool, 0);
+MODULE_PARM_DESC(scan, "Start RapidIO network enumeration/discovery "
+			"(default = 0)");
+
+/**
+ * rio_basic_attach:
+ *
+ * When this enumeration/discovery method is loaded as a module this function
+ * registers its specific enumeration and discover routines for all available
+ * RapidIO mport devices. The "scan" command line parameter controls ability of
+ * the module to start RapidIO enumeration/discovery automatically.
+ *
+ * Returns 0 for success or -EIO if unable to register itself.
+ *
+ * This enumeration/discovery method cannot be unloaded and therefore does not
+ * provide a matching cleanup_module routine.
+ */
+
+static int __init rio_basic_attach(void)
+{
+	if (rio_register_scan(RIO_MPORT_ANY, &rio_scan_ops))
+		return -EIO;
+	if (scan)
+		rio_init_mports();
+	return 0;
+}
+
+late_initcall(rio_basic_attach);
+
+MODULE_DESCRIPTION("Basic RapidIO enumeration/discovery");
+MODULE_LICENSE("GPL");
diff -puN drivers/rapidio/rio.c~rapidio-make-enumeration-discovery-configurable drivers/rapidio/rio.c
--- a/drivers/rapidio/rio.c~rapidio-make-enumeration-discovery-configurable
+++ a/drivers/rapidio/rio.c
@@ -31,7 +31,11 @@
 
 #include "rio.h"
 
+static LIST_HEAD(rio_devices);
+static DEFINE_SPINLOCK(rio_global_list_lock);
+
 static LIST_HEAD(rio_mports);
+static DEFINE_MUTEX(rio_mport_list_lock);
 static unsigned char next_portid;
 static DEFINE_SPINLOCK(rio_mmap_lock);
 
@@ -53,6 +57,32 @@ u16 rio_local_get_device_id(struct rio_m
 }
 
 /**
+ * rio_add_device- Adds a RIO device to the device model
+ * @rdev: RIO device
+ *
+ * Adds the RIO device to the global device list and adds the RIO
+ * device to the RIO device list.  Creates the generic sysfs nodes
+ * for an RIO device.
+ */
+int rio_add_device(struct rio_dev *rdev)
+{
+	int err;
+
+	err = device_add(&rdev->dev);
+	if (err)
+		return err;
+
+	spin_lock(&rio_global_list_lock);
+	list_add_tail(&rdev->global_list, &rio_devices);
+	spin_unlock(&rio_global_list_lock);
+
+	rio_create_sysfs_dev_files(rdev);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rio_add_device);
+
+/**
  * rio_request_inb_mbox - request inbound mailbox service
  * @mport: RIO master port from which to allocate the mailbox resource
  * @dev_id: Device specific pointer to pass on event
@@ -489,6 +519,7 @@ rio_mport_get_physefb(struct rio_mport *
 
 	return ext_ftr_ptr;
 }
+EXPORT_SYMBOL_GPL(rio_mport_get_physefb);
 
 /**
  * rio_get_comptag - Begin or continue searching for a RIO device by component tag
@@ -521,6 +552,7 @@ exit:
 	spin_unlock(&rio_global_list_lock);
 	return rdev;
 }
+EXPORT_SYMBOL_GPL(rio_get_comptag);
 
 /**
  * rio_set_port_lockout - Sets/clears LOCKOUT bit (RIO EM 1.3) for a switch port.
@@ -545,6 +577,107 @@ int rio_set_port_lockout(struct rio_dev
 				  regval);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rio_set_port_lockout);
+
+/**
+ * rio_switch_init - Sets switch operations for a particular vendor switch
+ * @rdev: RIO device
+ * @do_enum: Enumeration/Discovery mode flag
+ *
+ * Searches the RIO switch ops table for known switch types. If the vid
+ * and did match a switch table entry, then call switch initialization
+ * routine to setup switch-specific routines.
+ */
+void rio_switch_init(struct rio_dev *rdev, int do_enum)
+{
+	struct rio_switch_ops *cur = __start_rio_switch_ops;
+	struct rio_switch_ops *end = __end_rio_switch_ops;
+
+	while (cur < end) {
+		if ((cur->vid == rdev->vid) && (cur->did == rdev->did)) {
+			pr_debug("RIO: calling init routine for %s\n",
+				 rio_name(rdev));
+			cur->init_hook(rdev, do_enum);
+			break;
+		}
+		cur++;
+	}
+
+	if ((cur >= end) && (rdev->pef & RIO_PEF_STD_RT)) {
+		pr_debug("RIO: adding STD routing ops for %s\n",
+			rio_name(rdev));
+		rdev->rswitch->add_entry = rio_std_route_add_entry;
+		rdev->rswitch->get_entry = rio_std_route_get_entry;
+		rdev->rswitch->clr_table = rio_std_route_clr_table;
+	}
+
+	if (!rdev->rswitch->add_entry || !rdev->rswitch->get_entry)
+		printk(KERN_ERR "RIO: missing routing ops for %s\n",
+		       rio_name(rdev));
+}
+EXPORT_SYMBOL_GPL(rio_switch_init);
+
+/**
+ * rio_enable_rx_tx_port - enable input receiver and output transmitter of
+ * given port
+ * @port: Master port associated with the RIO network
+ * @local: local=1 select local port otherwise a far device is reached
+ * @destid: Destination ID of the device to check host bit
+ * @hopcount: Number of hops to reach the target
+ * @port_num: Port (-number on switch) to enable on a far end device
+ *
+ * Returns 0 or 1 from on General Control Command and Status Register
+ * (EXT_PTR+0x3C)
+ */
+int rio_enable_rx_tx_port(struct rio_mport *port,
+			  int local, u16 destid,
+			  u8 hopcount, u8 port_num)
+{
+#ifdef CONFIG_RAPIDIO_ENABLE_RX_TX_PORTS
+	u32 regval;
+	u32 ext_ftr_ptr;
+
+	/*
+	* enable rx input tx output port
+	*/
+	pr_debug("rio_enable_rx_tx_port(local = %d, destid = %d, hopcount = "
+		 "%d, port_num = %d)\n", local, destid, hopcount, port_num);
+
+	ext_ftr_ptr = rio_mport_get_physefb(port, local, destid, hopcount);
+
+	if (local) {
+		rio_local_read_config_32(port, ext_ftr_ptr +
+				RIO_PORT_N_CTL_CSR(0),
+				&regval);
+	} else {
+		if (rio_mport_read_config_32(port, destid, hopcount,
+		ext_ftr_ptr + RIO_PORT_N_CTL_CSR(port_num), &regval) < 0)
+			return -EIO;
+	}
+
+	if (regval & RIO_PORT_N_CTL_P_TYP_SER) {
+		/* serial */
+		regval = regval | RIO_PORT_N_CTL_EN_RX_SER
+				| RIO_PORT_N_CTL_EN_TX_SER;
+	} else {
+		/* parallel */
+		regval = regval | RIO_PORT_N_CTL_EN_RX_PAR
+				| RIO_PORT_N_CTL_EN_TX_PAR;
+	}
+
+	if (local) {
+		rio_local_write_config_32(port, ext_ftr_ptr +
+					  RIO_PORT_N_CTL_CSR(0), regval);
+	} else {
+		if (rio_mport_write_config_32(port, destid, hopcount,
+		    ext_ftr_ptr + RIO_PORT_N_CTL_CSR(port_num), regval) < 0)
+			return -EIO;
+	}
+#endif
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rio_enable_rx_tx_port);
+
 
 /**
  * rio_chk_dev_route - Validate route to the specified device.
@@ -610,6 +743,7 @@ rio_mport_chk_dev_access(struct rio_mpor
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rio_mport_chk_dev_access);
 
 /**
  * rio_chk_dev_access - Validate access to the specified device.
@@ -941,6 +1075,7 @@ rio_mport_get_efb(struct rio_mport *port
 		return RIO_GET_BLOCK_ID(reg_val);
 	}
 }
+EXPORT_SYMBOL_GPL(rio_mport_get_efb);
 
 /**
  * rio_mport_get_feature - query for devices' extended features
@@ -997,6 +1132,7 @@ rio_mport_get_feature(struct rio_mport *
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(rio_mport_get_feature);
 
 /**
  * rio_get_asm - Begin or continue searching for a RIO device by vid/did/asm_vid/asm_did
@@ -1246,6 +1382,71 @@ EXPORT_SYMBOL_GPL(rio_dma_prep_slave_sg)
 
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
 
+/**
+ * rio_register_scan - enumeration/discovery method registration interface
+ * @mport_id: mport device ID for which fabric scan routine has to be set
+ *            (RIO_MPORT_ANY = set for all available mports)
+ * @scan_ops: enumeration/discovery control structure
+ *
+ * Assigns enumeration or discovery method to the specified mport device (or all
+ * available mports if RIO_MPORT_ANY is specified).
+ * Returns error if the mport already has an enumerator attached to it.
+ * In case of RIO_MPORT_ANY ignores ports with valid scan routines and returns
+ * an error if was unable to find at least one available mport.
+ */
+int rio_register_scan(int mport_id, struct rio_scan *scan_ops)
+{
+	struct rio_mport *port;
+	int rc = -EBUSY;
+
+	mutex_lock(&rio_mport_list_lock);
+	list_for_each_entry(port, &rio_mports, node) {
+		if (port->id == mport_id || mport_id == RIO_MPORT_ANY) {
+			if (port->nscan && mport_id == RIO_MPORT_ANY)
+				continue;
+			else if (port->nscan)
+				break;
+
+			port->nscan = scan_ops;
+			rc = 0;
+
+			if (mport_id != RIO_MPORT_ANY)
+				break;
+		}
+	}
+	mutex_unlock(&rio_mport_list_lock);
+
+	return rc;
+}
+EXPORT_SYMBOL_GPL(rio_register_scan);
+
+/**
+ * rio_unregister_scan - removes enumeration/discovery method from mport
+ * @mport_id: mport device ID for which fabric scan routine has to be
+ *            unregistered (RIO_MPORT_ANY = set for all available mports)
+ *
+ * Removes enumeration or discovery method assigned to the specified mport
+ * device (or all available mports if RIO_MPORT_ANY is specified).
+ */
+int rio_unregister_scan(int mport_id)
+{
+	struct rio_mport *port;
+
+	mutex_lock(&rio_mport_list_lock);
+	list_for_each_entry(port, &rio_mports, node) {
+		if (port->id == mport_id || mport_id == RIO_MPORT_ANY) {
+			if (port->nscan)
+				port->nscan = NULL;
+			if (mport_id != RIO_MPORT_ANY)
+				break;
+		}
+	}
+	mutex_unlock(&rio_mport_list_lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(rio_unregister_scan);
+
 static void rio_fixup_device(struct rio_dev *dev)
 {
 }
@@ -1274,7 +1475,7 @@ static void disc_work_handler(struct wor
 	work = container_of(_work, struct rio_disc_work, work);
 	pr_debug("RIO: discovery work for mport %d %s\n",
 		 work->mport->id, work->mport->name);
-	rio_disc_mport(work->mport);
+	work->mport->nscan->discover(work->mport);
 }
 
 int rio_init_mports(void)
@@ -1290,12 +1491,15 @@ int rio_init_mports(void)
 	 * First, run enumerations and check if we need to perform discovery
 	 * on any of the registered mports.
 	 */
+	mutex_lock(&rio_mport_list_lock);
 	list_for_each_entry(port, &rio_mports, node) {
-		if (port->host_deviceid >= 0)
-			rio_enum_mport(port);
-		else
+		if (port->host_deviceid >= 0) {
+			if (port->nscan)
+				port->nscan->enumerate(port);
+		} else
 			n++;
 	}
+	mutex_unlock(&rio_mport_list_lock);
 
 	if (!n)
 		goto no_disc;
@@ -1322,14 +1526,16 @@ int rio_init_mports(void)
 	}
 
 	n = 0;
+	mutex_lock(&rio_mport_list_lock);
 	list_for_each_entry(port, &rio_mports, node) {
-		if (port->host_deviceid < 0) {
+		if (port->host_deviceid < 0 && port->nscan) {
 			work[n].mport = port;
 			INIT_WORK(&work[n].work, disc_work_handler);
 			queue_work(rio_wq, &work[n].work);
 			n++;
 		}
 	}
+	mutex_unlock(&rio_mport_list_lock);
 
 	flush_workqueue(rio_wq);
 	pr_debug("RIO: destroy discovery workqueue\n");
@@ -1342,8 +1548,6 @@ no_disc:
 	return 0;
 }
 
-device_initcall_sync(rio_init_mports);
-
 static int hdids[RIO_MAX_MPORTS + 1];
 
 static int rio_get_hdid(int index)
@@ -1371,7 +1575,10 @@ int rio_register_mport(struct rio_mport
 
 	port->id = next_portid++;
 	port->host_deviceid = rio_get_hdid(port->id);
+	port->nscan = NULL;
+	mutex_lock(&rio_mport_list_lock);
 	list_add_tail(&port->node, &rio_mports);
+	mutex_unlock(&rio_mport_list_lock);
 	return 0;
 }
 
@@ -1386,3 +1593,4 @@ EXPORT_SYMBOL_GPL(rio_request_inb_mbox);
 EXPORT_SYMBOL_GPL(rio_release_inb_mbox);
 EXPORT_SYMBOL_GPL(rio_request_outb_mbox);
 EXPORT_SYMBOL_GPL(rio_release_outb_mbox);
+EXPORT_SYMBOL_GPL(rio_init_mports);
diff -puN drivers/rapidio/rio.h~rapidio-make-enumeration-discovery-configurable drivers/rapidio/rio.h
--- a/drivers/rapidio/rio.h~rapidio-make-enumeration-discovery-configurable
+++ a/drivers/rapidio/rio.h
@@ -15,6 +15,7 @@
 #include <linux/rio.h>
 
 #define RIO_MAX_CHK_RETRY	3
+#define RIO_MPORT_ANY		(-1)
 
 /* Functions internal to the RIO core code */
 
@@ -27,8 +28,6 @@ extern u32 rio_mport_get_efb(struct rio_
 extern int rio_mport_chk_dev_access(struct rio_mport *mport, u16 destid,
 				    u8 hopcount);
 extern int rio_create_sysfs_dev_files(struct rio_dev *rdev);
-extern int rio_enum_mport(struct rio_mport *mport);
-extern int rio_disc_mport(struct rio_mport *mport);
 extern int rio_std_route_add_entry(struct rio_mport *mport, u16 destid,
 				   u8 hopcount, u16 table, u16 route_destid,
 				   u8 route_port);
@@ -39,10 +38,16 @@ extern int rio_std_route_clr_table(struc
 				   u8 hopcount, u16 table);
 extern int rio_set_port_lockout(struct rio_dev *rdev, u32 pnum, int lock);
 extern struct rio_dev *rio_get_comptag(u32 comp_tag, struct rio_dev *from);
+extern int rio_add_device(struct rio_dev *rdev);
+extern void rio_switch_init(struct rio_dev *rdev, int do_enum);
+extern int rio_enable_rx_tx_port(struct rio_mport *port, int local, u16 destid,
+				 u8 hopcount, u8 port_num);
+extern int rio_register_scan(int mport_id, struct rio_scan *scan_ops);
+extern int rio_unregister_scan(int mport_id);
+extern void rio_attach_device(struct rio_dev *rdev);
 
 /* Structures internal to the RIO core code */
 extern struct device_attribute rio_dev_attrs[];
-extern spinlock_t rio_global_list_lock;
 
 extern struct rio_switch_ops __start_rio_switch_ops[];
 extern struct rio_switch_ops __end_rio_switch_ops[];
diff -puN include/linux/rio.h~rapidio-make-enumeration-discovery-configurable include/linux/rio.h
--- a/include/linux/rio.h~rapidio-make-enumeration-discovery-configurable
+++ a/include/linux/rio.h
@@ -83,7 +83,6 @@
 
 extern struct bus_type rio_bus_type;
 extern struct device rio_bus;
-extern struct list_head rio_devices;	/* list of all devices */
 
 struct rio_mport;
 struct rio_dev;
@@ -237,6 +236,7 @@ enum rio_phy_type {
  * @name: Port name string
  * @priv: Master port private data
  * @dma: DMA device associated with mport
+ * @nscan: RapidIO network enumeration/discovery operations
  */
 struct rio_mport {
 	struct list_head dbells;	/* list of doorbell events */
@@ -262,6 +262,7 @@ struct rio_mport {
 #ifdef CONFIG_RAPIDIO_DMA_ENGINE
 	struct dma_device	dma;
 #endif
+	struct rio_scan *nscan;
 };
 
 struct rio_id_table {
@@ -460,6 +461,16 @@ static inline struct rio_mport *dma_to_m
 }
 #endif /* CONFIG_RAPIDIO_DMA_ENGINE */
 
+/**
+ * struct rio_scan - RIO enumeration and discovery operations
+ * @enumerate: Callback to perform RapidIO fabric enumeration.
+ * @discover: Callback to perform RapidIO fabric discovery.
+ */
+struct rio_scan {
+	int (*enumerate)(struct rio_mport *mport);
+	int (*discover)(struct rio_mport *mport);
+};
+
 /* Architecture and hardware-specific functions */
 extern int rio_register_mport(struct rio_mport *);
 extern int rio_open_inb_mbox(struct rio_mport *, void *, int, int);
diff -puN include/linux/rio_drv.h~rapidio-make-enumeration-discovery-configurable include/linux/rio_drv.h
--- a/include/linux/rio_drv.h~rapidio-make-enumeration-discovery-configurable
+++ a/include/linux/rio_drv.h
@@ -433,5 +433,6 @@ extern u16 rio_local_get_device_id(struc
 extern struct rio_dev *rio_get_device(u16 vid, u16 did, struct rio_dev *from);
 extern struct rio_dev *rio_get_asm(u16 vid, u16 did, u16 asm_vid, u16 asm_did,
 				   struct rio_dev *from);
+extern int rio_init_mports(void);
 
 #endif				/* LINUX_RIO_DRV_H */
_

Patches currently in -mm which might be from alexandre.bounine@idt.com are

rapidio-switches-remove-tsi500-driver.patch

