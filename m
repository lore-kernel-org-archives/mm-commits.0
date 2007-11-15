From: akpm@linux-foundation.org
Subject: - crisv10-fix-timer-interrupt-parameters.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:12:08 -0800
Message-ID: <200711152112.lAFLC82J015840@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52121 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760560AbXKOVRG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:17:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jesper.nilsson@axis.com, mikael.starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     CRISv10: fix timer interrupt parameters
has been removed from the -mm tree.  Its filename was
     crisv10-fix-timer-interrupt-parameters.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: CRISv10: fix timer interrupt parameters
From: Jesper Nilsson <jesper.nilsson@axis.com>

Fix timer interrupt parameters for CRIS v10.

- irq_handler_t only takes two arguments, use get_irq_regs to get
  regs for profiling.
- Call update_process_times.
- Remove CVS tag.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Mikael Starvik <mikael.starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v10/kernel/time.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff -puN arch/cris/arch-v10/kernel/time.c~crisv10-fix-timer-interrupt-parameters arch/cris/arch-v10/kernel/time.c
--- a/arch/cris/arch-v10/kernel/time.c~crisv10-fix-timer-interrupt-parameters
+++ a/arch/cris/arch-v10/kernel/time.c
@@ -1,5 +1,4 @@
-/* $Id: time.c,v 1.5 2004/09/29 06:12:46 starvik Exp $
- *
+/*
  *  linux/arch/cris/arch-v10/kernel/time.c
  *
  *  Copyright (C) 1991, 1992, 1995  Linus Torvalds
@@ -20,6 +19,7 @@
 #include <asm/io.h>
 #include <asm/delay.h>
 #include <asm/rtc.h>
+#include <asm/irq_regs.h>
 
 /* define this if you need to use print_timestamp */
 /* it will make jiffies at 96 hz instead of 100 hz though */
@@ -201,8 +201,9 @@ static long last_rtc_update = 0;
 extern void cris_do_profile(struct pt_regs *regs);
 
 static inline irqreturn_t
-timer_interrupt(int irq, void *dev_id, struct pt_regs *regs)
+timer_interrupt(int irq, void *dev_id)
 {
+	struct pt_regs *regs = get_irq_regs();
 	/* acknowledge the timer irq */
 
 #ifdef USE_CASCADE_TIMERS
@@ -221,9 +222,11 @@ timer_interrupt(int irq, void *dev_id, s
 #endif
 
 	/* reset watchdog otherwise it resets us! */
-
 	reset_watchdog();
 	
+	/* Update statistics. */
+	update_process_times(user_mode(regs));
+
 	/* call the real timer interrupt handler */
 
 	do_timer(1);
_

Patches currently in -mm which might be from jesper.nilsson@axis.com are

origin.patch
cris-build-fixes-atomich-needs-compilerh.patch
git-mtd.patch
