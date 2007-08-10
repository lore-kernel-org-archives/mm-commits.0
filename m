From: akpm@linux-foundation.org
Subject: + sysctl-remove-broken-cdrom-binary-sysctls.patch added to -mm tree
Date: Thu, 09 Aug 2007 18:42:02 -0700
Message-ID: <200708100142.l7A1g2ei029588@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37651 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755378AbXHJBmu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 21:42:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@sw.ru, alan@lxorguk.ukuu.org.uk, jens.axboe@oracle.com


The patch titled
     sysctl: remove broken cdrom binary sysctls
has been added to the -mm tree.  Its filename is
     sysctl-remove-broken-cdrom-binary-sysctls.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: remove broken cdrom binary sysctls
From: Eric W. Biederman <ebiederm@xmission.com>

The binary interface for the cdrom sysctls can't possilby work.  So remove the
binary sysctls and update the test for finding out which sysctl table entry we
are dealy with to use the procname and not the ctl_name (which I am removing).

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/cdrom/cdrom.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff -puN drivers/cdrom/cdrom.c~sysctl-remove-broken-cdrom-binary-sysctls drivers/cdrom/cdrom.c
--- a/drivers/cdrom/cdrom.c~sysctl-remove-broken-cdrom-binary-sysctls
+++ a/drivers/cdrom/cdrom.c
@@ -3468,32 +3468,25 @@ static int cdrom_sysctl_handler(ctl_tabl
 		else
 			*valp = 0;
 
-		switch (ctl->ctl_name) {
-		case DEV_CDROM_AUTOCLOSE: {
+		if (strcmp(ctl->procname, "autoclose") == 0) {
 			if (valp == &cdrom_sysctl_settings.autoclose)
 				autoclose = cdrom_sysctl_settings.autoclose;
-			break;
-			}
-		case DEV_CDROM_AUTOEJECT: {
+		}
+		else if (strcmp(ctl->procname, "autoeject") == 0) {
 			if (valp == &cdrom_sysctl_settings.autoeject)
 				autoeject = cdrom_sysctl_settings.autoeject;
-			break;
-			}
-		case DEV_CDROM_DEBUG: {
+		}
+		else if (strcmp(ctl->procname, "debug") == 0) {
 			if (valp == &cdrom_sysctl_settings.debug)
 				debug = cdrom_sysctl_settings.debug;
-			break;
-			}
-		case DEV_CDROM_LOCK: {
+		}
+		else if (strcmp(ctl->procname, "lock") == 0) {
 			if (valp == &cdrom_sysctl_settings.lock)
 				lockdoor = cdrom_sysctl_settings.lock;
-			break;
-			}
-		case DEV_CDROM_CHECK_MEDIA: {
+		}
+		else if (strcmp(ctl->procname, "check_media") == 0) {
 			if (valp == &cdrom_sysctl_settings.check)
 				check_media_type = cdrom_sysctl_settings.check;
-			break;
-			}
 		}
 		/* update the option flags according to the changes. we
 		   don't have per device options through sysctl yet,
@@ -3507,7 +3500,6 @@ static int cdrom_sysctl_handler(ctl_tabl
 /* Place files in /proc/sys/dev/cdrom */
 static ctl_table cdrom_table[] = {
 	{
-		.ctl_name	= DEV_CDROM_INFO,
 		.procname	= "info",
 		.data		= &cdrom_sysctl_settings.info, 
 		.maxlen		= CDROM_STR_SIZE,
@@ -3515,7 +3507,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_info,
 	},
 	{
-		.ctl_name	= DEV_CDROM_AUTOCLOSE,
 		.procname	= "autoclose",
 		.data		= &cdrom_sysctl_settings.autoclose,
 		.maxlen		= sizeof(int),
@@ -3523,7 +3514,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_handler,
 	},
 	{
-		.ctl_name	= DEV_CDROM_AUTOEJECT,
 		.procname	= "autoeject",
 		.data		= &cdrom_sysctl_settings.autoeject,
 		.maxlen		= sizeof(int),
@@ -3531,7 +3521,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_handler,
 	},
 	{
-		.ctl_name	= DEV_CDROM_DEBUG,
 		.procname	= "debug",
 		.data		= &cdrom_sysctl_settings.debug,
 		.maxlen		= sizeof(int),
@@ -3539,7 +3528,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_handler,
 	},
 	{
-		.ctl_name	= DEV_CDROM_LOCK,
 		.procname	= "lock",
 		.data		= &cdrom_sysctl_settings.lock,
 		.maxlen		= sizeof(int),
@@ -3547,7 +3535,6 @@ static ctl_table cdrom_table[] = {
 		.proc_handler	= &cdrom_sysctl_handler,
 	},
 	{
-		.ctl_name	= DEV_CDROM_CHECK_MEDIA,
 		.procname	= "check_media",
 		.data		= &cdrom_sysctl_settings.check,
 		.maxlen		= sizeof(int),
_

Patches currently in -mm which might be from ebiederm@xmission.com are

remove-unused-struct-proc_dir_entryset.patch
dvb_en_50221-convert-to-kthread-api.patch
x86_64-remove-sync_arb_ids.patch
x86_64-clear-io_apic-before-enabing-apic-error-vector.patch
clone-flag-clone_parent_tidptr-leaves-invalid-results-in-memory.patch
handle-the-multi-threaded-inits-exit-properly.patch
sysctl-core-stop-using-the-unnecessary-ctl_table-typedef.patch
sysctl-factor-out-sysctl_data.patch
sysctl-error-on-bad-sysctl-tables.patch
sysctl-update-sysctl_check_table.patch
sysct-mqueue-remove-the-binary-sysctl-numbers.patch
sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch
sysctl-fix-neighbour-table-sysctls.patch
sysctl-ipv6-route-flushing-kill-binary-path.patch
sysctl-remove-broken-sunrpc-debug-binary-sysctls.patch
sysctl-x86_64-remove-unnecessary-binary-paths.patch
sysctl-remove-broken-cdrom-binary-sysctls.patch
sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch
sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch
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
