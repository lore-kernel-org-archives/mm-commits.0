From: akpm@linux-foundation.org
Subject: + cleanup-the-code-managed-with-the-user_ns-option.patch added to -mm tree
Date: Thu, 15 Nov 2007 16:01:56 -0800
Message-ID: <200711160001.lAG01uci022719@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51234 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763730AbXKPACr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 19:02:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, clg@fr.ibm.com, dev@sw.ru, ebiederm@xmission.com, herbert@13thfloor.at, serue@us.ibm.com, sukadev@us.ibm.com


The patch titled
     namespaces: cleanup the code managed with the USER_NS option
has been added to the -mm tree.  Its filename is
     cleanup-the-code-managed-with-the-user_ns-option.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: namespaces: cleanup the code managed with the USER_NS option
From: Pavel Emelyanov <xemul@openvz.org>

Make the user_namespace.o compilation depend on this option and move the
init_user_ns into user.c file to make the kernel compile and work without the
namespaces support.  This make the user namespace code be organized similar to
other namespaces'.

Also mask the USER_NS option as "depend on NAMESPACES".

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
 kernel/Makefile         |    3 ++-
 kernel/user.c           |   11 +++++++++++
 kernel/user_namespace.c |   13 -------------
 4 files changed, 21 insertions(+), 23 deletions(-)

diff -puN init/Kconfig~cleanup-the-code-managed-with-the-user_ns-option init/Kconfig
--- a/init/Kconfig~cleanup-the-code-managed-with-the-user_ns-option
+++ a/init/Kconfig
@@ -206,15 +206,6 @@ config TASK_IO_ACCOUNTING
 
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
@@ -427,6 +418,14 @@ config IPC_NS
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
@@ -49,6 +49,7 @@ obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
 obj-$(CONFIG_UTS_NS) += utsname.o
+obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_SYSFS) += ksysfs.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
diff -puN kernel/user.c~cleanup-the-code-managed-with-the-user_ns-option kernel/user.c
--- a/kernel/user.c~cleanup-the-code-managed-with-the-user_ns-option
+++ a/kernel/user.c
@@ -17,6 +17,15 @@
 #include <linux/module.h>
 #include <linux/user_namespace.h>
 
+struct user_namespace init_user_ns = {
+	.kref = {
+		.refcount	= ATOMIC_INIT(2),
+	},
+	.root_user = &root_user,
+};
+
+EXPORT_SYMBOL_GPL(init_user_ns);
+
 /*
  * UID task count cache, to get fast user lookup in "alloc_uid"
  * when changing user ID's (ie setuid() and friends).
@@ -430,6 +439,7 @@ void switch_uid(struct user_struct *new_
 	suid_keys(current);
 }
 
+#ifdef CONFIG_USER_NS
 void release_uids(struct user_namespace *ns)
 {
 	int i;
@@ -454,6 +464,7 @@ void release_uids(struct user_namespace 
 
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
git-net.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option.patch
mark-net_ns-with-depends-on-namespaces.patch
reiser4.patch
