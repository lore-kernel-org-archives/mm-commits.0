From: akpm@linux-foundation.org
Subject: + spi-fix-refcount-related-spidev-oops-on-rmmod.patch added to -mm tree
Date: Fri, 23 May 2008 17:48:19 -0700
Message-ID: <200805240048.m4O0mJ6b017277@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56028 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751857AbYEXAsn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 23 May 2008 20:48:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dbrownell@users.sourceforge.net, bigeasy@tglx.de


The patch titled
     spi: fix refcount-related spidev oops-on-rmmod
has been added to the -mm tree.  Its filename is
     spi-fix-refcount-related-spidev-oops-on-rmmod.patch

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
Subject: spi: fix refcount-related spidev oops-on-rmmod
From: David Brownell <dbrownell@users.sourceforge.net>

This addresses other oopsing paths in "spidev" by changing how it manages
refcounting.  It decouples the lifecycle of the per-device data from the
class device (not just the spi device):

  - Use class_{create,destroy} not class_{register,unregister}.
  - Use device_{create,destroy} not device_{register,unregister}.
  - Free the per-device data only when TWO conditions are true:
      * Driver is unbound from underlying SPI device, and
      * Device is no longer open (new)

Also, spi_{get,set}_drvdata not dev_{get,set}_drvdata for simpler code.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Sebastian Siewior <bigeasy@tglx.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/spi/spidev.c |   64 +++++++++++++++++++++--------------------
 1 file changed, 34 insertions(+), 30 deletions(-)

diff -puN drivers/spi/spidev.c~spi-fix-refcount-related-spidev-oops-on-rmmod drivers/spi/spidev.c
--- a/drivers/spi/spidev.c~spi-fix-refcount-related-spidev-oops-on-rmmod
+++ a/drivers/spi/spidev.c
@@ -25,6 +25,7 @@
 #include <linux/ioctl.h>
 #include <linux/fs.h>
 #include <linux/device.h>
+#include <linux/err.h>
 #include <linux/list.h>
 #include <linux/errno.h>
 #include <linux/mutex.h>
@@ -67,11 +68,12 @@ static unsigned long	minors[N_SPI_MINORS
 				| SPI_LSB_FIRST | SPI_3WIRE | SPI_LOOP)
 
 struct spidev_data {
-	struct device		dev;
+	dev_t			devt;
 	spinlock_t		spi_lock;
 	struct spi_device	*spi;
 	struct list_head	device_entry;
 
+	/* buffer is NULL unless this device is open (users > 0) */
 	struct mutex		buf_lock;
 	unsigned		users;
 	u8			*buffer;
@@ -467,7 +469,7 @@ static int spidev_open(struct inode *ino
 	mutex_lock(&device_list_lock);
 
 	list_for_each_entry(spidev, &device_list, device_entry) {
-		if (spidev->dev.devt == inode->i_rdev) {
+		if (spidev->devt == inode->i_rdev) {
 			status = 0;
 			break;
 		}
@@ -500,10 +502,22 @@ static int spidev_release(struct inode *
 	mutex_lock(&device_list_lock);
 	spidev = filp->private_data;
 	filp->private_data = NULL;
+
+	/* last close? */
 	spidev->users--;
 	if (!spidev->users) {
+		int		dofree;
+
 		kfree(spidev->buffer);
 		spidev->buffer = NULL;
+
+		/* ... after we unbound from the underlying device? */
+		spin_lock_irq(&spidev->spi_lock);
+		dofree = (spidev->spi == NULL);
+		spin_unlock_irq(&spidev->spi_lock);
+
+		if (dofree)
+			kfree(spidev);
 	}
 	mutex_unlock(&device_list_lock);
 
@@ -530,19 +544,7 @@ static struct file_operations spidev_fop
  * It also simplifies memory management.
  */
 
-static void spidev_classdev_release(struct device *dev)
-{
-	struct spidev_data	*spidev;
-
-	spidev = container_of(dev, struct spidev_data, dev);
-	kfree(spidev);
-}
-
-static struct class spidev_class = {
-	.name		= "spidev",
-	.owner		= THIS_MODULE,
-	.dev_release	= spidev_classdev_release,
-};
+static struct class *spidev_class;
 
 /*-------------------------------------------------------------------------*/
 
@@ -570,20 +572,20 @@ static int spidev_probe(struct spi_devic
 	mutex_lock(&device_list_lock);
 	minor = find_first_zero_bit(minors, N_SPI_MINORS);
 	if (minor < N_SPI_MINORS) {
-		spidev->dev.parent = &spi->dev;
-		spidev->dev.class = &spidev_class;
-		spidev->dev.devt = MKDEV(SPIDEV_MAJOR, minor);
-		snprintf(spidev->dev.bus_id, sizeof spidev->dev.bus_id,
+		struct device *dev;
+
+		spidev->devt = MKDEV(SPIDEV_MAJOR, minor);
+		dev = device_create(spidev_class, &spi->dev, spidev->devt,
 				"spidev%d.%d",
 				spi->master->bus_num, spi->chip_select);
-		status = device_register(&spidev->dev);
+		status = IS_ERR(dev) ? PTR_ERR(dev) : 0;
 	} else {
 		dev_dbg(&spi->dev, "no minor number available!\n");
 		status = -ENODEV;
 	}
 	if (status == 0) {
 		set_bit(minor, minors);
-		dev_set_drvdata(&spi->dev, spidev);
+		spi_set_drvdata(spi, spidev);
 		list_add(&spidev->device_entry, &device_list);
 	}
 	mutex_unlock(&device_list_lock);
@@ -596,19 +598,21 @@ static int spidev_probe(struct spi_devic
 
 static int spidev_remove(struct spi_device *spi)
 {
-	struct spidev_data	*spidev = dev_get_drvdata(&spi->dev);
+	struct spidev_data	*spidev = spi_get_drvdata(spi);
 
 	/* make sure ops on existing fds can abort cleanly */
 	spin_lock_irq(&spidev->spi_lock);
 	spidev->spi = NULL;
+	spi_set_drvdata(spi, NULL);
 	spin_unlock_irq(&spidev->spi_lock);
 
 	/* prevent new opens */
 	mutex_lock(&device_list_lock);
 	list_del(&spidev->device_entry);
-	dev_set_drvdata(&spi->dev, NULL);
-	clear_bit(MINOR(spidev->dev.devt), minors);
-	device_unregister(&spidev->dev);
+	device_destroy(spidev_class, spidev->devt);
+	clear_bit(MINOR(spidev->devt), minors);
+	if (spidev->users == 0)
+		kfree(spidev);
 	mutex_unlock(&device_list_lock);
 
 	return 0;
@@ -644,15 +648,15 @@ static int __init spidev_init(void)
 	if (status < 0)
 		return status;
 
-	status = class_register(&spidev_class);
-	if (status < 0) {
+	spidev_class = class_create(THIS_MODULE, "spidev");
+	if (IS_ERR(spidev_class)) {
 		unregister_chrdev(SPIDEV_MAJOR, spidev_spi.driver.name);
-		return status;
+		return PTR_ERR(spidev_class);
 	}
 
 	status = spi_register_driver(&spidev_spi);
 	if (status < 0) {
-		class_unregister(&spidev_class);
+		class_destroy(spidev_class);
 		unregister_chrdev(SPIDEV_MAJOR, spidev_spi.driver.name);
 	}
 	return status;
@@ -662,7 +666,7 @@ module_init(spidev_init);
 static void __exit spidev_exit(void)
 {
 	spi_unregister_driver(&spidev_spi);
-	class_unregister(&spidev_class);
+	class_destroy(spidev_class);
 	unregister_chrdev(SPIDEV_MAJOR, spidev_spi.driver.name);
 }
 module_exit(spidev_exit);
_

Patches currently in -mm which might be from dbrownell@users.sourceforge.net are

origin.patch
gpio-pca953x-driver-handles-pca9554-too.patch
gpio-mcp23s08-debug-fix.patch
gpiolib-fix-off-by-one-errors.patch
gpio-build-fixes-mostly-potential.patch
spi-remove-some-spidev-oops-on-rmmod-paths.patch
spi-fix-refcount-related-spidev-oops-on-rmmod.patch
linux-next.patch
acpi_pm_device_sleep_state-cleanup.patch
git-orion.patch
xilinx_spi-test-below-0-on-unsigned-irq-in-xilinx_spi_probe.patch
spi-kconfig-simplifications.patch
spi-make-spi_board_infomodalias-a-char-array.patch
gpio-sysfs-interface.patch

