From: akpm@linux-foundation.org
Subject: - sony-laptop-add-sonypi-compat-code.patch removed from -mm tree
Date: Wed, 11 Apr 2007 16:20:53 -0700
Message-ID: <200704112320.l3BNKr4V017520@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35945 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161430AbXDKXWP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 11 Apr 2007 19:22:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: malattia@linux.it, lenb@kernel.org, stelian@popies.net, mm-commits@vger.kernel.org


The patch titled
     sony-laptop: add sonypi compat code
has been removed from the -mm tree.  Its filename was
     sony-laptop-add-sonypi-compat-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sony-laptop: add sonypi compat code
From: Mattia Dongili <malattia@linux.it>

Compatibility code to allow old sonypi bound userspace apps to still work.

Signed-off-by: Mattia Dongili <malattia@linux.it>
Cc: Len Brown <lenb@kernel.org>
Cc: Stelian Pop <stelian@popies.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/Kconfig       |    6 
 drivers/misc/sony-laptop.c |  332 ++++++++++++++++++++++++++++++++++-
 2 files changed, 335 insertions(+), 3 deletions(-)

diff -puN drivers/misc/Kconfig~add-sonypi-compat-code drivers/misc/Kconfig
--- a/drivers/misc/Kconfig~add-sonypi-compat-code
+++ a/drivers/misc/Kconfig
@@ -121,6 +121,12 @@ config SONY_LAPTOP
 
 	  Read <file:Documentation/sony-laptop.txt> for more information.
 
+config SONY_LAPTOP_OLD
+	bool "Sonypi compatibility"
+	depends on SONY_LAPTOP
+	  ---help---
+	  Build the sonypi driver compatibility code into the sony-laptop driver.
+
 config THINKPAD_ACPI
 	tristate "ThinkPad ACPI Laptop Extras"
 	depends on X86 && ACPI
diff -puN drivers/misc/sony-laptop.c~add-sonypi-compat-code drivers/misc/sony-laptop.c
--- a/drivers/misc/sony-laptop.c~add-sonypi-compat-code
+++ a/drivers/misc/sony-laptop.c
@@ -62,6 +62,10 @@
 #include <acpi/acpi_bus.h>
 #include <asm/uaccess.h>
 #include <linux/sonypi.h>
+#ifdef CONFIG_SONY_LAPTOP_OLD
+#include <linux/poll.h>
+#include <linux/miscdevice.h>
+#endif
 
 #define DRV_PFX			"sony-laptop: "
 #define dprintk(msg...)		do {			\
@@ -96,13 +100,21 @@ MODULE_PARM_DESC(no_spic,
 static int compat;		/* = 0 */
 module_param(compat, int, 0444);
 MODULE_PARM_DESC(compat,
-		 "set this if you want to enable backward compatibility mode for SPIC");
+		 "set this if you want to enable backward compatibility mode");
 
 static unsigned long mask = 0xffffffff;
 module_param(mask, ulong, 0644);
 MODULE_PARM_DESC(mask,
 		 "set this to the mask of event you want to enable (see doc)");
 
+#ifdef CONFIG_SONY_LAPTOP_OLD
+static int minor = -1;
+module_param(minor, int, 0);
+MODULE_PARM_DESC(minor,
+		 "minor number of the misc device for the SPIC compatibility code, "
+		 "default is -1 (automatic)");
+#endif
+
 /*********** Input Devices ***********/
 
 #define SONY_LAPTOP_BUF_SIZE	128
@@ -1318,6 +1330,16 @@ static ssize_t sony_pic_bluetoothpower_s
 /* fan speed */
 /* FAN0 information (reverse engineered from ACPI tables) */
 #define SONY_PIC_FAN0_STATUS	0x93
+static int sony_pic_set_fanspeed(unsigned long value)
+{
+	return ec_write(SONY_PIC_FAN0_STATUS, value);
+}
+
+static int sony_pic_get_fanspeed(u8 *value)
+{
+	return ec_read(SONY_PIC_FAN0_STATUS, value);
+}
+
 static ssize_t sony_pic_fanspeed_store(struct device *dev,
 		struct device_attribute *attr,
 		const char *buffer, size_t count)
@@ -1327,7 +1349,7 @@ static ssize_t sony_pic_fanspeed_store(s
 		return -EINVAL;
 
 	value = simple_strtoul(buffer, NULL, 10);
-	if (ec_write(SONY_PIC_FAN0_STATUS, value))
+	if (sony_pic_set_fanspeed(value))
 		return -EIO;
 
 	return count;
@@ -1337,7 +1359,7 @@ static ssize_t sony_pic_fanspeed_show(st
 		struct device_attribute *attr, char *buffer)
 {
 	u8 value = 0;
-	if (ec_read(SONY_PIC_FAN0_STATUS, &value))
+	if (sony_pic_get_fanspeed(&value))
 		return -EIO;
 
 	return snprintf(buffer, PAGE_SIZE, "%d\n", value);
@@ -1363,6 +1385,304 @@ static struct attribute_group spic_attri
 	.attrs = spic_attributes
 };
 
+/******** SONYPI compatibility **********/
+#ifdef CONFIG_SONY_LAPTOP_OLD
+
+/* battery / brightness / temperature  addresses */
+#define SONYPI_BAT_FLAGS	0x81
+#define SONYPI_LCD_LIGHT	0x96
+#define SONYPI_BAT1_PCTRM	0xa0
+#define SONYPI_BAT1_LEFT	0xa2
+#define SONYPI_BAT1_MAXRT	0xa4
+#define SONYPI_BAT2_PCTRM	0xa8
+#define SONYPI_BAT2_LEFT	0xaa
+#define SONYPI_BAT2_MAXRT	0xac
+#define SONYPI_BAT1_MAXTK	0xb0
+#define SONYPI_BAT1_FULL	0xb2
+#define SONYPI_BAT2_MAXTK	0xb8
+#define SONYPI_BAT2_FULL	0xba
+#define SONYPI_TEMP_STATUS	0xC1
+
+struct sonypi_compat_s {
+	struct fasync_struct	*fifo_async;
+	struct kfifo		*fifo;
+	spinlock_t		fifo_lock;
+	wait_queue_head_t	fifo_proc_list;
+	atomic_t		open_count;
+};
+static struct sonypi_compat_s sonypi_compat = {
+	.open_count = ATOMIC_INIT(0),
+};
+
+static int sonypi_misc_fasync(int fd, struct file *filp, int on)
+{
+	int retval;
+
+	retval = fasync_helper(fd, filp, on, &sonypi_compat.fifo_async);
+	if (retval < 0)
+		return retval;
+	return 0;
+}
+
+static int sonypi_misc_release(struct inode *inode, struct file *file)
+{
+	sonypi_misc_fasync(-1, file, 0);
+	atomic_dec(&sonypi_compat.open_count);
+	return 0;
+}
+
+static int sonypi_misc_open(struct inode *inode, struct file *file)
+{
+	/* Flush input queue on first open */
+	if (atomic_inc_return(&sonypi_compat.open_count) == 1)
+		kfifo_reset(sonypi_compat.fifo);
+	return 0;
+}
+
+static ssize_t sonypi_misc_read(struct file *file, char __user *buf,
+				size_t count, loff_t *pos)
+{
+	ssize_t ret;
+	unsigned char c;
+
+	if ((kfifo_len(sonypi_compat.fifo) == 0) &&
+	    (file->f_flags & O_NONBLOCK))
+		return -EAGAIN;
+
+	ret = wait_event_interruptible(sonypi_compat.fifo_proc_list,
+				       kfifo_len(sonypi_compat.fifo) != 0);
+	if (ret)
+		return ret;
+
+	while (ret < count &&
+	       (kfifo_get(sonypi_compat.fifo, &c, sizeof(c)) == sizeof(c))) {
+		if (put_user(c, buf++))
+			return -EFAULT;
+		ret++;
+	}
+
+	if (ret > 0) {
+		struct inode *inode = file->f_path.dentry->d_inode;
+		inode->i_atime = current_fs_time(inode->i_sb);
+	}
+
+	return ret;
+}
+
+static unsigned int sonypi_misc_poll(struct file *file, poll_table *wait)
+{
+	poll_wait(file, &sonypi_compat.fifo_proc_list, wait);
+	if (kfifo_len(sonypi_compat.fifo))
+		return POLLIN | POLLRDNORM;
+	return 0;
+}
+
+static int ec_read16(u8 addr, u16 *value)
+{
+	u8 val_lb, val_hb;
+	if (ec_read(addr, &val_lb))
+		return -1;
+	if (ec_read(addr + 1, &val_hb))
+		return -1;
+	*value = val_lb | (val_hb << 8);
+	return 0;
+}
+
+static int sonypi_misc_ioctl(struct inode *ip, struct file *fp,
+			     unsigned int cmd, unsigned long arg)
+{
+	int ret = 0;
+	void __user *argp = (void __user *)arg;
+	u8 val8;
+	u16 val16;
+	int value;
+
+	/*down(&sonypi_device.lock);*/
+	switch (cmd) {
+	case SONYPI_IOCGBRT:
+		if (sony_backlight_device == NULL) {
+			ret = -EIO;
+			break;
+		}
+		if (acpi_callgetfunc(sony_nc_acpi_handle, "GBRT", &value)) {
+			ret = -EIO;
+			break;
+		}
+		val8 = ((value & 0xff) - 1) << 5;
+		if (copy_to_user(argp, &val8, sizeof(val8)))
+				ret = -EFAULT;
+		break;
+	case SONYPI_IOCSBRT:
+		if (sony_backlight_device == NULL) {
+			ret = -EIO;
+			break;
+		}
+		if (copy_from_user(&val8, argp, sizeof(val8))) {
+			ret = -EFAULT;
+			break;
+		}
+		if (acpi_callsetfunc(sony_nc_acpi_handle, "SBRT",
+				(val8 >> 5) + 1, NULL)) {
+			ret = -EIO;
+			break;
+		}
+		/* sync the backlight device status */
+		sony_backlight_device->props.brightness =
+		    sony_backlight_get_brightness(sony_backlight_device);
+		break;
+	case SONYPI_IOCGBAT1CAP:
+		if (ec_read16(SONYPI_BAT1_FULL, &val16)) {
+			ret = -EIO;
+			break;
+		}
+		if (copy_to_user(argp, &val16, sizeof(val16)))
+			ret = -EFAULT;
+		break;
+	case SONYPI_IOCGBAT1REM:
+		if (ec_read16(SONYPI_BAT1_LEFT, &val16)) {
+			ret = -EIO;
+			break;
+		}
+		if (copy_to_user(argp, &val16, sizeof(val16)))
+			ret = -EFAULT;
+		break;
+	case SONYPI_IOCGBAT2CAP:
+		if (ec_read16(SONYPI_BAT2_FULL, &val16)) {
+			ret = -EIO;
+			break;
+		}
+		if (copy_to_user(argp, &val16, sizeof(val16)))
+			ret = -EFAULT;
+		break;
+	case SONYPI_IOCGBAT2REM:
+		if (ec_read16(SONYPI_BAT2_LEFT, &val16)) {
+			ret = -EIO;
+			break;
+		}
+		if (copy_to_user(argp, &val16, sizeof(val16)))
+			ret = -EFAULT;
+		break;
+	case SONYPI_IOCGBATFLAGS:
+		if (ec_read(SONYPI_BAT_FLAGS, &val8)) {
+			ret = -EIO;
+			break;
+		}
+		val8 &= 0x07;
+		if (copy_to_user(argp, &val8, sizeof(val8)))
+			ret = -EFAULT;
+		break;
+	case SONYPI_IOCGBLUE:
+		val8 = spic_dev.bluetooth_power;
+		if (copy_to_user(argp, &val8, sizeof(val8)))
+			ret = -EFAULT;
+		break;
+	case SONYPI_IOCSBLUE:
+		if (copy_from_user(&val8, argp, sizeof(val8))) {
+			ret = -EFAULT;
+			break;
+		}
+		sony_pic_set_bluetoothpower(val8);
+		break;
+	/* FAN Controls */
+	case SONYPI_IOCGFAN:
+		if (sony_pic_get_fanspeed(&val8)) {
+			ret = -EIO;
+			break;
+		}
+		if (copy_to_user(argp, &val8, sizeof(val8)))
+			ret = -EFAULT;
+		break;
+	case SONYPI_IOCSFAN:
+		if (copy_from_user(&val8, argp, sizeof(val8))) {
+			ret = -EFAULT;
+			break;
+		}
+		if (sony_pic_set_fanspeed(val8))
+			ret = -EIO;
+		break;
+	/* GET Temperature (useful under APM) */
+	case SONYPI_IOCGTEMP:
+		if (ec_read(SONYPI_TEMP_STATUS, &val8)) {
+			ret = -EIO;
+			break;
+		}
+		if (copy_to_user(argp, &val8, sizeof(val8)))
+			ret = -EFAULT;
+		break;
+	default:
+		ret = -EINVAL;
+	}
+	/*up(&sonypi_device.lock);*/
+	return ret;
+}
+
+static const struct file_operations sonypi_misc_fops = {
+	.owner		= THIS_MODULE,
+	.read		= sonypi_misc_read,
+	.poll		= sonypi_misc_poll,
+	.open		= sonypi_misc_open,
+	.release	= sonypi_misc_release,
+	.fasync		= sonypi_misc_fasync,
+	.ioctl		= sonypi_misc_ioctl,
+};
+
+static struct miscdevice sonypi_misc_device = {
+	.minor		= MISC_DYNAMIC_MINOR,
+	.name		= "sonypi",
+	.fops		= &sonypi_misc_fops,
+};
+
+static void sonypi_compat_report_event(u8 event)
+{
+	kfifo_put(sonypi_compat.fifo, (unsigned char *)&event, sizeof(event));
+	kill_fasync(&sonypi_compat.fifo_async, SIGIO, POLL_IN);
+	wake_up_interruptible(&sonypi_compat.fifo_proc_list);
+}
+
+static int sonypi_compat_init(void)
+{
+	int error;
+
+	spin_lock_init(&sonypi_compat.fifo_lock);
+	sonypi_compat.fifo = kfifo_alloc(SONY_LAPTOP_BUF_SIZE, GFP_KERNEL,
+					 &sonypi_compat.fifo_lock);
+	if (IS_ERR(sonypi_compat.fifo)) {
+		printk(KERN_ERR DRV_PFX "kfifo_alloc failed\n");
+		return PTR_ERR(sonypi_compat.fifo);
+	}
+
+	init_waitqueue_head(&sonypi_compat.fifo_proc_list);
+	/*init_MUTEX(&sonypi_device.lock);*/
+
+	if (minor != -1)
+		sonypi_misc_device.minor = minor;
+	error = misc_register(&sonypi_misc_device);
+	if (error) {
+		printk(KERN_ERR DRV_PFX "misc_register failed\n");
+		goto err_free_kfifo;
+	}
+	if (minor == -1)
+		printk(KERN_INFO "sonypi: device allocated minor is %d\n",
+		       sonypi_misc_device.minor);
+
+	return 0;
+
+err_free_kfifo:
+	kfifo_free(sonypi_compat.fifo);
+	return error;
+}
+
+static void sonypi_compat_exit(void)
+{
+	misc_deregister(&sonypi_misc_device);
+	kfifo_free(sonypi_compat.fifo);
+}
+#else
+static int sonypi_compat_init(void) { return 0; }
+static void sonypi_compat_exit(void) { }
+static void sonypi_compat_report_event(u8 event) { }
+#endif /* CONFIG_SONY_LAPTOP_OLD */
+
 /*
  * ACPI callbacks
  */
@@ -1604,6 +1924,7 @@ static irqreturn_t sony_pic_irq(int irq,
 found:
 	sony_laptop_report_input_event(device_event);
 	acpi_bus_generate_event(spic_dev.acpi_dev, 1, device_event);
+	sonypi_compat_report_event(device_event);
 
 	return IRQ_HANDLED;
 }
@@ -1618,6 +1939,8 @@ static int sony_pic_remove(struct acpi_d
 	struct sony_pic_ioport *io, *tmp_io;
 	struct sony_pic_irq *irq, *tmp_irq;
 
+	sonypi_compat_exit();
+
 	if (sony_pic_disable(device)) {
 		printk(KERN_ERR DRV_PFX "Couldn't disable device.\n");
 		return -ENXIO;
@@ -1731,6 +2054,9 @@ static int sony_pic_add(struct acpi_devi
 	if (result)
 		goto err_remove_pf;
 
+	if (sonypi_compat_init())
+		goto err_remove_pf;
+
 	return 0;
 
 err_remove_pf:
_

Patches currently in -mm which might be from malattia@linux.it are

git-cpufreq.patch
