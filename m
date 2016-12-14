From: akpm@linux-foundation.org
Subject: [patch 045/114] posix-timers: give lazy compilers some help
 optimizing code away
Date: Wed, 14 Dec 2016 15:06:13 -0800
Message-ID: <5851d065.K3xLafFrtkiasr/l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34802 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754615AbcLNXGY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 14 Dec 2016 18:06:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, nicolas.pitre@linaro.org, josh@joshtriplett.org, nico@linaro.org, tglx@linutronix.de

From: Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: posix-timers: give lazy compilers some help optimizing code away

The OpenRISC compiler (so far) fails to optimize away a large portion
of code containing a reference to posix_timer_event in alarmtimer.c when
CONFIG_POSIX_TIMERS is unset. Let's give it a direct clue to let the build
succeed.

This fixes
[linux-next:master 6682/7183] alarmtimer.c:undefined reference to `posix_timer_event'
reported by kbuild test robot.

Signed-off-by: Nicolas Pitre <nico@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Josh Triplett <josh@joshtriplett.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/time/alarmtimer.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/time/alarmtimer.c~posix-timers-give-lazy-compilers-some-help-optimizing-code-away kernel/time/alarmtimer.c
--- a/kernel/time/alarmtimer.c~posix-timers-give-lazy-compilers-some-help-optimizing-code-away
+++ a/kernel/time/alarmtimer.c
@@ -516,7 +516,8 @@ static enum alarmtimer_restart alarm_han
 
 	spin_lock_irqsave(&ptr->it_lock, flags);
 	if ((ptr->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE) {
-		if (posix_timer_event(ptr, 0) != 0)
+		if (IS_ENABLED(CONFIG_POSIX_TIMERS) &&
+		    posix_timer_event(ptr, 0) != 0)
 			ptr->it_overrun++;
 	}
 
_
