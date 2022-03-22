Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E235FC43219
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbiCVVnJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:43:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236169AbiCVVmz (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:42:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB4C5EBE5
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:41:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60292B81DB7
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BF3C340EC;
        Tue, 22 Mar 2022 21:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985283;
        bh=QnUfLlF3aSdOdedL6HMjuLKYUMOSSkGo8W9FW82MmUE=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=AxxLuPYD2rUdP6eyYYER7Wdk3CdeltJCimEIIDfi1YYTKcFtNrSexidqGC0vvvmju
         2L63YrF694LCPK9wYTscQxZQPOqCoPZzpLCJu80BqaEWo7vNxQ9U9IrAWiHT0JAwXg
         wQlq1s8OtshhwdnBADnK9Ft8bAtpzo3ywUzq1RdY=
Date:   Tue, 22 Mar 2022 14:41:22 -0700
To:     zhengqi.arch@bytedance.com, willy@infradead.org,
        vdavydov.dev@gmail.com, vbabka@suse.cz, tytso@mit.edu,
        trond.myklebust@hammerspace.com, shy828301@gmail.com,
        shakeelb@google.com, roman.gushchin@linux.dev,
        richard.weiyang@gmail.com, mhocko@kernel.org,
        kari.argillander@gmail.com, jaegeuk@kernel.org, hannes@cmpxchg.org,
        fam.zheng@bytedance.com, duanxiongchun@bytedance.com,
        david@fromorbit.com, chao@kernel.org, Anna.Schumaker@Netapp.com,
        alexs@kernel.org, songmuchun@bytedance.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 056/227] mm: list_lru: rename memcg_drain_all_list_lrus to memcg_reparent_list_lrus
Message-Id: <20220322214122.E8BF3C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: list_lru: rename memcg_drain_all_list_lrus to memcg_reparent_list_lrus

The purpose of the memcg_drain_all_list_lrus() is list_lrus reparenting. 
It is very similar to memcg_reparent_objcgs().  Rename it to
memcg_reparent_list_lrus() so that the name can more consistent with
memcg_reparent_objcgs().

Link: https://lkml.kernel.org/r/20220228122126.37293-12-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Cc: Alex Shi <alexs@kernel.org>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Fam Zheng <fam.zheng@bytedance.com>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kari Argillander <kari.argillander@gmail.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |    2 +-
 mm/list_lru.c            |   24 ++++++++++++------------
 mm/memcontrol.c          |    6 +++---
 3 files changed, 16 insertions(+), 16 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-rename-memcg_drain_all_list_lrus-to-memcg_reparent_list_lrus
+++ a/include/linux/list_lru.h
@@ -78,7 +78,7 @@ int __list_lru_init(struct list_lru *lru
 int memcg_list_lru_alloc(struct mem_cgroup *memcg, struct list_lru *lru,
 			 gfp_t gfp);
 int memcg_update_all_list_lrus(int num_memcgs);
-void memcg_drain_all_list_lrus(struct mem_cgroup *src, struct mem_cgroup *dst);
+void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent);
 
 /**
  * list_lru_add: add an element to the lru list's tail
--- a/mm/list_lru.c~mm-list_lru-rename-memcg_drain_all_list_lrus-to-memcg_reparent_list_lrus
+++ a/mm/list_lru.c
@@ -457,8 +457,8 @@ int memcg_update_all_list_lrus(int new_s
 	return ret;
 }
 
-static void memcg_drain_list_lru_node(struct list_lru *lru, int nid,
-				      int src_idx, struct mem_cgroup *dst_memcg)
+static void memcg_reparent_list_lru_node(struct list_lru *lru, int nid,
+					 int src_idx, struct mem_cgroup *dst_memcg)
 {
 	struct list_lru_node *nlru = &lru->node[nid];
 	int dst_idx = dst_memcg->kmemcg_id;
@@ -486,22 +486,22 @@ out:
 	spin_unlock_irq(&nlru->lock);
 }
 
-static void memcg_drain_list_lru(struct list_lru *lru,
-				 int src_idx, struct mem_cgroup *dst_memcg)
+static void memcg_reparent_list_lru(struct list_lru *lru,
+				    int src_idx, struct mem_cgroup *dst_memcg)
 {
 	int i;
 
 	for_each_node(i)
-		memcg_drain_list_lru_node(lru, i, src_idx, dst_memcg);
+		memcg_reparent_list_lru_node(lru, i, src_idx, dst_memcg);
 
 	memcg_list_lru_free(lru, src_idx);
 }
 
-void memcg_drain_all_list_lrus(struct mem_cgroup *src, struct mem_cgroup *dst)
+void memcg_reparent_list_lrus(struct mem_cgroup *memcg, struct mem_cgroup *parent)
 {
 	struct cgroup_subsys_state *css;
 	struct list_lru *lru;
-	int src_idx = src->kmemcg_id;
+	int src_idx = memcg->kmemcg_id;
 
 	/*
 	 * Change kmemcg_id of this cgroup and all its descendants to the
@@ -517,17 +517,17 @@ void memcg_drain_all_list_lrus(struct me
 	 * call.
 	 */
 	rcu_read_lock();
-	css_for_each_descendant_pre(css, &src->css) {
-		struct mem_cgroup *memcg;
+	css_for_each_descendant_pre(css, &memcg->css) {
+		struct mem_cgroup *child;
 
-		memcg = mem_cgroup_from_css(css);
-		memcg->kmemcg_id = dst->kmemcg_id;
+		child = mem_cgroup_from_css(css);
+		child->kmemcg_id = parent->kmemcg_id;
 	}
 	rcu_read_unlock();
 
 	mutex_lock(&list_lrus_mutex);
 	list_for_each_entry(lru, &memcg_list_lrus, list)
-		memcg_drain_list_lru(lru, src_idx, dst);
+		memcg_reparent_list_lru(lru, src_idx, parent);
 	mutex_unlock(&list_lrus_mutex);
 }
 
--- a/mm/memcontrol.c~mm-list_lru-rename-memcg_drain_all_list_lrus-to-memcg_reparent_list_lrus
+++ a/mm/memcontrol.c
@@ -3710,7 +3710,7 @@ static void memcg_offline_kmem(struct me
 	memcg_reparent_objcgs(memcg, parent);
 
 	/*
-	 * memcg_drain_all_list_lrus() can change memcg->kmemcg_id.
+	 * memcg_reparent_list_lrus() can change memcg->kmemcg_id.
 	 * Cache it to local @kmemcg_id.
 	 */
 	kmemcg_id = memcg->kmemcg_id;
@@ -3719,9 +3719,9 @@ static void memcg_offline_kmem(struct me
 	 * After we have finished memcg_reparent_objcgs(), all list_lrus
 	 * corresponding to this cgroup are guaranteed to remain empty.
 	 * The ordering is imposed by list_lru_node->lock taken by
-	 * memcg_drain_all_list_lrus().
+	 * memcg_reparent_list_lrus().
 	 */
-	memcg_drain_all_list_lrus(memcg, parent);
+	memcg_reparent_list_lrus(memcg, parent);
 
 	memcg_free_cache_id(kmemcg_id);
 }
_
