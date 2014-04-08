From: akpm@linux-foundation.org
Subject: [merged] kernel-panicc-display-reason-at-end-pr_emerg.patch
 removed from -mm tree
Date: Tue, 08 Apr 2014 14:30:41 -0700
Message-ID: <53446a81.JGx+0KV+XuVjd+C/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57017 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756598AbaDHVam (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 Apr 2014 17:30:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fabf@skynet.be

Subject: [merged] kernel-panicc-display-reason-at-end-pr_emerg.patch removed from -mm tree
To: fabf@skynet.be,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 08 Apr 2014 14:30:41 -0700


The patch titled
     Subject: kernel/panic.c: display reason at end + pr_emerg
has been removed from the -mm tree.  Its filename was
     kernel-panicc-display-reason-at-end-pr_emerg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: kernel/panic.c: display reason at end + pr_emerg

Currently, booting without initrd specified on 80x25 screen gives a call
trace followed by atkbd : Spurious ACK.  Original message ("VFS: Unable to
mount root fs") is not available.  Of course this could happen in other
situations...

This patch displays panic reason after call trace which could help lot of
people even if it's not the very last line on screen.

Also, convert all panic.c printk(KERN_EMERG to pr_emerg(

[akpm@linux-foundation.org: missed a couple of pr_ conversions]
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |   13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff -puN kernel/panic.c~kernel-panicc-display-reason-at-end-pr_emerg kernel/panic.c
--- a/kernel/panic.c~kernel-panicc-display-reason-at-end-pr_emerg
+++ a/kernel/panic.c
@@ -100,7 +100,7 @@ void panic(const char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(buf, sizeof(buf), fmt, args);
 	va_end(args);
-	printk(KERN_EMERG "Kernel panic - not syncing: %s\n",buf);
+	pr_emerg("Kernel panic - not syncing: %s\n", buf);
 #ifdef CONFIG_DEBUG_BUGVERBOSE
 	/*
 	 * Avoid nested stack-dumping if a panic occurs during oops processing
@@ -141,7 +141,7 @@ void panic(const char *fmt, ...)
 		 * Delay timeout seconds before rebooting the machine.
 		 * We can't use the "normal" timers since we just panicked.
 		 */
-		printk(KERN_EMERG "Rebooting in %d seconds..", panic_timeout);
+		pr_emerg("Rebooting in %d seconds..", panic_timeout);
 
 		for (i = 0; i < panic_timeout * 1000; i += PANIC_TIMER_STEP) {
 			touch_nmi_watchdog();
@@ -165,7 +165,7 @@ void panic(const char *fmt, ...)
 		extern int stop_a_enabled;
 		/* Make sure the user can actually press Stop-A (L1-A) */
 		stop_a_enabled = 1;
-		printk(KERN_EMERG "Press Stop-A (L1-A) to return to the boot prom\n");
+		pr_emerg("Press Stop-A (L1-A) to return to the boot prom\n");
 	}
 #endif
 #if defined(CONFIG_S390)
@@ -176,6 +176,7 @@ void panic(const char *fmt, ...)
 		disabled_wait(caller);
 	}
 #endif
+	pr_emerg("---[ end Kernel panic - not syncing: %s\n", buf);
 	local_irq_enable();
 	for (i = 0; ; i += PANIC_TIMER_STEP) {
 		touch_softlockup_watchdog();
@@ -276,8 +277,7 @@ unsigned long get_taint(void)
 void add_taint(unsigned flag, enum lockdep_ok lockdep_ok)
 {
 	if (lockdep_ok == LOCKDEP_NOW_UNRELIABLE && __debug_locks_off())
-		printk(KERN_WARNING
-		       "Disabling lock debugging due to kernel taint\n");
+		pr_warn("Disabling lock debugging due to kernel taint\n");
 
 	set_bit(flag, &tainted_mask);
 }
@@ -382,8 +382,7 @@ late_initcall(init_oops_id);
 void print_oops_end_marker(void)
 {
 	init_oops_id();
-	printk(KERN_WARNING "---[ end trace %016llx ]---\n",
-		(unsigned long long)oops_id);
+	pr_warn("---[ end trace %016llx ]---\n", (unsigned long long)oops_id);
 }
 
 /*
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
ufs-sb-mutex-merge-mutex_destroy.patch
ufs-sb-mutex-merge-mutex_destroy-fix.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2.patch
ufs-sb-mutex-merge-mutex_destroy-fix-v2-fix.patch

