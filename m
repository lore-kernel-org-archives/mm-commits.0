From: akpm@linux-foundation.org
Subject: + compat-remove-compat_printk.patch added to -mm tree
Date: Tue, 21 Jun 2016 16:37:35 -0700
Message-ID: <5769cfbf.aspPQfzmTbbpHdCF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbcFVAaw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jun 2016 20:30:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: arnd@arndb.de, acme@redhat.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: compat: remove compat_printk()
has been added to the -mm tree.  Its filename is
     compat-remove-compat_printk.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/compat-remove-compat_printk.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/compat-remove-compat_printk.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -1077,15 +1076,6 @@ static struct ctl_table kern_table[] = {
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

procfs-avoid-32-bit-time_t-in-proc-stat.patch
crc32-use-ktime_get_ns-for-measurement.patch
compat-remove-compat_printk.patch
nilfs2-replace-nilfs_warning-with-nilfs_msg-fix.patch

