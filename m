From: akpm@linux-foundation.org
Subject: + merge-multiple-error-paths-in-alloc_uid-into-one.patch added to -mm tree
Date: Mon, 26 Nov 2007 15:54:23 -0800
Message-ID: <200711262354.lAQNsNC4029615@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35353 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756547AbXKZXyr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Nov 2007 18:54:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, dhaval@linux.vnet.ibm.com, mingo@elte.hu


The patch titled
     Merge multiple error paths in alloc_uid into one
has been added to the -mm tree.  Its filename is
     merge-multiple-error-paths-in-alloc_uid-into-one.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Merge multiple error paths in alloc_uid into one
From: Pavel Emelyanov <xemul@openvz.org>

There are already 4 error paths in alloc_uid() that do incremental rollbacks. 
I think it's time to merge them.  This costs us 8 lines of code :)

Maybe it would be better to merge this patch with the previous one, but I
remember that some time ago I sent a similar patch (fixing the error path and
cleaning it), but I was told to make two patches in such cases.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |   47 ++++++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 27 deletions(-)

diff -puN kernel/user.c~merge-multiple-error-paths-in-alloc_uid-into-one kernel/user.c
--- a/kernel/user.c~merge-multiple-error-paths-in-alloc_uid-into-one
+++ a/kernel/user.c
@@ -320,7 +320,7 @@ void free_uid(struct user_struct *up)
 struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
 {
 	struct hlist_head *hashent = uidhashentry(ns, uid);
-	struct user_struct *up;
+	struct user_struct *up, *new;
 
 	/* Make uid_hash_find() + uids_user_create() + uid_hash_insert()
 	 * atomic.
@@ -332,13 +332,9 @@ struct user_struct * alloc_uid(struct us
 	spin_unlock_irq(&uidhash_lock);
 
 	if (!up) {
-		struct user_struct *new;
-
 		new = kmem_cache_alloc(uid_cachep, GFP_KERNEL);
-		if (!new) {
-			uids_mutex_unlock();
-			return NULL;
-		}
+		if (!new)
+			goto out_unlock;
 
 		new->uid = uid;
 		atomic_set(&new->__count, 1);
@@ -354,28 +350,14 @@ struct user_struct * alloc_uid(struct us
 #endif
 		new->locked_shm = 0;
 
-		if (alloc_uid_keyring(new, current) < 0) {
-			kmem_cache_free(uid_cachep, new);
-			uids_mutex_unlock();
-			return NULL;
-		}
+		if (alloc_uid_keyring(new, current) < 0)
+			goto out_free_user;
 
-		if (sched_create_user(new) < 0) {
-			key_put(new->uid_keyring);
-			key_put(new->session_keyring);
-			kmem_cache_free(uid_cachep, new);
-			uids_mutex_unlock();
-			return NULL;
-		}
+		if (sched_create_user(new) < 0)
+			goto out_put_keys;
 
-		if (uids_user_create(new)) {
-			sched_destroy_user(new);
-			key_put(new->uid_keyring);
-			key_put(new->session_keyring);
-			kmem_cache_free(uid_cachep, new);
-			uids_mutex_unlock();
-			return NULL;
-		}
+		if (uids_user_create(new))
+			goto out_destoy_sched;
 
 		/*
 		 * Before adding this, check whether we raced
@@ -403,6 +385,17 @@ struct user_struct * alloc_uid(struct us
 	uids_mutex_unlock();
 
 	return up;
+
+out_destoy_sched:
+	sched_destroy_user(new);
+out_put_keys:
+	key_put(new->uid_keyring);
+	key_put(new->session_keyring);
+out_free_user:
+	kmem_cache_free(uid_cachep, new);
+out_unlock:
+	uids_mutex_unlock();
+	return NULL;
 }
 
 void switch_uid(struct user_struct *new_user)
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
