From: akpm@osdl.org
Subject: - sysctl-simplify-ipc-ns-specific-sysctls.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:59 -0800
Message-ID: <200612082012.kB8KBxWj002970@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59184 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946656AbWLHUMC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:12:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: simplify ipc ns specific sysctls
has been removed from the -mm tree.  Its filename was
     sysctl-simplify-ipc-ns-specific-sysctls.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: simplify ipc ns specific sysctls
From: "Eric W. Biederman" <ebiederm@xmission.com>

Refactor the ipc sysctl support so that it is simpler, more readable, and
prepares for fixing the bug with the wrong values being returned in the
sys_sysctl interface.

The function proc_do_ipc_string() was misnamed as it never handled strings. 
It's magic of when to work with strings and when to work with longs belonged
in the sysctl table.  I couldn't tell if the code would work if you disabled
the ipc namespace but it certainly looked like it would have problems.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |  106 +++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 57 deletions(-)

diff -puN kernel/sysctl.c~sysctl-simplify-ipc-ns-specific-sysctls kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-simplify-ipc-ns-specific-sysctls
+++ a/kernel/sysctl.c
@@ -92,7 +92,9 @@ extern char modprobe_path[];
 extern int sg_big_buff;
 #endif
 #ifdef CONFIG_SYSVIPC
-static int proc_do_ipc_string(ctl_table *table, int write, struct file *filp,
+static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
+		void __user *buffer, size_t *lenp, loff_t *ppos);
+static int proc_ipc_doulongvec_minmax(ctl_table *table, int write, struct file *filp,
 		void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
@@ -189,6 +191,18 @@ static void put_uts(ctl_table *table, in
 		up_write(&uts_sem);
 }
 
+#ifdef CONFIG_SYSVIPC
+static void *get_ipc(ctl_table *table, int write)
+{
+	char *which = table->data;
+	struct ipc_namespace *ipc_ns = current->nsproxy->ipc_ns;
+	which = (which - (char *)&init_ipc_ns) + (char *)ipc_ns;
+	return which;
+}
+#else
+#define get_ipc(T,W) ((T)->data)
+#endif
+
 /* /proc declarations: */
 
 #ifdef CONFIG_PROC_SYSCTL
@@ -458,58 +472,58 @@ static ctl_table kern_table[] = {
 	{
 		.ctl_name	= KERN_SHMMAX,
 		.procname	= "shmmax",
-		.data		= NULL,
-		.maxlen		= sizeof (size_t),
+		.data		= &init_ipc_ns.shm_ctlmax,
+		.maxlen		= sizeof (init_ipc_ns.shm_ctlmax),
 		.mode		= 0644,
-		.proc_handler	= &proc_do_ipc_string,
+		.proc_handler	= &proc_ipc_doulongvec_minmax,
 	},
 	{
 		.ctl_name	= KERN_SHMALL,
 		.procname	= "shmall",
-		.data		= NULL,
-		.maxlen		= sizeof (size_t),
+		.data		= &init_ipc_ns.shm_ctlall,
+		.maxlen		= sizeof (init_ipc_ns.shm_ctlall),
 		.mode		= 0644,
-		.proc_handler	= &proc_do_ipc_string,
+		.proc_handler	= &proc_ipc_doulongvec_minmax,
 	},
 	{
 		.ctl_name	= KERN_SHMMNI,
 		.procname	= "shmmni",
-		.data		= NULL,
-		.maxlen		= sizeof (int),
+		.data		= &init_ipc_ns.shm_ctlmni,
+		.maxlen		= sizeof (init_ipc_ns.shm_ctlmni),
 		.mode		= 0644,
-		.proc_handler	= &proc_do_ipc_string,
+		.proc_handler	= &proc_ipc_dointvec,
 	},
 	{
 		.ctl_name	= KERN_MSGMAX,
 		.procname	= "msgmax",
-		.data		= NULL,
-		.maxlen		= sizeof (int),
+		.data		= &init_ipc_ns.msg_ctlmax,
+		.maxlen		= sizeof (init_ipc_ns.msg_ctlmax),
 		.mode		= 0644,
-		.proc_handler	= &proc_do_ipc_string,
+		.proc_handler	= &proc_ipc_dointvec,
 	},
 	{
 		.ctl_name	= KERN_MSGMNI,
 		.procname	= "msgmni",
-		.data		= NULL,
-		.maxlen		= sizeof (int),
+		.data		= &init_ipc_ns.msg_ctlmni,
+		.maxlen		= sizeof (init_ipc_ns.msg_ctlmni),
 		.mode		= 0644,
-		.proc_handler	= &proc_do_ipc_string,
+		.proc_handler	= &proc_ipc_dointvec,
 	},
 	{
 		.ctl_name	= KERN_MSGMNB,
 		.procname	=  "msgmnb",
-		.data		= NULL,
-		.maxlen		= sizeof (int),
+		.data		= &init_ipc_ns.msg_ctlmnb,
+		.maxlen		= sizeof (init_ipc_ns.msg_ctlmnb),
 		.mode		= 0644,
-		.proc_handler	= &proc_do_ipc_string,
+		.proc_handler	= &proc_ipc_dointvec,
 	},
 	{
 		.ctl_name	= KERN_SEM,
 		.procname	= "sem",
-		.data		= NULL,
+		.data		= &init_ipc_ns.sem_ctls,
 		.maxlen		= 4*sizeof (int),
 		.mode		= 0644,
-		.proc_handler	= &proc_do_ipc_string,
+		.proc_handler	= &proc_ipc_dointvec,
 	},
 #endif
 #ifdef CONFIG_MAGIC_SYSRQ
@@ -2319,46 +2333,24 @@ int proc_dointvec_ms_jiffies(ctl_table *
 }
 
 #ifdef CONFIG_SYSVIPC
-static int proc_do_ipc_string(ctl_table *table, int write, struct file *filp,
-		void __user *buffer, size_t *lenp, loff_t *ppos)
+static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
+	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	void *data;
-	struct ipc_namespace *ns;
-
-	ns = current->nsproxy->ipc_ns;
-
-	switch (table->ctl_name) {
-	case KERN_SHMMAX:
-		data = &ns->shm_ctlmax;
-		goto proc_minmax;
-	case KERN_SHMALL:
-		data = &ns->shm_ctlall;
-		goto proc_minmax;
-	case KERN_SHMMNI:
-		data = &ns->shm_ctlmni;
-		break;
-	case KERN_MSGMAX:
-		data = &ns->msg_ctlmax;
-		break;
-	case KERN_MSGMNI:
-		data = &ns->msg_ctlmni;
-		break;
-	case KERN_MSGMNB:
-		data = &ns->msg_ctlmnb;
-		break;
-	case KERN_SEM:
-		data = &ns->sem_ctls;
-		break;
-	default:
-		return -EINVAL;
-	}
-
-	return __do_proc_dointvec(data, table, write, filp, buffer,
+	void *which;
+	which = get_ipc(table, write);
+	return __do_proc_dointvec(which, table, write, filp, buffer,
 			lenp, ppos, NULL, NULL);
-proc_minmax:
-	return __do_proc_doulongvec_minmax(data, table, write, filp, buffer,
+}
+
+static int proc_ipc_doulongvec_minmax(ctl_table *table, int write,
+	struct file *filp, void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	void *which;
+	which = get_ipc(table, write);
+	return __do_proc_doulongvec_minmax(which, table, write, filp, buffer,
 			lenp, ppos, 1l, 1l);
 }
+
 #endif
 
 static int proc_do_cad_pid(ctl_table *table, int write, struct file *filp,
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
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

