From: akpm@linux-foundation.org
Subject: + input-core-driver-for-wm97xx-touchscreens-update-fix-typo.patch added to -mm tree
Date: Wed, 05 Mar 2008 16:01:11 -0800
Message-ID: <200803060001.m2601BLn028540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757629AbYCFACo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 19:02:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hcegtvedt@atmel.com, broonie@opensource.wolfsonmicro.com


The patch titled
     wm97xx: fix logic typo when clearing GPIO function
has been added to the -mm tree.  Its filename is
     input-core-driver-for-wm97xx-touchscreens-update-fix-typo.patch

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
input-core-driver-for-wm97xx-touchscreens-update.patch
input-core-driver-for-wm97xx-touchscreens-update-fix-typo.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update.patch

