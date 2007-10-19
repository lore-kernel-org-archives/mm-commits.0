From: akpm@linux-foundation.org
Subject: - sysctl-update-sysctl_check_table.patch removed from -mm tree
Date: Thu, 18 Oct 2007 20:43:09 -0700
Message-ID: <200710190343.l9J3h9f7012965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934612AbXJSD4e (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 23:56:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, adobriyan@sw.ru, mm-commits@vger.kernel.org


The patch titled
     sysctl: update sysctl_check_table
has been removed from the -mm tree.  Its filename was
     sysctl-update-sysctl_check_table.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysctl: update sysctl_check_table
From: Eric W. Biederman <ebiederm@xmission.com>

Well it turns out after I dug into the problems a little more I was returning
a few false positives so this patch updates my logic to remove them.

- Don't complain about 0 ctl_names in sysctl_check_binary_path
  It is valid for someone to remove the sysctl binary interface
  and still keep the same sysctl proc interface.

- Count ctl_names and procnames as matching if they both don't
  exist.

- Only warn about missing min&max when the generic functions care.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff -puN kernel/sysctl_check.c~sysctl-update-sysctl_check_table kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-update-sysctl_check_table
+++ a/kernel/sysctl_check.c
@@ -565,6 +565,7 @@ static struct trans_ctl_table trans_net_
 	{ NET_IPV6_IP6FRAG_TIME,	"ip6frag_time" },
 	{ NET_IPV6_IP6FRAG_SECRET_INTERVAL,	"ip6frag_secret_interval" },
 	{ NET_IPV6_MLD_MAX_MSF,		"mld_max_msf" },
+	{ 2088 /* IPQ_QMAX */,		"ip6_queue_maxlen" },
 	{}
 };
 
@@ -723,6 +724,7 @@ static struct trans_ctl_table trans_net_
 	{ NET_LLC,		"llc",		trans_net_llc_table },
 	{ NET_NETFILTER,	"netfilter",	trans_net_netfilter_table },
 	{ NET_DCCP,		"dccp",		trans_net_dccp_table },
+	{ 2089,			"nf_conntrack_max" },
 	{}
 };
 
@@ -1421,12 +1423,14 @@ static int sysctl_check_dir(struct ctl_t
 	ref = sysctl_check_lookup(table);
 	if (ref) {
 		int match = 0;
-		if (table->procname && ref->procname &&
-		    (strcmp(table->procname, ref->procname) == 0))
+		if ((!table->procname && !ref->procname) ||
+		    (table->procname && ref->procname &&
+		     (strcmp(table->procname, ref->procname) == 0)))
 			match++;
 
-		if (table->ctl_name && ref->ctl_name &&
-		    (table->ctl_name == ref->ctl_name))
+		if ((!table->ctl_name && !ref->ctl_name) ||
+		    (table->ctl_name && ref->ctl_name &&
+		     (table->ctl_name == ref->ctl_name)))
 			match++;
 
 		if (match != 2) {
@@ -1463,8 +1467,8 @@ static void sysctl_check_bin_path(struct
 		     (strcmp(table->procname, ref->procname) != 0)))
 			set_fail(fail, table, "procname does not match binary path procname");
 
-		if (ref->ctl_name &&
-		    (!table->ctl_name || table->ctl_name != ref->ctl_name))
+		if (ref->ctl_name && table->ctl_name &&
+		    (table->ctl_name != ref->ctl_name))
 			set_fail(fail, table, "ctl_name does not match binary path ctl_name");
 	}
 }
@@ -1500,7 +1504,7 @@ int sysctl_check_table(struct ctl_table 
 			if (table->extra2)
 				set_fail(&fail, table, "Directory with extra2");
 			if (sysctl_check_dir(table))
-				set_fail(&fail, table, "Inconsistent directory");
+				set_fail(&fail, table, "Inconsistent directory names");
 		} else {
 			if ((table->strategy == sysctl_data) ||
 			    (table->strategy == sysctl_string) ||
@@ -1521,23 +1525,27 @@ int sysctl_check_table(struct ctl_table 
 				if (!table->maxlen)
 					set_fail(&fail, table, "No maxlen");
 			}
-			if ((table->strategy == sysctl_intvec) ||
-			    (table->proc_handler == proc_dointvec_minmax) ||
-			    (table->proc_handler == proc_doulongvec_minmax) ||
+			if ((table->proc_handler == proc_doulongvec_minmax) ||
 			    (table->proc_handler == proc_doulongvec_ms_jiffies_minmax)) {
-				if (!table->extra1)
-					set_fail(&fail, table, "No min");
-				if (!table->extra2)
-					set_fail(&fail, table, "No max");
+				if (table->maxlen > sizeof (unsigned long)) {
+					if (!table->extra1)
+						set_fail(&fail, table, "No min");
+					if (!table->extra2)
+						set_fail(&fail, table, "No max");
+				}
 			}
+#ifdef CONFIG_SYSCTL_SYSCALL
 			if (table->ctl_name && !table->strategy)
 				set_fail(&fail, table, "Missing strategy");
+#endif
 #if 0
 			if (!table->ctl_name && table->strategy)
 				set_fail(&fail, table, "Strategy without ctl_name");
 #endif
+#ifdef CONFIG_PROC_FS
 			if (table->procname && !table->proc_handler)
 				set_fail(&fail, table, "No proc_handler");
+#endif
 #if 0
 			if (!table->procname && table->proc_handler)
 				set_fail(&fail, table, "proc_handler without procname");
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
