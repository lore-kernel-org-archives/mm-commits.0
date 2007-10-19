From: akpm@linux-foundation.org
Subject: - sysctl-simplify-the-pty-sysctl-logic.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:42:56 -0700
Message-ID: <200710190342.l9J3guCV012944@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49699 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934405AbXJSDzl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:55:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, mm-commits@vger.kernel.org


The patch titled
     sysctl: simplify the pty sysctl logic
has been removed from the -mm tree.  Its filename was
     sysctl-simplify-the-pty-sysctl-logic.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: simplify the pty sysctl logic
From: Eric W. Biederman <ebiederm@xmission.com>

Instead of having a bunch of ifdefs in sysctl.c move all of the pty sysctl
logic into drivers/char/pty.c

As well as cleaning up the logic this prevents sysctl_check_table from
complaining that the root table has a NULL data pointer on something with
generic methods.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pty.c |   24 +++++++++++++++++++++++-
 kernel/sysctl.c    |   11 -----------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff -puN drivers/char/pty.c~sysctl-simplify-the-pty-sysctl-logic drivers/char/pty.c
--- a/drivers/char/pty.c~sysctl-simplify-the-pty-sysctl-logic
+++ a/drivers/char/pty.c
@@ -318,7 +318,7 @@ int pty_limit = NR_UNIX98_PTY_DEFAULT;
 static int pty_limit_min = 0;
 static int pty_limit_max = NR_UNIX98_PTY_MAX;
 
-ctl_table pty_table[] = {
+static struct ctl_table pty_table[] = {
 	{
 		.ctl_name	= PTY_MAX,
 		.procname	= "max",
@@ -340,6 +340,27 @@ ctl_table pty_table[] = {
 	}
 };
 
+static struct ctl_table pty_kern_table[] = {
+	{
+		.ctl_name	= KERN_PTY,
+		.procname	= "pty",
+		.mode		= 0555,
+		.child		= pty_table,
+	},
+	{}
+};
+
+static struct ctl_table pty_root_table[] = {
+	{
+		.ctl_name	= CTL_KERN,
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= pty_kern_table,
+	},
+	{}
+};
+
+
 static int pty_unix98_ioctl(struct tty_struct *tty, struct file *file,
 			    unsigned int cmd, unsigned long arg)
 {
@@ -404,6 +425,7 @@ static void __init unix98_pty_init(void)
 		panic("Couldn't register Unix98 pts driver");
 
 	pty_table[1].data = &ptm_driver->refcount;
+	register_sysctl_table(pty_root_table);
 }
 #else
 static inline void unix98_pty_init(void) { }
diff -puN kernel/sysctl.c~sysctl-simplify-the-pty-sysctl-logic kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-simplify-the-pty-sysctl-logic
+++ a/kernel/sysctl.c
@@ -163,9 +163,6 @@ static struct ctl_table fs_table[];
 static struct ctl_table debug_table[];
 static struct ctl_table dev_table[];
 extern struct ctl_table random_table[];
-#ifdef CONFIG_UNIX98_PTYS
-extern struct ctl_table pty_table[];
-#endif
 #ifdef CONFIG_INOTIFY_USER
 extern struct ctl_table inotify_table[];
 #endif
@@ -534,14 +531,6 @@ static struct ctl_table kern_table[] = {
 		.mode		= 0555,
 		.child		= random_table,
 	},
-#ifdef CONFIG_UNIX98_PTYS
-	{
-		.ctl_name	= KERN_PTY,
-		.procname	= "pty",
-		.mode		= 0555,
-		.child		= pty_table,
-	},
-#endif
 	{
 		.ctl_name	= KERN_OVERFLOWUID,
 		.procname	= "overflowuid",
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
update-boot-spec-to-207.patch
i386-paravirt-boot-sequence.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids-fix.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
uninline-find_task_by_xxx-set-of-functions.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
uninline-find_pid-etc-set-of-functions.patch
uninline-the-task_xid_nr_ns-calls.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
virtualization-of-sysv-msg-queues-is-incomplete.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-sh.patch
add-documentation-for-extended-crashkernel-syntax.patch
kexec-add-bss-to-resource-tree.patch
kexec-introduce-bootmem_exclusive.patch
kexec-use-bootmem_exclusive-on-x86.patch
