From: akpm@linux-foundation.org
Subject: [alternative-merged]
 usbvision-i2c-fix-format-overflow-warning.patch removed from -mm tree
Date: Fri, 21 Jul 2017 11:41:26 -0700
Message-ID: <20170721184126.vnbrmH_yh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38184 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753527AbdGUSl1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Jul 2017 14:41:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/media/usb/usbvision/usbvision-i2c.c: fix format overflow warning
has been removed from the -mm tree.  Its filename was
     usbvision-i2c-fix-format-overflow-warning.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: drivers/media/usb/usbvision/usbvision-i2c.c: fix format overflow warning

gcc-7 notices that we copy a fixed length string into another
string of the same size, with additional characters:

drivers/media/usb/usbvision/usbvision-i2c.c: In function 'usbvision_i2c_register':
drivers/media/usb/usbvision/usbvision-i2c.c:190:36: error: '%d' directive writing between 1 and 11 bytes into a region of size between 0 and 47 [-Werror=format-overflow=]
  sprintf(usbvision->i2c_adap.name, "%s-%d-%s", i2c_adap_template.name,
                                    ^~~~~~~~~~
drivers/media/usb/usbvision/usbvision-i2c.c:190:2: note: 'sprintf' output between 4 and 76 bytes into a destination of size 48

We know this is fine as the template name is always "usbvision", so
we can easily avoid the warning by using this as the format string
directly.

Link: http://lkml.kernel.org/r/20170714120720.906842-15-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/usb/usbvision/usbvision-i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/media/usb/usbvision/usbvision-i2c.c~usbvision-i2c-fix-format-overflow-warning drivers/media/usb/usbvision/usbvision-i2c.c
--- a/drivers/media/usb/usbvision/usbvision-i2c.c~usbvision-i2c-fix-format-overflow-warning
+++ a/drivers/media/usb/usbvision/usbvision-i2c.c
@@ -187,8 +187,8 @@ int usbvision_i2c_register(struct usb_us
 
 	usbvision->i2c_adap = i2c_adap_template;
 
-	sprintf(usbvision->i2c_adap.name, "%s-%d-%s", i2c_adap_template.name,
-		usbvision->dev->bus->busnum, usbvision->dev->devpath);
+	sprintf(usbvision->i2c_adap.name, "usbvision-%d-%s",
+		 usbvision->dev->bus->busnum, usbvision->dev->devpath);
 	PDEBUG(DBG_I2C, "Adaptername: %s", usbvision->i2c_adap.name);
 	usbvision->i2c_adap.dev.parent = &usbvision->dev->dev;
 
_

Patches currently in -mm which might be from arnd@arndb.de are

kbuild-disable-wformat-truncation-warnings-by-default.patch
scsi-megaraid-fix-format-overflow-warning.patch
scsi-mpt3sas-fix-format-overflow-warning.patch
scsi-fusion-fix-string-overflow-warning.patch
scsi-gdth-avoid-buffer-overflow-warning.patch
scsi-fnic-fix-format-string-overflow-warning.patch
scsi-gdth-increase-the-procfs-event-buffer-size.patch
hwmon-applesmc-fix-format-string-overflow.patch
x86-intel-mid-fix-a-format-string-overflow-warning.patch
platform-x86-alienware-wmi-fix-format-string-overflow-warning.patch
block-dac960-shut-up-format-overflow-warning.patch
fscache-fix-fscache_objlist_show-format-processing.patch
ib-mlx4-fix-sprintf-format-warning.patch

