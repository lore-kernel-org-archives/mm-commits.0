From: akpm@linux-foundation.org
Subject: + fix-hpet-wrong-values.patch added to -mm tree
Date: Tue, 27 Nov 2007 14:19:50 -0800
Message-ID: <200711272219.lARMJoOq002273@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33839 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753245AbXK0WUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Nov 2007 17:20:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, johnstul@us.ibm.com, mingo@elte.hu, pavel@suse.cz, tglx@linutronix.de


The patch titled
     time: fix hpet wrong values
has been added to the -mm tree.  Its filename is
     fix-hpet-wrong-values.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
fix-config_mtd_sharp_sl-if-config_mtd=m-try2.patch
fix-proc-net-breakage.patch
kernel-power-diskc-make-code-static.patch
make-kernel_shutdown_prepare-static.patch
