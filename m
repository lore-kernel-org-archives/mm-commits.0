From: akpm@linux-foundation.org
Subject: + sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch added to -mm tree
Date: Thu, 09 Aug 2007 18:41:55 -0700
Message-ID: <200708100141.l7A1ftnd029565@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56118 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879AbXHJBmi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 21:42:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@sw.ru


The patch titled
     sysctl: remove binary sysctl support where it clearly doesn't work
has been added to the -mm tree.  Its filename is
     sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: remove binary sysctl support where it clearly doesn't work
From: Eric W. Biederman <ebiederm@xmission.com>

These functions are all wrapper functions for the proc interface that are
needed for them to work correctly.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    7 -------
 1 file changed, 7 deletions(-)

diff -puN kernel/sysctl.c~sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work kernel/sysctl.c
--- a/kernel/sysctl.c~sysctl-remove-binary-sysctl-support-where-it-clearly-doesnt-work
+++ a/kernel/sysctl.c
@@ -363,7 +363,6 @@ static struct ctl_table kern_table[] = {
 	},
 #ifdef CONFIG_PROC_SYSCTL
 	{
-		.ctl_name	= KERN_TAINTED,
 		.procname	= "tainted",
 		.data		= &tainted,
 		.maxlen		= sizeof(int),
@@ -372,7 +371,6 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
-		.ctl_name	= KERN_CAP_BSET,
 		.procname	= "cap-bound",
 		.data		= &cap_bset,
 		.maxlen		= sizeof(kernel_cap_t),
@@ -648,7 +646,6 @@ static struct ctl_table kern_table[] = {
 		.proc_handler   = &proc_dointvec,
 	},
 	{
-		.ctl_name       = KERN_NMI_WATCHDOG,
 		.procname       = "nmi_watchdog",
 		.data           = &nmi_watchdog_enabled,
 		.maxlen         = sizeof (int),
@@ -837,7 +834,6 @@ static struct ctl_table vm_table[] = {
 		.extra2		= &one_hundred,
 	},
 	{
-		.ctl_name	= VM_DIRTY_WB_CS,
 		.procname	= "dirty_writeback_centisecs",
 		.data		= &dirty_writeback_interval,
 		.maxlen		= sizeof(dirty_writeback_interval),
@@ -845,7 +841,6 @@ static struct ctl_table vm_table[] = {
 		.proc_handler	= &dirty_writeback_centisecs_handler,
 	},
 	{
-		.ctl_name	= VM_DIRTY_EXPIRE_CS,
 		.procname	= "dirty_expire_centisecs",
 		.data		= &dirty_expire_interval,
 		.maxlen		= sizeof(dirty_expire_interval),
@@ -873,7 +868,6 @@ static struct ctl_table vm_table[] = {
 	},
 #ifdef CONFIG_HUGETLB_PAGE
 	 {
-		.ctl_name	= VM_HUGETLB_PAGES,
 		.procname	= "nr_hugepages",
 		.data		= &max_huge_pages,
 		.maxlen		= sizeof(unsigned long),
@@ -1124,7 +1118,6 @@ static struct ctl_table fs_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= FS_NRFILE,
 		.procname	= "file-nr",
 		.data		= &files_stat,
 		.maxlen		= 3*sizeof(int),
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
