From: akpm@linux-foundation.org
Subject: [wrecked] printk_delay-for-multi-lines.patch removed from -mm tree
Date: Wed, 24 Feb 2010 14:08:45 -0800
Message-ID: <201002242208.o1OM8jBj023288@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59328 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758325Ab0BXWJd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 17:09:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     printk_delay for multi lines
has been removed from the -mm tree.  Its filename was
     printk_delay-for-multi-lines.patch

This patch was dropped because other changes were merged, which wrecked this patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk_delay for multi lines
From: Dave Young <hidave.darkstar@gmail.com>

printk_delay helps us to capture printk messages on some unconvenient
senarios, ie.  on halt phase.  But the messages is still not easy to read.

So this patch add another sysctl variable printk_delay_lines to make the
messages can be delayed after multi printks.  Thus we can take pictures by
camera easily and the messages will be more readable.

kmesg will delay printk_delay_msecs milliseconds after every
printk_delay_lines printks when printk_delay > 0.

Additional, merge boot_delay into printk_delay function.  remove
boot_delay boot param, add printk_delay and printk_delay_lines instead.

Now, we can set the value by:

1. sysctl interface:
/proc/sys/kernel/printk_delay
/proc/sys/kernel/printk_delay_lines

2. boot params:
printk_delay
printk_delay_lines

printk_delay_lines range from 1 - 10000, default value is 1

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |   11 +++-
 Documentation/sysctl/kernel.txt     |    9 +++
 include/linux/printk.h              |    1 
 kernel/printk.c                     |   67 ++++++++++++++------------
 kernel/sysctl.c                     |    9 +++
 lib/Kconfig.debug                   |   18 ------
 6 files changed, 66 insertions(+), 49 deletions(-)

diff -puN Documentation/kernel-parameters.txt~printk_delay-for-multi-lines Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~printk_delay-for-multi-lines
+++ a/Documentation/kernel-parameters.txt
@@ -418,9 +418,16 @@ and is between 256 and 4096 characters. 
 			Format: <io>,<irq>,<mode>
 			See header of drivers/net/hamradio/baycom_ser_hdx.c.
 
-	boot_delay=	Milliseconds to delay each printk during boot.
+	printk_delay=	Milliseconds to delay each printk.
 			Values larger than 10 seconds (10000) are changed to
-			no delay (0).
+			no delay (0). It can be set via sysctl after boot,
+			the proc file is: /proc/sys/kernel/printk_delay
+			Format: integer
+
+	printk_delay_lines=	Delay after every printk_delay_lines printk.
+			Values larger than 10 seconds (10000) are changed to 1.
+			It can be set via sysctl after boot,
+			the proc file is: /proc/sys/kernel/printk_delay_lines
 			Format: integer
 
 	bootmem_debug	[KNL] Enable bootmem allocator debug messages.
diff -puN Documentation/sysctl/kernel.txt~printk_delay-for-multi-lines Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~printk_delay-for-multi-lines
+++ a/Documentation/sysctl/kernel.txt
@@ -374,6 +374,15 @@ Value from 0 - 10000 is allowed.
 
 ==============================================================
 
+printk_delay_lines:
+
+Delay printk message every printk_delay_lines printks
+in printk_delay milliseconds
+
+Value from 1 - 10000 is allowed.
+
+==============================================================
+
 randomize-va-space:
 
 This option can be used to select the type of process address
diff -puN include/linux/printk.h~printk_delay-for-multi-lines include/linux/printk.h
--- a/include/linux/printk.h~printk_delay-for-multi-lines
+++ a/include/linux/printk.h
@@ -66,6 +66,7 @@ extern bool printk_timed_ratelimit(unsig
 				   unsigned int interval_msec);
 
 extern int printk_delay_msec;
+extern int printk_delay_lines;
 
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
diff -puN kernel/printk.c~printk_delay-for-multi-lines kernel/printk.c
--- a/kernel/printk.c~printk_delay-for-multi-lines
+++ a/kernel/printk.c
@@ -206,40 +206,44 @@ out:
 
 __setup("log_buf_len=", log_buf_len_setup);
 
-#ifdef CONFIG_BOOT_PRINTK_DELAY
+static unsigned long long loops_per_msec;	/* based on preset_lpj */
 
-static unsigned int boot_delay; /* msecs delay after each printk during bootup */
-static unsigned long long loops_per_msec;	/* based on boot_delay */
-
-static int __init boot_delay_setup(char *str)
+static int __init printk_delay_setup(char *str)
 {
 	unsigned long lpj;
 
 	lpj = preset_lpj ? preset_lpj : 1000000;	/* some guess */
 	loops_per_msec = (unsigned long long)lpj / 1000 * HZ;
 
-	get_option(&str, &boot_delay);
-	if (boot_delay > 10 * 1000)
-		boot_delay = 0;
+	get_option(&str, &printk_delay_msec);
+	if (printk_delay_msec > 10 * 1000)
+		printk_delay_msec = 0;
 
-	pr_debug("boot_delay: %u, preset_lpj: %ld, lpj: %lu, "
+	pr_debug("printk_delay_msec: %u, preset_lpj: %ld, lpj: %lu, "
 		"HZ: %d, loops_per_msec: %llu\n",
-		boot_delay, preset_lpj, lpj, HZ, loops_per_msec);
+		printk_delay_msec, preset_lpj, lpj, HZ, loops_per_msec);
+	return 1;
+}
+__setup("printk_delay=", printk_delay_setup);
+
+static int __init printk_delay_lines_setup(char *str)
+{
+	get_option(&str, &printk_delay_lines);
+	if (printk_delay_lines > 10 * 1000)
+		printk_delay_lines = 1;
+
 	return 1;
 }
-__setup("boot_delay=", boot_delay_setup);
+__setup("printk_delay_lines=", printk_delay_lines_setup);
 
-static void boot_delay_msec(void)
+static void boot_delay(void)
 {
 	unsigned long long k;
 	unsigned long timeout;
 
-	if (boot_delay == 0 || system_state != SYSTEM_BOOTING)
-		return;
-
-	k = (unsigned long long)loops_per_msec * boot_delay;
+	k = (unsigned long long)loops_per_msec * printk_delay_msec;
 
-	timeout = jiffies + msecs_to_jiffies(boot_delay);
+	timeout = jiffies + msecs_to_jiffies(printk_delay_msec);
 	while (k) {
 		k--;
 		cpu_relax();
@@ -253,11 +257,6 @@ static void boot_delay_msec(void)
 		touch_nmi_watchdog();
 	}
 }
-#else
-static inline void boot_delay_msec(void)
-{
-}
-#endif
 
 int do_syslog(int type, char __user *buf, int len, bool from_file)
 {
@@ -674,16 +673,28 @@ static int new_text_line = 1;
 static char printk_buf[1024];
 
 int printk_delay_msec __read_mostly;
+int printk_delay_lines __read_mostly = 1;
 
 static inline void printk_delay(void)
 {
 	if (unlikely(printk_delay_msec)) {
+		static atomic_t l = ATOMIC_INIT(0);
 		int m = printk_delay_msec;
 
-		while (m--) {
-			mdelay(1);
-			touch_nmi_watchdog();
-		}
+		if (!atomic_read(&l))
+			atomic_set(&l, printk_delay_lines);
+
+		smp_mb__before_atomic_dec();
+		if (atomic_dec_return(&l))
+			return;
+
+		if (system_state == SYSTEM_BOOTING)
+			boot_delay();
+		else
+			while (m--) {
+				mdelay(1);
+				touch_nmi_watchdog();
+			}
 	}
 }
 
@@ -695,9 +706,6 @@ asmlinkage int vprintk(const char *fmt, 
 	int this_cpu;
 	char *p;
 
-	boot_delay_msec();
-	printk_delay();
-
 	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
 	raw_local_irq_save(flags);
@@ -816,6 +824,7 @@ out_restore_irqs:
 	raw_local_irq_restore(flags);
 
 	preempt_enable();
+	printk_delay();
 	return printed_len;
 }
 EXPORT_SYMBOL(printk);
diff -puN kernel/sysctl.c~printk_delay-for-multi-lines kernel/sysctl.c
--- a/kernel/sysctl.c~printk_delay-for-multi-lines
+++ a/kernel/sysctl.c
@@ -689,6 +689,15 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &ten_thousand,
 	},
+	{
+		.procname	= "printk_delay_lines",
+		.data		= &printk_delay_lines,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &one,
+		.extra2		= &ten_thousand,
+	},
 #endif
 	{
 		.procname	= "ngroups_max",
diff -puN lib/Kconfig.debug~printk_delay-for-multi-lines lib/Kconfig.debug
--- a/lib/Kconfig.debug~printk_delay-for-multi-lines
+++ a/lib/Kconfig.debug
@@ -720,24 +720,6 @@ config FRAME_POINTER
 	  larger and slower, but it gives very useful debugging information
 	  in case of kernel bugs. (precise oopses/stacktraces/warnings)
 
-config BOOT_PRINTK_DELAY
-	bool "Delay each boot printk message by N milliseconds"
-	depends on DEBUG_KERNEL && PRINTK && GENERIC_CALIBRATE_DELAY
-	help
-	  This build option allows you to read kernel boot messages
-	  by inserting a short delay after each one.  The delay is
-	  specified in milliseconds on the kernel command line,
-	  using "boot_delay=N".
-
-	  It is likely that you would also need to use "lpj=M" to preset
-	  the "loops per jiffie" value.
-	  See a previous boot log for the "lpj" value to use for your
-	  system, and then set "lpj=M" before setting "boot_delay=N".
-	  NOTE:  Using this option may adversely affect SMP systems.
-	  I.e., processors other than the first one may not boot up.
-	  BOOT_PRINTK_DELAY also may cause DETECT_SOFTLOCKUP to detect
-	  what it believes to be lockup conditions.
-
 config RCU_TORTURE_TEST
 	tristate "torture tests for RCU"
 	depends on DEBUG_KERNEL
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

linux-next.patch
kernelh-intr_sqrt-cleanup.patch
printk_delay-for-multi-lines.patch
documentation-email-clientstxt-update-gmail-information.patch
sysctl-extern-cleanup-c_a_d.patch
sysctl-extern-cleanup-signal.patch
sysctl-extern-cleanup-binfmts.patch
sysctl-extern-cleanup-pid.patch
sysctl-extern-cleanup-mm.patch
sysctl-extern-cleanup-compat.patch
sysctl-extern-cleanup-latencytop.patch
sysctl-extern-cleanup-file-nr.patch
sysctl-extern-cleanup-rcu.patch
sysctl-extern-cleanup-block-iopoll.patch
sysctl-extern-cleanup-module.patch
sysctl-extern-cleanup-sg.patch
sysctl-extern-cleanup-acct.patch
sysctl-extern-cleanup-rtmutex.patch
sysctl-extern-cleanup-lockdep.patch
sysctl-extern-cleanup-poll.patch
sysctl-extern-cleanup-inotify.patch

