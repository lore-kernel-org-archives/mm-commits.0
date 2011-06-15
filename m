From: akpm@linux-foundation.org
Subject: + timerfd-really-wake-up-processes-when-timer-is-cancelled-on-clock-change.patch added to -mm tree
Date: Tue, 14 Jun 2011 18:27:21 -0700
Message-ID: <201106150124.p5F1Ocfc031971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752334Ab1FOBh4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Jun 2011 21:37:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: masbock@linux.vnet.ibm.com, john.stultz@linaro.org, tglx@linutronix.de


The patch titled
     timerfd: really wake up processes when timer is cancelled on clock change
has been added to the -mm tree.  Its filename is
     timerfd-really-wake-up-processes-when-timer-is-cancelled-on-clock-change.patch

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
Subject: timerfd: really wake up processes when timer is cancelled on clock change
From: Max Asbock <masbock@linux.vnet.ibm.com>

When the system time is set the clock_was_set() function calls
timerfd_clock_was_set() to cancel and wake up processes waiting on
potential cancelable timerfd timers.  However the wake up currently has no
effect because in the case of timerfd_read it is dependent on ctx->ticks
not being 0.  timerfd_poll also requires ctx->ticks being non zero.  As a
consequence processes waiting on cancelable timers only get woken up when
the timers expire.  This patch fixes this by incrementing ctx->ticks
before calling wake_up.

Signed-off-by: Max Asbock <masbock@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Signed-off-by: Andrew Morton <>
---

 fs/timerfd.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/timerfd.c~timerfd-really-wake-up-processes-when-timer-is-cancelled-on-clock-change fs/timerfd.c
--- a/fs/timerfd.c~timerfd-really-wake-up-processes-when-timer-is-cancelled-on-clock-change
+++ a/fs/timerfd.c
@@ -61,7 +61,9 @@ static enum hrtimer_restart timerfd_tmrp
 
 /*
  * Called when the clock was set to cancel the timers in the cancel
- * list.
+ * list. This will wake up processes waiting on these timers. The
+ * wake-up requires ctx->ticks to be non zero, therefore we increment
+ * it before calling wake_up_locked().
  */
 void timerfd_clock_was_set(void)
 {
@@ -76,6 +78,7 @@ void timerfd_clock_was_set(void)
 		spin_lock_irqsave(&ctx->wqh.lock, flags);
 		if (ctx->moffs.tv64 != moffs.tv64) {
 			ctx->moffs.tv64 = KTIME_MAX;
+			ctx->ticks++;
 			wake_up_locked(&ctx->wqh);
 		}
 		spin_unlock_irqrestore(&ctx->wqh.lock, flags);
_

Patches currently in -mm which might be from masbock@linux.vnet.ibm.com are

timerfd-really-wake-up-processes-when-timer-is-cancelled-on-clock-change.patch

