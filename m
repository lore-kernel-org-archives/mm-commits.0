Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FE5C433ED
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 07BE76147E
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:56:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbhD3F5p (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:57:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230291AbhD3F5n (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:57:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C70A61463;
        Fri, 30 Apr 2021 05:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619762216;
        bh=5NfjOYfSItV4MAsmcJR1+duM4vXDPGy8mv3ZUJGMiaU=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=iKz29DjDtE8NYzOcA15NxpLCcZl277mteBAKgeod5rqYb8XH/zESehrly8xAYfVRS
         4QQHtEhOODqJJbs1238FCEUMsvaG+do5XI64o8zcN1BFLSxslQTOtm/qDznUxZsWTh
         Xukxr7bO0JjzG8mOjuL+tH3RBtRiJr4YwU2xOLzc=
Date:   Thu, 29 Apr 2021 22:56:55 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, duanxiongchun@bytedance.com,
        guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@kernel.org, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 073/178] mm: memcontrol: inline
 __memcg_kmem_{un}charge() into obj_cgroup_{un}charge_pages()
Message-ID: <20210430055655.WnASKt8h6%akpm@linux-foundation.org>
In-Reply-To: <20210429225251.02b6386d21b69255b4f6c163@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: inline __memcg_kmem_{un}charge() into obj_cgroup_{un}charge_pages()

There is only one user of __memcg_kmem_charge(), so manually inline
__memcg_kmem_charge() to obj_cgroup_charge_pages().  Similarly manually
inline __memcg_kmem_uncharge() into obj_cgroup_uncharge_pages() and call
obj_cgroup_uncharge_pages() in obj_cgroup_release().

This is just code cleanup without any functionality changes.

Link: https://lkml.kernel.org/r/20210319163821.20704-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   63 ++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 38 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-inline-__memcg_kmem_uncharge-into-obj_cgroup_uncharge_pages
+++ a/mm/memcontrol.c
@@ -255,10 +255,8 @@ struct cgroup_subsys_state *vmpressure_t
 #ifdef CONFIG_MEMCG_KMEM
 extern spinlock_t css_set_lock;
 
-static int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
-			       unsigned int nr_pages);
-static void __memcg_kmem_uncharge(struct mem_cgroup *memcg,
-				  unsigned int nr_pages);
+static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
+				      unsigned int nr_pages);
 
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
@@ -295,7 +293,7 @@ static void obj_cgroup_release(struct pe
 	spin_lock_irqsave(&css_set_lock, flags);
 	memcg = obj_cgroup_memcg(objcg);
 	if (nr_pages)
-		__memcg_kmem_uncharge(memcg, nr_pages);
+		obj_cgroup_uncharge_pages(objcg, nr_pages);
 	list_del(&objcg->list);
 	mem_cgroup_put(memcg);
 	spin_unlock_irqrestore(&css_set_lock, flags);
@@ -3015,46 +3013,45 @@ static void memcg_free_cache_id(int id)
 	ida_simple_remove(&memcg_cache_ida, id);
 }
 
+/*
+ * obj_cgroup_uncharge_pages: uncharge a number of kernel pages from a objcg
+ * @objcg: object cgroup to uncharge
+ * @nr_pages: number of pages to uncharge
+ */
 static void obj_cgroup_uncharge_pages(struct obj_cgroup *objcg,
 				      unsigned int nr_pages)
 {
 	struct mem_cgroup *memcg;
 
 	memcg = get_mem_cgroup_from_objcg(objcg);
-	__memcg_kmem_uncharge(memcg, nr_pages);
-	css_put(&memcg->css);
-}
 
-static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
-				   unsigned int nr_pages)
-{
-	struct mem_cgroup *memcg;
-	int ret;
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
+		page_counter_uncharge(&memcg->kmem, nr_pages);
+	refill_stock(memcg, nr_pages);
 
-	memcg = get_mem_cgroup_from_objcg(objcg);
-	ret = __memcg_kmem_charge(memcg, gfp, nr_pages);
 	css_put(&memcg->css);
-
-	return ret;
 }
 
-/**
- * __memcg_kmem_charge: charge a number of kernel pages to a memcg
- * @memcg: memory cgroup to charge
+/*
+ * obj_cgroup_charge_pages: charge a number of kernel pages to a objcg
+ * @objcg: object cgroup to charge
  * @gfp: reclaim mode
  * @nr_pages: number of pages to charge
  *
  * Returns 0 on success, an error code on failure.
  */
-static int __memcg_kmem_charge(struct mem_cgroup *memcg, gfp_t gfp,
-			       unsigned int nr_pages)
+static int obj_cgroup_charge_pages(struct obj_cgroup *objcg, gfp_t gfp,
+				   unsigned int nr_pages)
 {
 	struct page_counter *counter;
+	struct mem_cgroup *memcg;
 	int ret;
 
+	memcg = get_mem_cgroup_from_objcg(objcg);
+
 	ret = try_charge(memcg, gfp, nr_pages);
 	if (ret)
-		return ret;
+		goto out;
 
 	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) &&
 	    !page_counter_try_charge(&memcg->kmem, nr_pages, &counter)) {
@@ -3066,25 +3063,15 @@ static int __memcg_kmem_charge(struct me
 		 */
 		if (gfp & __GFP_NOFAIL) {
 			page_counter_charge(&memcg->kmem, nr_pages);
-			return 0;
+			goto out;
 		}
 		cancel_charge(memcg, nr_pages);
-		return -ENOMEM;
+		ret = -ENOMEM;
 	}
-	return 0;
-}
-
-/**
- * __memcg_kmem_uncharge: uncharge a number of kernel pages from a memcg
- * @memcg: memcg to uncharge
- * @nr_pages: number of pages to uncharge
- */
-static void __memcg_kmem_uncharge(struct mem_cgroup *memcg, unsigned int nr_pages)
-{
-	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
-		page_counter_uncharge(&memcg->kmem, nr_pages);
+out:
+	css_put(&memcg->css);
 
-	refill_stock(memcg, nr_pages);
+	return ret;
 }
 
 /**
_
