From: akpm@linux-foundation.org
Subject: - spi-filesystem-api.patch removed from -mm tree
Date: Wed, 07 Feb 2007 17:08:05 -0800
Message-ID: <200702080109.l1819BGq001320@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:48980 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422855AbXBHBJT (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 20:09:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.paterniani@swapp-eng.it, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     spi: filesystem API
has been removed from the -mm tree.  Its filename was
     spi-filesystem-api.patch

This patch was dropped because greg

------------------------------------------------------
Subject: spi: filesystem API
From: Andrea Paterniani <a.paterniani@swapp-eng.it>

Add a filesystem API for <linux/spi/spi.h> stack.  The initial version of
this interface is purely synchronous.

dbrownell@users.sourceforge.net:

 Cleaned up, bugfixed; much simplified; added preliminary documentation.

 Works with mdev given CONFIG_SYSFS_DEPRECATED; and presumably udev.

 Updated SPI_IOC_MESSAGE ioctl to full spi_message semantics, supporting
 groups of one or more transfers (each of which may be full duplex if
 desired).  But its implementation is incomplete.

 This is marked as EXPERIMENTAL with an explicit disclaimer that the API
 (notably the ioctls) is subject to change.

Signed-off-by: Andrea Paterniani <a.paterniani@swapp-eng.it>
Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/spi/spidev   |  104 ++++++
 drivers/spi/Kconfig        |    9 
 drivers/spi/Makefile       |    1 
 drivers/spi/spidev.c       |  549 +++++++++++++++++++++++++++++++++++
 include/linux/Kbuild       |    1 
 include/linux/spi/Kbuild   |    1 
 include/linux/spi/spidev.h |   87 +++++
 7 files changed, 752 insertions(+)

diff -puN /dev/null Documentation/spi/spidev
--- /dev/null
+++ a/Documentation/spi/spidev
@@ -0,0 +1,104 @@
+SPI devices have a limited functionality userspace API, supporting basic
+half-duplex read() and write() access to SPI devices.  Using ioctl()
+requests, full duplex transfers and partial interface configuration
+is also available.
+
+	#include <fcntl.h>
+	#include <unistd.h>
+	#include <sys/ioctl.h>
+	#include <linux/spi/spidev.h>
+
+Some reasons you might want to use this programming interface include:
+
+ * Prototyping in an environment that's not crash-prone; stray pointers
+   in userspace won't normally bring down any Linux system.
+
+ * Developing simple protocols used to talk to microcontrollers acting
+   as SPI slaves, which you may need to change quite often.
+
+Of course there are drivers that can never be written in userspace, because
+they need to access kernel interfaces (such as IRQ handlers or other layers
+of the driver stack) that are not accessible to userspace.
+
+
+DEVICE CREATION, DRIVER BINDING
+===============================
+The simplest way to arrange to use this driver is to just list it in the
+spi_board_info for a device as the driver it should use:  the "modalias"
+entry is "spidev", matching the name of the driver exposing this API.
+Set up the other device characteristics (bits per word, SPI clocking,
+etc) as usual, so you won't always need to override them later.
+
+(Sysfs also supports userspace driven binding/unbinding of drivers to
+devices.  That mechanism might be supported here in the future.)
+
+When you do that, the sysfs node for the SPI device will include a child
+device node with a "dev" attribute that will be understood by udev or mdev.
+(Larger systems will have "udev".  Smaller ones may configure "mdev" into
+busybox; it's less featureful, but often enough.)  For a SPI device with
+chipselect C on bus B, you should see:
+
+    /dev/spidevB.C ... character special device, major number 153 with
+	a dynamically chosen minor device number.  (This is the node
+	which userspace programs will open.)
+
+    /sys/devices/.../spiB.C ... as usual, the SPI device node will
+	be a child of the SPI master controller.
+
+    /sys/class/spidev/spidevB.C ... created when the "spidev" driver
+	binds to that device.  (Directory or symlink, based on whether
+	or not you enabled the "deprecated sysfs files" Kconfig option.)
+
+Do not try to manage the /dev character device special file nodes by hand.
+That's error prone, and you'd need to pay careful attention to system
+security issues; udev/mdev should already be configured securely.
+
+If you unbind the "spidev" driver from that device, those two "spidev" nodes
+(in sysfs and in /dev) should automatically be removed (respectively by the
+kernel and by udev/mdev).  You can unbind by removing the "spidev" driver
+module, which will affect all devices using this driver.  You can also unbind
+by having kernel code remove the SPI device, probably by removing the driver
+for its SPI controller (so its spi_master vanishes).
+
+Since this is a standard Linux device driver -- even though it just happens
+to expose a low level API to userspace -- it can be associated with any number
+of devices at a time.  Just provide one spi_board_info record for each such
+SPI device, and you'll get a /dev device node for each device.
+
+
+CHARACTER DEVICE API
+====================
+Normal open() and close() operations on /dev/spidevB.D files work as you
+would expect.
+
+Standard read() and write() operations are obviously only half-duplex, and
+the chipselect is deactivated between those operations.
+
+    **	FIXME ... AIO ought to work too.  The IOC_MESSAGE request
+    **	is incomplete; it needs to handle multiple transactions,
+    **	and get documented.
+
+Several ioctl() requests let your driver read or override the device's current
+settings for SPI transfer parameters:
+
+    SPI_IOC_RD_MODE, SPI_IOC_WR_MODE ... pass a pointer to a byte
+	which will return (RD) or assign (WR) the SPI transfer mode.
+	Use the constants SPI_MODE_0..SPI_MODE_3.
+
+    SPI_IOC_RD_LSB_FIRST, SPI_IOC_WR_LSB_FIRST ... pass a pointer to a
+	byte which will return (RD) or assign (WR) the bit justification
+	used to transfer SPI words.  The default (zero) uses MSB-first,
+	but some controllers support LSB-first encoding.  In both cases
+	the specified value is right-justified in each word, so that any
+	unused (TX) or undefined (RX) bits are in the MSBs.
+
+    SPI_IOC_RD_BITS_PER_WORD, SPI_IOC_WR_BITS_PER_WORD ... pass a
+	pointer to a byte which will return (RD) or assign (WR) the
+	number of bits in each SPI transfer word.  The default of
+	eight bits is also indicated by the value zero.
+
+    SPI_IOC_RD_MAX_SPEED_HZ, SPI_IOC_WR_MAX_SPEED_HZ ... pass a
+	pointer to a u32 which will return (RD) or assign (WR) the
+	maximum SPI transfer speed, in Hz.  The controller can't
+	necessarily assign that specific clock speed.
+
diff -puN drivers/spi/Kconfig~spi-filesystem-api drivers/spi/Kconfig
--- a/drivers/spi/Kconfig~spi-filesystem-api
+++ a/drivers/spi/Kconfig
@@ -146,6 +146,15 @@ config SPI_AT25
 	  This driver can also be built as a module.  If so, the module
 	  will be called at25.
 
+config SPI_SPIDEV
+	tristate "User mode SPI device driver support"
+	depends on SPI_MASTER && EXPERIMENTAL
+	help
+	  This supports user mode SPI protocol drivers.
+
+	  Note that this application programming interface is EXPERIMENTAL
+	  and hence SUBJECT TO CHANGE WITHOUT NOTICE while it stabilizes.
+
 #
 # Add new SPI protocol masters in alphabetical order above this line
 #
diff -puN drivers/spi/Makefile~spi-filesystem-api drivers/spi/Makefile
--- a/drivers/spi/Makefile~spi-filesystem-api
+++ a/drivers/spi/Makefile
@@ -23,6 +23,7 @@ obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24x
 
 # SPI protocol drivers (device/link on bus)
 obj-$(CONFIG_SPI_AT25)		+= at25.o
+obj-$(CONFIG_SPI_SPIDEV)	+= spidev.o
 # 	... add above this line ...
 
 # SPI slave controller drivers (upstream link)
diff -puN /dev/null drivers/spi/spidev.c
--- /dev/null
+++ a/drivers/spi/spidev.c
@@ -0,0 +1,549 @@
+/*
+ * spidev.c -- simple userspace interface to SPI devices
+ *
+ * Copyright (C) 2006 SWAPP
+ *	Andrea Paterniani <a.paterniani@swapp-eng.it>
+ * Copyright (C) 2007 David Brownell (simplification, cleanup)
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
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/device.h>
+#include <linux/list.h>
+#include <linux/errno.h>
+#include <linux/mutex.h>
+#include <linux/slab.h>
+
+#include <linux/spi/spi.h>
+#include <linux/spi/spidev.h>
+
+#include <asm/uaccess.h>
+
+/*
+ * This supports acccess to SPI devices using normal userspace I/O calls.
+ * Note that while traditional UNIX/POSIX I/O semantics are half duplex,
+ * and often mask message boundaries, full SPI support requires full duplex
+ * transfers and demands several kinds of of internal boundaries to handle
+ * chipselect management and other protocol options.
+ *
+ * SPI has a character major number assigned.  We allocate minor numbers
+ * dynamically using a bitmask.  You must use hotplug tools, such as udev
+ * (or mdev with busybox) to create and destroy the /dev/spidevB.C device
+ * nodes, since there is no fixed association of minor numbers with any
+ * particular SPI bus or device.
+ */
+#define SPIDEV_MAJOR			153	/* assigned */
+#define	N_SPI_MINORS			32	/* ... up to 256 */
+
+static unsigned long	minors[N_SPI_MINORS / BITS_PER_LONG];
+static unsigned long	last_minor;
+
+
+/* Bit masks for spi_device.mode management */
+#define SPI_MODE_MASK			(SPI_CPHA | SPI_CPOL)
+
+
+struct device_data {
+	struct device		dev;
+	struct spi_device	*spi;
+	struct list_head	device_entry;
+
+	struct mutex		buf_lock;
+	unsigned		users;
+	u8			*buffer;
+};
+
+static LIST_HEAD(device_list);
+static DEFINE_MUTEX(device_list_lock);
+
+static unsigned bufsiz = PAGE_SIZE;
+module_param(bufsiz, uint, 0);
+MODULE_PARM_DESC(bufsiz, "bytes in biggest supported SPI message");
+
+/*-------------------------------------------------------------------------*/
+
+/* Read-only message with current device setup */
+static ssize_t
+spidev_read(struct file *filp, char __user *buf, size_t count, loff_t *f_pos)
+{
+	struct device_data	*spidev;
+	struct spi_device	*spi;
+	ssize_t			status = 0;
+
+	/* chipselect only toggles at start or end of operation */
+	if (count > bufsiz)
+		return -EMSGSIZE;
+
+	spidev = (struct device_data *)filp->private_data;
+	spi = spidev->spi;
+
+	mutex_lock(&spidev->buf_lock);
+
+	/* short reads mean bad buffer, not bad I/O */
+	status = spi_read(spi, spidev->buffer, count);
+	if (status == 0) {
+		unsigned	missing;
+
+		missing = copy_to_user(buf, spidev->buffer, count);
+		if (count && missing == count)
+			status = -EFAULT;
+		else
+			status = count - missing;
+	}
+
+	mutex_unlock(&spidev->buf_lock);
+
+	return status;
+}
+
+/* Write-only message with current device setup */
+static ssize_t
+spidev_write(struct file *filp, const char __user *buf,
+		size_t count, loff_t *f_pos)
+{
+	struct device_data	*spidev;
+	struct spi_device	*spi;
+	ssize_t			status = 0;
+	unsigned		missing;
+
+	/* chipselect only toggles at start or end of operation */
+	if (count > bufsiz)
+		return -EMSGSIZE;
+
+	spidev = (struct device_data *)filp->private_data;
+	spi = spidev->spi;
+
+	mutex_lock(&spidev->buf_lock);
+
+	/* there are no short write reports */
+	missing = copy_from_user(spidev->buffer, buf, count);
+	if (missing == 0) {
+		status = spi_write(spi, spidev->buffer, count);
+		if (status == 0)
+			status = count;
+	} else
+		status = -EFAULT;
+
+	mutex_unlock(&spidev->buf_lock);
+
+	return status;
+}
+
+static int
+spidev_ioctl(struct inode *inode, struct file *filp,
+		unsigned int cmd, unsigned long arg)
+{
+	int			err = 0;
+	int			retval = 0;
+	struct device_data	*dev_data;
+	struct spi_device	*spi;
+	u32			tmp;
+//	struct spi_ioc_message	msg;
+//	struct rd_post_context	rd_context;
+//	DECLARE_COMPLETION_ONSTACK(done);
+
+	/* Check type and command number */
+	if (_IOC_TYPE(cmd) != SPI_IOC_MAGIC)
+		return -ENOTTY;
+
+	/* Check access direction once here; don't repeat below.
+	 * NOTE: type is user-oriented while access_ok is kernel oriented;
+	 * so the direction of read and write may seem reversed
+	 */
+	if (_IOC_DIR(cmd) & _IOC_READ)
+		err = !access_ok(VERIFY_WRITE,
+				(void __user *)arg, _IOC_SIZE(cmd));
+	if (err == 0 && _IOC_DIR(cmd) & _IOC_WRITE)
+		err = !access_ok(VERIFY_READ,
+				(void __user *)arg, _IOC_SIZE(cmd));
+	if (err)
+		return -EFAULT;
+
+	dev_data = (struct device_data *)filp->private_data;
+	spi = dev_data->spi;
+
+	switch (cmd) {
+#if 0
+	case SPI_IOC_MESSAGE:
+		retval = copy_from_user(&msg,
+					(struct spi_ioc_message __user *)arg,
+					sizeof(struct spi_ioc_message));
+		if (retval == 0) {
+			dev_dbg(&spi->dev,
+				"SPI_IOC_MESSAGE\n"
+				"  tx_buf        = %p\n"
+				"  rx_buf        = %p\n"
+				"  count         = %Zd\n"
+				"  cs_change     = %d\n"
+				"  bits_per_word = %d\n"
+				"  delay_usecs   = %d\n"
+				"  speed_hz      = %d\n",
+				msg.tx_buf,
+				msg.rx_buf,
+				msg.count,
+				msg.cs_change,
+				msg.bits_per_word,
+				msg.delay_usecs,
+				msg.speed_hz);
+			if (msg.rx_buf) {
+				/* read-only or full-duplex */
+				rd_context.done = &done;
+				rd_context.context = NULL;
+				retval = pump_rdwr(filp, &msg, &rd_context);
+				if (retval > 0)
+					retval = read_completion(filp,
+								msg.rx_buf,
+								&rd_context);
+			} else if (msg.tx_buf) {
+				/* write-only */
+				retval = pump_rdwr(filp, &msg, NULL);
+			} else
+				retval = -EINVAL;
+		}
+		return retval;
+#endif
+
+	/* read requests */
+	case SPI_IOC_RD_MODE:
+		retval = __put_user(spi->mode & SPI_MODE_MASK,
+					(__u8 __user *)arg);
+		break;
+	case SPI_IOC_RD_LSB_FIRST:
+		retval = __put_user((spi->mode & SPI_LSB_FIRST) ?  1 : 0,
+					(__u8 __user *)arg);
+		break;
+	case SPI_IOC_RD_BITS_PER_WORD:
+		retval = __put_user(spi->bits_per_word, (__u8 __user *)arg);
+		break;
+	case SPI_IOC_RD_MAX_SPEED_HZ:
+		retval = __put_user(spi->max_speed_hz, (__u32 __user *)arg);
+		break;
+
+	/* write requests */
+	case SPI_IOC_WR_MODE:
+		retval = __get_user(tmp, (u8 __user *)arg);
+		if (retval == 0) {
+			u8	save = spi->mode;
+
+			if (tmp & ~SPI_MODE_MASK) {
+				retval = -EINVAL;
+				break;
+			}
+
+			tmp |= spi->mode & ~SPI_MODE_MASK;
+			spi->mode = (u8)tmp;
+			retval = spi_setup(spi);
+			if (retval < 0)
+				spi->mode = save;
+			else
+				dev_dbg(&spi->dev, "spi mode %02x\n", tmp);
+		}
+		break;
+	case SPI_IOC_WR_LSB_FIRST:
+		retval = __get_user(tmp, (__u8 __user *)arg);
+		if (retval == 0) {
+			u8	save = spi->mode;
+
+			if (tmp)
+				spi->mode |= SPI_LSB_FIRST;
+			else
+				spi->mode &= ~SPI_LSB_FIRST;
+			retval = spi_setup(spi);
+			if (retval < 0)
+				spi->mode = save;
+			else
+				dev_dbg(&spi->dev, "%csb first\n",
+						tmp ? 'l' : 'm');
+		}
+		break;
+	case SPI_IOC_WR_BITS_PER_WORD:
+		retval = __get_user(tmp, (__u8 __user *)arg);
+		if (retval == 0) {
+			u8	save = spi->bits_per_word;
+
+			spi->bits_per_word = tmp;
+			retval = spi_setup(spi);
+			if (retval < 0)
+				spi->bits_per_word = save;
+			else
+				dev_dbg(&spi->dev, "%d bits per word\n", tmp);
+		}
+		break;
+	case SPI_IOC_WR_MAX_SPEED_HZ:
+		retval = __get_user(tmp, (__u32 __user *)arg);
+		if (retval == 0) {
+			u32	save = spi->max_speed_hz;
+
+			spi->max_speed_hz = tmp;
+			retval = spi_setup(spi);
+			if (retval < 0)
+				spi->max_speed_hz = save;
+			else
+				dev_dbg(&spi->dev, "%d Hz (max)\n", tmp);
+		}
+		break;
+
+	default:
+		return -ENOTTY;
+	}
+	return retval;
+}
+
+static int spidev_open(struct inode *inode, struct file *filp)
+{
+	struct device_data	*spidev;
+	int			status = -ENXIO;
+
+	mutex_lock(&device_list_lock);
+
+	list_for_each_entry(spidev, &device_list, device_entry) {
+		if (spidev->dev.devt == inode->i_rdev) {
+			status = 0;
+			break;
+		}
+	}
+	if (status == 0) {
+		if (!spidev->buffer) {
+			spidev->buffer = kmalloc(bufsiz, GFP_KERNEL);
+			if (!spidev->buffer) {
+				dev_dbg(&spidev->spi->dev, "open/ENOMEM\n");
+				status = -ENOMEM;
+			}
+		}
+		if (status == 0) {
+			dev_dbg(&spidev->spi->dev, "open\n");
+			spidev->users++;
+			filp->private_data = spidev;
+		}
+	} else
+		pr_debug("spidev: nothing for minor %d\n", iminor(inode));
+
+	mutex_unlock(&device_list_lock);
+	return status;
+}
+
+static int spidev_release(struct inode *inode, struct file *filp)
+{
+	struct device_data	*spidev;
+	int			status = 0;
+
+	mutex_lock(&device_list_lock);
+	spidev = filp->private_data;
+	filp->private_data = NULL;
+	spidev->users--;
+	if (!spidev->users) {
+		kfree(spidev->buffer);
+		spidev->buffer = NULL;
+	}
+	mutex_unlock(&device_list_lock);
+
+	return status;
+}
+
+static struct file_operations spidev_fops = {
+	.owner =	THIS_MODULE,
+	.llseek =	no_llseek,
+	/* FIXME switch over to the aio primitives, so that userspace
+	 * gets more complete API coverage.  It'll simplify things too,
+	 * except for the locking.
+	 */
+	.write =	spidev_write,
+	.read =		spidev_read,
+	.ioctl =	spidev_ioctl,
+	.open =		spidev_open,
+	.release =	spidev_release,
+};
+
+/*-------------------------------------------------------------------------*/
+
+/* The main reason to have this class is to make mdev/udev create the
+ * /dev/spidevB.C character device nodes exposing our userspace API.
+ * It also simplifies memory management.
+ */
+
+static void spidev_classdev_release(struct device *dev)
+{
+	struct device_data	*spidev;
+
+	spidev = container_of(dev, struct device_data, dev);
+	kfree(spidev);
+}
+
+static struct class spidev_class = {
+	.name		= "spidev",
+	.owner		= THIS_MODULE,
+	.dev_release	= spidev_classdev_release,
+};
+
+/*-------------------------------------------------------------------------*/
+
+static int spidev_probe(struct spi_device *spi)
+{
+	struct device_data	*spidev;
+	int			status;
+	unsigned long		minor;
+
+	dev_dbg(&spi->dev, "probe\n");
+
+	/* Allocate driver data */
+	spidev = kzalloc(sizeof(struct device_data), GFP_KERNEL);
+	if (!spidev)
+		return -ENOMEM;
+
+	/* Initialize the driver data */
+	spidev->spi = spi;
+	mutex_init(&spidev->buf_lock);
+
+	INIT_LIST_HEAD(&spidev->device_entry);
+
+	/* If we can allocate a minor number, hook up this device.
+	 * Reusing minors is fine so long as udev or mdev is working.
+	 */
+	mutex_lock(&device_list_lock);
+	minor = find_next_zero_bit(minors, ARRAY_SIZE(minors), last_minor);
+	if (minor >= N_SPI_MINORS) {
+		dev_warn(&spi->dev, "wrapping minor number assignment\n");
+		minor = find_first_zero_bit(minors, ARRAY_SIZE(minors));
+	}
+	if (minor < N_SPI_MINORS) {
+		spidev->dev.parent = &spi->dev;
+		spidev->dev.class = &spidev_class;
+		spidev->dev.devt = MKDEV(SPIDEV_MAJOR, minor);
+		snprintf(spidev->dev.bus_id, sizeof spidev->dev.bus_id,
+				"spidev%d.%d",
+				spi->master->bus_num, spi->chip_select);
+		status = device_register(&spidev->dev);
+	} else {
+		dev_dbg(&spi->dev, "no minor number available!\n");
+		status = -ENODEV;
+	}
+	if (status == 0) {
+		set_bit(minor, minors);
+		last_minor = minor;
+		dev_set_drvdata(&spi->dev, spidev);
+		list_add(&spidev->device_entry, &device_list);
+	}
+	mutex_unlock(&device_list_lock);
+
+	if (status != 0)
+		kfree(spidev);
+
+	return status;
+}
+
+static int spidev_remove(struct spi_device *spi)
+{
+	struct device_data	*spidev = dev_get_drvdata(&spi->dev);
+
+	dev_dbg(&spi->dev, "remove\n");
+
+	mutex_lock(&device_list_lock);
+
+	list_del(&spidev->device_entry);
+	dev_set_drvdata(&spi->dev, NULL);
+	clear_bit(MINOR(spidev->dev.devt), minors);
+	device_unregister(&spidev->dev);
+
+	mutex_unlock(&device_list_lock);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+static int spidev_suspend(struct spi_device *spi, pm_message_t state)
+// __claims(spidev->buf_lock)
+{
+	struct device_data *spidev = dev_get_drvdata(&spi->dev);
+
+	dev_dbg(&spi->dev, "suspend\n");
+
+	/* ensure there's no pending I/O */
+	mutex_lock(&spidev->buf_lock);
+
+	return 0;
+}
+
+static int spidev_resume(struct spi_device *spi)
+// __releases(spidev->buf_lock)
+{
+	struct device_data *dev_data = dev_get_drvdata(&spi->dev);
+
+	dev_dbg(&spi->dev, "resume\n");
+
+	/* allow I/O to proceed */
+	mutex_unlock(&spidev->buf_lock);
+
+	return 0;
+}
+#else
+#define spidev_suspend NULL
+#define spidev_resume NULL
+#endif /* CONFIG_PM */
+
+static struct spi_driver spidev_spi = {
+	.driver = {
+		.name =		"spidev",
+		.owner =	THIS_MODULE,
+	},
+	.probe =	spidev_probe,
+	.remove =	__devexit_p(spidev_remove),
+	.suspend =	spidev_suspend,
+	.resume =	spidev_resume,
+};
+
+/*-------------------------------------------------------------------------*/
+
+static int __init spidev_init(void)
+{
+	int status;
+
+	/* Claim our 256 reserved device numbers.  Then register a class
+	 * that will key udev/mdev to add/remove /dev nodes.  Last, register
+	 * the driver which manages those device numbers.
+	 */
+	BUILD_BUG_ON(N_SPI_MINORS > 256);
+	status = register_chrdev(SPIDEV_MAJOR, "spi", &spidev_fops);
+	if (status < 0)
+		return status;
+
+	status = class_register(&spidev_class);
+	if (status < 0) {
+		unregister_chrdev(SPIDEV_MAJOR, spidev_spi.driver.name);
+		return status;
+	}
+
+	status = spi_register_driver(&spidev_spi);
+	if (status < 0) {
+		class_unregister(&spidev_class);
+		unregister_chrdev(SPIDEV_MAJOR, spidev_spi.driver.name);
+	}
+	return status;
+}
+module_init(spidev_init);
+
+static void __exit spidev_exit(void)
+{
+	spi_unregister_driver(&spidev_spi);
+	class_unregister(&spidev_class);
+	unregister_chrdev(SPIDEV_MAJOR, spidev_spi.driver.name);
+}
+module_exit(spidev_exit);
+
+MODULE_AUTHOR("Andrea Paterniani, <a.paterniani@swapp-eng.it>");
+MODULE_DESCRIPTION("User mode SPI device interface");
+MODULE_LICENSE("GPL");
diff -puN include/linux/Kbuild~spi-filesystem-api include/linux/Kbuild
--- a/include/linux/Kbuild~spi-filesystem-api
+++ a/include/linux/Kbuild
@@ -4,6 +4,7 @@ header-y += hdlc/
 header-y += isdn/
 header-y += nfsd/
 header-y += raid/
+header-y += spi/
 header-y += sunrpc/
 header-y += tc_act/
 header-y += netfilter/
diff -puN /dev/null include/linux/spi/Kbuild
--- /dev/null
+++ a/include/linux/spi/Kbuild
@@ -0,0 +1 @@
+header-y += spidev.h
diff -puN /dev/null include/linux/spi/spidev.h
--- /dev/null
+++ a/include/linux/spi/spidev.h
@@ -0,0 +1,87 @@
+/*
+ * include/linux/spi/spidev.h
+ *
+ * Copyright (C) 2006 SWAPP
+ *	Andrea Paterniani <a.paterniani@swapp-eng.it>
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
+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+  */
+
+#ifndef SPIDEV_H
+#define SPIDEV_H
+
+
+/* User space versions of kernel symbols for SPI clocking modes,
+ * matching <linux/spi/spi.h>
+ */
+
+#define SPI_CPHA		0x01
+#define SPI_CPOL		0x02
+
+#define SPI_MODE_0		(0|0)
+#define SPI_MODE_1		(0|SPI_CPHA)
+#define SPI_MODE_2		(SPI_CPOL|0)
+#define SPI_MODE_3		(SPI_CPOL|SPI_CPHA)
+
+
+/*---------------------------------------------------------------------------*/
+
+/* IOCTL commands */
+
+/* REVISIT be sure nobody's using this code ... */
+#define SPI_IOC_MAGIC			'k'
+
+/* SPI_IOC_MESSAGE gives userspace the equivalent of kernel spi_sync().
+ * Pass it an array of related transfers, they'll execute together.
+ * Each transfer may be half duplex (either direction) or full duplex.
+ *
+ * An example would be a common register read idiom: activate chipselect,
+ * write command, read response, deactivate chipselect.  For correctness,
+ * sometimes those accesses need to be grouped.
+ */
+struct spi_ioc_transfer {
+	const char __user	*tx_buf;
+	char __user		*rx_buf;
+	size_t			count;
+	__u8			cs_change;
+	__u8			bits_per_word;
+	__u16			delay_usecs;
+	__u32			speed_hz;
+};
+
+#define SPI_MSGSIZE(N) \
+	((((N)*(sizeof (struct spi_ioc_transfer))) < (1 << IOC_SIZEBITS)) \
+		? ((N)*(sizeof (struct spi_ioc_transfer))) : 0)
+#define SPI_IOC_MESSAGE(N)	_IOW_BAD(SPI_IOC_MAGIC, 0, SPI_MSGSIZE(N))
+
+/* Read / Write of SPI mode (SPI_MODE_0..SPI_MODE_3) */
+#define SPI_IOC_RD_MODE			_IOR(SPI_IOC_MAGIC, 1, __u8)
+#define SPI_IOC_WR_MODE			_IOW(SPI_IOC_MAGIC, 1, __u8)
+
+/* Read / Write SPI bit justification */
+#define SPI_IOC_RD_LSB_FIRST		_IOR(SPI_IOC_MAGIC, 2, __u8)
+#define SPI_IOC_WR_LSB_FIRST		_IOW(SPI_IOC_MAGIC, 2, __u8)
+
+/* Read / Write SPI device word length (1..N) */
+#define SPI_IOC_RD_BITS_PER_WORD	_IOR(SPI_IOC_MAGIC, 3, __u8)
+#define SPI_IOC_WR_BITS_PER_WORD	_IOW(SPI_IOC_MAGIC, 3, __u8)
+
+/* Read / Write SPI device default max speed hz */
+#define SPI_IOC_RD_MAX_SPEED_HZ		_IOR(SPI_IOC_MAGIC, 4, __u32)
+#define SPI_IOC_WR_MAX_SPEED_HZ		_IOW(SPI_IOC_MAGIC, 4, __u32)
+
+
+
+#endif /* SPIDEV_H */
_

Patches currently in -mm which might be from a.paterniani@swapp-eng.it are

spi-freescale-imx-spi-controller-driver-bis.patch
spi-freescale-imx-spi-controller-driver-v5.patch
spi-filesystem-api.patch
