From: akpm@linux-foundation.org
Subject: + backlight-lm3639-dont-mix-different-enum-types.patch added to
 -mm tree
Date: Wed, 18 Sep 2013 15:41:27 -0700
Message-ID: <523a2c17.B2Qw0wXfxdqLZApD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3IRWl2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 18:41:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, jg1.han@samsung.com

Subject: + backlight-lm3639-dont-mix-different-enum-types.patch added to -mm tree
To: jg1.han@samsung.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 15:41:27 -0700


The patch titled
     Subject: backlight: lm3639: Don't mix different enum types
has been added to the -mm tree.  Its filename is
     backlight-lm3639-dont-mix-different-enum-types.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/backlight-lm3639-dont-mix-different-enum-types.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/backlight-lm3639-dont-mix-different-enum-types.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jingoo Han <jg1.han@samsung.com>
Subject: backlight: lm3639: Don't mix different enum types

Don't mix different enum types to fix the sparse warnings.

drivers/video/backlight/lm3639_bl.c:80:51: warning: mixing different enum types
drivers/video/backlight/lm3639_bl.c:80:51:     int enum lm3639_fleds  versus
drivers/video/backlight/lm3639_bl.c:80:51:     int enum lm3639_bleds
drivers/video/backlight/lm3639_bl.c:82:51: warning: mixing different enum types
drivers/video/backlight/lm3639_bl.c:82:51:     int enum lm3639_fleds  versus
drivers/video/backlight/lm3639_bl.c:82:51:     int enum lm3639_bleds

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lm3639_bl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN drivers/video/backlight/lm3639_bl.c~backlight-lm3639-dont-mix-different-enum-types drivers/video/backlight/lm3639_bl.c
--- a/drivers/video/backlight/lm3639_bl.c~backlight-lm3639-dont-mix-different-enum-types
+++ a/drivers/video/backlight/lm3639_bl.c
@@ -76,10 +76,13 @@ static int lm3639_chip_init(struct lm363
 		goto out;
 
 	/* output pins config. */
-	if (!pdata->init_brt_led)
-		reg_val = pdata->fled_pins | pdata->bled_pins;
-	else
-		reg_val = pdata->fled_pins | pdata->bled_pins | 0x01;
+	if (!pdata->init_brt_led) {
+		reg_val = pdata->fled_pins;
+		reg_val |= pdata->bled_pins;
+	} else {
+		reg_val = pdata->fled_pins;
+		reg_val |= pdata->bled_pins | 0x01;
+	}
 
 	ret = regmap_update_bits(pchip->regmap, REG_ENABLE, 0x79, reg_val);
 	if (ret < 0)
_

Patches currently in -mm which might be from jg1.han@samsung.com are

linux-next.patch
backlight-lp855x_bl-support-new-lp8555-device.patch
backlight-lm3630-apply-chip-revision.patch
backlight-ld9040-staticize-local-variable-gamma_table.patch
backlight-lm3639-dont-mix-different-enum-types.patch
backlight-lp8788-staticize-default_bl_config.patch
backlight-use-dev_get_platdata.patch
w1-w1-gpio-use-dev_get_platdata.patch
w1-ds1wm-use-dev_get_platdata.patch

