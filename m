From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-pcf2123c-fix-error-return-code-in-pcf2123_probe.patch added to -mm tree
Date: Thu, 25 Apr 2013 13:57:42 -0700
Message-ID: <20130425205742.6FF3031C1BD@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:34168 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab3DYU5n (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 25 Apr 2013 16:57:43 -0400
Received: by mail-gg0-f202.google.com with SMTP id 4so367466ggm.3
        for <mm-commits@vger.kernel.org>; Thu, 25 Apr 2013 13:57:42 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, jg1.han@samsung.com


The patch titled
     Subject: drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-pcf2123c-fix-error-return-code-in-pcf2123_probe.patch

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
Subject: drivers/rtc/rtc-pcf2123.c: fix error return code in pcf2123_probe()

Fix to return -ENODEV in the chip not found error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2123.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/rtc/rtc-pcf2123.c~drivers-rtc-rtc-pcf2123c-fix-error-return-code-in-pcf2123_probe drivers/rtc/rtc-pcf2123.c
--- a/drivers/rtc/rtc-pcf2123.c~drivers-rtc-rtc-pcf2123c-fix-error-return-code-in-pcf2123_probe
+++ a/drivers/rtc/rtc-pcf2123.c
@@ -266,6 +266,7 @@ static int pcf2123_probe(struct spi_devi
 
 	if (!(rxbuf[0] & 0x20)) {
 		dev_err(&spi->dev, "chip not found\n");
+		ret = -ENODEV;
 		goto kfree_exit;
 	}
 
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

linux-next.patch
ocfs2-fix-error-return-code-in-ocfs2_info_handle_freefrag.patch
rpmsg-fix-error-return-code-in-rpmsg_probe.patch
drivers-video-backlight-adp8860_blc-fix-error-return-code-in-adp8860_led_probe.patch
drivers-video-backlight-adp8870_blc-fix-error-return-code-in-adp8870_led_probe.patch
drivers-rtc-rtc-pcf2123c-fix-error-return-code-in-pcf2123_probe.patch

