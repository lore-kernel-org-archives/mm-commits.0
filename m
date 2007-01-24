From: akpm@osdl.org
Subject: + sysctl-move-utsname-sysctls-to-their-own-file.patch added to -mm tree
Date: Tue, 23 Jan 2007 19:13:37 -0800
Message-ID: <200701240313.l0O3DbxO006971@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:49392 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030192AbXAXDUz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jan 2007 22:20:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, dev@sw.ru, herbert@13thfloor.at, serue@us.ibm.com


The patch titled
     sysctl: move utsname sysctls to their own file
has been added to the -mm tree.  Its filename is
     sysctl-move-utsname-sysctls-to-their-own-file.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/Makefile         |    1 
 kernel/sysctl.c         |  115 -----------------------------
 kernel/utsname_sysctl.c |  146 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 147 insertions(+), 115 deletions(-)

diff -puN kernel/Makefile~sysctl-move-utsname-sysctls-to-their-own-file kernel/Makefile
--- a/kernel/Makefile~sysctl-move-utsname-sysctls-to-their-own-file
+++ a/kernel/Makefile
@@ -53,6 +53,7 @@ obj-$(CONFIG_RCU_TRACE) += rcupreempt_tr
 endif
 obj-$(CONFIG_RELAY) += relay.o
 obj-$(CONFIG_UTS_NS) += utsname.o
+obj-$(CONFIG_SYSCTL) += utsname_sysctl.o
 obj-$(CONFIG_TASK_DELAY_ACCT) += delayacct.o
 obj-$(CONFIG_TASKSTATS) += taskstats.o tsacct.o
 
diff -puN kernel/sysctl.c~sysctl-move-utsname-sysctls-to-their-own-file kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-move-utsname-sysctls-to-their-own-file
+++ a/kernel/sysctl.c
@@ -141,13 +141,6 @@ static int parse_table(int __user *, int
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
@@ -183,27 +176,6 @@ int sysctl_legacy_va_layout;
 #endif
 
 
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
 
 #ifdef CONFIG_SYSVIPC
 static void *get_ipc(ctl_table *table, int write)
@@ -284,51 +256,6 @@ static ctl_table root_table[] = {
 
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
@@ -1789,21 +1716,6 @@ int proc_dostring(ctl_table *table, int 
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
@@ -2440,12 +2352,6 @@ int proc_dostring(ctl_table *table, int 
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
@@ -2675,21 +2581,6 @@ int sysctl_ms_jiffies(ctl_table *table, 
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
@@ -2796,12 +2687,6 @@ int sysctl_ms_jiffies(ctl_table *table, 
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
