From: akpm@linux-foundation.org
Subject: + drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave.patch added to -mm tree
Date: Fri, 26 Apr 2013 14:29:47 -0700
Message-ID: <20130426212947.D53CA5A4016@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:57825 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3DZV3u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 26 Apr 2013 17:29:50 -0400
Received: by mail-gh0-f201.google.com with SMTP id r13so164475ghr.0
        for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2013 14:29:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, greg@kroah.com, neilb@suse.de, zbr@ioremap.net


The patch titled
     Subject: drivers/w1/slaves/w1_ds2781.c: fix the error handling in w1_ds2781_add_slave()
has been added to the -mm tree.  Its filename is
     drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave.patch

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
Subject: drivers/w1/slaves/w1_ds2781.c: fix the error handling in w1_ds2781_add_slave()

Use platform_device_put() instead of platform_device_unregister() if
platform_device_add() fail, and platform_device_del() should be used in
the error handling case after platform_device_add() success.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Greg KH <greg@kroah.com>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/slaves/w1_ds2781.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/w1/slaves/w1_ds2781.c~drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave drivers/w1/slaves/w1_ds2781.c
--- a/drivers/w1/slaves/w1_ds2781.c~drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave
+++ a/drivers/w1/slaves/w1_ds2781.c
@@ -139,8 +139,9 @@ static int w1_ds2781_add_slave(struct w1
 	return 0;
 
 bin_attr_failed:
+	platform_device_del(pdev);
 pdev_add_failed:
-	platform_device_unregister(pdev);
+	platform_device_put(pdev);
 pdev_alloc_failed:
 	ida_simple_remove(&bat_ida, id);
 noid:
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

linux-next.patch
ocfs2-fix-error-return-code-in-ocfs2_info_handle_freefrag.patch
rpmsg-fix-error-return-code-in-rpmsg_probe.patch
drivers-video-backlight-adp8860_blc-fix-error-return-code-in-adp8860_led_probe.patch
drivers-video-backlight-adp8870_blc-fix-error-return-code-in-adp8870_led_probe.patch
drivers-rtc-rtc-pcf2123c-fix-error-return-code-in-pcf2123_probe.patch
drivers-w1-slaves-w1_bq27000c-fix-the-error-handling-in-w1_bq27000_add_slave.patch
drivers-w1-slaves-w1_ds2780c-fix-the-error-handling-in-w1_ds2780_add_slave.patch
drivers-w1-slaves-w1_ds2781c-fix-the-error-handling-in-w1_ds2781_add_slave.patch
drivers-w1-slaves-w1_ds2760c-fix-the-error-handling-in-w1_ds2760_add_slave.patch

