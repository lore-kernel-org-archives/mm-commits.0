From: akpm@linux-foundation.org
Subject: [merged]
 drivers-rtc-rtc-cmosc-work-around-bios-clearing-rtc-control.patch removed
 from -mm tree
Date: Mon, 08 Jul 2013 12:35:06 -0700
Message-ID: <51db146a.ByesAifOzszMMcD7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51391 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3GHTfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, snanda@chromium.org, rostedt@goodmis.org, john.stultz@linaro.org, jg1.han@samsung.com, a.zummo@towertech.it, dbasehore@chromium.org

Subject: [merged] drivers-rtc-rtc-cmosc-work-around-bios-clearing-rtc-control.patch removed from -mm tree
To: dbasehore@chromium.org,a.zummo@towertech.it,jg1.han@samsung.com,john.stultz@linaro.org,rostedt@goodmis.org,snanda@chromium.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:06 -0700


The patch titled
     Subject: drivers/rtc/rtc-cmos.c: work around bios clearing rtc control
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-cmosc-work-around-bios-clearing-rtc-control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Derek Basehore <dbasehore@chromium.org>
Subject: drivers/rtc/rtc-cmos.c: work around bios clearing rtc control

The bios may clear the rtc control register when resuming the system. Since the
cmos interrupt handler may now be run before the rtc_cmos is resumed, this can
cause the interrupt handler to ignore an alarm since the alarm bit is not set in
the rtc control register. To work around this, check if the rtc_cmos is
suspended and use the stored value for the rtc control register.

Signed-off-by: Derek Basehore <dbasehore@chromium.org>
Reviewed-by: Sameer Nanda <snanda@chromium.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |   35 ++++++++++++++++++++++-------------
 1 file changed, 22 insertions(+), 13 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-work-around-bios-clearing-rtc-control drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~drivers-rtc-rtc-cmosc-work-around-bios-clearing-rtc-control
+++ a/drivers/rtc/rtc-cmos.c
@@ -556,17 +556,24 @@ static irqreturn_t cmos_interrupt(int ir
 	rtc_control = CMOS_READ(RTC_CONTROL);
 	if (is_hpet_enabled())
 		irqstat = (unsigned long)irq & 0xF0;
-	irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+
+	/* If we were suspended, RTC_CONTROL may not be accurate since the
+	 * bios may have cleared it.
+	 */
+	if (!cmos_rtc.suspend_ctrl)
+		irqstat &= (rtc_control & RTC_IRQMASK) | RTC_IRQF;
+	else
+		irqstat &= (cmos_rtc.suspend_ctrl & RTC_IRQMASK) | RTC_IRQF;
 
 	/* All Linux RTC alarms should be treated as if they were oneshot.
 	 * Similar code may be needed in system wakeup paths, in case the
 	 * alarm woke the system.
 	 */
 	if (irqstat & RTC_AIE) {
+		cmos_rtc.suspend_ctrl &= ~RTC_AIE;
 		rtc_control &= ~RTC_AIE;
 		CMOS_WRITE(rtc_control, RTC_CONTROL);
 		hpet_mask_rtc_irq_bit(RTC_AIE);
-
 		CMOS_READ(RTC_INTR_FLAGS);
 	}
 	spin_unlock(&rtc_lock);
@@ -839,21 +846,23 @@ static inline int cmos_poweroff(struct d
 static int cmos_resume(struct device *dev)
 {
 	struct cmos_rtc	*cmos = dev_get_drvdata(dev);
-	unsigned char	tmp = cmos->suspend_ctrl;
+	unsigned char tmp;
+
+	if (cmos->enabled_wake) {
+		if (cmos->wake_off)
+			cmos->wake_off(dev);
+		else
+			disable_irq_wake(cmos->irq);
+		cmos->enabled_wake = 0;
+	}
 
+	spin_lock_irq(&rtc_lock);
+	tmp = cmos->suspend_ctrl;
+	cmos->suspend_ctrl = 0;
 	/* re-enable any irqs previously active */
 	if (tmp & RTC_IRQMASK) {
 		unsigned char	mask;
 
-		if (cmos->enabled_wake) {
-			if (cmos->wake_off)
-				cmos->wake_off(dev);
-			else
-				disable_irq_wake(cmos->irq);
-			cmos->enabled_wake = 0;
-		}
