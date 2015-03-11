From: akpm@linux-foundation.org
Subject: +
 rtc-da9052-register-ability-of-alarm-to-wake-device-from-suspend.patch
 added to -mm tree
Date: Wed, 11 Mar 2015 13:55:00 -0700
Message-ID: <5500aba4.Kva6bKZNh1GdJFK4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49758 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbbCKUzB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Mar 2015 16:55:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adam.ward.opensource@diasemi.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-da9052.c: register ability of alarm to wake device from suspend
has been added to the -mm tree.  Its filename is
     rtc-da9052-register-ability-of-alarm-to-wake-device-from-suspend.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-da9052-register-ability-of-alarm-to-wake-device-from-suspend.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-da9052-register-ability-of-alarm-to-wake-device-from-suspend.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Adam Ward <adam.ward.opensource@diasemi.com>
Subject: drivers/rtc/rtc-da9052.c: register ability of alarm to wake device from suspend

Signed-off-by: Adam Ward <adam.ward.opensource@diasemi.com>
Tested-by: Adam Ward <adam.ward.opensource@diasemi.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-da9052.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/rtc/rtc-da9052.c~rtc-da9052-register-ability-of-alarm-to-wake-device-from-suspend drivers/rtc/rtc-da9052.c
--- a/drivers/rtc/rtc-da9052.c~rtc-da9052-register-ability-of-alarm-to-wake-device-from-suspend
+++ a/drivers/rtc/rtc-da9052.c
@@ -309,6 +309,8 @@ static int da9052_rtc_probe(struct platf
 		return ret;
 	}
 
+	device_init_wakeup(&pdev->dev, true);
+
 	rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				       &da9052_rtc_ops, THIS_MODULE);
 	return PTR_ERR_OR_ZERO(rtc->rtc);
_

Patches currently in -mm which might be from adam.ward.opensource@diasemi.com are

rtc-da9052-add-extra-reads-with-timeouts-to-avoid-returning-partially-updated-values.patch
rtc-da9052-add-constraints-to-set-valid-year.patch
rtc-da9052-register-ability-of-alarm-to-wake-device-from-suspend.patch

