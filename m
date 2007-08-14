From: akpm@linux-foundation.org
Subject: + pid-namespaces-remove-the-struct-pid-unneeded-fields.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:05:28 -0700
Message-ID: <200708142005.l7EK5Sdt018715@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55081 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935535AbXHNUML (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:12:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     pid namespaces: remove the struct pid unneeded fields
has been added to the -mm tree.  Its filename is
     pid-namespaces-remove-the-struct-pid-unneeded-fields.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: remove the struct pid unneeded fields
From: Pavel Emelyanov <xemul@openvz.org>

Since we've switched from using pid->nr to pid->upids->nr some
fields on struct pid are no longer needed

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |    3 ---
 include/linux/pid.h       |    3 ---
 kernel/pid.c              |    1 -
 3 files changed, 7 deletions(-)

diff -puN include/linux/init_task.h~pid-namespaces-remove-the-struct-pid-unneeded-fields include/linux/init_task.h
--- a/include/linux/init_task.h~pid-namespaces-remove-the-struct-pid-unneeded-fields
+++ a/include/linux/init_task.h
@@ -93,9 +93,6 @@ extern struct group_info init_groups;
 
 #define INIT_STRUCT_PID {						\
 	.count 		= ATOMIC_INIT(1),				\
-	.nr		= 0, 						\
-	/* Don't put this struct pid in pid_hash */			\
-	.pid_chain	= { .next = NULL, .pprev = NULL },		\
 	.tasks		= {						\
 		{ .first = &init_task.pids[PIDTYPE_PID].node },		\
 		{ .first = &init_task.pids[PIDTYPE_PGID].node },	\
diff -puN include/linux/pid.h~pid-namespaces-remove-the-struct-pid-unneeded-fields include/linux/pid.h
--- a/include/linux/pid.h~pid-namespaces-remove-the-struct-pid-unneeded-fields
+++ a/include/linux/pid.h
@@ -57,9 +57,6 @@ struct upid {
 struct pid
 {
 	atomic_t count;
-	/* Try to keep pid_chain in the same cacheline as nr for find_pid */
-	int nr;
-	struct hlist_node pid_chain;
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
diff -puN kernel/pid.c~pid-namespaces-remove-the-struct-pid-unneeded-fields kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-remove-the-struct-pid-unneeded-fields
+++ a/kernel/pid.c
@@ -262,7 +262,6 @@ struct pid *alloc_pid(struct pid_namespa
 
 	get_pid_ns(ns);
 	pid->level = ns->level;
-	pid->nr = pid->numbers[0].nr;
 	atomic_set(&pid->count, 1);
 	for (type = 0; type < PIDTYPE_MAX; ++type)
 		INIT_HLIST_HEAD(&pid->tasks[type]);
_

Patches currently in -mm which might be from xemul@openvz.org are

git-net.patch
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
pid-namespaces-rework-forget_original_parent.patch
pid-namespaces-move-exit_task_namespaces.patch
pid-namespaces-introduce-ms_kernmount-flag.patch
pid-namespaces-prepare-proc_flust_task-to-flush-entries-from-multiple-proc-trees.patch
pid-namespaces-introduce-struct-upid.patch
pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch
pid-namespaces-make-alloc_pid-free_pid-and-put_pid-work-with-struct-upid.patch
pid-namespaces-helpers-to-obtain-pid-numbers.patch
pid-namespaces-helpers-to-find-the-task-by-its-numerical-ids.patch
pid-namespaces-move-alloc_pid-lower-in-copy_process.patch
pid-namespaces-make-proc-have-multiple-superblocks-one-for-each-namespace.patch
pid-namespaces-miscelaneous-preparations-for-pid-namespaces.patch
pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
