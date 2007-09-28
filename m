From: akpm@linux-foundation.org
Subject: + make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch added to -mm tree
Date: Fri, 28 Sep 2007 15:27:48 -0700
Message-ID: <200709282227.l8SMRmFw020429@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752748AbXI1W2j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 18:28:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, clg@fr.ibm.com, oleg@tv-sign.ru, paulmck@linux.vnet.ibm.com, serue@us.ibm.com, xemul@openvz.org


The patch titled
     Update get_net_ns_by_pid
has been added to the -mm tree.  Its filename is
     make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Update get_net_ns_by_pid
From: "Eric W. Biederman" <ebiederm@xmission.com>

In the -mm tree the rules for access an nsproxy have changed, and in
get_net_ns_by_pid we access the nsproxy, so update it to follow the new
rules.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN net/core/rtnetlink.c~make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid net/core/rtnetlink.c
--- a/net/core/rtnetlink.c~make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid
+++ a/net/core/rtnetlink.c
@@ -746,10 +746,10 @@ static struct net *get_net_ns_by_pid(pid
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

dvb_en_50221-convert-to-kthread-api.patch
git-net.patch
git-wireless.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
handle-the-multi-threaded-inits-exit-properly.patch
remove-unused-member-from-nsproxy.patch
express-relocatability-of-kernel-on-x86_64-in-documentation.patch
express-relocatability-of-kernel-on-x86_64-in.patch
express-new-elf32-mechanisms-in-documentation.patch
add-reset_devices-to-the-recommended-parameters.patch
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
sysctl-deprecate-sys_sysctl-in-a-user-space-visible-fashion-fix.patch
remove-broken-netfilter-binary-sysctls-from-bridging-code.patch
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
isolate-the-explicit-usage-of-signal-pgrp.patch
extended-crashkernel-command-line.patch
use-extended-crashkernel-command-line-on-i386.patch
use-extended-crashkernel-command-line-on-x86_64.patch
use-extended-crashkernel-command-line-on-ia64.patch
use-extended-crashkernel-command-line-on-ia64-fix.patch
use-extended-crashkernel-command-line-on-ppc64.patch
use-extended-crashkernel-command-line-on-sh.patch
add-documentation-for-extended-crashkernel-syntax.patch
