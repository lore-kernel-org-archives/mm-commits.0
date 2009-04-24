From: akpm@linux-foundation.org
Subject: [to-be-updated] rtc-make-rtc_update_irq-callable-with-irqs-enabled.patch removed from -mm tree
Date: Fri, 24 Apr 2009 13:15:55 -0700
Message-ID: <200904242015.n3OKFtIH007962@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751188AbZDXUTI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Apr 2009 16:19:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net, mm-commits@vger.kernel.org


The patch titled
     rtc: make rtc_update_irq callable with irqs enabled
has been removed from the -mm tree.  Its filename was
     rtc-make-rtc_update_irq-callable-with-irqs-enabled.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: rtc: make rtc_update_irq callable with irqs enabled
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

The rtc_update_irq() might be called with irqs enabled, if a interrupt
handler was registered without IRQF_DISABLED.

Use spin_lock_irqsave/spin_unlock_irqrestore instead of
spin_lock/spin_unlock.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: David Brownell <david-b@pacbell.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/interface.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/interface.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled drivers/rtc/interface.c
--- a/drivers/rtc/interface.c~rtc-make-rtc_update_irq-callable-with-irqs-enabled
+++ a/drivers/rtc/interface.c
@@ -376,14 +376,16 @@ EXPORT_SYMBOL_GPL(rtc_update_irq_enable)
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
_

Patches currently in -mm which might be from anemo@mba.ocn.ne.jp are

linux-next.patch
kgdb-kgdboc-console-poll-hooks-for-serial_txx9-uart.patch
serial_txx9-use-container_of-instead-of-direct-cast.patch
rtc-rtc-ds1742-nvram-attribute-fix.patch
rtc-make-rtc_update_irq-callable-with-irqs-enabled.patch
rtc-make-rtc_update_irq-callable-with-irqs-enabled-v2.patch

