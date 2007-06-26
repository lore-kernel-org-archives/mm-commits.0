From: akpm@linux-foundation.org
Subject: + x86_64-prep-idle-loop-for-dynticks.patch added to -mm tree
Date: Mon, 25 Jun 2007 17:08:12 -0700
Message-ID: <200706260008.l5Q08CkK014482@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43607 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbXFZAPR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 25 Jun 2007 20:15:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chrisw@sous-sol.org, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de


The patch titled
     x86_64: prep idle loop for dynticks
has been added to the -mm tree.  Its filename is
     x86_64-prep-idle-loop-for-dynticks.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: x86_64: prep idle loop for dynticks
From: Chris Wright <chrisw@sous-sol.org>

Add tick_nohz_{stop,restart}_sched_tick to idle loop in prepartion for turning
on dynticks.  These are just noops until NO_HZ is enabled in next patch.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: john stultz <johnstul@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/process.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN arch/x86_64/kernel/process.c~x86_64-prep-idle-loop-for-dynticks arch/x86_64/kernel/process.c
--- a/arch/x86_64/kernel/process.c~x86_64-prep-idle-loop-for-dynticks
+++ a/arch/x86_64/kernel/process.c
@@ -37,6 +37,7 @@
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -207,6 +208,8 @@ void cpu_idle (void)
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
+			tick_nohz_stop_sched_tick();
+
 			check_pgt_cache();
 			rmb();
 			idle = pm_idle;
@@ -228,6 +231,7 @@ void cpu_idle (void)
 			__exit_idle();
 		}
 
+		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

ntp-move-the-cmos-update-code-into-ntpc.patch
i386-hpet-assumes-boot-cpu-is-0.patch
x86_64-untangle-asm-hpeth-from-asm-timexh.patch
x86_64-use-generic-cmos-update.patch
x86_64-convert-to-cleckevents.patch
x86_64-restore-restore-nohpet-cmdline.patch
x86_64-prep-idle-loop-for-dynticks.patch
x86_64-enable-high-resolution-timers-and-dynticks.patch
implement-file-posix-capabilities.patch
implement-file-posix-capabilities-fix.patch
user-namespace-add-the-framework.patch
user-namespace-add-unshare.patch
