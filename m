Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DA3C678D5
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 22:27:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjCGW1Q (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 17:27:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCGW0n (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 17:26:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF72D93E3A
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 14:26:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C927BCE1D59
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 22:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C533C433D2;
        Tue,  7 Mar 2023 22:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678227935;
        bh=M2hPEYk/srbcLK6NCkBeAtTIj9T/yz08HIdLtQRB1uY=;
        h=Date:To:From:Subject:From;
        b=Zpfgg+J91wZQUBwGmzNaIiGh+8/6xmr4GE5Urli34YzW24Cp+zkSDXFvOke3ErYR1
         q2UL5IOdtawOE80DMauzdmtbvMxhWO3/cNiGokjWsX0mjVpi/uhOeLhR0rcJVpJSzp
         J/v5clQaVrRI0kwKx3R/Ux7vAGhW6o7zkRlFVQWM=
Date:   Tue, 07 Mar 2023 14:25:34 -0800
To:     mm-commits@vger.kernel.org, tkhai@ya.ru, sultan@kerneltoast.com,
        shy828301@gmail.com, shakeelb@google.com, rppt@kernel.org,
        roman.gushchin@linux.dev, penguin-kernel@i-love.sakura.ne.jp,
        paulmck@kernel.org, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, david@redhat.com, dave@stgolabs.net,
        zhengqi.arch@bytedance.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch added to mm-unstable branch
Message-Id: <20230307222535.3C533C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: shrinkers: convert shrinker_rwsem to mutex
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm: shrinkers: convert shrinker_rwsem to mutex
Date: Tue, 7 Mar 2023 14:56:05 +0800

Now there are no readers of shrinker_rwsem, so we can simply replace it
with mutex lock.

Link: https://lkml.kernel.org/r/20230307065605.58209-9-zhengqi.arch@bytedance.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/md/dm-cache-metadata.c |    2 -
 drivers/md/dm-thin-metadata.c  |    2 -
 fs/super.c                     |    2 -
 mm/shrinker_debug.c            |   14 ++++++------
 mm/vmscan.c                    |   34 +++++++++++++++----------------
 5 files changed, 27 insertions(+), 27 deletions(-)

--- a/drivers/md/dm-cache-metadata.c~mm-shrinkers-convert-shrinker_rwsem-to-mutex
+++ a/drivers/md/dm-cache-metadata.c
@@ -1828,7 +1828,7 @@ int dm_cache_metadata_abort(struct dm_ca
 	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
 	 * cmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
 	 * shrinker associated with the block manager's bufio client vs cmd root_lock).
-	 * - must take shrinker_rwsem without holding cmd->root_lock
+	 * - must take shrinker_mutex without holding cmd->root_lock
 	 */
 	new_bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
 					 CACHE_MAX_CONCURRENT_LOCKS);
--- a/drivers/md/dm-thin-metadata.c~mm-shrinkers-convert-shrinker_rwsem-to-mutex
+++ a/drivers/md/dm-thin-metadata.c
@@ -1887,7 +1887,7 @@ int dm_pool_abort_metadata(struct dm_poo
 	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
 	 * pmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
 	 * shrinker associated with the block manager's bufio client vs pmd root_lock).
-	 * - must take shrinker_rwsem without holding pmd->root_lock
+	 * - must take shrinker_mutex without holding pmd->root_lock
 	 */
 	new_bm = dm_block_manager_create(pmd->bdev, THIN_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
 					 THIN_MAX_CONCURRENT_LOCKS);
--- a/fs/super.c~mm-shrinkers-convert-shrinker_rwsem-to-mutex
+++ a/fs/super.c
@@ -54,7 +54,7 @@ static char *sb_writers_name[SB_FREEZE_L
  * One thing we have to be careful of with a per-sb shrinker is that we don't
  * drop the last active reference to the superblock from within the shrinker.
  * If that happens we could trigger unregistering the shrinker from within the
- * shrinker path and that leads to deadlock on the shrinker_rwsem. Hence we
+ * shrinker path and that leads to deadlock on the shrinker_mutex. Hence we
  * take a passive reference to the superblock to avoid this from occurring.
  */
 static unsigned long super_cache_scan(struct shrinker *shrink,
--- a/mm/shrinker_debug.c~mm-shrinkers-convert-shrinker_rwsem-to-mutex
+++ a/mm/shrinker_debug.c
@@ -7,7 +7,7 @@
 #include <linux/memcontrol.h>
 
 /* defined in vmscan.c */
-extern struct rw_semaphore shrinker_rwsem;
+extern struct mutex shrinker_mutex;
 extern struct list_head shrinker_list;
 extern struct srcu_struct shrinker_srcu;
 
@@ -167,7 +167,7 @@ int shrinker_debugfs_add(struct shrinker
 	char buf[128];
 	int id;
 
-	lockdep_assert_held(&shrinker_rwsem);
+	lockdep_assert_held(&shrinker_mutex);
 
 	/* debugfs isn't initialized yet, add debugfs entries later. */
 	if (!shrinker_debugfs_root)
@@ -210,7 +210,7 @@ int shrinker_debugfs_rename(struct shrin
 	if (!new)
 		return -ENOMEM;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 
 	old = shrinker->name;
 	shrinker->name = new;
@@ -228,7 +228,7 @@ int shrinker_debugfs_rename(struct shrin
 			shrinker->debugfs_entry = entry;
 	}
 
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	kfree_const(old);
 
@@ -240,7 +240,7 @@ struct dentry *shrinker_debugfs_remove(s
 {
 	struct dentry *entry = shrinker->debugfs_entry;
 
-	lockdep_assert_held(&shrinker_rwsem);
+	lockdep_assert_held(&shrinker_mutex);
 
 	kfree_const(shrinker->name);
 	shrinker->name = NULL;
@@ -265,14 +265,14 @@ static int __init shrinker_debugfs_init(
 	shrinker_debugfs_root = dentry;
 
 	/* Create debugfs entries for shrinkers registered at boot */
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	list_for_each_entry(shrinker, &shrinker_list, list)
 		if (!shrinker->debugfs_entry) {
 			ret = shrinker_debugfs_add(shrinker);
 			if (ret)
 				break;
 		}
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	return ret;
 }
--- a/mm/vmscan.c~mm-shrinkers-convert-shrinker_rwsem-to-mutex
+++ a/mm/vmscan.c
@@ -35,7 +35,7 @@
 #include <linux/cpuset.h>
 #include <linux/compaction.h>
 #include <linux/notifier.h>
-#include <linux/rwsem.h>
+#include <linux/mutex.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
@@ -202,7 +202,7 @@ static void set_task_reclaim_state(struc
 }
 
 LIST_HEAD(shrinker_list);
-DECLARE_RWSEM(shrinker_rwsem);
+DEFINE_MUTEX(shrinker_mutex);
 DEFINE_SRCU(shrinker_srcu);
 static atomic_t shrinker_srcu_generation = ATOMIC_INIT(0);
 
@@ -225,7 +225,7 @@ static struct shrinker_info *shrinker_in
 {
 	return srcu_dereference_check(memcg->nodeinfo[nid]->shrinker_info,
 				      &shrinker_srcu,
-				      lockdep_is_held(&shrinker_rwsem));
+				      lockdep_is_held(&shrinker_mutex));
 }
 
 static struct shrinker_info *shrinker_info_srcu(struct mem_cgroup *memcg,
@@ -310,7 +310,7 @@ int alloc_shrinker_info(struct mem_cgrou
 	int nid, size, ret = 0;
 	int map_size, defer_size = 0;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	map_size = shrinker_map_size(shrinker_nr_max);
 	defer_size = shrinker_defer_size(shrinker_nr_max);
 	size = map_size + defer_size;
@@ -326,7 +326,7 @@ int alloc_shrinker_info(struct mem_cgrou
 		info->map_nr_max = shrinker_nr_max;
 		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, info);
 	}
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	return ret;
 }
@@ -342,7 +342,7 @@ static int expand_shrinker_info(int new_
 	if (!root_mem_cgroup)
 		goto out;
 
-	lockdep_assert_held(&shrinker_rwsem);
+	lockdep_assert_held(&shrinker_mutex);
 
 	map_size = shrinker_map_size(new_nr_max);
 	defer_size = shrinker_defer_size(new_nr_max);
@@ -392,7 +392,7 @@ static int prealloc_memcg_shrinker(struc
 	if (mem_cgroup_disabled())
 		return -ENOSYS;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		goto unlock;
@@ -406,7 +406,7 @@ static int prealloc_memcg_shrinker(struc
 	shrinker->id = id;
 	ret = 0;
 unlock:
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 	return ret;
 }
 
@@ -416,7 +416,7 @@ static void unregister_memcg_shrinker(st
 
 	BUG_ON(id < 0);
 
-	lockdep_assert_held(&shrinker_rwsem);
+	lockdep_assert_held(&shrinker_mutex);
 
 	idr_remove(&shrinker_idr, id);
 }
@@ -451,7 +451,7 @@ void reparent_shrinker_deferred(struct m
 		parent = root_mem_cgroup;
 
 	/* Prevent from concurrent shrinker_info expand */
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	for_each_node(nid) {
 		child_info = shrinker_info_protected(memcg, nid);
 		parent_info = shrinker_info_protected(parent, nid);
@@ -460,7 +460,7 @@ void reparent_shrinker_deferred(struct m
 			atomic_long_add(nr, &parent_info->nr_deferred[i]);
 		}
 	}
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 }
 
 static bool cgroup_reclaim(struct scan_control *sc)
@@ -709,9 +709,9 @@ void free_prealloced_shrinker(struct shr
 	shrinker->name = NULL;
 #endif
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE) {
-		down_write(&shrinker_rwsem);
+		mutex_lock(&shrinker_mutex);
 		unregister_memcg_shrinker(shrinker);
-		up_write(&shrinker_rwsem);
+		mutex_unlock(&shrinker_mutex);
 		return;
 	}
 
@@ -721,11 +721,11 @@ void free_prealloced_shrinker(struct shr
 
 void register_shrinker_prepared(struct shrinker *shrinker)
 {
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	list_add_tail_rcu(&shrinker->list, &shrinker_list);
 	shrinker->flags |= SHRINKER_REGISTERED;
 	shrinker_debugfs_add(shrinker);
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 }
 
 static int __register_shrinker(struct shrinker *shrinker)
@@ -775,13 +775,13 @@ void unregister_shrinker(struct shrinker
 	if (!(shrinker->flags & SHRINKER_REGISTERED))
 		return;
 
-	down_write(&shrinker_rwsem);
+	mutex_lock(&shrinker_mutex);
 	list_del_rcu(&shrinker->list);
 	shrinker->flags &= ~SHRINKER_REGISTERED;
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		unregister_memcg_shrinker(shrinker);
 	debugfs_entry = shrinker_debugfs_remove(shrinker);
-	up_write(&shrinker_rwsem);
+	mutex_unlock(&shrinker_mutex);
 
 	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are

mm-vmscan-add-a-map_nr_max-field-to-shrinker_info.patch
mm-vmscan-make-global-slab-shrink-lockless.patch
mm-vmscan-make-memcg-slab-shrink-lockless.patch
mm-shrinkers-make-count-and-scan-in-shrinker-debugfs-lockless.patch
mm-vmscan-hold-write-lock-to-reparent-shrinker-nr_deferred.patch
mm-vmscan-remove-shrinker_rwsem-from-synchronize_shrinkers.patch
mm-shrinkers-convert-shrinker_rwsem-to-mutex.patch

