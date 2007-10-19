From: akpm@linux-foundation.org
Subject: - task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:11:55 -0700
Message-ID: <200710190411.l9J4Bupr014379@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59029 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbXJSEMj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:12:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: menage@google.com, balbir@in.ibm.com, clg@fr.ibm.com, dev@openvz.org, ebiederm@xmission.com, haveblue@us.ibm.com, herbert@13thfloor.at, kamezawa.hiroyu@jp.fujitsu.com, pj@sgi.com, ser


The patch titled
     Simplify /proc/cgroups
has been removed from the -mm tree.  Its filename was
     task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups.patch

This patch was dropped because it was folded into task-containersv11-shared-container-subsystem-group-arrays.patch

------------------------------------------------------
Subject: Simplify /proc/cgroups
From: menage@google.com (Paul Menage)

This patch simplifies /proc/cgroups by removing pointers and some debugging
information, and simply presenting a list of subsystems, which hierarchy
they are part of (if any) and the number of cgroups created for that
subsystem.  Hierarchy id is determined by the bitmask of subsystem ids
attached to that hierarchy.

Several people have commented that /proc/cgroups is too confusing or
contains strange information. Here's an attempt to simplify it. New
typical output looks like:

#subsys_name	hierarchy	num_cgroups
cpuset	1	2
cpuacct	10	1
debug	0	1
ns	10	1
memory	0	1
cpu	0	1

Maybe there should be more tabs so that the columns line up better?
But then it'll be out of line if people create subsystems with longer
names ...

Signed-off-by: Paul Menage <menage@google.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: Paul Jackson <pj@sgi.com>
Cc: Kirill Korotaev <dev@openvz.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cgroup.c |   25 ++++---------------------
 1 file changed, 4 insertions(+), 21 deletions(-)

diff -puN kernel/cgroup.c~task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups kernel/cgroup.c
--- a/kernel/cgroup.c~task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups
+++ a/kernel/cgroup.c
@@ -2118,31 +2118,14 @@ static int proc_cgroupstats_show(struct 
 	int i;
 	struct cgroupfs_root *root;
 
+	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\n");
 	mutex_lock(&cgroup_mutex);
-	seq_puts(m, "Hierarchies:\n");
-	for_each_root(root) {
-		struct cgroup_subsys *ss;
-		int first = 1;
-		seq_printf(m, "%p: bits=%lx cgroups=%d (", root,
-			   root->subsys_bits, root->number_of_cgroups);
-		for_each_subsys(root, ss) {
-			seq_printf(m, "%s%s", first ? "" : ", ", ss->name);
-			first = false;
-		}
-		seq_putc(m, ')');
-		if (root->sb) {
-			seq_printf(m, " s_active=%d",
-				   atomic_read(&root->sb->s_active));
-		}
-		seq_putc(m, '\n');
-	}
-	seq_puts(m, "Subsystems:\n");
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
-		seq_printf(m, "%d: name=%s hierarchy=%p\n",
-			   i, ss->name, ss->root);
+		seq_printf(m, "%s\t%d\t%d\n",
+			   ss->name, ss->root->subsys_bits,
+			   ss->root->number_of_cgroups);
 	}
-	seq_printf(m, "Control Group groups: %d\n", css_set_count);
 	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
_

Patches currently in -mm which might be from menage@google.com are

cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-add-tasks-file-interface.patch
add-cgroup-write_uint-helper-method.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups.patch
task-containersv11-shared-container-subsystem-group-arrays-simplify-proc-cgroups-fix.patch
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-automatic-userspace-notification-of-idle-containers-fix.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
task-containers-enable-containers-by-default-in-some-configs.patch
add-containerstats-v3.patch
add-containerstats-v3-fix.patch
containers-implement-namespace-tracking-subsystem.patch
containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch
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
uninline-find_pid-etc-set-of-functions.patch
uninline-the-task_xid_nr_ns-calls.patch
cpusets-decrustify-cpuset-mask-update-code.patch
fix-cpusets-update_cpumask.patch
fix-cpusets-update_cpumask-checkpatch-fixes.patch
use-task_pid_nr-instead-of-pid_nrtask_pid.patch
control-groups-replace-cont-with-cgrp-and-other-misc.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
