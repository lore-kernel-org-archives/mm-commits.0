From: akpm@linux-foundation.org
Subject: + rtc-make-rtc_update_irq-callable-with-irqs-enabled.patch added to -mm tree
Date: Thu, 09 Apr 2009 15:40:23 -0700
Message-ID: <200904092240.n39MeN5o001350@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753538AbZDIWnd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 18:43:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: anemo@mba.ocn.ne.jp, a.zummo@towertech.it, david-b@pacbell.net


The patch titled
     rtc: make rtc_update_irq callable with irqs enabled
has been added to the -mm tree.  Its filename is
     rtc-make-rtc_update_irq-callable-with-irqs-enabled.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

