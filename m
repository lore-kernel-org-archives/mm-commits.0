From: akpm@linux-foundation.org
Subject: - cleanup-the-code-managed-with-the-user_ns-option.patch removed from -mm tree
Date: Fri, 08 Feb 2008 12:11:39 -0800
Message-ID: <200802082011.m18KBK8Q010110@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51531 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757708AbYBHVFU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Feb 2008 16:05:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com, sukadev@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     namespaces: cleanup the code managed with the USER_NS option
has been removed from the -mm tree.  Its filename was
     cleanup-the-code-managed-with-the-user_ns-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: namespaces: cleanup the code managed with the USER_NS option
From: Pavel Emelyanov <xemul@openvz.org>

Make the user_namespace.o compilation depend on this option and move the
init_user_ns into user.c file to make the kernel compile and work without the
namespaces support.  This make the user namespace code be organized similar to
other namespaces'.

Also mask the USER_NS option as "depend on NAMESPACES".

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Kirill Korotaev <dev@sw.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig            |   17 ++++++++---------
 kernel/Makefile         |    5 +++--
 kernel/user.c           |   10 ++++++++++
 kernel/user_namespace.c |   13 -------------
 4 files changed, 21 insertions(+), 24 deletions(-)

diff -puN init/Kconfig~cleanup-the-code-managed-with-the-user_ns-option init/Kconfig
--- a/init/Kconfig~cleanup-the-code-managed-with-the-user_ns-option
+++ a/init/Kconfig
@@ -214,15 +214,6 @@ config TASK_IO_ACCOUNTING
 
 	  Say N if unsure.
 
-config USER_NS
-	bool "User Namespaces (EXPERIMENTAL)"
-	default n
-	depends on EXPERIMENTAL
-	help
-	  Support user namespaces.  This allows containers, i.e.
-	  vservers, to use user namespaces to provide different
-	  user info for different servers.  If unsure, say N.
-
 config PID_NS
 	bool "PID Namespaces (EXPERIMENTAL)"
 	default n
@@ -443,6 +434,14 @@ config IPC_NS
 	  In this namespace tasks work with IPC ids which correspond to
 	  different IPC objects in different namespaces
 
+config USER_NS
+	bool "User namespace (EXPERIMENTAL)"
+	depends on NAMESPACES && EXPERIMENTAL
+	help
+	  This allows containers, i.e. vservers, to use user namespaces
+	  to provide different user info for different servers.
+	  If unsure, say N.
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
diff -puN kernel/Makefile~cleanup-the-code-managed-with-the-user_ns-option kernel/Makefile
--- a/kernel/Makefile~cleanup-the-code-managed-with-the-user_ns-option
+++ a/kernel/Makefile
@@ -4,7 +4,7 @@
 
 obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    exit.o itimer.o time.o softirq.o resource.o \
-	    sysctl.o capability.o ptrace.o timer.o user.o user_namespace.o \
+	    sysctl.o capability.o ptrace.o timer.o user.o \
 	    signal.o sys.o kmod.o workqueue.o pid.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
@@ -33,7 +33,6 @@ obj-$(CONFIG_PROVE_LOCKING) += spinlock.
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
-obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_PM) += power/
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
@@ -43,6 +42,8 @@ obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_DEBUG) += cgroup_debug.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
+obj-$(CONFIG_UTS_NS) += utsname.o
+obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_IKCONFIG) += configs.o
 obj-$(CONFIG_RESOURCE_COUNTERS) += res_counter.o
 obj-$(CONFIG_STOP_MACHINE) += stop_machine.o
diff -puN kernel/user.c~cleanup-the-code-managed-with-the-user_ns-option kernel/user.c
--- a/kernel/user.c~cleanup-the-code-managed-with-the-user_ns-option
+++ a/kernel/user.c
@@ -17,6 +17,14 @@
 #include <linux/module.h>
 #include <linux/user_namespace.h>
 
+struct user_namespace init_user_ns = {
+	.kref = {
+		.refcount	= ATOMIC_INIT(2),
+	},
+	.root_user = &root_user,
+};
+EXPORT_SYMBOL_GPL(init_user_ns);
+
 /*
  * UID task count cache, to get fast user lookup in "alloc_uid"
  * when changing user ID's (ie setuid() and friends).
@@ -427,6 +435,7 @@ void switch_uid(struct user_struct *new_
 	suid_keys(current);
 }
 
+#ifdef CONFIG_USER_NS
 void release_uids(struct user_namespace *ns)
 {
 	int i;
@@ -451,6 +460,7 @@ void release_uids(struct user_namespace 
 
 	free_uid(ns->root_user);
 }
+#endif
 
 static int __init uid_cache_init(void)
 {
diff -puN kernel/user_namespace.c~cleanup-the-code-managed-with-the-user_ns-option kernel/user_namespace.c
--- a/kernel/user_namespace.c~cleanup-the-code-managed-with-the-user_ns-option
+++ a/kernel/user_namespace.c
@@ -10,17 +10,6 @@
 #include <linux/nsproxy.h>
 #include <linux/user_namespace.h>
 
-struct user_namespace init_user_ns = {
-	.kref = {
-		.refcount	= ATOMIC_INIT(2),
-	},
-	.root_user = &root_user,
-};
-
-EXPORT_SYMBOL_GPL(init_user_ns);
-
-#ifdef CONFIG_USER_NS
-
 /*
  * Clone a new ns copying an original user ns, setting refcount to 1
  * @old_ns: namespace to clone
@@ -84,5 +73,3 @@ void free_user_ns(struct kref *kref)
 	release_uids(ns);
 	kfree(ns);
 }
-
-#endif /* CONFIG_USER_NS */
_

Patches currently in -mm which might be from xemul@openvz.org are

origin.patch
revert-proc-fix-the-threaded-proc-self.patch
use-find_task_by_vpid-in-audit-code.patch
ia64-fix-ptrace-inside-a-namespace.patch
mips-use-find_task_by_vpid-in-system-calls.patch
deprecate-find_task_by_pid-kgdb.patch
use-find_task_by_vpid-in-taskstats.patch
deprecate-find_task_by_pid.patch
reiser4.patch
