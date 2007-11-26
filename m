From: akpm@linux-foundation.org
Subject: + dont-forget-to-unlock-uids_mutex-on-error-paths.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:53:58 -0800
Message-ID: <200711262353.lAQNrwW8029540@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44197 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756403AbXKZXyg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:54:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, dhaval@linux.vnet.ibm.com, mingo@elte.hu


The patch titled
     Don't forget to unlock uids_mutex on error paths
has been added to the -mm tree.  Its filename is
     dont-forget-to-unlock-uids_mutex-on-error-paths.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Don't forget to unlock uids_mutex on error paths
From: Pavel Emelyanov <xemul@openvz.org>

The commit

commit 5cb350baf580017da38199625b7365b1763d7180
Author: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Date:   Mon Oct 15 17:00:14 2007 +0200

    sched: group scheduling, sysfs tunables

introduced the uids_mutex and the helpers to lock/unlock it.  Unfortunately,
the error paths of alloc_uid() were not patched to unlock it.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN kernel/user.c~dont-forget-to-unlock-uids_mutex-on-error-paths kernel/user.c
--- a/kernel/user.c~dont-forget-to-unlock-uids_mutex-on-error-paths
+++ a/kernel/user.c
@@ -335,8 +335,11 @@ struct user_struct * alloc_uid(struct us
 		struct user_struct *new;
 
 		new = kmem_cache_alloc(uid_cachep, GFP_KERNEL);
-		if (!new)
+		if (!new) {
+			uids_mutex_unlock();
 			return NULL;
+		}
+
 		new->uid = uid;
 		atomic_set(&new->__count, 1);
 		atomic_set(&new->processes, 0);
@@ -353,6 +356,7 @@ struct user_struct * alloc_uid(struct us
 
 		if (alloc_uid_keyring(new, current) < 0) {
 			kmem_cache_free(uid_cachep, new);
+			uids_mutex_unlock();
 			return NULL;
 		}
 
@@ -360,6 +364,7 @@ struct user_struct * alloc_uid(struct us
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
+			uids_mutex_unlock();
 			return NULL;
 		}
 
_

Patches currently in -mm which might be from xemul@openvz.org are

wait_task_stopped-dont-use-task_pid_nr_ns-lockless.patch
ipc-lost-unlock-and-fput-in-mqueuec-on-error-path.patch
git-net.patch
dont-forget-to-unlock-uids_mutex-on-error-paths.patch
merge-multiple-error-paths-in-alloc_uid-into-one.patch
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
proc-fix-the-threaded-proc-self.patch
reiser4.patch
