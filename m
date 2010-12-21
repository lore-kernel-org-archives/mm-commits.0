From: akpm@linux-foundation.org
Subject: + msm-timer-migrate-to-timer-based-__delay.patch added to -mm tree
Date: Tue, 21 Dec 2010 14:24:21 -0800
Message-ID: <201012212224.oBLMOLpB029499@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753307Ab0LUWYX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Dec 2010 17:24:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sboyd@codeaurora.org


The patch titled
     msm: timer: migrate to timer based __delay()
has been added to the -mm tree.  Its filename is
     msm-timer-migrate-to-timer-based-__delay.patch

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
Subject: msm: timer: migrate to timer based __delay()
From: Stephen Boyd <sboyd@codeaurora.org>

We have to provide a dummy set_mode for the DGT since we don't want it to
ever turn off.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-msm/include/mach/timex.h |    1 +
 arch/arm/mach-msm/timer.c              |   16 +++++++++++++++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff -puN arch/arm/mach-msm/include/mach/timex.h~msm-timer-migrate-to-timer-based-__delay arch/arm/mach-msm/include/mach/timex.h
--- a/arch/arm/mach-msm/include/mach/timex.h~msm-timer-migrate-to-timer-based-__delay
+++ a/arch/arm/mach-msm/include/mach/timex.h
@@ -17,5 +17,6 @@
 #define __ASM_ARCH_MSM_TIMEX_H
 
 #define CLOCK_TICK_RATE		1000000
+#define ARCH_HAS_READ_CURRENT_TIMER
 
 #endif
diff -puN arch/arm/mach-msm/timer.c~msm-timer-migrate-to-timer-based-__delay arch/arm/mach-msm/timer.c
--- a/arch/arm/mach-msm/timer.c~msm-timer-migrate-to-timer-based-__delay
+++ a/arch/arm/mach-msm/timer.c
@@ -84,6 +84,12 @@ static cycle_t msm_dgt_read(struct clock
 	return readl(MSM_DGT_BASE + TIMER_COUNT_VAL) >> MSM_DGT_SHIFT;
 }
 
+int read_current_timer(unsigned long *timer_val)
+{
+	*timer_val = readl(MSM_DGT_BASE + TIMER_COUNT_VAL);
+	return 0;
+}
+
 static int msm_timer_set_next_event(unsigned long cycles,
 				    struct clock_event_device *evt)
 {
@@ -122,6 +128,12 @@ static void msm_timer_set_mode(enum cloc
 	}
 }
 
+static void msm_timer_set_mode_nop(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	/* The timer is always ticking so do nothing */
+}
+
 static struct msm_clock msm_clocks[] = {
 	{
 		.clockevent = {
@@ -156,7 +168,7 @@ static struct msm_clock msm_clocks[] = {
 			.shift          = 32 + MSM_DGT_SHIFT,
 			.rating         = 300,
 			.set_next_event = msm_timer_set_next_event,
-			.set_mode       = msm_timer_set_mode,
+			.set_mode       = msm_timer_set_mode_nop,
 		},
 		.clocksource = {
 			.name           = "dg_timer",
@@ -215,6 +227,8 @@ static void __init msm_timer_init(void)
 
 		clockevents_register_device(ce);
 	}
+	writel(TIMER_ENABLE_EN, MSM_DGT_BASE + TIMER_ENABLE);
+	set_delay_fn(read_current_timer_delay_loop);
 }
 
 struct sys_timer msm_timer = {
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

arm-translate-delays-into-mostly-c.patch
arm-allow-machines-to-override-__delay.patch
arm-implement-a-timer-based-__delay-loop.patch
msm-timer-migrate-to-timer-based-__delay.patch

