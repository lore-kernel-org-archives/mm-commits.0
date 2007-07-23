From: akpm@linux-foundation.org
Subject: - i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch removed from -mm tree
Date: Mon, 23 Jul 2007 02:34:13 -0700
Message-ID: <200707230934.l6N9YDC9016364@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49679 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757468AbXGWJfb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 23 Jul 2007 05:35:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386: PIT stop only, when in periodic or oneshot mode
has been removed from the -mm tree.  Its filename was
     i386-pit-stop-only-when-in-periodic-or-oneshot-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: PIT stop only, when in periodic or oneshot mode
From: Thomas Gleixner <tglx@linutronix.de>

The patch is necessary on one of my boxen, where programming the stop
sequence twice leads to PIT malfunction.

Sigh !

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/i8253.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN arch/i386/kernel/i8253.c~i386-pit-stop-only-when-in-periodic-or-oneshot-mode arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~i386-pit-stop-only-when-in-periodic-or-oneshot-mode
+++ a/arch/i386/kernel/i8253.c
@@ -47,9 +47,12 @@ static void init_pit_timer(enum clock_ev
 
 	case CLOCK_EVT_MODE_SHUTDOWN:
 	case CLOCK_EVT_MODE_UNUSED:
-		outb_p(0x30, PIT_MODE);
-		outb_p(0, PIT_CH0);	/* LSB */
-		outb_p(0, PIT_CH0);	/* MSB */
+		if (evt->mode == CLOCK_EVT_MODE_PERIODIC ||
+		    evt->mode == CLOCK_EVT_MODE_ONESHOT) {
+			outb_p(0x30, PIT_MODE);
+			outb_p(0, PIT_CH0);
+			outb_p(0, PIT_CH0);
+		}
 		break;
 
 	case CLOCK_EVT_MODE_ONESHOT:
_

Patches currently in -mm which might be from tglx@linutronix.de are

git-acpi.patch
acpi-move-timer-broadcast-and-pmtimer-access-before-c3-arbiter-shutdown.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
acpi-remove-the-useless-ifdef-code.patch
x86_64-hpet-restore-vread.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-block-irq-balancing-for-timer.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
x86_64-dynticks-disable-hpet_id_legsup-hpets.patch
geode-mfgpt-clock-event-device-support.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
