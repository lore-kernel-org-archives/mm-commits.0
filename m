From: akpm@linux-foundation.org
Subject: + sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch added to -mm tree
Date: Thu, 09 Aug 2007 18:42:04 -0700
Message-ID: <200708100142.l7A1g4Jn029591@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45545 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092AbXHJBmr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 21:42:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@sw.ru, davem@davemloft.net


The patch titled
     sysctl: ipv4 remove binary sysctl paths where they are broken
has been added to the -mm tree.  Its filename is
     sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: ipv4 remove binary sysctl paths where they are broken
From: Eric W. Biederman <ebiederm@xmission.com>

Currently tcp_available_congestion_control does not even attempt being read
from sys_sysctl, and ipfrag_max_dist while it works allows setting of invalid
values using sys_sysctl.

So just kill the binary sys_sysctl support for these sysctls.  If the support
is not important enough to test and get right it probably isn't important
enough to keep.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/sysctl_net_ipv4.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN net/ipv4/sysctl_net_ipv4.c~sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken net/ipv4/sysctl_net_ipv4.c
--- a/net/ipv4/sysctl_net_ipv4.c~sysctl-ipv4-remove-binary-sysctl-paths-where-they-are-broken
+++ a/net/ipv4/sysctl_net_ipv4.c
@@ -672,7 +672,6 @@ ctl_table ipv4_table[] = {
 		.strategy	= &sysctl_jiffies
 	},
 	{
-		.ctl_name	= NET_IPV4_IPFRAG_MAX_DIST,
 		.procname	= "ipfrag_max_dist",
 		.data		= &sysctl_ipfrag_max_dist,
 		.maxlen		= sizeof(int),
@@ -797,7 +796,6 @@ ctl_table ipv4_table[] = {
 	},
 #endif /* CONFIG_NETLABEL */
 	{
-		.ctl_name	= NET_TCP_AVAIL_CONG_CONTROL,
 		.procname	= "tcp_available_congestion_control",
 		.maxlen		= TCP_CA_BUF_MAX,
 		.mode		= 0444,
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
