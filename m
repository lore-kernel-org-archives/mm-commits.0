From: akpm@linux-foundation.org
Subject: + ibmaem-new-driver-for-power-energy-meters-in-ibm-system-x-hardware.patch added to -mm tree
Date: Tue, 06 May 2008 17:33:32 -0700
Message-ID: <200805070033.m470XWSp002817@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37454 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752778AbYEGAes (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2008 20:34:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: djwong@us.ibm.com, mhoffman@lightlink.com, minyard@acm.org


The patch titled
     ibmaem: new driver for power/energy meters in IBM System X hardware
has been added to the -mm tree.  Its filename is
     ibmaem-new-driver-for-power-energy-meters-in-ibm-system-x-hardware.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ibmaem: new driver for power/energy meters in IBM System X hardware
From: "Darrick J. Wong" <djwong@us.ibm.com>

New driver for power meters in IBM System X hardware, with a few
cleanups suggested by Anthony Liguori.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>
Cc: Corey Minyard <minyard@acm.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/ibmaem |   37 +
 drivers/hwmon/Kconfig      |   14 
 drivers/hwmon/Makefile     |    1 
 drivers/hwmon/ibmaem.c     | 1157 +++++++++++++++++++++++++++++++++++
 4 files changed, 1209 insertions(+)

diff -puN /dev/null Documentation/hwmon/ibmaem
--- /dev/null
+++ a/Documentation/hwmon/ibmaem
@@ -0,0 +1,37 @@
+Kernel driver ibmaem
+======================
+
+Supported systems:
+  * Any recent IBM System X server with Active Energy Manager support.
+    This includes the x3350, x3550, x3650, x3655, x3755, x3850 M2,
+    x3950 M2, and certain HS2x/LS2x/QS2x blades.  The IPMI host interface
+    driver ("ipmi-si") needs to be loaded for this driver to do anything.
+    Prefix: 'ibmaem'
+    Datasheet: Not available
+
+Author: Darrick J. Wong
+
+Description
+-----------
+
+This driver implements sensor reading support for the energy and power
+meters available on various IBM System X hardware through the BMC.  All
+sensor banks will be exported as platform devices; this driver can talk
+to both v1 and v2 interfaces.  This driver is completely separate from the
+older ibmpex driver.
+
+The v1 AEM interface has a simple set of features to monitor energy use.
+There is a register that displays an estimate of raw energy consumption
+since the last BMC reset, and a power sensor that returns average power
+use over a configurable interval.
+
+The v2 AEM interface is a bit more sophisticated, being able to present
+a wider range of energy and power use registers, the power cap as
+set by the AEM software, and temperature sensors.
+
+Special Features
+----------------
+
+The "power_cap" value displays the current system power cap, as set by
+the Active Energy Manager software.  Setting the power cap from the host
+is not currently supported.
diff -puN drivers/hwmon/Kconfig~ibmaem-new-driver-for-power-energy-meters-in-ibm-system-x-hardware drivers/hwmon/Kconfig
--- a/drivers/hwmon/Kconfig~ibmaem-new-driver-for-power-energy-meters-in-ibm-system-x-hardware
+++ a/drivers/hwmon/Kconfig
@@ -330,6 +330,20 @@ config SENSORS_CORETEMP
 	  sensor inside your CPU. Supported all are all known variants
 	  of Intel Core family.
 
+config SENSORS_IBMAEM
+	tristate "IBM Active Energy Manager temperature/power sensors and control"
+	select IPMI_SI
+	depends on IPMI_HANDLER
+	help
+	  If you say yes here you get support for the temperature and
+	  power sensors and capping hardware in various IBM System X
+	  servers that support Active Energy Manager.  This includes
+	  the x3350, x3550, x3650, x3655, x3755, x3850 M2, x3950 M2,
+	  and certain HS2x/LS2x/QS2x blades.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called ibmaem.
+
 config SENSORS_IBMPEX
 	tristate "IBM PowerExecutive temperature/power sensors"
 	select IPMI_SI
diff -puN drivers/hwmon/Makefile~ibmaem-new-driver-for-power-energy-meters-in-ibm-system-x-hardware drivers/hwmon/Makefile
--- a/drivers/hwmon/Makefile~ibmaem-new-driver-for-power-energy-meters-in-ibm-system-x-hardware
+++ a/drivers/hwmon/Makefile
@@ -41,6 +41,7 @@ obj-$(CONFIG_SENSORS_GL518SM)	+= gl518sm
 obj-$(CONFIG_SENSORS_GL520SM)	+= gl520sm.o
 obj-$(CONFIG_SENSORS_HDAPS)	+= hdaps.o
 obj-$(CONFIG_SENSORS_I5K_AMB)	+= i5k_amb.o
+obj-$(CONFIG_SENSORS_IBMAEM)	+= ibmaem.o
 obj-$(CONFIG_SENSORS_IBMPEX)	+= ibmpex.o
 obj-$(CONFIG_SENSORS_IT87)	+= it87.o
 obj-$(CONFIG_SENSORS_K8TEMP)	+= k8temp.o
diff -puN /dev/null drivers/hwmon/ibmaem.c
--- /dev/null
+++ a/drivers/hwmon/ibmaem.c
@@ -0,0 +1,1157 @@
+/*
+ * A hwmon driver for the IBM Active Energy Manager temperature/power sensors
+ * and capping functionality.
+ * Copyright (C) 2008 IBM
+ *
+ * Author: Darrick J. Wong <djwong@us.ibm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/ipmi.h>
+#include <linux/module.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/jiffies.h>
+#include <linux/mutex.h>
+#include <linux/kdev_t.h>
+#include <linux/spinlock.h>
+#include <linux/idr.h>
+#include <linux/sched.h>
+#include <linux/platform_device.h>
+
+#define REFRESH_INTERVAL	(HZ)
+#define DRVNAME			"aem"
+
+#define AEM_NETFN		0x2E
+
+#define AEM_FIND_FW_CMD		0x80
+#define AEM_ELEMENT_CMD		0x81
+#define AEM_FW_INSTANCE_CMD	0x82
+
+#define AEM_READ_ELEMENT_CFG	0x80
+#define AEM_READ_BUFFER		0x81
+#define AEM_READ_REGISTER	0x82
+#define AEM_WRITE_REGISTER	0x83
+#define AEM_SET_REG_MASK	0x84
+#define AEM_CLEAR_REG_MASK	0x85
+#define AEM_READ_ELEMENT_CFG2	0x86
+
+#define AEM_CONTROL_ELEMENT	0
+#define AEM_ENERGY_ELEMENT	1
+#define AEM_CLOCK_ELEMENT	4
+#define AEM_POWER_CAP_ELEMENT	7
+#define AEM_EXHAUST_ELEMENT	9
+#define AEM_POWER_ELEMENT	10
+
+#define AEM_MODULE_TYPE_ID	0x0001
+
+#define AEM2_NUM_ENERGY_REGS	2
+#define AEM2_NUM_PCAP_REGS	6
+#define AEM2_NUM_TEMP_REGS	2
+#define AEM2_NUM_SENSORS	14
+
+#define AEM1_NUM_ENERGY_REGS	1
+#define AEM1_NUM_SENSORS	3
+
+#define POWER_CAP		0
+#define POWER_CAP_MAX_HOTPLUG	1
+#define POWER_CAP_MAX		2
+#define	POWER_CAP_MIN_WARNING	3
+#define POWER_CAP_MIN		4
+#define	POWER_AUX		5
+
+#define AEM_DEFAULT_POWER_INTERVAL 1000
+#define AEM_MIN_POWER_INTERVAL	200
+
+static DEFINE_IDR(aem1_idr);
+static DEFINE_SPINLOCK(aem1_idr_lock);
+static DEFINE_IDR(aem2_idr);
+static DEFINE_SPINLOCK(aem2_idr_lock);
+
+struct aem_ipmi_data;
+struct aem1_data;
+struct aem2_data;
+
+static void aem_register_bmc(int iface, struct device *dev);
+static void aem_bmc_gone(int iface);
+static void aem_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data);
+static void aem_init_aem1(struct aem_ipmi_data *probe);
+static void aem1_delete(struct aem1_data *data);
+static void aem_init_aem2(struct aem_ipmi_data *probe);
+static void aem2_delete(struct aem2_data *data);
+static void aem1_remove_sensors(struct aem1_data *data);
+static int aem1_find_sensors(struct aem1_data *data);
+static void aem2_remove_sensors(struct aem2_data *data);
+static int aem2_find_sensors(struct aem2_data *data);
+
+static struct device_driver aem_driver = {
+	.name = DRVNAME,
+	.bus = &platform_bus_type,
+};
+
+struct aem_ipmi_data {
+	struct completion	read_complete;
+	struct ipmi_addr	address;
+	ipmi_user_t		user;
+	int			interface;
+
+	struct kernel_ipmi_msg	tx_message;
+	long			tx_msgid;
+
+	void			*rx_msg_data;
+	unsigned short		rx_msg_len;
+	unsigned char		rx_result;
+	int			rx_recv_type;
+
+	struct device		*bmc_device;
+};
+
+struct aem_fw_data {
+	struct device		*hwmon_dev;
+	struct platform_device	*pdev;
+	struct mutex		lock;
+	char			valid;
+	unsigned long		last_updated;	/* In jiffies */
+	u8			ver_major;
+	u8			ver_minor;
+	u8			module_handle;
+	int			id;
+	struct aem_ipmi_data	ipmi;
+};
+
+struct aem_ro_sensor_template {
+	char *label;
+	ssize_t (*show)(struct device *dev,
+			struct device_attribute *devattr,
+			char *buf);
+	int index;
+};
+
+struct aem_rw_sensor_template {
+	char *label;
+	ssize_t (*show)(struct device *dev,
+			struct device_attribute *devattr,
+			char *buf);
+	ssize_t (*set)(struct device *dev,
+		       struct device_attribute *devattr,
+		       const char *buf, size_t count);
+	int index;
+};
+
+struct aem1_data {
+	struct aem_fw_data	fw;
+	struct list_head	list;
+
+	/*
+	 * Available sensors:
+	 * Energy meter
+	 * Power meter
+	 */
+	struct sensor_device_attribute	sensors[AEM1_NUM_SENSORS];
+
+	/* energy use */
+	u64			energy[AEM1_NUM_ENERGY_REGS];
+
+	int			power_period[AEM1_NUM_ENERGY_REGS];
+};
+
+struct aem2_data {
+	struct aem_fw_data	fw;
+	struct list_head	list;
+
+	/*
+	 * Available sensors:
+	 * Two energy meters
+	 * Two power meters
+	 * Two temperature sensors
+	 * Six powercap registers
+	 */
+	struct sensor_device_attribute	sensors[AEM2_NUM_SENSORS];
+
+	/* energy use */
+	u64			energy[AEM2_NUM_ENERGY_REGS];
+
+	/* power caps */
+	u16			pcap[AEM2_NUM_PCAP_REGS];
+
+	/* exhaust temperature */
+	u8			temp[AEM2_NUM_TEMP_REGS];
+
+	/* power sampling interval */
+	int			power_period[AEM2_NUM_ENERGY_REGS];
+};
+
+/* Data structures returned by the AEM firmware */
+struct aem_iana_id {
+	u8			bytes[3];
+};
+static struct aem_iana_id system_x_id = {
+	.bytes = {0x4D, 0x4F, 0x00}
+};
+
+/* These are used to find AEM1 instances */
+struct aem_find_firmware_req {
+	struct aem_iana_id	id;
+	u8			rsvd;
+	u16			index;
+	u16			module_type_id;
+} __attribute__ ((packed));
+
+struct aem_find_firmware_resp {
+	struct aem_iana_id	id;
+	u8			num_instances;
+} __attribute__ ((packed));
+
+/* These are used to find AEM2 instances */
+struct aem_find_instance_req {
+	struct aem_iana_id	id;
+	u8			instance_number;
+	u16			module_type_id;
+} __attribute__ ((packed));
+
+struct aem_find_instance_resp {
+	struct aem_iana_id	id;
+	u8			num_instances;
+	u8			major;
+	u8			minor;
+	u8			module_handle;
+	u16			record_id;
+} __attribute__ ((packed));
+
+/* These are used to query sensors */
+struct aem_read_sensor_req {
+	struct aem_iana_id	id;
+	u8			module_handle;
+	u8			element;
+	u8			subcommand;
+	u8			reg;
+	u8			rx_buf_size;
+} __attribute__ ((packed));
+
+struct aem_read_sensor_resp {
+	struct aem_iana_id	id;
+	u8			bytes[0];
+} __attribute__ ((packed));
+
+/* Data structures to talk to the IPMI layer */
+struct aem_driver_data {
+	struct list_head	aem1_devices;
+	struct list_head	aem2_devices;
+	struct ipmi_smi_watcher	bmc_events;
+	struct ipmi_user_hndl	ipmi_hndlrs;
+};
+
+static struct aem_driver_data driver_data = {
+	.aem1_devices = LIST_HEAD_INIT(driver_data.aem1_devices),
+	.aem2_devices = LIST_HEAD_INIT(driver_data.aem2_devices),
+	.bmc_events = {
+		.owner = THIS_MODULE,
+		.new_smi = aem_register_bmc,
+		.smi_gone = aem_bmc_gone,
+	},
+	.ipmi_hndlrs = {
+		.ipmi_recv_hndl = aem_msg_handler,
+	},
+};
+
+/* Functions to talk to the IPMI layer */
+
+/* Initialize IPMI address, message buffers and user data */
+static int aem_init_ipmi_data(struct aem_ipmi_data *data,
+				 int iface, struct device *bmc)
+{
+	int err;
+
+	init_completion(&data->read_complete);
+	data->bmc_device = bmc;
+
+	/* Initialize IPMI address */
+	data->address.addr_type = IPMI_SYSTEM_INTERFACE_ADDR_TYPE;
+	data->address.channel = IPMI_BMC_CHANNEL;
+	data->address.data[0] = 0;
+	data->interface = iface;
+
+	/* Initialize message buffers */
+	data->tx_msgid = 0;
+	data->tx_message.netfn = AEM_NETFN;
+
+	/* Create IPMI messaging interface user */
+	err = ipmi_create_user(data->interface, &driver_data.ipmi_hndlrs,
+			       data, &data->user);
+	if (err < 0) {
+		dev_err(bmc, "Unable to register user with IPMI "
+			"interface %d\n", data->interface);
+		return -EACCES;
+	}
+
+	return 0;
+}
+
+/* Send an IPMI command */
+static int aem_send_message(struct aem_ipmi_data *data)
+{
+	int err;
+
+	err = ipmi_validate_addr(&data->address, sizeof(data->address));
+	if (err)
+		goto out;
+
+	data->tx_msgid++;
+	err = ipmi_request_settime(data->user, &data->address, data->tx_msgid,
+				   &data->tx_message, data, 0, 0, 0);
+	if (err)
+		goto out1;
+
+	return 0;
+out1:
+	dev_err(data->bmc_device, "request_settime=%x\n", err);
+	return err;
+out:
+	dev_err(data->bmc_device, "validate_addr=%x\n", err);
+	return err;
+}
+
+/* Probe a BMC for AEM firmware instances */
+static void aem_register_bmc(int iface, struct device *dev)
+{
+	struct aem_ipmi_data probe;
+
+	if (aem_init_ipmi_data(&probe, iface, dev))
+		return;
+
+	aem_init_aem1(&probe);
+	aem_init_aem2(&probe);
+
+	ipmi_destroy_user(probe.user);
+}
+
+/* Handle BMC deletion */
+static void aem_bmc_gone(int iface)
+{
+	struct aem1_data *p1, *next1;
+	struct aem2_data *p2, *next2;
+
+	list_for_each_entry_safe(p1, next1, &driver_data.aem1_devices, list) {
+		if (p1->fw.ipmi.interface == iface)
+			aem1_delete(p1);
+	}
+
+	list_for_each_entry_safe(p2, next2, &driver_data.aem2_devices, list) {
+		if (p2->fw.ipmi.interface == iface)
+			aem2_delete(p2);
+	}
+}
+
+/* Dispatch IPMI messages to callers */
+static void aem_msg_handler(struct ipmi_recv_msg *msg, void *user_msg_data)
+{
+	unsigned short rx_len;
+	struct aem_ipmi_data *data = (struct aem_ipmi_data *)user_msg_data;
+
+	if (msg->msgid != data->tx_msgid) {
+		dev_err(data->bmc_device, "Mismatch between received msgid "
+			"(%02x) and transmitted msgid (%02x)!\n",
+			(int)msg->msgid,
+			(int)data->tx_msgid);
+		ipmi_free_recv_msg(msg);
+		return;
+	}
+
+	data->rx_recv_type = msg->recv_type;
+	if (msg->msg.data_len > 0)
+		data->rx_result = msg->msg.data[0];
+	else
+		data->rx_result = IPMI_UNKNOWN_ERR_COMPLETION_CODE;
+
+	if (msg->msg.data_len > 1) {
+		rx_len = msg->msg.data_len - 1;
+		if (data->rx_msg_len < rx_len)
+			rx_len = data->rx_msg_len;
+		data->rx_msg_len = rx_len;
+		memcpy(data->rx_msg_data, msg->msg.data + 1, data->rx_msg_len);
+	} else
+		data->rx_msg_len = 0;
+
+	ipmi_free_recv_msg(msg);
+	complete(&data->read_complete);
+}
+
+/* ID functions */
+
+/* Obtain an id */
+#define AEM_IDR_GET(type) \
+static int type##_idr_get(int *id) \
+{ \
+	int i, err; \
+\
+again: \
+	if (unlikely(idr_pre_get(&type##_idr, GFP_KERNEL) == 0)) \
+		return -ENOMEM; \
+\
+	spin_lock(&type##_idr_lock); \
+	err = idr_get_new(&type##_idr, NULL, &i); \
+	spin_unlock(&type##_idr_lock); \
+\
+	if (unlikely(err == -EAGAIN)) \
+		goto again; \
+	else if (unlikely(err)) \
+		return err; \
+\
+	*id = i & MAX_ID_MASK; \
+	return 0; \
+}
+
+/* Release an object ID */
+#define AEM_IDR_PUT(type) \
+static void type##_idr_put(int id) \
+{ \
+	spin_lock(&type##_idr_lock); \
+	idr_remove(&type##_idr, id); \
+	spin_unlock(&type##_idr_lock); \
+}
+
+/* AEM Device Name */
+static ssize_t show_name(struct device *dev, struct device_attribute *devattr,
+			 char *buf)
+{
+	struct aem_fw_data *fwdata = dev_get_drvdata(dev);
+
+	return sprintf(buf, "%s%d\n", DRVNAME, fwdata->ver_major);
+}
+static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, 0);
+
+/* Probe functions for AEM1 devices */
+
+/* Get an object ID for AEM1 device */
+AEM_IDR_GET(aem1)
+
+/* Release an object ID for an AEM1 device */
+AEM_IDR_PUT(aem1)
+
+/* Retrieve version and module handle for an AEM1 instance */
+static int aem_find_aem1_count(struct aem_ipmi_data *data)
+{
+	struct aem_find_firmware_req	ff_req;
+	struct aem_find_firmware_resp	ff_resp;
+
+	ff_req.id = system_x_id;
+	ff_req.index = 0;
+	ff_req.module_type_id = cpu_to_be16(AEM_MODULE_TYPE_ID);
+
+	data->tx_message.cmd = AEM_FIND_FW_CMD;
+	data->tx_message.data = (char *)&ff_req;
+	data->tx_message.data_len = sizeof(ff_req);
+
+	data->rx_msg_data = &ff_resp;
+	data->rx_msg_len = sizeof(ff_resp);
+
+	aem_send_message(data);
+
+	wait_for_completion(&data->read_complete);
+
+	if (data->rx_result || data->rx_msg_len != sizeof(ff_resp) ||
+	    memcmp(&ff_resp.id, &system_x_id, sizeof(system_x_id)))
+		return -ENOENT;
+
+	return ff_resp.num_instances;
+}
+
+/* Find and initialize one AEM1 instance */
+static int aem_init_aem1_inst(struct aem_ipmi_data *probe, u8 module_handle)
+{
+	struct aem1_data *data;
+	int i;
+	int res = -ENOMEM;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return res;
+	mutex_init(&data->fw.lock);
+
+	/* Copy instance data */
+	data->fw.ver_major = 1;
+	data->fw.ver_minor = 0;
+	data->fw.module_handle = module_handle;
+	for (i = 0; i < AEM1_NUM_ENERGY_REGS; i++)
+		data->power_period[i] = AEM_DEFAULT_POWER_INTERVAL;
+
+	/* Create sub-device for this fw instance */
+	if (aem1_idr_get(&data->fw.id))
+		goto id_err;
+
+	data->fw.pdev = platform_device_alloc(DRVNAME "1", data->fw.id);
+	data->fw.pdev->dev.driver = &aem_driver;
+	if (IS_ERR(data->fw.pdev))
+		goto dev_err;
+
+	res = platform_device_add(data->fw.pdev);
+	if (res)
+		goto ipmi_err;
+
+	dev_set_drvdata(&data->fw.pdev->dev, &data->fw);
+
+	/* Set up IPMI interface */
+	if (aem_init_ipmi_data(&data->fw.ipmi, probe->interface,
+			       probe->bmc_device))
+		goto ipmi_err;
+
+	/* Register with hwmon */
+	data->fw.hwmon_dev = hwmon_device_register(&data->fw.pdev->dev);
+
+	if (IS_ERR(data->fw.hwmon_dev)) {
+		dev_err(&data->fw.pdev->dev, "Unable to register hwmon "
+			"device for IPMI interface %d\n",
+			probe->interface);
+		goto hwmon_reg_err;
+	}
+
+	/* Find sensors */
+	if (aem1_find_sensors(data))
+		goto sensor_err;
+
+	/* Add to our list of AEM1 devices */
+	list_add_tail(&data->list, &driver_data.aem1_devices);
+	dev_info(data->fw.ipmi.bmc_device, "Found AEM v%d.%d at 0x%X\n",
+		 data->fw.ver_major, data->fw.ver_minor,
+		 data->fw.module_handle);
+	return 0;
+
+sensor_err:
+	hwmon_device_unregister(data->fw.hwmon_dev);
+hwmon_reg_err:
+	ipmi_destroy_user(data->fw.ipmi.user);
+ipmi_err:
+	dev_set_drvdata(&data->fw.pdev->dev, NULL);
+	platform_device_unregister(data->fw.pdev);
+dev_err:
+	aem1_idr_put(data->fw.id);
+id_err:
+	kfree(data);
+
+	return res;
+}
+
+/* Find and initialize all AEM1 instances */
+static void aem_init_aem1(struct aem_ipmi_data *probe)
+{
+	int num, i, err;
+
+	num = aem_find_aem1_count(probe);
+	for (i = 0; i < num; i++) {
+		err = aem_init_aem1_inst(probe, i);
+		if (err) {
+			dev_err(probe->bmc_device,
+				"Error %d initializing AEM1 0x%X\n",
+				err, i);
+			return;
+		}
+	}
+}
+
+/* Delete an AEM instance */
+#define AEM_DELETE(type) \
+static void type##_delete(struct type##_data *data) \
+{ \
+	list_del(&data->list); \
+	type##_remove_sensors(data); \
+	hwmon_device_unregister(data->fw.hwmon_dev); \
+	ipmi_destroy_user(data->fw.ipmi.user); \
+	dev_set_drvdata(&data->fw.pdev->dev, NULL); \
+	platform_device_unregister(data->fw.pdev); \
+	type##_idr_put(data->fw.id); \
+	kfree(data); \
+}
+
+/* Delete an AEM1 instance */
+AEM_DELETE(aem1)
+
+/* Probe functions for AEM2 devices */
+
+/* Retrieve version and module handle for an AEM2 instance */
+static int aem_find_aem2(struct aem_ipmi_data *data,
+			    struct aem_find_instance_resp *fi_resp,
+			    int instance_num)
+{
+	struct aem_find_instance_req fi_req;
+
+	fi_req.id = system_x_id;
+	fi_req.instance_number = instance_num;
+	fi_req.module_type_id = cpu_to_be16(AEM_MODULE_TYPE_ID);
+
+	data->tx_message.cmd = AEM_FW_INSTANCE_CMD;
+	data->tx_message.data = (char *)&fi_req;
+	data->tx_message.data_len = sizeof(fi_req);
+
+	data->rx_msg_data = fi_resp;
+	data->rx_msg_len = sizeof(*fi_resp);
+
+	aem_send_message(data);
+
+	wait_for_completion(&data->read_complete);
+
+	if (data->rx_result || data->rx_msg_len != sizeof(*fi_resp) ||
+	    memcmp(&fi_resp->id, &system_x_id, sizeof(system_x_id)))
+		return -ENOENT;
+
+	return 0;
+}
+
+/* Get an object ID for AEM2 device */
+AEM_IDR_GET(aem2)
+
+/* Release an object ID for an AEM2 device */
+AEM_IDR_PUT(aem2)
+
+/* Find and initialize one AEM2 instance */
+static int aem_init_aem2_inst(struct aem_ipmi_data *probe,
+			      struct aem_find_instance_resp *fi_resp)
+{
+	struct aem2_data *data;
+	int i;
+	int res = -ENOMEM;
+
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return res;
+	mutex_init(&data->fw.lock);
+
+	/* Copy instance data */
+	data->fw.ver_major = fi_resp->major;
+	data->fw.ver_minor = fi_resp->minor;
+	data->fw.module_handle = fi_resp->module_handle;
+	for (i = 0; i < AEM2_NUM_ENERGY_REGS; i++)
+		data->power_period[i] = AEM_DEFAULT_POWER_INTERVAL;
+
+	/* Create sub-device for this fw instance */
+	if (aem2_idr_get(&data->fw.id))
+		goto id_err;
+
+	data->fw.pdev = platform_device_alloc(DRVNAME "2", data->fw.id);
+	data->fw.pdev->dev.driver = &aem_driver;
+	if (IS_ERR(data->fw.pdev))
+		goto dev_err;
+
+	res = platform_device_add(data->fw.pdev);
+	if (res)
+		goto ipmi_err;
+
+	dev_set_drvdata(&data->fw.pdev->dev, &data->fw);
+
+	/* Set up IPMI interface */
+	if (aem_init_ipmi_data(&data->fw.ipmi, probe->interface,
+			       probe->bmc_device))
+		goto ipmi_err;
+
+	/* Register with hwmon */
+	data->fw.hwmon_dev = hwmon_device_register(&data->fw.pdev->dev);
+
+	if (IS_ERR(data->fw.hwmon_dev)) {
+		dev_err(&data->fw.pdev->dev, "Unable to register hwmon "
+			"device for IPMI interface %d\n",
+			probe->interface);
+		goto hwmon_reg_err;
+	}
+
+	/* Find sensors */
+	if (aem2_find_sensors(data))
+		goto sensor_err;
+
+	/* Add to our list of AEM2 devices */
+	list_add_tail(&data->list, &driver_data.aem2_devices);
+	dev_info(data->fw.ipmi.bmc_device, "Found AEM v%d.%d at 0x%X\n",
+		 data->fw.ver_major, data->fw.ver_minor,
+		 data->fw.module_handle);
+	return 0;
+
+sensor_err:
+	hwmon_device_unregister(data->fw.hwmon_dev);
+hwmon_reg_err:
+	ipmi_destroy_user(data->fw.ipmi.user);
+ipmi_err:
+	dev_set_drvdata(&data->fw.pdev->dev, NULL);
+	platform_device_unregister(data->fw.pdev);
+dev_err:
+	aem2_idr_put(data->fw.id);
+id_err:
+	kfree(data);
+
+	return res;
+}
+
+/* Find and initialize all AEM2 instances */
+static void aem_init_aem2(struct aem_ipmi_data *probe)
+{
+	struct aem_find_instance_resp fi_resp;
+	int err;
+	int i = 0;
+
+	while (!aem_find_aem2(probe, &fi_resp, i)) {
+		if (fi_resp.major != 2) {
+			dev_err(probe->bmc_device, "Unknown AEM v%d; please "
+				"report this to the maintainer.\n",
+				fi_resp.major);
+			i++;
+			continue;
+		}
+		err = aem_init_aem2_inst(probe, &fi_resp);
+		if (err) {
+			dev_err(probe->bmc_device,
+				"Error %d initializing AEM2 0x%X\n",
+				err, fi_resp.module_handle);
+			return;
+		}
+		i++;
+	}
+}
+
+/* Delete an AEM2 instance */
+AEM_DELETE(aem2)
+
+/* Sensor support functions */
+
+/* Read a sensor value */
+static int aem_read_sensor(struct aem_fw_data *fwdata, u8 elt, u8 reg,
+			   void *data, size_t size)
+{
+	int rs_size;
+	struct aem_read_sensor_req	rs_req;
+	struct aem_read_sensor_resp	*rs_resp;
+	struct aem_ipmi_data *ipmi = &fwdata->ipmi;
+
+	/* AEM registers are 1, 2, 4 or 8 bytes */
+	switch (size) {
+	case 1:
+	case 2:
+	case 4:
+	case 8:
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	rs_req.id = system_x_id;
+	rs_req.module_handle = fwdata->module_handle;
+	rs_req.element = elt;
+	rs_req.subcommand = AEM_READ_REGISTER;
+	rs_req.reg = reg;
+	rs_req.rx_buf_size = size;
+
+	ipmi->tx_message.cmd = AEM_ELEMENT_CMD;
+	ipmi->tx_message.data = (char *)&rs_req;
+	ipmi->tx_message.data_len = sizeof(rs_req);
+
+	rs_size = sizeof(*rs_resp) + size;
+	rs_resp = kzalloc(rs_size, GFP_KERNEL);
+	if (!rs_resp)
+		return -ENOMEM;
+
+	ipmi->rx_msg_data = rs_resp;
+	ipmi->rx_msg_len = rs_size;
+
+	aem_send_message(ipmi);
+
+	wait_for_completion(&ipmi->read_complete);
+
+	if (ipmi->rx_result || ipmi->rx_msg_len != rs_size ||
+	    memcmp(&rs_resp->id, &system_x_id, sizeof(system_x_id))) {
+		kfree(rs_resp);
+		return -ENOENT;
+	}
+
+	switch (size) {
+	case 1: {
+		u8 *x = data;
+		*x = rs_resp->bytes[0];
+		break;
+	}
+	case 2: {
+		u16 *x = data;
+		*x = be16_to_cpup((u16 *)rs_resp->bytes);
+		break;
+	}
+	case 4: {
+		u32 *x = data;
+		*x = be32_to_cpup((u32 *)rs_resp->bytes);
+		break;
+	}
+	case 8: {
+		u64 *x = data;
+		*x = be64_to_cpup((u64 *)rs_resp->bytes);
+		break;
+	}
+	}
+
+	return 0;
+}
+
+/* Update AEM1 energy sensors */
+static void update_aem1_energy_sensors(struct aem1_data *data)
+{
+	aem_read_sensor(&data->fw, AEM_ENERGY_ELEMENT, 0, &data->energy, 8);
+}
+
+/* Update all AEM1 sensors */
+static void update_aem1_sensors(struct aem1_data *data)
+{
+	mutex_lock(&data->fw.lock);
+	if (time_before(jiffies, data->fw.last_updated + REFRESH_INTERVAL) &&
+	    data->fw.valid)
+		goto out;
+
+	update_aem1_energy_sensors(data);
+out:
+	mutex_unlock(&data->fw.lock);
+}
+
+/* Update AEM2 energy sensors */
+static void update_aem2_energy_sensors(struct aem2_data *data)
+{
+	aem_read_sensor(&data->fw, AEM_ENERGY_ELEMENT,	0, &data->energy[0], 8);
+	aem_read_sensor(&data->fw, AEM_ENERGY_ELEMENT,	1, &data->energy[1], 8);
+}
+
+/* Update all AEM2 sensors */
+static void update_aem2_sensors(struct aem2_data *data)
+{
+	int i;
+
+	mutex_lock(&data->fw.lock);
+	if (time_before(jiffies, data->fw.last_updated + REFRESH_INTERVAL) &&
+	    data->fw.valid)
+		goto out;
+
+	update_aem2_energy_sensors(data);
+	aem_read_sensor(&data->fw, AEM_EXHAUST_ELEMENT,	0, &data->temp[0], 1);
+	aem_read_sensor(&data->fw, AEM_EXHAUST_ELEMENT,	1, &data->temp[1], 1);
+
+	for (i = POWER_CAP; i <= POWER_AUX; i++)
+		aem_read_sensor(&data->fw, AEM_POWER_CAP_ELEMENT, i,
+				&data->pcap[i], 2);
+out:
+	mutex_unlock(&data->fw.lock);
+}
+
+/* sysfs support functions */
+
+#define AEM_SHOW_POWER(type) \
+static ssize_t type##_show_power(struct device *dev, \
+				 struct device_attribute *devattr, \
+				 char *buf) \
+{ \
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr); \
+	struct aem_fw_data *fwdata = dev_get_drvdata(dev); \
+	struct type##_data * a = container_of(fwdata, \
+						 struct type##_data, fw); \
+	u64 before, after; \
+	signed long leftover; \
+\
+	mutex_lock(&fwdata->lock); \
+	update_##type##_energy_sensors(a); \
+	before = a->energy[attr->index]; \
+\
+	leftover = schedule_timeout_interruptible( \
+			msecs_to_jiffies(a->power_period[attr->index]) \
+		   ); \
+	if (leftover) { \
+		mutex_unlock(&fwdata->lock); \
+		return 0; \
+	} \
+\
+	update_##type##_energy_sensors(a); \
+	after = a->energy[attr->index]; \
+	mutex_unlock(&fwdata->lock); \
+\
+	return sprintf(buf, "%llu\n", (after - before) * 1000000 / \
+		       a->power_period[attr->index]); \
+}
+
+/* Display energy use */
+#define AEM_SHOW_ENERGY(type) \
+static ssize_t type##_show_energy(struct device *dev, \
+				  struct device_attribute *devattr, \
+				  char *buf) \
+{ \
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr); \
+	struct aem_fw_data *fwdata = dev_get_drvdata(dev); \
+	struct type##_data * a = container_of(fwdata, struct type##_data, fw); \
+	update_##type##_sensors(a); \
+\
+	return sprintf(buf, "%llu\n", a->energy[attr->index] * 1000); \
+}
+
+/* Display power interval registers */
+#define AEM_SHOW_POWER_PERIOD(type) \
+static ssize_t type##_show_power_period(struct device *dev, \
+					struct device_attribute *devattr, \
+					char *buf) \
+{ \
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr); \
+	struct aem_fw_data *fwdata = dev_get_drvdata(dev); \
+	struct type##_data * a = container_of(fwdata, struct type##_data, fw); \
+	update_##type##_sensors(a); \
+\
+	return sprintf(buf, "%d\n", a->power_period[attr->index]); \
+}
+
+/* Set power interval registers */
+#define AEM_SET_POWER_PERIOD(type) \
+static ssize_t type##_set_power_period(struct device *dev, \
+				       struct device_attribute *devattr, \
+				       const char *buf, size_t count) \
+{ \
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr); \
+	struct aem_fw_data *fwdata = dev_get_drvdata(dev); \
+	struct type##_data * a = container_of(fwdata, struct type##_data, fw); \
+	int temp = simple_strtol(buf, NULL, 10); \
+\
+	if (temp < AEM_MIN_POWER_INTERVAL) \
+		return -EINVAL; \
+\
+	mutex_lock(&a->fw.lock); \
+	a->power_period[attr->index] = temp; \
+	mutex_unlock(&a->fw.lock); \
+\
+	return count; \
+}
+
+/* Remove sensors attached to an AEM device */
+#define AEM_REMOVE_SENSORS(type, num_sensors) \
+static void type##_remove_sensors(struct type##_data *data) \
+{ \
+	int i; \
+\
+	for (i = 0; i < num_sensors; i++) { \
+		if (!data->sensors[i].dev_attr.attr.name) \
+			continue; \
+		device_remove_file(&data->fw.pdev->dev, \
+				   &data->sensors[i].dev_attr); \
+	} \
+\
+	device_remove_file(&data->fw.pdev->dev, \
+			   &sensor_dev_attr_name.dev_attr); \
+}
+
+/* Discover sensors on an AEM device */
+static int register_sensors(struct device *dev,
+			    struct sensor_device_attribute *sensors,
+			    struct aem_ro_sensor_template *ro,
+			    struct aem_rw_sensor_template *rw)
+{
+	int err, idx;
+
+	/* Set up read-only sensors */
+	idx = 0;
+	while (ro->label) {
+		sensors[idx].dev_attr.attr.name = ro->label;
+		sensors[idx].dev_attr.attr.mode = S_IRUGO;
+		sensors[idx].dev_attr.show = ro->show;
+		sensors[idx].index = ro->index;
+
+		err = device_create_file(dev, &sensors[idx].dev_attr);
+		if (err) {
+			sensors[idx].dev_attr.attr.name = NULL;
+			return err;
+		}
+		idx++;
+		ro++;
+	}
+
+	/* Set up read-write sensors */
+	while (rw->label) {
+		sensors[idx].dev_attr.attr.name = rw->label;
+		sensors[idx].dev_attr.attr.mode = S_IRUGO | S_IWUSR;
+		sensors[idx].dev_attr.show = rw->show;
+		sensors[idx].dev_attr.store = rw->set;
+		sensors[idx].index = rw->index;
+
+		err = device_create_file(dev, &sensors[idx].dev_attr);
+		if (err) {
+			sensors[idx].dev_attr.attr.name = NULL;
+			return err;
+		}
+		idx++;
+		rw++;
+	}
+
+	err = device_create_file(dev, &sensor_dev_attr_name.dev_attr);
+	return err;
+}
+
+#define AEM_FIND_SENSORS(type) \
+static int type##_find_sensors(struct type##_data *data) \
+{ \
+\
+	int err; \
+\
+	err = register_sensors(&data->fw.pdev->dev, data->sensors, \
+			       type##_ro_sensors, type##_rw_sensors); \
+	if (err) \
+		goto exit_remove; \
+\
+	return 0; \
+\
+exit_remove: \
+	type##_remove_sensors(data); \
+	return err; \
+}
+
+/* sysfs support functions for AEM1 sensors */
+
+/* Display power use */
+AEM_SHOW_POWER(aem1)
+
+/* Display energy use */
+AEM_SHOW_ENERGY(aem1)
+
+/* Display power interval registers */
+AEM_SHOW_POWER_PERIOD(aem1)
+
+/* Set power interval registers */
+AEM_SET_POWER_PERIOD(aem1)
+
+/* sysfs support functions for AEM2 sensors */
+
+/* Display power use */
+AEM_SHOW_POWER(aem2)
+
+/* Display energy use */
+AEM_SHOW_ENERGY(aem2)
+
+/* Display temperature use */
+static ssize_t aem2_show_temp(struct device *dev,
+			      struct device_attribute *devattr,
+			      char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct aem_fw_data *fwdata = dev_get_drvdata(dev);
+	struct aem2_data *a2 = container_of(fwdata, struct aem2_data, fw);
+	update_aem2_sensors(a2);
+
+	return sprintf(buf, "%u\n", a2->temp[attr->index] * 1000);
+}
+
+/* Display power-capping registers */
+static ssize_t aem2_show_pcap_value(struct device *dev,
+				    struct device_attribute *devattr,
+				    char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct aem_fw_data *fwdata = dev_get_drvdata(dev);
+	struct aem2_data *a2 = container_of(fwdata, struct aem2_data, fw);
+	update_aem2_sensors(a2);
+
+	return sprintf(buf, "%u\n", a2->pcap[attr->index] * 100000);
+}
+
+/* Display power interval registers */
+AEM_SHOW_POWER_PERIOD(aem2)
+
+/* Set power interval registers */
+AEM_SET_POWER_PERIOD(aem2)
+
+/* Sensor probe functions */
+
+/* Remove sensors attached to an AEM1 device */
+AEM_REMOVE_SENSORS(aem1, AEM1_NUM_SENSORS)
+
+/* Description of AEM1 sensors */
+static struct aem_ro_sensor_template aem1_ro_sensors[] = {
+{"energy1_input",  aem1_show_energy, 0},
+{"power1_average", aem1_show_power,  0},
+{NULL,		   NULL,	     0},
+};
+
+static struct aem_rw_sensor_template aem1_rw_sensors[] = {
+{"power1_average_interval", aem1_show_power_period, aem1_set_power_period, 0},
+{NULL,			    NULL,                   NULL,                  0},
+};
+
+/* Discover sensors on an AEM1 device */
+AEM_FIND_SENSORS(aem1)
+
+/* Remove sensors attached to an AEM2 device */
+AEM_REMOVE_SENSORS(aem2, AEM2_NUM_SENSORS)
+
+/* Description of AEM2 sensors */
+static struct aem_ro_sensor_template aem2_ro_sensors[] = {
+{"energy1_input",	  aem2_show_energy,	0},
+{"energy2_input",	  aem2_show_energy,	1},
+{"power1_average",	  aem2_show_power,	0},
+{"power2_average",	  aem2_show_power,	1},
+{"temp1_input",		  aem2_show_temp,	0},
+{"temp2_input",		  aem2_show_temp,	1},
+
+{"power4_average",	  aem2_show_pcap_value, POWER_CAP_MAX_HOTPLUG},
+{"power5_average",	  aem2_show_pcap_value,	POWER_CAP_MAX},
+{"power6_average",	  aem2_show_pcap_value, POWER_CAP_MIN_WARNING},
+{"power7_average",	  aem2_show_pcap_value,	POWER_CAP_MIN},
+
+{"power3_average", 	  aem2_show_pcap_value,	POWER_AUX},
+{NULL,                    NULL,                 0},
+{"power_cap",		  aem2_show_pcap_value, POWER_CAP},
+};
+
+static struct aem_rw_sensor_template aem2_rw_sensors[] = {
+{"power1_average_interval", aem2_show_power_period, aem2_set_power_period, 0},
+{"power2_average_interval", aem2_show_power_period, aem2_set_power_period, 1},
+{NULL,			    NULL,                   NULL,                  0},
+};
+
+/* Discover sensors on an AEM2 device */
+AEM_FIND_SENSORS(aem2)
+
+/* Module init/exit routines */
+
+static int __init aem_init(void)
+{
+	int res;
+
+	res = driver_register(&aem_driver);
+	if (res) {
+		printk(KERN_ERR "Can't register aem_driver\n");
+		return res;
+	}
+
+	res = ipmi_smi_watcher_register(&driver_data.bmc_events);
+	if (res)
+		goto ipmi_reg_err;
+	return 0;
+
+ipmi_reg_err:
+	driver_unregister(&aem_driver);
+	return res;
+
+}
+
+static void __exit aem_exit(void)
+{
+	struct aem1_data *p1, *next1;
+	struct aem2_data *p2, *next2;
+
+	ipmi_smi_watcher_unregister(&driver_data.bmc_events);
+	driver_unregister(&aem_driver);
+	list_for_each_entry_safe(p1, next1, &driver_data.aem1_devices, list)
+		aem1_delete(p1);
+	list_for_each_entry_safe(p2, next2, &driver_data.aem2_devices, list)
+		aem2_delete(p2);
+}
+
+MODULE_AUTHOR("Darrick J. Wong <djwong@us.ibm.com>");
+MODULE_DESCRIPTION("IBM Active Energy Manager power/temp sensor driver");
+MODULE_LICENSE("GPL");
+
+module_init(aem_init);
+module_exit(aem_exit);
_

Patches currently in -mm which might be from djwong@us.ibm.com are

i5k_amb-support-intel-5400-chipset.patch
ibmaem-new-driver-for-power-energy-meters-in-ibm-system-x-hardware.patch
adt7473-minor-documentation-update.patch

