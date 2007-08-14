From: akpm@linux-foundation.org
Subject: + pid-namespaces-introduce-struct-upid.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:04:52 -0700
Message-ID: <200708142004.l7EK4qUW018595@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34908 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763833AbXHNUFS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:05:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, xemul@openvz.org


The patch titled
     pid namespaces: introduce struct upid
has been added to the -mm tree.  Its filename is
     pid-namespaces-introduce-struct-upid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: introduce struct upid
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

Since task will be visible from different pid namespaces each of them have to
be addressed by multiple pids.  struct upid is to store the information about
which id refers to which namespace.

The constuciton looks like this.  Each struct pid carried the reference
counter and the list of tasks attached to this pid.  At its end it has a
variable length array of struct upid-s.  Each struct upid has a numerical id
(pid itself), pointer to the namespace, this ID is valid in and is hashed into
a pid_hash for searching the pids.

The nr and pid_chain fields are kept in struct pid for a while to make kernel
still work (no patch initialize the upids yet), but it will be removed at the
end of this series when we switch to upids completely.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/init_task.h |    6 ++++++
 include/linux/pid.h       |   16 ++++++++++++++++
 2 files changed, 22 insertions(+)

diff -puN include/linux/init_task.h~pid-namespaces-introduce-struct-upid include/linux/init_task.h
--- a/include/linux/init_task.h~pid-namespaces-introduce-struct-upid
+++ a/include/linux/init_task.h
@@ -102,6 +102,12 @@ extern struct group_info init_groups;
 		{ .first = &init_task.pids[PIDTYPE_SID].node },		\
 	},								\
 	.rcu		= RCU_HEAD_INIT,				\
+	.level		= 0,						\
+	.numbers	= { {						\
+		.nr		= 0,					\
+		.ns		= &init_pid_ns,				\
+		.pid_chain	= { .next = NULL, .pprev = NULL },	\
+	}, }								\
 }
 
 #define INIT_PID_LINK(type) 					\
diff -puN include/linux/pid.h~pid-namespaces-introduce-struct-upid include/linux/pid.h
--- a/include/linux/pid.h~pid-namespaces-introduce-struct-upid
+++ a/include/linux/pid.h
@@ -40,6 +40,20 @@ enum pid_type
  * processes.
  */
 
+
+/*
+ * struct upid is used to get the id of the struct pid, as it is
+ * seen in particular namespace. Later the struct pid is found with
+ * find_pid_ns() using the int nr and struct pid_namespace *ns.
+ */
+
+struct upid {
+	/* Try to keep pid_chain in the same cacheline as nr for find_pid */
+	int nr;
+	struct pid_namespace *ns;
+	struct hlist_node pid_chain;
+};
+
 struct pid
 {
 	atomic_t count;
@@ -49,6 +63,8 @@ struct pid
 	/* lists of tasks that use this pid */
 	struct hlist_head tasks[PIDTYPE_MAX];
 	struct rcu_head rcu;
+	int level;
+	struct upid numbers[1];
 };
 
 extern struct pid init_struct_pid;
_

Patches currently in -mm which might be from sukadev@us.ibm.com are

handle-the-multi-threaded-inits-exit-properly.patch
pid-namespaces-round-up-the-api.patch
pid-namespaces-make-get_pid_ns-return-the-namespace-itself.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces.patch
pid-namespaces-dynamic-kmem-cache-allocator-for-pid-namespaces-fix.patch
pid-namespaces-define-and-use-task_active_pid_ns-wrapper.patch
pid-namespaces-rename-child_reaper-function.patch
pid-namespaces-use-task_pid-to-find-leaders-pid.patch
pid-namespaces-define-is_global_init-and-is_container_init.patch
pid-namespaces-define-is_global_init-and-is_container_init-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-m32r-fix.patch
pid-namespaces-define-is_global_init-and-is_container_init-kernel-pidc-remove-unused-exports.patch
pid-namespaces-move-alloc_pid-to-copy_process.patch
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
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
