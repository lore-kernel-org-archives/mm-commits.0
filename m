From: akpm@linux-foundation.org
Subject: [merged] input-add-btn_touch-event.patch removed from -mm tree
Date: Thu, 05 Mar 2009 11:56:10 -0800
Message-ID: <200903051956.n25JuANa027219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52849 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754862AbZCET41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 5 Mar 2009 14:56:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike@compulab.co.il, broonie@opensource.wolfsonmicro.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: add BTN_TOUCH event
has been removed from the -mm tree.  Its filename was
     input-add-btn_touch-event.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: input: add BTN_TOUCH event
From: Mike Rapoport <mike@compulab.co.il>

Add BTN_TOUCH event reporting to ucb1400_ts and accelerated
mainstone-wm97xx touchscreen drivers.  Together with previously posted
similar patch for wm97xx-core this will make all touchscreen drivers
behave consistently wrt.  BTN_TOUCH.

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/touchscreen/mainstone-wm97xx.c |    1 +
 drivers/input/touchscreen/ucb1400_ts.c       |    5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff -puN drivers/input/touchscreen/mainstone-wm97xx.c~input-add-btn_touch-event drivers/input/touchscreen/mainstone-wm97xx.c
--- a/drivers/input/touchscreen/mainstone-wm97xx.c~input-add-btn_touch-event
+++ a/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -162,6 +162,7 @@ static int wm97xx_acc_pen_down(struct wm
 		input_report_abs(wm->input_dev, ABS_X, x & 0xfff);
 		input_report_abs(wm->input_dev, ABS_Y, y & 0xfff);
 		input_report_abs(wm->input_dev, ABS_PRESSURE, p & 0xfff);
+		input_report_key(wm->input_dev, BTN_TOUCH, (p != 0));
 		input_sync(wm->input_dev);
 		reads++;
 	} while (reads < cinfo[sp_idx].reads);
diff -puN drivers/input/touchscreen/ucb1400_ts.c~input-add-btn_touch-event drivers/input/touchscreen/ucb1400_ts.c
--- a/drivers/input/touchscreen/ucb1400_ts.c~input-add-btn_touch-event
+++ a/drivers/input/touchscreen/ucb1400_ts.c
@@ -151,12 +151,14 @@ static void ucb1400_ts_evt_add(struct in
 	input_report_abs(idev, ABS_X, x);
 	input_report_abs(idev, ABS_Y, y);
 	input_report_abs(idev, ABS_PRESSURE, pressure);
+	input_report_key(idev, BTN_TOUCH, 1);
 	input_sync(idev);
 }
 
 static void ucb1400_ts_event_release(struct input_dev *idev)
 {
 	input_report_abs(idev, ABS_PRESSURE, 0);
+	input_report_key(idev, BTN_TOUCH, 0);
 	input_sync(idev);
 }
 
@@ -377,7 +379,8 @@ static int ucb1400_ts_probe(struct platf
 	ucb->ts_idev->id.product	= ucb->id;
 	ucb->ts_idev->open		= ucb1400_ts_open;
 	ucb->ts_idev->close		= ucb1400_ts_close;
-	ucb->ts_idev->evbit[0]		= BIT_MASK(EV_ABS);
+	ucb->ts_idev->evbit[0]		= BIT_MASK(EV_ABS) | BIT_MASK(EV_KEY);
+	ucb->ts_idev->keybit[BIT_WORD(BTN_TOUCH)] = BIT_MASK(BTN_TOUCH);
 
 	ucb1400_adc_enable(ucb->ac97);
 	x_res = ucb1400_ts_read_xres(ucb);
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

