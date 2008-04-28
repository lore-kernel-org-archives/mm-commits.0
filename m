From: akpm@linux-foundation.org
Subject: - savagefb-speed-up-the-i2c-bus.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:28 -0700
Message-ID: <200804282158.m3SLwSe6018495@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965372AbYD1V6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: khali@linux-fr.org, adaplas@pol.net, mm-commits@vger.kernel.org


The patch titled
     savagefb: speed up the I2C bus
has been removed from the -mm tree.  Its filename was
     savagefb-speed-up-the-i2c-bus.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: savagefb: speed up the I2C bus
From: Jean Delvare <khali@linux-fr.org>

There is no reason to drive the savagefb I2C bus at such a low speed, so bump
it from 12.5 kbps to 50 kbps.  The Intel (i810) and Matrox framebuffer drivers
already run their I2C bus at this speed, and so are the legacy i2c-savage4 and
i2c-prosavage drivers.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/savage/savagefb-i2c.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/savage/savagefb-i2c.c~savagefb-speed-up-the-i2c-bus drivers/video/savage/savagefb-i2c.c
--- a/drivers/video/savage/savagefb-i2c.c~savagefb-speed-up-the-i2c-bus
+++ a/drivers/video/savage/savagefb-i2c.c
@@ -140,7 +140,7 @@ static int savage_setup_i2c_bus(struct s
 		chan->adapter.id		= I2C_HW_B_SAVAGE;
 		chan->adapter.algo_data		= &chan->algo;
 		chan->adapter.dev.parent	= &chan->par->pcidev->dev;
-		chan->algo.udelay		= 40;
+		chan->algo.udelay		= 10;
 		chan->algo.timeout		= 20;
 		chan->algo.data 		= chan;
 
_

Patches currently in -mm which might be from khali@linux-fr.org are

origin.patch
mm-only-enforce-acpi-resource-conflict-checks.patch
i2c-renesas-highlander-fpga-smbus-support.patch
git-hwmon.patch
dmi-clean-up-dmi-helper-declarations.patch

