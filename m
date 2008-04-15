From: akpm@linux-foundation.org
Subject: + omap_rng-minor-updates.patch added to -mm tree
Date: Tue, 15 Apr 2008 01:07:20 -0700
Message-ID: <200804150807.m3F87KTY018288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752984AbYDOIIY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Apr 2008 04:08:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, Uwe_Zeisberger@digi.com, dbrownell@users.sourceforge.net, herbert@gondor.apana.org.au, mb@bu3sch.de


The patch titled
     omap_rng: minor updates
has been added to the -mm tree.  Its filename is
     omap_rng-minor-updates.patch

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
Subject: omap_rng: minor updates
From: David Brownell <david-b@pacbell.net>

Minor cleanups to the OMAP RNG:

 - Comment update re RNG status:
     * yes, it works on 16xx; "rngtest" is quite happy
     * it's fast enough that polling vs IRQ is a non-issue
 - Get rid of BUG_ON
 - Help GCC not be stupid about inlining (object code shrink)
 - Remove "sparse" warning
 - Cope with new hotplug rule requiring "platform:" modalias

And make the file header match kernel conventions.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Uwe Zeisberger <Uwe_Zeisberger@digi.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/omap-rng.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN drivers/char/hw_random/omap-rng.c~omap_rng-minor-updates drivers/char/hw_random/omap-rng.c
--- a/drivers/char/hw_random/omap-rng.c~omap_rng-minor-updates
+++ a/drivers/char/hw_random/omap-rng.c
@@ -1,7 +1,5 @@
 /*
- * drivers/char/hw_random/omap-rng.c
- *
- * RNG driver for TI OMAP CPU family
+ * omap-rng.c - RNG driver for TI OMAP CPU family
  *
  * Author: Deepak Saxena <dsaxena@plexity.net>
  *
@@ -15,11 +13,6 @@
  * This file is licensed under  the terms of the GNU General Public
  * License version 2. This program is licensed "as is" without any
  * warranty of any kind, whether express or implied.
- *
- * TODO:
- *
- * - Make status updated be interrupt driven so we don't poll
- *
  */
 
 #include <linux/module.h>
@@ -55,17 +48,16 @@ static void __iomem *rng_base;
 static struct clk *rng_ick;
 static struct platform_device *rng_dev;
 
-static u32 omap_rng_read_reg(int reg)
+static inline u32 omap_rng_read_reg(int reg)
 {
 	return __raw_readl(rng_base + reg);
 }
 
-static void omap_rng_write_reg(int reg, u32 val)
+static inline void omap_rng_write_reg(int reg, u32 val)
 {
 	__raw_writel(val, rng_base + reg);
 }
 
-/* REVISIT: Does the status bit really work on 16xx? */
 static int omap_rng_data_present(struct hwrng *rng, int wait)
 {
 	int data, i;
@@ -74,6 +66,11 @@ static int omap_rng_data_present(struct 
 		data = omap_rng_read_reg(RNG_STAT_REG) ? 0 : 1;
 		if (data || !wait)
 			break;
+		/* RNG produces data fast enough (2+ MBit/sec, even
+		 * during "rngtest" loads, that these delays don't
+		 * seem to trigger.  We *could* use the RNG IRQ, but
+		 * that'd be higher overhead ... so why bother?
+		 */
 		udelay(10);
 	}
 	return data;
@@ -101,7 +98,8 @@ static int __init omap_rng_probe(struct 
 	 * A bit ugly, and it will never actually happen but there can
 	 * be only one RNG and this catches any bork
 	 */
-	BUG_ON(rng_dev);
+	if (rng_dev)
+		return -EBUSY;
 
 	if (cpu_is_omap24xx()) {
 		rng_ick = clk_get(NULL, "rng_ick");
@@ -124,7 +122,7 @@ static int __init omap_rng_probe(struct 
 		return -EBUSY;
 
 	dev_set_drvdata(&pdev->dev, mem);
-	rng_base = (u32 __iomem *)io_p2v(res->start);
+	rng_base = (u32 __force __iomem *)io_p2v(res->start);
 
 	ret = hwrng_register(&omap_rng_ops);
 	if (ret) {
@@ -182,6 +180,8 @@ static int omap_rng_resume(struct platfo
 
 #endif
 
+/* work with hotplug and coldplug */
+MODULE_ALIAS("platform:omap_rng");
 
 static struct platform_driver omap_rng_driver = {
 	.driver = {
_

Patches currently in -mm which might be from david-b@pacbell.net are

git-acpi.patch
git-arm.patch
git-avr32.patch
git-input.patch
input-add-debouncing-for-generic-gpio-input-device-gpio_keyc.patch
jffs2-summary-allocation-dont-use-vmalloc.patch
fix-gregkh-usb-usb-ohci-port-reset-paranoia-timeout.patch
spi-pxa2xx_spi-sparse-fixes.patch
atmel_spi-support-zero-length-transfer.patch
rtc-avoid-legacy-drivers-with-generic-framework.patch
rtc-avoid-legacy-drivers-with-generic-framework-update.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes.patch
rtc-isl1208-new-style-conversion-and-minor-bug-fixes-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes.patch
rtc-pcf8563-new-style-conversion-checkpatch-fixes-fix.patch
rtc-x1205-new-style-conversion.patch
rtc-x1205-new-style-conversion-checkpatch-fixes.patch
rtc-silence-section-mismatch-warning-in-rtc-test.patch
make-ds1511_rtc_readset_time-static.patch
kerneldoc-for-linux-clkh.patch
kerneldoc-for-linux-clkh-fix.patch
rtc-rtc-rs5c372-fix-up-null-name-in-transfer-error-path.patch
rtc-rtc-rs5c372-smbus-conversion-support.patch
rtc-rtc-rs5c732-add-support-for-ricoh-r2025s-d-rtc.patch
rtc-replace-remaining-__function__-occurrences.patch
gpiochip_reserve-fix-2.patch
remove-duplicated-unlikely-in-is_err.patch
omap_rng-minor-updates.patch

