From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-tps65910c-fix-invalid-pointer-access-on-_remove.patch added to -mm tree
Date: Wed, 28 Nov 2012 18:14:01 -0800
Message-ID: <20121129021401.AC0A6100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:59517 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab2K2COE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 28 Nov 2012 21:14:04 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so602405ggn.1
        for <mm-commits@vger.kernel.org>; Wed, 28 Nov 2012 18:14:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Milo.Kim@ti.com, milo.kim@ti.com, stable@vger.kernel.org


The patch titled
     Subject: drivers/rtc/rtc-tps65910.c: fix invalid pointer access on _remove()
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-tps65910c-fix-invalid-pointer-access-on-_remove.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kim, Milo" <Milo.Kim@ti.com>
Subject: drivers/rtc/rtc-tps65910.c: fix invalid pointer access on _remove()

The tps65910_rtc data is registered as the platform driver data in
_probe(= ).  Therefore the tps65910_rtc should be used on unregistering
the rtc device.  And device pointer should be retrieved from the
platform_device structure.

This patch fixes the below oops:

 Unable to handle kernel NULL pointer dereference at virtual address 000000=
08
 Modules linked in: rtc_tps65910(-)
 CPU: 0    Not tainted  (3.7.0-rc7-next-20121128-g6b1f974-dirty #7)
 PC is at tps65910_rtc_alarm_irq_enable+0x20/0x2c [rtc_tps65910]
 LR is at tps65910_rtc_alarm_irq_enable+0x10/0x2c [rtc_tps65910]
 [<bf000044>] (tps65910_rtc_alarm_irq_enable+0x20/0x2c [rtc_tps65910]) from
   [<bf0004d4>] (tps65910_rtc_remove+0x18/0x28 [rtc_)
 [<bf0004d4>] (tps65910_rtc_remove+0x18/0x28 [rtc_tps65910]) from
   [<c034e700>] (platform_drv_remove+0x18/0x1c)
 [<c034e700>] (platform_drv_remove+0x18/0x1c) from
   [<c034ceec>] (__device_release_driver+0x70/0xcc)
 [<c034ceec>] (__device_release_driver+0x70/0xcc) from
   [<c034d608>] (driver_detach+0xb4/0xb8)
 [<c034d608>] (driver_detach+0xb4/0xb8) from
   [<c034cc24>] (bus_remove_driver+0x7c/0xc0)
 [<c034cc24>] (bus_remove_driver+0x7c/0xc0) from
   [<c00a045c>] (sys_delete_module+0x148/0x21c)
 [<c00a045c>] (sys_delete_module+0x148/0x21c) from
   [<c0013c60>] (ret_fast_syscall+0x0/0x3c)

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-tps65910.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-fix-invalid-pointer-access-on-_remove drivers/rtc/rtc-tps65910.c
--- a/drivers/rtc/rtc-tps65910.c~drivers-rtc-rtc-tps65910c-fix-invalid-pointer-access-on-_remove
+++ a/drivers/rtc/rtc-tps65910.c
@@ -288,11 +288,11 @@ static int __devinit tps65910_rtc_probe(
 static int __devexit tps65910_rtc_remove(struct platform_device *pdev)
 {
 	/* leave rtc running, but disable irqs */
-	struct rtc_device *rtc = platform_get_drvdata(pdev);
+	struct tps65910_rtc *tps_rtc = platform_get_drvdata(pdev);
 
-	tps65910_rtc_alarm_irq_enable(&rtc->dev, 0);
+	tps65910_rtc_alarm_irq_enable(&pdev->dev, 0);
 
-	rtc_device_unregister(rtc);
+	rtc_device_unregister(tps_rtc->rtc);
 	return 0;
 }
 
_

Patches currently in -mm which might be from Milo.Kim@ti.com are

linux-next.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions.patch
drivers-video-backlight-lp855x_blc-use-generic-pwm-functions-fix.patch
drivers-video-backlight-lp855x_blc-remove-unnecessary-mutex-code.patch
drivers-rtc-rtc-tps65910c-fix-invalid-pointer-access-on-_remove.patch

