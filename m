From: akpm@linux-foundation.org
Subject: [folded-merged] fb-backlight-add-the-himax-hx-8357b-lcd-controller-change-parameters-of-the-write-function-to-u8.patch removed from -mm tree
Date: Thu, 21 Feb 2013 15:21:55 -0800
Message-ID: <20130221232155.DC5055A4174@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f74.google.com ([209.85.128.74]:56291 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595Ab3BUXV6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 21 Feb 2013 18:21:58 -0500
Received: by mail-qe0-f74.google.com with SMTP id a11so10926qen.1
        for <mm-commits@vger.kernel.org>; Thu, 21 Feb 2013 15:21:56 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maxime.ripard@free-electrons.com, FlorianSchandinat@gmx.de, jg1.han@samsung.com, joe@perches.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: fb: hx8357: Change parameters of the write function to u8
has been removed from the -mm tree.  Its filename was
     fb-backlight-add-the-himax-hx-8357b-lcd-controller-change-parameters-of-the-write-function-to-u8.patch

This patch was dropped because it was folded into fb-backlight-add-the-himax-hx-8357b-lcd-controller.patch

------------------------------------------------------
From: Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: fb: hx8357: Change parameters of the write function to u8

Moving from void* to u8* removes the need for castslater on in the
function.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/hx8357.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/video/backlight/hx8357.c~fb-backlight-add-the-himax-hx-8357b-lcd-controller-change-parameters-of-the-write-function-to-u8 drivers/video/backlight/hx8357.c
--- a/drivers/video/backlight/hx8357.c~fb-backlight-add-the-himax-hx-8357b-lcd-controller-change-parameters-of-the-write-function-to-u8
+++ a/drivers/video/backlight/hx8357.c
@@ -79,8 +79,8 @@ struct hx8357_data {
 };
 
 static int hx8357_spi_write_then_read(struct lcd_device *lcdev,
-				void *txbuf, u16 txlen,
-				void *rxbuf, u16 rxlen)
+				u8 *txbuf, u16 txlen,
+				u8 *rxbuf, u16 rxlen)
 {
 	struct hx8357_data *lcd = lcd_get_data(lcdev);
 	struct spi_message msg;
@@ -102,7 +102,7 @@ static int hx8357_spi_write_then_read(st
 		}
 
 		for (i = 0; i < txlen; i++) {
-			local_txbuf[i] = ((u8 *)txbuf)[i];
+			local_txbuf[i] = txbuf[i];
 			if (i > 0)
 				local_txbuf[i] |= 1 << 8;
 		}
_

Patches currently in -mm which might be from maxime.ripard@free-electrons.com are

origin.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-fix-inverted-parameters-for-kcalloc.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-useless-error-message.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-remove-trailing-period.patch
fb-backlight-add-the-himax-hx-8357b-lcd-controller-use-static-arrays-for-lcd-configuration.patch

