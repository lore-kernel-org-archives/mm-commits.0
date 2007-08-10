From: akpm@linux-foundation.org
Subject: + sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch added to -mm tree
Date: Thu, 09 Aug 2007 18:42:05 -0700
Message-ID: <200708100142.l7A1g5ba029594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35776 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755271AbXHJBnG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 21:43:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@sw.ru, bcrl@kvack.org, lenb@kernel.org, pbadari@us.ibm.com, zach.brown@oracle.com


The patch titled
     sysctl: remove the binary interface for aio-nr, aio-max-nr, acpi_video_flags
has been added to the -mm tree.  Its filename is
     sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: remove the binary interface for aio-nr, aio-max-nr, acpi_video_flags
From: Eric W. Biederman <ebiederm@xmission.com>

aio-nr, aio-max-nr, acpi_video_flags are unsigned long values which sysctl
does not handle properly with a 64bit kernel and a 32bit user space.

Since no one is likely to be using the binary sysctl values and the ascii
interface still works, this patch just removes support for the binary sysctl
interface from the kernel.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Zach Brown <zach.brown@oracle.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN kernel/sysctl.c~sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remove-the-binary-interface-for-aio-nr-aio-max-nr-acpi_video_flags
+++ a/kernel/sysctl.c
@@ -701,7 +701,6 @@ static struct ctl_table kern_table[] = {
 #endif
 #if	defined(CONFIG_ACPI_SLEEP) && defined(CONFIG_X86)
 	{
-		.ctl_name	= KERN_ACPI_VIDEO_FLAGS,
 		.procname	= "acpi_video_flags",
 		.data		= &acpi_realmode_flags,
 		.maxlen		= sizeof (unsigned long),
@@ -1193,7 +1192,6 @@ static struct ctl_table fs_table[] = {
 		.extra2		= &two,
 	},
 	{
-		.ctl_name	= FS_AIO_NR,
 		.procname	= "aio-nr",
 		.data		= &aio_nr,
 		.maxlen		= sizeof(aio_nr),
@@ -1201,7 +1199,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &proc_doulongvec_minmax,
 	},
 	{
-		.ctl_name	= FS_AIO_MAX_NR,
 		.procname	= "aio-max-nr",
 		.data		= &aio_max_nr,
 		.maxlen		= sizeof(aio_max_nr),
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
