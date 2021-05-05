Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9156DC433ED
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7740A6141D
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhEEBhO (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:37:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhEEBhN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:37:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DABD26141F;
        Wed,  5 May 2021 01:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178578;
        bh=gNz9z2hzRJUHkoco3FqhwyWs/FtzhdxzNey88kcQoAI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=lQJklRexGKBcjB5YQYcht8f0Izst/22SV2+cpwKAjmQetxvkj0BgQOvvhn+8aEA3d
         o9BdFFiajcbR7OsCYkinuORkfeQ9H2VxheobyeUX/lBojkeQoEtOsLIX5kgi32tqwO
         67hy4t0PBqpaIe/Ltr/JbJrS54Vh06jGz4vcK9VE=
Date:   Tue, 04 May 2021 18:36:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@fromorbit.com, guro@fb.com,
        hannes@cmpxchg.org, ktkhai@virtuozzo.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 065/143] mm: vmscan: remove
 memcg_shrinker_map_size
Message-ID: <20210505013617.RorkZ6DiV%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
