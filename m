From: akpm@linux-foundation.org
Subject: [merged] rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2.patch removed from -mm tree
Date: Mon, 22 Jun 2009 10:00:23 -0700
Message-ID: <200906221700.n5MH0Nqr009629@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35720 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752561AbZFVRBF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Jun 2009 13:01:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: make rtc_update_irq callable with irqs enabled
has been removed from the -mm tree.  Its filename was
     rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: make rtc_update_irq callable with irqs enabled
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The rtc_update_irq() might be called with irqs enabled, if a interrupt
handler was registered without IRQF_DISABLED.  Use
spin_lock_irqsave/spin_unlock_irqrestore instead of spin_lock/spin_unlock.

Also update kerneldoc and drivers which do extra work to follow the
current interface spec, as suggestted by David Brownell.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c  |   12 +++++++-----
 drivers/rtc/rtc-dev.c    |    6 ++----
 drivers/rtc/rtc-ds1305.c |    3 ---
 drivers/rtc/rtc-ds1307.c |    5 -----
 drivers/rtc/rtc-ds1374.c |    5 -----
 drivers/rtc/rtc-test.c   |    2 --
 6 files changed, 9 insertions(+), 24 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2 drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2
+++ a/drivers/rtc/interface.c
@@ -371,19 +371,21 @@ EXPORT_SYMBOL_GPL(rtc_update_irq_enable)
  * @rtc: the rtc device
  * @num: how many irqs are being reported (usually one)
  * @events: mask of RTC_IRQF with one or more of RTC_PF, RTC_AF, RTC_UF
- * Context: in_interrupt(), irqs blocked
+ * Context: any
  */
 void rtc_update_irq(struct rtc_device *rtc,
 		unsigned long num, unsigned long events)
 {
-	spin_lock(&rtc->irq_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&rtc->irq_lock, flags);
 	rtc->irq_data = (rtc->irq_data + (num << 8)) | events;
-	spin_unlock(&rtc->irq_lock);
+	spin_unlock_irqrestore(&rtc->irq_lock, flags);
 
-	spin_lock(&rtc->irq_task_lock);
+	spin_lock_irqsave(&rtc->irq_task_lock, flags);
 	if (rtc->irq_task)
 		rtc->irq_task->func(rtc->irq_task->private_data);
-	spin_unlock(&rtc->irq_task_lock);
+	spin_unlock_irqrestore(&rtc->irq_task_lock, flags);
 
 	wake_up_interruptible(&rtc->irq_queue);
 	kill_fasync(&rtc->async_queue, SIGIO, POLL_IN);
diff -puN drivers/rtc/rtc-dev.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2 drivers/rtc/rtc-dev.c
--- a/drivers/rtc/rtc-dev.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2
+++ a/drivers/rtc/rtc-dev.c
@@ -60,8 +60,7 @@ static void rtc_uie_task(struct work_str
 
 	err = rtc_read_time(rtc, &tm);
 
-	local_irq_disable();
-	spin_lock(&rtc->irq_lock);
+	spin_lock_irq(&rtc->irq_lock);
 	if (rtc->stop_uie_polling || err) {
 		rtc->uie_task_active = 0;
 	} else if (rtc->oldsecs != tm.tm_sec) {
@@ -74,10 +73,9 @@ static void rtc_uie_task(struct work_str
 	} else if (schedule_work(&rtc->uie_task) == 0) {
 		rtc->uie_task_active = 0;
 	}
-	spin_unlock(&rtc->irq_lock);
+	spin_unlock_irq(&rtc->irq_lock);
 	if (num)
 		rtc_update_irq(rtc, num, RTC_UF | RTC_IRQF);
-	local_irq_enable();
 }
 static void rtc_uie_timer(unsigned long data)
 {
diff -puN drivers/rtc/rtc-ds1305.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2 drivers/rtc/rtc-ds1305.c
--- a/drivers/rtc/rtc-ds1305.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2
+++ a/drivers/rtc/rtc-ds1305.c
@@ -499,10 +499,7 @@ static void ds1305_work(struct work_stru
 	if (!test_bit(FLAG_EXITING, &ds1305->flags))
 		enable_irq(spi->irq);
 
-	/* rtc_update_irq() requires an IRQ-disabled context */
-	local_irq_disable();
 	rtc_update_irq(ds1305->rtc, 1, RTC_AF | RTC_IRQF);
-	local_irq_enable();
 }
 
 /*
diff -puN drivers/rtc/rtc-ds1307.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2 drivers/rtc/rtc-ds1307.c
--- a/drivers/rtc/rtc-ds1307.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2
+++ a/drivers/rtc/rtc-ds1307.c
@@ -267,12 +267,7 @@ static void ds1307_work(struct work_stru
 		control &= ~DS1337_BIT_A1IE;
 		i2c_smbus_write_byte_data(client, DS1337_REG_CONTROL, control);
 
-		/* rtc_update_irq() assumes that it is called
-		 * from IRQ-disabled context.
-		 */
-		local_irq_disable();
 		rtc_update_irq(ds1307->rtc, 1, RTC_AF | RTC_IRQF);
-		local_irq_enable();
 	}
 
 out:
diff -puN drivers/rtc/rtc-ds1374.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2 drivers/rtc/rtc-ds1374.c
--- a/drivers/rtc/rtc-ds1374.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2
+++ a/drivers/rtc/rtc-ds1374.c
@@ -296,12 +296,7 @@ static void ds1374_work(struct work_stru
 		control &= ~(DS1374_REG_CR_WACE | DS1374_REG_CR_AIE);
 		i2c_smbus_write_byte_data(client, DS1374_REG_CR, control);
 
-		/* rtc_update_irq() assumes that it is called
-		 * from IRQ-disabled context.
-		 */
-		local_irq_disable();
 		rtc_update_irq(ds1374->rtc, 1, RTC_AF | RTC_IRQF);
-		local_irq_enable();
 	}
 
 out:
diff -puN drivers/rtc/rtc-test.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2 drivers/rtc/rtc-test.c
--- a/drivers/rtc/rtc-test.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2
+++ a/drivers/rtc/rtc-test.c
@@ -93,7 +93,6 @@ static ssize_t test_irq_store(struct dev
 	struct rtc_device *rtc = platform_get_drvdata(plat_dev);
 
 	retval = count;
-	local_irq_disable();
 	if (strncmp(buf, "tick", 4) == 0)
 		rtc_update_irq(rtc, 1, RTC_PF | RTC_IRQF);
 	else if (strncmp(buf, "alarm", 5) == 0)
@@ -102,7 +101,6 @@ static ssize_t test_irq_store(struct dev
 		rtc_update_irq(rtc, 1, RTC_UF | RTC_IRQF);
 	else
 		retval = -EINVAL;
-	local_irq_enable();
 
 	return retval;
 }
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

origin.patch
linux-next.patch
txx9dmac-use-dma_unmap_single-if-dma_compl_srcdest_unmap_single-was-set.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch

