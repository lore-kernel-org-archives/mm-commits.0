From: akpm@linux-foundation.org
Subject: [merged] drivers-video-backlight-adp5520_blc-fix-compiler-warning-in-adp5520_show.patch removed from -mm tree
Date: Tue, 30 Apr 2013 11:52:17 -0700
Message-ID: <20130430185217.875155A425C@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ye0-f201.google.com ([209.85.213.201]:56437 "EHLO
	mail-ye0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933102Ab3D3SwS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 30 Apr 2013 14:52:18 -0400
Received: by mail-ye0-f201.google.com with SMTP id m3so86437yen.2
        for <mm-commits@vger.kernel.org>; Tue, 30 Apr 2013 11:52:18 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: devendra.aaru@gmail.com, jg1.han@samsung.com, michael.hennerich@analog.com, rpurdie@rpsys.net, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/video/backlight/adp5520_bl.c: fix compiler warning in adp5520_show()
has been removed from the -mm tree.  Its filename was
     drivers-video-backlight-adp5520_blc-fix-compiler-warning-in-adp5520_show.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

