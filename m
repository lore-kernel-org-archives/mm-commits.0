Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A564EC11F66
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D3D261D0A
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhF2Cj5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:39:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231750AbhF2Cjy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:39:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7734A61D04;
        Tue, 29 Jun 2021 02:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934248;
        bh=BQgZGy6iznnnUTsaOT3qPGLaSbg7oHX5C6wD7wONZkc=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=pOfqkvJa64hSzuNyhSecMbyD2PPqzmgSC+h62q4W4yXbPeVDp9Ka6ZdLPoitclefz
         8BZzmnJ0a8nvz7cZrU89GMibBItH5gQMq2FUfIO4Xi0pTg5agDM25V+iD/dkSlxYV5
         4JaNmiZvxLz76mQX9l9L91itnKirGSzmE95rZ15Y=
Date:   Mon, 28 Jun 2021 19:37:27 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, alex.shi@linux.alibaba.com,
        chris@chrisdown.name, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, iamjoonsoo.kim@lge.com, laoar.shao@gmail.com,
        linux-mm@kvack.org, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, msys.mizuma@gmail.com,
        penberg@kernel.org, richard.weiyang@gmail.com, rientjes@google.com,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz,
        vdavydov.dev@gmail.com, willy@infradead.org,
        zhengjun.xing@linux.intel.com
Subject:  [patch 079/192] mm/memcg: improve refill_obj_stock()
 performance
Message-ID: <20210629023727.p94gdt1Do%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Waiman Long <longman@redhat.com>
Subject: mm/memcg: improve refill_obj_stock() performance

There are two issues with the current refill_obj_stock() code.  First of
all, when nr_bytes reaches over PAGE_SIZE, it calls drain_obj_stock() to
atomically flush out remaining bytes to obj_cgroup, clear cached_objcg and
do a obj_cgroup_put().  It is likely that the same obj_cgroup will be used
again which leads to another call to drain_obj_stock() and
obj_cgroup_get() as well as atomically retrieve the available byte from
obj_cgroup.  That is costly.  Instead, we should just uncharge the excess
pages, reduce the stock bytes and be done with it.  The drain_obj_stock()
function should only be called when obj_cgroup changes.

Secondly, when charging an object of size not less than a page in
obj_cgroup_charge(), it is possible that the remaining bytes to be
refilled to the stock will overflow a page and cause refill_obj_stock() to
uncharge 1 page.  To avoid the additional uncharge in this case, a new
allow_uncharge flag is added to refill_obj_stock() which will be set to
false when called from obj_cgroup_charge() so that an uncharge_pages()
call won't be issued right after a charge_pages() call unless the objcg
changes.

A multithreaded kmalloc+kfree microbenchmark on a 2-socket 48-core
96-thread x86-64 system with 96 testing threads were run.  Before this
patch, the total number of kilo kmalloc+kfree operations done for a 4k
large object by all the testing threads per second were 4,304 kops/s
(cgroup v1) and 8,478 kops/s (cgroup v2).  After applying this patch, the
number were 4,731 (cgroup v1) and 418,142 (cgroup v2) respectively.  This
represents a performance improvement of 1.10X (cgroup v1) and 49.3X
(cgroup v2).

Link: https://lkml.kernel.org/r/20210506150007.16288-4-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Chris Down <chris@chrisdown.name>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Xing Zhengjun <zhengjun.xing@linux.intel.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   48 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 35 insertions(+), 13 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-improve-refill_obj_stock-performance
+++ a/mm/memcontrol.c
@@ -3157,10 +3157,12 @@ static bool obj_stock_flush_required(str
 	return false;
 }
 
-static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
+static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
+			     bool allow_uncharge)
 {
 	struct memcg_stock_pcp *stock;
 	unsigned long flags;
+	unsigned int nr_pages = 0;
 
 	local_irq_save(flags);
 
@@ -3169,14 +3171,21 @@ static void refill_obj_stock(struct obj_
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->cached_objcg = objcg;
-		stock->nr_bytes = atomic_xchg(&objcg->nr_charged_bytes, 0);
+		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
+				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
+		allow_uncharge = true;	/* Allow uncharge when objcg changes */
 	}
 	stock->nr_bytes += nr_bytes;
 
-	if (stock->nr_bytes > PAGE_SIZE)
-		drain_obj_stock(stock);
+	if (allow_uncharge && (stock->nr_bytes > PAGE_SIZE)) {
+		nr_pages = stock->nr_bytes >> PAGE_SHIFT;
+		stock->nr_bytes &= (PAGE_SIZE - 1);
+	}
 
 	local_irq_restore(flags);
+
+	if (nr_pages)
+		obj_cgroup_uncharge_pages(objcg, nr_pages);
 }
 
 int obj_cgroup_charge(struct obj_cgroup *objcg, gfp_t gfp, size_t size)
@@ -3188,14 +3197,27 @@ int obj_cgroup_charge(struct obj_cgroup
 		return 0;
 
 	/*
-	 * In theory, memcg->nr_charged_bytes can have enough
+	 * In theory, objcg->nr_charged_bytes can have enough
 	 * pre-charged bytes to satisfy the allocation. However,
-	 * flushing memcg->nr_charged_bytes requires two atomic
-	 * operations, and memcg->nr_charged_bytes can't be big,
-	 * so it's better to ignore it and try grab some new pages.
-	 * memcg->nr_charged_bytes will be flushed in
-	 * refill_obj_stock(), called from this function or
-	 * independently later.
+	 * flushing objcg->nr_charged_bytes requires two atomic
+	 * operations, and objcg->nr_charged_bytes can't be big.
+	 * The shared objcg->nr_charged_bytes can also become a
+	 * performance bottleneck if all tasks of the same memcg are
+	 * trying to update it. So it's better to ignore it and try
+	 * grab some new pages. The stock's nr_bytes will be flushed to
+	 * objcg->nr_charged_bytes later on when objcg changes.
+	 *
+	 * The stock's nr_bytes may contain enough pre-charged bytes
+	 * to allow one less page from being charged, but we can't rely
+	 * on the pre-charged bytes not being changed outside of
+	 * consume_obj_stock() or refill_obj_stock(). So ignore those
+	 * pre-charged bytes as well when charging pages. To avoid a
+	 * page uncharge right after a page charge, we set the
+	 * allow_uncharge flag to false when calling refill_obj_stock()
+	 * to temporarily allow the pre-charged bytes to exceed the page
+	 * size limit. The maximum reachable value of the pre-charged
+	 * bytes is (sizeof(object) + PAGE_SIZE - 2) if there is no data
+	 * race.
 	 */
 	nr_pages = size >> PAGE_SHIFT;
 	nr_bytes = size & (PAGE_SIZE - 1);
@@ -3205,14 +3227,14 @@ int obj_cgroup_charge(struct obj_cgroup
 
 	ret = obj_cgroup_charge_pages(objcg, gfp, nr_pages);
 	if (!ret && nr_bytes)
-		refill_obj_stock(objcg, PAGE_SIZE - nr_bytes);
+		refill_obj_stock(objcg, PAGE_SIZE - nr_bytes, false);
 
 	return ret;
 }
 
 void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
 {
-	refill_obj_stock(objcg, size);
+	refill_obj_stock(objcg, size, true);
 }
 
 #endif /* CONFIG_MEMCG_KMEM */
_
