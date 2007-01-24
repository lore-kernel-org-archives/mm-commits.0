From: akpm@osdl.org
Subject: + sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch added to -mm tree
Date: Tue, 23 Jan 2007 19:13:41 -0800
Message-ID: <200701240313.l0O3Df56006976@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49368 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030243AbXAXDRh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 22:17:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, dev@sw.ru, herbert@13thfloor.at, serue@us.ibm.com


The patch titled
     sysctl: move SYSV IPC sysctls to their own file
has been added to the -mm tree.  Its filename is
     sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: move SYSV IPC sysctls to their own file
From: Eric W. Biederman <ebiederm@xmission.com>

This is just a simple cleanup to keep kernel/sysctl.c from getting to crowded
with special cases, and by keeping all of the ipc logic to together it makes
the code a little more readable.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 init/Kconfig     |    6 +
 ipc/Makefile     |    1 
 ipc/ipc_sysctl.c |  182 +++++++++++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c  |  176 -------------------------------------------
 4 files changed, 189 insertions(+), 176 deletions(-)

diff -puN init/Kconfig~sysctl-move-sysv-ipc-sysctls-to-their-own-file init/Kconfig
--- a/init/Kconfig~sysctl-move-sysv-ipc-sysctls-to-their-own-file
+++ a/init/Kconfig
@@ -138,6 +138,12 @@ config SYSVIPC
 	  section 6.4 of the Linux Programmer's Guide, available from
 	  <http://www.tldp.org/guides.html>.
 
+config SYSVIPC_SYSCTL
+	bool
+	depends on SYSVIPC
+	depends on SYSCTL
+	default y
+
 config IPC_NS
 	bool "IPC Namespaces"
 	depends on SYSVIPC
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
@@ -0,0 +1,182 @@
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
+#define proc_ipc_do_ulongvec_minmax NULL
+#define proc_ipc_do_intvec	    NULL
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
@@ -96,12 +96,6 @@ extern char modprobe_path[];
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
@@ -141,11 +135,6 @@ static int parse_table(int __user *, int
 		void __user *, size_t, ctl_table *);
 #endif
 
-#ifdef CONFIG_SYSVIPC
-static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
-		  void __user *oldval, size_t __user *oldlenp,
-		  void __user *newval, size_t newlen);
-#endif
 
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
@@ -177,17 +166,6 @@ int sysctl_legacy_va_layout;
 
 
 
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
 
@@ -411,71 +389,6 @@ static ctl_table kern_table[] = {
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
@@ -2301,27 +2214,6 @@ int proc_dointvec_ms_jiffies(ctl_table *
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
@@ -2352,25 +2244,6 @@ int proc_dostring(ctl_table *table, int 
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
@@ -2582,47 +2455,6 @@ int sysctl_ms_jiffies(ctl_table *table, 
 
 
 
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
 
 
@@ -2687,14 +2519,6 @@ int sysctl_ms_jiffies(ctl_table *table, 
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

kthread-api-conversion-for-dvb_frontend-and-av7110.patch
vt-refactor-console-sak-processing.patch
sysctl_ms_jiffies-fix-oldlen-semantics.patch
9p-use-kthread_stop-instead-of-sending-a-sigkill.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry.patch
procfs-fix-race-between-proc_readdir-and-remove_proc_entry-fix.patch
kill_pid_info-kill-acquired_tasklist_lock.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
fix-rmmod-read-write-races-in-proc-entries.patch
tty-make-__proc_set_tty-static.patch
tty-clarify-disassociate_ctty.patch
tty-fix-the-locking-for-signal-session-in-disassociate_ctty.patch
signal-use-kill_pgrp-not-kill_pg-in-the-sunos-compatibility-code.patch
signal-rewrite-kill_something_info-so-it-uses-newer-helpers.patch
pid-make-session_of_pgrp-use-struct-pid-instead-of-pid_t.patch
pid-use-struct-pid-for-talking-about-process-groups-in-exitc.patch
pid-replace-is_orphaned_pgrp-with-is_current_pgrp_orphaned.patch
tty-update-the-tty-layer-to-work-with-struct-pid.patch
pid-replace-do-while_each_task_pid-with-do-while_each_pid_task.patch
pid-remove-now-unused-do_each_task_pid-and-while_each_task_pid.patch
pid-remove-the-now-unused-kill_pg-kill_pg_info-and-__kill_pg_info.patch
i386-apic-clean-up-the-apic-code.patch
i386-apic-rework-and-fix-local-apic-calibration.patch
dynticks-i386-prepare-nmi-watchdog.patch
edac-e752x-bit-mask-fix.patch
edac-e752x-byte-access-fix.patch
edac-k8-driver-coding-tidy.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
nsproxy-externalizes-exit_task_namespaces.patch
user-namespace-add-the-framework.patch
user-namespace-add-the-framework-fix.patch
user-ns-add-user_namespace-ptr-to-vfsmount.patch
user-ns-hook-permission.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs.patch
user-ns-prepare-copy_tree-copy_mnt-and-their-callers-to-handle-errs-fix.patch
user-ns-implement-shared-mounts.patch
user_ns-handle-file-sigio.patch
user_ns-handle-file-sigio-fix.patch
user-ns-implement-user-ns-unshare.patch
user-ns-implement-user-ns-unshare-tidy.patch
user-ns-implement-user-ns-unshare-remove-config_user_ns.patch
remove-find_attach_pid.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
sysctl-x25-remove-unnecessary-insert_at_head-from-register_sysctl_table.patch
sysctl-move-ctl_sunrpc-to-sysctlh-where-it-belongs.patch
sysctl-sunrpc-remove-unnecessary-insert_at_head-flag.patch
sysctl-sunrpc-dont-unnecessarily-set-ctl_table-de.patch
sysctl-rose-remove-unnecessary-insert_at_head-flag.patch
sysctl-netrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-llc-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipx-remove-unnecessary-insert_at_head-flag.patch
sysctl-decnet-remove-unnecessary-insert_at_head-flag.patch
sysctl-dccp-remove-unnecessary-insert_at_head-flag.patch
sysctl-ax25-remove-unnecessary-insert_at_head-flag.patch
sysctl-atalk-remove-unnecessary-insert_at_head-flag.patch
sysctl-xfs-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-xfs-ctl_tables.patch
sysctl-c99-convert-xfs-ctl_tables-fixes.patch
sysctl-scsi-remove-unnecessary-insert_at_head-flag.patch
sysctl-md-remove-unnecessary-insert_at_head-flag.patch
sysctl-mac_hid-remove-unnecessary-insert_at_head-flag.patch
sysctl-ipmi-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-remove-unnecessary-insert_at_head-flag.patch
sysctl-cdrom-dont-set-de-owner.patch
sysctl-move-ctl_pm-into-sysctlh-where-it-belongs.patch
sysctl-frv-pm-remove-unnecessary-insert_at_head-flag.patch
sysctl-move-ctl_frv-into-sysctlh-where-it-belongs.patch
sysctl-frv-remove-unnecessary-insert_at_head-flag.patch
sysctl-c99-convert-arch-frv-kernel-pmc.patch
sysctl-c99-convert-arch-frv-kernel-sysctlc.patch
sysctl-sn-remove-sysctl-abi-breakage.patch
sysctl-c99-convert-arch-ia64-sn-kernel-xpc_mainc.patch
sysctl-c99-convert-arch-ia64-kernel-perfmon-and-remove-abi-breakage.patch
sysctl-mips-au1000-remove-sys_sysctl-support.patch
sysctl-c99-convert-the-ctl_tables-in-arch-mips-au1000-common-powerc.patch
sysctl-c99-convert-arch-mips-lasat-sysctlc-and-remove-abi-breakage.patch
sysctl-s390-move-sysctl-definitions-to-sysctlh.patch
sysctl-s390-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-powerpc-kernel-idlec.patch
sysctl-c99-convert-ctl_tables-entries-in-arch-ppc-kernel-ppc_htabc.patch
sysctl-c99-convert-arch-sh64-kernel-trapsc-and-remove-abi-breakage.patch
sysctl-x86_64-remove-unnecessary-use-of-insert_at_head.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-ia32-ia32_binfmtc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-kernel-vsyscallc.patch
sysctl-c99-convert-ctl_tables-in-arch-x86_64-mm-initc.patch
sysctl-remove-sys_sysctl-support-from-the-hpet-timer-driver.patch
sysctl-remove-sys_sysctl-support-from-drivers-char-rtcc.patch
sysctl-register-the-sysctl-number-used-by-the-arlan-driver.patch
sysctl-c99-convert-ctl_tables-in-drivers-parport-procfsc.patch
sysctl-c99-convert-coda-ctl_tables-and-remove-binary-sysctls.patch
sysctl-c99-convert-ctl_tables-in-ntfs-and-remove-sys_sysctl-support.patch
sysctl-register-the-ocfs2-sysctl-numbers.patch
sysctl-move-init_irq_proc-into-init-main-where-it-belongs.patch
sysctl-move-utsname-sysctls-to-their-own-file.patch
sysctl-move-sysv-ipc-sysctls-to-their-own-file.patch
sysctl-create-sys-fs-binfmt_misc-as-an-ordinary-sysctl-entry.patch
sysctl-remove-support-for-ctl_any.patch
sysctl-remove-support-for-directory-strategy-routines.patch
sysctl-remove-insert_at_head-from-register_sysctl.patch
sysctl-factor-out-sysctl_head_next-from-do_sysctl.patch
sysctl-allow-sysctl_perm-to-be-called-from-outside-of-sysctlc.patch
sysctl-reimplement-the-sysctl-proc-support.patch
sysctl-remove-the-proc_dir_entry-member-for-the-sysctl-tables.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
