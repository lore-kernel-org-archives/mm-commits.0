From: akpm@linux-foundation.org
Subject: + printk_ratelimit-functions-should-use-config_printk.patch added to -mm tree
Date: Sun, 27 Jan 2008 21:29:12 -0800
Message-ID: <200801280530.m0S5U68j014029@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750961AbYA1Faj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Jan 2008 00:30:39 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com


The patch titled
     printk_ratelimit() functions should use CONFIG_PRINTK
has been added to the -mm tree.  Its filename is
     printk_ratelimit-functions-should-use-config_printk.patch

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
Subject: printk_ratelimit() functions should use CONFIG_PRINTK
From: Joe Perches <joe@perches.com>

Makes an embedded image a bit smaller.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   17 +++++++++++++----
 kernel/printk.c        |    2 ++
 kernel/sysctl.c        |   20 ++++++++++----------
 3 files changed, 25 insertions(+), 14 deletions(-)

diff -puN include/linux/kernel.h~printk_ratelimit-functions-should-use-config_printk include/linux/kernel.h
--- a/include/linux/kernel.h~printk_ratelimit-functions-should-use-config_printk
+++ a/include/linux/kernel.h
@@ -180,6 +180,13 @@ asmlinkage int printk(const char * fmt, 
 extern int log_buf_get_len(void);
 extern int log_buf_read(int idx);
 extern int log_buf_copy(char *dest, int idx, int len);
+
+extern int printk_ratelimit_jiffies;
+extern int printk_ratelimit_burst;
+extern int printk_ratelimit(void);
+extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
+extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
+				   unsigned int interval_msec);
 #else
 static inline int vprintk(const char *s, va_list args)
 	__attribute__ ((format (printf, 1, 0)));
@@ -197,10 +204,12 @@ extern void __attribute__((format(printf
 
 unsigned long int_sqrt(unsigned long);
 
-extern int printk_ratelimit(void);
-extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
-extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
-				unsigned int interval_msec);
+static inline int printk_ratelimit(void) { return 0; }
+static inline int __printk_ratelimit(int ratelimit_jiffies, \
+				     int ratelimit_burst) { return 0; }
+static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
+					  unsigned int interval_msec)	\
+		{ return false; }
 
 static inline void console_silent(void)
 {
diff -puN kernel/printk.c~printk_ratelimit-functions-should-use-config_printk kernel/printk.c
--- a/kernel/printk.c~printk_ratelimit-functions-should-use-config_printk
+++ a/kernel/printk.c
@@ -1251,6 +1251,7 @@ void tty_write_message(struct tty_struct
 	return;
 }
 
+#if defined CONFIG_PRINTK
 /*
  * printk rate limiting, lifted from the networking subsystem.
  *
@@ -1320,3 +1321,4 @@ bool printk_timed_ratelimit(unsigned lon
 	return false;
 }
 EXPORT_SYMBOL(printk_timed_ratelimit);
+#endif
diff -puN kernel/sysctl.c~printk_ratelimit-functions-should-use-config_printk kernel/sysctl.c
--- a/kernel/sysctl.c~printk_ratelimit-functions-should-use-config_printk
+++ a/kernel/sysctl.c
@@ -73,8 +73,6 @@ extern int suid_dumpable;
 extern char core_pattern[];
 extern int pid_max;
 extern int min_free_kbytes;
-extern int printk_ratelimit_jiffies;
-extern int printk_ratelimit_burst;
 extern int pid_max_min, pid_max_max;
 extern int sysctl_drop_caches;
 extern int percpu_pagelist_fraction;
@@ -490,14 +488,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
-	{
-		.ctl_name	= KERN_PRINTK,
-		.procname	= "printk",
-		.data		= &console_loglevel,
-		.maxlen		= 4*sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= &proc_dointvec,
-	},
 #ifdef CONFIG_KMOD
 	{
 		.ctl_name	= KERN_MODPROBE,
@@ -644,6 +634,15 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#if defined CONFIG_PRINTK
+	{
+		.ctl_name	= KERN_PRINTK,
+		.procname	= "printk",
+		.data		= &console_loglevel,
+		.maxlen		= 4*sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
 	{
 		.ctl_name	= KERN_PRINTK_RATELIMIT,
 		.procname	= "printk_ratelimit",
@@ -661,6 +660,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#endif
 	{
 		.ctl_name	= KERN_NGROUPS_MAX,
 		.procname	= "ngroups_max",
_

Patches currently in -mm which might be from joe@perches.com are

git-alsa.patch
git-cpufreq.patch
git-powerpc.patch
git-dvb.patch
git-hwmon.patch
git-ieee1394.patch
git-infiniband.patch
git-jfs.patch
git-kvm.patch
git-net.patch
git-selinux.patch
git-s390.patch
git-sh.patch
git-unionfs.patch
git-x86.patch
uml-add-missing-space.patch
uml-style-fixes-in-arch-um-kernel.patch
uml-spelling-fix.patch
maintainers-remove-adam-fritzler-update-his-email-address-in-other-sources.patch
spi_imx-spelling-fixes.patch
printk_ratelimit-functions-should-use-config_printk.patch
