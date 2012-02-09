From: akpm@linux-foundation.org
Subject: + backlight-add-support-for-pandora-backlight-v2.patch added to -mm tree
Date: Wed, 08 Feb 2012 16:17:09 -0800
Message-ID: <20120209001710.1C706A04C2@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:51722 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab2BIARM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 19:17:12 -0500
Received: by eekb15 with SMTP id b15so37303eek.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 16:17:11 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: notasas@gmail.com, rpurdie@rpsys.net


The patch titled
     Subject: backlight-add-support-for-pandora-backlight-v2
has been added to the -mm tree.  Its filename is
     backlight-add-support-for-pandora-backlight-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
Subject: Subject: backlight-add-support-for-pandora-backlight-v2

Patches currently in -mm which might be from notasas@gmail.com are

origin.patch
linux-next.patch
backlight-add-support-for-pandora-backlight.patch
backlight-add-support-for-pandora-backlight-v2.patch

