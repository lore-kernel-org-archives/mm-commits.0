From: akpm@linux-foundation.org
Subject: + pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:04:54 -0700
Message-ID: <200708142004.l7EK4sLV018600@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56267 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765228AbXHNUFc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:05:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xemul@openvz.org, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru, sukadev@us.ibm.com


The patch titled
     pid namespaces: add support for pid namespaces hierarchy
has been added to the -mm tree.  Its filename is
     pid-namespaces-add-support-for-pid-namespaces-hierarchy.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: add support for pid namespaces hierarchy
From: Pavel Emelyanov <xemul@openvz.org>

Each namespace has a parent and is characterized by its "level".  Level is the
number of the namespace generation.  E.g.  init namespace has level 0, after
cloning new one it will have level 1, the next one - 2 and so on and so forth.
 This level is not explicitly limited.

True hierarchy must have some way to find each namespace's children, but it is
not used in the patches, so this ability is not added (yet).

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pid_namespace.h |    2 ++
 kernel/pid.c                  |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/linux/pid_namespace.h~pid-namespaces-add-support-for-pid-namespaces-hierarchy include/linux/pid_namespace.h
--- a/include/linux/pid_namespace.h~pid-namespaces-add-support-for-pid-namespaces-hierarchy
+++ a/include/linux/pid_namespace.h
@@ -21,6 +21,8 @@ struct pid_namespace {
 	int last_pid;
 	struct task_struct *child_reaper;
 	struct kmem_cache *pid_cachep;
+	int level;
+	struct pid_namespace *parent;
 };
 
 extern struct pid_namespace init_pid_ns;
diff -puN kernel/pid.c~pid-namespaces-add-support-for-pid-namespaces-hierarchy kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-add-support-for-pid-namespaces-hierarchy
+++ a/kernel/pid.c
@@ -67,7 +67,8 @@ struct pid_namespace init_pid_ns = {
 		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
 	},
 	.last_pid = 0,
-	.child_reaper = &init_task
+	.level = 0,
+	.child_reaper = &init_task,
 };
 
 int is_global_init(struct task_struct *tsk)
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
