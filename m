From: akpm@linux-foundation.org
Subject: + rtc-pl031-add-wake-up-support.patch added to -mm tree
Date: Tue, 15 Jan 2013 13:58:46 -0800
Message-ID: <20130115215846.89AB382004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:36752 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3AOV6r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 15 Jan 2013 16:58:47 -0500
Received: by mail-qa0-f74.google.com with SMTP id r4so93760qaq.1
        for <mm-commits@vger.kernel.org>; Tue, 15 Jan 2013 13:58:47 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rob.herring@calxeda.com, a.zummo@towertech.it, linus.walleij@linaro.org, srinidhi.kasagar@stericsson.com


The patch titled
     Subject: drivers/rtc/rtc-pl031.c: add wakeup support
has been added to the -mm tree.  Its filename is
     rtc-pl031-add-wake-up-support.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Rob Herring <rob.herring@calxeda.com>
Subject: drivers/rtc/rtc-pl031.c: add wakeup support

Mark the pl031 as wake-up capable so that rtcwake and suspend test can work.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pl031.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-pl031.c~rtc-pl031-add-wake-up-support drivers/rtc/rtc-pl031.c
--- a/drivers/rtc/rtc-pl031.c~rtc-pl031-add-wake-up-support
+++ a/drivers/rtc/rtc-pl031.c
@@ -380,6 +380,8 @@ static int pl031_probe(struct amba_devic
 		goto out_no_irq;
 	}
 
+	device_init_wakeup(&adev->dev, 1);
+
 	return 0;
 
 out_no_irq:
_

Patches currently in -mm which might be from rob.herring@calxeda.com are

origin.patch
linux-next.patch
rtc-pl031-add-wake-up-support.patch

