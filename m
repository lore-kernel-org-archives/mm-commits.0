Return-Path: <SRS0=ze/c=BR=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45107C433E0
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A9652177B
	for <mm-commits@archiver.kernel.org>; Fri,  7 Aug 2020 06:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596781242;
	bh=Wr6Ao82alTcvrS8s+OMnF9azCleNhu8TDRkyZlYwk/c=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=utz6qo6r9bLiYdhNcbwkT+jbdlQa2zme9vJDKzLnSlDyvX8S7+e9/ZP/rrPX2RYa1
	 Ck9DCa+u9LJbObB1HjhHljwmGM6zCzMjVL3nJZzbrHFtVZVf9cvHiwHRnsEwuU/vN1
	 bMDi5nC8cdlhlOK2kdDI0canS8feMejMwKhZCGf0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHGGUl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 7 Aug 2020 02:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:56622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726094AbgHGGUl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 7 Aug 2020 02:20:41 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3ECF221E5;
        Fri,  7 Aug 2020 06:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596781240;
        bh=Wr6Ao82alTcvrS8s+OMnF9azCleNhu8TDRkyZlYwk/c=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=Iv7M7jIhfUL3QIDmdiIySY5KcsLEzxJM/a8dtjf2651C/nVMpje0+w/7Vcu9UOmpT
         n/SStelds3r7giNvtBR/pcDEg48Uj7fGJl3iowhWspfERQ/oIChhAg8t+0OTAwrF/u
         ZW6j1icvBevTo8Z/xTuTAnHynUcxvVmB7AnCqPDE=
Date:   Thu, 06 Aug 2020 23:20:39 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com, guro@fb.com,
        hannes@cmpxchg.org, linux-mm@kvack.org, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shakeelb@google.com, tj@kernel.org,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 064/163] mm: memcg: convert vmstat slab counters
 to bytes
Message-ID: <20200807062039.9Bzmjuqpw%akpm@linux-foundation.org>
In-Reply-To: <20200806231643.a2711a608dd0f18bff2caf2b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Roman Gushchin <guro@fb.com>
Subject: mm: memcg: convert vmstat slab counters to bytes

In order to prepare for per-object slab memory accounting, convert
NR_SLAB_RECLAIMABLE and NR_SLAB_UNRECLAIMABLE vmstat items to bytes.

To make it obvious, rename them to NR_SLAB_RECLAIMABLE_B and
NR_SLAB_UNRECLAIMABLE_B (similar to NR_KERNEL_STACK_KB).

Internally global and per-node counters are stored in pages, however memcg
and lruvec counters are stored in bytes.  This scheme may look weird, but
only for now.  As soon as slab pages will be shared between multiple
cgroups, global and node counters will reflect the total number of slab
pages.  However memcg and lruvec counters will be used for per-memcg slab
memory tracking, which will take separate kernel objects in the account. 
Keeping global and node counters in pages helps to avoid additional
overhead.

The size of slab memory shouldn't exceed 4Gb on 32-bit machines, so it
will fit into atomic_long_t we use for vmstats.

Link: http://lkml.kernel.org/r/20200623174037.3951353-4-guro@fb.com
Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/node.c     |    4 ++--
 fs/proc/meminfo.c       |    4 ++--
 include/linux/mmzone.h  |   16 +++++++++++++---
 kernel/power/snapshot.c |    2 +-
 mm/memcontrol.c         |   11 ++++-------
 mm/oom_kill.c           |    2 +-
 mm/page_alloc.c         |    8 ++++----
 mm/slab.h               |   15 ++++++++-------
 mm/slab_common.c        |    4 ++--
 mm/slob.c               |   12 ++++++------
 mm/slub.c               |    8 ++++----
 mm/vmscan.c             |    3 ++-
 mm/workingset.c         |    6 ++++--
 13 files changed, 53 insertions(+), 42 deletions(-)

--- a/drivers/base/node.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/drivers/base/node.c
@@ -368,8 +368,8 @@ static ssize_t node_read_meminfo(struct
 	unsigned long sreclaimable, sunreclaimable;
 
 	si_meminfo_node(&i, nid);
-	sreclaimable = node_page_state(pgdat, NR_SLAB_RECLAIMABLE);
-	sunreclaimable = node_page_state(pgdat, NR_SLAB_UNRECLAIMABLE);
+	sreclaimable = node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B);
+	sunreclaimable = node_page_state_pages(pgdat, NR_SLAB_UNRECLAIMABLE_B);
 	n = sprintf(buf,
 		       "Node %d MemTotal:       %8lu kB\n"
 		       "Node %d MemFree:        %8lu kB\n"
--- a/fs/proc/meminfo.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/fs/proc/meminfo.c
@@ -52,8 +52,8 @@ static int meminfo_proc_show(struct seq_
 		pages[lru] = global_node_page_state(NR_LRU_BASE + lru);
 
 	available = si_mem_available();
-	sreclaimable = global_node_page_state(NR_SLAB_RECLAIMABLE);
-	sunreclaim = global_node_page_state(NR_SLAB_UNRECLAIMABLE);
+	sreclaimable = global_node_page_state_pages(NR_SLAB_RECLAIMABLE_B);
+	sunreclaim = global_node_page_state_pages(NR_SLAB_UNRECLAIMABLE_B);
 
 	show_val_kb(m, "MemTotal:       ", i.totalram);
 	show_val_kb(m, "MemFree:        ", i.freeram);
--- a/include/linux/mmzone.h~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/include/linux/mmzone.h
@@ -174,8 +174,8 @@ enum node_stat_item {
 	NR_INACTIVE_FILE,	/*  "     "     "   "       "         */
 	NR_ACTIVE_FILE,		/*  "     "     "   "       "         */
 	NR_UNEVICTABLE,		/*  "     "     "   "       "         */
-	NR_SLAB_RECLAIMABLE,
-	NR_SLAB_UNRECLAIMABLE,
+	NR_SLAB_RECLAIMABLE_B,
+	NR_SLAB_UNRECLAIMABLE_B,
 	NR_ISOLATED_ANON,	/* Temporary isolated pages from anon lru */
 	NR_ISOLATED_FILE,	/* Temporary isolated pages from file lru */
 	WORKINGSET_NODES,
@@ -213,7 +213,17 @@ enum node_stat_item {
  */
 static __always_inline bool vmstat_item_in_bytes(int idx)
 {
-	return false;
+	/*
+	 * Global and per-node slab counters track slab pages.
+	 * It's expected that changes are multiples of PAGE_SIZE.
+	 * Internally values are stored in pages.
+	 *
+	 * Per-memcg and per-lruvec counters track memory, consumed
+	 * by individual slab objects. These counters are actually
+	 * byte-precise.
+	 */
+	return (idx == NR_SLAB_RECLAIMABLE_B ||
+		idx == NR_SLAB_UNRECLAIMABLE_B);
 }
 
 /*
--- a/kernel/power/snapshot.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/kernel/power/snapshot.c
@@ -1663,7 +1663,7 @@ static unsigned long minimum_image_size(
 {
 	unsigned long size;
 
-	size = global_node_page_state(NR_SLAB_RECLAIMABLE)
+	size = global_node_page_state_pages(NR_SLAB_RECLAIMABLE_B)
 		+ global_node_page_state(NR_ACTIVE_ANON)
 		+ global_node_page_state(NR_INACTIVE_ANON)
 		+ global_node_page_state(NR_ACTIVE_FILE)
--- a/mm/memcontrol.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/memcontrol.c
@@ -1391,9 +1391,8 @@ static char *memory_stat_format(struct m
 		       (u64)memcg_page_state(memcg, MEMCG_KERNEL_STACK_KB) *
 		       1024);
 	seq_buf_printf(&s, "slab %llu\n",
-		       (u64)(memcg_page_state(memcg, NR_SLAB_RECLAIMABLE) +
-			     memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE)) *
-		       PAGE_SIZE);
+		       (u64)(memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B) +
+			     memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B)));
 	seq_buf_printf(&s, "sock %llu\n",
 		       (u64)memcg_page_state(memcg, MEMCG_SOCK) *
 		       PAGE_SIZE);
@@ -1423,11 +1422,9 @@ static char *memory_stat_format(struct m
 			       PAGE_SIZE);
 
 	seq_buf_printf(&s, "slab_reclaimable %llu\n",
-		       (u64)memcg_page_state(memcg, NR_SLAB_RECLAIMABLE) *
-		       PAGE_SIZE);
+		       (u64)memcg_page_state(memcg, NR_SLAB_RECLAIMABLE_B));
 	seq_buf_printf(&s, "slab_unreclaimable %llu\n",
-		       (u64)memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE) *
-		       PAGE_SIZE);
+		       (u64)memcg_page_state(memcg, NR_SLAB_UNRECLAIMABLE_B));
 
 	/* Accumulated memory events */
 
--- a/mm/oom_kill.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/oom_kill.c
@@ -184,7 +184,7 @@ static bool is_dump_unreclaim_slabs(void
 		 global_node_page_state(NR_ISOLATED_FILE) +
 		 global_node_page_state(NR_UNEVICTABLE);
 
-	return (global_node_page_state(NR_SLAB_UNRECLAIMABLE) > nr_lru);
+	return (global_node_page_state_pages(NR_SLAB_UNRECLAIMABLE_B) > nr_lru);
 }
 
 /**
--- a/mm/page_alloc.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/page_alloc.c
@@ -5220,8 +5220,8 @@ long si_mem_available(void)
 	 * items that are in use, and cannot be freed. Cap this estimate at the
 	 * low watermark.
 	 */
-	reclaimable = global_node_page_state(NR_SLAB_RECLAIMABLE) +
-			global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE);
+	reclaimable = global_node_page_state_pages(NR_SLAB_RECLAIMABLE_B) +
+		global_node_page_state(NR_KERNEL_MISC_RECLAIMABLE);
 	available += reclaimable - min(reclaimable / 2, wmark_low);
 
 	if (available < 0)
@@ -5364,8 +5364,8 @@ void show_free_areas(unsigned int filter
 		global_node_page_state(NR_UNEVICTABLE),
 		global_node_page_state(NR_FILE_DIRTY),
 		global_node_page_state(NR_WRITEBACK),
-		global_node_page_state(NR_SLAB_RECLAIMABLE),
-		global_node_page_state(NR_SLAB_UNRECLAIMABLE),
+		global_node_page_state_pages(NR_SLAB_RECLAIMABLE_B),
+		global_node_page_state_pages(NR_SLAB_UNRECLAIMABLE_B),
 		global_node_page_state(NR_FILE_MAPPED),
 		global_node_page_state(NR_SHMEM),
 		global_zone_page_state(NR_PAGETABLE),
--- a/mm/slab_common.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/slab_common.c
@@ -1363,8 +1363,8 @@ void *kmalloc_order(size_t size, gfp_t f
 	page = alloc_pages(flags, order);
 	if (likely(page)) {
 		ret = page_address(page);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE,
-				    1 << order);
+		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
+				    PAGE_SIZE << order);
 	}
 	ret = kasan_kmalloc_large(ret, size, flags);
 	/* As ret might get tagged, call kmemleak hook after KASAN. */
--- a/mm/slab.h~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/slab.h
@@ -273,7 +273,7 @@ int __kmem_cache_alloc_bulk(struct kmem_
 static inline int cache_vmstat_idx(struct kmem_cache *s)
 {
 	return (s->flags & SLAB_RECLAIM_ACCOUNT) ?
-		NR_SLAB_RECLAIMABLE : NR_SLAB_UNRECLAIMABLE;
+		NR_SLAB_RECLAIMABLE_B : NR_SLAB_UNRECLAIMABLE_B;
 }
 
 #ifdef CONFIG_SLUB_DEBUG
@@ -390,7 +390,7 @@ static __always_inline int memcg_charge_
 
 	if (unlikely(!memcg || mem_cgroup_is_root(memcg))) {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    nr_pages);
+				    nr_pages << PAGE_SHIFT);
 		percpu_ref_get_many(&s->memcg_params.refcnt, nr_pages);
 		return 0;
 	}
@@ -400,7 +400,7 @@ static __always_inline int memcg_charge_
 		goto out;
 
 	lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
-	mod_lruvec_state(lruvec, cache_vmstat_idx(s), nr_pages);
+	mod_lruvec_state(lruvec, cache_vmstat_idx(s), nr_pages << PAGE_SHIFT);
 
 	/* transer try_charge() page references to kmem_cache */
 	percpu_ref_get_many(&s->memcg_params.refcnt, nr_pages);
@@ -425,11 +425,12 @@ static __always_inline void memcg_unchar
 	memcg = READ_ONCE(s->memcg_params.memcg);
 	if (likely(!mem_cgroup_is_root(memcg))) {
 		lruvec = mem_cgroup_lruvec(memcg, page_pgdat(page));
-		mod_lruvec_state(lruvec, cache_vmstat_idx(s), -nr_pages);
+		mod_lruvec_state(lruvec, cache_vmstat_idx(s),
+				 -(nr_pages << PAGE_SHIFT));
 		memcg_kmem_uncharge(memcg, nr_pages);
 	} else {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    -nr_pages);
+				    -(nr_pages << PAGE_SHIFT));
 	}
 	rcu_read_unlock();
 
@@ -513,7 +514,7 @@ static __always_inline int charge_slab_p
 {
 	if (is_root_cache(s)) {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    1 << order);
+				    PAGE_SIZE << order);
 		return 0;
 	}
 
@@ -525,7 +526,7 @@ static __always_inline void uncharge_sla
 {
 	if (is_root_cache(s)) {
 		mod_node_page_state(page_pgdat(page), cache_vmstat_idx(s),
-				    -(1 << order));
+				    -(PAGE_SIZE << order));
 		return;
 	}
 
--- a/mm/slob.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/slob.c
@@ -202,8 +202,8 @@ static void *slob_new_pages(gfp_t gfp, i
 	if (!page)
 		return NULL;
 
-	mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE,
-			    1 << order);
+	mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
+			    PAGE_SIZE << order);
 	return page_address(page);
 }
 
@@ -214,8 +214,8 @@ static void slob_free_pages(void *b, int
 	if (current->reclaim_state)
 		current->reclaim_state->reclaimed_slab += 1 << order;
 
-	mod_node_page_state(page_pgdat(sp), NR_SLAB_UNRECLAIMABLE,
-			    -(1 << order));
+	mod_node_page_state(page_pgdat(sp), NR_SLAB_UNRECLAIMABLE_B,
+			    -(PAGE_SIZE << order));
 	__free_pages(sp, order);
 }
 
@@ -552,8 +552,8 @@ void kfree(const void *block)
 		slob_free(m, *m + align);
 	} else {
 		unsigned int order = compound_order(sp);
-		mod_node_page_state(page_pgdat(sp), NR_SLAB_UNRECLAIMABLE,
-				    -(1 << order));
+		mod_node_page_state(page_pgdat(sp), NR_SLAB_UNRECLAIMABLE_B,
+				    -(PAGE_SIZE << order));
 		__free_pages(sp, order);
 
 	}
--- a/mm/slub.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/slub.c
@@ -3991,8 +3991,8 @@ static void *kmalloc_large_node(size_t s
 	page = alloc_pages_node(node, flags, order);
 	if (page) {
 		ptr = page_address(page);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE,
-				    1 << order);
+		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
+				    PAGE_SIZE << order);
 	}
 
 	return kmalloc_large_node_hook(ptr, size, flags);
@@ -4123,8 +4123,8 @@ void kfree(const void *x)
 
 		BUG_ON(!PageCompound(page));
 		kfree_hook(object);
-		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE,
-				    -(1 << order));
+		mod_node_page_state(page_pgdat(page), NR_SLAB_UNRECLAIMABLE_B,
+				    -(PAGE_SIZE << order));
 		__free_pages(page, order);
 		return;
 	}
--- a/mm/vmscan.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/vmscan.c
@@ -4222,7 +4222,8 @@ int node_reclaim(struct pglist_data *pgd
 	 * unmapped file backed pages.
 	 */
 	if (node_pagecache_reclaimable(pgdat) <= pgdat->min_unmapped_pages &&
-	    node_page_state(pgdat, NR_SLAB_RECLAIMABLE) <= pgdat->min_slab_pages)
+	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) <=
+	    pgdat->min_slab_pages)
 		return NODE_RECLAIM_FULL;
 
 	/*
--- a/mm/workingset.c~mm-memcg-convert-vmstat-slab-counters-to-bytes
+++ a/mm/workingset.c
@@ -486,8 +486,10 @@ static unsigned long count_shadow_nodes(
 		for (pages = 0, i = 0; i < NR_LRU_LISTS; i++)
 			pages += lruvec_page_state_local(lruvec,
 							 NR_LRU_BASE + i);
-		pages += lruvec_page_state_local(lruvec, NR_SLAB_RECLAIMABLE);
-		pages += lruvec_page_state_local(lruvec, NR_SLAB_UNRECLAIMABLE);
+		pages += lruvec_page_state_local(
+			lruvec, NR_SLAB_RECLAIMABLE_B) >> PAGE_SHIFT;
+		pages += lruvec_page_state_local(
+			lruvec, NR_SLAB_UNRECLAIMABLE_B) >> PAGE_SHIFT;
 	} else
 #endif
 		pages = node_present_pages(sc->nid);
_
