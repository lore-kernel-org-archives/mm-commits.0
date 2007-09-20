From: akpm@linux-foundation.org
Subject: - fix-user-namespace-exiting-oops.patch removed from -mm tree
Date: Thu, 20 Sep 2007 14:15:56 -0700
Message-ID: <200709202115.l8KLFuUf002959@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59593 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264AbXITV3N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 20 Sep 2007 17:29:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xemul@openvz.org, adobriyan@openvz.org, serue@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Fix user namespace exiting OOPs
has been removed from the -mm tree.  Its filename was
     fix-user-namespace-exiting-oops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix user namespace exiting OOPs
From: Pavel Emelyanov <xemul@openvz.org>

It turned out, that the user namespace is released during the do_exit() in
exit_task_namespaces(), but the struct user_struct is released only during the
put_task_struct(), i.e.  MUCH later.

On debug kernels with poisoned slabs this will cause the oops in
uid_hash_remove() because the head of the chain, which resides inside the
struct user_namespace, will be already freed and poisoned.

Since the uid hash itself is required only when someone can search it, i.e. 
when the namespace is alive, we can safely unhash all the user_struct-s from
it during the namespace exiting.  The subsequent free_uid() will complete the
user_struct destruction.

For example simple program

   #include <sched.h>

   char stack[2 * 1024 * 1024];

   int f(void *foo)
   {
   	return 0;
   }

   int main(void)
   {
   	clone(f, stack + 1 * 1024 * 1024, 0x10000000, 0);
   	return 0;
   }

run on kernel with CONFIG_USER_NS turned on will oops the
kernel immediately.

This was spotted during OpenVZ kernel testing.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
Acked-by: "Serge E. Hallyn" <serue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h   |    1 +
 kernel/user.c           |   26 +++++++++++++++++++++++++-
 kernel/user_namespace.c |    2 +-
 3 files changed, 27 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~fix-user-namespace-exiting-oops include/linux/sched.h
--- a/include/linux/sched.h~fix-user-namespace-exiting-oops
+++ a/include/linux/sched.h
@@ -1472,6 +1472,7 @@ static inline struct user_struct *get_ui
 }
 extern void free_uid(struct user_struct *);
 extern void switch_uid(struct user_struct *);
+extern void release_uids(struct user_namespace *ns);
 
 #include <asm/current.h>
 
diff -puN kernel/user.c~fix-user-namespace-exiting-oops kernel/user.c
--- a/kernel/user.c~fix-user-namespace-exiting-oops
+++ a/kernel/user.c
@@ -62,7 +62,7 @@ static inline void uid_hash_insert(struc
 
 static inline void uid_hash_remove(struct user_struct *up)
 {
-	hlist_del(&up->uidhash_node);
+	hlist_del_init(&up->uidhash_node);
 }
 
 static inline struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
@@ -199,6 +199,30 @@ void switch_uid(struct user_struct *new_
 	suid_keys(current);
 }
 
+void release_uids(struct user_namespace *ns)
+{
+	int i;
+	unsigned long flags;
+	struct hlist_head *head;
+	struct hlist_node *nd;
+
+	spin_lock_irqsave(&uidhash_lock, flags);
+	/*
+	 * collapse the chains so that the user_struct-s will
+	 * be still alive, but not in hashes. subsequent free_uid()
+	 * will free them.
+	 */
+	for (i = 0; i < UIDHASH_SZ; i++) {
+		head = ns->uidhash_table + i;
+		while (!hlist_empty(head)) {
+			nd = head->first;
+			hlist_del_init(nd);
+		}
+	}
+	spin_unlock_irqrestore(&uidhash_lock, flags);
+
+	free_uid(ns->root_user);
+}
 
 static int __init uid_cache_init(void)
 {
diff -puN kernel/user_namespace.c~fix-user-namespace-exiting-oops kernel/user_namespace.c
--- a/kernel/user_namespace.c~fix-user-namespace-exiting-oops
+++ a/kernel/user_namespace.c
@@ -81,7 +81,7 @@ void free_user_ns(struct kref *kref)
 	struct user_namespace *ns;
 
 	ns = container_of(kref, struct user_namespace, kref);
-	free_uid(ns->root_user);
+	release_uids(ns);
 	kfree(ns);
 }
 
_

Patches currently in -mm which might be from xemul@openvz.org are

git-net.patch
git-nfsd.patch
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
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
isolate-the-explicit-usage-of-signal-pgrp.patch
use-helpers-to-obtain-task-pid-in-printks.patch
use-helpers-to-obtain-task-pid-in-printks-drm-fix.patch
use-helpers-to-obtain-task-pid-in-printks-arch-code.patch
remove-unused-variables-from-fs-proc-basec.patch
use-task_pid_nr-in-ip_vs_syncc.patch
cleanup-macros-for-distinguishing-mandatory-locks.patch
gfs2-cleanup-explicit-check-for-mandatory-locks.patch
9pfs-cleanup-explicit-check-for-mandatory-locks.patch
afs-cleanup-explicit-check-for-mandatory-locks.patch
nfs-cleanup-explicit-check-for-mandatory-locks.patch
reiser4-use-helpers-to-obtain-task-pid-in-printks.patch
