From: akpm@linux-foundation.org
Subject: - timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch removed from -mm tree
Date: Tue, 05 Feb 2008 14:26:37 -0800
Message-ID: <200802052226.m15MQI1F011616@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50012 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758719AbYBEW02 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Feb 2008 17:26:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, mtk-manpages@gmx.net, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     timerfd: introduce a new hrtimer_forward_now() function
has been removed from the -mm tree.  Its filename was
     timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: timerfd: introduce a new hrtimer_forward_now() function
From: Davide Libenzi <davidel@xmailserver.org>

I think that advancing the timer against the timer's current "now" can be a
pretty common usage, so, w/out exposing hrtimer's internals, we add a new
hrtimer_forward_now() function.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk-manpages@gmx.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hrtimer.h |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN include/linux/hrtimer.h~timerfd-v3-introduce-a-new-hrtimer_forward_now-function include/linux/hrtimer.h
--- a/include/linux/hrtimer.h~timerfd-v3-introduce-a-new-hrtimer_forward_now-function
+++ a/include/linux/hrtimer.h
@@ -304,6 +304,13 @@ static inline int hrtimer_is_queued(stru
 extern unsigned long
 hrtimer_forward(struct hrtimer *timer, ktime_t now, ktime_t interval);
 
+/* Forward a hrtimer so it expires after the hrtimer's current now */
+static inline unsigned long hrtimer_forward_now(struct hrtimer *timer,
+						ktime_t interval)
+{
+	return hrtimer_forward(timer, timer->base->get_time(), interval);
+}
+
 /* Precise sleep: */
 extern long hrtimer_nanosleep(struct timespec *rqtp,
 			      struct timespec *rmtp,
_

Patches currently in -mm which might be from davidel@xmailserver.org are

origin.patch
timerfd-fix-remaining-architectures.patch
git-kvm.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
fix-group-stop-with-exit-race.patch
move-the-related-code-from-exit_notify-to-exit_signals.patch
uglify-kill_pid_info-to-fix-kill-vs-exec-race.patch
uglify-while_each_pid_task-to-make-sure-we-dont-count-the-execing-pricess-twice.patch
itimer_real-convert-to-use-struct-pid.patch
