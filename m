From: akpm@linux-foundation.org
Subject: + radeonfb-speed-up-the-i2c-buses.patch added to -mm tree
Date: Wed, 05 Mar 2008 23:05:42 -0800
Message-ID: <200803060705.m2675gpj013930@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53099 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758028AbYCFHFy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 6 Mar 2008 02:05:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: khali@linux-fr.org, adaplas@pol.net, benh@kernel.crashing.org


The patch titled
     radeonfb: speed up the I2C buses
has been added to the -mm tree.  Its filename is
     radeonfb-speed-up-the-i2c-buses.patch

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
Subject: radeonfb: speed up the I2C buses
From: Jean Delvare <khali@linux-fr.org>

There is no reason to drive the radeon I2C buses at such a low speed, so bump
it from 12.5 kbps to 50 kbps.  The Intel (i810) and Matrox framebuffer drivers
already run their I2C bus at this speed.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/aty/radeon_i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/aty/radeon_i2c.c~radeonfb-speed-up-the-i2c-buses drivers/video/aty/radeon_i2c.c
--- a/drivers/video/aty/radeon_i2c.c~radeonfb-speed-up-the-i2c-buses
+++ a/drivers/video/aty/radeon_i2c.c
@@ -78,7 +78,7 @@ static int radeon_setup_i2c_bus(struct r
 	chan->algo.setscl		= radeon_gpio_setscl;
 	chan->algo.getsda		= radeon_gpio_getsda;
 	chan->algo.getscl		= radeon_gpio_getscl;
-	chan->algo.udelay		= 40;
+	chan->algo.udelay		= 10;
 	chan->algo.timeout		= 20;
 	chan->algo.data 		= chan;	
 	
_

Patches currently in -mm which might be from khali@linux-fr.org are

mm-only-enforce-acpi-resource-conflict-checks.patch
oz99x-i2c-button-and-led-support-driver.patch
git-hwmon.patch
git-hid.patch
dmi-clean-up-dmi-helper-declarations.patch
radeonfb-fix-debug-option.patch
radeonfb-drop-redundant-rtrace-macro.patch
radeonfb-speed-up-the-i2c-buses.patch

