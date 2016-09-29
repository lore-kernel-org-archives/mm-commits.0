From: akpm@linux-foundation.org
Subject: [merged] compat-remove-compat_printk.patch removed from -mm tree
Date: Thu, 29 Sep 2016 12:59:49 -0700
Message-ID: <57ed72b5.Mrh7a3mSt021QFyH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44086 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755598AbcI2T7u (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 29 Sep 2016 15:59:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, acme@redhat.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: compat: remove compat_printk()
has been removed from the -mm tree.  Its filename was
     compat-remove-compat_printk.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Arnd Bergmann <arnd@arndb.de>
Subject: compat: remove compat_printk()

After 7e8e385aaf6e ("x86/compat: Remove sys32_vm86_warning"), this
function has become unused, so we can remove it as well.

Link: http://lkml.kernel.org/r/20160617142903.3070388-1-arnd@arndb.de
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat.c            |   14 --------------
 include/linux/compat.h |    1 -
 kernel/sysctl.c        |   10 ----------
 3 files changed, 25 deletions(-)

diff -puN fs/compat.c~compat-remove-compat_printk fs/compat.c
--- a/fs/compat.c~compat-remove-compat_printk
+++ a/fs/compat.c
@@ -54,20 +54,6 @@
 #include <asm/ioctls.h>
 #include "internal.h"
 
-int compat_log = 1;
-
-int compat_printk(const char *fmt, ...)
-{
-	va_list ap;
-	int ret;
-	if (!compat_log)
-		return 0;
-	va_start(ap, fmt);
-	ret = vprintk(fmt, ap);
-	va_end(ap);
-	return ret;
-}
-
 /*
  * Not all architectures have sys_utime, so implement this in terms
  * of sys_utimes.
diff -puN include/linux/compat.h~compat-remove-compat_printk include/linux/compat.h
--- a/include/linux/compat.h~compat-remove-compat_printk
+++ a/include/linux/compat.h
@@ -432,7 +432,6 @@ asmlinkage long compat_sys_settimeofday(
 
 asmlinkage long compat_sys_adjtimex(struct compat_timex __user *utp);
 
-extern __printf(1, 2) int compat_printk(const char *fmt, ...);
 extern void sigset_from_compat(sigset_t *set, const compat_sigset_t *compat);
 extern void sigset_to_compat(compat_sigset_t *compat, const sigset_t *set);
 
diff -puN kernel/sysctl.c~compat-remove-compat_printk kernel/sysctl.c
--- a/kernel/sysctl.c~compat-remove-compat_printk
+++ a/kernel/sysctl.c
@@ -106,7 +106,6 @@ extern unsigned int core_pipe_limit;
 extern int pid_max;
 extern int pid_max_min, pid_max_max;
 extern int percpu_pagelist_fraction;
-extern int compat_log;
 extern int latencytop_enabled;
 extern int sysctl_nr_open_min, sysctl_nr_open_max;
 #ifndef CONFIG_MMU
@@ -1084,15 +1083,6 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &neg_one,
 	},
 #endif
-#ifdef CONFIG_COMPAT
-	{
-		.procname	= "compat-log",
-		.data		= &compat_log,
-		.maxlen		= sizeof (int),
-	 	.mode		= 0644,
-		.proc_handler	= proc_dointvec,
-	},
-#endif
 #ifdef CONFIG_RT_MUTEXES
 	{
 		.procname	= "max_lock_depth",
_

Patches currently in -mm which might be from arnd@arndb.de are

relay-use-irq_work-instead-of-plain-timer-for-deferred-wakeup-fix.patch

