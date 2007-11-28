From: akpm@linux-foundation.org
Subject: - fix-hpet-wrong-values.patch removed from -mm tree
Date: Wed, 28 Nov 2007 02:45:55 -0800
Message-ID: <200711281045.lASAjt4H028085@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756423AbXK1Kqv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 28 Nov 2007 05:46:51 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, johnstul@us.ibm.com, mingo@elte.hu, pavel@suse.cz, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     time: fix hpet wrong values
has been removed from the -mm tree.  Its filename was
     fix-hpet-wrong-values.patch

This patch was dropped because it had testing failures

------------------------------------------------------
Subject: time: fix hpet wrong values
From: Pavel Machek <pavel@ucw.cz>

If hpet is not enabled in config, its init should not pretend to work,
and people should not try to get time from it.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86/hpet.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-x86/hpet.h~fix-hpet-wrong-values include/asm-x86/hpet.h
--- a/include/asm-x86/hpet.h~fix-hpet-wrong-values
+++ a/include/asm-x86/hpet.h
@@ -81,8 +81,8 @@ extern irqreturn_t hpet_rtc_interrupt(in
 
 #else
 
-static inline int hpet_enable(void) { return 0; }
-static inline unsigned long hpet_readl(unsigned long a) { return 0; }
+static inline int hpet_enable(void) { return -ENODEV; }
+static inline unsigned long hpet_readl(unsigned long a) { BUG(); }
 
 #endif /* CONFIG_HPET_TIMER */
 #endif /* ASM_X86_HPET_H */
_

Patches currently in -mm which might be from pavel@ucw.cz are

git-acpi.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
clean-hungarian-notation-from-timers.patch
timer-cleanups.patch
more-timer-related-cleanups.patch
fix-hpet-wrong-values.patch
fix-hpet-wrong-values-fix.patch
fix-config_mtd_sharp_sl-if-config_mtd=m-try2.patch
fix-proc-net-breakage.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
