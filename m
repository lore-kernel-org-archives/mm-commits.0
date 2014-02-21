From: akpm@linux-foundation.org
Subject: + rtc-mc13xxx-remove-__exit_p.patch added to -mm tree
Date: Fri, 21 Feb 2014 15:10:00 -0800
Message-ID: <5307dcc8.lgyQKn83ZWEFJP/Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59144 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaBUXKB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Feb 2014 18:10:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, u.kleine-koenig@pengutronix.de, kernel@pengutronix.de, shc_work@mail.ru

Subject: + rtc-mc13xxx-remove-__exit_p.patch added to -mm tree
To: shc_work@mail.ru,kernel@pengutronix.de,u.kleine-koenig@pengutronix.de
From: akpm@linux-foundation.org
Date: Fri, 21 Feb 2014 15:10:00 -0800


The patch titled
     Subject: rtc: mc13xxx: remove __exit_p()
has been added to the -mm tree.  Its filename is
     rtc-mc13xxx-remove-__exit_p.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-mc13xxx-remove-__exit_p.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-mc13xxx-remove-__exit_p.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Shiyan <shc_work@mail.ru>
Subject: rtc: mc13xxx: remove __exit_p()

Since we no longer allow building without hotplug, the
mc13xxx_rtc_remove() function is always present and we should not use
__exit_p() to refer to it.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Sascha Hauer <kernel@pengutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-mc13xxx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-remove-__exit_p drivers/rtc/rtc-mc13xxx.c
--- a/drivers/rtc/rtc-mc13xxx.c~rtc-mc13xxx-remove-__exit_p
+++ a/drivers/rtc/rtc-mc13xxx.c
@@ -375,7 +375,7 @@ err_reset_irq_request:
 	return ret;
 }
 
-static int __exit mc13xxx_rtc_remove(struct platform_device *pdev)
+static int mc13xxx_rtc_remove(struct platform_device *pdev)
 {
 	struct mc13xxx_rtc *priv = platform_get_drvdata(pdev);
 
@@ -404,7 +404,7 @@ MODULE_DEVICE_TABLE(platform, mc13xxx_rt
 
 static struct platform_driver mc13xxx_rtc_driver = {
 	.id_table = mc13xxx_rtc_idtable,
-	.remove = __exit_p(mc13xxx_rtc_remove),
+	.remove = mc13xxx_rtc_remove,
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
_

Patches currently in -mm which might be from shc_work@mail.ru are

rtc-mc13xxx-remove-__exit_p.patch
rtc-mc13xxx-request-irqs-after-rtc-registration.patch
rtc-mc13xxx-simplify-alarm_irq_enable.patch
rtc-mc13xxx-fix-1hz-interrupt.patch
rtc-mc13xxx-change-rtc-validation-scheme.patch
rtc-mc13xxx-make-rtc_read_time-more-readable.patch
linux-next.patch

