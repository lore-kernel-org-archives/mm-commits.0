From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-platform_lcdc-introduce-probe-callback.patch added to -mm tree
Date: Mon, 15 Apr 2013 16:07:32 -0700
Message-ID: <20130415230732.7E33631C034@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ve0-f201.google.com ([209.85.128.201]:35111 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934152Ab3DOXHe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 15 Apr 2013 19:07:34 -0400
Received: by mail-ve0-f201.google.com with SMTP id jz10so157962veb.0
        for <mm-commits@vger.kernel.org>; Mon, 15 Apr 2013 16:07:33 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: abrestic@chromium.org, FlorianSchandinat@gmx.de, dianders@chromium.org, jg1.han@samsung.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/platform_lcd.c: introduce probe callback
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-platform_lcdc-introduce-probe-callback.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Bresticker <abrestic@chromium.org>
Subject: drivers/video/backlight/platform_lcd.c: introduce probe callback

Platform LCD devices may need to do some device-specific initialization
before they can be used (regulator or GPIO setup, for example), but
currently the driver does not support any way of doing this.  This patch
adds a probe() callback to plat_lcd_data which platform LCD devices can
set to indicate that device-specific initialization is needed.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Reviewed-by: Doug Anderson <dianders@chromium.org>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/platform_lcd.c |    6 ++++++
 include/video/platform_lcd.h           |    1 +
 2 files changed, 7 insertions(+)

diff -puN drivers/video/backlight/platform_lcd.c~drivers-video-backlight-platform_lcdc-introduce-probe-callback drivers/video/backlight/platform_lcd.c
--- a/drivers/video/backlight/platform_lcd.c~drivers-video-backlight-platform_lcdc-introduce-probe-callback
+++ a/drivers/video/backlight/platform_lcd.c
@@ -86,6 +86,12 @@ static int platform_lcd_probe(struct pla
 		return -EINVAL;
 	}
 
+	if (pdata->probe) {
+		err = pdata->probe(pdata);
+		if (err)
+			return err;
+	}
+
 	plcd = devm_kzalloc(&pdev->dev, sizeof(struct platform_lcd),
 			    GFP_KERNEL);
 	if (!plcd) {
diff -puN include/video/platform_lcd.h~drivers-video-backlight-platform_lcdc-introduce-probe-callback include/video/platform_lcd.h
--- a/include/video/platform_lcd.h~drivers-video-backlight-platform_lcdc-introduce-probe-callback
+++ a/include/video/platform_lcd.h
@@ -15,6 +15,7 @@ struct plat_lcd_data;
 struct fb_info;
 
 struct plat_lcd_data {
+	int	(*probe)(struct plat_lcd_data *);
 	void	(*set_power)(struct plat_lcd_data *, unsigned int power);
 	int	(*match_fb)(struct plat_lcd_data *, struct fb_info *);
 };
_

Patches currently in -mm which might be from abrestic@chromium.org are

linux-next.patch
drivers-video-backlight-platform_lcdc-introduce-probe-callback.patch

