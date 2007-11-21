From: akpm@linux-foundation.org
Subject: + ipc-lost-unlock-and-fput-in-mqueuec-on-error-path.patch added to -mm tree
Date: Wed, 21 Nov 2007 13:15:22 -0800
Message-ID: <200711212115.lALLFMSD009718@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33433 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751540AbXKUVQD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Nov 2007 16:16:03 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, Nadia.Derbey@bull.net, pierre.peiffer@bull.net


The patch titled
     ipc: lost unlock and fput in mqueue.c on error path
has been added to the -mm tree.  Its filename is
     ipc-lost-unlock-and-fput-in-mqueuec-on-error-path.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ipc: lost unlock and fput in mqueue.c on error path
From: Pavel Emelyanov <xemul@openvz.org>

The error path in sys_mq_getsetattr() after the call to
audit_mq_getsetattr() is wrong - the info->lock is not unlocked and the
struct file *filp is not put.

Fix them both.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN ipc/mqueue.c~ipc-lost-unlock-and-fput-in-mqueuec-on-error-path ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-lost-unlock-and-fput-in-mqueuec-on-error-path
+++ a/ipc/mqueue.c
@@ -1138,8 +1138,10 @@ asmlinkage long sys_mq_getsetattr(mqd_t 
 	omqstat.mq_flags = filp->f_flags & O_NONBLOCK;
 	if (u_mqstat) {
 		ret = audit_mq_getsetattr(mqdes, &mqstat);
-		if (ret != 0)
-			goto out;
+		if (ret != 0) {
+			spin_unlock(&info->lock);
+			goto out_fput;
+		}
 		if (mqstat.mq_flags & O_NONBLOCK)
 			filp->f_flags |= O_NONBLOCK;
 		else
_

Patches currently in -mm which might be from xemul@openvz.org are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
ipc-lost-unlock-and-fput-in-mqueuec-on-error-path.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-memcgroup-fix-try_to_free-order.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
memcgroup-reinstate-swapoff-mod.patch
bugfix-for-memory-cgroup-controller-charge-refcnt-race-fix.patch
bugfix-for-memory-cgroup-controller-fix-error-handling-path-in-mem_charge_cgroup.patch
bugfix-for-memory-controller-add-helper-function-for-assigning-cgroup-to-page.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages.patch
bugfix-for-memory-cgroup-controller-avoid-pagelru-page-in-mem_cgroup_isolate_pages-fix.patch
memcgroup-fix-zone-isolation-oom.patch
memcgroup-revert-swap_state-mods.patch
bugfix-for-memory-cgroup-controller-migration-under-memory-controller-fix.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-force_empty-interface-for-dropping-all-account-in-empty-cgroup.patch
memory-cgroup-enhancements-remember-a-page-is-charged-as-page-cache.patch
memory-cgroup-enhancements-remember-a-page-is-on-active-list-of-cgroup-or-not.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-checkpatch-fixes.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-1.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-uninlining.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup-fix-2.patch
memory-cgroup-enhancements-add-memorystat-file.patch
memory-cgroup-enhancements-add-memorystat-file-checkpatch-fixes.patch
memory-cgroup-enhancements-add-memorystat-file-printk-fix.patch
memory-cgroup-enhancements-add-pre_destroy-handler.patch
memory-cgroup-enhancements-implicit-force_empty-at-rmdir.patch
add-the-namespaces-config-option.patch
move-the-uts-namespace-under-uts_ns-option.patch
move-the-ipc-namespace-under-ipc_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option.patch
cleanup-the-code-managed-with-the-user_ns-option-checkpatch-fixes.patch
cleanup-the-code-managed-with-pid_ns-option.patch
cleanup-the-code-managed-with-pid_ns-option-checkpatch-fixes.patch
mark-net_ns-with-depends-on-namespaces.patch
proc-proper-pidns-handling-for-proc-self.patch
reiser4.patch
