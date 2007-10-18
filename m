From: akpm@linux-foundation.org
Subject: - do_sys_poll-simplify-playing-with-on-stack-data.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:53:21 -0700
Message-ID: <200710180653.l9I6rLJw030434@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761538AbXJRHrQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:47:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@tv-sign.ru, ak@suse.de, davidel@xmailserver.org, vlobanov@speakeasy.net, mm-commits@vger.kernel.org


The patch titled
     do_sys_poll: simplify playing with on-stack data
has been removed from the -mm tree.  Its filename was
     do_sys_poll-simplify-playing-with-on-stack-data.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: do_sys_poll: simplify playing with on-stack data
From: Oleg Nesterov <oleg@tv-sign.ru>

Cleanup. Lessens both the source and compiled code (100 bytes) and imho makes
the code much more understandable.

With this patch "struct poll_list *head" always points to on-stack stack_pps,
so we can remove all "is it on-stack" and "was it initialized" checks.

Also, move poll_initwait/poll_freewait and -EINTR detection closer to the
do_poll()'s callsite.

[akpm@linux-foundation.org: fix warning (size_t != uint)]
Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>
Looks-good-to: Andi Kleen <ak@suse.de>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Vadim Lobanov <vlobanov@speakeasy.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/select.c |   92 +++++++++++++++++++-------------------------------
 1 file changed, 36 insertions(+), 56 deletions(-)

diff -puN fs/select.c~do_sys_poll-simplify-playing-with-on-stack-data fs/select.c
--- a/fs/select.c~do_sys_poll-simplify-playing-with-on-stack-data
+++ a/fs/select.c
@@ -651,86 +651,66 @@ static int do_poll(unsigned int nfds,  s
 int do_sys_poll(struct pollfd __user *ufds, unsigned int nfds, s64 *timeout)
 {
 	struct poll_wqueues table;
- 	int fdcount, err;
- 	unsigned int i;
-	struct poll_list *head;
- 	struct poll_list *walk;
+ 	int err = -EFAULT, fdcount, len, size;
 	/* Allocate small arguments on the stack to save memory and be
 	   faster - use long to make sure the buffer is aligned properly
 	   on 64 bit archs to avoid unaligned access */
 	long stack_pps[POLL_STACK_ALLOC/sizeof(long)];
-	struct poll_list *stack_pp = NULL;
+	struct poll_list *const head = (struct poll_list *)stack_pps;
+ 	struct poll_list *walk = head;
+ 	unsigned long todo = nfds;
 
-	/* Do a sanity check on nfds ... */
 	if (nfds > current->signal->rlim[RLIMIT_NOFILE].rlim_cur)
 		return -EINVAL;
 
-	poll_initwait(&table);
+	len = min_t(unsigned int, nfds, N_STACK_PPS);
+	for (;;) {
+		walk->next = NULL;
+		walk->len = len;
+		if (!len)
+			break;
 
-	head = NULL;
-	walk = NULL;
-	i = nfds;
-	err = -ENOMEM;
-	while(i!=0) {
-		struct poll_list *pp;
-		int num, size;
-		if (stack_pp == NULL)
-			num = N_STACK_PPS;
-		else
-			num = POLLFD_PER_PAGE;
-		if (num > i)
-			num = i;
-		size = sizeof(struct poll_list) + sizeof(struct pollfd)*num;
-		if (!stack_pp)
-			stack_pp = pp = (struct poll_list *)stack_pps;
-		else {
-			pp = kmalloc(size, GFP_KERNEL);
-			if (!pp)
-				goto out_fds;
-		}
-		pp->next=NULL;
-		pp->len = num;
-		if (head == NULL)
-			head = pp;
-		else
-			walk->next = pp;
+		if (copy_from_user(walk->entries, ufds + nfds-todo,
+					sizeof(struct pollfd) * walk->len))
+			goto out_fds;
 
-		walk = pp;
-		if (copy_from_user(pp->entries, ufds + nfds-i, 
-				sizeof(struct pollfd)*num)) {
-			err = -EFAULT;
+		todo -= walk->len;
+		if (!todo)
+			break;
+
+		len = min(todo, POLLFD_PER_PAGE);
+		size = sizeof(struct poll_list) + sizeof(struct pollfd) * len;
+		walk = walk->next = kmalloc(size, GFP_KERNEL);
+		if (!walk) {
+			err = -ENOMEM;
 			goto out_fds;
 		}
-		i -= pp->len;
 	}
 
+	poll_initwait(&table);
 	fdcount = do_poll(nfds, head, &table, timeout);
+	if (!fdcount && signal_pending(current))
+		fdcount = -EINTR;
+	poll_freewait(&table);
 
-	/* OK, now copy the revents fields back to user space. */
-	walk = head;
-	err = -EFAULT;
-	while(walk != NULL) {
+	for (walk = head; walk; walk = walk->next) {
 		struct pollfd *fds = walk->entries;
 		int j;
 
-		for (j=0; j < walk->len; j++, ufds++) {
-			if(__put_user(fds[j].revents, &ufds->revents))
+		for (j = 0; j < walk->len; j++, ufds++)
+			if (__put_user(fds[j].revents, &ufds->revents))
 				goto out_fds;
-		}
-		walk = walk->next;
   	}
+
 	err = fdcount;
-	if (!fdcount && signal_pending(current))
-		err = -EINTR;
 out_fds:
-	walk = head;
-	while(walk!=NULL) {
-		struct poll_list *pp = walk->next;
-		if (walk != stack_pp)
-			kfree(walk);
-		walk = pp;
+	walk = head->next;
+	while (walk) {
+		struct poll_list *pos = walk;
+		walk = walk->next;
+		kfree(pos);
 	}
-	poll_freewait(&table);
+
 	return err;
 }
 
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
