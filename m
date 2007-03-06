From: akpm@linux-foundation.org
Subject: - highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak.patch removed from -mm tree
Date: Tue, 06 Mar 2007 01:38:37 -0800
Message-ID: <200703060938.l269cbwv018142@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59799 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030463AbXCFJis (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 04:38:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@debian.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode tweak
has been removed from the -mm tree.  Its filename was
     highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak.patch

This patch was dropped because it was folded into highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch

------------------------------------------------------
Subject: highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode tweak
From: Andres Salomon <dilinger@debian.org>

And an additional request, just to make it explicit that we should not have
any NO_SOFTIRQ callbacks in the tree; warn if we encounter such a thing.

Signed-off-by: Andres Salomon <dilinger@debian.org>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN kernel/hrtimer.c~highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak kernel/hrtimer.c
--- a/kernel/hrtimer.c~highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak
+++ a/kernel/hrtimer.c
@@ -1131,6 +1131,7 @@ static inline void run_hrtimer_queue(str
 		if (base->softirq_time.tv64 <= timer->expires.tv64)
 			break;
 
+		WARN_ON_ONCE(timer->cb_mode == HRTIMER_CB_IRQSAFE_NO_SOFTIRQ);
 		timer_stats_account_hrtimer(timer);
 
 		fn = timer->function;
_

Patches currently in -mm which might be from dilinger@debian.org are

i386-make-x86_64-tsc-header-require-i386-rather-than-vice-versa.patch
hrtimers-fix-hrtimer_cb_irqsafe_no_softirq-description.patch
hrtimers-hrtimer_clock_base-description-typo.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch
