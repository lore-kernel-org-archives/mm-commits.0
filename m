From: akpm@linux-foundation.org
Subject: - do_poll-return-eintr-when-signalled.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:23 -0700
Message-ID: <200710180653.l9I6rNrP030437@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50540 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755711AbXJRHrG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:47:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ak@suse.de, davidel@xmailserver.org, vlobanov@speakeasy.net, mm-commits@vger.kernel.org


The patch titled
     do_poll: return -EINTR when signalled
has been removed from the -mm tree.  Its filename was
     do_poll-return-eintr-when-signalled.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: do_poll: return -EINTR when signalled
From: Oleg Nesterov <oleg@tv-sign.ru>

do_poll() checks signal_pending() but returns 0 when interrupted.  This means
the caller has to check signal_pending() again.

Change it to return -EINTR when signal_pending() and count == 0.

Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andi Kleen <ak@suse.de>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Vadim Lobanov <vlobanov@speakeasy.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/select.c~do_poll-return-eintr-when-signalled fs/select.c
--- a/fs/select.c~do_poll-return-eintr-when-signalled
+++ a/fs/select.c
@@ -586,7 +586,7 @@ static int do_poll(unsigned int nfds,  s
 	/* Optimise the no-wait case */
 	if (!(*timeout))
 		pt = NULL;
- 
+
 	for (;;) {
 		struct poll_list *walk;
 		long __timeout;
@@ -616,10 +616,12 @@ static int do_poll(unsigned int nfds,  s
 		 * a poll_table to them on the next loop iteration.
 		 */
 		pt = NULL;
-		if (count || !*timeout || signal_pending(current))
-			break;
-		count = wait->error;
-		if (count)
+		if (!count) {
+			count = wait->error;
+			if (signal_pending(current))
+				count = -EINTR;
+		}
+		if (count || !*timeout)
 			break;
 
 		if (*timeout < 0) {
@@ -689,8 +691,6 @@ int do_sys_poll(struct pollfd __user *uf
 
 	poll_initwait(&table);
 	fdcount = do_poll(nfds, head, &table, timeout);
-	if (!fdcount && signal_pending(current))
-		fdcount = -EINTR;
 	poll_freewait(&table);
 
 	for (walk = head; walk; walk = walk->next) {
_

Patches currently in -mm which might be from oleg@tv-sign.ru are

origin.patch
git-x86.patch
cpu-hotplug-slab-cleanup-cpuup_callback.patch
cpu-hotplug-slab-fix-memory-leak-in-cpu-hotplug-error-path.patch
cpu-hotplug-cpu-deliver-cpu_up_canceled-only-to-notify_oked-callbacks-with-cpu_up_prepare.patch
cpu-hotplug-topology-remove-topology_dev_map.patch
cpu-hotplug-thermal_throttle-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-msr-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-mce-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling.patch
cpu-hotplug-intel_cacheinfo-fix-cpu-hotplug-error-handling-fix-a-section-mismatch-warning.patch
make-access-to-tasks-nsproxy-lighter.patch
make-access-to-tasks-nsproxy-lighterpatch-breaks-unshare.patch
make-access-to-tasks-nsproxy-lighter-update-get_net_ns_by_pid.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
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
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-merge-fix.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
uninline-find_task_by_xxx-set-of-functions.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
uninline-find_pid-etc-set-of-functions.patch
uninline-the-task_xid_nr_ns-calls.patch
proc-export-a-processes-resource-limits-via-proc-pid.patch
fix-tsk-exit_state-usage-resend.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
