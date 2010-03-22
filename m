From: akpm@linux-foundation.org
Subject: [merged] clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch removed from -mm tree
Date: Mon, 22 Mar 2010 11:31:22 -0400
Message-ID: <201003221832.o2MIWCAS019990@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39034 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755638Ab0CVSco (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 22 Mar 2010 14:32:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, a.p.zijlstra@chello.nl, luming.yu@gmail.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clockevents: ensure that min_delta_ns is increased in error path
has been removed from the -mm tree.  Its filename was
     clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.pa=
tch

This patch was dropped because it was merged into mainline or a subsyst=
em tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: clockevents: ensure that min_delta_ns is increased in error pa=
th
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

tick_dev_program_event failed to increase min_delta_ns if the initial
value was 1.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Luming Yu <luming.yu@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/tick-oneshot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/time/tick-oneshot.c~clockevents-ensure-taht-min_delta_=
ns-is-increased-in-error-path kernel/time/tick-oneshot.c
--- a/kernel/time/tick-oneshot.c~clockevents-ensure-taht-min_delta_ns-i=
s-increased-in-error-path
+++ a/kernel/time/tick-oneshot.c
@@ -44,7 +44,7 @@ int tick_dev_program_event(struct clock_
 		 */
 		if (++i > 2) {
 			/* Increase the min. delta and try again */
-			if (!dev->min_delta_ns)
+			if (dev->min_delta_ns <=3D 1)
 				dev->min_delta_ns =3D 5000;
 			else
 				dev->min_delta_ns +=3D dev->min_delta_ns >> 1;
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
