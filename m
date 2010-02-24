From: akpm@linux-foundation.org
Subject: [merged] clocksource-add-argument-to-resume-callback.patch removed from -mm tree
Date: Wed, 24 Feb 2010 11:40:00 -0800
Message-ID: <201002241940.o1OJe0wP016337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55768 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757878Ab0BXTko (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 14:40:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: damm@opensource.se, johnstul@us.ibm.com, lethal@linux-sh.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     clocksource: add argument to resume callback
has been removed from the -mm tree.  Its filename was
     clocksource-add-argument-to-resume-callback.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: clocksource: add argument to resume callback
From: Magnus Damm <damm@opensource.se>

Pass the clocksource as an argument to the clocksource resume callback. 
Needed so we can point out which CMT channel the sh_cmt.c driver shall
resume.

Signed-off-by: Magnus Damm <damm@opensource.se>
Cc: john stultz <johnstul@us.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/time.c     |    2 +-
 arch/x86/kernel/hpet.c      |    2 +-
 arch/x86/kernel/tsc.c       |    2 +-
 include/linux/clocksource.h |    2 +-
 kernel/time/clocksource.c   |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff -puN arch/ia64/kernel/time.c~clocksource-add-argument-to-resume-callback arch/ia64/kernel/time.c
--- a/arch/ia64/kernel/time.c~clocksource-add-argument-to-resume-callback
+++ a/arch/ia64/kernel/time.c
@@ -61,7 +61,7 @@ unsigned long long sched_clock(void)
 
 #ifdef CONFIG_PARAVIRT
 static void
-paravirt_clocksource_resume(void)
+paravirt_clocksource_resume(struct clocksource *cs)
 {
 	if (pv_time_ops.clocksource_resume)
 		pv_time_ops.clocksource_resume();
diff -puN arch/x86/kernel/hpet.c~clocksource-add-argument-to-resume-callback arch/x86/kernel/hpet.c
--- a/arch/x86/kernel/hpet.c~clocksource-add-argument-to-resume-callback
+++ a/arch/x86/kernel/hpet.c
@@ -266,7 +266,7 @@ static void hpet_resume_device(void)
 	force_hpet_resume();
 }
 
-static void hpet_resume_counter(void)
+static void hpet_resume_counter(struct clocksource *cs)
 {
 	hpet_resume_device();
 	hpet_restart_counter();
diff -puN arch/x86/kernel/tsc.c~clocksource-add-argument-to-resume-callback arch/x86/kernel/tsc.c
--- a/arch/x86/kernel/tsc.c~clocksource-add-argument-to-resume-callback
+++ a/arch/x86/kernel/tsc.c
@@ -740,7 +740,7 @@ static cycle_t __vsyscall_fn vread_tsc(v
 }
 #endif
 
-static void resume_tsc(void)
+static void resume_tsc(struct clocksource *cs)
 {
 	clocksource_tsc.cycle_last = 0;
 }
diff -puN include/linux/clocksource.h~clocksource-add-argument-to-resume-callback include/linux/clocksource.h
--- a/include/linux/clocksource.h~clocksource-add-argument-to-resume-callback
+++ a/include/linux/clocksource.h
@@ -172,7 +172,7 @@ struct clocksource {
 	u64 max_idle_ns;
 	unsigned long flags;
 	cycle_t (*vread)(void);
-	void (*resume)(void);
+	void (*resume)(struct clocksource *cs);
 #ifdef CONFIG_IA64
 	void *fsys_mmio;        /* used by fsyscall asm code */
 #define CLKSRC_FSYS_MMIO_SET(mmio, addr)      ((mmio) = (addr))
diff -puN kernel/time/clocksource.c~clocksource-add-argument-to-resume-callback kernel/time/clocksource.c
--- a/kernel/time/clocksource.c~clocksource-add-argument-to-resume-callback
+++ a/kernel/time/clocksource.c
@@ -461,7 +461,7 @@ void clocksource_resume(void)
 
 	list_for_each_entry(cs, &clocksource_list, list)
 		if (cs->resume)
-			cs->resume();
+			cs->resume(cs);
 
 	clocksource_resume_watchdog();
 }
_

Patches currently in -mm which might be from damm@opensource.se are

linux-next.patch

