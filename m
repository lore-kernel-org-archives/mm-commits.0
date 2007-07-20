From: akpm@linux-foundation.org
Subject: + softlockup-add-a-proc-tuning-parameter.patch added to -mm tree
Date: Fri, 20 Jul 2007 14:29:53 -0700
Message-ID: <200707202129.l6KLTrhe017379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34158 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832AbXGTVaR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 17:30:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kiran@scalex86.org, mingo@elte.hu, shai@scalex86.org


The patch titled
     softlockup: add a /proc tuning parameter
has been added to the -mm tree.  Its filename is
     softlockup-add-a-proc-tuning-parameter.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: softlockup: add a /proc tuning parameter
From: Ravikiran G Thirumalai <kiran@scalex86.org>

Control the trigger limit for softlockup warnings.  This is useful for
debugging softlockups, by lowering the softlockup_thresh to identify
possible softlockups earlier.

This patch:
1. Adds a sysctl softlockup_thresh with valid values of 1-60s
   (Higher value to disable false positives)
2. Changes the softlockup printk to print the cpu softlockup time

Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    8 ++++++++
 include/linux/sched.h           |    1 +
 kernel/softlockup.c             |    8 +++++---
 kernel/sysctl.c                 |   26 +++++++++++++++++++-------
 4 files changed, 33 insertions(+), 10 deletions(-)

diff -puN Documentation/sysctl/kernel.txt~softlockup-add-a-proc-tuning-parameter Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~softlockup-add-a-proc-tuning-parameter
+++ a/Documentation/sysctl/kernel.txt
@@ -320,6 +320,14 @@ kernel.  This value defaults to SHMMAX.
 
 ==============================================================
 
+softlockup_thresh:
+
+This value can be used to lower the softlockup tolerance
+threshold. The default threshold is 10s.  If a cpu is locked up
+for 10s, the kernel complains.  Valid values are 1-60s.
+
+==============================================================
+
 tainted: 
 
 Non-zero if the kernel has been tainted.  Numeric values, which
diff -puN include/linux/sched.h~softlockup-add-a-proc-tuning-parameter include/linux/sched.h
--- a/include/linux/sched.h~softlockup-add-a-proc-tuning-parameter
+++ a/include/linux/sched.h
@@ -260,6 +260,7 @@ extern void softlockup_tick(void);
 extern void spawn_softlockup_task(void);
 extern void touch_softlockup_watchdog(void);
 extern void touch_all_softlockup_watchdogs(void);
+extern int softlockup_thresh;
 #else
 static inline void softlockup_tick(void)
 {
diff -puN kernel/softlockup.c~softlockup-add-a-proc-tuning-parameter kernel/softlockup.c
--- a/kernel/softlockup.c~softlockup-add-a-proc-tuning-parameter
+++ a/kernel/softlockup.c
@@ -25,6 +25,7 @@ static DEFINE_PER_CPU(unsigned long, pri
 static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
 
 static int did_panic;
+int softlockup_thresh = 10;
 
 static int
 softlock_panic(struct notifier_block *this, unsigned long event, void *ptr)
@@ -106,7 +107,7 @@ void softlockup_tick(void)
 		wake_up_process(per_cpu(watchdog_task, this_cpu));
 
 	/* Warn about unreasonable 10+ seconds delays: */
-	if (now <= (touch_timestamp + 10))
+	if (now <= (touch_timestamp + softlockup_thresh))
 		return;
 
 	regs = get_irq_regs();
@@ -114,8 +115,9 @@ void softlockup_tick(void)
 	per_cpu(print_timestamp, this_cpu) = touch_timestamp;
 
 	spin_lock(&print_lock);
-	printk(KERN_ERR "BUG: soft lockup detected on CPU#%d! [%s:%d]\n",
-			this_cpu, current->comm, current->pid);
+	printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
+			this_cpu, now - touch_timestamp,
+				current->comm, current->pid);
 	if (regs)
 		show_regs(regs);
 	else
diff -puN kernel/sysctl.c~softlockup-add-a-proc-tuning-parameter kernel/sysctl.c
--- a/kernel/sysctl.c~softlockup-add-a-proc-tuning-parameter
+++ a/kernel/sysctl.c
@@ -80,6 +80,12 @@ extern int maps_protect;
 extern int sysctl_stat_interval;
 extern int audit_argv_kb;
 
+/* Constants used for minimum and  maximum */
+static int one = 1;
+static int zero;
+static int sixty = 60;
+static int one_hundred = 100;
+
 /* this is needed for the proc_dointvec_minmax for [fs_]overflow UID and GID */
 static int maxolduid = 65535;
 static int minolduid;
@@ -709,6 +715,19 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_DETECT_SOFTLOCKUP
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "softlockup_thresh",
+		.data		= &softlockup_thresh,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &one,
+		.extra2		= &sixty,
+	},
+#endif
 #ifdef CONFIG_COMPAT
 	{
 		.ctl_name	= KERN_COMPAT_LOG,
@@ -755,13 +774,6 @@ static ctl_table kern_table[] = {
 	{ .ctl_name = 0 }
 };
 
-/* Constants for minimum and maximum testing in vm_table.
-   We use these as one-element integer vectors. */
-static int zero;
-static int two = 2;
-static int one_hundred = 100;
-
-
 static ctl_table vm_table[] = {
 	{
 		.ctl_name	= VM_OVERCOMMIT_MEMORY,
_

Patches currently in -mm which might be from kiran@scalex86.org are

origin.patch
softlockup-add-a-proc-tuning-parameter.patch
slab-leaks3-default-y.patch
