From: akpm@linux-foundation.org
Subject: + rtc-tps6586x-device-wakeup-flags-correction.patch added to -mm
 tree
Date: Wed, 29 May 2013 12:20:29 -0700
Message-ID: <51a654fd.tVwwq3Qz8Oncq6r2%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965341Ab3E2TUa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 29 May 2013 15:20:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ldewangan@nvidia.com, jg1.han@samsung.com, digetx@gmail.com

Subject: + rtc-tps6586x-device-wakeup-flags-correction.patch added to -mm tree
To: digetx@gmail.com,jg1.han@samsung.com,ldewangan@nvidia.com
From: akpm@linux-foundation.org
Date: Wed, 29 May 2013 12:20:29 -0700


The patch titled
     Subject: drivers/rtc/rtc-tps6586x.c: device wakeup flags correction
has been added to the -mm tree.  Its filename is
     rtc-tps6586x-device-wakeup-flags-correction.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Osipenko <digetx@gmail.com>
Subject: drivers/rtc/rtc-tps6586x.c: device wakeup flags correction

Use device_init_wakeup() instead of device_set_wakeup_capable() and move
it before rtc dev registering.  This fixes alarmtimer not registered when
tps6586x rtc is the only wakeup compatible rtc in the system.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps6586x.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-tps6586x.c~rtc-tps6586x-device-wakeup-flags-correction drivers/rtc/rtc-tps6586x.c
--- a/drivers/rtc/rtc-tps6586x.c~rtc-tps6586x-device-wakeup-flags-correction
+++ a/drivers/rtc/rtc-tps6586x.c
@@ -273,6 +273,8 @@ static int tps6586x_rtc_probe(struct pla
 		return ret;
 	}
 
+	device_init_wakeup(&pdev->dev, 1);
+
 	platform_set_drvdata(pdev, rtc);
 	rtc->rtc = devm_rtc_device_register(&pdev->dev, dev_name(&pdev->dev),
 				       &tps6586x_rtc_ops, THIS_MODULE);
@@ -292,7 +294,6 @@ static int tps6586x_rtc_probe(struct pla
 		goto fail_rtc_register;
 	}
 	disable_irq(rtc->irq);
-	device_set_wakeup_capable(&pdev->dev, 1);
 	return 0;
 
 fail_rtc_register:
_

Patches currently in -mm which might be from digetx@gmail.com are

linux-next.patch
rtc-tps6586x-device-wakeup-flags-correction.patch
drivers-rtc-rtc-tps6586xc-device-wakeup-flags-correction.patch

