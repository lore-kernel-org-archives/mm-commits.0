From: akpm@linux-foundation.org
Subject: - make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch removed from -mm tree
Date: Thu, 18 Oct 2007 21:17:19 -0700
Message-ID: <200710190417.l9J4HKrM014583@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59736 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751548AbXJSERx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 00:17:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebiederm@xmission.com, clg@fr.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, serue@us.ibm.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     Update get_net_ns_by_pid
has been removed from the -mm tree.  Its filename was
     make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch

This patch was dropped because it was folded into make-access-to-tasks-nsproxy-lighter.patch

------------------------------------------------------
Subject: Update get_net_ns_by_pid
From: "Eric W. Biederman" <ebiederm@xmission.com>

In the -mm tree the rules for access an nsproxy have changed, and in
get_net_ns_by_pid we access the nsproxy, so update it to follow the new
rules.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/core/rtnetlink.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN net/core/rtnetlink.c~make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid net/core/rtnetlink.c
--- a/net/core/rtnetlink.c~make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid
+++ a/net/core/rtnetlink.c
@@ -744,10 +744,10 @@ static struct net *get_net_ns_by_pid(pid
 	rcu_read_lock();
 	tsk = find_task_by_pid(pid);
 	if (tsk) {
-		task_lock(tsk);
-		if (tsk->nsproxy)
-			net = get_net(tsk->nsproxy->net_ns);
-		task_unlock(tsk);
+		struct nsproxy *nsproxy;
+		nsproxy = task_nsproxy(tsk);
+		if (nsproxy)
+			net = get_net(nsproxy->net_ns);
 	}
 	rcu_read_unlock();
 	return net;
_

Patches currently in -mm which might be from ebiederm@xmission.com are

origin.patch
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
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
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
