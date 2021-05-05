Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E7CC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AE5B6141F
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231996AbhEEBhM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhEEBhL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:37:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C2A866141B;
        Wed,  5 May 2021 01:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178575;
        bh=HOQiaMpXD8LRfpKexZytBQcwzGnDcCT2ioY05ao+jUo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=btu72YM2nqkBEu921Bsy7FTgtpsBJNyxH4DvjdsI6cvkS82tD7qJWy5le2rnrGVFA
         9mqGf0Z7cAdx8Z4/7C/PgImauz7ANCRexm+IRTk2aygF/iXsEVt0E8wYKLRPcnIEiv
         +WRo/DiBYKizS0GKwqs2mTXDL7TLZJXoH67t3u4k=
Date:   Tue, 04 May 2021 18:36:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@fromorbit.com, guro@fb.com,
        hannes@cmpxchg.org, ktkhai@virtuozzo.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 064/143] mm: vmscan: use shrinker_rwsem to protect
 shrinker_maps allocation
Message-ID: <20210505013614.KkXqL1afR%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: vmscan: use shrinker_rwsem to protect shrinker_maps allocation

Since memcg_shrinker_map_size just can be changed under holding
shrinker_rwsem exclusively, the read side can be protected by holding read
lock, so it sounds superfluous to have a dedicated mutex.

Kirill Tkhai suggested use write lock since:

  * We want the assignment to shrinker_maps is visible for shrink_slab_memcg().
  * The rcu_dereference_protected() dereferrencing in shrink_slab_memcg(), but
    in case of we use READ lock in alloc_shrinker_maps(), the dereferrencing
    is not actually protected.
  * READ lock makes alloc_shrinker_info() racy against memory allocation fail.
    alloc_shrinker_info()->free_shrinker_info() may free memory right after
    shrink_slab_memcg() dereferenced it. You may say
    shrink_slab_memcg()->mem_cgroup_online() protects us from it? Yes, sure,
    but this is not the thing we want to remember in the future, since this
    spreads modularity.

And a test with heavy paging workload didn't show write lock makes things worse.

Link: https://lkml.kernel.org/r/20210311190845.9708-4-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-use-shrinker_rwsem-to-protect-shrinker_maps-allocation
+++ a/mm/vmscan.c
@@ -187,7 +187,6 @@ static DECLARE_RWSEM(shrinker_rwsem);
 #ifdef CONFIG_MEMCG
 
 static int memcg_shrinker_map_size;
-static DEFINE_MUTEX(memcg_shrinker_map_mutex);
 
 static void free_shrinker_map_rcu(struct rcu_head *head)
 {
@@ -201,8 +200,6 @@ static int expand_one_shrinker_map(struc
 	struct mem_cgroup_per_node *pn;
 	int nid;
 
-	lockdep_assert_held(&memcg_shrinker_map_mutex);
-
 	for_each_node(nid) {
 		pn = memcg->nodeinfo[nid];
 		old = rcu_dereference_protected(pn->shrinker_map, true);
@@ -250,7 +247,7 @@ int alloc_shrinker_maps(struct mem_cgrou
 	if (mem_cgroup_is_root(memcg))
 		return 0;
 
-	mutex_lock(&memcg_shrinker_map_mutex);
+	down_write(&shrinker_rwsem);
 	size = memcg_shrinker_map_size;
 	for_each_node(nid) {
 		map = kvzalloc_node(sizeof(*map) + size, GFP_KERNEL, nid);
@@ -261,7 +258,7 @@ int alloc_shrinker_maps(struct mem_cgrou
 		}
 		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_map, map);
 	}
-	mutex_unlock(&memcg_shrinker_map_mutex);
+	up_write(&shrinker_rwsem);
 
 	return ret;
 }
@@ -276,9 +273,10 @@ static int expand_shrinker_maps(int new_
 	if (size <= old_size)
 		return 0;
 
-	mutex_lock(&memcg_shrinker_map_mutex);
 	if (!root_mem_cgroup)
-		goto unlock;
+		goto out;
+
+	lockdep_assert_held(&shrinker_rwsem);
 
 	memcg = mem_cgroup_iter(NULL, NULL, NULL);
 	do {
@@ -287,13 +285,13 @@ static int expand_shrinker_maps(int new_
 		ret = expand_one_shrinker_map(memcg, size, old_size);
 		if (ret) {
 			mem_cgroup_iter_break(NULL, memcg);
-			goto unlock;
+			goto out;
 		}
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
-unlock:
+out:
 	if (!ret)
 		memcg_shrinker_map_size = size;
-	mutex_unlock(&memcg_shrinker_map_mutex);
+
 	return ret;
 }
 
_
