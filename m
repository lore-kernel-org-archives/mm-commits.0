From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-lp855x_blc-fix-compiler-warning-in-lp855x_probe.patch added to -mm tree
Date: Fri, 08 Mar 2013 13:02:20 -0800
Message-ID: <20130308210220.715CB31C00F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:36856 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3CHVCV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Mar 2013 16:02:21 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so201200yhz.5
        for <mm-commits@vger.kernel.org>; Fri, 08 Mar 2013 13:02:20 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devendra.aaru@gmail.com, jg1.han@samsung.com, milo.kim@ti.com


The patch titled
     Subject: drivers/video/backlight/lp855x_bl.c: fix compiler warning in lp855x_probe
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-lp855x_blc-fix-compiler-warning-in-lp855x_probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: drivers/video/backlight/lp855x_bl.c: fix compiler warning in lp855x_probe

while doing with make W=1 gcc (gcc (GCC) 4.7.2 20121109 (Red Hat 4.7.2-8))

found

drivers/video/backlight/lp855x_bl.c: In function `lp855x_probe':
drivers/video/backlight/lp855x_bl.c:342:35: warning: variable `mode' set but not used [-Wunused-but-set-variable]

fixed by removing it as since its not used anywhere

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/lp855x_bl.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/video/backlight/lp855x_bl.c~drivers-video-backlight-lp855x_blc-fix-compiler-warning-in-lp855x_probe drivers/video/backlight/lp855x_bl.c
--- a/drivers/video/backlight/lp855x_bl.c~drivers-video-backlight-lp855x_blc-fix-compiler-warning-in-lp855x_probe
+++ a/drivers/video/backlight/lp855x_bl.c
@@ -339,7 +339,6 @@ static int lp855x_probe(struct i2c_clien
 {
 	struct lp855x *lp;
 	struct lp855x_platform_data *pdata = cl->dev.platform_data;
-	enum lp855x_brightness_ctrl_mode mode;
 	int ret;
 
 	if (!pdata) {
@@ -354,7 +353,6 @@ static int lp855x_probe(struct i2c_clien
 	if (!lp)
 		return -ENOMEM;
 
-	mode = pdata->mode;
 	lp->client = cl;
 	lp->dev = &cl->dev;
 	lp->pdata = pdata;
_

Patches currently in -mm which might be from devendra.aaru@gmail.com are

drivers-video-backlight-lp855x_blc-fix-compiler-warning-in-lp855x_probe.patch

