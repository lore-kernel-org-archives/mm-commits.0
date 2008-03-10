From: akpm@linux-foundation.org
Subject: - input-core-driver-for-wm97xx-touchscreens-update-fix-typo.patch removed from -mm tree
Date: Mon, 10 Mar 2008 03:06:25 -0700
Message-ID: <200803101006.m2AA6PxH011183@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36931 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbYCJKHH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 06:07:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hcegtvedt@atmel.com, broonie@opensource.wolfsonmicro.com, mm-commits@vger.kernel.org


The patch titled
     wm97xx: fix logic typo when clearing GPIO function
has been removed from the -mm tree.  Its filename was
     input-core-driver-for-wm97xx-touchscreens-update-fix-typo.patch

This patch was dropped because it was folded into input-core-driver-for-wm97xx-touchscreens.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: wm97xx: fix logic typo when clearing GPIO function
From: Hans-Christian Egtvedt <hcegtvedt@atmel.com>

Fix a typo when the core part of the wm97xx touch driver tries to clear the
GPIO functionality for a GPIO line.

Signed-off-by: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/wm97xx-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/wm97xx-core.c~input-core-driver-for-wm97xx-touchscreens-update-fix-typo drivers/input/touchscreen/wm97xx-core.c
--- a/drivers/input/touchscreen/wm97xx-core.c~input-core-driver-for-wm97xx-touchscreens-update-fix-typo
+++ a/drivers/input/touchscreen/wm97xx-core.c
@@ -358,7 +358,7 @@ static int wm97xx_init_pen_irq(struct wm
 		BUG_ON(!wm->mach_ops->irq_gpio);
 		reg = wm97xx_reg_read(wm, AC97_MISC_AFE);
 		wm97xx_reg_write(wm, AC97_MISC_AFE,
-				 reg ^ wm->mach_ops->irq_gpio);
+				reg & ~(wm->mach_ops->irq_gpio));
 		reg = wm97xx_reg_read(wm, 0x5a);
 		wm97xx_reg_write(wm, 0x5a, reg & ~0x0001);
 	}
_

Patches currently in -mm which might be from hcegtvedt@atmel.com are

git-alsa.patch
git-avr32.patch
input-core-driver-for-wm97xx-touchscreens.patch
input-core-driver-for-wm97xx-touchscreens-update-fix-typo.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update.patch
ps-2-serio-driver-for-avr32-devices.patch
ps-2-serio-driver-for-avr32-devices-fix.patch
at73c213-fix-error-checking-for-clk-api.patch
at73c213-monaural-support.patch

