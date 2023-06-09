Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B994AC7EE2E
	for <mm-commits@archiver.kernel.org>; Fri,  9 Jun 2023 18:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbjFISoo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 9 Jun 2023 14:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjFISok (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jun 2023 14:44:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56856198C
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 11:44:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E824A65ADB
        for <mm-commits@vger.kernel.org>; Fri,  9 Jun 2023 18:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC74C433D2;
        Fri,  9 Jun 2023 18:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1686336278;
        bh=Q9SMiAztnRNLWriYBj/m0+mb4rxsAIXz1tEKnBZbqUA=;
        h=Date:To:From:Subject:From;
        b=kSatQ9+MrWxVGaF3+1WV/UAIkaklG4d7d5V+rz32xibS7BgdVtYXR5bebHe0fikD0
         IV9AAcVDFcux7koCOwYwqp+DZzlR7rD8C+z1HGHTpHYxt6Vn5nIYw0UgAbZQw9k5HU
         8ygWnDfrgf3fRu+WCkWP8w3auWiqmHAaCpLNdLBs=
Date:   Fri, 09 Jun 2023 11:44:37 -0700
To:     mm-commits@vger.kernel.org, yujie.liu@intel.com, vbabka@suse.cz,
        tkhai@ya.ru, roman.gushchin@linux.dev, muchun.song@linux.dev,
        david@fromorbit.com, zhengqi.arch@bytedance.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + revert-mm-vmscan-add-shrinker_srcu_generation.patch added to mm-hotfixes-unstable branch
Message-Id: <20230609184438.4CC74C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Revert "mm: vmscan: add shrinker_srcu_generation"
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     revert-mm-vmscan-add-shrinker_srcu_generation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/revert-mm-vmscan-add-shrinker_srcu_generation.patch

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
Subject: Revert "mm: vmscan: add shrinker_srcu_generation"
Date: Fri, 9 Jun 2023 08:15:16 +0000

This reverts commit 475733dda5aedba9e086379aafe6b5ffd53e8f5e.

Kernel test robot reports -88.8% regression in stress-ng.ramfs.ops_per_sec
test case [1], which is caused by commit f95bdb700bc6 ("mm: vmscan: make
global slab shrink lockless").  The root cause is that SRCU has to be
careful to not frequently check for SRCU read-side critical section exits.
Therefore, even if no one is currently in the SRCU read-side critical
section, synchronize_srcu() cannot return quickly.  That's why
unregister_shrinker() has become slower.

We will try to use the refcount+RCU method [2] proposed by Dave Chinner to
continue to re-implement the lockless slab shrink.  So revert the
shrinker_srcu related changes first.

[1]. https://lore.kernel.org/lkml/202305230837.db2c233f-yujie.liu@intel.com/
[2]. https://lore.kernel.org/lkml/ZIJhou1d55d4H1s0@dread.disaster.area/

Link: https://lkml.kernel.org/r/20230609081518.3039120-6-qi.zheng@linux.dev
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

 mm/vmscan.c |   24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

--- a/mm/vmscan.c~revert-mm-vmscan-add-shrinker_srcu_generation
+++ a/mm/vmscan.c
@@ -192,7 +192,6 @@ int vm_swappiness = 60;
 LIST_HEAD(shrinker_list);
 DECLARE_RWSEM(shrinker_rwsem);
 DEFINE_SRCU(shrinker_srcu);
-static atomic_t shrinker_srcu_generation = ATOMIC_INIT(0);
 
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
@@ -818,7 +817,6 @@ void unregister_shrinker(struct shrinker
 	debugfs_entry = shrinker_debugfs_detach(shrinker, &debugfs_id);
 	up_write(&shrinker_rwsem);
 
-	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
 
 	shrinker_debugfs_remove(debugfs_entry, debugfs_id);
@@ -840,7 +838,6 @@ void synchronize_shrinkers(void)
 {
 	down_write(&shrinker_rwsem);
 	up_write(&shrinker_rwsem);
-	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
 }
 EXPORT_SYMBOL(synchronize_shrinkers);
@@ -950,20 +947,18 @@ static unsigned long shrink_slab_memcg(g
 {
 	struct shrinker_info *info;
 	unsigned long ret, freed = 0;
-	int srcu_idx, generation;
-	int i = 0;
+	int srcu_idx;
+	int i;
 
 	if (!mem_cgroup_online(memcg))
 		return 0;
 
-again:
 	srcu_idx = srcu_read_lock(&shrinker_srcu);
 	info = shrinker_info_srcu(memcg, nid);
 	if (unlikely(!info))
 		goto unlock;
 
-	generation = atomic_read(&shrinker_srcu_generation);
-	for_each_set_bit_from(i, info->map, info->map_nr_max) {
+	for_each_set_bit(i, info->map, info->map_nr_max) {
 		struct shrink_control sc = {
 			.gfp_mask = gfp_mask,
 			.nid = nid,
@@ -1009,11 +1004,6 @@ again:
 				set_shrinker_bit(memcg, nid, i);
 		}
 		freed += ret;
-		if (atomic_read(&shrinker_srcu_generation) != generation) {
-			srcu_read_unlock(&shrinker_srcu, srcu_idx);
-			i++;
-			goto again;
-		}
 	}
 unlock:
 	srcu_read_unlock(&shrinker_srcu, srcu_idx);
@@ -1053,7 +1043,7 @@ static unsigned long shrink_slab(gfp_t g
 {
 	unsigned long ret, freed = 0;
 	struct shrinker *shrinker;
-	int srcu_idx, generation;
+	int srcu_idx;
 
 	/*
 	 * The root memcg might be allocated even though memcg is disabled
@@ -1067,7 +1057,6 @@ static unsigned long shrink_slab(gfp_t g
 
 	srcu_idx = srcu_read_lock(&shrinker_srcu);
 
-	generation = atomic_read(&shrinker_srcu_generation);
 	list_for_each_entry_srcu(shrinker, &shrinker_list, list,
 				 srcu_read_lock_held(&shrinker_srcu)) {
 		struct shrink_control sc = {
@@ -1080,11 +1069,6 @@ static unsigned long shrink_slab(gfp_t g
 		if (ret == SHRINK_EMPTY)
 			ret = 0;
 		freed += ret;
-
-		if (atomic_read(&shrinker_srcu_generation) != generation) {
-			freed = freed ? : 1;
-			break;
-		}
 	}
 
 	srcu_read_unlock(&shrinker_srcu, srcu_idx);
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

