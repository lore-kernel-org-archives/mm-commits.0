From: akpm@linux-foundation.org
Subject: - x86_64-prep-idle-loop-for-dynticks.patch removed from -mm tree
Date: Mon, 15 Oct 2007 02:18:13 -0700
Message-ID: <200710150918.l9F9IDux027376@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34175 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757012AbXJOJYM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 05:24:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: chrisw@sous-sol.org, ak@suse.de, johnstul@us.ibm.com, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: prepare idle loop for dynamic ticks
has been removed from the -mm tree.  Its filename was
     x86_64-prep-idle-loop-for-dynticks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 arch/x86_64/kernel/process.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/process.c~x86_64-prep-idle-loop-for-dynticks arch/x86_64/kernel/process.c
--- a/arch/x86/kernel/process_64.c~x86_64-prep-idle-loop-for-dynticks
+++ a/arch/x86/kernel/process_64.c
@@ -38,6 +38,7 @@
 #include <linux/notifier.h>
 #include <linux/kprobes.h>
 #include <linux/kdebug.h>
+#include <linux/tick.h>
 
 #include <asm/uaccess.h>
 #include <asm/pgtable.h>
@@ -197,7 +198,7 @@ static inline void play_dead(void)
  * low exit latency (ie sit in a loop waiting for
  * somebody to say that they'd like to reschedule)
  */
-void cpu_idle (void)
+void cpu_idle(void)
 {
 	current_thread_info()->status |= TS_POLLING;
 	/* endless idle loop with no priority at all */
@@ -208,6 +209,8 @@ void cpu_idle (void)
 			if (__get_cpu_var(cpu_idle_state))
 				__get_cpu_var(cpu_idle_state) = 0;
 
+			tick_nohz_stop_sched_tick();
+
 			rmb();
 			idle = pm_idle;
 			if (!idle)
@@ -228,6 +231,7 @@ void cpu_idle (void)
 			__exit_idle();
 		}
 
+		tick_nohz_restart_sched_tick();
 		preempt_enable_no_resched();
 		schedule();
 		preempt_disable();
_

Patches currently in -mm which might be from chrisw@sous-sol.org are

origin.patch
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
capabilities-reset-current-pdeath_signal-when-increasing-capabilities.patch
security-cleanups.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal.patch
use-erestart_restartblock-if-poll-is-interrupted-by-a-signal-fix.patch
whitespace-fixes-capability-syscalls.patch
