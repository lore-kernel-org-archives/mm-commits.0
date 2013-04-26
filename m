From: akpm@linux-foundation.org
Subject: + drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave.patch added to -mm tree
Date: Fri, 26 Apr 2013 12:42:22 -0700
Message-ID: <20130426194222.76DFC5A41D5@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:50968 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3DZTmX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Apr 2013 15:42:23 -0400
Received: by mail-vb0-f74.google.com with SMTP id w16so469790vbb.1
        for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2013 12:42:23 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, greg@kroah.com, neilb@suse.de, zbr@ioremap.net


The patch titled
     Subject: drivers/w1/slaves/w1_bq27000.c: fix the error handling in w1_bq27000_add_slave()
has been added to the -mm tree.  Its filename is
     drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave.patch

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
Subject: drivers/w1/slaves/w1_bq27000.c: fix the error handling in w1_bq27000_add_slave()

Use platform_device_put() instead of platform_device_unregister() if
platform_device_add() fails, and also add the return value check of
platform_device_add_data().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_bq27000.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/w1/slaves/w1_bq27000.c~drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave drivers/w1/slaves/w1_bq27000.c
--- a/drivers/w1/slaves/w1_bq27000.c~drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave
+++ a/drivers/w1/slaves/w1_bq27000.c
@@ -57,6 +57,8 @@ static int w1_bq27000_add_slave(struct w
 	ret = platform_device_add_data(pdev,
 				       &bq27000_battery_info,
 				       sizeof(bq27000_battery_info));
+	if (ret)
+		goto pdev_add_failed;
 	pdev->dev.parent = &sl->dev;
 
 	ret = platform_device_add(pdev);
@@ -68,7 +70,7 @@ static int w1_bq27000_add_slave(struct w
 	goto success;
 
 pdev_add_failed:
-	platform_device_unregister(pdev);
+	platform_device_put(pdev);
 success:
 	return ret;
 }
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

linux-next.patch
ocfs2-fix-error-return-code-in-ocfs2_info_handle_freefrag.patch
rpmsg-fix-error-return-code-in-rpmsg_probe.patch
drivers-video-backlight-adp8860_blc-fix-error-return-code-in-adp8860_led_probe.patch
drivers-video-backlight-adp8870_blc-fix-error-return-code-in-adp8870_led_probe.patch
drivers-rtc-rtc-pcf2123c-fix-error-return-code-in-pcf2123_probe.patch
drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave.patch

