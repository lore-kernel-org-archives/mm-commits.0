From: akpm@linux-foundation.org
Subject: + correct-name-for-rtc-m41t80.patch added to -mm tree
Date: Wed, 15 Aug 2007 12:43:46 -0700
Message-ID: <200708151943.l7FJhk0o011778@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45075 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753218AbXHOToL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 15:44:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: david-b@pacbell.net, anemo@mba.ocn.ne.jp, dbrownell@users.sourceforge.net


The patch titled
     correct name for rtc-m41t80
has been added to the -mm tree.  Its filename is
     correct-name-for-rtc-m41t80.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
correct-name-for-rtc-m41t80.patch
git-mmc.patch
git-mtd.patch
dma_free_coherent-needs-irqs-enabled-sigh.patch
drivers-pmc-msp71xx-gpio-char-driver.patch
driver-for-the-atmel-on-chip-ssc-on-at32ap-and-at91.patch
clean-up-duplicate-includes-in-drivers-spi.patch
rtc-periodic-irq-fix.patch
rtc_irq_set_freq-requires-power-of-two-and-associated-kerneldoc.patch
