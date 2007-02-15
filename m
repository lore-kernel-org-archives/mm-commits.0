From: akpm@linux-foundation.org
Subject: - sysctl-move-utsname-sysctls-to-their-own-file.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:16 -0800
Message-ID: <200702150850.l1F8oGqa025205@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40469 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965611AbXBOIyt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:54:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, dev@sw.ru, herbert@13thfloor.at, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: move utsname sysctls to their own file
has been removed from the -mm tree.  Its filename was
     sysctl-move-utsname-sysctls-to-their-own-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: move utsname sysctls to their own file
From: Eric W. Biederman <ebiederm@xmission.com>

This is just a simple cleanup to keep kernel/sysctl.c from getting to crowded
with special cases, and by keeping all of the utsname logic to together it
makes the code a little more readable.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Makefile         |    1 
 kernel/sysctl.c         |  117 ------------------------------
 kernel/utsname_sysctl.c |  146 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+), 117 deletions(-)

diff -puN kernel/Makefile~sysctl-move-utsname-sysctls-to-their-own-file kernel/Makefile
--- a/kernel/Makefile~sysctl-move-utsname-sysctls-to-their-own-file
+++ a/kernel/Makefile
@@ -47,6 +47,7 @@ obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
 obj-$(CONFIG_RCU_TORTURE_TEST) += rcutorture.o
 obj-$(CONFIG_RELAY) += relay.o
+obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
diff -puN kernel/sysctl.c~sysctl-move-utsname-sysctls-to-their-own-file kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-move-utsname-sysctls-to-their-own-file
+++ a/kernel/sysctl.c
@@ -135,13 +135,6 @@ static int parse_table(int __user *, int
 		void __user *, size_t, ctl_table *);
 #endif
 
-static int proc_do_uts_string(ctl_table *table, int write, struct file *filp,
-		  void __user *buffer, size_t *lenp, loff_t *ppos);
-
-static int sysctl_uts_string(ctl_table *table, int __user *name, int nlen,
-		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen);
-
 #ifdef CONFIG_SYSVIPC
 static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
@@ -176,29 +169,6 @@ extern ctl_table inotify_table[];
 int sysctl_legacy_va_layout;
 #endif
 
-
-static void *get_uts(ctl_table *table, int write)
-{
-	char *which = table->data;
-#ifdef CONFIG_UTS_NS
-	struct uts_namespace *uts_ns = current->nsproxy->uts_ns;
-	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
-#endif
-	if (!write)
-		down_read(&uts_sem);
-	else
-		down_write(&uts_sem);
-	return which;
-}
-
-static void put_uts(ctl_table *table, int write, void *which)
-{
-	if (!write)
-		up_read(&uts_sem);
-	else
-		up_write(&uts_sem);
-}
-
 #ifdef CONFIG_SYSVIPC
 static void *get_ipc(ctl_table *table, int write)
 {
@@ -278,51 +248,6 @@ static ctl_table root_table[] = {
 
 static ctl_table kern_table[] = {
 	{
-		.ctl_name	= KERN_OSTYPE,
-		.procname	= "ostype",
-		.data		= init_uts_ns.name.sysname,
-		.maxlen		= sizeof(init_uts_ns.name.sysname),
-		.mode		= 0444,
-		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_uts_string,
-	},
-	{
-		.ctl_name	= KERN_OSRELEASE,
-		.procname	= "osrelease",
-		.data		= init_uts_ns.name.release,
-		.maxlen		= sizeof(init_uts_ns.name.release),
-		.mode		= 0444,
-		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_uts_string,
-	},
-	{
-		.ctl_name	= KERN_VERSION,
-		.procname	= "version",
-		.data		= init_uts_ns.name.version,
-		.maxlen		= sizeof(init_uts_ns.name.version),
-		.mode		= 0444,
-		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_uts_string,
-	},
-	{
-		.ctl_name	= KERN_NODENAME,
-		.procname	= "hostname",
-		.data		= init_uts_ns.name.nodename,
-		.maxlen		= sizeof(init_uts_ns.name.nodename),
-		.mode		= 0644,
-		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_uts_string,
-	},
-	{
-		.ctl_name	= KERN_DOMAINNAME,
-		.procname	= "domainname",
-		.data		= init_uts_ns.name.domainname,
-		.maxlen		= sizeof(init_uts_ns.name.domainname),
-		.mode		= 0644,
-		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_uts_string,
-	},
-	{
 		.ctl_name	= KERN_PANIC,
 		.procname	= "panic",
 		.data		= &panic_timeout,
@@ -1759,21 +1684,6 @@ int proc_dostring(ctl_table *table, int 
 			       buffer, lenp, ppos);
 }
 
-/*
- *	Special case of dostring for the UTS structure. This has locks
- *	to observe. Should this be in kernel/sys.c ????
- */
-
-static int proc_do_uts_string(ctl_table *table, int write, struct file *filp,
-		  void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	int r;
-	void *which;
-	which = get_uts(table, write);
-	r = _proc_do_string(which, table->maxlen,write,filp,buffer,lenp, ppos);
-	put_uts(table, write, which);
-	return r;
-}
 
 static int do_proc_dointvec_conv(int *negp, unsigned long *lvalp,
 				 int *valp,
@@ -2410,12 +2320,6 @@ int proc_dostring(ctl_table *table, int 
 	return -ENOSYS;
 }
 
-static int proc_do_uts_string(ctl_table *table, int write, struct file *filp,
-		void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-
 #ifdef CONFIG_SYSVIPC
 static int proc_do_ipc_string(ctl_table *table, int write, struct file *filp,
 		void __user *buffer, size_t *lenp, loff_t *ppos)
@@ -2645,21 +2549,6 @@ int sysctl_ms_jiffies(ctl_table *table, 
 }
 
 
-/* The generic string strategy routine: */
-static int sysctl_uts_string(ctl_table *table, int __user *name, int nlen,
-		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen)
-{
-	struct ctl_table uts_table;
-	int r, write;
-	write = newval && newlen;
-	memcpy(&uts_table, table, sizeof(uts_table));
-	uts_table.data = get_uts(table, write);
-	r = sysctl_string(&uts_table, name, nlen,
-		oldval, oldlenp, newval, newlen);
-	put_uts(table, write, uts_table.data);
-	return r;
-}
 
 #ifdef CONFIG_SYSVIPC
 /* The generic sysctl ipc data routine. */
@@ -2766,12 +2655,6 @@ int sysctl_ms_jiffies(ctl_table *table, 
 	return -ENOSYS;
 }
 
-static int sysctl_uts_string(ctl_table *table, int __user *name, int nlen,
-		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
 #ifdef CONFIG_SYSVIPC
 static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
 		void __user *oldval, size_t __user *oldlenp,
diff -puN /dev/null kernel/utsname_sysctl.c
--- /dev/null
+++ a/kernel/utsname_sysctl.c
@@ -0,0 +1,146 @@
+/*
+ *  Copyright (C) 2007
+ *
+ *  Author: Eric Biederman <ebiederm@xmision.com>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License as
+ *  published by the Free Software Foundation, version 2 of the
+ *  License.
+ */
+
+#include <linux/module.h>
+#include <linux/uts.h>
+#include <linux/utsname.h>
+#include <linux/version.h>
+#include <linux/sysctl.h>
+
+static void *get_uts(ctl_table *table, int write)
+{
+	char *which = table->data;
+#ifdef CONFIG_UTS_NS
+	struct uts_namespace *uts_ns = current->nsproxy->uts_ns;
+	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
+#endif
+	if (!write)
+		down_read(&uts_sem);
+	else
+		down_write(&uts_sem);
+	return which;
+}
+
+static void put_uts(ctl_table *table, int write, void *which)
+{
+	if (!write)
+		up_read(&uts_sem);
+	else
+		up_write(&uts_sem);
+}
+
+#ifdef CONFIG_PROC_FS
+/*
+ *	Special case of dostring for the UTS structure. This has locks
+ *	to observe. Should this be in kernel/sys.c ????
+ */
+static int proc_do_uts_string(ctl_table *table, int write, struct file *filp,
+		  void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table uts_table;
+	int r;
+	memcpy(&uts_table, table, sizeof(uts_table));
+	uts_table.data = get_uts(table, write);
+	r = proc_dostring(&uts_table,write,filp,buffer,lenp, ppos);
+	put_uts(table, write, uts_table.data);
+	return r;
+}
+#else
+#define proc_do_uts_string NULL
+#endif
+
+
+#ifdef CONFIG_SYSCTL_SYSCALL
+/* The generic string strategy routine: */
+static int sysctl_uts_string(ctl_table *table, int __user *name, int nlen,
+		  void __user *oldval, size_t __user *oldlenp,
+		  void __user *newval, size_t newlen)
+{
+	struct ctl_table uts_table;
+	int r, write;
+	write = newval && newlen;
+	memcpy(&uts_table, table, sizeof(uts_table));
+	uts_table.data = get_uts(table, write);
+	r = sysctl_string(&uts_table, name, nlen,
+		oldval, oldlenp, newval, newlen);
+	put_uts(table, write, uts_table.data);
+	return r;
+}
+#else
+#define sysctl_uts_string NULL
+#endif
+
+static struct ctl_table uts_kern_table[] = {
+	{
+		.ctl_name	= KERN_OSTYPE,
+		.procname	= "ostype",
+		.data		= init_uts_ns.name.sysname,
+		.maxlen		= sizeof(init_uts_ns.name.sysname),
+		.mode		= 0444,
+		.proc_handler	= proc_do_uts_string,
+		.strategy	= sysctl_uts_string,
+	},
+	{
+		.ctl_name	= KERN_OSRELEASE,
+		.procname	= "osrelease",
+		.data		= init_uts_ns.name.release,
+		.maxlen		= sizeof(init_uts_ns.name.release),
+		.mode		= 0444,
+		.proc_handler	= proc_do_uts_string,
+		.strategy	= sysctl_uts_string,
+	},
+	{
+		.ctl_name	= KERN_VERSION,
+		.procname	= "version",
+		.data		= init_uts_ns.name.version,
+		.maxlen		= sizeof(init_uts_ns.name.version),
+		.mode		= 0444,
+		.proc_handler	= proc_do_uts_string,
+		.strategy	= sysctl_uts_string,
+	},
+	{
+		.ctl_name	= KERN_NODENAME,
+		.procname	= "hostname",
+		.data		= init_uts_ns.name.nodename,
+		.maxlen		= sizeof(init_uts_ns.name.nodename),
+		.mode		= 0644,
+		.proc_handler	= proc_do_uts_string,
+		.strategy	= sysctl_uts_string,
+	},
+	{
+		.ctl_name	= KERN_DOMAINNAME,
+		.procname	= "domainname",
+		.data		= init_uts_ns.name.domainname,
+		.maxlen		= sizeof(init_uts_ns.name.domainname),
+		.mode		= 0644,
+		.proc_handler	= proc_do_uts_string,
+		.strategy	= sysctl_uts_string,
+	},
+	{}
+};
+
+static struct ctl_table uts_root_table[] = {
+	{
+		.ctl_name	= CTL_KERN,
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= uts_kern_table,
+	},
+	{}
+};
+
+static int __init utsname_sysctl_init(void)
+{
+	register_sysctl_table(uts_root_table, 0);
+	return 0;
+}
+
+__initcall(utsname_sysctl_init);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
powerpc-rtas-msi-support.patch
fix-i-oat-for-kexec.patch
git-v9fs.patch
x86_64-irq-simplfy-__assign_irq_vector.patch
x86_64-irq-handle-irqs-pending-in-irr-during-irq-migration.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
allow-access-to-proc-pid-fd-after-setuid.patch
allow-access-to-proc-pid-fd-after-setuid-fix.patch
allow-access-to-proc-pid-fd-after-setuid-update.patch
allow-access-to-proc-pid-fd-after-setuid-update-2.patch
shm-make-sysv-ipc-shared-memory-use-stacked-files.patch
i386-apic-clean-up-the-apic-code.patch
i386-rework-local-apic-timer-calibration.patch
i386-prepare-nmi-watchdog-for-dynticks.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-remove-insert_at_head-from-register_sysctl-fix.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
