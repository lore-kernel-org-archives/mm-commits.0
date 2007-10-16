From: akpm@linux-foundation.org
Subject: - lockdep-give-each-filesystem-its-own-inode-lock-class.patch removed from -mm tree
Date: Mon, 15 Oct 2007 19:17:57 -0700
Message-ID: <200710160217.l9G2Hv7N004242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46063 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757143AbXJPCSF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Oct 2007 22:18:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: a.p.zijlstra@chello.nl, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     lockdep: give each filesystem its own inode lock class
has been removed from the -mm tree.  Its filename was
     lockdep-give-each-filesystem-its-own-inode-lock-class.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: lockdep: give each filesystem its own inode lock class
From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Give each filesystem its own inode lock class. The various filesystems have
different locking order wrt the inode locks; esp. the pseudo filesystems
differ from the rest.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c         |   12 +++++++++---
 include/linux/fs.h |    5 +++++
 2 files changed, 14 insertions(+), 3 deletions(-)

diff -puN fs/inode.c~lockdep-give-each-filesystem-its-own-inode-lock-class fs/inode.c
--- a/fs/inode.c~lockdep-give-each-filesystem-its-own-inode-lock-class
+++ a/fs/inode.c
@@ -142,6 +142,15 @@ static struct inode *alloc_inode(struct 
 			return NULL;
 		}
 
+		spin_lock_init(&inode->i_lock);
+		lockdep_set_class(&inode->i_lock, &sb->s_type->i_lock_key);
+
+		mutex_init(&inode->i_mutex);
+		lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key);
+
+		init_rwsem(&inode->i_alloc_sem);
+		lockdep_set_class(&inode->i_alloc_sem, &sb->s_type->i_alloc_sem_key);
+
 		mapping->a_ops = &empty_aops;
  		mapping->host = inode;
 		mapping->flags = 0;
@@ -190,8 +199,6 @@ void inode_init_once(struct inode *inode
 	INIT_HLIST_NODE(&inode->i_hash);
 	INIT_LIST_HEAD(&inode->i_dentry);
 	INIT_LIST_HEAD(&inode->i_devices);
-	mutex_init(&inode->i_mutex);
-	init_rwsem(&inode->i_alloc_sem);
 	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
 	rwlock_init(&inode->i_data.tree_lock);
 	spin_lock_init(&inode->i_data.i_mmap_lock);
@@ -199,7 +206,6 @@ void inode_init_once(struct inode *inode
 	spin_lock_init(&inode->i_data.private_lock);
 	INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
 	INIT_LIST_HEAD(&inode->i_data.i_mmap_nonlinear);
-	spin_lock_init(&inode->i_lock);
 	i_size_ordered_init(inode);
 #ifdef CONFIG_INOTIFY
 	INIT_LIST_HEAD(&inode->inotify_watches);
diff -puN include/linux/fs.h~lockdep-give-each-filesystem-its-own-inode-lock-class include/linux/fs.h
--- a/include/linux/fs.h~lockdep-give-each-filesystem-its-own-inode-lock-class
+++ a/include/linux/fs.h
@@ -1357,8 +1357,13 @@ struct file_system_type {
 	struct module *owner;
 	struct file_system_type * next;
 	struct list_head fs_supers;
+
 	struct lock_class_key s_lock_key;
 	struct lock_class_key s_umount_key;
+
+	struct lock_class_key i_lock_key;
+	struct lock_class_key i_mutex_key;
+	struct lock_class_key i_alloc_sem_key;
 };
 
 extern int get_sb_bdev(struct file_system_type *fs_type,
_

Patches currently in -mm which might be from a.p.zijlstra@chello.nl are

origin.patch
git-sched.patch
radix-tree-use-indirect-bit.patch
nfs-remove-congestion_end.patch
lib-percpu_counter_add.patch
lib-percpu_counter_sub.patch
lib-percpu_counter-variable-batch.patch
lib-make-percpu_counter_add-take-s64.patch
lib-percpu_counter_set.patch
lib-percpu_counter_sum_positive.patch
lib-percpu_count_sum.patch
lib-percpu_counter_init-error-handling.patch
lib-percpu_counter_init_irq.patch
mm-bdi-init-hooks.patch
mm-scalable-bdi-statistics-counters.patch
mm-count-reclaimable-pages-per-bdi.patch
mm-count-writeback-pages-per-bdi.patch
lib-floating-proportions.patch
mm-per-device-dirty-threshold.patch
mm-per-device-dirty-threshold-warning-fix.patch
mm-per-device-dirty-threshold-fix.patch
mm-dirty-balancing-for-tasks.patch
mm-dirty-balancing-for-tasks-warning-fix.patch
intel-iommu-dmar-detection-and-parsing-logic.patch
intel-iommu-pci-generic-helper-function.patch
intel-iommu-clflush_cache_range-now-takes-size-param.patch
intel-iommu-iova-allocation-and-management-routines.patch
intel-iommu-intel-iommu-driver.patch
intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
intel-iommu-intel-iommu-cmdline-option-forcedac.patch
intel-iommu-dmar-fault-handling-support.patch
intel-iommu-iommu-gfx-workaround.patch
intel-iommu-iommu-floppy-workaround.patch
peterz-vs-ext4-mballoc-core.patch
r-o-bind-mounts-track-number-of-mount-writers-make-lockdep-happy-with-r-o-bind-mounts.patch
task-containersv11-add-procfs-interface-containers-bdi-init-hooks.patch
task-containersv11-shared-container-subsystem-group-arrays-avoid-lockdep-warning.patch
task-containersv11-shared-container-subsystem-group-arrays-include-fix.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
memory-controller-add-documentation.patch
memory-controller-resource-counters-v7.patch
memory-controller-containers-setup-v7.patch
memory-controller-accounting-setup-v7.patch
memory-controller-memory-accounting-v7.patch
memory-controller-task-migration-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7-fix.patch
memory-controller-improve-user-interface.patch
memory-controller-oom-handling-v7.patch
memory-controller-oom-handling-v7-vs-oom-killer-stuff.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7-fix-2.patch
memory-controller-make-page_referenced-container-aware-v7.patch
memory-controller-make-charging-gfp-mask-aware.patch
