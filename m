Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 103FEC61DA4
	for <mm-commits@archiver.kernel.org>; Mon, 13 Mar 2023 19:10:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229932AbjCMTKx (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 13 Mar 2023 15:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjCMTKl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 13 Mar 2023 15:10:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E04375861
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 12:10:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D125EB811DD
        for <mm-commits@vger.kernel.org>; Mon, 13 Mar 2023 19:10:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90B9DC433D2;
        Mon, 13 Mar 2023 19:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678734632;
        bh=PddccAIs25tKp95n0Qan+4U7knQ27OTgaC7ymrbwemc=;
        h=Date:To:From:Subject:From;
        b=zcuk5w7eexAdNNmBQAfxrCdPPDG/ldAWPmBURrHE0FRdR4N4/LsvdzqjD00J1IrhX
         uTVJ6Qvpil0HvmweQnILpVzd2+98Ei9ZgJYpaK3JjMTg/UQG9GxiTXgraQqBC4hYPG
         DP2L3pRrbHiDqaKm6nEU8SnLbCFi/1kFMTcHux4A=
Date:   Mon, 13 Mar 2023 12:10:32 -0700
To:     mm-commits@vger.kernel.org, zhengqi.arch@bytedance.com,
        vbabka@suse.cz, sultan@kerneltoast.com, shy828301@gmail.com,
        shakeelb@google.com, roman.gushchin@linux.dev,
        penguin-kernel@i-love.sakura.ne.jp, paulmck@kernel.org,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        david@redhat.com, dave@stgolabs.net, christian.koenig@amd.com,
        tkhai@ya.ru, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-add-shrinker_srcu_generation.patch added to mm-unstable branch
Message-Id: <20230313191032.90B9DC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: add shrinker_srcu_generation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-add-shrinker_srcu_generation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-add-shrinker_srcu_generation.patch

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
From: Kirill Tkhai <tkhai@ya.ru>
Subject: mm: vmscan: add shrinker_srcu_generation
Date: Mon, 13 Mar 2023 19:28:15 +0800

After we make slab shrink lockless with SRCU, the longest sleep
unregister_shrinker() will be a sleep waiting for all do_shrink_slab()
calls.

To avoid long unbreakable action in the unregister_shrinker(), add
shrinker_srcu_generation to restore a check similar to the
rwsem_is_contendent() check that we had before.

And for memcg slab shrink, we unlock SRCU and continue iterations from the
next shrinker id.

Link: https://lkml.kernel.org/r/20230313112819.38938-5-zhengqi.arch@bytedance.com
Signed-off-by: Kirill Tkhai <tkhai@ya.ru>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian König <christian.koenig@amd.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Sultan Alsawaf <sultan@kerneltoast.com>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/vmscan.c~mm-vmscan-add-shrinker_srcu_generation
+++ a/mm/vmscan.c
@@ -204,6 +204,7 @@ static void set_task_reclaim_state(struc
 LIST_HEAD(shrinker_list);
 DECLARE_RWSEM(shrinker_rwsem);
 DEFINE_SRCU(shrinker_srcu);
+static atomic_t shrinker_srcu_generation = ATOMIC_INIT(0);
 
 #ifdef CONFIG_MEMCG
 static int shrinker_nr_max;
@@ -776,6 +777,7 @@ void unregister_shrinker(struct shrinker
 	debugfs_entry = shrinker_debugfs_remove(shrinker);
 	up_write(&shrinker_rwsem);
 
+	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
 
 	debugfs_remove_recursive(debugfs_entry);
@@ -797,6 +799,7 @@ void synchronize_shrinkers(void)
 {
 	down_write(&shrinker_rwsem);
 	up_write(&shrinker_rwsem);
+	atomic_inc(&shrinker_srcu_generation);
 	synchronize_srcu(&shrinker_srcu);
 }
 EXPORT_SYMBOL(synchronize_shrinkers);
@@ -906,18 +909,20 @@ static unsigned long shrink_slab_memcg(g
 {
 	struct shrinker_info *info;
 	unsigned long ret, freed = 0;
-	int srcu_idx;
-	int i;
+	int srcu_idx, generation;
+	int i = 0;
 
 	if (!mem_cgroup_online(memcg))
 		return 0;
 
+again:
 	srcu_idx = srcu_read_lock(&shrinker_srcu);
 	info = shrinker_info_srcu(memcg, nid);
 	if (unlikely(!info))
 		goto unlock;
 
-	for_each_set_bit(i, info->map, info->map_nr_max) {
+	generation = atomic_read(&shrinker_srcu_generation);
+	for_each_set_bit_from(i, info->map, info->map_nr_max) {
 		struct shrink_control sc = {
 			.gfp_mask = gfp_mask,
 			.nid = nid,
@@ -963,6 +968,11 @@ static unsigned long shrink_slab_memcg(g
 				set_shrinker_bit(memcg, nid, i);
 		}
 		freed += ret;
+		if (atomic_read(&shrinker_srcu_generation) != generation) {
+			srcu_read_unlock(&shrinker_srcu, srcu_idx);
+			i++;
+			goto again;
+		}
 	}
 unlock:
 	srcu_read_unlock(&shrinker_srcu, srcu_idx);
@@ -1002,7 +1012,7 @@ static unsigned long shrink_slab(gfp_t g
 {
 	unsigned long ret, freed = 0;
 	struct shrinker *shrinker;
-	int srcu_idx;
+	int srcu_idx, generation;
 
 	/*
 	 * The root memcg might be allocated even though memcg is disabled
@@ -1016,6 +1026,7 @@ static unsigned long shrink_slab(gfp_t g
 
 	srcu_idx = srcu_read_lock(&shrinker_srcu);
 
+	generation = atomic_read(&shrinker_srcu_generation);
 	list_for_each_entry_srcu(shrinker, &shrinker_list, list,
 				 srcu_read_lock_held(&shrinker_srcu)) {
 		struct shrink_control sc = {
@@ -1028,6 +1039,11 @@ static unsigned long shrink_slab(gfp_t g
 		if (ret == SHRINK_EMPTY)
 			ret = 0;
 		freed += ret;
+
+		if (atomic_read(&shrinker_srcu_generation) != generation) {
+			freed = freed ? : 1;
+			break;
+		}
 	}
 
 	srcu_read_unlock(&shrinker_srcu, srcu_idx);
_

Patches currently in -mm which might be from tkhai@ya.ru are

mm-vmscan-add-shrinker_srcu_generation.patch

