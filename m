From: akpm@linux-foundation.org
Subject: + rtc-rtc-davinci-return-correct-error-code-if-rtc_device_register-fails.patch added to -mm tree
Date: Tue, 27 Nov 2012 12:33:13 -0800
Message-ID: <20121127203314.3787D82004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:45501 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab2K0UdQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Nov 2012 15:33:16 -0500
Received: by mail-vb0-f74.google.com with SMTP id s24so1521181vbi.1
        for <mm-commits@vger.kernel.org>; Tue, 27 Nov 2012 12:33:14 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: devendra.aaru@gmail.com, a.zummo@towertech.it, miguel.aguilar@ridgerun.com


The patch titled
     Subject: rtc: rtc-davinci: return correct error code if rtc_device_register() fails
has been added to the -mm tree.  Its filename is
     rtc-rtc-davinci-return-correct-error-code-if-rtc_device_register-fails.patch

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
Subject: rtc: rtc-davinci: return correct error code if rtc_device_register() fails

rtc_device_register() returns a pointer containing error code in case
of error.  Use that in the error return.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Miguel Aguilar <miguel.aguilar@ridgerun.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-davinci.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-return-correct-error-code-if-rtc_device_register-fails drivers/rtc/rtc-davinci.c
--- a/drivers/rtc/rtc-davinci.c~rtc-rtc-davinci-return-correct-error-code-if-rtc_device_register-fails
+++ a/drivers/rtc/rtc-davinci.c
@@ -529,8 +529,9 @@ static int __init davinci_rtc_probe(stru
 	davinci_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				    &davinci_rtc_ops, THIS_MODULE);
 	if (IS_ERR(davinci_rtc->rtc)) {
-		dev_err(dev, "unable to register RTC device, err %ld\n",
-				PTR_ERR(davinci_rtc->rtc));
+		ret = PTR_ERR(davinci_rtc->rtc);
+		dev_err(dev, "unable to register RTC device, err %d\n",
+				ret);
 		goto fail3;
 	}
 
_

Patches currently in -mm which might be from devendra.aaru@gmail.com are

linux-next.patch
drivers-rtc-rtc-vt8500c-convert-to-use-devm_kzalloc.patch
rtc-rtc-davinci-return-correct-error-code-if-rtc_device_register-fails.patch
rtc-rtc-davinci-use-devm_kzalloc.patch

