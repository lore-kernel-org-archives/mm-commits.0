From: akpm@linux-foundation.org
Subject: [merged]
 posix-timers-give-lazy-compilers-some-help-optimizing-code-away.patch
 removed from -mm tree
Date: Thu, 15 Dec 2016 10:46:38 -0800
Message-ID: <5852e50e.Xp2UjuYYP3RCMXYA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48778 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755225AbcLOSqw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 15 Dec 2016 13:46:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.pitre@linaro.org, josh@joshtriplett.org, nico@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: posix-timers: give lazy compilers some help optimizing code away
has been removed from the -mm tree.  Its filename was
     posix-timers-give-lazy-compilers-some-help-optimizing-code-away.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from nicolas.pitre@linaro.org are


