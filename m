From: akpm@linux-foundation.org
Subject: + kernel-time-tick-schedc-convert-noisy-nohz-prints-to-pr_debug.patch added to -mm tree
Date: Mon, 29 Aug 2011 16:50:57 -0700
Message-ID: <201108292350.p7TNovL8011147@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39821 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755176Ab1H2Xvk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Aug 2011 19:51:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: santosh.shilimkar@ti.com, john.stultz@linaro.org, tglx@linutronix.de


The patch titled
     kernel/time/tick-sched.c: convert noisy NOHz prints to pr_debug
has been added to the -mm tree.  Its filename is
     kernel-time-tick-schedc-convert-noisy-nohz-prints-to-pr_debug.patch

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
Subject: kernel/time/tick-sched.c: convert noisy NOHz prints to pr_debug
From: Santosh Shilimkar <santosh.shilimkar@ti.com>

Couple of prints from tick-sched.c which says 'Switched to NOHz mode on
CPU' is more of debug information with NOHZ enabled.  Mark these as debug
prints to avoid console noise.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/time/tick-sched.c~kernel-time-tick-schedc-convert-noisy-nohz-prints-to-pr_debug kernel/time/tick-sched.c
--- a/kernel/time/tick-sched.c~kernel-time-tick-schedc-convert-noisy-nohz-prints-to-pr_debug
+++ a/kernel/time/tick-sched.c
@@ -660,7 +660,7 @@ static void tick_nohz_switch_to_nohz(voi
 	}
 	local_irq_enable();
 
-	printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
+	pr_debug("Switched to NOHz mode on CPU #%d\n", smp_processor_id());
 }
 
 /*
@@ -814,7 +814,7 @@ void tick_setup_sched_timer(void)
 #ifdef CONFIG_NO_HZ
 	if (tick_nohz_enabled) {
 		ts->nohz_mode = NOHZ_MODE_HIGHRES;
-		printk(KERN_INFO "Switched to NOHz mode on CPU #%d\n", smp_processor_id());
+		pr_debug("Switched to NOHz mode on CPU #%d\n", smp_processor_id());
 	}
 #endif
 }
_

Patches currently in -mm which might be from santosh.shilimkar@ti.com are

linux-next.patch
kernel-time-tick-schedc-convert-noisy-nohz-prints-to-pr_debug.patch

