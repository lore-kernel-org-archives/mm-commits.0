From: akpm@linux-foundation.org
Subject: - rtcs-handle-nvram-better.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:08:00 -0800
Message-ID: <200711152108.lAFL8002015309@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757965AbXKOVQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:16:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, a.zummo@towertech.it, anemo@mba.ocn.ne.jp, dbrownell@users.sourceforge.net, rongkai.zhan@windriver.com, thomas.hommel@gefanuc.com, tr@newtec.dk, mm-commits@vger.kernel.org


The patch titled
     RTCs: handle NVRAM better
has been removed from the -mm tree.  Its filename was
     rtcs-handle-nvram-better.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: RTCs: handle NVRAM better
From: David Brownell <david-b@pacbell.net>

Several of the RTC drivers are exporting binary "nvram" files in sysfs.  Such
NVRAM (or on many systems, EEPROM) data is often initialized during system
manufacture to hold data about identity (serial numbers, Ethernet addresses,
etc), configuration, calibration, and so forth.

This patch improves integrity and security of those files:

  - Correctly initializes the size in one of the two cases where
    that was not yet being done.

  - Improves system security/integrity by making this state not
    be world-writable by default.

Letting arbitrary userspace code mangle such state by default is at least Not
A Good Thing; and it could sometimes be worse, depending on the particular
data that might be corrupted.  (I disregard the paranoiac "don't let anyone
read it either" approach.  Anyone storing passwords in such memory doesn't
really care about security.)

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Acked-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Torsten Ertbjerg Rasmussen <tr@newtec.dk>
Cc: Mark Zhan <rongkai.zhan@windriver.com>
Cc: Thomas Hommel <thomas.hommel@gefanuc.com>
Acked-by: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-ds1553.c   |    2 +-
 drivers/rtc/rtc-ds1742.c   |    5 ++++-
 drivers/rtc/rtc-m48t59.c   |    3 ++-
 drivers/rtc/rtc-stk17ta8.c |    2 +-
 4 files changed, 8 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-ds1553.c~rtcs-handle-nvram-better drivers/rtc/rtc-ds1553.c
--- a/drivers/rtc/rtc-ds1553.c~rtcs-handle-nvram-better
+++ a/drivers/rtc/rtc-ds1553.c
@@ -291,7 +291,7 @@ static ssize_t ds1553_nvram_write(struct
 static struct bin_attribute ds1553_nvram_attr = {
 	.attr = {
 		.name = "nvram",
-		.mode = S_IRUGO | S_IWUGO,
+		.mode = S_IRUGO | S_IWUSR,
 	},
 	.size = RTC_OFFSET,
 	.read = ds1553_nvram_read,
diff -puN drivers/rtc/rtc-ds1742.c~rtcs-handle-nvram-better drivers/rtc/rtc-ds1742.c
--- a/drivers/rtc/rtc-ds1742.c~rtcs-handle-nvram-better
+++ a/drivers/rtc/rtc-ds1742.c
@@ -160,10 +160,13 @@ static ssize_t ds1742_nvram_write(struct
 static struct bin_attribute ds1742_nvram_attr = {
 	.attr = {
 		.name = "nvram",
-		.mode = S_IRUGO | S_IWUGO,
+		.mode = S_IRUGO | S_IWUSR,
 	},
 	.read = ds1742_nvram_read,
 	.write = ds1742_nvram_write,
+	/* REVISIT: size in sysfs won't match actual size... if it's
+	 * not a constant, each RTC should have its own attribute.
+	 */
 };
 
 static int __devinit ds1742_rtc_probe(struct platform_device *pdev)
diff -puN drivers/rtc/rtc-m48t59.c~rtcs-handle-nvram-better drivers/rtc/rtc-m48t59.c
--- a/drivers/rtc/rtc-m48t59.c~rtcs-handle-nvram-better
+++ a/drivers/rtc/rtc-m48t59.c
@@ -353,11 +353,12 @@ static ssize_t m48t59_nvram_write(struct
 static struct bin_attribute m48t59_nvram_attr = {
 	.attr = {
 		.name = "nvram",
-		.mode = S_IRUGO | S_IWUGO,
+		.mode = S_IRUGO | S_IWUSR,
 		.owner = THIS_MODULE,
 	},
 	.read = m48t59_nvram_read,
 	.write = m48t59_nvram_write,
+	.size = M48T59_NVRAM_SIZE,
 };
 
 static int __devinit m48t59_rtc_probe(struct platform_device *pdev)
diff -puN drivers/rtc/rtc-stk17ta8.c~rtcs-handle-nvram-better drivers/rtc/rtc-stk17ta8.c
--- a/drivers/rtc/rtc-stk17ta8.c~rtcs-handle-nvram-better
+++ a/drivers/rtc/rtc-stk17ta8.c
@@ -291,7 +291,7 @@ static ssize_t stk17ta8_nvram_write(stru
 static struct bin_attribute stk17ta8_nvram_attr = {
 	.attr = {
 		.name = "nvram",
-		.mode = S_IRUGO | S_IWUGO,
+		.mode = S_IRUGO | S_IWUSR,
 		.owner = THIS_MODULE,
 	},
 	.size = RTC_OFFSET,
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
rtc-dont-write-rtc-century-when-setting-a-wake-alarm.patch
git-mmc.patch
usb-s3c2410_udc-minor-irq-handler-cleanups.patch
usb-device-dma-support-on-omap2.patch
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
rtc-s3c-use-is_power_of_2-macro-for-simplicity.patch
rtc-cmos-exports-nvram-in-sysfs.patch
generic-gpio-gpio_chip-support.patch
generic-gpio-gpio_chip-support-fix.patch
avr32-uses-gpio_chip.patch
mcp23s08-spi-gpio-expander.patch
mcp23s08-spi-gpio-expander-checkpatch-fixes.patch
pnp-request-ioport-and-iomem-resources-used-by-active-devices.patch
