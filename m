From: akpm@linux-foundation.org
Subject: - clocksource-avr32-initialize-list-value.patch removed from -mm tree
Date: Thu, 05 Apr 2007 12:28:48 -0700
Message-ID: <200704051928.l35JSmKk024035@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49072 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767232AbXDETcB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 5 Apr 2007 15:32:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, hskinnemoen@atmel.com, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: avr32 initialize list value
has been removed from the -mm tree.  Its filename was
     clocksource-avr32-initialize-list-value.patch

This patch was dropped because of general bunfight

------------------------------------------------------
Subject: clocksource: avr32 initialize list value
From: Daniel Walker <dwalker@mvista.com>

Update arch/avre32/ with list initialization.

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/avr32/kernel/time.c         |    1 +
 arch/avr32/mach-at32ap/time-tc.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN arch/avr32/kernel/time.c~clocksource-avr32-initialize-list-value arch/avr32/kernel/time.c
--- a/arch/avr32/kernel/time.c~clocksource-avr32-initialize-list-value
+++ a/arch/avr32/kernel/time.c
@@ -45,6 +45,7 @@ struct clocksource __weak clocksource_av
 	.mask		= CLOCKSOURCE_MASK(32),
 	.shift		= 16,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_avr32.list),
 };
 
 irqreturn_t __weak timer_interrupt(int irq, void *dev_id);
diff -puN arch/avr32/mach-at32ap/time-tc.c~clocksource-avr32-initialize-list-value arch/avr32/mach-at32ap/time-tc.c
--- a/arch/avr32/mach-at32ap/time-tc.c~clocksource-avr32-initialize-list-value
+++ a/arch/avr32/mach-at32ap/time-tc.c
@@ -50,6 +50,7 @@ struct clocksource clocksource_avr32 = {
 	.mask		= CLOCKSOURCE_MASK(16),
 	.shift		= 16,
 	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
+	.list		= LIST_HEAD_INIT(clocksource_avr32.list),
 };
 
 static void avr32_timer_ack(void)
_

Patches currently in -mm which might be from dwalker@mvista.com are

clocksource-avr32-initialize-list-value.patch
clocksource-mips-initialize-list-value.patch
clocksource-i386-initialize-list-value.patch
clocksource-x86_64-initialize-list-value.patch
clocksource-s390-initialize-list-value.patch
clocksource-driver-initialize-list-value.patch
clocksource-refactor-duplicate-registration-checking.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
