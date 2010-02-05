From: akpm@linux-foundation.org
Subject: + cs5535-clockevt-free-timer-in-irq-setup-error-path.patch added to -mm tree
Date: Fri, 05 Feb 2010 14:38:01 -0800
Message-ID: <201002052238.o15Mc1LA025397@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933946Ab0BEWjA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Feb 2010 17:39:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JRottmann@LiPPERTEmbedded.de, dilinger@collabora.co.uk, johnstul@us.ibm.com, jordan.crouse@amd.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     cs5535-clockevt: free timer in IRQ setup error path
has been added to the -mm tree.  Its filename is
     cs5535-clockevt-free-timer-in-irq-setup-error-path.patch

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
Subject: cs5535-clockevt: free timer in IRQ setup error path
From: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>

Due to a hardware limitation cs5535_mfgpt_free_timer() cannot actually
release the timer hardware, but it will at least free the now unreferenced
struct associated with it so calling it is the cleaner thing to do.

Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
Cc: Andres Salomon <dilinger@collabora.co.uk>
Cc: Jordan Crouse <jordan.crouse@amd.com>
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

origin.patch
geode-mfgpt-restore-previous-behavior-for-selecting-irq.patch
cs5535-clockevt-free-timer-in-irq-setup-error-path.patch

