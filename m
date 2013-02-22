From: akpm@linux-foundation.org
Subject: + backlight-ams369fg06-make-power_on-call-optional.patch added to -mm tree
Date: Fri, 22 Feb 2013 13:31:37 -0800
Message-ID: <20130222213137.90C5031C194@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qe0-f73.google.com ([209.85.128.73]:44271 "EHLO
	mail-qe0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab3BVVbi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Feb 2013 16:31:38 -0500
Received: by mail-qe0-f73.google.com with SMTP id 7so109175qeb.4
        for <mm-commits@vger.kernel.org>; Fri, 22 Feb 2013 13:31:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jg1.han@samsung.com


The patch titled
     Subject: drivers/video/backlight/ams369fg06.c: make power_on() call optional
has been added to the -mm tree.  Its filename is
     backlight-ams369fg06-make-power_on-call-optional.patch

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
Subject: drivers/video/backlight/ams369fg06.c: make power_on() call optional

This patch makes power_on() call optional.  The voltage source can be
provided to some boards using ams369fg06 panel, thus in this case, power
on/off sequence is not necessary.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/ams369fg06.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff -puN drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-make-power_on-call-optional drivers/video/backlight/ams369fg06.c
--- a/drivers/video/backlight/ams369fg06.c~backlight-ams369fg06-make-power_on-call-optional
+++ a/drivers/video/backlight/ams369fg06.c
@@ -317,10 +317,7 @@ static int ams369fg06_power_on(struct am
 	pd = lcd->lcd_pd;
 	bd = lcd->bd;
 
-	if (!pd->power_on) {
-		dev_err(lcd->dev, "power_on is NULL.\n");
-		return -EINVAL;
-	} else {
+	if (pd->power_on) {
 		pd->power_on(lcd->ld, 1);
 		msleep(pd->power_on_delay);
 	}
@@ -370,7 +367,8 @@ static int ams369fg06_power_off(struct a
 
 	msleep(pd->power_off_delay);
 
-	pd->power_on(lcd->ld, 0);
+	if (pd->power_on)
+		pd->power_on(lcd->ld, 0);
 
 	return 0;
 }
_

Patches currently in -mm which might be from jg1.han@samsung.com are

origin.patch
linux-next.patch
drivers-video-backlight-ams369fg06c-convert-ams369fg06-to-dev_pm_ops.patch
backlight-ams369fg06-make-power_on-call-optional.patch
rtc-rtc-palmas-use-devm_request_threaded_irq.patch

