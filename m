From: akpm@linux-foundation.org
Subject: + sysctl-clean-up-the-sched-debug-sysctl-usage.patch added to -mm tree
Date: Wed, 15 Aug 2007 12:59:53 -0700
Message-ID: <200708151959.l7FJxrph012484@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59998 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936387AbXHOUAy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 16:00:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, mingo@elte.hu


The patch titled
     sysctl: clean up the sched debug sysctl usage
has been added to the -mm tree.  Its filename is
     sysctl-clean-up-the-sched-debug-sysctl-usage.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: clean up the sched debug sysctl usage
From: Eric W. Biederman <ebiederm@xmission.com>

The ctl_name for the kernel directory is CTL_KERN - It is impoosible to write
to sysctl directories so do not give users write permissions.

This is enough to stop sysctl_check_table from complaining about the sched
debug sysctls.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sched.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff -puN kernel/sched.c~sysctl-clean-up-the-sched-debug-sysctl-usage kernel/sched.c
--- a/kernel/sched.c~sysctl-clean-up-the-sched-debug-sysctl-usage
+++ a/kernel/sched.c
@@ -5235,15 +5235,16 @@ static void migrate_dead_tasks(unsigned 
 static struct ctl_table sd_ctl_dir[] = {
 	{
 		.procname	= "sched_domain",
-		.mode		= 0755,
+		.mode		= 0555,
 	},
 	{0,},
 };
 
 static struct ctl_table sd_ctl_root[] = {
 	{
+		.ctl_name	= CTL_KERN,
 		.procname	= "kernel",
-		.mode		= 0755,
+		.mode		= 0555,
 		.child		= sd_ctl_dir,
 	},
 	{0,},
@@ -5319,7 +5320,7 @@ static ctl_table *sd_alloc_ctl_cpu_table
 	for_each_domain(cpu, sd) {
 		snprintf(buf, 32, "domain%d", i);
 		entry->procname = kstrdup(buf, GFP_KERNEL);
-		entry->mode = 0755;
+		entry->mode = 0555;
 		entry->child = sd_alloc_ctl_domain_table(sd);
 		entry++;
 		i++;
@@ -5339,7 +5340,7 @@ static void init_sched_domain_sysctl(voi
 	for (i = 0; i < cpu_num; i++, entry++) {
 		snprintf(buf, 32, "cpu%d", i);
 		entry->procname = kstrdup(buf, GFP_KERNEL);
-		entry->mode = 0755;
+		entry->mode = 0555;
 		entry->child = sd_alloc_ctl_cpu_table(i);
 	}
 	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
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
