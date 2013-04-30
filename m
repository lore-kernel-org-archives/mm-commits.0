From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-lp855x_blc-fix-compiler-warning-in-lp855x_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:51:23 -0700
Message-ID: <20130430185123.7B8935A4082@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:60517 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669Ab3D3SvY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:51:24 -0400
Received: by mail-vc0-f202.google.com with SMTP id hr11so86478vcb.1
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:51:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, jg1.han@samsung.com, milo.kim@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/lp855x_bl.c: fix compiler warning in lp855x_probe
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-lp855x_blc-fix-compiler-warning-in-lp855x_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Devendra Naga <devendra.aaru@gmail.com>
Subject: drivers/video/backlight/lp855x_bl.c: fix compiler warning in lp855x_probe

while doing with make W=1 gcc (gcc (GCC) 4.7.2 20121109 (Red Hat 4.7.2-8))

found

drivers/video/backlight/lp855x_bl.c: In function `lp855x_probe':
drivers/video/backlight/lp855x_bl.c:342:35: warning: variable `mode' set but not used [-Wunused-but-set-variable]

fixed by removing it as since its not used anywhere

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Acked-by: Milo Kim <milo.kim@ti.com>
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

origin.patch
linux-next.patch

