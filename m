From: akpm@linux-foundation.org
Subject: + watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup.patch added to -mm tree
Date: Thu, 01 Oct 2015 14:20:38 -0700
Message-ID: <560da3a6.mPiJowm6b9FmxKLf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33390 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbbJAVUj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 Oct 2015 17:20:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, atomlin@redhat.com, dzickus@redhat.com, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: perform all-CPU backtrace in case of hard lockup
has been added to the -mm tree.  Its filename is
     watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: kernel/watchdog.c: perform all-CPU backtrace in case of hard lockup

In many cases of hardlockup reports, it's actually not possible to know
why it triggered, because the CPU that got stuck is usually waiting on a
resource (with IRQs disabled) in posession of some other CPU is holding.

IOW, we are often looking at the stacktrace of the victim and not the
actual offender.

Introduce sysctl / cmdline parameter that makes it possible to have
hardlockup detector perform all-CPU backtrace.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Reviewed-by: Aaron Tomlin <atomlin@redhat.com>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++
 Documentation/sysctl/kernel.txt     |   12 +++++++++
 include/linux/nmi.h                 |    1 
 kernel/sysctl.c                     |    9 +++++++
 kernel/watchdog.c                   |   33 ++++++++++++++++++++++----
 5 files changed, 55 insertions(+), 5 deletions(-)

diff -puN Documentation/kernel-parameters.txt~watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup
+++ a/Documentation/kernel-parameters.txt
@@ -1246,6 +1246,11 @@ bytes respectively. Such letter suffixes
 			Format: <unsigned int> such that (rxsize & ~0x1fffc0) == 0.
 			Default: 1024
 
+	hardlockup_all_cpu_backtrace=
+			[KNL] Should the hard-lockup detector generate
+			backtraces on all cpus.
+			Format: <integer>
+
 	hashdist=	[KNL,NUMA] Large hashes allocated during boot
 			are distributed across NUMA nodes.  Defaults on
 			for 64-bit NUMA, off otherwise.
diff -puN Documentation/sysctl/kernel.txt~watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup
+++ a/Documentation/sysctl/kernel.txt
@@ -33,6 +33,7 @@ show up in /proc/sys/kernel:
 - domainname
 - hostname
 - hotplug
+- hardlockup_all_cpu_backtrace
 - hung_task_panic
 - hung_task_check_count
 - hung_task_timeout_secs
@@ -293,6 +294,17 @@ domain names are in general different. F
 see the hostname(1) man page.
 
 ==============================================================
+hardlockup_all_cpu_backtrace:
+
+This value controls the hard lockup detector behavior when a hard
+lockup condition is detected as to whether or not to gather further
+debug information. If enabled, arch-specific all-CPU stack dumping
+will be initiated.
+
+0: do nothing. This is the default behavior.
+
+1: on detection capture more debug information.
+==============================================================
 
 hotplug:
 
diff -puN include/linux/nmi.h~watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup include/linux/nmi.h
--- a/include/linux/nmi.h~watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup
+++ a/include/linux/nmi.h
@@ -73,6 +73,7 @@ extern int watchdog_user_enabled;
 extern int watchdog_thresh;
 extern unsigned long *watchdog_cpumask_bits;
 extern int sysctl_softlockup_all_cpu_backtrace;
+extern int sysctl_hardlockup_all_cpu_backtrace;
 struct ctl_table;
 extern int proc_watchdog(struct ctl_table *, int ,
 			 void __user *, size_t *, loff_t *);
diff -puN kernel/sysctl.c~watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup kernel/sysctl.c
--- a/kernel/sysctl.c~watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup
+++ a/kernel/sysctl.c
@@ -897,6 +897,15 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+	{
+		.procname	= "hardlockup_all_cpu_backtrace",
+		.data		= &sysctl_hardlockup_all_cpu_backtrace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
 #endif /* CONFIG_SMP */
 #endif
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86)
diff -puN kernel/watchdog.c~watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup kernel/watchdog.c
--- a/kernel/watchdog.c~watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup
+++ a/kernel/watchdog.c
@@ -57,8 +57,10 @@ int __read_mostly watchdog_thresh = 10;
 
 #ifdef CONFIG_SMP
 int __read_mostly sysctl_softlockup_all_cpu_backtrace;
+int __read_mostly sysctl_hardlockup_all_cpu_backtrace;
 #else
 #define sysctl_softlockup_all_cpu_backtrace 0
+#define sysctl_hardlockup_all_cpu_backtrace 0
 #endif
 static struct cpumask watchdog_cpumask __read_mostly;
 unsigned long *watchdog_cpumask_bits = cpumask_bits(&watchdog_cpumask);
@@ -112,6 +114,7 @@ static unsigned long soft_lockup_nmi_war
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
 static int hardlockup_panic =
 			CONFIG_BOOTPARAM_HARDLOCKUP_PANIC_VALUE;
+static unsigned long hardlockup_allcpu_dumped;
 /*
  * We may not want to enable hard lockup detection by default in all cases,
  * for example when running the kernel as a guest on a hypervisor. In these
@@ -173,6 +176,13 @@ static int __init softlockup_all_cpu_bac
 	return 1;
 }
 __setup("softlockup_all_cpu_backtrace=", softlockup_all_cpu_backtrace_setup);
+static int __init hardlockup_all_cpu_backtrace_setup(char *str)
+{
+	sysctl_hardlockup_all_cpu_backtrace =
+		!!simple_strtol(str, NULL, 0);
+	return 1;
+}
+__setup("hardlockup_all_cpu_backtrace=", hardlockup_all_cpu_backtrace_setup);
 #endif
 
 /*
@@ -318,17 +328,30 @@ static void watchdog_overflow_callback(s
 	 */
 	if (is_hardlockup()) {
 		int this_cpu = smp_processor_id();
+		struct pt_regs *regs = get_irq_regs();
 
 		/* only print hardlockups once */
 		if (__this_cpu_read(hard_watchdog_warn) == true)
 			return;
 
-		if (hardlockup_panic)
-			panic("Watchdog detected hard LOCKUP on cpu %d",
-			      this_cpu);
+		pr_emerg("Watchdog detected hard LOCKUP on cpu %d", this_cpu);
+		print_modules();
+		print_irqtrace_events(current);
+		if (regs)
+			show_regs(regs);
 		else
-			WARN(1, "Watchdog detected hard LOCKUP on cpu %d",
-			     this_cpu);
+			dump_stack();
+
+		/*
+		 * Perform all-CPU dump only once to avoid multiple hardlockups
+		 * generating interleaving traces
+		 */
+		if (sysctl_hardlockup_all_cpu_backtrace &&
+				!test_and_set_bit(0, &hardlockup_allcpu_dumped))
+			trigger_allbutself_cpu_backtrace();
+
+		if (hardlockup_panic)
+			panic("Hard LOCKUP");
 
 		__this_cpu_write(hard_watchdog_warn, true);
 		return;
_

Patches currently in -mm which might be from jkosina@suse.cz are

watchdog-perform-all-cpu-backtrace-in-case-of-hard-lockup.patch

