From: akpm@linux-foundation.org
Subject: - sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix.patch removed from -mm tree
Date: Thu, 18 Oct 2007 01:49:40 -0700
Message-ID: <200710180849.l9I8neEd002893@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48860 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932356AbXJRIto (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 04:49:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: Fix syscall disabled build.
has been removed from the -mm tree.  Its filename was
     sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix.patch

This patch was dropped because it was folded into sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion.patch

------------------------------------------------------
Subject: sysctl: Fix syscall disabled build.
From: Paul Mundt <lethal@linux-sh.org>

deprecated_sysctl_warning() is used for sys_sysctl(), whether
CONFIG_SYSCTL_SYSCALL is enabled or not. When it was added, it was
added under the CONFIG_SYSCTL section, so it's not defined if we have
the support disabled completely.

  CC      kernel/sysctl.o
kernel/sysctl.c: In function 'sys_sysctl':
kernel/sysctl.c:2601: error: implicit declaration of function 'deprecated_sysctl_warning'
make[1]: *** [kernel/sysctl.o] Error 1
make: *** [kernel] Error 2

This just moves the function past the end of the CONFIG_SYSCTL space
so both configurations are happy.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |   56 +++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff -puN kernel/sysctl.c~sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix
+++ a/kernel/sysctl.c
@@ -55,6 +55,8 @@
 #include <asm/stacktrace.h>
 #endif
 
+static int deprecated_sysctl_warning(struct __sysctl_args *args);
+
 #if defined(CONFIG_SYSCTL)
 
 /* External variables not in a header file. */
@@ -1320,33 +1322,6 @@ struct ctl_table_header *sysctl_head_nex
 	return NULL;
 }
 
-static int deprecated_sysctl_warning(struct __sysctl_args *args)
-{
-	static int msg_count;
-	int name[CTL_MAXNAME];
-	int i;
-
-	/* Read in the sysctl name for better debug message logging */
-	for (i = 0; i < args->nlen; i++)
-		if (get_user(name[i], args->name + i))
-			return -EFAULT;
-
-	/* Ignore accesses to kernel.version */
-	if ((args->nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
-		return 0;
-
-	if (msg_count < 5) {
-		msg_count++;
-		printk(KERN_INFO
-			"warning: process `%s' used the deprecated sysctl "
-			"system call with ", current->comm);
-		for (i = 0; i < args->nlen; i++)
-			printk("%d.", name[i]);
-		printk("\n");
-	}
-	return 0;
-}
-
 #ifdef CONFIG_SYSCTL_SYSCALL
 int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
 	       void __user *newval, size_t newlen)
@@ -2632,6 +2607,33 @@ int sysctl_ms_jiffies(struct ctl_table *
 
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
+static int deprecated_sysctl_warning(struct __sysctl_args *args)
+{
+	static int msg_count;
+	int name[CTL_MAXNAME];
+	int i;
+
+	/* Read in the sysctl name for better debug message logging */
+	for (i = 0; i < args->nlen; i++)
+		if (get_user(name[i], args->name + i))
+			return -EFAULT;
+
+	/* Ignore accesses to kernel.version */
+	if ((args->nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
+		return 0;
+
+	if (msg_count < 5) {
+		msg_count++;
+		printk(KERN_INFO
+			"warning: process `%s' used the deprecated sysctl "
+			"system call with ", current->comm);
+		for (i = 0; i < args->nlen; i++)
+			printk("%d.", name[i]);
+		printk("\n");
+	}
+	return 0;
+}
+
 /*
  * No sense putting this after each symbol definition, twice,
  * exception granted :-)
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion.patch
sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix.patch
bitops-introduce-lock-ops.patch
