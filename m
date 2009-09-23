From: akpm@linux-foundation.org
Subject: [merged] printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch removed from -mm tree
Date: Wed, 23 Sep 2009 12:52:15 -0700
Message-ID: <200909231952.n8NJqFwL028782@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633AbZIWTwt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 15:52:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hidave.darkstar@gmail.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     printk: add printk_delay to make messages readable for some scenarios
has been removed from the -mm tree.  Its filename was
     printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: add printk_delay to make messages readable for some scenarios
From: Dave Young <hidave.darkstar@gmail.com>

When syslog is not possible, at the same time there's no serial/net
console available, it will be hard to read the printk messages.  For
example oops/panic/warning messages in shutdown phase.

Add a printk delay feature, we can make each printk message delay some
milliseconds.

Setting the delay by proc/sysctl interface: /proc/sys/kernel/printk_delay

The value range from 0 - 10000, default value is 0

[akpm@linux-foundation.org: fix a few things]
Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    8 ++++++++
 include/linux/kernel.h          |    2 ++
 kernel/printk.c                 |   15 +++++++++++++++
 kernel/sysctl.c                 |   14 ++++++++++++++
 4 files changed, 39 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios
+++ a/Documentation/sysctl/kernel.txt
@@ -313,6 +313,14 @@ send before ratelimiting kicks in.
 
 ==============================================================
 
+printk_delay:
+
+Delay each printk message in printk_delay milliseconds
+
+Value from 0 - 10000 is allowed.
+
+==============================================================
+
 randomize-va-space:
 
 This option can be used to select the type of process address
diff -puN include/linux/kernel.h~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios include/linux/kernel.h
--- a/include/linux/kernel.h~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios
+++ a/include/linux/kernel.h
@@ -246,6 +246,8 @@ extern int printk_ratelimit(void);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 
+extern int printk_delay_msec;
+
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
  */
diff -puN kernel/printk.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios kernel/printk.c
--- a/kernel/printk.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios
+++ a/kernel/printk.c
@@ -653,6 +653,20 @@ static int recursion_bug;
 static int new_text_line = 1;
 static char printk_buf[1024];
 
+int printk_delay_msec __read_mostly;
+
+static inline void printk_delay(void)
+{
+	if (unlikely(printk_delay_msec)) {
+		int m = printk_delay_msec;
+
+		while (m--) {
+			mdelay(1);
+			touch_nmi_watchdog();
+		}
+	}
+}
+
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
 	int printed_len = 0;
@@ -662,6 +676,7 @@ asmlinkage int vprintk(const char *fmt, 
 	char *p;
 
 	boot_delay_msec();
+	printk_delay();
 
 	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
diff -puN kernel/sysctl.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios kernel/sysctl.c
--- a/kernel/sysctl.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios
+++ a/kernel/sysctl.c
@@ -106,6 +106,9 @@ static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
+#ifdef CONFIG_PRINTK
+static int ten_thousand = 10000;
+#endif
 
 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
 static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
@@ -722,6 +725,17 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "printk_delay",
+		.data		= &printk_delay_msec,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+		.extra2		= &ten_thousand,
+	},
 #endif
 	{
 		.ctl_name	= KERN_NGROUPS_MAX,
_

Patches currently in -mm which might be from hidave.darkstar@gmail.com are

origin.patch
bluetooth-fix-for-acer-bluetooth-optical-rechargeable-mouse.patch
cgroups-let-ss-can_attach-and-ss-attach-do-whole-threadgroups-at-a-time-fix.patch
pc-fs-char_devc-remove-useless-loop-fix.patch

