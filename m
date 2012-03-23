From: akpm@linux-foundation.org
Subject: [folded] backlight-add-support-for-pandora-backlight-v2.patch removed from -mm tree
Date: Fri, 23 Mar 2012 14:24:05 -0700
Message-ID: <20120323212405.5CF7CA0395@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:53557 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab2CWVYH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 23 Mar 2012 17:24:07 -0400
Received: by ghbz15 with SMTP id z15so565846ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 23 Mar 2012 14:24:05 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: notasas@gmail.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: backlight-add-support-for-pandora-backlight-v2
has been removed from the -mm tree.  Its filename was
     backlight-add-support-for-pandora-backlight-v2.patch

This patch was dropped because it was folded into backlight-add-support-for-pandora-backlight.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Grazvydas Ignotas <notasas@gmail.com>
Subject: backlight-add-support-for-pandora-backlight-v2

changed in v2: fixed a bug where setting brightness to 0 twice
               would actually turn the backlight on.
We had this driver in pandora tree for a couple of years now, but
while cleaning it up for mainline submission I've introduced this
bug, sorry for the noise.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/pandora_bl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN drivers/video/backlight/pandora_bl.c~backlight-add-support-for-pandora-backlight-v2 drivers/video/backlight/pandora_bl.c
--- a/drivers/video/backlight/pandora_bl.c~backlight-add-support-for-pandora-backlight-v2
+++ a/drivers/video/backlight/pandora_bl.c
@@ -52,7 +52,10 @@ static int pandora_backlight_update_stat
 	if ((unsigned int)brightness > MAX_USER_VALUE)
 		brightness = MAX_USER_VALUE;
 
-	if (brightness == 0 && !(bl->props.state & PANDORABL_WAS_OFF)) {
+	if (brightness == 0) {
+		if (bl->props.state & PANDORABL_WAS_OFF)
+			goto done;
+
 		/* first disable PWM0 output, then clock */
 		twl_i2c_read_u8(TWL4030_MODULE_INTBR, &r, TWL_INTBR_GPBR1);
 		r &= ~PWM0_ENABLE;
_

Patches currently in -mm which might be from notasas@gmail.com are

origin.patch
backlight-add-support-for-pandora-backlight.patch

