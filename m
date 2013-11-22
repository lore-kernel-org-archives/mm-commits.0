From: akpm@linux-foundation.org
Subject: [merged]
 arm-drivers-rtc-rtc-at91rm9200c-disable-interrupts-at-shutdown.patch
 removed from -mm tree
Date: Fri, 22 Nov 2013 13:21:55 -0800
Message-ID: <528fcaf3.uQd7m1XyzBYdBSuJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56880 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755698Ab3KVVV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 22 Nov 2013 16:21:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, plagnioj@jcrosoft.com, nicolas.ferre@atmel.com, linux@maxim.org.za, a.zummo@towertech.it, jhovold@gmail.com

Subject: [merged] arm-drivers-rtc-rtc-at91rm9200c-disable-interrupts-at-shutdown.patch removed from -mm tree
To: jhovold@gmail.com,a.zummo@towertech.it,linux@maxim.org.za,nicolas.ferre@atmel.com,plagnioj@jcrosoft.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 22 Nov 2013 13:21:55 -0800


The patch titled
     Subject: ARM: drivers/rtc/rtc-at91rm9200.c: disable interrupts at shutdown
has been removed from the -mm tree.  Its filename was
     arm-drivers-rtc-rtc-at91rm9200c-disable-interrupts-at-shutdown.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johan Hovold <jhovold@gmail.com>
Subject: ARM: drivers/rtc/rtc-at91rm9200.c: disable interrupts at shutdown

Make sure RTC-interrupts are disabled at shutdown.

As the RTC is generally powered by backup power (VDDBU), its interrupts
are not disabled on wake-up, user, watchdog or software reset.  This could
cause troubles on other systems (e.g.  older kernels) if an interrupt
occurs before a handler has been installed at next boot.

Let us be well-behaved and disable them on clean shutdowns at least (as
do the RTT-based rtc-at91sam9 driver).

Signed-off-by: Johan Hovold <jhovold@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-at91rm9200.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff -puN drivers/rtc/rtc-at91rm9200.c~arm-drivers-rtc-rtc-at91rm9200c-disable-interrupts-at-shutdown drivers/rtc/rtc-at91rm9200.c
--- a/drivers/rtc/rtc-at91rm9200.c~arm-drivers-rtc-rtc-at91rm9200c-disable-interrupts-at-shutdown
+++ a/drivers/rtc/rtc-at91rm9200.c
@@ -428,6 +428,14 @@ static int __exit at91_rtc_remove(struct
 	return 0;
 }
 
+static void at91_rtc_shutdown(struct platform_device *pdev)
+{
+	/* Disable all interrupts */
+	at91_rtc_write(AT91_RTC_IDR, AT91_RTC_ACKUPD | AT91_RTC_ALARM |
+					AT91_RTC_SECEV | AT91_RTC_TIMEV |
+					AT91_RTC_CALEV);
+}
+
 #ifdef CONFIG_PM_SLEEP
 
 /* AT91RM9200 RTC Power management control */
@@ -466,6 +474,7 @@ static SIMPLE_DEV_PM_OPS(at91_rtc_pm_ops
 
 static struct platform_driver at91_rtc_driver = {
 	.remove		= __exit_p(at91_rtc_remove),
+	.shutdown	= at91_rtc_shutdown,
 	.driver		= {
 		.name	= "at91_rtc",
 		.owner	= THIS_MODULE,
_

Patches currently in -mm which might be from jhovold@gmail.com are

origin.patch

