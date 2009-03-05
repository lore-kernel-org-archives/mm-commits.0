From: akpm@linux-foundation.org
Subject: [merged] input-wm97xx-add-btn_touch-event-to-wm97xx-to-use-it-with-android.patch removed from -mm tree
Date: Thu, 05 Mar 2009 11:56:06 -0800
Message-ID: <200903051956.n25Ju6Vi027216@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754756AbZCET4Y (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 14:56:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, broonie@opensource.wolfsonmicro.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: wm97xx: add BTN_TOUCH event to wm97xx to use it with Android
has been removed from the -mm tree.  Its filename was
     input-wm97xx-add-btn_touch-event-to-wm97xx-to-use-it-with-android.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: wm97xx: add BTN_TOUCH event to wm97xx to use it with Android
From: Mike Rapoport <mike@compulab.co.il>

Android expects BTN_TOUCH events when pen state changes.  Add BTN_TOUCH
event reporting to allow use of wm97xx touchscreen controller wiht Android
devices.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/wm97xx-core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/input/touchscreen/wm97xx-core.c~input-wm97xx-add-btn_touch-event-to-wm97xx-to-use-it-with-android drivers/input/touchscreen/wm97xx-core.c
--- a/drivers/input/touchscreen/wm97xx-core.c~input-wm97xx-add-btn_touch-event-to-wm97xx-to-use-it-with-android
+++ a/drivers/input/touchscreen/wm97xx-core.c
@@ -409,6 +409,7 @@ static int wm97xx_read_samples(struct wm
 			wm->pen_is_down = 0;
 			dev_dbg(wm->dev, "pen up\n");
 			input_report_abs(wm->input_dev, ABS_PRESSURE, 0);
+			input_report_key(wm->input_dev, BTN_TOUCH, 0);
 			input_sync(wm->input_dev);
 		} else if (!(rc & RC_AGAIN)) {
 			/* We need high frequency updates only while
@@ -433,6 +434,7 @@ static int wm97xx_read_samples(struct wm
 		input_report_abs(wm->input_dev, ABS_X, data.x & 0xfff);
 		input_report_abs(wm->input_dev, ABS_Y, data.y & 0xfff);
 		input_report_abs(wm->input_dev, ABS_PRESSURE, data.p & 0xfff);
+		input_report_key(wm->input_dev, BTN_TOUCH, 1);
 		input_sync(wm->input_dev);
 		wm->pen_is_down = 1;
 		wm->ts_reader_interval = wm->ts_reader_min_interval;
@@ -629,9 +631,11 @@ static int wm97xx_probe(struct device *d
 	wm->input_dev->open = wm97xx_ts_input_open;
 	wm->input_dev->close = wm97xx_ts_input_close;
 	set_bit(EV_ABS, wm->input_dev->evbit);
+	set_bit(EV_KEY, wm->input_dev->evbit);
 	set_bit(ABS_X, wm->input_dev->absbit);
 	set_bit(ABS_Y, wm->input_dev->absbit);
 	set_bit(ABS_PRESSURE, wm->input_dev->absbit);
+	set_bit(BTN_TOUCH, wm->input_dev->keybit);
 	input_set_abs_params(wm->input_dev, ABS_X, abs_x[0], abs_x[1],
 			     abs_x[2], 0);
 	input_set_abs_params(wm->input_dev, ABS_Y, abs_y[0], abs_y[1],
_

Patches currently in -mm which might be from mike@compulab.co.il are

linux-next.patch
spi_bfin5xx-remove-unused-is_dma_aligned-macro.patch
spi-add-dma_alignment-field-to-spi_master.patch
pxa2xx_spi-set-spi_masterdma_alignment-=-8.patch
spi_imx-set-spi_masterdma_alignment-=-4.patch
rtc-v3020-coding-style-cleanup.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios.patch
rtc-v3020-add-ability-to-access-v3020-chip-with-gpios-fix.patch

