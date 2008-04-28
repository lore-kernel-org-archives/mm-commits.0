From: akpm@linux-foundation.org
Subject: - radeonfb-speed-up-the-i2c-buses.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:22 -0700
Message-ID: <200804282158.m3SLwM65018486@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57210 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965359AbYD1V6d (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, adaplas@pol.net, benh@kernel.crashing.org, mm-commits@vger.kernel.org


The patch titled
     radeonfb: speed up the I2C buses
has been removed from the -mm tree.  Its filename was
     radeonfb-speed-up-the-i2c-buses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
dmi-clean-up-dmi-helper-declarations.patch

