From: akpm@linux-foundation.org
Subject: + hrtimer-correct-a-few-numbers-in-comments.patch added to -mm tree
Date: Mon, 23 Nov 2009 15:26:40 -0800
Message-ID: <200911232326.nANNQeQD021634@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46409 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757386AbZKWX1i (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Nov 2009 18:27:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, a.p.zijlstra@chello.nl, luming.yu@gmail.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     hrtimer: correct a few numbers in comments
has been added to the -mm tree.  Its filename is
     hrtimer-correct-a-few-numbers-in-comments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: hrtimer: correct a few numbers in comments
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Luming Yu <luming.yu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c           |    4 ++--
 kernel/time/tick-oneshot.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/hrtimer.c~hrtimer-correct-a-few-numbers-in-comments ke=
rnel/hrtimer.c
--- a/kernel/hrtimer.c~hrtimer-correct-a-few-numbers-in-comments
+++ a/kernel/hrtimer.c
@@ -1220,7 +1220,7 @@ static void __run_hrtimer(struct hrtimer
 static int force_clock_reprogram;
=20
 /*
- * After 5 iteration's attempts, we consider that hrtimer_interrupt()
+ * After 4 iteration's attempts, we consider that hrtimer_interrupt()
  * is hanging, which could happen with something that slows the interr=
upt
  * such as the tracing. Then we force the clock reprogramming for each=
 future
  * hrtimer interrupts to avoid infinite loops and use the min_delta_ns
@@ -1258,7 +1258,7 @@ void hrtimer_interrupt(struct clock_even
 	dev->next_event.tv64 =3D KTIME_MAX;
=20
  retry:
-	/* 5 retries is enough to notice a hang */
+	/* 4 retries is enough to notice a hang */
 	if (!(++nr_retries % 5))
 		hrtimer_interrupt_hanging(dev, ktime_sub(ktime_get(), now));
=20
diff -puN kernel/time/tick-oneshot.c~hrtimer-correct-a-few-numbers-in-c=
omments kernel/time/tick-oneshot.c
--- a/kernel/time/tick-oneshot.c~hrtimer-correct-a-few-numbers-in-comme=
nts
+++ a/kernel/time/tick-oneshot.c
@@ -39,7 +39,7 @@ int tick_dev_program_event(struct clock_
=20
 		/*
 		 * We tried 2 times to program the device with the given
-		 * min_delta_ns. If that's not working then we double it
+		 * min_delta_ns. If that's not working then we increase it
 		 * and emit a warning.
 		 */
 		if (++i > 2) {
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-assert-min_delta_ns-being-increased-in-error-path.patch
mxcmmc-fix-error-path-in-mxcmci_probe.patch
spi-drain-mxc-spi-transfer-buffer-when-probing-device.patch
rtc-add-freescale-mc13783-rtc-driver.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
