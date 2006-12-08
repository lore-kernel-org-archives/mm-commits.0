From: akpm@osdl.org
Subject: - sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:12:02 -0800
Message-ID: <200612082012.kB8KC2W4002973@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59188 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946686AbWLHUME (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: fix sys_sysctl interface of ipc sysctls
has been removed from the -mm tree.  Its filename was
     sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: fix sys_sysctl interface of ipc sysctls
From: "Eric W. Biederman" <ebiederm@xmission.com>

Currently there is a regression and the ipc sysctls don't show up in the
binary sysctl namespace.

This patch adds sysctl_ipc_data to read data/write from the appropriate
namespace and deliver it in the expected manner.

[akpm@osdl.org: warning fix]
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |   60 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff -puN kernel/sysctl.c~sysctl-fix-sys_sysctl-interface-of-ipc-sysctls kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-fix-sys_sysctl-interface-of-ipc-sysctls
+++ a/kernel/sysctl.c
@@ -143,6 +143,12 @@ static int sysctl_uts_string(ctl_table *
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen, void **context);
 
+#ifdef CONFIG_SYSVIPC
+static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
+		  void __user *oldval, size_t __user *oldlenp,
+		  void __user *newval, size_t newlen, void **context);
+#endif
+
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
@@ -476,6 +482,7 @@ static ctl_table kern_table[] = {
 		.maxlen		= sizeof (init_ipc_ns.shm_ctlmax),
 		.mode		= 0644,
 		.proc_handler	= &proc_ipc_doulongvec_minmax,
+		.strategy	= sysctl_ipc_data,
 	},
 	{
 		.ctl_name	= KERN_SHMALL,
@@ -484,6 +491,7 @@ static ctl_table kern_table[] = {
 		.maxlen		= sizeof (init_ipc_ns.shm_ctlall),
 		.mode		= 0644,
 		.proc_handler	= &proc_ipc_doulongvec_minmax,
+		.strategy	= sysctl_ipc_data,
 	},
 	{
 		.ctl_name	= KERN_SHMMNI,
@@ -492,6 +500,7 @@ static ctl_table kern_table[] = {
 		.maxlen		= sizeof (init_ipc_ns.shm_ctlmni),
 		.mode		= 0644,
 		.proc_handler	= &proc_ipc_dointvec,
+		.strategy	= sysctl_ipc_data,
 	},
 	{
 		.ctl_name	= KERN_MSGMAX,
@@ -500,6 +509,7 @@ static ctl_table kern_table[] = {
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmax),
 		.mode		= 0644,
 		.proc_handler	= &proc_ipc_dointvec,
+		.strategy	= sysctl_ipc_data,
 	},
 	{
 		.ctl_name	= KERN_MSGMNI,
@@ -508,6 +518,7 @@ static ctl_table kern_table[] = {
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmni),
 		.mode		= 0644,
 		.proc_handler	= &proc_ipc_dointvec,
+		.strategy	= sysctl_ipc_data,
 	},
 	{
 		.ctl_name	= KERN_MSGMNB,
@@ -516,6 +527,7 @@ static ctl_table kern_table[] = {
 		.maxlen		= sizeof (init_ipc_ns.msg_ctlmnb),
 		.mode		= 0644,
 		.proc_handler	= &proc_ipc_dointvec,
+		.strategy	= sysctl_ipc_data,
 	},
 	{
 		.ctl_name	= KERN_SEM,
@@ -524,6 +536,7 @@ static ctl_table kern_table[] = {
 		.maxlen		= 4*sizeof (int),
 		.mode		= 0644,
 		.proc_handler	= &proc_ipc_dointvec,
+		.strategy	= sysctl_ipc_data,
 	},
 #endif
 #ifdef CONFIG_MAGIC_SYSRQ
@@ -2611,6 +2624,47 @@ static int sysctl_uts_string(ctl_table *
 	return r;
 }
 
+#ifdef CONFIG_SYSVIPC
+/* The generic sysctl ipc data routine. */
+static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen, void **context)
+{
+	size_t len;
+	void *data;
+
+	/* Get out of I don't have a variable */
+	if (!table->data || !table->maxlen)
+		return -ENOTDIR;
+
+	data = get_ipc(table, 1);
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
+#endif
+
 #else /* CONFIG_SYSCTL_SYSCALL */
 
 
@@ -2681,6 +2735,12 @@ static int sysctl_uts_string(ctl_table *
 {
 	return -ENOSYS;
 }
+static int sysctl_ipc_data(ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen, void **context)
+{
+	return -ENOSYS;
+}
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
 /*
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
sysctl-fix-sys_sysctl-interface-of-ipc-sysctls.patch
genapic-optimize-fix-apic-mode-setup-2.patch
genapic-always-use-physical-delivery-mode-on-8-cpus.patch
genapic-remove-es7000-workaround.patch
genapic-remove-clustered-apic-mode.patch
genapic-default-to-physical-mode-on-hotplug-cpu-kernels.patch
sched2-sched-domain-sysctl-use-ctl_unnumbered.patch
mm-implement-swap-prefetching-use-ctl_unnumbered.patch
readahead-sysctl-parameters-use-ctl_unnumbered.patch
updated-i386-cleanup-apic-code.patch
updated-i386-rework-local-apic-calibration.patch
updated-dynticks-fix-nmi-watchdog.patch
clockevents-core-check-for-clock-event-device-handler-being-non-null-before-calling-it.patch
pidhash-temporary-debug-checks.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch

