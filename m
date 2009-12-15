From: akpm@linux-foundation.org
Subject: [nacked] gpiolib-add-names-file-in-gpio-chip-sysfs.patch removed from -mm tree
Date: Tue, 15 Dec 2009 14:44:27 -0800
Message-ID: <200912152244.nBFMiRXD018283@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60240 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755162AbZLOWoj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Dec 2009 17:44:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ben@simtec.co.uk, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     gpiolib: add names file in gpio chip sysfs
has been removed from the -mm tree.  Its filename was
     gpiolib-add-names-file-in-gpio-chip-sysfs.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib: add names file in gpio chip sysfs
From: Ben Dooks <ben@simtec.co.uk>

Add a 'names' file to the sysfs entries for each chip to show which
have names.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN drivers/gpio/gpiolib.c~gpiolib-add-names-file-in-gpio-chip-sysfs drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-add-names-file-in-gpio-chip-sysfs
+++ a/drivers/gpio/gpiolib.c
@@ -577,6 +577,7 @@ static const struct attribute_group gpio
  *   /base ... matching gpio_chip.base (N)
  *   /label ... matching gpio_chip.label
  *   /ngpio ... matching gpio_chip.ngpio
+ *   /names ... matching gpio_chip.names
  */
 
 static ssize_t chip_base_show(struct device *dev,
@@ -606,10 +607,30 @@ static ssize_t chip_ngpio_show(struct de
 }
 static DEVICE_ATTR(ngpio, 0444, chip_ngpio_show, NULL);
 
+static ssize_t chip_names_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	const struct gpio_chip *chip = dev_get_drvdata(dev);
+	char **names = chip->names;
+	int ptr = 0;
+	int name;
+
+	if (!names)
+		return -EINVAL;
+
+	for (name = 0; name < chip->ngpio && ptr < PAGE_SIZE; name++)
+		ptr += snprintf(buf + ptr, PAGE_SIZE - ptr,
+				"%s\n", names[name] ? names[name] : "");
+
+	return ptr;
+}
+static DEVICE_ATTR(names, 0444, chip_names_show, NULL);
+
 static const struct attribute *gpiochip_attrs[] = {
 	&dev_attr_base.attr,
 	&dev_attr_label.attr,
 	&dev_attr_ngpio.attr,
+	&dev_attr_names.attr,
 	NULL,
 };
 
_

Patches currently in -mm which might be from ben@simtec.co.uk are

origin.patch
linux-next.patch
spi_s3c24xx-add-fiq-pseudo-dma-support.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch
sm501-fix-missing-uses-of-resource_size.patch
sm501-fix-use-of-old-asm-ioh-instead-of-linux-ioh.patch
sm501-implement-acceleration-features.patch

