Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E26BBC433B4
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:45:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B94EF61430
	for <mm-commits@archiver.kernel.org>; Sun,  9 May 2021 00:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEIAq6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 20:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:35818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhEIAq5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 20:46:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 273BE61426;
        Sun,  9 May 2021 00:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620521155;
        bh=J6ekf0vx1v35XPJoUINopQMFqgR0wg6xT0fl5au9XNQ=;
        h=Date:From:To:Subject:From;
        b=sJHhEj9AB8XzoQODgLecgVNX27Wecxr2Zv+fRRqzK6Xh1vyCpztGkPaVc4Y61M/Sm
         N4uOEG4JZmM2e1/wAZkwPl2bTKJ+uPW6/ASMljQMqXPxrYgBdnAA0OX94IXNxrqNS/
         M25dxo7Av2A9cgcchmUPWsRclBgkezqpomWeyoWU=
Date:   Sat, 08 May 2021 17:45:54 -0700
From:   akpm@linux-foundation.org
To:     alex.shi@linux.alibaba.com, chris@chrisdown.name, cl@linux.com,
        guro@fb.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com,
        laoar.shao@gmail.com, longman@redhat.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, msys.mizuma@gmail.com,
        penberg@kernel.org, richard.weiyang@gmail.com, rientjes@google.com,
        shakeelb@google.com, songmuchun@bytedance.com, tj@kernel.org,
        vbabka@suse.cz, vdavydov.dev@gmail.com, willy@infradead.org,
        zhengjun.xing@linux.intel.com
Subject:  +
 mm-memcg-cache-vmstat-data-in-percpu-memcg_stock_pcp.patch added to -mm
 tree
Message-ID: <20210509004554.GKyejnwfm%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcg: cache vmstat data in percpu memcg_stock_pcp
has been added to the -mm tree.  Its filename is
     mm-memcg-cache-vmstat-data-in-percpu-memcg_stock_pcp.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-memcg-cache-vmstat-data-in-percpu-memcg_stock_pcp.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-memcg-cache-vmstat-data-in-percpu-memcg_stock_pcp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: mm/memcg: cache vmstat data in percpu memcg_stock_pcp

Before the new slab memory controller with per object byte charging,
charging and vmstat data update happen only when new slab pages are
allocated or freed.  Now they are done with every kmem_cache_alloc() and
kmem_cache_free().  This causes additional overhead for workloads that
generate a lot of alloc and free calls.

The memcg_stock_pcp is used to cache byte charge for a specific obj_cgroup
to reduce that overhead.  To further reducing it, this patch makes the
vmstat data cached in the memcg_stock_pcp structure as well until it
accumulates a page size worth of update or when other cached data change. 
Caching the vmstat data in the per-cpu stock eliminates two writes to
non-hot cachelines for memcg specific as well as memcg-lruvecs specific
vmstat data by a write to a hot local stock cacheline.

On a 2-socket Cascade Lake server with instrumentation enabled and this
patch applied, it was found that about 20% (634400 out of 3243830) of the
time when mod_objcg_state() is called leads to an actual call to
__mod_objcg_state() after initial boot.  When doing parallel kernel build,
the figure was about 17% (24329265 out of 142512465).  So caching the
vmstat data reduces the number of calls to __mod_objcg_state() by more
than 80%.

Link: https://lkml.kernel.org/r/20210506150007.16288-3-longman@redhat.com
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

 mm/memcontrol.c |   90 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 87 insertions(+), 3 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-cache-vmstat-data-in-percpu-memcg_stock_pcp
+++ a/mm/memcontrol.c
@@ -782,8 +782,9 @@ void __mod_lruvec_kmem_state(void *p, en
 	rcu_read_unlock();
 }
 
-void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
-		     enum node_stat_item idx, int nr)
+static inline void mod_objcg_mlstate(struct obj_cgroup *objcg,
+				     struct pglist_data *pgdat,
+				     enum node_stat_item idx, int nr)
 {
 	struct mem_cgroup *memcg;
 	struct lruvec *lruvec;
@@ -791,7 +792,7 @@ void mod_objcg_state(struct obj_cgroup *
 	rcu_read_lock();
 	memcg = obj_cgroup_memcg(objcg);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
-	mod_memcg_lruvec_state(lruvec, idx, nr);
+	__mod_memcg_lruvec_state(lruvec, idx, nr);
 	rcu_read_unlock();
 }
 
@@ -2059,7 +2060,10 @@ struct memcg_stock_pcp {
 
 #ifdef CONFIG_MEMCG_KMEM
 	struct obj_cgroup *cached_objcg;
+	struct pglist_data *cached_pgdat;
 	unsigned int nr_bytes;
+	int nr_slab_reclaimable_b;
+	int nr_slab_unreclaimable_b;
 #endif
 
 	struct work_struct work;
@@ -3008,6 +3012,67 @@ void __memcg_kmem_uncharge_page(struct p
 	obj_cgroup_put(objcg);
 }
 
+void mod_objcg_state(struct obj_cgroup *objcg, struct pglist_data *pgdat,
+		     enum node_stat_item idx, int nr)
+{
+	struct memcg_stock_pcp *stock;
+	unsigned long flags;
+	int *bytes;
+
+	local_irq_save(flags);
+	stock = this_cpu_ptr(&memcg_stock);
+
+	/*
+	 * Save vmstat data in stock and skip vmstat array update unless
+	 * accumulating over a page of vmstat data or when pgdat or idx
+	 * changes.
+	 */
+	if (stock->cached_objcg != objcg) {
+		drain_obj_stock(stock);
+		obj_cgroup_get(objcg);
+		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
+				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
+		stock->cached_objcg = objcg;
+		stock->cached_pgdat = pgdat;
+	} else if (stock->cached_pgdat != pgdat) {
+		/* Flush the existing cached vmstat data */
+		if (stock->nr_slab_reclaimable_b) {
+			mod_objcg_mlstate(objcg, pgdat, NR_SLAB_RECLAIMABLE_B,
+					  stock->nr_slab_reclaimable_b);
+			stock->nr_slab_reclaimable_b = 0;
+		}
+		if (stock->nr_slab_unreclaimable_b) {
+			mod_objcg_mlstate(objcg, pgdat, NR_SLAB_UNRECLAIMABLE_B,
+					  stock->nr_slab_unreclaimable_b);
+			stock->nr_slab_unreclaimable_b = 0;
+		}
+		stock->cached_pgdat = pgdat;
+	}
+
+	bytes = (idx == NR_SLAB_RECLAIMABLE_B) ? &stock->nr_slab_reclaimable_b
+					       : &stock->nr_slab_unreclaimable_b;
+	/*
+	 * Even for large object >= PAGE_SIZE, the vmstat data will still be
+	 * cached locally at least once before pushing it out.
+	 */
+	if (!*bytes) {
+		*bytes = nr;
+		nr = 0;
+	} else {
+		*bytes += nr;
+		if (abs(*bytes) > PAGE_SIZE) {
+			nr = *bytes;
+			*bytes = 0;
+		} else {
+			nr = 0;
+		}
+	}
+	if (nr)
+		mod_objcg_mlstate(objcg, pgdat, idx, nr);
+
+	local_irq_restore(flags);
+}
+
 static bool consume_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes)
 {
 	struct memcg_stock_pcp *stock;
@@ -3055,6 +3120,25 @@ static void drain_obj_stock(struct memcg
 		stock->nr_bytes = 0;
 	}
 
+	/*
+	 * Flush the vmstat data in current stock
+	 */
+	if (stock->nr_slab_reclaimable_b || stock->nr_slab_unreclaimable_b) {
+		if (stock->nr_slab_reclaimable_b) {
+			mod_objcg_mlstate(old, stock->cached_pgdat,
+					  NR_SLAB_RECLAIMABLE_B,
+					  stock->nr_slab_reclaimable_b);
+			stock->nr_slab_reclaimable_b = 0;
+		}
+		if (stock->nr_slab_unreclaimable_b) {
+			mod_objcg_mlstate(old, stock->cached_pgdat,
+					  NR_SLAB_UNRECLAIMABLE_B,
+					  stock->nr_slab_unreclaimable_b);
+			stock->nr_slab_unreclaimable_b = 0;
+		}
+		stock->cached_pgdat = NULL;
+	}
+
 	obj_cgroup_put(old);
 	stock->cached_objcg = NULL;
 }
_

Patches currently in -mm which might be from longman@redhat.com are

mm-memcg-move-mod_objcg_state-to-memcontrolc.patch
mm-memcg-cache-vmstat-data-in-percpu-memcg_stock_pcp.patch
mm-memcg-improve-refill_obj_stock-performance.patch
mm-memcg-optimize-user-context-object-stock-access.patch

