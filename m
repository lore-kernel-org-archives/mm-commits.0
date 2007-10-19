From: akpm@linux-foundation.org
Subject: - sysctl-factor-out-sysctl_data.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:42:32 -0700
Message-ID: <200710190342.l9J3gWfC012903@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47806 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934418AbXJSD4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     sysctl: Factor out sysctl_data.
has been removed from the -mm tree.  Its filename was
     sysctl-factor-out-sysctl_data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: Factor out sysctl_data.
From: Eric W. Biederman <ebiederm@xmission.com>

There as been no easy way to wrap the default sysctl strategy routine except
for returning 0.  Which is not always what we want.  The few instances I have
seen that want different behaviour have written their own version of
sysctl_data.  While not too hard it is unnecessary code and has the potential
for extra bugs.

So to make these situations easier and make that part of sysctl more symetric
I have factord sysctl_data out of do_sysctl_strategy and exported as a
function everyone can use.

Further having sysctl_data be an explicit function makes checking for badly
formed sysctl tables much easier.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    1 
 kernel/sysctl.c        |   66 +++++++++++++++++++++++++++------------
 2 files changed, 47 insertions(+), 20 deletions(-)

diff -puN include/linux/sysctl.h~sysctl-factor-out-sysctl_data include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-factor-out-sysctl_data
+++ a/include/linux/sysctl.h
@@ -972,6 +972,7 @@ extern int do_sysctl_strategy (struct ct
 			       void __user *oldval, size_t __user *oldlenp,
 			       void __user *newval, size_t newlen);
 
+extern ctl_handler sysctl_data;
 extern ctl_handler sysctl_string;
 extern ctl_handler sysctl_intvec;
 extern ctl_handler sysctl_jiffies;
diff -puN kernel/sysctl.c~sysctl-factor-out-sysctl_data kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-factor-out-sysctl_data
+++ a/kernel/sysctl.c
@@ -1443,7 +1443,6 @@ int do_sysctl_strategy (struct ctl_table
 			void __user *newval, size_t newlen)
 {
 	int op = 0, rc;
-	size_t len;
 
 	if (oldval)
 		op |= 004;
@@ -1464,25 +1463,10 @@ int do_sysctl_strategy (struct ctl_table
 	/* If there is no strategy routine, or if the strategy returns
 	 * zero, proceed with automatic r/w */
 	if (table->data && table->maxlen) {
-		if (oldval && oldlenp) {
-			if (get_user(len, oldlenp))
-				return -EFAULT;
-			if (len) {
-				if (len > table->maxlen)
-					len = table->maxlen;
-				if(copy_to_user(oldval, table->data, len))
-					return -EFAULT;
-				if(put_user(len, oldlenp))
-					return -EFAULT;
-			}
-		}
-		if (newval && newlen) {
-			len = newlen;
-			if (len > table->maxlen)
-				len = table->maxlen;
-			if(copy_from_user(table->data, newval, len))
-				return -EFAULT;
-		}
+		rc = sysctl_data(table, name, nlen, oldval, oldlenp,
+				 newval, newlen);
+		if (rc < 0)
+			return rc;
 	}
 	return 0;
 }
@@ -2381,6 +2365,40 @@ int proc_doulongvec_ms_jiffies_minmax(st
  * General sysctl support routines 
  */
 
+/* The generic sysctl data routine (used if no strategy routine supplied) */
+int sysctl_data(struct ctl_table *table, int __user *name, int nlen,
+		void __user *oldval, size_t __user *oldlenp,
+		void __user *newval, size_t newlen)
+{
+	size_t len;
+
+	/* Get out of I don't have a variable */
+	if (!table->data || !table->maxlen)
+		return -ENOTDIR;
+
+	if (oldval && oldlenp) {
+		if (get_user(len, oldlenp))
+			return -EFAULT;
+		if (len) {
+			if (len > table->maxlen)
+				len = table->maxlen;
+			if (copy_to_user(oldval, table->data, len))
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
+		if (copy_from_user(table->data, newval, newlen))
+			return -EFAULT;
+	}
+	return 1;
+}
+
 /* The generic string strategy routine: */
 int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
@@ -2569,6 +2587,13 @@ out:
 	return -ENOSYS;
 }
 
+int sysctl_data(struct ctl_table *table, int __user *name, int nlen,
+		  void __user *oldval, size_t __user *oldlenp,
+		  void __user *newval, size_t newlen)
+{
+	return -ENOSYS;
+}
+
 int sysctl_string(struct ctl_table *table, int __user *name, int nlen,
 		  void __user *oldval, size_t __user *oldlenp,
 		  void __user *newval, size_t newlen)
@@ -2616,4 +2641,5 @@ EXPORT_SYMBOL(sysctl_intvec);
 EXPORT_SYMBOL(sysctl_jiffies);
 EXPORT_SYMBOL(sysctl_ms_jiffies);
 EXPORT_SYMBOL(sysctl_string);
+EXPORT_SYMBOL(sysctl_data);
 EXPORT_SYMBOL(unregister_sysctl_table);
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
