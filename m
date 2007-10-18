From: akpm@linux-foundation.org
Subject: - x86_64-mce-poll-at-idle_start-and-printk-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:08:55 -0700
Message-ID: <200710180708.l9I78thK031857@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759996AbXJRHJE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:09:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: thockin@google.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     x86_64: mce poll at IDLE_START and printk fix
has been removed from the -mm tree.  Its filename was
     x86_64-mce-poll-at-idle_start-and-printk-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: mce poll at IDLE_START and printk fix
From: Tim Hockin <thockin@google.com>

Background:
 The MCE handler already has an idle-task handler which checks for the
 TIF_MCE_NOTIFY flag.  Given that the system is idle at that point, we can
 get even better granularity of MCE logging by polling for MCEs whenever
 we enter the idle loop.  This exposes a small imperfection in the
 printk() rate limiting whereby that last "Events Logged" message might
 not get printed if no more MCEs arrive.

Description:
 This patch extends the MCE idle notifier callback to poll for MCEs on the
 current CPU at IDLE_START time.  It also adds one new static variable to
 track whether any events have been logged since the last printk() and
 causes a printk at the next rate-limited opportunity.

Result:
 MCEs are found more rapidly on systems with bad memory.

Alternatives:
 None.

Testing:
 I used software to inject correctable and uncorrectable errors.  An
 application poll()ing /dev/mcelog gets woken up very quickly after error
 injection.

Signed-off-by: Tim Hockin <thockin@google.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86_64/kernel/mce.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff -puN arch/x86_64/kernel/mce.c~x86_64-mce-poll-at-idle_start-and-printk-fix arch/x86_64/kernel/mce.c
--- a/arch/x86/kernel/mce_64.c~x86_64-mce-poll-at-idle_start-and-printk-fix
+++ a/arch/x86/kernel/mce_64.c
@@ -309,10 +309,10 @@ void do_machine_check(struct pt_regs * r
 		}
 	}
 
+ out:
 	/* notify userspace ASAP */
 	set_thread_flag(TIF_MCE_NOTIFY);
 
- out:
 	/* the last thing we do is clear state */
 	for (i = 0; i < banks; i++)
 		wrmsrl(MSR_IA32_MC0_STATUS+4*i, 0);
@@ -391,30 +391,43 @@ static void mcheck_timer(struct work_str
  */
 int mce_notify_user(void)
 {
+	static int do_printk;
+	int retval = 0;
+
 	clear_thread_flag(TIF_MCE_NOTIFY);
-	if (test_and_clear_bit(0, &notify_user)) {
-		static unsigned long last_print;
-		unsigned long now = jiffies;
 
+	/* notify userspace apps as soon as possible */
+	if (test_and_clear_bit(0, &notify_user)) {
 		wake_up_interruptible(&mce_wait);
 		if (trigger[0])
 			call_usermodehelper(trigger, trigger_argv, NULL,
 						UMH_NO_WAIT);
+		do_printk = 1;
+		retval = 1;
+	}
+
+	/* only log a message periodically */
+	if (do_printk) {
+		static unsigned long last_print;
+		unsigned long now = jiffies;
 
 		if (time_after_eq(now, last_print + (check_interval*HZ))) {
 			last_print = now;
 			printk(KERN_INFO "Machine check events logged\n");
+			do_printk = 0;
 		}
-
-		return 1;
 	}
-	return 0;
+	return retval;
 }
 
-/* see if the idle task needs to notify userspace */
+/* take advantage of idle time to manage MCEs */
 static int
 mce_idle_callback(struct notifier_block *nfb, unsigned long action, void *junk)
 {
+	/* poll for new MCEs on this CPU */
+	if (action == IDLE_START)
+		mcheck_check_cpu(NULL);
+
 	/* IDLE_END should be safe - interrupts are back on */
 	if (action == IDLE_END && test_thread_flag(TIF_MCE_NOTIFY))
 		mce_notify_user();
_

Patches currently in -mm which might be from thockin@google.com are

git-x86.patch
