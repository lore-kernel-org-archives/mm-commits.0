From: akpm@linux-foundation.org
Subject: [merged]
 rtc-da9052-register-ability-of-alarm-to-wake-device-from-suspend.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:17:54 -0700
Message-ID: <553550e2.fFYctVdyYaCgSZ3R%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40192 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848AbbDTTLd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:11:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adam.ward.opensource@diasemi.com, a.zummo@towertech.it, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-da9052.c: register ability of alarm to wake device from suspend
has been removed from the -mm tree.  Its filename was
     rtc-da9052-register-ability-of-alarm-to-wake-device-from-suspend.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

