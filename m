From: akpm@linux-foundation.org
Subject: + drivers-video-backlight-adp5520_blc-fix-compiler-warning-in-adp5520_show.patch added to -mm tree
Date: Tue, 12 Mar 2013 13:57:35 -0700
Message-ID: <20130312205735.752C55A41DE@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:62958 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391Ab3CLU5g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:57:36 -0400
Received: by mail-yh0-f74.google.com with SMTP id z6so35764yhz.3
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:57:36 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devendra.aaru@gmail.com, jg1.han@samsung.com, michael.hennerich@analog.com, rpurdie@rpsys.net


The patch titled
     Subject: drivers/video/backlight/adp5520_bl.c: fix compiler warning in adp5520_show()
has been added to the -mm tree.  Its filename is
     drivers-video-backlight-adp5520_blc-fix-compiler-warning-in-adp5520_show.patch

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
Subject: drivers/video/backlight/adp5520_bl.c: fix compiler warning in adp5520_show()

While compiling with make W=1 (gcc gcc (GCC) 4.7.2 20121109 (Red Hat
4.7.2-8)) found the following warning

drivers/video/backlight/adp5520_bl.c: In function `adp5520_show':
drivers/video/backlight/adp5520_bl.c:146:6: warning: variable `error' set but not used [-Wunused-but-set-variable]

fixed by checking the return value of the variable

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Acked-by: Jingoo Han <jg1.han@samsung.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/video/backlight/adp5520_bl.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff -puN drivers/video/backlight/adp5520_bl.c~drivers-video-backlight-adp5520_blc-fix-compiler-warning-in-adp5520_show drivers/video/backlight/adp5520_bl.c
--- a/drivers/video/backlight/adp5520_bl.c~drivers-video-backlight-adp5520_blc-fix-compiler-warning-in-adp5520_show
+++ a/drivers/video/backlight/adp5520_bl.c
@@ -143,13 +143,16 @@ static int adp5520_bl_setup(struct backl
 static ssize_t adp5520_show(struct device *dev, char *buf, int reg)
 {
 	struct adp5520_bl *data = dev_get_drvdata(dev);
-	int error;
+	int ret;
 	uint8_t reg_val;
 
 	mutex_lock(&data->lock);
-	error = adp5520_read(data->master, reg, &reg_val);
+	ret = adp5520_read(data->master, reg, &reg_val);
 	mutex_unlock(&data->lock);
 
+	if (ret < 0)
+		return ret;
+
 	return sprintf(buf, "%u\n", reg_val);
 }
 
_

Patches currently in -mm which might be from devendra.aaru@gmail.com are

linux-next.patch
drivers-video-console-fbcon_cwc-fix-compiler-warning-in-cw_update_attr.patch
drivers-video-backlight-lp855x_blc-fix-compiler-warning-in-lp855x_probe.patch
drivers-video-backlight-adp5520_blc-fix-compiler-warning-in-adp5520_show.patch
rtc-ds1286-fix-compiler-warning-while-doing-make-w=1.patch

