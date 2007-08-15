From: akpm@linux-foundation.org
Subject: + sysctl-simplify-the-pty-sysctl-logic.patch added to -mm tree
Date: Wed, 15 Aug 2007 12:59:49 -0700
Message-ID: <200708151959.l7FJxnO3012473@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49460 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936224AbXHOUAY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 16:00:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     sysctl: simplify the pty sysctl logic
has been added to the -mm tree.  Its filename is
     sysctl-simplify-the-pty-sysctl-logic.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -313,7 +313,7 @@ int pty_limit = NR_UNIX98_PTY_DEFAULT;
 static int pty_limit_min = 0;
 static int pty_limit_max = NR_UNIX98_PTY_MAX;
 
-ctl_table pty_table[] = {
+static struct ctl_table pty_table[] = {
 	{
 		.ctl_name	= PTY_MAX,
 		.procname	= "max",
@@ -335,6 +335,27 @@ ctl_table pty_table[] = {
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
@@ -399,6 +420,7 @@ static void __init unix98_pty_init(void)
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
@@ -532,14 +529,6 @@ static struct ctl_table kern_table[] = {
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

dvb_en_50221-convert-to-kthread-api.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
handle-the-multi-threaded-inits-exit-properly.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
sysctl-update-sysctl_check_table.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-remove-broken-cdrom-binary-sysctls-update.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
sysctl-parport-remove-binary-paths.patch
sysctl-simplify-the-pty-sysctl-logic.patch
sysctl-remove-broken-netfilter-binary-sysctls.patch
sysctl-clean-up-the-sched-debug-sysctl-usage.patch
sysctl-update-sysctl_checks-list-of-binary-paths.patch
sysctl-remove-the-cad_pid-binary-sysctl-path.patch
cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
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
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
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
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
