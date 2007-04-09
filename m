From: akpm@linux-foundation.org
Subject: + add-new_id-to-pcmcia-drivers.patch added to -mm tree
Date: Mon, 09 Apr 2007 12:07:29 -0700
Message-ID: <200704091907.l39J7U7U020927@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56030 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965013AbXDITHm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 9 Apr 2007 15:07:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: bwalle@suse.de, greg@kroah.com, linux@dominikbrodowski.net


The patch titled
     add new_id to PCMCIA drivers
has been added to the -mm tree.  Its filename is
     add-new_id-to-pcmcia-drivers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: add new_id to PCMCIA drivers
From: Bernhard Walle <bwalle@suse.de>

PCI drivers have the new_id file in sysfs which allows new IDs to be added
at runtime.  The advantage is to avoid re-compilation of a driver that
works for a new device, but it's ID table doesn't contain the new device. 
This mechanism is only meant for testing, after the driver has been tested
successfully, the ID should be added in source code so that new revisions
of the kernel automatically detect the device.

The implementation follows the PCI implementation. The interface is documented
in Documentation/pcmcia/driver.txt. Computations should be done in userspace,
so the sysfs string contains the raw structure members for matching.

Signed-off-by: Bernhard Walle <bwalle@suse.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/pcmcia/driver.txt |   30 +++++++
 drivers/pcmcia/ds.c             |  113 +++++++++++++++++++++++++++++-
 include/pcmcia/ds.h             |    6 +
 3 files changed, 148 insertions(+), 1 deletion(-)

diff -puN /dev/null Documentation/pcmcia/driver.txt
--- /dev/null
+++ a/Documentation/pcmcia/driver.txt
@@ -0,0 +1,30 @@
+PCMCIA Driver
+-------------
+
+
+sysfs
+-----
+
+New PCMCIA IDs may be added to a device driver pcmcia_device_id table at
+runtime as shown below:
+
+echo "match_flags manf_id card_id func_id function device_no \
+prod_id_hash[0] prod_id_hash[1] prod_id_hash[2] prod_id_hash[3]" > \
+/sys/bus/pcmcia/drivers/{driver}/new_id
+
+All fields are passed in as hexadecimal values (no leading 0x).
+The meaning is described in the PCMCIA specification, the match_flags is
+a bitwise or-ed combination from PCMCIA_DEV_ID_MATCH_* constants
+defined in include/linux/mod_devicetable.h.
+
+Once added, the driver probe routine will be invoked for any unclaimed
+PCMCIA device listed in its (newly updated) pcmcia_device_id list.
+
+A common use-case is to add a new device according to the manufacturer ID
+and the card ID (form the manf_id and card_id file in the device tree).
+For this, just use:
+
+echo "0x3 manf_id card_id 0 0 0 0 0 0 0" > \
+        /sys/bus/pcmcia/drivers/{driver}/new_id
+
+after loading the driver.
diff -puN drivers/pcmcia/ds.c~add-new_id-to-pcmcia-drivers drivers/pcmcia/ds.c
--- a/drivers/pcmcia/ds.c~add-new_id-to-pcmcia-drivers
+++ a/drivers/pcmcia/ds.c
@@ -234,6 +234,89 @@ static void pcmcia_check_driver(struct p
 /*======================================================================*/
 
 
+struct pcmcia_dynid {
+	struct list_head 		node;
+	struct pcmcia_device_id 	id;
+};
+
+/**
+ * pcmcia_store_new_id - add a new PCMCIA device ID to this driver and re-probe devices
+ * @driver: target device driver
+ * @buf: buffer for scanning device ID data
+ * @count: input size
+ *
+ * Adds a new dynamic PCMCIA device ID to this driver,
+ * and causes the driver to probe for all devices again.
+ */
+static ssize_t
+pcmcia_store_new_id(struct device_driver *driver, const char *buf, size_t count)
+{
+	struct pcmcia_dynid *dynid;
+	struct pcmcia_driver *pdrv = to_pcmcia_drv(driver);
+	__u16 match_flags, manf_id, card_id;
+	__u8 func_id, function, device_no;
+	__u32 prod_id_hash[4] = {0, 0, 0, 0};
+	int fields=0;
+	int retval = 0;
+
+	fields = sscanf(buf, "%hx %hx %hx %hhx %hhx %hhx %x %x %x %x",
+			&match_flags, &manf_id, &card_id, &func_id, &function, &device_no,
+			&prod_id_hash[0], &prod_id_hash[1], &prod_id_hash[2], &prod_id_hash[3]);
+	if (fields < 6)
+		return -EINVAL;
+
+	dynid = kzalloc(sizeof(struct pcmcia_dynid), GFP_KERNEL);
+	if (!dynid)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&dynid->node);
+	dynid->id.match_flags = match_flags;
+	dynid->id.manf_id = manf_id;
+	dynid->id.card_id = card_id;
+	dynid->id.func_id = func_id;
+	dynid->id.function = function;
+	dynid->id.device_no = device_no;
+	memcpy(dynid->id.prod_id_hash, prod_id_hash, sizeof(__u32) * 4);
+
+	spin_lock(&pdrv->dynids.lock);
+	list_add_tail(&pdrv->dynids.list, &dynid->node);
+	spin_unlock(&pdrv->dynids.lock);
+
+	if (get_driver(&pdrv->drv)) {
+		retval = driver_attach(&pdrv->drv);
+		put_driver(&pdrv->drv);
+	}
+
+	if (retval)
+		return retval;
+	return count;
+}
+static DRIVER_ATTR(new_id, S_IWUSR, NULL, pcmcia_store_new_id);
+
+static void
+pcmcia_free_dynids(struct pcmcia_driver *drv)
+{
+	struct pcmcia_dynid *dynid, *n;
+
+	spin_lock(&drv->dynids.lock);
+	list_for_each_entry_safe(dynid, n, &drv->dynids.list, node) {
+		list_del(&dynid->node);
+		kfree(dynid);
+	}
+	spin_unlock(&drv->dynids.lock);
+}
+
+static int
+pcmcia_create_newid_file(struct pcmcia_driver *drv)
+{
+	int error = 0;
+	if (drv->probe != NULL)
+		error = sysfs_create_file(&drv->drv.kobj,
+					  &driver_attr_new_id.attr);
+	return error;
+}
+
+
 /**
  * pcmcia_register_driver - register a PCMCIA driver with the bus core
  *
@@ -241,6 +324,8 @@ static void pcmcia_check_driver(struct p
  */
 int pcmcia_register_driver(struct pcmcia_driver *driver)
 {
+	int error;
+
 	if (!driver)
 		return -EINVAL;
 
@@ -249,10 +334,20 @@ int pcmcia_register_driver(struct pcmcia
 	/* initialize common fields */
 	driver->drv.bus = &pcmcia_bus_type;
 	driver->drv.owner = driver->owner;
+	spin_lock_init(&driver->dynids.lock);
+	INIT_LIST_HEAD(&driver->dynids.list);
 
 	ds_dbg(3, "registering driver %s\n", driver->drv.name);
 
-	return driver_register(&driver->drv);
+	error = driver_register(&driver->drv);
+	if (error < 0)
+		return error;
+
+	error = pcmcia_create_newid_file(driver);
+	if (error)
+		driver_unregister(&driver->drv);
+
+	return error;
 }
 EXPORT_SYMBOL(pcmcia_register_driver);
 
@@ -263,6 +358,7 @@ void pcmcia_unregister_driver(struct pcm
 {
 	ds_dbg(3, "unregistering driver %s\n", driver->drv.name);
 	driver_unregister(&driver->drv);
+	pcmcia_free_dynids(driver);
 }
 EXPORT_SYMBOL(pcmcia_unregister_driver);
 
@@ -927,6 +1023,21 @@ static int pcmcia_bus_match(struct devic
 	struct pcmcia_device * p_dev = to_pcmcia_dev(dev);
 	struct pcmcia_driver * p_drv = to_pcmcia_drv(drv);
 	struct pcmcia_device_id *did = p_drv->id_table;
+	struct pcmcia_dynid *dynid;
+
+	/* match dynamic devices first */
+	spin_lock(&p_drv->dynids.lock);
+	list_for_each_entry(dynid, &p_drv->dynids.list, node) {
+		ds_dbg(3, "trying to match %s to %s\n", dev->bus_id,
+		       drv->name);
+		if (pcmcia_devmatch(p_dev, &dynid->id)) {
+			ds_dbg(0, "matched %s to %s\n", dev->bus_id,
+			       drv->name);
+			spin_unlock(&p_drv->dynids.lock);
+			return 1;
+		}
+	}
+	spin_unlock(&p_drv->dynids.lock);
 
 	while (did && did->match_flags) {
 		ds_dbg(3, "trying to match %s to %s\n", dev->bus_id,
diff -puN include/pcmcia/ds.h~add-new_id-to-pcmcia-drivers include/pcmcia/ds.h
--- a/include/pcmcia/ds.h~add-new_id-to-pcmcia-drivers
+++ a/include/pcmcia/ds.h
@@ -108,6 +108,11 @@ typedef struct dev_node_t {
 struct pcmcia_socket;
 struct config_t;
 
+struct pcmcia_dynids {
+	spinlock_t		lock;
+	struct list_head	list;
+};
+
 struct pcmcia_driver {
 	int (*probe)		(struct pcmcia_device *dev);
 	void (*remove)		(struct pcmcia_device *dev);
@@ -118,6 +123,7 @@ struct pcmcia_driver {
 	struct module		*owner;
 	struct pcmcia_device_id	*id_table;
 	struct device_driver	drv;
+	struct pcmcia_dynids	dynids;
 };
 
 /* driver registration */
_

Patches currently in -mm which might be from bwalle@suse.de are

add-new_id-to-pcmcia-drivers.patch
git-r8169.patch
git-scsi-misc.patch
use-unchecked_isa_dma-in-sd_revalidate_disk.patch
add-irqf_irqpoll-flag-common-code.patch
add-irqf_irqpoll-flag-on-x86_64.patch
add-irqf_irqpoll-flag-on-i386.patch
add-irqf_irqpoll-flag-on-ia64.patch
add-irqf_irqpoll-flag-on-sh.patch
add-irqf_irqpoll-flag-on-parisc.patch
add-irqf_irqpoll-flag-on-arm.patch
