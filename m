From: akpm@linux-foundation.org
Subject: + pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch added to -mm tree
Date: Tue, 14 Aug 2007 13:05:19 -0700
Message-ID: <200708142005.l7EK5KjI018702@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55782 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935140AbXHNUHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Aug 2007 16:07:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sukadev@us.ibm.com, ebiederm@xmission.com, menage@google.com, oleg@tv-sign.ru


The patch titled
     pid namespaces: create a slab-cache for 'struct pid_namespace'
has been added to the -mm tree.  Its filename is
     pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: pid namespaces: create a slab-cache for 'struct pid_namespace'
From: Sukadev Bhattiprolu <sukadev@us.ibm.com>

This will help fixing memory leaks due to bad reference counting.

Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Paul Menage <menage@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -puN kernel/pid.c~pid-namespaces-create-a-slab-cache-for-struct-pid_namespace kernel/pid.c
--- a/kernel/pid.c~pid-namespaces-create-a-slab-cache-for-struct-pid_namespace
+++ a/kernel/pid.c
@@ -40,6 +40,7 @@
 static struct hlist_head *pid_hash;
 static int pidhash_shift;
 struct pid init_struct_pid = INIT_STRUCT_PID;
+static struct kmem_cache *pid_ns_cachep;
 
 int pid_max = PID_MAX_DEFAULT;
 
@@ -485,7 +486,7 @@ static struct pid_namespace *create_pid_
 	struct pid_namespace *ns;
 	int i;
 
-	ns = kmalloc(sizeof(struct pid_namespace), GFP_KERNEL);
+	ns = kmem_cache_alloc(pid_ns_cachep, GFP_KERNEL);
 	if (ns == NULL)
 		goto out;
 
@@ -515,7 +516,7 @@ static struct pid_namespace *create_pid_
 out_free_map:
 	kfree(ns->pidmap[0].page);
 out_free:
-	kfree(ns);
+	kmem_cache_free(pid_ns_cachep, ns);
 out:
 	return ERR_PTR(-ENOMEM);
 }
@@ -526,7 +527,7 @@ static void destroy_pid_namespace(struct
 
 	for (i = 0; i < PIDMAP_ENTRIES; i++)
 		kfree(ns->pidmap[i].page);
-	kfree(ns);
+	kmem_cache_free(pid_ns_cachep, ns);
 }
 
 struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old_ns)
@@ -600,4 +601,6 @@ void __init pidmap_init(void)
 	init_pid_ns.pid_cachep = create_pid_cachep(1);
 	if (init_pid_ns.pid_cachep == NULL)
 		panic("Can't create pid_1 cachep\n");
+
+	pid_ns_cachep = KMEM_CACHE(pid_namespace, SLAB_PANIC);
 }
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
