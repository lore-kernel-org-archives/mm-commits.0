From: akpm@linux-foundation.org
Subject: [merged] backlight-fix-blanking-for-lms283gf05-lcd.patch removed from -mm tree
Date: Tue, 16 Nov 2010 11:30:53 -0800
Message-ID: <201011161934.oAGJY5S5003170@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48133 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756436Ab0KPTeQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Nov 2010 14:34:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: marek.vasut@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     backlight: fix blanking for LMS283GF05 LCD
has been removed from the -mm tree.  Its filename was
     backlight-fix-blanking-for-lms283gf05-lcd.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: backlight: fix blanking for LMS283GF05 LCD
From: Marek Vasut <marek.vasut@gmail.com>

The LCD was turned on if the variable power was > 0, but that was
incorrect.  The LCD has to be turned on in NORMAL and UNBLANK case.

Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lms283gf05.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/video/backlight/lms283gf05.c~backlight-fix-blanking-for-lms283gf05-lcd drivers/video/backlight/lms283gf05.c
--- a/drivers/video/backlight/lms283gf05.c~backlight-fix-blanking-for-lms283gf05-lcd
+++ a/drivers/video/backlight/lms283gf05.c
@@ -129,7 +129,7 @@ static int lms283gf05_power_set(struct l
 	struct spi_device *spi = st->spi;
 	struct lms283gf05_pdata *pdata = spi->dev.platform_data;
 
-	if (power) {
+	if (power <= FB_BLANK_NORMAL) {
 		if (pdata)
 			lms283gf05_reset(pdata->reset_gpio,
 					pdata->reset_inverted);
_

Patches currently in -mm which might be from marek.vasut@gmail.com are

drivers-video-backlight-l4f00242t03c-full-implement-fb-power-states-for-this-lcd.patch

