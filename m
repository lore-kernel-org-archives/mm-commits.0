From: akpm@linux-foundation.org
Subject: + printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch added to -mm tree
Date: Mon, 22 Jun 2009 22:52:03 -0700
Message-ID: <200906230552.n5N5q3al012876@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752495AbZFWFwJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 01:52:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hidave.darkstar@gmail.com, mingo@elte.hu


The patch titled
     printk: add printk_delay to make messages readable for some  scenarios
has been added to the -mm tree.  Its filename is
     printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: printk: add printk_delay to make messages readable for some  scenarios
From: Dave Young <hidave.darkstar@gmail.com>

When syslog is not possible, at the same time there's no serial/net
console available, it will be hard to read the printk messages.  For
example oops/panic/warning messages in shutdown phase.

Add a printk delay feature, we can make each printk message delay some
milliseconds.

Setting the delay by proc/sysctl interface: /proc/sys/kernel/printk_delay

The value range from 0 - 10000, default value is 0

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    8 ++++++++
 include/linux/kernel.h          |    2 ++
 include/linux/sysctl.h          |    1 +
 kernel/printk.c                 |   14 ++++++++++++++
 kernel/sysctl.c                 |   12 ++++++++++++
 5 files changed, 37 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios
+++ a/Documentation/sysctl/kernel.txt
@@ -297,6 +297,14 @@ send before ratelimiting kicks in.
 
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
@@ -245,6 +245,8 @@ extern int printk_ratelimit(void);
 extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 
+extern int printk_delay_msec;
+
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
  */
diff -puN include/linux/sysctl.h~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios include/linux/sysctl.h
--- a/include/linux/sysctl.h~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios
+++ a/include/linux/sysctl.h
@@ -163,6 +163,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_PRINTK_DELAY = 77,	/* int: tune printk delay*/
 };
 
 
diff -puN kernel/printk.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios kernel/printk.c
--- a/kernel/printk.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios
+++ a/kernel/printk.c
@@ -640,6 +640,19 @@ static int recursion_bug;
 static int new_text_line = 1;
 static char printk_buf[1024];
 
+int printk_delay_msec;
+
+static inline void printk_delay(void)
+{
+	if (unlikely(printk_delay_msec)) {
+		int m = printk_delay_msec;
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
@@ -649,6 +662,7 @@ asmlinkage int vprintk(const char *fmt, 
 	char *p;
 
 	boot_delay_msec();
+	printk_delay();
 
 	preempt_disable();
 	/* This stops the holder of console_sem just where we want him */
diff -puN kernel/sysctl.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios kernel/sysctl.c
--- a/kernel/sysctl.c~printk-add-printk_delay-to-make-messages-readable-for-some-scenarios
+++ a/kernel/sysctl.c
@@ -103,6 +103,7 @@ static int __maybe_unused one = 1;
 static int __maybe_unused two = 2;
 static unsigned long one_ul = 1;
 static int one_hundred = 100;
+static int ten_thousand = 10000;
 
 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
 static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
@@ -708,6 +709,17 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+	{
+		.ctl_name	= KERN_PRINTK_DELAY,
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
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios.patch
printk-add-printk_delay-to-make-messages-readable-for-some-scenarios-fix.patch

