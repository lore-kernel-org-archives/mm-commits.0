Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A377DC7EE2E
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 18:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjFISoc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 14:44:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjFISoc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 14:44:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A13C198C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 11:44:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D733617C6
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 18:44:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76F4C433EF;
        Fri,  9 Jun 2023 18:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686336269;
        bh=sR63sL3dpRNeg7+nR56BBA1RqWom1lFPbVNphV8L5So=;
        h=Date:To:From:Subject:From;
        b=sRKD6jZDttSo0+EFJtyNWceqdo7yo8MX+xES1I/4+u7iBAxj3HKXv8IOs1nL/7oIl
         K7wJNV8LVuP699ANv1QPvQI9KhHucriv6pcHhWYRWTQ4vQSNN6vSBRkbIM1nFkmGZK
         Dm9Jl9FQkH8HBLz+ZqeSFPdmrw2B6HRCflssr5nM=
Date:   Fri, 09 Jun 2023 11:44:28 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
        tkhai@ya.ru, roman.gushchin@linux.dev, muchun.song@linux.dev,
        david@fromorbit.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch added to mm-hotfixes-unstable branch
Message-Id: <20230609184428.E76F4C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: shrinkers: convert shrinker_rwsem to mutex"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Revert "mm: shrinkers: convert shrinker_rwsem to mutex"
Date: Fri, 9 Jun 2023 08:15:12 +0000

Patch series "revert shrinker_srcu related changes".


This patch (of 7):

This reverts commit cf2e309ebca7bb0916771839f9b580b06c778530.

Kernel test robot reports -88.8% regression in stress-ng.ramfs.ops_per_sec
test case [1], which is caused by commit f95bdb700bc6 ("mm: vmscan: make
global slab shrink lockless").  The root cause is that SRCU has to be
careful to not frequently check for SRCU read-side critical section exits.
Therefore, even if no one is currently in the SRCU read-side critical
section, synchronize_srcu() cannot return quickly.  That's why
unregister_shrinker() has become slower.

After discussion, we will try to use the refcount+RCU method [2] proposed
by Dave Chinner to continue to re-implement the lockless slab shrink.  So
revert the shrinker_mutex back to shrinker_rwsem first.

[1]. https://lore.kernel.org/lkml/202305230837.db2c233f-yujie.liu@intel.com/
[2]. https://lore.kernel.org/lkml/ZIJhou1d55d4H1s0@dread.disaster.area/

Link: https://lkml.kernel.org/r/20230609081518.3039120-1-qi.zheng@linux.dev
Link: https://lkml.kernel.org/r/20230609081518.3039120-2-qi.zheng@linux.dev
Reported-by: kernel test robot <yujie.liu@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202305230837.db2c233f-yujie.liu@intel.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yujie Liu <yujie.liu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-cache-metadata.c |    2 -
 drivers/md/dm-thin-metadata.c  |    2 -
 fs/super.c                     |    2 -
 mm/shrinker_debug.c            |   14 ++++++------
 mm/vmscan.c                    |   34 +++++++++++++++----------------
 5 files changed, 27 insertions(+), 27 deletions(-)

--- a/drivers/md/dm-cache-metadata.c~revert-mm-shrinkers-convert-shrinker_rwsem-to-mutex
+++ a/drivers/md/dm-cache-metadata.c
@@ -1828,7 +1828,7 @@ int dm_cache_metadata_abort(struct dm_ca
 	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
 	 * cmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
 	 * shrinker associated with the block manager's bufio client vs cmd root_lock).
-	 * - must take shrinker_mutex without holding cmd->root_lock
+	 * - must take shrinker_rwsem without holding cmd->root_lock
 	 */
 	new_bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
 					 CACHE_MAX_CONCURRENT_LOCKS);
--- a/drivers/md/dm-thin-metadata.c~revert-mm-shrinkers-convert-shrinker_rwsem-to-mutex
+++ a/drivers/md/dm-thin-metadata.c
@@ -1887,7 +1887,7 @@ int dm_pool_abort_metadata(struct dm_poo
 	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
 	 * pmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
 	 * shrinker associated with the block manager's bufio client vs pmd root_lock).
-	 * - must take shrinker_mutex without holding pmd->root_lock
+	 * - must take shrinker_rwsem without holding pmd->root_lock
 	 */
 	new_bm = dm_block_manager_create(pmd->bdev, THIN_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
 					 THIN_MAX_CONCURRENT_LOCKS);
--- a/fs/super.c~revert-mm-shrinkers-convert-shrinker_rwsem-to-mutex
+++ a/fs/super.c
@@ -54,7 +54,7 @@ static char *sb_writers_name[SB_FREEZE_L
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
  * If that happens we could trigger unregistering the shrinker from within the
- * shrinker path and that leads to deadlock on the shrinker_mutex. Hence we
+ * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
  * take a passive reference to the superblock to avoid this from occurring.
  */
 static unsigned long super_cache_scan(struct shrinker *shrink,
--- a/mm/shrinker_debug.c~revert-mm-shrinkers-convert-shrinker_rwsem-to-mutex
+++ a/mm/shrinker_debug.c
@@ -8,7 +8,7 @@
 #include <linux/srcu.h>
 
 /* defined in vmscan.c */
-extern struct mutex shrinker_mutex;
+extern struct rw_semaphore shrinker_rwsem;
 extern struct list_head shrinker_list;
 extern struct srcu_struct shrinker_srcu;
 
@@ -168,7 +168,7 @@ int shrinker_debugfs_add(struct shrinker
 	char buf[128];
 	int id;
 
-	lockdep_assert_held(&shrinker_mutex);
+	lockdep_assert_held(&shrinker_rwsem);
 
 	/* debugfs isn't initialized yet, add debugfs entries later. */
 	if (!shrinker_debugfs_root)
@@ -211,7 +211,7 @@ int shrinker_debugfs_rename(struct shrin
 	if (!new)
 		return -ENOMEM;
 
-	mutex_lock(&shrinker_mutex);
+	down_write(&shrinker_rwsem);
 
 	old = shrinker->name;
 	shrinker->name = new;
@@ -229,7 +229,7 @@ int shrinker_debugfs_rename(struct shrin
 			shrinker->debugfs_entry = entry;
 	}
 
-	mutex_unlock(&shrinker_mutex);
+	up_write(&shrinker_rwsem);
 
 	kfree_const(old);
 
@@ -242,7 +242,7 @@ struct dentry *shrinker_debugfs_detach(s
 {
 	struct dentry *entry = shrinker->debugfs_entry;
 
-	lockdep_assert_held(&shrinker_mutex);
+	lockdep_assert_held(&shrinker_rwsem);
 
 	kfree_const(shrinker->name);
 	shrinker->name = NULL;
@@ -271,14 +271,14 @@ static int __init shrinker_debugfs_init(
 	shrinker_debugfs_root = dentry;
 
 	/* Create debugfs entries for shrinkers registered at boot */
-	mutex_lock(&shrinker_mutex);
+	down_write(&shrinker_rwsem);
 	list_for_each_entry(shrinker, &shrinker_list, list)
 		if (!shrinker->debugfs_entry) {
 			ret = shrinker_debugfs_add(shrinker);
 			if (ret)
 				break;
 		}
-	mutex_unlock(&shrinker_mutex);
+	up_write(&shrinker_rwsem);
 
 	return ret;
 }
--- a/mm/vmscan.c~revert-mm-shrinkers-convert-shrinker_rwsem-to-mutex
+++ a/mm/vmscan.c
@@ -35,7 +35,7 @@
 #include <linux/cpuset.h>
 #include <linux/compaction.h>
 #include <linux/notifier.h>
-#include <linux/mutex.h>
+#include <linux/rwsem.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -190,7 +190,7 @@ struct scan_control {
 int vm_swappiness = 60;
 
 LIST_HEAD(shrinker_list);
-DEFINE_MUTEX(shrinker_mutex);
+DECLARE_RWSEM(shrinker_rwsem);
 DEFINE_SRCU(shrinker_srcu);
 static atomic_t shrinker_srcu_generation = ATOMIC_INIT(0);
 
@@ -213,7 +213,7 @@ static struct shrinker_info *shrinker_in
 {
 	return srcu_dereference_check(memcg->nodeinfo[nid]->shrinker_info,
 				      &shrinker_srcu,
-				      lockdep_is_held(&shrinker_mutex));
+				      lockdep_is_held(&shrinker_rwsem));
 }
 
 static struct shrinker_info *shrinker_info_srcu(struct mem_cgroup *memcg,
@@ -292,7 +292,7 @@ int alloc_shrinker_info(struct mem_cgrou
 	int nid, size, ret = 0;
 	int map_size, defer_size = 0;
 
-	mutex_lock(&shrinker_mutex);
+	down_write(&shrinker_rwsem);
 	map_size = shrinker_map_size(shrinker_nr_max);
 	defer_size = shrinker_defer_size(shrinker_nr_max);
 	size = map_size + defer_size;
@@ -308,7 +308,7 @@ int alloc_shrinker_info(struct mem_cgrou
 		info->map_nr_max = shrinker_nr_max;
 		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
 	}
-	mutex_unlock(&shrinker_mutex);
+	up_write(&shrinker_rwsem);
 
 	return ret;
 }
@@ -324,7 +324,7 @@ static int expand_shrinker_info(int new_
 	if (!root_mem_cgroup)
 		goto out;
 
-	lockdep_assert_held(&shrinker_mutex);
+	lockdep_assert_held(&shrinker_rwsem);
 
 	map_size = shrinker_map_size(new_nr_max);
 	defer_size = shrinker_defer_size(new_nr_max);
@@ -374,7 +374,7 @@ static int prealloc_memcg_shrinker(struc
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
 
-	mutex_lock(&shrinker_mutex);
+	down_write(&shrinker_rwsem);
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		goto unlock;
@@ -388,7 +388,7 @@ static int prealloc_memcg_shrinker(struc
 	shrinker->id = id;
 	ret = 0;
 unlock:
-	mutex_unlock(&shrinker_mutex);
+	up_write(&shrinker_rwsem);
 	return ret;
 }
 
@@ -398,7 +398,7 @@ static void unregister_memcg_shrinker(st
 
 	BUG_ON(id < 0);
 
-	lockdep_assert_held(&shrinker_mutex);
+	lockdep_assert_held(&shrinker_rwsem);
 
 	idr_remove(&shrinker_idr, id);
 }
@@ -433,7 +433,7 @@ void reparent_shrinker_deferred(struct m
 		parent = root_mem_cgroup;
 
 	/* Prevent from concurrent shrinker_info expand */
-	mutex_lock(&shrinker_mutex);
+	down_write(&shrinker_rwsem);
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
@@ -442,7 +442,7 @@ void reparent_shrinker_deferred(struct m
 			atomic_long_add(nr, &parent_info->nr_deferred[i]);
 		}
 	}
-	mutex_unlock(&shrinker_mutex);
+	up_write(&shrinker_rwsem);
 }
 
 static bool cgroup_reclaim(struct scan_control *sc)
@@ -743,9 +743,9 @@ void free_prealloced_shrinker(struct shr
 	shrinker->name = NULL;
 #endif
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
-		mutex_lock(&shrinker_mutex);
+		down_write(&shrinker_rwsem);
 		unregister_memcg_shrinker(shrinker);
-		mutex_unlock(&shrinker_mutex);
+		up_write(&shrinker_rwsem);
 		return;
 	}
 
@@ -755,11 +755,11 @@ void free_prealloced_shrinker(struct shr
 
 void register_shrinker_prepared(struct shrinker *shrinker)
 {
-	mutex_lock(&shrinker_mutex);
+	down_write(&shrinker_rwsem);
 	list_add_tail_rcu(&shrinker->list, &shrinker_list);
 	shrinker->flags |= SHRINKER_REGISTERED;
 	shrinker_debugfs_add(shrinker);
-	mutex_unlock(&shrinker_mutex);
+	up_write(&shrinker_rwsem);
 }
 
 static int __register_shrinker(struct shrinker *shrinker)
@@ -810,13 +810,13 @@ void unregister_shrinker(struct shrinker
 	if (!(shrinker->flags & SHRINKER_REGISTERED))
 		return;
 
-	mutex_lock(&shrinker_mutex);
+	down_write(&shrinker_rwsem);
 	list_del_rcu(&shrinker->list);
 	shrinker->flags &= ~SHRINKER_REGISTERED;
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		unregister_memcg_shrinker(shrinker);
 	debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
-	mutex_unlock(&shrinker_mutex);
+	up_write(&shrinker_rwsem);
 
 	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

revert-mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch
revert-mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch
revert-mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch
revert-mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch
revert-mm-vmscan-add-shrinker_srcu_generation.patch
revert-mm-vmscan-make-memcg-slab-shrink-lockless.patch
revert-mm-vmscan-make-global-slab-shrink-lockless.patch
mm-vmscan-move-shrinker_debugfs_remove-before-synchronize_srcu.patch

