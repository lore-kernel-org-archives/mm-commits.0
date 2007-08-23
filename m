From: akpm@linux-foundation.org
Subject: + task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch added to -mm tree
Date: Thu, 23 Aug 2007 15:55:06 -0700
Message-ID: <200708232255.l7NMt650031253@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59336 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753677AbXHWWzP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Aug 2007 18:55:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: menage@google.com, a.p.zijlstra@chello.nl


The patch titled
     Containers: Avoid lockdep warning
has been added to the -mm tree.  Its filename is
     task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Containers: Avoid lockdep warning
From: Paul Menage <menage@google.com>

I think this is the right way to handle the lockdep false-positive in the
current containers patches, but I'm not that familiar with lockdep so any
suggestions for a better approach are welcomed.

In order to avoid a false-positive lockdep warning, we lock the root inode
of a new filesystem mount prior to taking container_mutex, to preserve the
invariant that container_mutex nests inside inode->i_mutex.  In order to
prevent a lockdep false positive when locking i_mutex on a newly-created
container directory inode we use mutex_lock_nested(), with a nesting level
of I_MUTEX_CHILD since the new inode will ultimately be a child directory
of the parent whose i_mutex is nested outside of container_mutex.

Signed-off-by: Paul Menage <menage@google.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/container.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

diff -puN kernel/container.c~task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning kernel/container.c
--- a/kernel/container.c~task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning
+++ a/kernel/container.c
@@ -867,13 +867,16 @@ static int container_get_sb(struct file_
 	} else {
 		/* New superblock */
 		struct container *cont = &root->top_container;
+		struct inode *inode;
 
 		BUG_ON(sb->s_root != NULL);
 
 		ret = container_get_rootdir(sb);
 		if (ret)
 			goto drop_new_super;
+		inode = sb->s_root->d_inode;
 
+		mutex_lock(&inode->i_mutex);
 		mutex_lock(&container_mutex);
 
 		/*
@@ -886,12 +889,14 @@ static int container_get_sb(struct file_
 		ret = allocate_cg_links(css_group_count, &tmp_cg_links);
 		if (ret) {
 			mutex_unlock(&container_mutex);
+			mutex_unlock(&inode->i_mutex);
 			goto drop_new_super;
 		}
 
 		ret = rebind_subsystems(root, root->subsys_bits);
 		if (ret == -EBUSY) {
 			mutex_unlock(&container_mutex);
+			mutex_unlock(&inode->i_mutex);
 			goto drop_new_super;
 		}
 
@@ -931,16 +936,8 @@ static int container_get_sb(struct file_
 		BUG_ON(!list_empty(&cont->children));
 		BUG_ON(root->number_of_containers != 1);
 
-		/*
-		 * I believe that it's safe to nest i_mutex inside
-		 * container_mutex in this case, since no-one else can
-		 * be accessing this directory yet. But we still need
-		 * to teach lockdep that this is the case - currently
-		 * a containerfs remount triggers a lockdep warning
-		 */
-		mutex_lock(&cont->dentry->d_inode->i_mutex);
 		container_populate_dir(cont);
-		mutex_unlock(&cont->dentry->d_inode->i_mutex);
+		mutex_unlock(&inode->i_mutex);
 		mutex_unlock(&container_mutex);
 	}
 
@@ -1358,7 +1355,7 @@ static int container_create_file(struct 
 
 		/* start with the directory inode held, so that we can
 		 * populate it without racing with another mkdir */
-		mutex_lock(&inode->i_mutex);
+		mutex_lock_nested(&inode->i_mutex, I_MUTEX_CHILD);
 	} else if (S_ISREG(mode)) {
 		inode->i_size = 0;
 		inode->i_fop = &container_file_operations;
_

Patches currently in -mm which might be from menage@google.com are

cpuset-zero-malloc-revert-the-old-cpuset-fix.patch
task-containersv11-basic-task-container-framework.patch
task-containersv11-basic-task-container-framework-fix.patch
task-containersv11-add-tasks-file-interface.patch
task-containersv11-add-fork-exit-hooks.patch
task-containersv11-add-container_clone-interface.patch
task-containersv11-add-procfs-interface.patch
task-containersv11-shared-container-subsystem-group-arrays.patch
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-automatic-userspace-notification-of-idle-containers.patch
task-containersv11-make-cpusets-a-client-of-containers.patch
task-containersv11-example-cpu-accounting-subsystem.patch
task-containersv11-simple-task-container-debug-info-subsystem.patch
add-containerstats-v3.patch
add-containerstats-v3-fix.patch
containers-implement-namespace-tracking-subsystem.patch
containers-implement-namespace-tracking-subsystem-fix-order-of-container-subsystems-in-init-kconfig.patch
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
pid-namespaces-make-proc_flush_task-actually-from-entries-from-multiple-namespaces.patch
pid-namespaces-initialize-the-namespaces-proc_mnt.patch
pid-namespaces-create-a-slab-cache-for-struct-pid_namespace.patch
pid-namespaces-allow-signalling-container-init.patch
pid-namespaces-destroy-pid-namespace-on-inits-death.patch
pid-namespaces-changes-to-show-virtual-ids-to-user.patch
pid-namespaces-changes-to-show-virtual-ids-to-user-fix.patch
pid-namespaces-remove-the-struct-pid-unneeded-fields.patch
