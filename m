From: akpm@linux-foundation.org
Subject: +
 =?US-ASCII?Q?kernel-watchdogc-convert-soft-hardlockup-boot-parameters-to-?=
 =?US-ASCII?Q?sysctl-aliases.patch?= added to -mm tree
Date: Thu, 07 May 2020 16:10:20 -0700
Message-ID: <20200507231020.gnlnjuYlm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:48020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726572AbgEGXKX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 7 May 2020 19:10:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gpiccoli@canonical.com, keescook@chromium.org, mcgrof@kernel.org, mm-commits@vger.kernel.org, vbabka@suse.cz, yzaikin@google.com


The patch titled
     Subject: kernel/watchdog.c: convert {soft/hard}lockup boot parameters to sysctl aliases
has been added to the -mm tree.  Its filename is
     kernel-watchdogc-convert-soft-hardlockup-boot-parameters-to-sysctl-aliases.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-watchdogc-convert-soft-hardlockup-boot-parameters-to-sysctl-aliases.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-watchdogc-convert-soft-hardlockup-boot-parameters-to-sysctl-aliases.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Guilherme G. Piccoli" <gpiccoli@canonical.com>
Subject: kernel/watchdog.c: convert {soft/hard}lockup boot parameters to sysctl aliases

After a recent change introduced by Vlastimil's series [0], kernel is
able now to handle sysctl parameters on kernel command line; also, the
series introduced a simple infrastructure to convert legacy boot
parameters (that duplicate sysctls) into sysctl aliases.

This patch converts the watchdog parameters softlockup_panic and
{hard,soft}lockup_all_cpu_backtrace to use the new alias infrastructure.
It fixes the documentation too, since the alias only accepts values 0
or 1, not the full range of integers. We also took the opportunity here
to improve the documentation of the previously converted hung_task_panic
(see the patch series [0]) and put the alias table in alphabetical order.

[0] http://lkml.kernel.org/r/20200427180433.7029-1-vbabka@suse.cz

Link: http://lkml.kernel.org/r/20200507214624.21911-1-gpiccoli@canonical.com
Signed-off-by: Guilherme G. Piccoli <gpiccoli@canonical.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Iurii Zaikin <yzaikin@google.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/kernel-parameters.txt |   10 +--
 fs/proc/proc_sysctl.c                           |    7 +-
 kernel/watchdog.c                               |   38 +++-----------
 3 files changed, 19 insertions(+), 36 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~kernel-watchdogc-convert-soft-hardlockup-boot-parameters-to-sysctl-aliases
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -1435,7 +1435,7 @@
 	hardlockup_all_cpu_backtrace=
 			[KNL] Should the hard-lockup detector generate
 			backtraces on all cpus.
-			Format: <integer>
+			Format: 0 | 1
 
 	hashdist=	[KNL,NUMA] Large hashes allocated during boot
 			are distributed across NUMA nodes.  Defaults on
@@ -1503,7 +1503,7 @@
 
 	hung_task_panic=
 			[KNL] Should the hung task detector generate panics.
-			Format: <integer>
+			Format: 0 | 1
 
 			A value of 1 instructs the kernel to panic when a
 			hung task is detected. The default value is controlled
@@ -4643,9 +4643,9 @@
 
 	softlockup_panic=
 			[KNL] Should the soft-lockup detector generate panics.
-			Format: <integer>
+			Format: 0 | 1
 
-			A nonzero value instructs the soft-lockup detector
+			A value of 1 instructs the soft-lockup detector
 			to panic the machine when a soft-lockup occurs. It is
 			also controlled by the kernel.softlockup_panic sysctl
 			and CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC, which is the
@@ -4654,7 +4654,7 @@
 	softlockup_all_cpu_backtrace=
 			[KNL] Should the soft-lockup detector generate
 			backtraces on all cpus.
-			Format: <integer>
+			Format: 0 | 1
 
 	sonypi.*=	[HW] Sony Programmable I/O Control Device driver
 			See Documentation/admin-guide/laptops/sonypi.rst
--- a/fs/proc/proc_sysctl.c~kernel-watchdogc-convert-soft-hardlockup-boot-parameters-to-sysctl-aliases
+++ a/fs/proc/proc_sysctl.c
@@ -1720,8 +1720,11 @@ struct sysctl_alias {
  * parameter.
  */
 static const struct sysctl_alias sysctl_aliases[] = {
-	{"numa_zonelist_order",		"vm.numa_zonelist_order" },
-	{"hung_task_panic",		"kernel.hung_task_panic" },
+	{"hardlockup_all_cpu_backtrace",	"kernel.hardlockup_all_cpu_backtrace" },
+	{"hung_task_panic",			"kernel.hung_task_panic" },
+	{"numa_zonelist_order",			"vm.numa_zonelist_order" },
+	{"softlockup_all_cpu_backtrace",	"kernel.softlockup_all_cpu_backtrace" },
+	{"softlockup_panic",			"kernel.softlockup_panic" },
 	{ }
 };
 
--- a/kernel/watchdog.c~kernel-watchdogc-convert-soft-hardlockup-boot-parameters-to-sysctl-aliases
+++ a/kernel/watchdog.c
@@ -50,6 +50,11 @@ struct cpumask watchdog_cpumask __read_m
 unsigned long *watchdog_cpumask_bits = cpumask_bits(&watchdog_cpumask);
 
 #ifdef CONFIG_HARDLOCKUP_DETECTOR
+
+# ifdef CONFIG_SMP
+int __read_mostly sysctl_hardlockup_all_cpu_backtrace;
+# endif /* CONFIG_SMP */
+
 /*
  * Should we panic when a soft-lockup or hard-lockup occurs:
  */
@@ -82,17 +87,6 @@ static int __init hardlockup_panic_setup
 }
 __setup("nmi_watchdog=", hardlockup_panic_setup);
 
-# ifdef CONFIG_SMP
-int __read_mostly sysctl_hardlockup_all_cpu_backtrace;
-
-static int __init hardlockup_all_cpu_backtrace_setup(char *str)
-{
-	sysctl_hardlockup_all_cpu_backtrace = !!simple_strtol(str, NULL, 0);
-	return 1;
-}
-__setup("hardlockup_all_cpu_backtrace=", hardlockup_all_cpu_backtrace_setup);
-# endif /* CONFIG_SMP */
-
 atomic_t hardlockup_detected = ATOMIC_INIT(0);
 
 static inline void flush_hardlockup_messages(void)
@@ -183,6 +177,10 @@ static void lockup_detector_update_enabl
 
 #define SOFTLOCKUP_RESET	ULONG_MAX
 
+#ifdef CONFIG_SMP
+int __read_mostly sysctl_softlockup_all_cpu_backtrace;
+#endif
+
 /* Global variables, exported for sysctl */
 unsigned int __read_mostly softlockup_panic =
 			CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE;
@@ -198,13 +196,6 @@ static DEFINE_PER_CPU(unsigned long, hrt
 static DEFINE_PER_CPU(unsigned long, hrtimer_interrupts_saved);
 static unsigned long soft_lockup_nmi_warn;
 
-static int __init softlockup_panic_setup(char *str)
-{
-	softlockup_panic = simple_strtoul(str, NULL, 0);
-	return 1;
-}
-__setup("softlockup_panic=", softlockup_panic_setup);
-
 static int __init nowatchdog_setup(char *str)
 {
 	watchdog_user_enabled = 0;
@@ -226,17 +217,6 @@ static int __init watchdog_thresh_setup(
 }
 __setup("watchdog_thresh=", watchdog_thresh_setup);
 
-#ifdef CONFIG_SMP
-int __read_mostly sysctl_softlockup_all_cpu_backtrace;
-
-static int __init softlockup_all_cpu_backtrace_setup(char *str)
-{
-	sysctl_softlockup_all_cpu_backtrace = !!simple_strtol(str, NULL, 0);
-	return 1;
-}
-__setup("softlockup_all_cpu_backtrace=", softlockup_all_cpu_backtrace_setup);
-#endif
