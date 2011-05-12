From: akpm@linux-foundation.org
Subject: [wrecked] msm-timer-migrate-to-timer-based-__delay.patch removed from -mm tree
Date: Thu, 12 May 2011 13:08:41 -0700
Message-ID: <201105122045.p4CKj9Z8000328@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758559Ab1ELUpn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 12 May 2011 16:45:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, mm-commits@vger.kernel.org


The patch titled
     msm: timer: migrate to timer based __delay()
has been removed from the -mm tree.  Its filename was
     msm-timer-migrate-to-timer-based-__delay.patch

This patch was dropped because other changes were merged, which wrecked this patch

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
@@ -116,6 +116,12 @@ static struct msm_clock *clockevent_to_c
 #endif
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
@@ -146,6 +152,12 @@ static void msm_timer_set_mode(enum cloc
 	}
 }
 
+static void msm_timer_set_mode_nop(enum clock_event_mode mode,
+				struct clock_event_device *evt)
+{
+	/* The timer is always ticking so do nothing */
+}
+
 static struct msm_clock msm_clocks[] = {
 	[MSM_CLOCK_GPT] = {
 		.clockevent = {
@@ -179,7 +191,7 @@ static struct msm_clock msm_clocks[] = {
 			.shift          = 32 + MSM_DGT_SHIFT,
 			.rating         = 300,
 			.set_next_event = msm_timer_set_next_event,
-			.set_mode       = msm_timer_set_mode,
+			.set_mode       = msm_timer_set_mode_nop,
 		},
 		.clocksource = {
 			.name           = "dg_timer",
@@ -260,6 +272,8 @@ static void __init msm_timer_init(void)
 
 		clockevents_register_device(ce);
 	}
+	writel(TIMER_ENABLE_EN, MSM_DGT_BASE + TIMER_ENABLE);
+	set_delay_fn(read_current_timer_delay_loop);
 }
 
 #ifdef CONFIG_SMP
_

Patches currently in -mm which might be from sboyd@codeaurora.org are

linux-next.patch
lib-consolidate-debug_per_cpu_maps.patch
lib-consolidate-debug_stack_usage-option.patch

