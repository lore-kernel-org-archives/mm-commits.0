From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-adp8860_blc-fix-error-return-code-in-adp8860_led_probe.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:29 -0700
Message-ID: <20130430185229.7631231C22F@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:47787 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab3D3Swa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:30 -0400
Received: by mail-vb0-f73.google.com with SMTP id p12so86413vbe.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:30 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, jg1.han@samsung.com, michael.hennerich@analog.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/adp8860_bl.c: fix error return code in adp8860_led_probe()
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-adp8860_blc-fix-error-return-code-in-adp8860_led_probe.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave.patch
drivers-w1-slaves-w1_ds2780c-fix-the-error-handling-in-w1_ds2780_add_slave.patch
drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave.patch
drivers-w1-slaves-w1_ds2760c-fix-the-error-handling-in-w1_ds2760_add_slave.patch

