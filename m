Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0865EC433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9F3861421
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhEHWm3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:42:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWm1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:42:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 957FC6141E;
        Sat,  8 May 2021 22:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513684;
        bh=EKSyt5+POPPGNUs05FtHdMaPUiYDofNiUlD1S4l1ZBg=;
        h=Date:From:To:Subject:From;
        b=nah7F0h56scOAmPSO39etO1VNN3e4RoP7mrgZFfWmoNN3YaF9tso3fNlBdVX5/2RI
         RTJ3veEnVrpDzxx7ghDKrW/coSrcaj8ia62Z+gflIlZi76q3iJdI8LXT8jJxGPk93J
         sK5kcdnh6tmhuMgoLlrYP4sK5rG3/yPxgGeH/Uv8=
Date:   Sat, 08 May 2021 15:41:24 -0700
From:   akpm@linux-foundation.org
To:     duanxiongchun@bytedance.com, guro@fb.com, hannes@cmpxchg.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, vdavydov.dev@gmail.com
Subject:  [merged]
 mm-memcontrol-introduce-obj_cgroup_uncharge_pages.patch removed from -mm
 tree
Message-ID: <20210508224124.zSK7kbVsN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: memcontrol: introduce obj_cgroup_{un}charge_pages
has been removed from the -mm tree.  Its filename was
     mm-memcontrol-introduce-obj_cgroup_uncharge_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: introduce obj_cgroup_{un}charge_pages

We know that the unit of slab object charging is bytes, the unit of kmem
page charging is PAGE_SIZE.  If we want to reuse obj_cgroup APIs to charge
the kmem pages, we should pass PAGE_SIZE (as third parameter) to
obj_cgroup_charge().  Because the size is already PAGE_SIZE, we can skip
touch the objcg stock.  And obj_cgroup_{un}charge_pages() are introduced
to charge in units of page level.

In the latter patch, we also can reuse those two helpers to charge or
uncharge a number of kernel pages to a object cgroup.  This is just a code
movement without any functional changes.

Link: https://lkml.kernel.org/r/20210319163821.20704-3-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   63 +++++++++++++++++++++++++++++-----------------
 1 file changed, 40 insertions(+), 23 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-introduce-obj_cgroup_uncharge_pages
+++ a/mm/memcontrol.c
@@ -2874,6 +2874,20 @@ static void commit_charge(struct page *p
 	page->memcg_data = (unsigned long)memcg;
 }
 
+static struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *objcg)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+retry:
+	memcg = obj_cgroup_memcg(objcg);
+	if (unlikely(!css_tryget(&memcg->css)))
+		goto retry;
+	rcu_read_unlock();
+
+	return memcg;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 int memcg_alloc_page_obj_cgroups(struct page *page, struct kmem_cache *s,
 				 gfp_t gfp, bool new_page)
@@ -3025,6 +3039,29 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
+static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
+				      unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	__memcg_kmem_uncharge(memcg, nr_pages);
+	css_put(&memcg->css);
+}
+
+static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
+				   unsigned int nr_pages)
+{
+	struct mem_cgroup *memcg;
+	int ret;
+
+	memcg = get_mem_cgroup_from_objcg(objcg);
+	ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
+	css_put(&memcg->css);
+
+	return ret;
+}
+
 /**
  * __memcg_kmem_charge: charge a number of kernel pages to a memcg
  * @memcg: memory cgroup to charge
@@ -3149,19 +3186,8 @@ static void drain_obj_stock(struct memcg
 		unsigned int nr_pages = stock->nr_bytes >> PAGE_SHIFT;
 		unsigned int nr_bytes = stock->nr_bytes & (PAGE_SIZE - 1);
 
-		if (nr_pages) {
-			struct mem_cgroup *memcg;
-
-			rcu_read_lock();
-retry:
-			memcg = obj_cgroup_memcg(old);
-			if (unlikely(!css_tryget(&memcg->css)))
-				goto retry;
-			rcu_read_unlock();
-
-			__memcg_kmem_uncharge(memcg, nr_pages);
-			css_put(&memcg->css);
-		}
+		if (nr_pages)
+			obj_cgroup_uncharge_pages(old, nr_pages);
 
 		/*
 		 * The leftover is flushed to the centralized per-memcg value.
@@ -3219,7 +3245,6 @@ static void refill_obj_stock(struct obj_
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
 {
-	struct mem_cgroup *memcg;
 	unsigned int nr_pages, nr_bytes;
 	int ret;
 
@@ -3236,24 +3261,16 @@ int obj_cgroup_charge(struct obj_cgroup
 	 * refill_obj_stock(), called from this function or
 	 * independently later.
 	 */
-	rcu_read_lock();
-retry:
-	memcg = obj_cgroup_memcg(objcg);
-	if (unlikely(!css_tryget(&memcg->css)))
-		goto retry;
-	rcu_read_unlock();
-
 	nr_pages = size >> PAGE_SHIFT;
 	nr_bytes = size & (PAGE_SIZE - 1);
 
 	if (nr_bytes)
 		nr_pages += 1;
 
-	ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
+	ret = obj_cgroup_charge_pages(objcg, gfp, nr_pages);
 	if (!ret && nr_bytes)
 		refill_obj_stock(objcg, PAGE_SIZE - nr_bytes);
 
-	css_put(&memcg->css);
 	return ret;
 }
 
_

Patches currently in -mm which might be from songmuchun@bytedance.com are


