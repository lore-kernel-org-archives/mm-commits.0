From: akpm@linux-foundation.org
Subject: + sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code.patch added to -mm tree
Date: Mon, 27 Aug 2007 15:02:23 -0700
Message-ID: <200708272202.l7RM2NDJ030785@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43042 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925AbXH0WC0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 27 Aug 2007 18:02:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com


The patch titled
     sysctl: update sysctl_check to handle compiled out code.
has been added to the -mm tree.  Its filename is
     sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: update sysctl_check to handle compiled out code.
From: ebiederm@xmission.com (Eric W. Biederman)

Currently sysctl_check_table will complain if a strategy routine
is missing when we have sys_sysctl compiled out, or a proc_handler
is missing when we have procfs compiled out.  At least some
of the custom handlers actually expand to NULL when this is the
case so the warning is actually a problem.

Valdis.Kletnieks@vt.edu writes:
> As far as "something else wrong", I'm still seeing these in -rc3-mm1
>
> [    0.628000] sysctl table check failed: /kernel/ostype .1.1 Missing strategy
> [ 0.628000] sysctl table check failed: /kernel/osrelease .1.2 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/version .1.4 Missing strategy
> [ 0.628000] sysctl table check failed: /kernel/hostname .1.7 Missing strategy
> [ 0.628000] sysctl table check failed: /kernel/domainname .1.8 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/shmmax .1.34 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/shmall .1.41 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/shmmni .1.45 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/msgmax .1.35 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/msgmni .1.42 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/msgmnb .1.36 Missing strategy
> [    0.628000] sysctl table check failed: /kernel/sem .1.43 Missing strategy

So don't worry about missing strategy routines, or missing proc_handler
routines when they will never be called.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl_check.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN kernel/sysctl_check.c~sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code kernel/sysctl_check.c
--- a/kernel/sysctl_check.c~sysctl-update-sysctl_check_table-sysctl-update-sysctl_check-to-handle-compiled-out-code
+++ a/kernel/sysctl_check.c
@@ -1534,14 +1534,18 @@ int sysctl_check_table(struct ctl_table 
 						set_fail(&fail, table, "No max");
 				}
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
