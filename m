From: akpm@osdl.org
Subject: - sysctl-simplify-sysctl_uts_string.patch removed from -mm tree
Date: Fri, 08 Dec 2006 12:11:52 -0800
Message-ID: <200612082011.kB8KBqu8002957@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:59163 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946642AbWLHULz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 15:11:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: simplify sysctl_uts_string
has been removed from the -mm tree.  Its filename was
     sysctl-simplify-sysctl_uts_string.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: simplify sysctl_uts_string
From: "Eric W. Biederman" <ebiederm@xmission.com>

The binary interface to the namespace sysctls was never implemented resulting
in some really weird things if you attempted to use sys_sysctl to read your
hostname for example.

This patch series simples the code a little and implements the binary sysctl
interface.

In testing this patch series I discovered that our 32bit compatibility for the
binary sysctl interface is imperfect.  In particular KERN_SHMMAX and
KERN_SMMALL are size_t sized quantities and are returned as 8 bytes on to
32bit binaries using a x86_64 kernel.  However this has existing for a long
time so it is not a new regression with the namespace work.

Gads the whole sysctl thing needs work before it stops being easy to shoot
yourself in the foot.

Looking forward a little bit we need a better way to handle sysctls and
namespaces as our current technique will not work for the network namespace. 
I think something based on the current overlapping sysctl trees will work but
the proc side needs to be redone before we can use it.



This patch:

Introduce get_uts() and put_uts() (used later) and remove most of the special
cases for when UTS namespace is compiled in.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 kernel/sysctl.c |  128 +++++++++-------------------------------------
 1 file changed, 26 insertions(+), 102 deletions(-)

diff -puN kernel/sysctl.c~sysctl-simplify-sysctl_uts_string kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-simplify-sysctl_uts_string
+++ a/kernel/sysctl.c
@@ -163,6 +163,28 @@ extern ctl_table inotify_table[];
 int sysctl_legacy_va_layout;
 #endif
 
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
 /* /proc declarations: */
 
 #ifdef CONFIG_PROC_SYSCTL
@@ -229,7 +251,6 @@ static ctl_table root_table[] = {
 };
 
 static ctl_table kern_table[] = {
-#ifndef CONFIG_UTS_NS
 	{
 		.ctl_name	= KERN_OSTYPE,
 		.procname	= "ostype",
@@ -275,54 +296,6 @@ static ctl_table kern_table[] = {
 		.proc_handler	= &proc_do_uts_string,
 		.strategy	= &sysctl_string,
 	},
-#else  /* !CONFIG_UTS_NS */
-	{
-		.ctl_name	= KERN_OSTYPE,
-		.procname	= "ostype",
-		.data		= NULL,
-		/* could maybe use __NEW_UTS_LEN here? */
-		.maxlen		= FIELD_SIZEOF(struct new_utsname, sysname),
-		.mode		= 0444,
-		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_string,
-	},
-	{
-		.ctl_name	= KERN_OSRELEASE,
-		.procname	= "osrelease",
-		.data		= NULL,
-		.maxlen		= FIELD_SIZEOF(struct new_utsname, release),
-		.mode		= 0444,
-		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_string,
-	},
-	{
-		.ctl_name	= KERN_VERSION,
-		.procname	= "version",
-		.data		= NULL,
-		.maxlen		= FIELD_SIZEOF(struct new_utsname, version),
-		.mode		= 0444,
-		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_string,
-	},
-	{
-		.ctl_name	= KERN_NODENAME,
-		.procname	= "hostname",
-		.data		= NULL,
-		.maxlen		= FIELD_SIZEOF(struct new_utsname, nodename),
-		.mode		= 0644,
-		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_string,
-	},
-	{
-		.ctl_name	= KERN_DOMAINNAME,
-		.procname	= "domainname",
-		.data		= NULL,
-		.maxlen		= FIELD_SIZEOF(struct new_utsname, domainname),
-		.mode		= 0644,
-		.proc_handler	= &proc_do_uts_string,
-		.strategy	= &sysctl_string,
-	},
-#endif /* !CONFIG_UTS_NS */
 	{
 		.ctl_name	= KERN_PANIC,
 		.procname	= "panic",
@@ -1753,66 +1726,17 @@ int proc_dostring(ctl_table *table, int 
  *	Special case of dostring for the UTS structure. This has locks
  *	to observe. Should this be in kernel/sys.c ????
  */
- 
-#ifndef CONFIG_UTS_NS
-static int proc_do_uts_string(ctl_table *table, int write, struct file *filp,
-		  void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	int r;
 
-	if (!write) {
-		down_read(&uts_sem);
-		r=proc_dostring(table,0,filp,buffer,lenp, ppos);
-		up_read(&uts_sem);
-	} else {
-		down_write(&uts_sem);
-		r=proc_dostring(table,1,filp,buffer,lenp, ppos);
-		up_write(&uts_sem);
-	}
-	return r;
-}
-#else /* !CONFIG_UTS_NS */
 static int proc_do_uts_string(ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos)
 {
 	int r;
-	struct uts_namespace* uts_ns = current->nsproxy->uts_ns;
-	char* which;
-
-	switch (table->ctl_name) {
-	case KERN_OSTYPE:
-		which = uts_ns->name.sysname;
-		break;
-	case KERN_NODENAME:
-		which = uts_ns->name.nodename;
-		break;
-	case KERN_OSRELEASE:
-		which = uts_ns->name.release;
-		break;
-	case KERN_VERSION:
-		which = uts_ns->name.version;
-		break;
-	case KERN_DOMAINNAME:
-		which = uts_ns->name.domainname;
-		break;
-	default:
-		r = -EINVAL;
-		goto out;
-	}
-
-	if (!write) {
-		down_read(&uts_sem);
-		r=_proc_do_string(which,table->maxlen,0,filp,buffer,lenp, ppos);
-		up_read(&uts_sem);
-	} else {
-		down_write(&uts_sem);
-		r=_proc_do_string(which,table->maxlen,1,filp,buffer,lenp, ppos);
-		up_write(&uts_sem);
-	}
- out:
+	void *which;
+	which = get_uts(table, write);
+	r = _proc_do_string(which, table->maxlen,write,filp,buffer,lenp, ppos);
+	put_uts(table, write, which);
 	return r;
 }
-#endif /* !CONFIG_UTS_NS */
 
 static int do_proc_dointvec_conv(int *negp, unsigned long *lvalp,
 				 int *valp,
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
sysctl-simplify-sysctl_uts_string.patch
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

