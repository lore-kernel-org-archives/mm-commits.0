Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C0EDC7EE37
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 18:45:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbjFISop (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 14:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjFISom (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 14:44:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6649635B3
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 11:44:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0288065AF8
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 18:44:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51908C433D2;
        Fri,  9 Jun 2023 18:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686336280;
        bh=oVBU0IieSHo+aazWvYdOsZhmfye7ucNOevr3n6SIErg=;
        h=Date:To:From:Subject:From;
        b=fWpUszkO/OrpMw9jbABWjAqlJjsKTi8i3/bT9bnK0D5D+LHEeWQ9oOgGECCjYVhao
         eEdUzK1R0tydarvK+IsTLluMgmYSnN7mT28LK2jLD8otCPlgxXNbaxlT4+hRbeyIaa
         MyBIaYEcR4bWrzMlRsBLDOS0zIHGJpRbYF3cPImI=
Date:   Fri, 09 Jun 2023 11:44:39 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
        tkhai@ya.ru, roman.gushchin@linux.dev, muchun.song@linux.dev,
        david@fromorbit.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-vmscan-make-memcg-slab-shrink-lockless.patch added to mm-hotfixes-unstable branch
Message-Id: <20230609184440.51908C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: vmscan: make memcg slab shrink lockless"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-vmscan-make-memcg-slab-shrink-lockless.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-vmscan-make-memcg-slab-shrink-lockless.patch

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
Subject: Revert "mm: vmscan: make memcg slab shrink lockless"
Date: Fri, 9 Jun 2023 08:15:17 +0000

This reverts commit caa05325c9126c77ebf114edce51536a0d0a9a08.

Kernel test robot reports -88.8% regression in stress-ng.ramfs.ops_per_sec
test case [1], which is caused by commit f95bdb700bc6 ("mm: vmscan: make
global slab shrink lockless").  The root cause is that SRCU has to be
careful to not frequently check for SRCU read-side critical section exits.
Therefore, even if no one is currently in the SRCU read-side critical
section, synchronize_srcu() cannot return quickly.  That's why
unregister_shrinker() has become slower.

After discussion, we will try to use the refcount+RCU method [2] proposed
by Dave Chinner to continue to re-implement the lockless slab shrink.  So
revert the shrinker_srcu related changes first.

[1]. https://lore.kernel.org/lkml/202305230837.db2c233f-yujie.liu@intel.com/
[2]. https://lore.kernel.org/lkml/ZIJhou1d55d4H1s0@dread.disaster.area/

Link: https://lkml.kernel.org/r/20230609081518.3039120-7-qi.zheng@linux.dev
Reported-by: kernel test robot <yujie.liu@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202305230837.db2c233f-yujie.liu@intel.com
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Kirill Tkhai <tkhai@ya.ru>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   45 +++++++++++++++++++--------------------------
 1 file changed, 19 insertions(+), 26 deletions(-)

--- a/mm/vmscan.c~revert-mm-vmscan-make-memcg-slab-shrink-lockless
+++ a/mm/vmscan.c
@@ -210,21 +210,8 @@ static inline int shrinker_defer_size(in
 static struct shrinker_info *shrinker_info_protected(struct mem_cgroup *memcg,
 						     int nid)
 {
-	return srcu_dereference_check(memcg->nodeinfo[nid]->shrinker_info,
-				      &shrinker_srcu,
-				      lockdep_is_held(&shrinker_rwsem));
-}
-
-static struct shrinker_info *shrinker_info_srcu(struct mem_cgroup *memcg,
-						     int nid)
-{
-	return srcu_dereference(memcg->nodeinfo[nid]->shrinker_info,
-				&shrinker_srcu);
-}
-
-static void free_shrinker_info_rcu(struct rcu_head *head)
-{
-	kvfree(container_of(head, struct shrinker_info, rcu));
+	return rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
+					 lockdep_is_held(&shrinker_rwsem));
 }
 
 static int expand_one_shrinker_info(struct mem_cgroup *memcg,
@@ -265,7 +252,7 @@ static int expand_one_shrinker_info(stru
 		       defer_size - old_defer_size);
 
 		rcu_assign_pointer(pn->shrinker_info, new);
-		call_srcu(&shrinker_srcu, &old->rcu, free_shrinker_info_rcu);
+		kvfree_rcu(old, rcu);
 	}
 
 	return 0;
@@ -351,16 +338,15 @@ void set_shrinker_bit(struct mem_cgroup
 {
 	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
 		struct shrinker_info *info;
-		int srcu_idx;
 
-		srcu_idx = srcu_read_lock(&shrinker_srcu);
-		info = shrinker_info_srcu(memcg, nid);
+		rcu_read_lock();
+		info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
 		if (!WARN_ON_ONCE(shrinker_id >= info->map_nr_max)) {
 			/* Pairs with smp mb in shrink_slab() */
 			smp_mb__before_atomic();
 			set_bit(shrinker_id, info->map);
 		}
-		srcu_read_unlock(&shrinker_srcu, srcu_idx);
+		rcu_read_unlock();
 	}
 }
 
@@ -374,6 +360,7 @@ static int prealloc_memcg_shrinker(struc
 		return -ENOSYS;
 
 	down_write(&shrinker_rwsem);
+	/* This may call shrinker, so it must use down_read_trylock() */
 	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
 	if (id < 0)
 		goto unlock;
@@ -407,7 +394,7 @@ static long xchg_nr_deferred_memcg(int n
 {
 	struct shrinker_info *info;
 
-	info = shrinker_info_srcu(memcg, nid);
+	info = shrinker_info_protected(memcg, nid);
 	return atomic_long_xchg(&info->nr_deferred[shrinker->id], 0);
 }
 
@@ -416,7 +403,7 @@ static long add_nr_deferred_memcg(long n
 {
 	struct shrinker_info *info;
 
-	info = shrinker_info_srcu(memcg, nid);
+	info = shrinker_info_protected(memcg, nid);
 	return atomic_long_add_return(nr, &info->nr_deferred[shrinker->id]);
 }
 
@@ -947,14 +934,15 @@ static unsigned long shrink_slab_memcg(g
 {
 	struct shrinker_info *info;
 	unsigned long ret, freed = 0;
-	int srcu_idx;
 	int i;
 
 	if (!mem_cgroup_online(memcg))
 		return 0;
 
-	srcu_idx = srcu_read_lock(&shrinker_srcu);
-	info = shrinker_info_srcu(memcg, nid);
+	if (!down_read_trylock(&shrinker_rwsem))
+		return 0;
+
+	info = shrinker_info_protected(memcg, nid);
 	if (unlikely(!info))
 		goto unlock;
 
@@ -1004,9 +992,14 @@ static unsigned long shrink_slab_memcg(g
 				set_shrinker_bit(memcg, nid, i);
 		}
 		freed += ret;
+
+		if (rwsem_is_contended(&shrinker_rwsem)) {
+			freed = freed ? : 1;
+			break;
+		}
 	}
 unlock:
-	srcu_read_unlock(&shrinker_srcu, srcu_idx);
+	up_read(&shrinker_rwsem);
 	return freed;
 }
 #else /* CONFIG_MEMCG */
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

