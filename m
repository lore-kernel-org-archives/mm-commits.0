From: akpm@linux-foundation.org
Subject: [merged] sysctl-add-the-kernelns_last_pid-control.patch removed from -mm tree
Date: Fri, 13 Jan 2012 12:36:37 -0800
Message-ID: <20120113203638.6921F20004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ww0-f74.google.com ([74.125.82.74]:40171 "EHLO
	mail-ww0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932798Ab2AMUgk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Jan 2012 15:36:40 -0500
Received: by mail-ww0-f74.google.com with SMTP id dt14so106252wgb.1
        for <mm-commits@vger.kernel.org>; Fri, 13 Jan 2012 12:36:40 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@parallels.com, ebiederm@xmission.com, gorcunov@openvz.org, oleg@redhat.com, serue@us.ibm.com, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: add the kernel.ns_last_pid control
has been removed from the -mm tree.  Its filename was
     sysctl-add-the-kernelns_last_pid-control.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Pavel Emelyanov <xemul@parallels.com>
Subject: sysctl: add the kernel.ns_last_pid control

The sysctl works on the current task's pid namespace, getting and setting
its last_pid field.

Writing is allowed for CAP_SYS_ADMIN-capable tasks thus making it possible
to create a task with desired pid value.  This ability is required badly
for the checkpoint/restore in userspace.

This approach suits all the parties for now.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |    8 +++++++
 kernel/pid.c                    |    4 ++-
 kernel/pid_namespace.c          |   31 ++++++++++++++++++++++++++++++
 3 files changed, 42 insertions(+), 1 deletion(-)

diff -puN Documentation/sysctl/kernel.txt~sysctl-add-the-kernelns_last_pid-control Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~sysctl-add-the-kernelns_last_pid-control
+++ a/Documentation/sysctl/kernel.txt
@@ -415,6 +415,14 @@ PIDs of value pid_max or larger are not 
 
 ==============================================================
 
+ns_last_pid:
+
+The last pid allocated in the current (the one task using this sysctl
+lives in) pid namespace. When selecting a pid for a next task on fork
+kernel tries to allocate a number starting from this one.
+
+==============================================================
+
 powersave-nap: (PPC only)
 
 If set, Linux-PPC will use the 'nap' mode of powersaving,
diff -puN kernel/pid.c~sysctl-add-the-kernelns_last_pid-control kernel/pid.c
--- a/kernel/pid.c~sysctl-add-the-kernelns_last_pid-control
+++ a/kernel/pid.c
@@ -137,7 +137,9 @@ static int pid_before(int base, int a, i
 }
 
 /*
- * We might be racing with someone else trying to set pid_ns->last_pid.
+ * We might be racing with someone else trying to set pid_ns->last_pid
+ * at the pid allocation time (there's also a sysctl for this, but racing
+ * with this one is OK, see comment in kernel/pid_namespace.c about it).
  * We want the winner to have the "later" value, because if the
  * "earlier" value prevails, then a pid may get reused immediately.
  *
diff -puN kernel/pid_namespace.c~sysctl-add-the-kernelns_last_pid-control kernel/pid_namespace.c
--- a/kernel/pid_namespace.c~sysctl-add-the-kernelns_last_pid-control
+++ a/kernel/pid_namespace.c
@@ -191,9 +191,40 @@ void zap_pid_ns_processes(struct pid_nam
 	return;
 }
 
+static int pid_ns_ctl_handler(struct ctl_table *table, int write,
+		void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table tmp = *table;
+
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/*
+	 * Writing directly to ns' last_pid field is OK, since this field
+	 * is volatile in a living namespace anyway and a code writing to
+	 * it should synchronize its usage with external means.
+	 */
+
+	tmp.data = &current->nsproxy->pid_ns->last_pid;
+	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
+}
+
+static struct ctl_table pid_ns_ctl_table[] = {
+	{
+		.procname = "ns_last_pid",
+		.maxlen = sizeof(int),
+		.mode = 0666, /* permissions are checked in the handler */
+		.proc_handler = pid_ns_ctl_handler,
+	},
+	{ }
+};
+
+static struct ctl_path kern_path[] = { { .procname = "kernel", }, { } };
+
 static __init int pid_namespaces_init(void)
 {
 	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
+	register_sysctl_paths(kern_path, pid_ns_ctl_table);
 	return 0;
 }
 
_

Patches currently in -mm which might be from xemul@parallels.com are

origin.patch
linux-next.patch

