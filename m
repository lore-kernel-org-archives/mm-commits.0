From: akpm@linux-foundation.org
Subject: [merged] drivers-rtc-rtc-twlc-ensure-irq-is-wakeup-enabled.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:35:04 -0700
Message-ID: <51db1468.uQT9wQks02pJbcPY%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51397 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab3GHTfI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, tony@atomide.com, grygorii.strashko@ti.com, a.zummo@towertech.it, khilman@linaro.org

Subject: [merged] drivers-rtc-rtc-twlc-ensure-irq-is-wakeup-enabled.patch removed from -mm tree
To: khilman@linaro.org,a.zummo@towertech.it,grygorii.strashko@ti.com,tony@atomide.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:04 -0700


The patch titled
     Subject: drivers/rtc/rtc-twl.c: ensure IRQ is wakeup enabled
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-twlc-ensure-irq-is-wakeup-enabled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Kevin Hilman <khilman@linaro.org>
Subject: drivers/rtc/rtc-twl.c: ensure IRQ is wakeup enabled

Currently, the RTC IRQ is never wakeup-enabled so is not capable of
bringing the system out of suspend.

On OMAP platforms, we have gotten by without this because the TWL RTC is
on an I2C-connected chip which is capable of waking up the OMAP via the IO
ring when the OMAP is in low-power states.

However, if the OMAP suspends without hitting the low-power states (and
the IO ring is not enabled), RTC wakeups will not work because the IRQ is
not wakeup enabled.

To fix, ensure the RTC IRQ is wakeup enabled whenever the RTC alarm is
set.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-twl.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-ensure-irq-is-wakeup-enabled drivers/rtc/rtc-twl.c
--- a/drivers/rtc/rtc-twl.c~drivers-rtc-rtc-twlc-ensure-irq-is-wakeup-enabled
+++ a/drivers/rtc/rtc-twl.c
@@ -213,12 +213,24 @@ static int mask_rtc_irq_bit(unsigned cha
 
 static int twl_rtc_alarm_irq_enable(struct device *dev, unsigned enabled)
 {
+	struct platform_device *pdev = to_platform_device(dev);
+	int irq = platform_get_irq(pdev, 0);
+	static bool twl_rtc_wake_enabled;
 	int ret;
 
-	if (enabled)
+	if (enabled) {
 		ret = set_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
-	else
+		if (device_can_wakeup(dev) && !twl_rtc_wake_enabled) {
+			enable_irq_wake(irq);
+			twl_rtc_wake_enabled = true;
+		}
+	} else {
 		ret = mask_rtc_irq_bit(BIT_RTC_INTERRUPTS_REG_IT_ALARM_M);
+		if (twl_rtc_wake_enabled) {
+			disable_irq_wake(irq);
+			twl_rtc_wake_enabled = false;
+		}
+	}
 
 	return ret;
 }
_

Patches currently in -mm which might be from khilman@linaro.org are

origin.patch
linux-next.patch

