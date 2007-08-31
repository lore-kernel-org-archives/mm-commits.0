From: akpm@linux-foundation.org
Subject: + sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion.patch added to -mm tree
Date: Fri, 31 Aug 2007 12:08:29 -0700
Message-ID: <200708311908.l7VJ8TbQ022231@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58678 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932719AbXHaTIc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 31 Aug 2007 15:08:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     sysctl: deprecate sys_sysctl in a user space visible fashion.
has been added to the -mm tree.  Its filename is
     sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: deprecate sys_sysctl in a user space visible fashion.
From: ebiederm@xmission.com (Eric W. Biederman)

After adding checking to register_sysctl_table and finding a whole new set
of bugs.  Missed by countless code reviews and testers I have finally lost
patience with the binary sysctl interface.

The binary sysctl interface has been sort of deprecated for years and
finding a user space program that uses the syscall is more difficult then
finding a needle in a haystack.  Problems continue to crop up, with the in
kernel implementation.  So since supporting something that no one uses is
silly, deprecate sys_sysctl with a sufficient grace period and notice that
the handful of user space applications that care can be fixed or replaced.

The /proc/sys sysctl interface that people use will continue to be
supported indefinitely.

This patch moves the tested warning about sysctls from the path where
sys_sysctl to a separate path called from both implementations of
sys_sysctl, and it adds a proper entry into
Documentation/feature-removal-schedule.

Allowing us to revisit this in a couple years time and actually kill
sys_sysctl.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   35 ++++++++++
 kernel/sysctl.c                            |   62 +++++++++++--------
 2 files changed, 74 insertions(+), 23 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion
+++ a/Documentation/feature-removal-schedule.txt
@@ -65,6 +65,41 @@ Who:	Mauro Carvalho Chehab <mchehab@brtu
 
 ---------------------------
 
+What:	sys_sysctl
+When:	September 2010
+Option: CONFIG_SYSCTL_SYSCALL
+Why:	The same information is available in a more convenient from
+	/proc/sys, and none of the sysctl variables appear to be
+	important performance wise.
+
+	Binary sysctls are a long standing source of subtle kernel
+	bugs and security issues.
+
+	When I looked several months ago all I could find after
+	searching several distributions were 5 user space programs and
+	glibc (which falls back to /proc/sys) using this syscall.
+
+	The man page for sysctl(2) documents it as unusable for user
+	space programs.
+
+	sysctl(2) is not generally ABI compatible to a 32bit user
+	space application on a 64bit and a 32bit kernel.
+
+	For the last several months the policy has been no new binary
+	sysctls and no one has put forward an argument to use them.
+
+	Binary sysctls issues seem to keep happening appearing so
+	properly deprecating them (with a warning to user space) and a
+	2 year grace warning period will mean eventually we can kill
+	them and end the pain.
+
+	In the mean time individual binary sysctls can be dealt with
+	in a piecewise fashion.
+
+Who:	Eric Biederman <ebiederm@xmission.com>
+
+---------------------------
+
 What:  a.out interpreter support for ELF executables
 When:  2.6.25
 Files: fs/binfmt_elf.c
diff -puN kernel/sysctl.c~sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion
+++ a/kernel/sysctl.c
@@ -1320,6 +1320,33 @@ struct ctl_table_header *sysctl_head_nex
 	return NULL;
 }
 
+static int deprecated_sysctl_warning(struct __sysctl_args *args)
+{
+	static int msg_count;
+	int name[CTL_MAXNAME];
+	int i;
+
+	/* Read in the sysctl name for better debug message logging */
+	for (i = 0; i < args->nlen; i++)
+		if (get_user(name[i], args->name + i))
+			return -EFAULT;
+
+	/* Ignore accesses to kernel.version */
+	if ((args->nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
+		return 0;
+
+	if (msg_count < 5) {
+		msg_count++;
+		printk(KERN_INFO
+			"warning: process `%s' used the deprecated sysctl "
+			"system call with ", current->comm);
+		for (i = 0; i < args->nlen; i++)
+			printk("%d.", name[i]);
+		printk("\n");
+	}
+	return 0;
+}
+
 #ifdef CONFIG_SYSCTL_SYSCALL
 int do_sysctl(int __user *name, int nlen, void __user *oldval, size_t __user *oldlenp,
 	       void __user *newval, size_t newlen)
@@ -1355,10 +1382,15 @@ asmlinkage long sys_sysctl(struct __sysc
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
 		return -EFAULT;
 
+	error = deprecated_sysctl_warning(&tmp);
+	if (error)
+		goto out;
+
 	lock_kernel();
 	error = do_sysctl(tmp.name, tmp.nlen, tmp.oldval, tmp.oldlenp,
 			  tmp.newval, tmp.newlen);
 	unlock_kernel();
+out:
 	return error;
 }
 #endif /* CONFIG_SYSCTL_SYSCALL */
@@ -2548,35 +2580,19 @@ int sysctl_ms_jiffies(struct ctl_table *
 
 asmlinkage long sys_sysctl(struct __sysctl_args __user *args)
 {
-	static int msg_count;
 	struct __sysctl_args tmp;
-	int name[CTL_MAXNAME];
-	int i;
+	int error;
 
-	/* Read in the sysctl name for better debug message logging */
 	if (copy_from_user(&tmp, args, sizeof(tmp)))
 		return -EFAULT;
-	if (tmp.nlen <= 0 || tmp.nlen >= CTL_MAXNAME)
-		return -ENOTDIR;
-	for (i = 0; i < tmp.nlen; i++)
-		if (get_user(name[i], tmp.name + i))
-			return -EFAULT;
 
-	/* Ignore accesses to kernel.version */
-	if ((tmp.nlen == 2) && (name[0] == CTL_KERN) && (name[1] == KERN_VERSION))
-		goto out;
+	error = deprecated_sysctl_warning(&tmp);
 
-	if (msg_count < 5) {
-		msg_count++;
-		printk(KERN_INFO
-			"warning: process `%s' used the removed sysctl "
-			"system call with ", current->comm);
-		for (i = 0; i < tmp.nlen; i++)
-			printk("%d.", name[i]);
-		printk("\n");
-	}
-out:
-	return -ENOSYS;
+	/* If no error reading the parameters then just -ENOSYS ... */
+	if (!error)
+		error = -ENOSYS;
+
+	return error;
 }
 
 int sysctl_data(struct ctl_table *table, int __user *name, int nlen,
_

Patches currently in -mm which might be from ebiederm@xmission.com are

dvb_en_50221-convert-to-kthread-api.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
handle-the-multi-threaded-inits-exit-properly.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
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
sysctl-parport-remove-binary-paths-fix.patch
sysctl-simplify-the-pty-sysctl-logic.patch
sysctl-remove-broken-netfilter-binary-sysctls.patch
sysctl-remove-the-cad_pid-binary-sysctl-path.patch
sysctl-properly-register-the-irda-binary-sysctl-numbers.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-error-on-bad-sysctl-tables-kernel-sysctl_checkc-must-include-linux-stringh.patch
sysctl-update-sysctl_check_table.patch
sysctl-update-sysctl_checks-list-of-binary-paths.patch
sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code.patch
sysctl-for-irda-update-sysctl_checks-list-of-binary-paths.patch
sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion.patch
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
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
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
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
