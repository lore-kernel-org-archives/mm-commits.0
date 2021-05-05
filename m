Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6128DC433B4
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A94E610A1
	for <mm-commits@archiver.kernel.org>; Wed,  5 May 2021 01:36:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhEEBhj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 May 2021 21:37:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:40644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230361AbhEEBhi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 4 May 2021 21:37:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E75CF61421;
        Wed,  5 May 2021 01:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620178603;
        bh=KdW21TT29JCUWs8VGX8Dcco7fRQN4TVx4WI38R3OVLI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=S+BiT14iyrg00Sdk2OvMsbJxvcULD9dCyGYdNKmVHyQRamczclYWNf3NSDUDWBMUm
         I7fA6+LnLzcyBAfD+1YhFvdRDJrSqjV7+6PHuXc2SfQ62mOHGE+bc0nyNL/ihCG7K+
         VwPA3fG27myaVpWpr1siemNGvmaKv8F2NPFWOXgs=
Date:   Tue, 04 May 2021 18:36:42 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@fromorbit.com, guro@fb.com,
        hannes@cmpxchg.org, ktkhai@virtuozzo.com, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        shy828301@gmail.com, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 073/143] mm: memcontrol: reparent nr_deferred when
 memcg offline
Message-ID: <20210505013642.3_19yLOYn%akpm@linux-foundation.org>
In-Reply-To: <20210504183219.a3cc46aee4013d77402276c5@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yang Shi <shy828301@gmail.com>
Subject: mm: memcontrol: reparent nr_deferred when memcg offline

Now shrinker's nr_deferred is per memcg for memcg aware shrinkers, add to
parent's corresponding nr_deferred when memcg offline.

Link: https://lkml.kernel.org/r/20210311190845.9708-13-shy828301@gmail.com
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

 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |    1 +
 mm/vmscan.c                |   24 ++++++++++++++++++++++++
 3 files changed, 26 insertions(+)

--- a/include/linux/memcontrol.h~mm-memcontrol-reparent-nr_deferred-when-memcg-offline
+++ a/include/linux/memcontrol.h
@@ -1614,6 +1614,7 @@ static inline bool mem_cgroup_under_sock
 int alloc_shrinker_info(struct mem_cgroup *memcg);
 void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
+void reparent_shrinker_deferred(struct mem_cgroup *memcg);
 #else
 #define mem_cgroup_sockets_enabled 0
 static inline void mem_cgroup_sk_alloc(struct sock *sk) { };
--- a/mm/memcontrol.c~mm-memcontrol-reparent-nr_deferred-when-memcg-offline
+++ a/mm/memcontrol.c
@@ -5154,6 +5154,7 @@ static void mem_cgroup_css_offline(struc
 	page_counter_set_low(&memcg->memory, 0);
 
 	memcg_offline_kmem(memcg);
+	reparent_shrinker_deferred(memcg);
 	wb_memcg_offline(memcg);
 
 	drain_all_stock(memcg);
--- a/mm/vmscan.c~mm-memcontrol-reparent-nr_deferred-when-memcg-offline
+++ a/mm/vmscan.c
@@ -397,6 +397,30 @@ static long add_nr_deferred_memcg(long n
 	return atomic_long_add_return(nr, &info->nr_deferred[shrinker->id]);
 }
 
+void reparent_shrinker_deferred(struct mem_cgroup *memcg)
+{
+	int i, nid;
+	long nr;
+	struct mem_cgroup *parent;
+	struct shrinker_info *child_info, *parent_info;
+
+	parent = parent_mem_cgroup(memcg);
+	if (!parent)
+		parent = root_mem_cgroup;
+
+	/* Prevent from concurrent shrinker_info expand */
+	down_read(&shrinker_rwsem);
+	for_each_node(nid) {
+		child_info = shrinker_info_protected(memcg, nid);
+		parent_info = shrinker_info_protected(parent, nid);
+		for (i = 0; i < shrinker_nr_max; i++) {
+			nr = atomic_long_read(&child_info->nr_deferred[i]);
+			atomic_long_add(nr, &parent_info->nr_deferred[i]);
+		}
+	}
+	up_read(&shrinker_rwsem);
+}
+
 static bool cgroup_reclaim(struct scan_control *sc)
 {
 	return sc->target_mem_cgroup;
_
