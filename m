Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BAC3C4332F
	for <mm-commits@archiver.kernel.org>; Tue, 22 Mar 2022 21:41:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236005AbiCVVnL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Mar 2022 17:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236207AbiCVVm6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Mar 2022 17:42:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2325EBE5
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 14:41:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED34D61179
        for <mm-commits@vger.kernel.org>; Tue, 22 Mar 2022 21:41:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431F9C340EC;
        Tue, 22 Mar 2022 21:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1647985289;
        bh=Q8K3zCzmlXsZoH+fkhRGs2h/kdfXjuXuiDO9aNZLWSQ=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=Cxup5RnnUU81jFJJzQQVdnBWZUoy+u9tI/1W70ikMUO+89XWGyXMNaL7G7+gaYcBe
         FcZIXKeuwf0Y7NT1c76gD5fU9qhOLc92F5xozpze/6pGmZW/qALGJguA9in6NGWAJY
         dLNcTJK5i5XeKnon3S6MQfcO6Wr8aHn/UgBVvytg=
Date:   Tue, 22 Mar 2022 14:41:28 -0700
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
Subject: [patch 058/227] mm: memcontrol: reuse memory cgroup ID for kmem ID
Message-Id: <20220322214129.431F9C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: reuse memory cgroup ID for kmem ID

There are two idrs being used by memory cgroup, one is for kmem ID,
another is for memory cgroup ID.  The maximum ID of both is 64Ki.  Both of
them can limit the total number of memory cgroups.  Actually, we can reuse
memory cgroup ID for kmem ID to simplify the code.

Link: https://lkml.kernel.org/r/20220228122126.37293-14-songmuchun@bytedance.com
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

 mm/memcontrol.c |   39 +++------------------------------------
 1 file changed, 3 insertions(+), 36 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-reuse-memory-cgroup-id-for-kmem-id
+++ a/mm/memcontrol.c
@@ -348,23 +348,6 @@ static void memcg_reparent_objcgs(struct
 }
 
 /*
- * This will be used as a shrinker list's index.
- * The main reason for not using cgroup id for this:
- *  this works better in sparse environments, where we have a lot of memcgs,
- *  but only a few kmem-limited.
- */
-static DEFINE_IDA(memcg_cache_ida);
-
-/*
- * MAX_SIZE should be as large as the number of cgrp_ids. Ideally, we could get
- * this constant directly from cgroup, but it is understandable that this is
- * better kept as an internal representation in cgroup.c. In any case, the
- * cgrp_id space is not getting any smaller, and we don't have to necessarily
- * increase ours as well if it increases.
- */
-#define MEMCG_CACHES_MAX_SIZE MEM_CGROUP_ID_MAX
-
-/*
  * A lot of the calls to the cache allocation functions are expected to be
  * inlined by the compiler. Since the calls to memcg_slab_pre_alloc_hook() are
  * conditional to this static branch, we'll have to allow modules that does
@@ -3597,7 +3580,6 @@ static u64 mem_cgroup_read_u64(struct cg
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
 	struct obj_cgroup *objcg;
-	int memcg_id;
 
 	if (cgroup_memory_nokmem)
 		return 0;
@@ -3605,22 +3587,16 @@ static int memcg_online_kmem(struct mem_
 	if (unlikely(mem_cgroup_is_root(memcg)))
 		return 0;
 
-	memcg_id = ida_alloc_max(&memcg_cache_ida, MEMCG_CACHES_MAX_SIZE - 1,
-				 GFP_KERNEL);
-	if (memcg_id < 0)
-		return memcg_id;
-
 	objcg = obj_cgroup_alloc();
-	if (!objcg) {
-		ida_free(&memcg_cache_ida, memcg_id);
+	if (!objcg)
 		return -ENOMEM;
-	}
+
 	objcg->memcg = memcg;
 	rcu_assign_pointer(memcg->objcg, objcg);
 
 	static_branch_enable(&memcg_kmem_enabled_key);
 
-	memcg->kmemcg_id = memcg_id;
+	memcg->kmemcg_id = memcg->id.id;
 
 	return 0;
 }
@@ -3628,7 +3604,6 @@ static int memcg_online_kmem(struct mem_
 static void memcg_offline_kmem(struct mem_cgroup *memcg)
 {
 	struct mem_cgroup *parent;
-	int kmemcg_id;
 
 	if (cgroup_memory_nokmem)
 		return;
@@ -3643,20 +3618,12 @@ static void memcg_offline_kmem(struct me
 	memcg_reparent_objcgs(memcg, parent);
 
 	/*
-	 * memcg_reparent_list_lrus() can change memcg->kmemcg_id.
-	 * Cache it to local @kmemcg_id.
-	 */
-	kmemcg_id = memcg->kmemcg_id;
-
-	/*
 	 * After we have finished memcg_reparent_objcgs(), all list_lrus
 	 * corresponding to this cgroup are guaranteed to remain empty.
 	 * The ordering is imposed by list_lru_node->lock taken by
 	 * memcg_reparent_list_lrus().
 	 */
 	memcg_reparent_list_lrus(memcg, parent);
-
-	ida_free(&memcg_cache_ida, kmemcg_id);
 }
 #else
 static int memcg_online_kmem(struct mem_cgroup *memcg)
_
