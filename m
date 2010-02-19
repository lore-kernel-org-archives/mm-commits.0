From: akpm@linux-foundation.org
Subject: + timer-print-function-name-for-timer-callbacks-modifying-preemption-count.patch added to -mm tree
Date: Fri, 19 Feb 2010 14:01:44 -0800
Message-ID: <201002192201.o1JM1iVx006933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36843 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556Ab0BSWDT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Feb 2010 17:03:19 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: u.kleine-koenig@pengutronix.de, mingo@elte.hu, tglx@linutronix.de


The patch titled
     timer: print function name for timer callbacks modifying preemptio=
n count
has been added to the -mm tree.  Its filename is
     timer-print-function-name-for-timer-callbacks-modifying-preemption=
-count.patch

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
Subject: timer: print function name for timer callbacks modifying preem=
ption count
=46rom: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

A function scheduled with a timer must not exit with a different preemp=
t
count than it was entered.  To make helping users running into the
corresponding BUG() easier also print the name of the bad function not
only its address.

Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/timer.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN kernel/timer.c~timer-print-function-name-for-timer-callbacks-=
modifying-preemption-count kernel/timer.c
--- a/kernel/timer.c~timer-print-function-name-for-timer-callbacks-modi=
fying-preemption-count
+++ a/kernel/timer.c
@@ -1084,10 +1084,10 @@ static inline void __run_timers(struct t
 				lock_map_release(&lockdep_map);
=20
 				if (preempt_count !=3D preempt_count()) {
-					printk(KERN_ERR "huh, entered %p "
+					printk(KERN_ERR "huh, entered %p (%pF)"
 					       "with preempt_count %08x, exited"
 					       " with %08x?\n",
-					       fn, preempt_count,
+					       fn, fn, preempt_count,
 					       preempt_count());
 					BUG();
 				}
_

Patches currently in -mm which might be from u.kleine-koenig@pengutroni=
x.de are

origin.patch
linux-next.patch
hrtimer-correct-a-few-numbers-in-comments.patch
clockevents-ensure-taht-min_delta_ns-is-increased-in-error-path.patch
timer-print-function-name-for-timer-callbacks-modifying-preemption-coun=
t.patch
genirq-warn-about-irqf_sharedirqf_disabled-at-the-right-place.patch
rtc-pcf2123-move-pcf2123_remove-to-devexittext.patch
rtc-hctosys-only-claim-the-rtc-provided-the-system-time-if-it-did.patch
w1-mxc_w1-move-probe-and-remove-to-the-dev-text-area.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
