From: akpm@linux-foundation.org
Subject: - sysrq-add-a-show-stacktrace-on-all-cpus-command.patch removed from -mm tree
Date: Mon, 30 Jul 2007 21:51:04 -0700
Message-ID: <200707310451.l6V4p4dB016172@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936099AbXGaEvP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 31 Jul 2007 00:51:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avi@qumranet.com, mm-commits@vger.kernel.org


The patch titled
     sysrq: add a show-stacktrace-on-all-cpus command
has been removed from the -mm tree.  Its filename was
     sysrq-add-a-show-stacktrace-on-all-cpus-command.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
Subject: sysrq: add a show-stacktrace-on-all-cpus command
From: Avi Kivity <avi@qumranet.com>

If a cpu is spinning in the kernel but still responding to interrupts,
pressing sysrq-y will show you where it's spinning.

Signed-off-by: Avi Kivity <avi@qumranet.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/sysrq.c |   24 +++++++++++++++++++++++-
 1 files changed, 23 insertions(+), 1 deletion(-)

diff -puN drivers/char/sysrq.c~sysrq-add-a-show-stacktrace-on-all-cpus-command drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-add-a-show-stacktrace-on-all-cpus-command
+++ a/drivers/char/sysrq.c
@@ -45,6 +45,8 @@ int __read_mostly __sysrq_enabled = 1;
 
 static int __read_mostly sysrq_always_enabled;
 
+static spinlock_t show_stack_lock = SPIN_LOCK_UNLOCKED;
+
 int sysrq_on(void)
 {
 	return __sysrq_enabled || sysrq_always_enabled;
@@ -309,6 +311,26 @@ static struct sysrq_key_op sysrq_unrt_op
 	.enable_mask	= SYSRQ_ENABLE_RTNICE,
 };
 
+static void show_cpu_stack(void *garbage)
+{
+	spin_lock(&show_stack_lock);
+	printk("CPU%d stacktrace:\n", raw_smp_processor_id());
+	dump_stack();
+	sysrq_handle_showregs(0, NULL);
+	spin_unlock(&show_stack_lock);
+}
+
+static void sysrq_show_stacks(int key, struct tty_struct *tty)
+{
+	on_each_cpu(show_cpu_stack, NULL, 0, 1);
+}
+
+static struct sysrq_key_op sysrq_show_stacks_op = {
+	.handler	= sysrq_show_stacks,
+	.help_msg	= "stacktraces-on-all-cpus(Y)",
+	.action_msg	= "Stack traces on all cpus",
+};
+
 /* Key Operations table and lock */
 static DEFINE_SPINLOCK(sysrq_key_table_lock);
 
@@ -356,7 +378,7 @@ static struct sysrq_key_op *sysrq_key_ta
 	&sysrq_showstate_blocked_op,	/* w */
 	/* x: May be registered on ppc/powerpc for xmon */
 	NULL,				/* x */
-	NULL,				/* y */
+	&sysrq_show_stacks_op,		/* y */
 	NULL				/* z */
 };
 
_

Patches currently in -mm which might be from avi@qumranet.com are

origin.patch
ia64-allow-smp_call_function_single-to-current-cpu.patch
git-kvm.patch
cpuid-driver-simplify-smp_call_function_single-call-sequence.patch
msr-driver-simplify-smp_call_function_single-call-sequence.patch
time-simplify-smp_call_function_single-call-sequence.patch
sysrq-add-a-show-stacktrace-on-all-cpus-command.patch
