From: akpm@linux-foundation.org
Subject: + x86_64-prep-idle-loop-for-dynticks.patch added to -mm tree
Date: Fri, 24 Aug 2007 15:05:17 -0700
Message-ID: <200708242205.l7OM5HAX017026@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56215 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759558AbXHXWGX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Aug 2007 18:06:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisw@sous-sol.org, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86_64: prepare idle loop for dynamic ticks
has been added to the -mm tree.  Its filename is
     x86_64-prep-idle-loop-for-dynticks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: prepare idle loop for dynamic ticks
From: Chris Wright <chrisw@sous-sol.org>

Add tick_nohz_{stop,restart}_sched_tick to idle loop in prepartion for turning
on dynticks.  These are just noops until NO_HZ is enabled.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@suse.de>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/process.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN arch/x86_64/kernel/process.c~x86_64-prep-idle-loop-for-dynticks arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c~x86_64-prep-idle-loop-for-dynticks
+++ a/arch/x86_64/kernel/process.c
@@ -38,6 +38,7 @@
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -208,6 +209,8 @@ void cpu_idle (void)
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
+			tick_nohz_stop_sched_tick();
+
 			check_pgt_cache();
 			rmb();
 			idle = pm_idle;
@@ -229,6 +232,7 @@ void cpu_idle (void)
 			__exit_idle();
 		}
 
+		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

origin.patch
x86_64-consolidate-tsc-calibration.patch
i386-prepare-sharing-hpet-code.patch
i386-prepare-sharing-pit-code.patch
x86_64-use-i386-i8253-h.patch
x86_64-preparatory-apic-set-lvtt.patch
x86_64-apic-remove-bogus-pit-synchronization.patch
x86_64-apic-shuffle-calibration-around.patch
x86_64-apic-calibration-remove-divisor.patch
x86_64-apic-change-setup-calling-convention.patch
x86_64-apic-remove-nested-irq-disable.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-apic-add-clockevents-functions.patch
x86_64-convert-to-clockevents.patch
x86_64-remove-unused-code.patch
x86_64-cleanup-apic-c.patch
jiffies-remove-unused-macros.patch
i386-pit-remove-the-useless-ifdefs.patch
i386-hpet-sharing-optimize.patch
security-convert-lsm-into-a-static-interface.patch
security-convert-lsm-into-a-static-interface-fix.patch
security-convert-lsm-into-a-static-interface-fix-2.patch
security-convert-lsm-into-a-static-interface-fix-2-fix.patch
security-convert-lsm-into-a-static-interface-fix-unionfs.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
file-capabilities-introduce-cap_setfcap.patch
file-capabilities-get_file_caps-cleanups.patch
file-caps-update-selinux-xattr-hooks.patch
file-capabilities-clear-caps-cleanup.patch
file-capabilities-clear-caps-cleanup-fix.patch
file-capabilities-change-xattr-format-v2.patch
file-capabilities-change-fe-to-a-bool.patch
file-caps-clean-up-for-linux-capabilityh.patch
capabilityh-remove-include-of-currenth.patch
file-capabilities-clear-fcaps-on-inode-change.patch
security-cleanups.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
whitespace-fixes-capability-syscalls.patch
