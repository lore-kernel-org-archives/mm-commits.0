From: akpm@linux-foundation.org
Subject: + timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch added to -mm tree
Date: Tue, 27 Nov 2007 00:55:46 -0800
Message-ID: <200711270855.lAR8tkgq003572@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50104 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753858AbXK0I4F (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 03:56:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, mtk-manpages@gmx.net, tglx@linutronix.de


The patch titled
     timerfd: introduce a new hrtimer_forward_now() function
has been added to the -mm tree.  Its filename is
     timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -298,6 +298,13 @@ static inline int hrtimer_is_queued(stru
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

timerfd-v3-introduce-a-new-hrtimer_forward_now-function.patch
timerfd-v3-new-timerfd-api.patch
timerfd-v3-wire-the-new-timerfd-api-to-the-x86-family.patch
timerfd-v3-un-break-config_timerfd.patch
git-kvm.patch
use-wake_up_locked-in-eventpoll.patch
fs-signalfdc-should-include-linux-syscallsh.patch
fs-eventfdc-should-include-linux-syscallsh.patch
fs-remove-dead-config-config_has_compat_epoll_event-symbol.patch
