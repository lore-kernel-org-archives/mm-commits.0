From: akpm@osdl.org
Subject: - sysctl-implement-sysctl_uts_string.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:55 -0800
Message-ID: <200612082011.kB8KBtLB002960@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59173 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946614AbWLHUL7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: implement sysctl_uts_string()
has been removed from the -mm tree.  Its filename was
     sysctl-implement-sysctl_uts_string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: implement sysctl_uts_string()
From: "Eric W. Biederman" <ebiederm@xmission.com>

The problem: When using sys_sysctl we don't read the proper values for the
variables exported from the uts namespace, nor do we do the proper locking.

This patch introduces sysctl_uts_string which properly fetches the values and
does the proper locking.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |   37 ++++++++++++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 5 deletions(-)

diff -puN kernel/sysctl.c~sysctl-implement-sysctl_uts_string kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-implement-sysctl_uts_string
+++ a/kernel/sysctl.c
@@ -137,6 +137,10 @@ static int parse_table(int __user *, int
 static int proc_do_uts_string(ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
 
+static int sysctl_uts_string(ctl_table *table, int __user *name, int nlen,
+		  void __user *oldval, size_t __user *oldlenp,
+		  void __user *newval, size_t newlen, void **context);
+
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
@@ -258,7 +262,7 @@ static ctl_table kern_table[] = {
 		.maxlen		= sizeof(init_uts_ns.name.sysname),
 		.mode		= 0444,
 		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_string,
+		.strategy	= &sysctl_uts_string,
 	},
 	{
 		.ctl_name	= KERN_OSRELEASE,
@@ -267,7 +271,7 @@ static ctl_table kern_table[] = {
 		.maxlen		= sizeof(init_uts_ns.name.release),
 		.mode		= 0444,
 		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_string,
+		.strategy	= &sysctl_uts_string,
 	},
 	{
 		.ctl_name	= KERN_VERSION,
@@ -276,7 +280,7 @@ static ctl_table kern_table[] = {
 		.maxlen		= sizeof(init_uts_ns.name.version),
 		.mode		= 0444,
 		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_string,
+		.strategy	= &sysctl_uts_string,
 	},
 	{
 		.ctl_name	= KERN_NODENAME,
@@ -285,7 +289,7 @@ static ctl_table kern_table[] = {
 		.maxlen		= sizeof(init_uts_ns.name.nodename),
 		.mode		= 0644,
 		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_string,
+		.strategy	= &sysctl_uts_string,
 	},
 	{
 		.ctl_name	= KERN_DOMAINNAME,
@@ -294,7 +298,7 @@ static ctl_table kern_table[] = {
 		.maxlen		= sizeof(init_uts_ns.name.domainname),
 		.mode		= 0644,
 		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_string,
+		.strategy	= &sysctl_uts_string,
 	},
 	{
 		.ctl_name	= KERN_PANIC,
@@ -2598,6 +2602,23 @@ int sysctl_ms_jiffies(ctl_table *table, 
 	return 1;
 }
 
+
+/* The generic string strategy routine: */
+static int sysctl_uts_string(ctl_table *table, int __user *name, int nlen,
+		  void __user *oldval, size_t __user *oldlenp,
+		  void __user *newval, size_t newlen, void **context)
+{
+	struct ctl_table uts_table;
+	int r, write;
+	write = newval && newlen;
+	memcpy(&uts_table, table, sizeof(uts_table));
+	uts_table.data = get_uts(table, write);
+	r = sysctl_string(&uts_table, name, nlen,
+		oldval, oldlenp, newval, newlen, context);
+	put_uts(table, write, uts_table.data);
+	return r;
+}
+
 #else /* CONFIG_SYSCTL_SYSCALL */
 
 
@@ -2662,6 +2683,12 @@ int sysctl_ms_jiffies(ctl_table *table, 
 	return -ENOSYS;
 }
 
+static int sysctl_uts_string(ctl_table *table, int __user *name, int nlen,
+		  void __user *oldval, size_t __user *oldlenp,
+		  void __user *newval, size_t newlen, void **context)
+{
+	return -ENOSYS;
+}
 #endif /* CONFIG_SYSCTL_SYSCALL */
 
 /*
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
sysctl-implement-sysctl_uts_string.patch
sysctl-simplify-ipc-ns-specific-sysctls.patch
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

