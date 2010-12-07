From: akpm@linux-foundation.org
Subject: [merged] arch-arm-mach-tegra-timerc-separate-clocksource-and-sched_clock.patch removed from -mm tree
Date: Tue, 07 Dec 2010 11:46:55 -0800
Message-ID: <201012071948.oB7JmUXw004619@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752195Ab0LGTtC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Dec 2010 14:49:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ccross@android.com, johnstul@us.ibm.com, linus.walleij@stericsson.com, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     arch/arm/mach-tegra/timer.c: separate clocksource and sched_clock
has been removed from the -mm tree.  Its filename was
     arch-arm-mach-tegra-timerc-separate-clocksource-and-sched_clock.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/arm/mach-tegra/timer.c: separate clocksource and sched_clock
From: Colin Cross <ccross@android.com>

tegra_clocksource_read should not use cnt32_to_63, wrapping is already
handled in the clocksource code.  Move the cnt32_to_63 into the
sched_clock function, and replace the use of clocksource mult and shift
with a multiplication by 1000 to convert us to ns.

Signed-off-by: Colin Cross <ccross@android.com>
Acked-by: John Stultz <johnstul@us.ibm.com>
Acked-by: Linus Walleij <linus.walleij@stericsson.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-tegra/timer.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff -puN arch/arm/mach-tegra/timer.c~arch-arm-mach-tegra-timerc-separate-clocksource-and-sched_clock arch/arm/mach-tegra/timer.c
--- a/arch/arm/mach-tegra/timer.c~arch-arm-mach-tegra-timerc-separate-clocksource-and-sched_clock
+++ a/arch/arm/mach-tegra/timer.c
@@ -91,7 +91,7 @@ static void tegra_timer_set_mode(enum cl
 
 static cycle_t tegra_clocksource_read(struct clocksource *cs)
 {
-	return cnt32_to_63(timer_readl(TIMERUS_CNTR_1US));
+	return timer_readl(TIMERUS_CNTR_1US);
 }
 
 static struct clock_event_device tegra_clockevent = {
@@ -106,14 +106,13 @@ static struct clocksource tegra_clocksou
 	.name	= "timer_us",
 	.rating	= 300,
 	.read	= tegra_clocksource_read,
-	.mask	= 0x7FFFFFFFFFFFFFFFULL,
+	.mask	= CLOCKSOURCE_MASK(32),
 	.flags	= CLOCK_SOURCE_IS_CONTINUOUS,
 };
 
 unsigned long long sched_clock(void)
 {
-	return clocksource_cyc2ns(tegra_clocksource.read(&tegra_clocksource),
-		tegra_clocksource.mult, tegra_clocksource.shift);
+	return cnt32_to_63(timer_readl(TIMERUS_CNTR_1US)) * 1000;
 }
 
 static irqreturn_t tegra_timer_interrupt(int irq, void *dev_id)
_

Patches currently in -mm which might be from ccross@android.com are

linux-next.patch

