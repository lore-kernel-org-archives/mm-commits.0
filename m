From: akpm@linux-foundation.org
Subject: + sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix.patch added to -mm tree
Date: Thu, 13 Sep 2007 18:52:31 -0700
Message-ID: <200709140152.l8E1qVO5016171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52652 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbXINBwf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Sep 2007 21:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: lethal@linux-sh.org, ebiederm@xmission.com


The patch titled
     sysctl: Fix syscall disabled build.
has been added to the -mm tree.  Its filename is
     sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

cpufreq-move-policys-governor-initialisation-out-of-low-level-drivers-into-cpufreq-core.patch
cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
git-sh.patch
sh-cleanup-struct-irqaction-initializers.patch
sh64-cleanup-struct-irqaction-initializers.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
clean-up-duplicate-includes-in-mm.patch
update-n_high_memory-node-state-for-memory-hotadd-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix.patch
printk-add-interfaces-for-external-access-to-the-log-buffer-fix-2.patch
remove-superfluous-definition-of-__setup_null_param-macro-and-broken-for-module-__setup_param.patch
uvesafb-the-driver-core-dont-access-vga-registers-directly-when-running-on-non-x86.patch
sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix.patch
bitops-introduce-lock-ops.patch
