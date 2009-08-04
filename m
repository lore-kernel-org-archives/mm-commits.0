From: akpm@linux-foundation.org
Subject: + gpiolib-add-names-file-in-gpio-chip-sysfs.patch added to -mm tree
Date: Tue, 04 Aug 2009 16:38:34 -0700
Message-ID: <200908042338.n74NcYg2014572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56574 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755385AbZHDXjh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Aug 2009 19:39:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ben@simtec.co.uk, dbrownell@users.sourceforge.net


The patch titled
     gpiolib: add names file in gpio chip sysfs
has been added to the -mm tree.  Its filename is
     gpiolib-add-names-file-in-gpio-chip-sysfs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gpiolib: add names file in gpio chip sysfs
From: Ben Dooks <ben@simtec.co.uk>

Add a 'names' file to the sysfs entries for each chip to show which
have names.

Signed-off-by: Ben Dooks <ben@simtec.co.uk>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/gpio/gpiolib.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff -puN drivers/gpio/gpiolib.c~gpiolib-add-names-file-in-gpio-chip-sysfs drivers/gpio/gpiolib.c
--- a/drivers/gpio/gpiolib.c~gpiolib-add-names-file-in-gpio-chip-sysfs
+++ a/drivers/gpio/gpiolib.c
@@ -303,6 +303,7 @@ static const struct attribute_group gpio
  *   /base ... matching gpio_chip.base (N)
  *   /label ... matching gpio_chip.label
  *   /ngpio ... matching gpio_chip.ngpio
+ *   /names ... matching gpio_chip.names
  */
 
 static ssize_t chip_base_show(struct device *dev,
@@ -332,10 +333,30 @@ static ssize_t chip_ngpio_show(struct de
 }
 static DEVICE_ATTR(ngpio, 0444, chip_ngpio_show, NULL);
 
+static ssize_t chip_names_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	const struct gpio_chip*chip = dev_get_drvdata(dev);
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
+DEVICE_ATTR(names, 0444, chip_names_show, NULL);
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

linux-next.patch
gpiolib-add-names-file-in-gpio-chip-sysfs.patch

