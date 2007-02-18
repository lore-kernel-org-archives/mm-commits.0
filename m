From: akpm@linux-foundation.org
Subject: - i386-pit_latch_buggy-has-no-effect.patch removed from -mm tree
Date: Sat, 17 Feb 2007 18:15:42 -0800
Message-ID: <200702180215.l1I2Fg1r008423@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55711 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993123AbXBRCPr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 17 Feb 2007 21:15:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: takada@mbf.nifty.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     i386: pit_latch_buggy has no effect
has been removed from the -mm tree.  Its filename was
     i386-pit_latch_buggy-has-no-effect.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: pit_latch_buggy has no effect
From: takada <takada@mbf.nifty.com>

Eliminated the arch/i386/kernel/timers in 2.6.18, use clocksoures instead. 
pit_latch_buggy was referred in timers/timer_tsc.c, and currently removed. 
Therefore nobody refer it.

Until 2.6.17, MediaGX's TSC works correctly.  after 2.6.18, warned "TSC
appears to be running slowly.  Marking it as unstable".  So marked unstable
TSC when CS55x0.

Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/cpu/cyrix.c |    2 +-
 arch/i386/kernel/time.c      |    2 --
 include/asm-i386/timer.h     |    2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff -puN arch/i386/kernel/cpu/cyrix.c~i386-pit_latch_buggy-has-no-effect arch/i386/kernel/cpu/cyrix.c
--- a/arch/i386/kernel/cpu/cyrix.c~i386-pit_latch_buggy-has-no-effect
+++ a/arch/i386/kernel/cpu/cyrix.c
@@ -279,7 +279,7 @@ static void __cpuinit init_cyrix(struct 
 		 */  
 		if (vendor == PCI_VENDOR_ID_CYRIX &&
 	 (device == PCI_DEVICE_ID_CYRIX_5510 || device == PCI_DEVICE_ID_CYRIX_5520))
-			pit_latch_buggy = 1;
+			mark_tsc_unstable();
 	}
 #endif
 		c->x86_cache_size=16;	/* Yep 16K integrated cache thats it */
diff -puN arch/i386/kernel/time.c~i386-pit_latch_buggy-has-no-effect arch/i386/kernel/time.c
--- a/arch/i386/kernel/time.c~i386-pit_latch_buggy-has-no-effect
+++ a/arch/i386/kernel/time.c
@@ -70,8 +70,6 @@
 
 #include <asm/i8259.h>
 
-int pit_latch_buggy;              /* extern */
-
 #include "do_timer.h"
 
 unsigned int cpu_khz;	/* Detected as we calibrate the TSC */
diff -puN include/asm-i386/timer.h~i386-pit_latch_buggy-has-no-effect include/asm-i386/timer.h
--- a/include/asm-i386/timer.h~i386-pit_latch_buggy-has-no-effect
+++ a/include/asm-i386/timer.h
@@ -5,8 +5,6 @@
 
 #define TICK_SIZE (tick_nsec / 1000)
 void setup_pit_timer(void);
-/* Modifiers for buggy PIT handling */
-extern int pit_latch_buggy;
 extern int timer_ack;
 extern int no_timer_check;
 extern unsigned long long (*custom_sched_clock)(void);
_

Patches currently in -mm which might be from takada@mbf.nifty.com are

origin.patch
