From: akpm@linux-foundation.org
Subject: + timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64.patch added to -mm tree
Date: Sat, 22 Dec 2007 01:49:17 -0800
Message-ID: <200712220949.lBM9nHGs027202@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbXLVJts (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 04:49:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, mingo@elte.hu, mtk-manpages@gmx.net, tglx@linutronix.de


The patch titled
     timerfd: make hrtimer_forward() to return a u64
has been added to the -mm tree.  Its filename is
     timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timerfd: make hrtimer_forward() to return a u64
From: Davide Libenzi <davidel@xmailserver.org>

Make hrtimer_forward() return a u64 instead of unsigned long.  Since timerfd
returns the number of timer ticks in a u64 variable, and hrtimer_forward() is
used to calculate the timer ticks, the patch allow full 64 bit usage even on
32 bit platforms.  The core of the hrtimer_forward() ticks calculation,
ktime_divns(), was already having the result in u64 and it was chopping it to
unsigned long.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/timerfd.c            |    6 +++---
 include/linux/hrtimer.h |   10 +++++-----
 kernel/hrtimer.c        |    9 ++++-----
 kernel/posix-timers.c   |    9 +++++----
 4 files changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/timerfd.c~timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64 fs/timerfd.c
--- a/fs/timerfd.c~timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64
+++ a/fs/timerfd.c
@@ -134,8 +134,8 @@ static ssize_t timerfd_read(struct file 
 			 * callback to avoid DoS attacks specifying a very
 			 * short timer period.
 			 */
-			ticks += (u64) hrtimer_forward_now(&ctx->tmr,
-							   ctx->tintv) - 1;
+			ticks += hrtimer_forward_now(&ctx->tmr,
+						     ctx->tintv) - 1;
 			hrtimer_restart(&ctx->tmr);
 		}
 		ctx->expired = 0;
@@ -270,7 +270,7 @@ asmlinkage long sys_timerfd_gettime(int 
 	spin_lock_irq(&ctx->wqh.lock);
 	if (ctx->expired && ctx->tintv.tv64) {
 		ctx->expired = 0;
-		ctx->ticks += (u64)
+		ctx->ticks +=
 			hrtimer_forward_now(&ctx->tmr, ctx->tintv) - 1;
 		hrtimer_restart(&ctx->tmr);
 	}
diff -puN include/linux/hrtimer.h~timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64 include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64
+++ a/include/linux/hrtimer.h
@@ -295,12 +295,12 @@ static inline int hrtimer_is_queued(stru
 }
 
 /* Forward a hrtimer so it expires after now: */
-extern unsigned long
+extern u64
 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
 
 /* Forward a hrtimer so it expires after the hrtimer's current now */
-static inline unsigned long hrtimer_forward_now(struct hrtimer *timer,
-						ktime_t interval)
+static inline u64 hrtimer_forward_now(struct hrtimer *timer,
+				      ktime_t interval)
 {
 	return hrtimer_forward(timer, timer->base->get_time(), interval);
 }
@@ -322,9 +322,9 @@ extern void hrtimer_run_queues(void);
 extern void __init hrtimers_init(void);
 
 #if BITS_PER_LONG < 64
-extern unsigned long ktime_divns(const ktime_t kt, s64 div);
+extern u64 ktime_divns(const ktime_t kt, s64 div);
 #else /* BITS_PER_LONG < 64 */
-# define ktime_divns(kt, div)		(unsigned long)((kt).tv64 / (div))
+# define ktime_divns(kt, div)		(u64)((kt).tv64 / (div))
 #endif
 
 /* Show pending timers: */
diff -puN kernel/hrtimer.c~timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64 kernel/hrtimer.c
--- a/kernel/hrtimer.c~timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64
+++ a/kernel/hrtimer.c
@@ -306,7 +306,7 @@ EXPORT_SYMBOL_GPL(ktime_sub_ns);
 /*
  * Divide a ktime value by a nanosecond value
  */
-unsigned long ktime_divns(const ktime_t kt, s64 div)
+u64 ktime_divns(const ktime_t kt, s64 div)
 {
 	u64 dclc, inc, dns;
 	int sft = 0;
@@ -321,7 +321,7 @@ unsigned long ktime_divns(const ktime_t 
 	dclc >>= sft;
 	do_div(dclc, (unsigned long) div);
 
-	return (unsigned long) dclc;
+	return dclc;
 }
 #endif /* BITS_PER_LONG >= 64 */
 
@@ -655,10 +655,9 @@ void unlock_hrtimer_base(const struct hr
  * Forward the timer expiry so it will expire in the future.
  * Returns the number of overruns.
  */
-unsigned long
-hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
+u64 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval)
 {
-	unsigned long orun = 1;
+	u64 orun = 1;
 	ktime_t delta;
 
 	delta = ktime_sub(now, timer->expires);
diff -puN kernel/posix-timers.c~timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64 kernel/posix-timers.c
--- a/kernel/posix-timers.c~timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64
+++ a/kernel/posix-timers.c
@@ -256,8 +256,9 @@ static void schedule_next_timer(struct k
 	if (timr->it.real.interval.tv64 == 0)
 		return;
 
-	timr->it_overrun += hrtimer_forward(timer, timer->base->get_time(),
-					    timr->it.real.interval);
+	timr->it_overrun += (unsigned int) hrtimer_forward(timer,
+						timer->base->get_time(),
+						timr->it.real.interval);
 
 	timr->it_overrun_last = timr->it_overrun;
 	timr->it_overrun = -1;
@@ -386,7 +387,7 @@ static enum hrtimer_restart posix_timer_
 					now = ktime_add(now, kj);
 			}
 #endif
-			timr->it_overrun +=
+			timr->it_overrun += (unsigned int)
 				hrtimer_forward(timer, now,
 						timr->it.real.interval);
 			ret = HRTIMER_RESTART;
@@ -662,7 +663,7 @@ common_timer_get(struct k_itimer *timr, 
 	 */
 	if (iv.tv64 && (timr->it_requeue_pending & REQUEUE_PENDING ||
 	    (timr->it_sigev_notify & ~SIGEV_THREAD_ID) == SIGEV_NONE))
-		timr->it_overrun += hrtimer_forward(timer, now, iv);
+		timr->it_overrun += (unsigned int) hrtimer_forward(timer, now, iv);
 
 	remaining = ktime_sub(timer->expires, now);
 	/* Return 0 only, when the timer is expired and not pending */
_

Patches currently in -mm which might be from davidel@xmailserver.org are

__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
timerfd-v3-new-timerfd-api.patch
timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64.patch
timerfd-v3-new-timerfd-api-ia64-fix.patch
timerfd-v3-new-timerfd-api-m68k-fix.patch
timerfd-v3-new-timerfd-api-mips-fix.patch
timerfd-v3-new-timerfd-api-arch-fixes.patch
timerfd-v3-new-timerfd-api-s390-fix.patch
timerfd-v3-new-timerfd-api-powerpc-fix.patch
timerfd-v3-new-timerfd-api-sparc64-fix.patch
timerfd-v3-new-timerfd-api-update-sys_nic-with-the-new-timerfd-syscalls.patch
timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch
timerfd-v3-un-break-config_timerfd.patch
timerfd-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration.patch
git-kvm.patch
use-wake_up_locked-in-eventpoll.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
fix-group-stop-with-exit-race.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
