From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-adp8860_blc-fix-error-return-code-in-adp8860_led_probe.patch added to -mm tree
Date: Mon, 25 Mar 2013 15:31:55 -0700
Message-ID: <20130325223155.723535A419C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:57992 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758655Ab3CYWb4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 25 Mar 2013 18:31:56 -0400
Received: by mail-vc0-f202.google.com with SMTP id gf12so670967vcb.3
        for <mm-commits@vger.kernel.org>; Mon, 25 Mar 2013 15:31:56 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, jg1.han@samsung.com, michael.hennerich@analog.com


The patch titled
     Subject: drivers/video/backlight/adp8860_bl.c: fix error return code in adp8860_led_probe()
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-adp8860_blc-fix-error-return-code-in-adp8860_led_probe.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: drivers/video/backlight/adp8860_bl.c: fix error return code in adp8860_led_probe()

Fix to return a negative error code from the error handling
case instead of 0, as returned elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp8860_bl.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp8860_blc-fix-error-return-code-in-adp8860_led_probe drivers/video/backlight/adp8860_bl.c
--- a/drivers/video/backlight/adp8860_bl.c~drivers-video-backlight-adp8860_blc-fix-error-return-code-in-adp8860_led_probe
+++ a/drivers/video/backlight/adp8860_bl.c
@@ -249,12 +249,14 @@ static int adp8860_led_probe(struct i2c_
 		if (led_dat->id > 7 || led_dat->id < 1) {
 			dev_err(&client->dev, "Invalid LED ID %d\n",
 				led_dat->id);
+			ret = -EINVAL;
 			goto err;
 		}
 
 		if (pdata->bl_led_assign & (1 << (led_dat->id - 1))) {
 			dev_err(&client->dev, "LED %d used by Backlight\n",
 				led_dat->id);
+			ret = -EBUSY;
 			goto err;
 		}
 
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch
rpmsg-fix-error-return-code-in-rpmsg_probe.patch
drivers-video-backlight-adp8860_blc-fix-error-return-code-in-adp8860_led_probe.patch

