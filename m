From: akpm@linux-foundation.org
Subject: + printk_ratelimit-functions-should-use-config_printk.patch added to -mm tree
Date: Fri, 21 Dec 2007 14:52:32 -0800
Message-ID: <200712212252.lBLMqWRE003311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33831 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768AbXLUWxr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Dec 2007 17:53:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joe@perches.com, mpm@selenic.com


The patch titled
     printk_ratelimit functions should use CONFIG_PRINTK
has been added to the -mm tree.  Its filename is
     printk_ratelimit-functions-should-use-config_printk.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: printk_ratelimit functions should use CONFIG_PRINTK
From: Joe Perches <joe@perches.com>

Makes an embedded image a bit smaller

Signed-off-by: Joe Perches <joe@perches.com>
Cc: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   20 +++++++++++++++-----
 kernel/printk.c        |    2 ++
 kernel/sysctl.c        |   20 ++++++++++----------
 3 files changed, 27 insertions(+), 15 deletions(-)

diff -puN include/linux/kernel.h~printk_ratelimit-functions-should-use-config_printk include/linux/kernel.h
--- a/include/linux/kernel.h~printk_ratelimit-functions-should-use-config_printk
+++ a/include/linux/kernel.h
@@ -182,6 +182,13 @@ asmlinkage int printk(const char * fmt, 
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
@@ -192,15 +199,18 @@ static inline int __cold printk(const ch
 static inline int log_buf_get_len(void) { return 0; }
 static inline int log_buf_read(int idx) { return 0; }
 static inline int log_buf_copy(char *dest, int idx, int len) { return 0; }
+
+static inline int printk_ratelimit(void) { return 0; }
+static inline int __printk_ratelimit(int ratelimit_jiffies, \
+				     int ratelimit_burst) { return 0; }
+static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies, \
+					  unsigned int interval_msec)	\
+		{ return false; }
+
 #endif
 
 unsigned long int_sqrt(unsigned long);
 
-extern int printk_ratelimit(void);
-extern int __printk_ratelimit(int ratelimit_jiffies, int ratelimit_burst);
-extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
-				unsigned int interval_msec);
-
 static inline void console_silent(void)
 {
 	console_loglevel = 0;
diff -puN kernel/printk.c~printk_ratelimit-functions-should-use-config_printk kernel/printk.c
--- a/kernel/printk.c~printk_ratelimit-functions-should-use-config_printk
+++ a/kernel/printk.c
@@ -1258,6 +1258,7 @@ void tty_write_message(struct tty_struct
 	return;
 }
 
+#if defined CONFIG_PRINTK
 /*
  * printk rate limiting, lifted from the networking subsystem.
  *
@@ -1327,3 +1328,4 @@ bool printk_timed_ratelimit(unsigned lon
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
@@ -481,14 +479,6 @@ static struct ctl_table kern_table[] = {
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
@@ -635,6 +625,15 @@ static struct ctl_table kern_table[] = {
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
@@ -652,6 +651,7 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec,
 	},
+#endif
 	{
 		.ctl_name	= KERN_NGROUPS_MAX,
 		.procname	= "ngroups_max",
_

Patches currently in -mm which might be from joe@perches.com are

maintainers-mailing-list-archives-are-web-links.patch
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
git-netdev-all.patch
git-selinux.patch
git-s390.patch
git-sh.patch
git-sparc64.patch
git-x86.patch
uml-add-missing-space.patch
printk_ratelimit-functions-should-use-config_printk.patch
