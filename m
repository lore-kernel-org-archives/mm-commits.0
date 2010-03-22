From: akpm@linux-foundation.org
Subject: [merged] hrtimer-correct-a-few-numbers-in-comments.patch removed from -mm tree
Date: Mon, 22 Mar 2010 11:31:19 -0400
Message-ID: <201003221832.o2MIW9M9019983@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412Ab0CVScj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 14:32:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, a.p.zijlstra@chello.nl, luming.yu@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     hrtimer: correct a few numbers in comments, fix printk output
has been removed from the -mm tree.  Its filename was
     hrtimer-correct-a-few-numbers-in-comments.patch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: hrtimer: correct a few numbers in comments, fix printk output
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

- fix comments

- remove incorrect left-shift in printk output

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Luming Yu <luming.yu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-oneshot.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
@@ -52,7 +52,7 @@ int tick_dev_program_event(struct clock_
 			printk(KERN_WARNING
 			       "CE: %s increasing min_delta_ns to %llu nsec\n",
 			       dev->name ? dev->name : "?",
-			       (unsigned long long) dev->min_delta_ns << 1);
+			       (unsigned long long) dev->min_delta_ns);
=20
 			i =3D 0;
 		}
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

rtc-mc13783-fix-use-after-free-bug.patch
linux-next.patch
timer-print-function-name-for-timer-callbacks-modifying-preemption-coun=
t.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
