Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE078C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2A51613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhEHWtd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229631AbhEHWtb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 952806100C;
        Sat,  8 May 2021 22:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514109;
        bh=dtll9exFoFII18rM+DTvGm39znahUELEBEyubcAOQmQ=;
        h=Date:From:To:Subject:From;
        b=z2/AEZFUS4OgSdF3w5GmT3czMrWYFT7NZpImAXe0ZK05ZAmA+M6So7zzBabnS/CBC
         478Q3rue/Bh2+8sRM65WC1zHb9OUcqqsfQp9M6uSHXBV/7fdpETEMkMvYryevJyrJS
         gJgvjAR+UGyW1Qhm/RCVxQda+wnNbK8kiZMgy9HA=
Date:   Sat, 08 May 2021 15:48:29 -0700
From:   akpm@linux-foundation.org
To:     david@fromorbit.com, guro@fb.com, hannes@cmpxchg.org,
        ktkhai@virtuozzo.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com, shy828301@gmail.com, vbabka@suse.cz
Subject:  [merged] mm-vmscan-remove-memcg_shrinker_map_size.patch
 removed from -mm tree
Message-ID: <20210508224829.82DWC4Czn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: vmscan: remove memcg_shrinker_map_size
has been removed from the -mm tree.  Its filename was
     mm-vmscan-remove-memcg_shrinker_map_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: vmscan: remove memcg_shrinker_map_size

Both memcg_shrinker_map_size and shrinker_nr_max is maintained, but
actually the map size can be calculated via shrinker_nr_max, so it seems
unnecessary to keep both.  Remove memcg_shrinker_map_size since
shrinker_nr_max is also used by iterating the bit map.

Link: https://lkml.kernel.org/r/20210311190845.9708-5-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Acked-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/mm/vmscan.c~mm-vmscan-remove-memcg_shrinker_map_size
+++ a/mm/vmscan.c
@@ -185,8 +185,12 @@ static LIST_HEAD(shrinker_list);
 static DECLARE_RWSEM(shrinker_rwsem);
 
 #ifdef CONFIG_MEMCG
+static int shrinker_nr_max;
 
-static int memcg_shrinker_map_size;
+static inline int shrinker_map_size(int nr_items)
+{
+	return (DIV_ROUND_UP(nr_items, BITS_PER_LONG) * sizeof(unsigned long));
+}
 
 static void free_shrinker_map_rcu(struct rcu_head *head)
 {
@@ -248,7 +252,7 @@ int alloc_shrinker_maps(struct mem_cgrou
 		return 0;
 
 	down_write(&shrinker_rwsem);
-	size = memcg_shrinker_map_size;
+	size = shrinker_map_size(shrinker_nr_max);
 	for_each_node(nid) {
 		map = kvzalloc_node(sizeof(*map) + size, GFP_KERNEL, nid);
 		if (!map) {
@@ -266,12 +270,13 @@ int alloc_shrinker_maps(struct mem_cgrou
 static int expand_shrinker_maps(int new_id)
 {
 	int size, old_size, ret = 0;
+	int new_nr_max = new_id + 1;
 	struct mem_cgroup *memcg;
 
-	size = DIV_ROUND_UP(new_id + 1, BITS_PER_LONG) * sizeof(unsigned long);
-	old_size = memcg_shrinker_map_size;
+	size = shrinker_map_size(new_nr_max);
+	old_size = shrinker_map_size(shrinker_nr_max);
 	if (size <= old_size)
-		return 0;
+		goto out;
 
 	if (!root_mem_cgroup)
 		goto out;
@@ -290,7 +295,7 @@ static int expand_shrinker_maps(int new_
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
 out:
 	if (!ret)
-		memcg_shrinker_map_size = size;
+		shrinker_nr_max = new_nr_max;
 
 	return ret;
 }
@@ -323,7 +328,6 @@ void set_shrinker_bit(struct mem_cgroup
 #define SHRINKER_REGISTERING ((struct shrinker *)~0UL)
 
 static DEFINE_IDR(shrinker_idr);
-static int shrinker_nr_max;
 
 static int prealloc_memcg_shrinker(struct shrinker *shrinker)
 {
@@ -340,8 +344,6 @@ static int prealloc_memcg_shrinker(struc
 			idr_remove(&shrinker_idr, id);
 			goto unlock;
 		}
-
-		shrinker_nr_max = id + 1;
 	}
 	shrinker->id = id;
 	ret = 0;
_

Patches currently in -mm which might be from shy828301@gmail.com are


