From: akpm@linux-foundation.org
Subject: + rtc-ds1307-exports-nvram.patch added to -mm tree
Date: Mon, 05 Nov 2007 16:36:15 -0800
Message-ID: <200711060036.lA60aF13027734@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36178 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbXKFAhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 Nov 2007 19:37:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, a.zummo@towertech.it, dbrownell@users.sourceforge.net


The patch titled
     rtc-ds1307 exports NVRAM
has been added to the -mm tree.  Its filename is
     rtc-ds1307-exports-nvram.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: rtc-ds1307 exports NVRAM
From: David Brownell <david-b@pacbell.net>

Export the NVRAM on DS1307 and DS1338 chips, like several of the
other drivers do for such combination RTC-and-NVRAM chips.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/Kconfig      |    4 -
 drivers/rtc/rtc-ds1307.c |   93 +++++++++++++++++++++++++++++++++++++
 2 files changed, 95 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/Kconfig~rtc-ds1307-exports-nvram drivers/rtc/Kconfig
--- a/drivers/rtc/Kconfig~rtc-ds1307-exports-nvram
+++ a/drivers/rtc/Kconfig
@@ -135,8 +135,8 @@ config RTC_DRV_DS1307
 
 	  The first seven registers on these chips hold an RTC, and other
 	  registers may add features such as NVRAM, a trickle charger for
-	  the RTC/NVRAM backup power, and alarms.  This driver may not
-	  expose all those available chip features.
+	  the RTC/NVRAM backup power, and alarms.  NVRAM is visible in
+	  sysfs, but other chip features may not be available.
 
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1307.
diff -puN drivers/rtc/rtc-ds1307.c~rtc-ds1307-exports-nvram drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-ds1307-exports-nvram
+++ a/drivers/rtc/rtc-ds1307.c
@@ -89,6 +89,7 @@ enum ds_type {
 
 struct ds1307 {
 	u8			reg_addr;
+	bool			has_nvram;
 	u8			regs[8];
 	enum ds_type		type;
 	struct i2c_msg		msg[2];
@@ -242,6 +243,87 @@ static const struct rtc_class_ops ds13xx
 	.set_time	= ds1307_set_time,
 };
 
+/*----------------------------------------------------------------------*/
+
+#define NVRAM_SIZE	56
+
+static ssize_t
+ds1307_nvram_read(struct kobject *kobj, struct bin_attribute *attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct i2c_client	*client;
+	struct ds1307		*ds1307;
+	struct i2c_msg		msg[2];
+	int			result;
+
+	client = to_i2c_client(container_of(kobj, struct device, kobj));
+	ds1307 = i2c_get_clientdata(client);
+
+	if (unlikely(off >= NVRAM_SIZE))
+		return 0;
+	if ((off + count) > NVRAM_SIZE)
+		count = NVRAM_SIZE - off;
+	if (unlikely(!count))
+		return count;
+
+	msg[0].addr = client->addr;
+	msg[0].flags = 0;
+	msg[0].len = 1;
+	msg[0].buf = buf;
+
+	buf[0] = 8 + off;
+
+	msg[1].addr = client->addr;
+	msg[1].flags = I2C_M_RD;
+	msg[1].len = count;
+	msg[1].buf = buf;
+
+	result = i2c_transfer(to_i2c_adapter(client->dev.parent), msg, 2);
+	if (result != 2) {
+		dev_err(&client->dev, "%s error %d\n", "nvram read", result);
+		return -EIO;
+	}
+	return count;
+}
+
+static ssize_t
+ds1307_nvram_write(struct kobject *kobj, struct bin_attribute *attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct i2c_client	*client;
+	u8			buffer[NVRAM_SIZE + 1];
+	int			ret;
+
+	client = to_i2c_client(container_of(kobj, struct device, kobj));
+
+	if (unlikely(off >= NVRAM_SIZE))
+		return -EFBIG;
+	if ((off + count) > NVRAM_SIZE)
+		count = NVRAM_SIZE - off;
+	if (unlikely(!count))
+		return count;
+
+	buffer[0] = 8 + off;
+	memcpy(buffer + 1, buf, count);
+
+	ret = i2c_master_send(client, buffer, count + 1);
+	return (ret < 0) ? ret : (ret - 1);
+}
+
+static struct bin_attribute nvram = {
+	.attr = {
+		.name	= "nvram",
+		.mode	= S_IRUGO | S_IWUSR,
+		.owner	= THIS_MODULE,
+	},
+
+	.read	= ds1307_nvram_read,
+	.write	= ds1307_nvram_write,
+	.size	= NVRAM_SIZE,
+};
+
+/*----------------------------------------------------------------------*/
+
 static struct i2c_driver ds1307_driver;
 
 static int __devinit ds1307_probe(struct i2c_client *client)
@@ -413,6 +495,14 @@ read_rtc:
 		goto exit_free;
 	}
 
+	if (chip->nvram56) {
+		err = sysfs_create_bin_file(&client->dev.kobj, &nvram);
+		if (err == 0) {
+			ds1307->has_nvram = true;
+			dev_info(&client->dev, "56 bytes nvram\n");
+		}
+	}
+
 	return 0;
 
 exit_bad:
@@ -432,6 +522,9 @@ static int __devexit ds1307_remove(struc
 {
 	struct ds1307	*ds1307 = i2c_get_clientdata(client);
 
+	if (ds1307->has_nvram)
+		sysfs_remove_bin_file(&client->dev.kobj, &nvram);
+
 	rtc_device_unregister(ds1307->rtc);
 	kfree(ds1307);
 	return 0;
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-m48t59-fix-section-mismatch-warning.patch
rtc_hctosys-expects-rtcs-in-utc-doc.patch
rtcs-handle-nvram-better.patch
rtc-ds1307-exports-nvram.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
pci-add-pci-identifiers-for-the-rdc-devices.patch
x86-add-support-for-the-rdc-r-321x-soc.patch
add-the-rdc-machine-specific-reboot-fixup.patch
rtc-release-correct-region-in-error-path.patch
rtc-fallback-to-requesting-only-the-ports-we-actually-use.patch
tle62x0-driver-stops-ignoring-read-errors.patch
rtc-convert-mutex-to-bitfield.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
remove-pointless-casts-from-void-pointers.patch
spi-at25-driver-is-for-eeprom-not-flash.patch
spi-use-mutex-not-semaphore.patch
blackfin-spi-driver-use-cpu_relax-to-replace-continue-in-while-busywait.patch
blackfin-spi-driver-use-void-__iomem-for-regs_base.patch
blackfin-spi-driver-move-hard-coded-pin_req-to-board-file.patch
blackfin-spi-driver-reconfigure-speed_hz-and-bits_per_word-in-each-spi-transfer.patch
cosmetic-fixes-to-rtc-subsystems-kconfig.patch
rtc-pcf8583-dont-abuse-i2c_m_nostart.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
