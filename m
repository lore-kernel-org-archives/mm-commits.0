From: akpm@linux-foundation.org
Subject: + additional-platform-attributes-coming-from-sny6001.patch added to -mm tree
Date: Fri, 06 Apr 2007 18:32:32 -0700
Message-ID: <200704070132.l371WWuw024875@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42014 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964932AbXDGBfM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 21:35:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: malattia@linux.it, lenb@kernel.org, stelian@popies.net


The patch titled
     sony-laptop: additional platform attributes coming from SNY6001
has been added to the -mm tree.  Its filename is
     additional-platform-attributes-coming-from-sny6001.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sony-laptop: additional platform attributes coming from SNY6001
From: Mattia Dongili <malattia@linux.it>

Register additional platform attributes coming from the SPIC (sonypi) driver

Signed-off-by: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>
Cc: Stelian Pop <stelian@popies.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/sony-laptop.c |  205 ++++++++++++++++++++++++++++++++++-
 1 file changed, 204 insertions(+), 1 deletion(-)

diff -puN drivers/misc/sony-laptop.c~additional-platform-attributes-coming-from-sny6001 drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~additional-platform-attributes-coming-from-sny6001
+++ a/drivers/misc/sony-laptop.c
@@ -774,7 +774,8 @@ static int sony_nc_add(struct acpi_devic
 
 	}
 
-	if (sony_pf_add())
+	result = sony_pf_add();
+	if (result)
 		goto outbacklight;
 
 	/* create sony_pf sysfs attributes related to the SNC device */
@@ -903,6 +904,8 @@ struct sony_pic_irq {
 
 struct sony_pic_dev {
 	int			model;
+	u8			camera_power;
+	u8			bluetooth_power;
 	struct acpi_device	*acpi_dev;
 	struct sony_pic_irq	*cur_irq;
 	struct sony_pic_ioport	*cur_ioport;
@@ -1181,6 +1184,186 @@ static u8 sony_pic_call2(u8 dev, u8 fn)
 	return v1;
 }
 
+static u8 sony_pic_call3(u8 dev, u8 fn, u8 v)
+{
+	u8 v1;
+
+	wait_on_command(inb_p(spic_dev.cur_ioport->io.minimum + 4) & 2, ITERATIONS_LONG);
+	outb(dev, spic_dev.cur_ioport->io.minimum + 4);
+	wait_on_command(inb_p(spic_dev.cur_ioport->io.minimum + 4) & 2, ITERATIONS_LONG);
+	outb(fn, spic_dev.cur_ioport->io.minimum);
+	wait_on_command(inb_p(spic_dev.cur_ioport->io.minimum + 4) & 2, ITERATIONS_LONG);
+	outb(v, spic_dev.cur_ioport->io.minimum);
+	v1 = inb_p(spic_dev.cur_ioport->io.minimum);
+	dprintk("sony_pic_call3: 0x%.4x\n", v1);
+	return v1;
+}
+
+/* camera tests and poweron/poweroff */
+#define SONYPI_CAMERA_PICTURE		5
+#define SONYPI_CAMERA_MUTE_MASK		0x40
+#define SONYPI_CAMERA_CONTROL		0x10
+#define SONYPI_CAMERA_STATUS 		7
+#define SONYPI_CAMERA_STATUS_READY 	0x2
+#define SONYPI_CAMERA_STATUS_POSITION	0x4
+
+static int sony_pic_camera_ready(void)
+{
+	u8 v;
+
+	v = sony_pic_call2(0x8f, SONYPI_CAMERA_STATUS);
+	return (v != 0xff && (v & SONYPI_CAMERA_STATUS_READY));
+}
+
+static void sony_pic_camera_off(void)
+{
+	wait_on_command(sony_pic_call3(0x90, SONYPI_CAMERA_PICTURE,
+				SONYPI_CAMERA_MUTE_MASK),
+			ITERATIONS_SHORT);
+
+	if (!spic_dev.camera_power)
+		return;
+
+	sony_pic_call2(0x91, 0);
+	spic_dev.camera_power = 0;
+}
+
+static void sony_pic_camera_on(void)
+{
+	int i, j;
+
+	if (spic_dev.camera_power)
+		return;
+
+	for (j = 5; j > 0; j--) {
+
+		while (sony_pic_call2(0x91, 0x1))
+			msleep(10);
+		sony_pic_call1(0x93);
+
+		for (i = 400; i > 0; i--) {
+			if (sony_pic_camera_ready())
+				break;
+			msleep(10);
+		}
+		if (i)
+			break;
+	}
+
+	if (j == 0) {
+		printk(KERN_WARNING "sonypi: failed to power on camera\n");
+		return;
+	}
+
+	wait_on_command(sony_pic_call3(0x90, SONYPI_CAMERA_CONTROL,
+				0x5a),
+			ITERATIONS_SHORT);
+
+	spic_dev.camera_power = 1;
+}
+
+static ssize_t sony_pic_camerapower_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buffer, size_t count)
+{
+	unsigned long value;
+	if (count > 31)
+		return -EINVAL;
+
+	value = simple_strtoul(buffer, NULL, 10);
+	if (value)
+		sony_pic_camera_on();
+	else
+		sony_pic_camera_off();
+
+	return count;
+}
+
+static ssize_t sony_pic_camerapower_show(struct device *dev,
+		struct device_attribute *attr, char *buffer)
+{
+	return snprintf(buffer, PAGE_SIZE, "%d\n", spic_dev.camera_power);
+}
+
+/* bluetooth subsystem power state */
+static void sony_pic_set_bluetoothpower(u8 state)
+{
+	state = !!state;
+	if (spic_dev.bluetooth_power == state)
+		return;
+	sony_pic_call2(0x96, state);
+	sony_pic_call1(0x82);
+	spic_dev.bluetooth_power = state;
+}
+
+static ssize_t sony_pic_bluetoothpower_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buffer, size_t count)
+{
+	unsigned long value;
+	if (count > 31)
+		return -EINVAL;
+
+	value = simple_strtoul(buffer, NULL, 10);
+	sony_pic_set_bluetoothpower(value);
+
+	return count;
+}
+
+static ssize_t sony_pic_bluetoothpower_show(struct device *dev,
+		struct device_attribute *attr, char *buffer)
+{
+	return snprintf(buffer, PAGE_SIZE, "%d\n", spic_dev.bluetooth_power);
+}
+
+/* fan speed */
+/* FAN0 information (reverse engineered from ACPI tables) */
+#define SONY_PIC_FAN0_STATUS	0x93
+static ssize_t sony_pic_fanspeed_store(struct device *dev,
+		struct device_attribute *attr,
+		const char *buffer, size_t count)
+{
+	unsigned long value;
+	if (count > 31)
+		return -EINVAL;
+
+	value = simple_strtoul(buffer, NULL, 10);
+	if (ec_write(SONY_PIC_FAN0_STATUS, value))
+		return -EIO;
+
+	return count;
+}
+
+static ssize_t sony_pic_fanspeed_show(struct device *dev,
+		struct device_attribute *attr, char *buffer)
+{
+	u8 value = 0;
+	if (ec_read(SONY_PIC_FAN0_STATUS, &value))
+		return -EIO;
+
+	return snprintf(buffer, PAGE_SIZE, "%d\n", value);
+}
+
+#define SPIC_ATTR(_name, _mode)					\
+struct device_attribute spic_attr_##_name = __ATTR(_name,	\
+		_mode, sony_pic_## _name ##_show,		\
+		sony_pic_## _name ##_store)
+
+static SPIC_ATTR(camerapower, 0644);
+static SPIC_ATTR(bluetoothpower, 0644);
+static SPIC_ATTR(fanspeed, 0644);
+
+static struct attribute *spic_attributes[] = {
+	&spic_attr_camerapower.attr,
+	&spic_attr_bluetoothpower.attr,
+	&spic_attr_fanspeed.attr,
+	NULL
+};
+
+static struct attribute_group spic_attribute_group = {
+	.attrs = spic_attributes
+};
+
 /*
  * ACPI callbacks
  */
@@ -1447,6 +1630,10 @@ static int sony_pic_remove(struct acpi_d
 
 	sony_laptop_remove_input();
 
+	/* pf attrs */
+	sysfs_remove_group(&sony_pf_device->dev.kobj, &spic_attribute_group);
+	sony_pf_remove();
+
 	list_for_each_entry_safe(io, tmp_io, &spic_dev.ioports, list) {
 		list_del(&io->list);
 		kfree(io);
@@ -1536,8 +1723,24 @@ static int sony_pic_add(struct acpi_devi
 		goto err_free_irq;
 	}
 
+	spic_dev.bluetooth_power = -1;
+	/* create device attributes */
+	result = sony_pf_add();
+	if (result)
+		goto err_disable_device;
+
+	result = sysfs_create_group(&sony_pf_device->dev.kobj, &spic_attribute_group);
+	if (result)
+		goto err_remove_pf;
+
 	return 0;
 
+err_remove_pf:
+	sony_pf_remove();
+
+err_disable_device:
+	sony_pic_disable(device);
+
 err_free_irq:
 	free_irq(spic_dev.cur_irq->irq.interrupts[0], &spic_dev);
 
_

Patches currently in -mm which might be from malattia@linux.it are

remove-acpi-references-from-variable-and-function-names.patch
prepare-the-platform-driver-for-multiple-users.patch
add-debug-macros-also-used-by-the-sonypi-reimplementation.patch
add-sny6001-device-handling-sonypi-reimplementation.patch
unify-the-input-subsystem-event-forwarding.patch
additional-platform-attributes-coming-from-sny6001.patch
sanitize-printks.patch
update-documentation-and-kconfig-help.patch
git-cpufreq.patch
