From: akpm@linux-foundation.org
Subject: - generic-vsyscall-gtod-support-for-generic_time-tidy.patch removed from -mm tree
Date: Fri, 16 Feb 2007 00:18:38 -0800
Message-ID: <200702160818.l1G8IcIb024338@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59540 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751887AbXBPISy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Feb 2007 03:18:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@muc.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     generic-vsyscall-gtod-support-for-generic_time-tidy
has been removed from the -mm tree.  Its filename was
     generic-vsyscall-gtod-support-for-generic_time-tidy.patch

This patch was dropped because it was folded into generic-vsyscall-gtod-support-for-generic_time.patch

------------------------------------------------------
Subject: generic-vsyscall-gtod-support-for-generic_time-tidy
From: Andrew Morton <akpm@osdl.org>

it's a losing battle.

Cc: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@muc.de>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 include/linux/clocksource.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.20-rc6-mm/include/linux/clocksource.h
===================================================================
--- linux-2.6.20-rc6-mm.orig/include/linux/clocksource.h
+++ linux-2.6.20-rc6-mm/include/linux/clocksource.h
@@ -202,7 +202,9 @@ extern void clocksource_change_rating(st
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL
 extern void update_vsyscall(struct timespec *ts, struct clocksource *c);
 #else
-#define update_vsyscall(now, c) do { } while(0)
+static inline void update_vsyscall(struct timespec *ts, struct clocksource *c)
+{
+}
 #endif
 
 #endif /* _LINUX_CLOCKSOURCE_H */

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
vmi-versus-hrtimers.patch
add-a-functions-to-handle-interrupt-affinity-setting.patch
i386-use-gtod-persistent-clock-support.patch
hrtimers-namespace-and-enum-cleanup.patch
hrtimers-cleanup-locking.patch
hrtimers-add-state-tracking.patch
clockevents-i383-drivers.patch
generic-vsyscall-gtod-support-for-generic_time.patch
generic-vsyscall-gtod-support-for-generic_time-tidy.patch
revert-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-split-x86_64-kernel-timec-up-tidy.patch
time-x86_64-split-x86_64-kernel-timec-up-fix.patch
reapply-x86_64-mm-ignore-long-smi-interrupts-in-clock-calibration.patch
time-x86_64-convert-x86_64-to-use-generic_time-fix.patch
time-x86_64-convert-x86_64-to-use-generic_time-tidy.patch
time-x86_64-re-enable-vsyscall-support-for-x86_64-tidy.patch
