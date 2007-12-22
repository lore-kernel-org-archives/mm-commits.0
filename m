From: akpm@linux-foundation.org
Subject: + timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration.patch added to -mm tree
Date: Sat, 22 Dec 2007 01:50:32 -0800
Message-ID: <200712220950.lBM9oW3c027219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50565 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750825AbXLVJvB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 22 Dec 2007 04:51:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, mingo@elte.hu, mtk-manpages@gmx.net, tglx@linutronix.de


The patch titled
     timerfd: make the returned time to be the remaining time till the next expiration
has been added to the -mm tree.  Its filename is
     timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timerfd: make the returned time to be the remaining time till the next expiration
From: Davide Libenzi <davidel@xmailserver.org>

Make the returned time to be the remaining time till the next expiration.  If
the timer is already expired, and there's no next expiration, zero will be
returned.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/timerfd.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff -puN fs/timerfd.c~timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration fs/timerfd.c
--- a/fs/timerfd.c~timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration
+++ a/fs/timerfd.c
@@ -49,6 +49,15 @@ static enum hrtimer_restart timerfd_tmrp
 	return HRTIMER_NORESTART;
 }
 
+static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx) {
+	ktime_t now, remaining;
+
+	now = ctx->tmr.base->get_time();
+	remaining = ktime_sub(ctx->tmr.expires, now);
+
+	return remaining.tv64 < 0 ? ktime_set(0, 0): remaining;
+}
+
 static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
 			  const struct itimerspec *ktmr)
 {
@@ -240,7 +249,7 @@ asmlinkage long sys_timerfd_settime(int 
 	if (ctx->expired && ctx->tintv.tv64)
 		hrtimer_forward_now(&ctx->tmr, ctx->tintv);
 
-	kotmr.it_value = ktime_to_timespec(ctx->tmr.expires);
+	kotmr.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
 	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
 
 	/*
@@ -274,7 +283,7 @@ asmlinkage long sys_timerfd_gettime(int 
 			hrtimer_forward_now(&ctx->tmr, ctx->tintv) - 1;
 		hrtimer_restart(&ctx->tmr);
 	}
-	kotmr.it_value = ktime_to_timespec(ctx->tmr.expires);
+	kotmr.it_value = ktime_to_timespec(timerfd_get_remaining(ctx));
 	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
 	spin_unlock_irq(&ctx->wqh.lock);
 	fput(file);
_

Patches currently in -mm which might be from davidel@xmailserver.org are

__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
timerfd-v3-new-timerfd-api.patch
timerfd-v3-new-timerfd-api-make-hrtimer_forward-to-return-a-u64.patch
timerfd-v3-new-timerfd-api-make-the-returned-time-to-be-the-remaining-time-till-the-next-expiration.patch
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
