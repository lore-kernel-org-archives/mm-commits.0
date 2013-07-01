From: akpm@linux-foundation.org
Subject: +
 drivers-rtc-rtc-palmasc-init-wakeup-before-device-register.patch added to
 -mm tree
Date: Mon, 01 Jul 2013 15:55:24 -0700
Message-ID: <51d208dc.+n9MWiM+v0WXKHep%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3GAWzZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Jul 2013 18:55:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ldewangan@nvidia.com, wni@nvidia.com

Subject: + drivers-rtc-rtc-palmasc-init-wakeup-before-device-register.patch added to -mm tree
To: wni@nvidia.com,ldewangan@nvidia.com
From: akpm@linux-foundation.org
Date: Mon, 01 Jul 2013 15:55:24 -0700


The patch titled
     Subject: drivers/rtc/rtc-palmas.c: init wakeup before device register
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-palmasc-init-wakeup-before-device-register.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-palmasc-init-wakeup-before-device-register.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-palmasc-init-wakeup-before-device-register.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Ni <wni@nvidia.com>
Subject: drivers/rtc/rtc-palmas.c: init wakeup before device register

Enable dev as wakeup device before calling rtc_device_register(), so that
it can create the "wakealarm" sysfs.

Signed-off-by: Wei Ni <wni@nvidia.com>
Acked-by: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-palmas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/rtc/rtc-palmas.c~drivers-rtc-rtc-palmasc-init-wakeup-before-device-register drivers/rtc/rtc-palmas.c
--- a/drivers/rtc/rtc-palmas.c~drivers-rtc-rtc-palmasc-init-wakeup-before-device-register
+++ a/drivers/rtc/rtc-palmas.c
@@ -265,6 +265,7 @@ static int palmas_rtc_probe(struct platf
 
 	palmas_rtc->irq = platform_get_irq(pdev, 0);
 
+	device_init_wakeup(&pdev->dev, 1);
 	palmas_rtc->rtc = devm_rtc_device_register(&pdev->dev, pdev->name,
 				&palmas_rtc_ops, THIS_MODULE);
 	if (IS_ERR(palmas_rtc->rtc)) {
@@ -283,7 +284,6 @@ static int palmas_rtc_probe(struct platf
 		return ret;
 	}
 
-	device_set_wakeup_capable(&pdev->dev, 1);
 	return 0;
 }
 
_

Patches currently in -mm which might be from wni@nvidia.com are

drivers-rtc-rtc-palmasc-init-wakeup-before-device-register.patch

