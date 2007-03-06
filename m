From: akpm@linux-foundation.org
Subject: - highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch removed from -mm tree
Date: Tue, 06 Mar 2007 01:38:42 -0800
Message-ID: <200703060938.l269cgag018145@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59801 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030470AbXCFJi7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Mar 2007 04:38:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dilinger@debian.org, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix
has been removed from the -mm tree.  Its filename was
     highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch

This patch was dropped because it was folded into highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch

------------------------------------------------------
Subject: highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Andres Salomon <dilinger@debian.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/hrtimer.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN kernel/hrtimer.c~highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix kernel/hrtimer.c
--- a/kernel/hrtimer.c~highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix
+++ a/kernel/hrtimer.c
@@ -1131,7 +1131,9 @@ static inline void run_hrtimer_queue(str
 		if (base->softirq_time.tv64 <= timer->expires.tv64)
 			break;
 
+#ifdef CONFIG_HIGH_RES_TIMERS
 		WARN_ON_ONCE(timer->cb_mode == HRTIMER_CB_IRQSAFE_NO_SOFTIRQ);
+#endif
 		timer_stats_account_hrtimer(timer);
 
 		fn = timer->function;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fix-build-with-config_no_idle_hz=n.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode.patch
highres-do-not-run-the-timer_softirq-after-switching-to-highres-mode-tweak-fix.patch
