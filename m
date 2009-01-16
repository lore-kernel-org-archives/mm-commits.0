From: akpm@linux-foundation.org
Subject: + hp-accelerometer-add-freefall-detection.patch added to -mm tree
Date: Fri, 16 Jan 2009 14:34:11 -0800
Message-ID: <200901162234.n0GMYB8Z022317@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44074 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937733AbZAPWex (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Jan 2009 17:34:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@suse.cz, eric.piel@tremplin-utc.net, trenn@suse.de


The patch titled
     hp accelerometer: add freefall detection
has been added to the -mm tree.  Its filename is
     hp-accelerometer-add-freefall-detection.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: hp accelerometer: add freefall detection
=46rom: Pavel Machek <pavel@suse.cz>

This adds freefall handling to hp_accel driver.  According to HP, it
should just work, without us having to set the chip up by hand.

hpfall.c is example .c program that parks the disk when accelerometer
detects free fall.  It should work; for now, it uses fixed 20seconds
protection period.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Thomas Renninger <trenn@suse.de>
Cc: =C9ric Piel <eric.piel@tremplin-utc.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/hwmon/hpfall.c  |  101 ++++++++++++++++++
 Documentation/hwmon/lis3lv02d |    8 +
 drivers/hwmon/hp_accel.c      |   27 +++++
 drivers/hwmon/lis3lv02d.c     |  172 ++++++++++++++++++++++++++++----
 drivers/hwmon/lis3lv02d.h     |    5=20
 5 files changed, 296 insertions(+), 17 deletions(-)

diff -puN /dev/null Documentation/hwmon/hpfall.c
--- /dev/null
+++ a/Documentation/hwmon/hpfall.c
@@ -0,0 +1,101 @@
+/* Disk protection for HP machines.
+ *
+ * Copyright 2008 Eric Piel
+ * Copyright 2009 Pavel Machek <pavel@suse.cz>
+ *
+ * GPLv2.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <string.h>
+#include <stdint.h>
+#include <errno.h>
+#include <signal.h>
+
+void write_int(char *path, int i)
+{
+	char buf[1024];
+	int fd =3D open(path, O_RDWR);
+	if (fd < 0) {
+		perror("open");
+		exit(1);
+	}
+	sprintf(buf, "%d", i);
+	if (write(fd, buf, strlen(buf)) !=3D strlen(buf)) {
+		perror("write");
+		exit(1);
+	}
+	close(fd);
+}
+
+void set_led(int on)
+{
+	write_int("/sys/class/leds/hp::hddprotect/brightness", on);
+}
+
+void protect(int seconds)
+{
+	write_int("/sys/block/sda/device/unload_heads", seconds*1000);
+}
+
+int on_ac(void)
+{
+//	/sys/class/power_supply/AC0/online
+}
+
+int lid_open(void)
+{
+//	/proc/acpi/button/lid/LID/state
+}
+
+void ignore_me(void)
+{
+	protect(0);
+	set_led(0);
+
+}
+
+int main(int argc, char* argv[])
+{
+       int fd, ret;
+
+       fd =3D open("/dev/freefall", O_RDONLY);
+       if (fd < 0) {
+               perror("open");
+               return EXIT_FAILURE;
+       }
+
+	signal(SIGALRM, ignore_me);
+
+       for (;;) {
+	       unsigned char count;
+
+               ret =3D read(fd, &count, sizeof(count));
+	       alarm(0);
+	       if ((ret =3D=3D -1) && (errno =3D=3D EINTR)) {
+		       /* Alarm expired, time to unpark the heads */
+		       continue;
+	       }
+
+               if (ret !=3D sizeof(count)) {
+                       perror("read");
+                       break;
+               }
+
+	       protect(21);
+	       set_led(1);
+	       if (1 || on_ac() || lid_open()) {
+		       alarm(2);
+	       } else {
+		       alarm(20);
+	       }
+       }
+
+       close(fd);
+       return EXIT_SUCCESS;
+}
diff -puN Documentation/hwmon/lis3lv02d~hp-accelerometer-add-freefall-d=
etection Documentation/hwmon/lis3lv02d
--- a/Documentation/hwmon/lis3lv02d~hp-accelerometer-add-freefall-detec=
tion
+++ a/Documentation/hwmon/lis3lv02d
@@ -33,6 +33,14 @@ rate - reports the sampling rate of the=20
 This driver also provides an absolute input class device, allowing
 the laptop to act as a pinball machine-esque joystick.
=20
+Another feature of the driver is misc device called "freefall" that
+acts similar to /dev/rtc and reacts on free-fall interrupts received
+from the device. It supports blocking operations, poll/select and
+fasync operation modes. You must read 1 bytes from the device.  The
+result is number of free-fall interrupts since the last successful
+read (or 255 if number of interrupts would not fit).
+
+
 Axes orientation
 ----------------
=20
diff -puN drivers/hwmon/hp_accel.c~hp-accelerometer-add-freefall-detect=
ion drivers/hwmon/hp_accel.c
--- a/drivers/hwmon/hp_accel.c~hp-accelerometer-add-freefall-detection
+++ a/drivers/hwmon/hp_accel.c
@@ -208,6 +208,30 @@ static struct delayed_led_classdev hpled
 	.set_brightness =3D hpled_set,
 };
=20
+static acpi_status
+lis3lv02d_get_resource(struct acpi_resource *resource, void *context)
+{
+	if (resource->type =3D=3D ACPI_RESOURCE_TYPE_EXTENDED_IRQ) {
+		struct acpi_resource_extended_irq *irq;
+		u32 *device_irq =3D context;
+
+		irq =3D &resource->data.extended_irq;
+		*device_irq =3D irq->interrupts[0];
+	}
+
+	return AE_OK;
+}
+
+static void lis3lv02d_enum_resources(struct acpi_device *device)
+{
+	acpi_status status;
+
+	status =3D acpi_walk_resources(device->handle, METHOD_NAME__CRS,
+					lis3lv02d_get_resource, &adev.irq);
+	if (ACPI_FAILURE(status))
+		printk(KERN_DEBUG DRIVER_NAME ": Error getting resources\n");
+}
+
 static int lis3lv02d_add(struct acpi_device *device)
 {
 	u8 val;
@@ -242,6 +266,9 @@ static int lis3lv02d_add(struct acpi_dev
 	if (ret)
 		return ret;
=20
+	/* obtain IRQ number of our device from ACPI */
+	lis3lv02d_enum_resources(adev.device);
+
 	ret =3D lis3lv02d_init_device(&adev);
 	if (ret) {
 		flush_work(&hpled_led.work);
diff -puN drivers/hwmon/lis3lv02d.c~hp-accelerometer-add-freefall-detec=
tion drivers/hwmon/lis3lv02d.c
--- a/drivers/hwmon/lis3lv02d.c~hp-accelerometer-add-freefall-detection
+++ a/drivers/hwmon/lis3lv02d.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2007-2008 Yan Burman
  *  Copyright (C) 2008 Eric Piel
- *  Copyright (C) 2008 Pavel Machek
+ *  Copyright (C) 2008-2009 Pavel Machek
  *
  *  This program is free software; you can redistribute it and/or modi=
fy
  *  it under the terms of the GNU General Public License as published =
by
@@ -35,6 +35,7 @@
 #include <linux/poll.h>
 #include <linux/freezer.h>
 #include <linux/uaccess.h>
+#include <linux/miscdevice.h>
 #include <acpi/acpi_drivers.h>
 #include <asm/atomic.h>
 #include "lis3lv02d.h"
@@ -55,7 +56,10 @@
 /* Maximum value our axis may get for the input device (signed 12 bits=
) */
 #define MDPS_MAX_VAL 2048
=20
-struct acpi_lis3lv02d adev;
+struct acpi_lis3lv02d adev =3D {
+	.misc_wait   =3D __WAIT_QUEUE_HEAD_INITIALIZER(adev.misc_wait),
+};
+
 EXPORT_SYMBOL_GPL(adev);
=20
 static int lis3lv02d_add_fs(struct acpi_device *device);
@@ -110,26 +114,13 @@ static void lis3lv02d_get_xyz(acpi_handl
 void lis3lv02d_poweroff(acpi_handle handle)
 {
 	adev.is_on =3D 0;
-	/* disable X,Y,Z axis and power down */
-	adev.write(handle, CTRL_REG1, 0x00);
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweroff);
=20
 void lis3lv02d_poweron(acpi_handle handle)
 {
-	u8 val;
-
 	adev.is_on =3D 1;
 	adev.init(handle);
-	adev.write(handle, FF_WU_CFG, 0);
-	/*
-	 * BDU: LSB and MSB values are not updated until both have been read.
-	 *      So the value read will always be correct.
-	 * IEN: Interrupt for free-fall and DD, not for data-ready.
-	 */
-	adev.read(handle, CTRL_REG2, &val);
-	val |=3D CTRL2_BDU | CTRL2_IEN;
-	adev.write(handle, CTRL_REG2, val);
 }
 EXPORT_SYMBOL_GPL(lis3lv02d_poweron);
=20
@@ -162,6 +153,140 @@ static void lis3lv02d_decrease_use(struc
 	mutex_unlock(&dev->lock);
 }
=20
+static irqreturn_t lis302dl_interrupt(int irq, void *dummy)
+{
+	/*
+	 * Be careful: on some HP laptops the bios force DD when on battery a=
nd
+	 * the lid is closed. This leads to interrupts as soon as a little mo=
ve
+	 * is done.
+	 */
+	atomic_inc(&adev.count);
+
+	wake_up_interruptible(&adev.misc_wait);
+	kill_fasync(&adev.async_queue, SIGIO, POLL_IN);
+	return IRQ_HANDLED;
+}
+
+static int lis3lv02d_misc_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	if (test_and_set_bit(0, &adev.misc_opened))
+		return -EBUSY; /* already open */
+
+	atomic_set(&adev.count, 0);
+
+	/*
+	 * The sensor can generate interrupts for free-fall and direction
+	 * detection (distinguishable with FF_WU_SRC and DD_SRC) but to keep
+	 * the things simple and _fast_ we activate it only for free-fall, so
+	 * no need to read register (very slow with ACPI). For the same reaso=
n,
+	 * we forbid shared interrupts.
+	 *
+	 * IRQF_TRIGGER_RISING seems pointless on HP laptops because the
+	 * io-apic is not configurable (and generates a warning) but I keep i=
t
+	 * in case of support for other hardware.
+	 */
+	ret =3D request_irq(adev.irq, lis302dl_interrupt, IRQF_TRIGGER_RISING=
,
+			  DRIVER_NAME, &adev);
+
+	if (ret) {
+		clear_bit(0, &adev.misc_opened);
+		printk(KERN_ERR DRIVER_NAME ": IRQ%d allocation failed\n", adev.irq)=
;
+		return -EBUSY;
+	}
+	lis3lv02d_increase_use(&adev);
+	printk("lis3: registered interrupt %d\n", adev.irq);
+	return 0;
+}
+
+static int lis3lv02d_misc_release(struct inode *inode, struct file *fi=
le)
+{
+	fasync_helper(-1, file, 0, &adev.async_queue);
+	lis3lv02d_decrease_use(&adev);
+	free_irq(adev.irq, &adev);
+	clear_bit(0, &adev.misc_opened); /* release the device */
+	return 0;
+}
+
+static ssize_t lis3lv02d_misc_read(struct file *file, char __user *buf=
,
+				size_t count, loff_t *pos)
+{
+	DECLARE_WAITQUEUE(wait, current);
+	u32 data;
+	unsigned char byte_data;
+	ssize_t retval =3D 1;
+
+	if (count < 1)
+		return -EINVAL;
+
+	add_wait_queue(&adev.misc_wait, &wait);
+	while (true) {
+		set_current_state(TASK_INTERRUPTIBLE);
+		data =3D atomic_xchg(&adev.count, 0);
+		if (data)
+			break;
+
+		if (file->f_flags & O_NONBLOCK) {
+			retval =3D -EAGAIN;
+			goto out;
+		}
+
+		if (signal_pending(current)) {
+			retval =3D -ERESTARTSYS;
+			goto out;
+		}
+
+		schedule();
+	}
+
+	if (data < 255)
+		byte_data =3D data;
+	else
+		byte_data =3D 255;
+
+	/* make sure we are not going into copy_to_user() with
+	 * TASK_INTERRUPTIBLE state */
+	set_current_state(TASK_RUNNING);
+	if (copy_to_user(buf, &byte_data, sizeof(byte_data)))
+		retval =3D -EFAULT;
+
+out:
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&adev.misc_wait, &wait);
+
+	return retval;
+}
+
+static unsigned int lis3lv02d_misc_poll(struct file *file, poll_table =
*wait)
+{
+	poll_wait(file, &adev.misc_wait, wait);
+	if (atomic_read(&adev.count))
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+static int lis3lv02d_misc_fasync(int fd, struct file *file, int on)
+{
+	return fasync_helper(fd, file, on, &adev.async_queue);
+}
+
+static const struct file_operations lis3lv02d_misc_fops =3D {
+	.owner   =3D THIS_MODULE,
+	.llseek  =3D no_llseek,
+	.read    =3D lis3lv02d_misc_read,
+	.open    =3D lis3lv02d_misc_open,
+	.release =3D lis3lv02d_misc_release,
+	.poll    =3D lis3lv02d_misc_poll,
+	.fasync  =3D lis3lv02d_misc_fasync,
+};
+
+static struct miscdevice lis3lv02d_misc_device =3D {
+	.minor   =3D MISC_DYNAMIC_MINOR,
+	.name    =3D "freefall",
+	.fops    =3D &lis3lv02d_misc_fops,
+};
+
 /**
  * lis3lv02d_joystick_kthread - Kthread polling function
  * @data: unused - here to conform to threadfn prototype
@@ -203,7 +328,6 @@ static void lis3lv02d_joystick_close(str
 	lis3lv02d_decrease_use(&adev);
 }
=20
-
 static inline void lis3lv02d_calibrate_joystick(void)
 {
 	lis3lv02d_get_xyz(adev.device->handle, &adev.xcalib, &adev.ycalib, &a=
dev.zcalib);
@@ -250,6 +374,7 @@ void lis3lv02d_joystick_disable(void)
 	if (!adev.idev)
 		return;
=20
+	misc_deregister(&lis3lv02d_misc_device);
 	input_unregister_device(adev.idev);
 	adev.idev =3D NULL;
 }
@@ -268,6 +393,19 @@ int lis3lv02d_init_device(struct acpi_li
 	if (lis3lv02d_joystick_enable())
 		printk(KERN_ERR DRIVER_NAME ": joystick initialization failed\n");
=20
+	printk("lis3_init_device: irq %d\n", dev->irq);
+
+	/* if we did not get an IRQ from ACPI - we have nothing more to do */
+	if (!dev->irq) {
+		printk(KERN_ERR DRIVER_NAME
+			": No IRQ in ACPI. Disabling /dev/freefall\n");
+		goto out;
+	}
+
+	printk("lis3: registering device\n");
+	if (misc_register(&lis3lv02d_misc_device))
+		printk(KERN_ERR DRIVER_NAME ": misc_register failed\n");
+out:
 	lis3lv02d_decrease_use(dev);
 	return 0;
 }
@@ -351,6 +489,6 @@ int lis3lv02d_remove_fs(void)
 EXPORT_SYMBOL_GPL(lis3lv02d_remove_fs);
=20
 MODULE_DESCRIPTION("ST LIS3LV02Dx three-axis digital accelerometer dri=
ver");
-MODULE_AUTHOR("Yan Burman and Eric Piel");
+MODULE_AUTHOR("Yan Burman, Eric Piel, Pavel Machek");
 MODULE_LICENSE("GPL");
=20
diff -puN drivers/hwmon/lis3lv02d.h~hp-accelerometer-add-freefall-detec=
tion drivers/hwmon/lis3lv02d.h
--- a/drivers/hwmon/lis3lv02d.h~hp-accelerometer-add-freefall-detection
+++ a/drivers/hwmon/lis3lv02d.h
@@ -170,6 +170,11 @@ struct acpi_lis3lv02d {
 	unsigned char		is_on;     /* whether the device is on or off */
 	unsigned char		usage;     /* usage counter */
 	struct axis_conversion	ac;        /* hw -> logical axis */
+
+	u32			irq;       /* IRQ number */
+	struct fasync_struct	*async_queue; /* queue for the misc device */
+	wait_queue_head_t	misc_wait; /* Wait queue for the misc device */
+	unsigned long		misc_opened; /* bit0: whether the device is open */
 };
=20
 int lis3lv02d_init_device(struct acpi_lis3lv02d *dev);
_

Patches currently in -mm which might be from pavel@suse.cz are

origin.patch
linux-next.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code.patch
thinkpad-acpi-split-delayed-leds-stuff-clean-up-code-checkpatch-fixes.p=
atch
resume-wait-for-device-probing-to-finish.patch
ext2-add-blk_issue_flush-to-syncing-paths.patch
hp-accelerometer-add-freefall-detection.patch
nbd-trivial-cleanups.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
