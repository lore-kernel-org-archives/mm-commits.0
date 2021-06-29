Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0150C11F64
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD6F561D07
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231682AbhF2Cka (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:40:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:32950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhF2Cka (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:40:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 685BA61D04;
        Tue, 29 Jun 2021 02:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934283;
        bh=N3haBBzWkQNuEOaEtNGYN2d3zDMqfoK5HvKbOnXH3Pc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Qlj/muaGildoMi00SSb4lazbLaw24Tf5U9L8rd18gepZN2eaWeaE/NNwF0NbtI+z4
         HLp2B3vEjt5F6moW6kxeJwNB0FEClfGNOvD4pUahwc3nihZsm9kZl5apfIVd9f7+7R
         YvKdksPLh1zGohpl/JM79x8KIJjAPHxkOCbaKmB8=
Date:   Mon, 28 Jun 2021 19:38:03 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, duanxiongchun@bytedance.com,
        guro@fb.com, hannes@cmpxchg.org, linux-mm@kvack.org,
        mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com,
        songmuchun@bytedance.com, torvalds@linux-foundation.org,
        vdavydov.dev@gmail.com
Subject:  [patch 090/192] mm: memcontrol: simplify the logic of
 objcg pinning memcg
Message-ID: <20210629023803.yWrgqzH02%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>
Subject: mm: memcontrol: simplify the logic of objcg pinning memcg

The obj_cgroup_release() and memcg_reparent_objcgs() are serialized by the
css_set_lock.  We do not need to care about objcg->memcg being released in
the process of obj_cgroup_release().  So there is no need to pin memcg
before releasing objcg.  Remove those pinning logic to simplfy the code.

There are only two places that modifies the objcg->memcg.  One is the
initialization to objcg->memcg in the memcg_online_kmem(), another is
objcgs reparenting in the memcg_reparent_objcgs().  It is also impossible
for the two to run in parallel.  So xchg() is unnecessary and it is enough
to use WRITE_ONCE().

Link: https://lkml.kernel.org/r/20210417043538.9793-7-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Xiongchun Duan <duanxiongchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/mm/memcontrol.c~mm-memcontrol-simplify-the-logic-of-objcg-pinning-memcg
+++ a/mm/memcontrol.c
@@ -261,7 +261,6 @@ static void obj_cgroup_uncharge_pages(st
 static void obj_cgroup_release(struct percpu_ref *ref)
 {
 	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
-	struct mem_cgroup *memcg;
 	unsigned int nr_bytes;
 	unsigned int nr_pages;
 	unsigned long flags;
@@ -291,11 +290,9 @@ static void obj_cgroup_release(struct pe
 	nr_pages = nr_bytes >> PAGE_SHIFT;
 
 	spin_lock_irqsave(&css_set_lock, flags);
-	memcg = obj_cgroup_memcg(objcg);
 	if (nr_pages)
 		obj_cgroup_uncharge_pages(objcg, nr_pages);
 	list_del(&objcg->list);
-	mem_cgroup_put(memcg);
 	spin_unlock_irqrestore(&css_set_lock, flags);
 
 	percpu_ref_exit(ref);
@@ -330,17 +327,12 @@ static void memcg_reparent_objcgs(struct
 
 	spin_lock_irq(&css_set_lock);
 
-	/* Move active objcg to the parent's list */
-	xchg(&objcg->memcg, parent);
-	css_get(&parent->css);
-	list_add(&objcg->list, &parent->objcg_list);
-
-	/* Move already reparented objcgs to the parent's list */
-	list_for_each_entry(iter, &memcg->objcg_list, list) {
-		css_get(&parent->css);
-		xchg(&iter->memcg, parent);
-		css_put(&memcg->css);
-	}
+	/* 1) Ready to reparent active objcg. */
+	list_add(&objcg->list, &memcg->objcg_list);
+	/* 2) Reparent active objcg and already reparented objcgs to parent. */
+	list_for_each_entry(iter, &memcg->objcg_list, list)
+		WRITE_ONCE(iter->memcg, parent);
+	/* 3) Move already reparented objcgs to the parent's list */
 	list_splice(&memcg->objcg_list, &parent->objcg_list);
 
 	spin_unlock_irq(&css_set_lock);
_
