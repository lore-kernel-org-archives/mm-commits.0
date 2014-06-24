From: akpm@linux-foundation.org
Subject: [merged]
 kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch
 removed from -mm tree
Date: Tue, 24 Jun 2014 12:02:33 -0700
Message-ID: <53a9cb49.jmgV0XC3S8A9URAV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaFXTCe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Jun 2014 15:02:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: atomlin@redhat.com, davem@davemloft.net, dzickus@redhat.com, mguzik@redhat.com, mq@suse.cz, oleg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/watchdog.c: print traces for all cpus on lockup detection
has been removed from the -mm tree.  Its filename was
     kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Aaron Tomlin <atomlin@redhat.com>
Subject: kernel/watchdog.c: print traces for all cpus on lockup detection

A 'softlockup' is defined as a bug that causes the kernel to loop in
kernel mode for more than a predefined period to time, without giving
other tasks a chance to run.

Currently, upon detection of this condition by the per-cpu watchdog task,
debug information (including a stack trace) is sent to the system log.

On some occasions, we have observed that the "victim" rather than the
actual "culprit" (i.e.  the owner/holder of the contended resource) is
reported to the user.  Often this information has proven to be
insufficient to assist debugging efforts.

To avoid loss of useful debug information, for architectures which support
NMI, this patch makes it possible to improve soft lockup reporting.  This
is accomplished by issuing an NMI to each cpu to obtain a stack trace.

If NMI is not supported we just revert back to the old method.  A sysctl
and boot-time parameter is available to toggle this feature.

[dzickus@redhat.com: add CONFIG_SMP in certain areas]
[akpm@linux-foundation.org: additional CONFIG_SMP=n optimisations]
[mq@suse.cz: fix warning]
Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Mateusz Guzik <mguzik@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jan Moskyto Matejka <mq@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    5 +++
 Documentation/sysctl/kernel.txt     |   17 +++++++++++
 include/linux/nmi.h                 |    1 
 kernel/sysctl.c                     |   11 +++++++
 kernel/watchdog.c                   |   39 ++++++++++++++++++++++++++
 5 files changed, 73 insertions(+)

diff -puN Documentation/kernel-parameters.txt~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection
+++ a/Documentation/kernel-parameters.txt
@@ -3130,6 +3130,11 @@ bytes respectively. Such letter suffixes
 			[KNL] Should the soft-lockup detector generate panics.
 			Format: <integer>
 
+	softlockup_all_cpu_backtrace=
+			[KNL] Should the soft-lockup detector generate
+			backtraces on all cpus.
+			Format: <integer>
+
 	sonypi.*=	[HW] Sony Programmable I/O Control Device driver
 			See Documentation/laptops/sonypi.txt
 
diff -puN Documentation/sysctl/kernel.txt~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection
+++ a/Documentation/sysctl/kernel.txt
@@ -75,6 +75,7 @@ show up in /proc/sys/kernel:
 - shmall
 - shmmax                      [ sysv ipc ]
 - shmmni
+- softlockup_all_cpu_backtrace
 - stop-a                      [ SPARC only ]
 - sysrq                       ==> Documentation/sysrq.txt
 - sysctl_writes_strict
@@ -783,6 +784,22 @@ via the /proc/sys interface:
 
 ==============================================================
 
+softlockup_all_cpu_backtrace:
+
+This value controls the soft lockup detector thread's behavior
+when a soft lockup condition is detected as to whether or not
+to gather further debug information. If enabled, each cpu will
+be issued an NMI and instructed to capture stack trace.
+
+This feature is only applicable for architectures which support
+NMI.
+
+0: do nothing. This is the default behavior.
+
+1: on detection capture more debug information.
+
+==============================================================
+
 tainted:
 
 Non-zero if the kernel has been tainted.  Numeric values, which
diff -puN include/linux/nmi.h~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection include/linux/nmi.h
--- a/include/linux/nmi.h~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection
+++ a/include/linux/nmi.h
@@ -57,6 +57,7 @@ int hw_nmi_is_cpu_stuck(struct pt_regs *
 u64 hw_nmi_get_sample_period(int watchdog_thresh);
 extern int watchdog_user_enabled;
 extern int watchdog_thresh;
+extern int sysctl_softlockup_all_cpu_backtrace;
 struct ctl_table;
 extern int proc_dowatchdog(struct ctl_table *, int ,
 			   void __user *, size_t *, loff_t *);
diff -puN kernel/sysctl.c~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection kernel/sysctl.c
--- a/kernel/sysctl.c~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection
+++ a/kernel/sysctl.c
@@ -860,6 +860,17 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#ifdef CONFIG_SMP
+	{
+		.procname	= "softlockup_all_cpu_backtrace",
+		.data		= &sysctl_softlockup_all_cpu_backtrace,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+#endif /* CONFIG_SMP */
 	{
 		.procname       = "nmi_watchdog",
 		.data           = &watchdog_user_enabled,
diff -puN kernel/watchdog.c~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection kernel/watchdog.c
--- a/kernel/watchdog.c~kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection
+++ a/kernel/watchdog.c
@@ -31,6 +31,12 @@
 
 int watchdog_user_enabled = 1;
 int __read_mostly watchdog_thresh = 10;
+#ifdef CONFIG_SMP
+int __read_mostly sysctl_softlockup_all_cpu_backtrace;
+#else
+#define sysctl_softlockup_all_cpu_backtrace 0
+#endif
+
 static int __read_mostly watchdog_running;
 static u64 __read_mostly sample_period;
 
@@ -47,6 +53,7 @@ static DEFINE_PER_CPU(bool, watchdog_nmi
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static DEFINE_PER_CPU(struct perf_event *, watchdog_ev);
 #endif
+static unsigned long soft_lockup_nmi_warn;
 
 /* boot commands */
 /*
@@ -95,6 +102,15 @@ static int __init nosoftlockup_setup(cha
 }
 __setup("nosoftlockup", nosoftlockup_setup);
 /*  */
+#ifdef CONFIG_SMP
+static int __init softlockup_all_cpu_backtrace_setup(char *str)
+{
+	sysctl_softlockup_all_cpu_backtrace =
+		!!simple_strtol(str, NULL, 0);
+	return 1;
+}
+__setup("softlockup_all_cpu_backtrace=", softlockup_all_cpu_backtrace_setup);
+#endif
 
 /*
  * Hard-lockup warnings should be triggered after just a few seconds. Soft-
@@ -271,6 +287,7 @@ static enum hrtimer_restart watchdog_tim
 	unsigned long touch_ts = __this_cpu_read(watchdog_touch_ts);
 	struct pt_regs *regs = get_irq_regs();
 	int duration;
+	int softlockup_all_cpu_backtrace = sysctl_softlockup_all_cpu_backtrace;
 
 	/* kick the hardlockup detector */
 	watchdog_interrupt_count();
@@ -317,6 +334,17 @@ static enum hrtimer_restart watchdog_tim
 		if (__this_cpu_read(soft_watchdog_warn) == true)
 			return HRTIMER_RESTART;
 
+		if (softlockup_all_cpu_backtrace) {
+			/* Prevent multiple soft-lockup reports if one cpu is already
+			 * engaged in dumping cpu back traces
+			 */
+			if (test_and_set_bit(0, &soft_lockup_nmi_warn)) {
+				/* Someone else will report us. Let's give up */
+				__this_cpu_write(soft_watchdog_warn, true);
+				return HRTIMER_RESTART;
+			}
+		}
+
 		printk(KERN_EMERG "BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
@@ -327,6 +355,17 @@ static enum hrtimer_restart watchdog_tim
 		else
 			dump_stack();
 
+		if (softlockup_all_cpu_backtrace) {
+			/* Avoid generating two back traces for current
+			 * given that one is already made above
+			 */
+			trigger_allbutself_cpu_backtrace();
+
+			clear_bit(0, &soft_lockup_nmi_warn);
+			/* Barrier to sync with other cpus */
+			smp_mb__after_atomic();
+		}
+
 		if (softlockup_panic)
 			panic("softlockup: hung tasks");
 		__this_cpu_write(soft_watchdog_warn, true);
_

Patches currently in -mm which might be from atomlin@redhat.com are

origin.patch

