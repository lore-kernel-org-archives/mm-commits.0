Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F5FEB64D9
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjFSUUo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230101AbjFSUUX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B70F1E63
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 13:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A3CE60E71
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 20:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB80C433C8;
        Mon, 19 Jun 2023 20:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206020;
        bh=iYFj9/sGIGibk/BFL9zRbyPMbr0WIPLn9D2Zwr7gIOQ=;
        h=Date:To:From:Subject:From;
        b=Dx5esQm+2RtiHAbr8ZeADo+ngAgxkHjUdN4kZxQSRkCq6Aj/BACG31jBA4qcHIWOx
         YLUTTAWqMsYWFfEbooFHNrDEVtJxMniMd0hA6Y2+E8Rxxhmy3VUSagfMH9c4ocwru5
         k4bAUiQ90M+ZOwCf30hkpdZogKJnSfdVZfgQkAlM=
Date:   Mon, 19 Jun 2023 13:20:20 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
        tkhai@ya.ru, roman.gushchin@linux.dev, muchun.song@linux.dev,
        david@fromorbit.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-vmscan-make-memcg-slab-shrink-lockless.patch removed from -mm tree
Message-Id: <20230619202020.9CB80C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm: vmscan: make memcg slab shrink lockless"
has been removed from the -mm tree.  Its filename was
     revert-mm-vmscan-make-memcg-slab-shrink-lockless.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


