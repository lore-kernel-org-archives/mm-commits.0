From: akpm@linux-foundation.org
Subject: - i386-clockevents-fix-breakage-on-geode-cyrix-pit.patch removed from -mm tree
Date: Sun, 25 Mar 2007 17:05:24 -0800
Message-ID: <200703260105.l2Q15O7H008710@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:38534 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933363AbXCZBFm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Mar 2007 21:05:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tglx@linutronix.de, ak@suse.de, jordan.crouse@amd.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     i386: clockevents fix breakage on Geode/Cyrix PIT implementations
has been removed from the -mm tree.  Its filename was
     i386-clockevents-fix-breakage-on-geode-cyrix-pit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386: clockevents fix breakage on Geode/Cyrix PIT implementations
From: Thomas Gleixner <tglx@linutronix.de>

The PIT has no dedicated mode for shut down.  The only way to disable PIT
is to put it into one shot mode.  AMD implementations of PIT on Geode (also
observed on Cyrix) are confused by an "empty" transition from
CLOCK_EVT_MODE_UNUSED to CLOCK_EVT_MODE_SHUTDOWN, which puts the PIT into
one shot mode momentarily.

I realized after staring helpless at the bug report
http://bugzilla.kernel.org/show_bug.cgi?id=8027 for quite a while, that the
only change, which might influence the bogomips calibration, is the above
transition during the PIT initialization.

Avoiding the unnecessary switch to oneshot and later to periodic mode fixes
the weird bogomips value and also the resulting slowness.

The fix is confirmed on OLPC and another Geode based box.

Note: this is unrelated to the Dual Core problem discussed here:
http://lkml.org/lkml/2007/3/17/48

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jordan Crouse <jordan.crouse@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/i8253.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletion(-)

diff -puN arch/i386/kernel/i8253.c~i386-clockevents-fix-breakage-on-geode-cyrix-pit arch/i386/kernel/i8253.c
--- a/arch/i386/kernel/i8253.c~i386-clockevents-fix-breakage-on-geode-cyrix-pit
+++ a/arch/i386/kernel/i8253.c
@@ -47,9 +47,17 @@ static void init_pit_timer(enum clock_ev
 		outb(LATCH >> 8 , PIT_CH0);	/* MSB */
 		break;
 
-	case CLOCK_EVT_MODE_ONESHOT:
+	/*
+	 * Avoid unnecessary state transitions, as it confuses
+	 * Geode / Cyrix based boxen.
+	 */
 	case CLOCK_EVT_MODE_SHUTDOWN:
+		if (evt->mode == CLOCK_EVT_MODE_UNUSED)
+			break;
 	case CLOCK_EVT_MODE_UNUSED:
+		if (evt->mode == CLOCK_EVT_MODE_SHUTDOWN)
+			break;
+	case CLOCK_EVT_MODE_ONESHOT:
 		/* One shot setup */
 		outb_p(0x38, PIT_MODE);
 		udelay(10);
_

Patches currently in -mm which might be from tglx@linutronix.de are

correct-slow-acpi_pm-rating.patch
ntp-avoid-time_offset-overflows.patch
ntp-avoid-time_offset-overflows-fix.patch
git-ieee1394.patch
log-reason-why-tsc-was-marked-unstable.patch
optimize-timespec_trunc.patch
sched-fix-idle-load-balancing-in-softirqd-context.patch
sched-dynticks-idle-load-balancing-v3.patch
mm-only-hrtimers-debug-patch.patch
