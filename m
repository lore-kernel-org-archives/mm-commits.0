From: akpm@linux-foundation.org
Subject: + input-core-driver-for-wm97xx-touchscreens-update.patch added to -mm tree
Date: Wed, 05 Mar 2008 14:51:29 -0800
Message-ID: <200803052251.m25MpUD5025402@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765311AbYCEXNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 18:13:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: broonie@opensource.wolfsonmicro.com, dbaryshkov@gmail.com, gg@opensource.wolfsonmicro.com, giometti@enneenne.com, hcegtvedt@atmel.com, liam.girdwood@wolfsonmicro.com, linux01@architechnical.net, mike.arthur@wolfsonmicro.com, mkl@pengutronix.de, rmk@arm.linux.org.uk, spyro@f2s.com, stanley.cai@intel.com, vince@kyllikki.org, zap@homelink.ru


The patch titled
     Core driver for WM97xx touchscreens (update)
has been added to the -mm tree.  Its filename is
     input-core-driver-for-wm97xx-touchscreens-update.patch

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
Subject: Core driver for WM97xx touchscreens (update)
From: Mark Brown <broonie@opensource.wolfsonmicro.com>

This patch series adds support for the touchscreen controllers provided
by Wolfson Microelectronics WM97xx series chips in both polled and
streaming modes.

These drivers have been maintained out of tree since 2003.  During that
time the driver the primary maintainer was Liam Girdwood and a number of
people have made contributions including Dmitry Baryshkov, Stanley Cai,
Rodolfo Giometti, Russell King, Marc Kleine-Budde, Ian Molton, Vincent
Sanders, Andrew Zabolotny, Graeme Gregory, Mike Arthur and myself.
Apologies to anyone I have omitted.

Signed-off-by: Liam Girdwood <liam.girdwood@wolfsonmicro.com>
Signed-off-by: Graeme Gregory <gg@opensource.wolfsonmicro.com>
Signed-off-by: Mike Arthur <mike.arthur@wolfsonmicro.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: Stanley Cai <stanley.cai@intel.com>
Cc: Hans-Christian Egtvedt <hcegtvedt@atmel.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Pete MacKay <linux01@architechnical.net>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Ian Molton <spyro@f2s.com>
Cc: Vincent Sanders <vince@kyllikki.org>
Cc: Andrew Zabolotny <zap@homelink.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/wm97xx-core.c |    8 +++++---
 include/linux/wm97xx.h                  |    3 +++
 2 files changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/input/touchscreen/wm97xx-core.c~input-core-driver-for-wm97xx-touchscreens-update drivers/input/touchscreen/wm97xx-core.c
--- a/drivers/input/touchscreen/wm97xx-core.c~input-core-driver-for-wm97xx-touchscreens-update
+++ a/drivers/input/touchscreen/wm97xx-core.c
@@ -308,7 +308,7 @@ static void wm97xx_pen_irq_worker(struct
 		queue_delayed_work(wm->ts_workq, &wm->ts_reader, 1);
 	}
 
-	if (!wm->pen_is_down && wm->mach_ops && wm->mach_ops->acc_enabled)
+	if (!wm->pen_is_down && wm->mach_ops->acc_enabled)
 		wm->mach_ops->acc_pen_up(wm);
 	wm->mach_ops->irq_enable(wm, 1);
 }
@@ -353,10 +353,12 @@ static int wm97xx_init_pen_irq(struct wm
 		return -EINVAL;
 	}
 
-	/* enable PEN down on wm9712/13 */
+	/* Configure GPIO as interrupt source on WM971x */
 	if (wm->id != WM9705_ID2) {
+		BUG_ON(!wm->mach_ops->irq_gpio);
 		reg = wm97xx_reg_read(wm, AC97_MISC_AFE);
-		wm97xx_reg_write(wm, AC97_MISC_AFE, reg & 0xfffb);
+		wm97xx_reg_write(wm, AC97_MISC_AFE,
+				 reg ^ wm->mach_ops->irq_gpio);
 		reg = wm97xx_reg_read(wm, 0x5a);
 		wm97xx_reg_write(wm, 0x5a, reg & ~0x0001);
 	}
diff -puN include/linux/wm97xx.h~input-core-driver-for-wm97xx-touchscreens-update include/linux/wm97xx.h
--- a/include/linux/wm97xx.h~input-core-driver-for-wm97xx-touchscreens-update
+++ a/include/linux/wm97xx.h
@@ -252,6 +252,9 @@ struct wm97xx_mach_ops {
 	/* interrupt mask control - required for accelerated operation */
 	void (*irq_enable) (struct wm97xx *, int enable);
 
+	/* GPIO pin used for accelerated operation */
+	int irq_gpio;
+
 	/* pre and post sample - can be used to minimise any analog noise */
 	void (*pre_sample) (int);  /* function to run before sampling */
 	void (*post_sample) (int);  /* function to run after sampling */
_

Patches currently in -mm which might be from broonie@opensource.wolfsonmicro.com are

git-alsa.patch
input-core-driver-for-wm97xx-touchscreens.patch
input-core-driver-for-wm97xx-touchscreens-update.patch
input-add-chip-driver-for-wm9705-touchscreen.patch
input-add-chip-driver-for-wm9712-touchscreen.patch
input-add-chip-driver-for-wm9713-touchscreen.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone.patch
input-driver-for-wm97xx-touchscreens-in-streaming-mode-on-mainstone-update.patch
input-build-system-and-maintainers-entry-for-wm97xx-touchscreen-drivers.patch

