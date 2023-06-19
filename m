Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84FB5EB64DB
	for <mm-commits@archiver.kernel.org>; Mon, 19 Jun 2023 20:20:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbjFSUUo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 19 Jun 2023 16:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjFSUUY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 19 Jun 2023 16:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F1DE64
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 13:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5056C60EB8
        for <mm-commits@vger.kernel.org>; Mon, 19 Jun 2023 20:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA655C433C8;
        Mon, 19 Jun 2023 20:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1687206021;
        bh=0fiDoNJg4ZIVllp5E00BCbZl0FLovPsZJC3Gwg+LO/M=;
        h=Date:To:From:Subject:From;
        b=hQNF9S51RdEvuEEFcaDI1QW+YlYCFCl1nBMOGRJjKvB9j9/xzJhB4nj4zj1iaHhL9
         hgn7WrwrHWZIJh3vQ4V8NV79qIcOUX0xWTG4SDsCwYwPRmUH8MLxROEmEMPz7LCyV6
         NZJJb8SCHKmJbPTo8lVsuBUiQlkWCuKqAb5GHFIs=
Date:   Mon, 19 Jun 2023 13:20:21 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
        tkhai@ya.ru, roman.gushchin@linux.dev, muchun.song@linux.dev,
        david@fromorbit.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] revert-mm-vmscan-make-global-slab-shrink-lockless.patch removed from -mm tree
Message-Id: <20230619202021.AA655C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: Revert "mm: vmscan: make global slab shrink lockless"
has been removed from the -mm tree.  Its filename was
     revert-mm-vmscan-make-global-slab-shrink-lockless.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Revert "mm: vmscan: make global slab shrink lockless"
Date: Fri, 9 Jun 2023 08:15:18 +0000

This reverts commit f95bdb700bc6bb74e1199b1f5f90c613e152cfa7.

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

Link: https://lkml.kernel.org/r/20230609081518.3039120-8-qi.zheng@linux.dev
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

 mm/vmscan.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/mm/vmscan.c~revert-mm-vmscan-make-global-slab-shrink-lockless
+++ a/mm/vmscan.c
@@ -57,7 +57,6 @@
 #include <linux/khugepaged.h>
 #include <linux/rculist_nulls.h>
 #include <linux/random.h>
-#include <linux/srcu.h>
 
 #include <asm/tlbflush.h>
 #include <asm/div64.h>
@@ -191,7 +190,6 @@ int vm_swappiness = 60;
 
 LIST_HEAD(shrinker_list);
 DECLARE_RWSEM(shrinker_rwsem);
-DEFINE_SRCU(shrinker_srcu);
 
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
@@ -742,7 +740,7 @@ void free_prealloced_shrinker(struct shr
 void register_shrinker_prepared(struct shrinker *shrinker)
 {
 	down_write(&shrinker_rwsem);
-	list_add_tail_rcu(&shrinker->list, &shrinker_list);
+	list_add_tail(&shrinker->list, &shrinker_list);
 	shrinker->flags |= SHRINKER_REGISTERED;
 	shrinker_debugfs_add(shrinker);
 	up_write(&shrinker_rwsem);
@@ -797,15 +795,13 @@ void unregister_shrinker(struct shrinker
 		return;
 
 	down_write(&shrinker_rwsem);
-	list_del_rcu(&shrinker->list);
+	list_del(&shrinker->list);
 	shrinker->flags &= ~SHRINKER_REGISTERED;
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		unregister_memcg_shrinker(shrinker);
 	debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
 	up_write(&shrinker_rwsem);
 
-	synchronize_srcu(&shrinker_srcu);
-
 	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
 
 	kfree(shrinker->nr_deferred);
@@ -825,7 +821,6 @@ void synchronize_shrinkers(void)
 {
 	down_write(&shrinker_rwsem);
 	up_write(&shrinker_rwsem);
-	synchronize_srcu(&shrinker_srcu);
 }
 EXPORT_SYMBOL(synchronize_shrinkers);
 
@@ -1036,7 +1031,6 @@ static unsigned long shrink_slab(gfp_t g
 {
 	unsigned long ret, freed = 0;
 	struct shrinker *shrinker;
-	int srcu_idx;
 
 	/*
 	 * The root memcg might be allocated even though memcg is disabled
@@ -1048,10 +1042,10 @@ static unsigned long shrink_slab(gfp_t g
 	if (!mem_cgroup_disabled() && !mem_cgroup_is_root(memcg))
 		return shrink_slab_memcg(gfp_mask, nid, memcg, priority);
 
-	srcu_idx = srcu_read_lock(&shrinker_srcu);
+	if (!down_read_trylock(&shrinker_rwsem))
+		goto out;
 
-	list_for_each_entry_srcu(shrinker, &shrinker_list, list,
-				 srcu_read_lock_held(&shrinker_srcu)) {
+	list_for_each_entry(shrinker, &shrinker_list, list) {
 		struct shrink_control sc = {
 			.gfp_mask = gfp_mask,
 			.nid = nid,
@@ -1062,9 +1056,19 @@ static unsigned long shrink_slab(gfp_t g
 		if (ret == SHRINK_EMPTY)
 			ret = 0;
 		freed += ret;
+		/*
+		 * Bail out if someone want to register a new shrinker to
+		 * prevent the registration from being stalled for long periods
+		 * by parallel ongoing shrinking.
+		 */
+		if (rwsem_is_contended(&shrinker_rwsem)) {
+			freed = freed ? : 1;
+			break;
+		}
 	}
 
-	srcu_read_unlock(&shrinker_srcu, srcu_idx);
+	up_read(&shrinker_rwsem);
+out:
 	cond_resched();
 	return freed;
 }
_

Patches currently in -mm which might be from zhengqi.arch@bytedance.com are


