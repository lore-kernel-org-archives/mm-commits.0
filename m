From: akpm@linux-foundation.org
Subject: + sysct-mqueue-remove-the-binary-sysctl-numbers.patch added to -mm tree
Date: Thu, 09 Aug 2007 18:41:54 -0700
Message-ID: <200708100141.l7A1fsdV029562@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754582AbXHJBmh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 21:42:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@sw.ru


The patch titled
     sysctl mqueue: remove the binary sysctl numbers
has been added to the -mm tree.  Its filename is
     sysct-mqueue-remove-the-binary-sysctl-numbers.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl mqueue: remove the binary sysctl numbers
From: Eric W. Biederman <ebiederm@xmission.com>

Because of a conflict with FS_INODE_NR none of the binary sysctl numbers use
by mqueue, were available to user space.  So just remove them.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN ipc/mqueue.c~sysct-mqueue-remove-the-binary-sysctl-numbers ipc/mqueue.c
--- a/ipc/mqueue.c~sysct-mqueue-remove-the-binary-sysctl-numbers
+++ a/ipc/mqueue.c
@@ -44,12 +44,6 @@
 #define STATE_PENDING	1
 #define STATE_READY	2
 
-/* used by sysctl */
-#define FS_MQUEUE 	1
-#define CTL_QUEUESMAX 	2
-#define CTL_MSGMAX 	3
-#define CTL_MSGSIZEMAX 	4
-
 /* default values */
 #define DFLT_QUEUESMAX	256	/* max number of message queues */
 #define DFLT_MSGMAX 	10	/* max number of messages in each queue */
@@ -1197,7 +1191,6 @@ static int msg_maxsize_limit_max = INT_M
 
 static ctl_table mq_sysctls[] = {
 	{
-		.ctl_name	= CTL_QUEUESMAX,
 		.procname	= "queues_max",
 		.data		= &queues_max,
 		.maxlen		= sizeof(int),
@@ -1205,7 +1198,6 @@ static ctl_table mq_sysctls[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
-		.ctl_name	= CTL_MSGMAX,
 		.procname	= "msg_max",
 		.data		= &msg_max,
 		.maxlen		= sizeof(int),
@@ -1215,7 +1207,6 @@ static ctl_table mq_sysctls[] = {
 		.extra2		= &msg_max_limit_max,
 	},
 	{
-		.ctl_name	= CTL_MSGSIZEMAX,
 		.procname	= "msgsize_max",
 		.data		= &msgsize_max,
 		.maxlen		= sizeof(int),
@@ -1229,7 +1220,6 @@ static ctl_table mq_sysctls[] = {
 
 static ctl_table mq_sysctl_dir[] = {
 	{
-		.ctl_name	= FS_MQUEUE,
 		.procname	= "mqueue",
 		.mode		= 0555,
 		.child		= mq_sysctls,
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
