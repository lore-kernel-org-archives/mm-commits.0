From: akpm@linux-foundation.org
Subject: + power_supply-add-eeprom-dump-file-to-olpc_batterys-sysfs.patch added to -mm tree
Date: Wed, 30 Apr 2008 14:56:20 -0700
Message-ID: <200804302156.m3ULuLc1005358@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757024AbYD3V4k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 17:56:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dilinger@queued.net, cbou@mail.ru, dilinger@debian.org, dwmw2@infradead.org


The patch titled
     power_supply: add eeprom dump file to olpc_battery's sysfs
has been added to the -mm tree.  Its filename is
     power_supply-add-eeprom-dump-file-to-olpc_batterys-sysfs.patch

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
Subject: power_supply: add eeprom dump file to olpc_battery's sysfs
From: Andres Salomon <dilinger@queued.net>

This allows you to dump 0x60 bytes from the battery's EEPROM (starting at
address 0x20).  Note that it does an EC command for each byte, so it's pretty
slow.  OTOH, if you want to grab just a single byte from somewhere in the
EEPROM, you can do something like:

dd bs=1 count=1 skip=16 if=/sys/class/power_supply/olpc-battery/eeprom | od -x

Userspace battery collection/logging information needs this.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/power/olpc_battery.c |   49 +++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff -puN drivers/power/olpc_battery.c~power_supply-add-eeprom-dump-file-to-olpc_batterys-sysfs drivers/power/olpc_battery.c
--- a/drivers/power/olpc_battery.c~power_supply-add-eeprom-dump-file-to-olpc_batterys-sysfs
+++ a/drivers/power/olpc_battery.c
@@ -283,6 +283,48 @@ static enum power_supply_property olpc_b
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
 };
 
+/* EEPROM reading goes completely around the power_supply API, sadly */
+
+#define EEPROM_START	0x20
+#define EEPROM_END	0x80
+#define EEPROM_SIZE	(EEPROM_END - EEPROM_START)
+
+static ssize_t olpc_bat_eeprom_read(struct kobject *kobj,
+		struct bin_attribute *attr, char *buf, loff_t off, size_t count)
+{
+	uint8_t ec_byte;
+	int ret, end;
+
+	if (off >= EEPROM_SIZE)
+		return 0;
+	if (off + count > EEPROM_SIZE)
+		count = EEPROM_SIZE - off;
+
+	end = EEPROM_START + off + count;
+	for (ec_byte = EEPROM_START + off; ec_byte < end; ec_byte++) {
+		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1,
+				&buf[ec_byte - EEPROM_START], 1);
+		if (ret) {
+			printk(KERN_ERR "olpc-battery:  EC command "
+					"EC_BAT_EEPROM @ 0x%x failed -"
+					" %d!\n", ec_byte, ret);
+			return -EIO;
+		}
+	}
+
+	return count;
+}
+
+static struct bin_attribute olpc_bat_eeprom = {
+	.attr = {
+		.name = "eeprom",
+		.mode = S_IRUGO,
+		.owner = THIS_MODULE,
+	},
+	.size = 0,
+	.read = olpc_bat_eeprom_read,
+};
+
 /*********************************************************************
  *		Initialisation
  *********************************************************************/
@@ -336,8 +378,14 @@ static int __init olpc_bat_init(void)
 	if (ret)
 		goto battery_failed;
 
+	ret = device_create_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
+	if (ret)
+		goto eeprom_failed;
+
 	goto success;
 
+eeprom_failed:
+	power_supply_unregister(&olpc_bat);
 battery_failed:
 	power_supply_unregister(&olpc_ac);
 ac_failed:
@@ -348,6 +396,7 @@ success:
 
 static void __exit olpc_bat_exit(void)
 {
+	device_remove_bin_file(olpc_bat.dev, &olpc_bat_eeprom);
 	power_supply_unregister(&olpc_bat);
 	power_supply_unregister(&olpc_ac);
 	platform_device_unregister(bat_pdev);
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
x86-ioremap-ram-check-fix.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline.patch
x86-geode-cache-results-from-geode_has_vsa2-and-uninline-cleanup.patch
power_supply-add-eeprom-dump-file-to-olpc_batterys-sysfs.patch
power_supply-cleanup-of-the-olpc-battery-driver.patch
power_supply-bump-ec-version-check-that-we-refuse-to-run-with-in-olpc_battery.patch

