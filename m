From: akpm@linux-foundation.org
Subject: +
 posix-timers-give-lazy-compilers-some-help-optimizing-code-away.patch added to -mm tree
Date: Tue, 29 Nov 2016 15:32:48 -0800
Message-ID: <583e1020.ywWaPZNsbJw+CKeW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50394 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754270AbcK2Xce (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 29 Nov 2016 18:32:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nicolas.pitre@linaro.org, josh@joshtriplett.org, nico@linaro.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: posix-timers: give lazy compilers some help optimizing code away
has been added to the -mm tree.  Its filename is
     posix-timers-give-lazy-compilers-some-help-optimizing-code-away.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/posix-timers-give-lazy-compilers-some-help-optimizing-code-away.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/posix-timers-give-lazy-compilers-some-help-optimizing-code-away.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -483,7 +483,8 @@ static enum alarmtimer_restart alarm_han
 
 	spin_lock_irqsave(&ptr->it_lock, flags);
 	if ((ptr->it_sigev_notify & ~SIGEV_THREAD_ID) != SIGEV_NONE) {
-		if (posix_timer_event(ptr, 0) != 0)
+		if (IS_ENABLED(CONFIG_POSIX_TIMERS) &&
+		    posix_timer_event(ptr, 0) != 0)
 			ptr->it_overrun++;
 	}
 
_

Patches currently in -mm which might be from nicolas.pitre@linaro.org are

posix-timers-give-lazy-compilers-some-help-optimizing-code-away.patch

