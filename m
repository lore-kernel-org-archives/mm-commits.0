From: akpm@linux-foundation.org
Subject: - sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch removed from -mm tree
Date: Thu, 15 Feb 2007 00:50:21 -0800
Message-ID: <200702150850.l1F8oL9C025224@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40310 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965544AbXBOIvf (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Feb 2007 03:51:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, dev@sw.ru, gcoady.lk@gmail.com, herbert@13thfloor.at, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: move SYSV IPC sysctls to their own file
has been removed from the -mm tree.  Its filename was
     sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: move SYSV IPC sysctls to their own file
From: Eric W. Biederman <ebiederm@xmission.com>

This is just a simple cleanup to keep kernel/sysctl.c from getting to crowded
with special cases, and by keeping all of the ipc logic to together it makes
the code a little more readable.

[gcoady.lk@gmail.com: build fix]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Signed-off-by: Grant Coady <gcoady.lk@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig     |    6 +
 ipc/Makefile     |    1 
 ipc/ipc_sysctl.c |  183 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c  |  176 -------------------------------------------
 4 files changed, 190 insertions(+), 176 deletions(-)

diff -puN init/Kconfig~sysctl-move-sysv-ipc-sysctls-to-their-own-file init/Kconfig
--- a/init/Kconfig~sysctl-move-sysv-ipc-sysctls-to-their-own-file
+++ a/init/Kconfig
@@ -125,6 +125,12 @@ config IPC_NS
 	  environments, to use ipc namespaces to provide different ipc
 	  objects for different servers.  If unsure, say N.
 
+config SYSVIPC_SYSCTL
+	bool
+	depends on SYSVIPC
+	depends on SYSCTL
+	default y
+
 config POSIX_MQUEUE
 	bool "POSIX Message Queues"
 	depends on NET && EXPERIMENTAL
diff -puN ipc/Makefile~sysctl-move-sysv-ipc-sysctls-to-their-own-file ipc/Makefile
--- a/ipc/Makefile~sysctl-move-sysv-ipc-sysctls-to-their-own-file
+++ a/ipc/Makefile
@@ -4,6 +4,7 @@
 
 obj-$(CONFIG_SYSVIPC_COMPAT) += compat.o
 obj-$(CONFIG_SYSVIPC) += util.o msgutil.o msg.o sem.o shm.o
+obj-$(CONFIG_SYSVIPC_SYSCTL) += ipc_sysctl.o
 obj_mq-$(CONFIG_COMPAT) += compat_mq.o
 obj-$(CONFIG_POSIX_MQUEUE) += mqueue.o msgutil.o $(obj_mq-y)
 
diff -puN /dev/null ipc/ipc_sysctl.c
--- /dev/null
+++ a/ipc/ipc_sysctl.c
@@ -0,0 +1,183 @@
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
+#include <linux/ipc.h>
+#include <linux/nsproxy.h>
+#include <linux/sysctl.h>
+#include <linux/uaccess.h>
+
+#ifdef CONFIG_IPC_NS
+static void *get_ipc(ctl_table *table)
+{
+	char *which = table->data;
+	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
+	which = (which - (char *)&init_ipc_ns) + (char *)ipc_ns;
+	return which;
+}
+#else
+#define get_ipc(T) ((T)->data)
+#endif
+
+#ifdef CONFIG_PROC_FS
+static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
+	void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table ipc_table;
+	memcpy(&ipc_table, table, sizeof(ipc_table));
+	ipc_table.data = get_ipc(table);
+
+	return proc_dointvec(&ipc_table, write, filp, buffer, lenp, ppos);
+}
+
+static int proc_ipc_doulongvec_minmax(ctl_table *table, int write,
+	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table ipc_table;
+	memcpy(&ipc_table, table, sizeof(ipc_table));
+	ipc_table.data = get_ipc(table);
+
+	return proc_doulongvec_minmax(&ipc_table, write, filp, buffer,
+					lenp, ppos);
+}
+
+#else
+#define proc_ipc_doulongvec_minmax NULL
+#define proc_ipc_dointvec	   NULL
+#endif
+
+#ifdef CONFIG_SYSCTL_SYSCALL
+/* The generic sysctl ipc data routine. */
+static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen)
+{
+	size_t len;
+	void *data;
+
+	/* Get out of I don't have a variable */
+	if (!table->data || !table->maxlen)
+		return -ENOTDIR;
+
+	data = get_ipc(table);
+	if (!data)
+		return -ENOTDIR;
+
+	if (oldval && oldlenp) {
+		if (get_user(len, oldlenp))
+			return -EFAULT;
+		if (len) {
+			if (len > table->maxlen)
+				len = table->maxlen;
+			if (copy_to_user(oldval, data, len))
+				return -EFAULT;
+			if (put_user(len, oldlenp))
+				return -EFAULT;
+		}
+	}
+
+	if (newval && newlen) {
+		if (newlen > table->maxlen)
+			newlen = table->maxlen;
+
+		if (copy_from_user(data, newval, newlen))
+			return -EFAULT;
+	}
+	return 1;
+}
+#else
+#define sysctl_ipc_data NULL
+#endif
+
+static struct ctl_table ipc_kern_table[] = {
+	{
+		.ctl_name	= KERN_SHMMAX,
+		.procname	= "shmmax",
+		.data		= &init_ipc_ns.shm_ctlmax,
+		.maxlen		= sizeof (init_ipc_ns.shm_ctlmax),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_doulongvec_minmax,
+		.strategy	= sysctl_ipc_data,
+	},
+	{
+		.ctl_name	= KERN_SHMALL,
+		.procname	= "shmall",
+		.data		= &init_ipc_ns.shm_ctlall,
+		.maxlen		= sizeof (init_ipc_ns.shm_ctlall),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_doulongvec_minmax,
+		.strategy	= sysctl_ipc_data,
+	},
+	{
+		.ctl_name	= KERN_SHMMNI,
+		.procname	= "shmmni",
+		.data		= &init_ipc_ns.shm_ctlmni,
+		.maxlen		= sizeof (init_ipc_ns.shm_ctlmni),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_dointvec,
+		.strategy	= sysctl_ipc_data,
+	},
+	{
+		.ctl_name	= KERN_MSGMAX,
+		.procname	= "msgmax",
+		.data		= &init_ipc_ns.msg_ctlmax,
+		.maxlen		= sizeof (init_ipc_ns.msg_ctlmax),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_dointvec,
+		.strategy	= sysctl_ipc_data,
+	},
+	{
+		.ctl_name	= KERN_MSGMNI,
+		.procname	= "msgmni",
+		.data		= &init_ipc_ns.msg_ctlmni,
+		.maxlen		= sizeof (init_ipc_ns.msg_ctlmni),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_dointvec,
+		.strategy	= sysctl_ipc_data,
+	},
+	{
+		.ctl_name	= KERN_MSGMNB,
+		.procname	=  "msgmnb",
+		.data		= &init_ipc_ns.msg_ctlmnb,
+		.maxlen		= sizeof (init_ipc_ns.msg_ctlmnb),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_dointvec,
+		.strategy	= sysctl_ipc_data,
+	},
+	{
+		.ctl_name	= KERN_SEM,
+		.procname	= "sem",
+		.data		= &init_ipc_ns.sem_ctls,
+		.maxlen		= 4*sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= proc_ipc_dointvec,
+		.strategy	= sysctl_ipc_data,
+	},
+	{}
+};
+
+static struct ctl_table ipc_root_table[] = {
+	{
+		.ctl_name	= CTL_KERN,
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= ipc_kern_table,
+	},
+	{}
+};
+
+static int __init ipc_sysctl_init(void)
+{
+	register_sysctl_table(ipc_root_table, 0);
+	return 0;
+}
+
+__initcall(ipc_sysctl_init);
diff -puN kernel/sysctl.c~sysctl-move-sysv-ipc-sysctls-to-their-own-file kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-move-sysv-ipc-sysctls-to-their-own-file
+++ a/kernel/sysctl.c
@@ -90,12 +90,6 @@ extern char modprobe_path[];
 #ifdef CONFIG_CHR_DEV_SG
 extern int sg_big_buff;
 #endif
-#ifdef CONFIG_SYSVIPC
-static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
-		void __user *buffer, size_t *lenp, loff_t *ppos);
-static int proc_ipc_doulongvec_minmax(ctl_table *table, int write, struct file *filp,
-		void __user *buffer, size_t *lenp, loff_t *ppos);
-#endif
 
 #ifdef __sparc__
 extern char reboot_command [];
@@ -135,11 +129,6 @@ static int parse_table(int __user *, int
 		void __user *, size_t, ctl_table *);
 #endif
 
-#ifdef CONFIG_SYSVIPC
-static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
-		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen);
-#endif
 
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
@@ -169,17 +158,6 @@ extern ctl_table inotify_table[];
 int sysctl_legacy_va_layout;
 #endif
 
-#ifdef CONFIG_SYSVIPC
-static void *get_ipc(ctl_table *table, int write)
-{
-	char *which = table->data;
-	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
-	which = (which - (char *)&init_ipc_ns) + (char *)ipc_ns;
-	return which;
-}
-#else
-#define get_ipc(T,W) ((T)->data)
-#endif
 
 /* /proc declarations: */
 
@@ -403,71 +381,6 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 #endif
-#ifdef CONFIG_SYSVIPC
-	{
-		.ctl_name	= KERN_SHMMAX,
-		.procname	= "shmmax",
-		.data		= &init_ipc_ns.shm_ctlmax,
-		.maxlen		= sizeof (init_ipc_ns.shm_ctlmax),
-		.mode		= 0644,
-		.proc_handler	= &proc_ipc_doulongvec_minmax,
-		.strategy	= sysctl_ipc_data,
-	},
-	{
-		.ctl_name	= KERN_SHMALL,
-		.procname	= "shmall",
-		.data		= &init_ipc_ns.shm_ctlall,
-		.maxlen		= sizeof (init_ipc_ns.shm_ctlall),
-		.mode		= 0644,
-		.proc_handler	= &proc_ipc_doulongvec_minmax,
-		.strategy	= sysctl_ipc_data,
-	},
-	{
-		.ctl_name	= KERN_SHMMNI,
-		.procname	= "shmmni",
-		.data		= &init_ipc_ns.shm_ctlmni,
-		.maxlen		= sizeof (init_ipc_ns.shm_ctlmni),
-		.mode		= 0644,
-		.proc_handler	= &proc_ipc_dointvec,
-		.strategy	= sysctl_ipc_data,
-	},
-	{
-		.ctl_name	= KERN_MSGMAX,
-		.procname	= "msgmax",
-		.data		= &init_ipc_ns.msg_ctlmax,
-		.maxlen		= sizeof (init_ipc_ns.msg_ctlmax),
-		.mode		= 0644,
-		.proc_handler	= &proc_ipc_dointvec,
-		.strategy	= sysctl_ipc_data,
-	},
-	{
-		.ctl_name	= KERN_MSGMNI,
-		.procname	= "msgmni",
-		.data		= &init_ipc_ns.msg_ctlmni,
-		.maxlen		= sizeof (init_ipc_ns.msg_ctlmni),
-		.mode		= 0644,
-		.proc_handler	= &proc_ipc_dointvec,
-		.strategy	= sysctl_ipc_data,
-	},
-	{
-		.ctl_name	= KERN_MSGMNB,
-		.procname	=  "msgmnb",
-		.data		= &init_ipc_ns.msg_ctlmnb,
-		.maxlen		= sizeof (init_ipc_ns.msg_ctlmnb),
-		.mode		= 0644,
-		.proc_handler	= &proc_ipc_dointvec,
-		.strategy	= sysctl_ipc_data,
-	},
-	{
-		.ctl_name	= KERN_SEM,
-		.procname	= "sem",
-		.data		= &init_ipc_ns.sem_ctls,
-		.maxlen		= 4*sizeof (int),
-		.mode		= 0644,
-		.proc_handler	= &proc_ipc_dointvec,
-		.strategy	= sysctl_ipc_data,
-	},
-#endif
 #ifdef CONFIG_MAGIC_SYSRQ
 	{
 		.ctl_name	= KERN_SYSRQ,
@@ -2269,27 +2182,6 @@ int proc_dointvec_ms_jiffies(ctl_table *
 				do_proc_dointvec_ms_jiffies_conv, NULL);
 }
 
-#ifdef CONFIG_SYSVIPC
-static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
-	void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	void *which;
-	which = get_ipc(table, write);
-	return __do_proc_dointvec(which, table, write, filp, buffer,
-			lenp, ppos, NULL, NULL);
-}
-
-static int proc_ipc_doulongvec_minmax(ctl_table *table, int write,
-	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	void *which;
-	which = get_ipc(table, write);
-	return __do_proc_doulongvec_minmax(which, table, write, filp, buffer,
-			lenp, ppos, 1l, 1l);
-}
-
-#endif
-
 static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
 			   void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -2320,25 +2212,6 @@ int proc_dostring(ctl_table *table, int 
 	return -ENOSYS;
 }
 
-#ifdef CONFIG_SYSVIPC
-static int proc_do_ipc_string(ctl_table *table, int write, struct file *filp,
-		void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
-		void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-static int proc_ipc_doulongvec_minmax(ctl_table *table, int write,
-		struct file *filp, void __user *buffer,
-		size_t *lenp, loff_t *ppos)
-{
-	return -ENOSYS;
-}
-#endif
-
 int proc_dointvec(ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
@@ -2550,47 +2423,6 @@ int sysctl_ms_jiffies(ctl_table *table, 
 
 
 
-#ifdef CONFIG_SYSVIPC
-/* The generic sysctl ipc data routine. */
-static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	size_t len;
-	void *data;
-
-	/* Get out of I don't have a variable */
-	if (!table->data || !table->maxlen)
-		return -ENOTDIR;
-
-	data = get_ipc(table, 1);
-	if (!data)
-		return -ENOTDIR;
-
-	if (oldval && oldlenp) {
-		if (get_user(len, oldlenp))
-			return -EFAULT;
-		if (len) {
-			if (len > table->maxlen)
-				len = table->maxlen;
-			if (copy_to_user(oldval, data, len))
-				return -EFAULT;
-			if (put_user(len, oldlenp))
-				return -EFAULT;
-		}
-	}
-
-	if (newval && newlen) {
-		if (newlen > table->maxlen)
-			newlen = table->maxlen;
-
-		if (copy_from_user(data, newval, newlen))
-			return -EFAULT;
-	}
-	return 1;
-}
-#endif
-
 #else /* CONFIG_SYSCTL_SYSCALL */
 
 
@@ -2655,14 +2487,6 @@ int sysctl_ms_jiffies(ctl_table *table, 
 	return -ENOSYS;
 }
 
-#ifdef CONFIG_SYSVIPC
-static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
-		void __user *oldval, size_t __user *oldlenp,
-		void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-#endif
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
 /*
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
