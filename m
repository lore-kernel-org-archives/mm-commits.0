From: akpm@linux-foundation.org
Subject: + sysctl-remove-broken-cdrom-binary-sysctls-update.patch added to -mm tree
Date: Wed, 15 Aug 2007 12:58:21 -0700
Message-ID: <200708151958.l7FJwLXB012324@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54434 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933325AbXHOT7L (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 15:59:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, alan@redhat.com


The patch titled
     sysctl: remove broken cdrom binary sysctls (update)
has been added to the -mm tree.  Its filename is
     sysctl-remove-broken-cdrom-binary-sysctls-update.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: remove broken cdrom binary sysctls (update)
From: ebiederm@xmission.com (Eric W. Biederman)

The binary interface for the cdrom sysctls can't possilby work.  So remove
the binary sysctls and reduce cdrom_sysctl_handler to it's essentials (to
kill the uses of ctl_name).

Since the last time this patch was posted I radically
simplified cdrom_sysctl_helper to meet address Alan's objections.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Acked-by: Alan Cox <alan@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdrom.c |   35 +++++++----------------------------
 1 files changed, 7 insertions(+), 28 deletions(-)

diff -puN drivers/cdrom/cdrom.c~sysctl-remove-broken-cdrom-binary-sysctls-update drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~sysctl-remove-broken-cdrom-binary-sysctls-update
+++ a/drivers/cdrom/cdrom.c
@@ -3454,40 +3454,19 @@ static void cdrom_update_settings(void)
 static int cdrom_sysctl_handler(ctl_table *ctl, int write, struct file * filp,
 				void __user *buffer, size_t *lenp, loff_t *ppos)
 {
-	int *valp = ctl->data;
-	int val = *valp;
 	int ret;
 	
 	ret = proc_dointvec(ctl, write, filp, buffer, lenp, ppos);
 
-	if (write && *valp != val) {
+	if (write) {
 	
 		/* we only care for 1 or 0. */
-		if (*valp)
-			*valp = 1;
-		else
-			*valp = 0;
-
-		if (strcmp(ctl->procname, "autoclose") == 0) {
-			if (valp == &cdrom_sysctl_settings.autoclose)
-				autoclose = cdrom_sysctl_settings.autoclose;
-		}
-		else if (strcmp(ctl->procname, "autoeject") == 0) {
-			if (valp == &cdrom_sysctl_settings.autoeject)
-				autoeject = cdrom_sysctl_settings.autoeject;
-		}
-		else if (strcmp(ctl->procname, "debug") == 0) {
-			if (valp == &cdrom_sysctl_settings.debug)
-				debug = cdrom_sysctl_settings.debug;
-		}
-		else if (strcmp(ctl->procname, "lock") == 0) {
-			if (valp == &cdrom_sysctl_settings.lock)
-				lockdoor = cdrom_sysctl_settings.lock;
-		}
-		else if (strcmp(ctl->procname, "check_media") == 0) {
-			if (valp == &cdrom_sysctl_settings.check)
-				check_media_type = cdrom_sysctl_settings.check;
-		}
+		autoclose        = !!cdrom_sysctl_settings.autoclose;
+		autoeject        = !!cdrom_sysctl_settings.autoeject;
+		debug	         = !!cdrom_sysctl_settings.debug;
+		lockdoor         = !!cdrom_sysctl_settings.lock;
+		check_media_type = !!cdrom_sysctl_settings.check;
+
 		/* update the option flags according to the changes. we
 		   don't have per device options through sysctl yet,
 		   but we will have and then this will disappear. */
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
