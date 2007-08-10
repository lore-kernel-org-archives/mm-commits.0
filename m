From: akpm@linux-foundation.org
Subject: + sysctl-ipv6-route-flushing-kill-binary-path.patch added to -mm tree
Date: Thu, 09 Aug 2007 18:41:58 -0700
Message-ID: <200708100141.l7A1fwBU029573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50225 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754319AbXHJBml (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Aug 2007 21:42:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ebiederm@xmission.com, adobriyan@sw.ru, davem@davemloft.net


The patch titled
     sysctl: ipv6 route flushing (kill binary path)
has been added to the -mm tree.  Its filename is
     sysctl-ipv6-route-flushing-kill-binary-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: sysctl: ipv6 route flushing (kill binary path)
From: Eric W. Biederman <ebiederm@xmission.com>

We don't preoperly support the sysctl binary path for flushing the ipv6
routes.  So remove support for a binary path.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@sw.ru>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv6/route.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN net/ipv6/route.c~sysctl-ipv6-route-flushing-kill-binary-path net/ipv6/route.c
--- a/net/ipv6/route.c~sysctl-ipv6-route-flushing-kill-binary-path
+++ a/net/ipv6/route.c
@@ -2458,7 +2458,6 @@ int ipv6_sysctl_rtcache_flush(ctl_table 
 
 ctl_table ipv6_route_table[] = {
 	{
-		.ctl_name	=	NET_IPV6_ROUTE_FLUSH,
 		.procname	=	"flush",
 		.data		=	&flush_delay,
 		.maxlen		=	sizeof(int),
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
