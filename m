From: akpm@linux-foundation.org
Subject: [merged] cs5535-clockevt-free-timer-in-irq-setup-error-path.patch removed from -mm tree
Date: Thu, 15 Apr 2010 11:38:33 -0400
Message-ID: <201004151840.o3FIeBZ2024371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53922 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754848Ab0DOSrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Apr 2010 14:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JRottmann@LiPPERTEmbedded.de, dilinger@collabora.co.uk, johnstul@us.ibm.com, jordan@cosmicpenguin.net, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     cs5535-clockevt: free timer in IRQ setup error path
has been removed from the -mm tree.  Its filename was
     cs5535-clockevt-free-timer-in-irq-setup-error-path.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cs5535-clockevt: free timer in IRQ setup error path
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>

Due to a hardware limitation cs5535_mfgpt_free_timer() cannot actually
release the timer hardware, but it will at least free the now unreferenced
struct associated with it so calling it is the cleaner thing to do.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Acked-by: Andres Salomon <dilinger@collabora.co.uk>
Cc: Jordan Crouse <jordan@cosmicpenguin.net>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/clocksource/cs5535-clockevt.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -puN drivers/clocksource/cs5535-clockevt.c~cs5535-clockevt-free-timer-in-irq-setup-error-path drivers/clocksource/cs5535-clockevt.c
--- a/drivers/clocksource/cs5535-clockevt.c~cs5535-clockevt-free-timer-in-irq-setup-error-path
+++ a/drivers/clocksource/cs5535-clockevt.c
@@ -154,14 +154,14 @@ static int __init cs5535_mfgpt_init(void
 	if (cs5535_mfgpt_setup_irq(timer, MFGPT_CMP2, &timer_irq)) {
 		printk(KERN_ERR DRV_NAME ": Could not set up IRQ %d\n",
 				timer_irq);
-		return -EIO;
+		goto err_timer;
 	}
 
 	/* And register it with the kernel */
 	ret = setup_irq(timer_irq, &mfgptirq);
 	if (ret) {
 		printk(KERN_ERR DRV_NAME ": Unable to set up the interrupt.\n");
-		goto err;
+		goto err_irq;
 	}
 
 	/* Set the clock scale and enable the event mode for CMP2 */
@@ -184,8 +184,10 @@ static int __init cs5535_mfgpt_init(void
 
 	return 0;
 
-err:
+err_irq:
 	cs5535_mfgpt_release_irq(cs5535_event_clock, MFGPT_CMP2, &timer_irq);
+err_timer:
+	cs5535_mfgpt_free_timer(cs5535_event_clock);
 	printk(KERN_ERR DRV_NAME ": Unable to set up the MFGPT clock source\n");
 	return -EIO;
 }
_

Patches currently in -mm which might be from JRottmann@LiPPERTEmbedded.de are

linux-next.patch

