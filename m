From: akpm@linux-foundation.org
Subject: - correct-name-for-rtc-m41t80.patch removed from -mm tree
Date: Fri, 24 Aug 2007 13:55:53 -0700
Message-ID: <200708242055.l7OKtrBx013990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40492 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763083AbXHXVBm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 17:01:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: david-b@pacbell.net, anemo@mba.ocn.ne.jp, dbrownell@users.sourceforge.net, mm-commits@vger.kernel.org


The patch titled
     correct name for rtc-m41t80
has been removed from the -mm tree.  Its filename was
     correct-name-for-rtc-m41t80.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: correct name for rtc-m41t80
From: David Brownell <david-b@pacbell.net>

The new rtc-m41t80 driver name doesn't match its module name, which
prevents it from properly hotplugging.  Since it's new, no platforms yet
depend on that name ...  so this patch fixes the driver name to match its
module name, rather than going the other way around with a MODULE_ALIAS().

NOTE: This sort of bug is a new thing to watch out for with new-style I2C
drivers; previously I2C couldn't hotplug.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-m41t80.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-m41t80.c~correct-name-for-rtc-m41t80 drivers/rtc/rtc-m41t80.c
--- a/drivers/rtc/rtc-m41t80.c~correct-name-for-rtc-m41t80
+++ a/drivers/rtc/rtc-m41t80.c
@@ -892,7 +892,7 @@ static int m41t80_remove(struct i2c_clie
 
 static struct i2c_driver m41t80_driver = {
 	.driver = {
-		.name = "m41t80",
+		.name = "rtc-m41t80",
 	},
 	.probe = m41t80_probe,
 	.remove = m41t80_remove,
_

Patches currently in -mm which might be from david-b@pacbell.net are

origin.patch
spi-driver-hotplug-coldplug-fixes.patch
fix-typo-in-atmel_spic.patch
mips-add-gpio-support-to-the-bcm947xx-platform.patch
mips-gpio-led-driver-for-the-wgt634u-machine.patch
git-mmc.patch
git-mtd.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
clean-up-duplicate-includes-in-drivers-spi.patch
spi-driver-runtime-footprint-shrinkage.patch
rtc-periodic-irq-fix.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
add-missing-newlines-to-some-uses-of-dev_level-messages.patch
