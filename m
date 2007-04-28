From: akpm@linux-foundation.org
Subject: - i386-tsc-remove-xtime_locking-around-cpufreq-notifier.patch removed from -mm tree
Date: Sat, 28 Apr 2007 03:55:30 -0700
Message-ID: <200704281055.l3SAtU0V020182@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:43205 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965816AbXD1Kzt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 06:55:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dwalker@mvista.com, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     i386 tsc: remove xtime_lock'ing around cpufreq notifier
has been removed from the -mm tree.  Its filename was
     i386-tsc-remove-xtime_locking-around-cpufreq-notifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: i386 tsc: remove xtime_lock'ing around cpufreq notifier
From: Daniel Walker <dwalker@mvista.com>

The locking of the xtime_lock around the cpu notifier is unessesary now. 
At one time the tsc was used after a frequency change for timekeeping, but
the re-write of timekeeping no longer uses the TSC unless the frequency is
constant.

The variables that are changed in this section of code had also once been
used for timekeeping, but not any longer ..

Signed-off-by: Daniel Walker <dwalker@mvista.com>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/i386/kernel/tsc.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff -puN arch/i386/kernel/tsc.c~i386-tsc-remove-xtime_locking-around-cpufreq-notifier arch/i386/kernel/tsc.c
--- a/arch/i386/kernel/tsc.c~i386-tsc-remove-xtime_locking-around-cpufreq-notifier
+++ a/arch/i386/kernel/tsc.c
@@ -144,13 +144,10 @@ time_cpufreq_notifier(struct notifier_bl
 {
 	struct cpufreq_freqs *freq = data;
 
-	if (val != CPUFREQ_RESUMECHANGE && val != CPUFREQ_SUSPENDCHANGE)
-		write_seqlock_irq(&xtime_lock);
-
 	if (!ref_freq) {
 		if (!freq->old){
 			ref_freq = freq->new;
-			goto end;
+			return 0;
 		}
 		ref_freq = freq->old;
 		loops_per_jiffy_ref = cpu_data[freq->cpu].loops_per_jiffy;
@@ -176,9 +173,6 @@ time_cpufreq_notifier(struct notifier_bl
 			}
 		}
 	}
-end:
-	if (val != CPUFREQ_RESUMECHANGE && val != CPUFREQ_SUSPENDCHANGE)
-		write_sequnlock_irq(&xtime_lock);
 
 	return 0;
 }
_

Patches currently in -mm which might be from dwalker@mvista.com are

origin.patch
git-acpi.patch
sched-consolidate-sched_clock-drift-adjustments.patch
sched-consolidate-sched_clock-drift-adjustments-fix.patch
slim-make-and-config-stuff.patch
profile-likely-unlikely-macros.patch
