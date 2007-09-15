From: akpm@linux-foundation.org
Subject: + convert-uid-hash-to-hlist.patch added to -mm tree
Date: Fri, 14 Sep 2007 19:31:30 -0700
Message-ID: <200709150231.l8F2VUUY003262@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40039 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759990AbXIOCbg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Sep 2007 22:31:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, adobriyan@openvz.org, serue@us.ibm.com


The patch titled
     Convert uid hash to hlist
has been added to the -mm tree.  Its filename is
     convert-uid-hash-to-hlist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Convert uid hash to hlist
From: Pavel Emelyanov <xemul@openvz.org>

Surprisingly, but (spotted by Alexey Dobriyan) the uid hash still uses
list_heads, thus occupying twice as much place as it could.  Convert it to
hlist_heads.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h          |    2 +-
 include/linux/user_namespace.h |    2 +-
 kernel/user.c                  |   15 ++++++++-------
 kernel/user_namespace.c        |    2 +-
 4 files changed, 11 insertions(+), 10 deletions(-)

diff -puN include/linux/sched.h~convert-uid-hash-to-hlist include/linux/sched.h
--- a/include/linux/sched.h~convert-uid-hash-to-hlist
+++ a/include/linux/sched.h
@@ -593,7 +593,7 @@ struct user_struct {
 #endif
 
 	/* Hash table maintenance information */
-	struct list_head uidhash_list;
+	struct hlist_node uidhash_node;
 	uid_t uid;
 };
 
diff -puN include/linux/user_namespace.h~convert-uid-hash-to-hlist include/linux/user_namespace.h
--- a/include/linux/user_namespace.h~convert-uid-hash-to-hlist
+++ a/include/linux/user_namespace.h
@@ -11,7 +11,7 @@
 
 struct user_namespace {
 	struct kref		kref;
-	struct list_head	uidhash_table[UIDHASH_SZ];
+	struct hlist_head	uidhash_table[UIDHASH_SZ];
 	struct user_struct	*root_user;
 };
 
diff -puN kernel/user.c~convert-uid-hash-to-hlist kernel/user.c
--- a/kernel/user.c~convert-uid-hash-to-hlist
+++ a/kernel/user.c
@@ -55,21 +55,22 @@ struct user_struct root_user = {
 /*
  * These routines must be called with the uidhash spinlock held!
  */
-static inline void uid_hash_insert(struct user_struct *up, struct list_head *hashent)
+static inline void uid_hash_insert(struct user_struct *up, struct hlist_head *hashent)
 {
-	list_add(&up->uidhash_list, hashent);
+	hlist_add_head(&up->uidhash_node, hashent);
 }
 
 static inline void uid_hash_remove(struct user_struct *up)
 {
-	list_del(&up->uidhash_list);
+	hlist_del(&up->uidhash_node);
 }
 
-static inline struct user_struct *uid_hash_find(uid_t uid, struct list_head *hashent)
+static inline struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
 {
 	struct user_struct *user;
+	struct hlist_node *h;
 
-	list_for_each_entry(user, hashent, uidhash_list) {
+	hlist_for_each_entry(user, h, hashent, uidhash_node) {
 		if(user->uid == uid) {
 			atomic_inc(&user->__count);
 			return user;
@@ -118,7 +119,7 @@ void free_uid(struct user_struct *up)
 
 struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
 {
-	struct list_head *hashent = uidhashentry(ns, uid);
+	struct hlist_head *hashent = uidhashentry(ns, uid);
 	struct user_struct *up;
 
 	spin_lock_irq(&uidhash_lock);
@@ -207,7 +208,7 @@ static int __init uid_cache_init(void)
 			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 
 	for(n = 0; n < UIDHASH_SZ; ++n)
-		INIT_LIST_HEAD(init_user_ns.uidhash_table + n);
+		INIT_HLIST_HEAD(init_user_ns.uidhash_table + n);
 
 	/* Insert the root user immediately (init already runs as root) */
 	spin_lock_irq(&uidhash_lock);
diff -puN kernel/user_namespace.c~convert-uid-hash-to-hlist kernel/user_namespace.c
--- a/kernel/user_namespace.c~convert-uid-hash-to-hlist
+++ a/kernel/user_namespace.c
@@ -39,7 +39,7 @@ static struct user_namespace *clone_user
 	kref_init(&ns->kref);
 
 	for (n = 0; n < UIDHASH_SZ; ++n)
-		INIT_LIST_HEAD(ns->uidhash_table + n);
+		INIT_HLIST_HEAD(ns->uidhash_table + n);
 
 	/* Insert new root user.  */
 	ns->root_user = alloc_uid(ns, 0);
_

Patches currently in -mm which might be from xemul@openvz.org are

leases-can-be-hidden-by-flocks.patch
convert-uid-hash-to-hlist.patch
fix-user-namespace-exiting-oops.patch
git-net.patch
memory-shortage-can-result-in-inconsistent-flocks-state.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix-capabilityc-to-work-with-threaded-init.patch
pid-namespaces-define-is_global_init-and-is_container_init-versus-x86_64-mm-i386-show-unhandled-signals-v3.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
make-access-to-tasks-nsproxy-lighter.patch
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
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-return-value-of-sys_set_tid_address.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-2.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-use-find_task_by_pid_ns-in-places-that-operate-with-virtual-fix-3.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-sys_getsid-sys_getpgid-return-wrong-id-for-task-from-another.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix-the-sys_setpgrp-to-work-between-namespaces.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
isolate-some-explicit-usage-of-task-tgid.patch
isolate-some-explicit-usage-of-task-tgid-fix.patch
isolate-some-explicit-usage-of-task-tgid-fix-fix.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-resource-counters-v7-fix.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
use-helpers-to-obtain-task-pid-in-printks.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
use-helpers-to-obtain-task-pid-in-printks-arch-code.patch
remove-unused-variables-from-fs-proc-basec.patch
use-task_pid_nr-in-ip_vs_syncc.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
