From: akpm@linux-foundation.org
Subject: + sysrq-add-show-backtrace-on-all-cpus-function.patch added to -mm tree
Date: Mon, 10 Mar 2008 13:45:52 -0700
Message-ID: <200803102045.m2AKjrOd004651@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50864 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751242AbYCJUsN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Mar 2008 16:48:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: riel@redhat.com, lwoodman@redhat.com, mingo@elte.hu, randy.dunlap@oracle.com


The patch titled
     sysrq: add show-backtrace-on-all-cpus function
has been added to the -mm tree.  Its filename is
     sysrq-add-show-backtrace-on-all-cpus-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sysrq: add show-backtrace-on-all-cpus function
From: Rik van Riel <riel@redhat.com>

SysRQ-P is not always useful on SMP systems, since it usually ends up showing
the backtrace of a CPU that is doing just fine, instead of the backtrace of
the CPU that is having problems.

This patch adds SysRQ show-all-cpus(L), which shows the backtrace of every
active CPU in the system.  It skips idle CPUs because some SMP systems are
just too large and we already know what the backtrace of the idle task looks
like.

Signed-off-by: Rik van Riel <riel@redhat.com>
Randy Dunlap <randy.dunlap@oracle.com>
Cc: <lwoodman@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    2 +
 drivers/char/sysrq.c    |   42 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff -puN Documentation/sysrq.txt~sysrq-add-show-backtrace-on-all-cpus-function Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~sysrq-add-show-backtrace-on-all-cpus-function
+++ a/Documentation/sysrq.txt
@@ -85,6 +85,8 @@ On all -  write a character to /proc/sys
 'k'     - Secure Access Key (SAK) Kills all programs on the current virtual
           console. NOTE: See important comments below in SAK section.
 
+'l'     - Shows a stack backtrace for all active CPUs.
+
 'm'     - Will dump current memory info to your console.
 
 'n'	- Used to make RT tasks nice-able
diff -puN drivers/char/sysrq.c~sysrq-add-show-backtrace-on-all-cpus-function drivers/char/sysrq.c
--- a/drivers/char/sysrq.c~sysrq-add-show-backtrace-on-all-cpus-function
+++ a/drivers/char/sysrq.c
@@ -196,6 +196,44 @@ static struct sysrq_key_op sysrq_showloc
 #define sysrq_showlocks_op (*(struct sysrq_key_op *)0)
 #endif
 
+#ifdef CONFIG_SMP
+static DEFINE_SPINLOCK(show_lock);
+static void showacpu(void *dummy)
+{
+	unsigned long flags;
+
+	/* Idle CPUs have no interesting backtrace. */
+	if (idle_cpu(smp_processor_id()))
+		return;
+
+	spin_lock_irqsave(&show_lock, flags);
+	printk("CPU%d:\n", smp_processor_id());
+	show_stack(NULL, NULL);
+	spin_unlock_irqrestore(&show_lock, flags);
+}
+static void sysrq_showregs_othercpus(struct work_struct *dummy)
+{
+	smp_call_function(showacpu, NULL, 0, 0);
+}
+static DECLARE_WORK(sysrq_showallcpus, sysrq_showregs_othercpus);
+
+static void sysrq_handle_showallcpus(int key, struct tty_struct *tty)
+{
+	struct pt_regs *regs = get_irq_regs();
+	if (regs) {
+		printk("CPU%d:\n", smp_processor_id());
+		show_regs(regs);
+	}
+	schedule_work(&sysrq_showallcpus);
+}
+static struct sysrq_key_op sysrq_showallcpus_op = {
+	.handler	= sysrq_handle_showallcpus,
+	.help_msg	= "aLlcpus",
+	.action_msg	= "Show backtrace of all active CPUs",
+	.enable_mask	= SYSRQ_ENABLE_DUMP,
+};
+#endif
+
 static void sysrq_handle_showregs(int key, struct tty_struct *tty)
 {
 	struct pt_regs *regs = get_irq_regs();
@@ -340,7 +378,11 @@ static struct sysrq_key_op *sysrq_key_ta
 	&sysrq_kill_op,			/* i */
 	NULL,				/* j */
 	&sysrq_SAK_op,			/* k */
+#ifdef CONFIG_SMP
+	&sysrq_showallcpus_op,		/* l */
+#else
 	NULL,				/* l */
+#endif
 	&sysrq_showmem_op,		/* m */
 	&sysrq_unrt_op,			/* n */
 	/* o: This will often be registered as 'Off' at init time */
_

Patches currently in -mm which might be from riel@redhat.com are

vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
sysrq-add-show-backtrace-on-all-cpus-function.patch

