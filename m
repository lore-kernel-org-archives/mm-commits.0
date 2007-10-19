From: akpm@linux-foundation.org
Subject: - sysctl-x86_64-remove-unnecessary-binary-paths.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:42:44 -0700
Message-ID: <200710190342.l9J3gi1b012926@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57035 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966465AbXJSD4u (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@sw.ru, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     sysctl: x86_64 remove unnecessary binary paths
has been removed from the -mm tree.  Its filename was
     sysctl-x86_64-remove-unnecessary-binary-paths.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: x86_64 remove unnecessary binary paths
From: Eric W. Biederman <ebiederm@xmission.com>

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/ia32/ia32_binfmt.c   |    1 -
 arch/x86/kernel/vsyscall_64.c |   10 +---------
 2 files changed, 1 insertion(+), 10 deletions(-)

diff -puN arch/x86/ia32/ia32_binfmt.c~sysctl-x86_64-remove-unnecessary-binary-paths arch/x86/ia32/ia32_binfmt.c
--- a/arch/x86/ia32/ia32_binfmt.c~sysctl-x86_64-remove-unnecessary-binary-paths
+++ a/arch/x86/ia32/ia32_binfmt.c
@@ -289,7 +289,6 @@ static void elf32_init(struct pt_regs *r
 
 static ctl_table abi_table2[] = {
 	{
-		.ctl_name	= 99,
 		.procname	= "vsyscall32",
 		.data		= &sysctl_vsyscall32,
 		.maxlen		= sizeof(int),
diff -puN arch/x86/kernel/vsyscall_64.c~sysctl-x86_64-remove-unnecessary-binary-paths arch/x86/kernel/vsyscall_64.c
--- a/arch/x86/kernel/vsyscall_64.c~sysctl-x86_64-remove-unnecessary-binary-paths
+++ a/arch/x86/kernel/vsyscall_64.c
@@ -266,18 +266,10 @@ out:
 	return ret;
 }
 
-static int vsyscall_sysctl_nostrat(ctl_table *t, int __user *name, int nlen,
-				void __user *oldval, size_t __user *oldlenp,
-				void __user *newval, size_t newlen)
-{
-	return -ENOSYS;
-}
-
 static ctl_table kernel_table2[] = {
-	{ .ctl_name = 99, .procname = "vsyscall64",
+	{ .procname = "vsyscall64",
 	  .data = &vsyscall_gtod_data.sysctl_enabled, .maxlen = sizeof(int),
 	  .mode = 0644,
-	  .strategy = vsyscall_sysctl_nostrat,
 	  .proc_handler = vsyscall_sysctl_change },
 	{}
 };
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
