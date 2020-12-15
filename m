Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EC16C2BB40
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E64AE223C8
	for <mm-commits@archiver.kernel.org>; Tue, 15 Dec 2020 03:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgLODQk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727409AbgLODPp (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 14 Dec 2020 22:15:45 -0500
Date:   Mon, 14 Dec 2020 19:14:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608002098;
        bh=TwPOT2mYSbkWpyl9KLR8oXr2+BzDeCoPOarPbNTk7WE=;
        h=From:To:Subject:In-Reply-To:From;
        b=UAQwyH7RX6z0ByTgIs0vGRrp9LZGeVGLcN2M/uR7ZGd1Zd/XgsjV8L6OoCLNbrZkZ
         F44M7PiksSzSKPJxlwdOn+y+zaJagE+PcZaPBXobNv1cnDsovmU7TNxxrbC9lHiygl
         nbb/TqqT0Az0GzbdtiYoRNXlb1oeU3GmKcTvm1pw=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cl@linux.com,
        gregkh@linuxfoundation.org, hughd@google.com,
        iamjoonsoo.kim@lge.com, joe@perches.com, linux-mm@kvack.org,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com,
        torvalds@linux-foundation.org, willy@infradead.org
Subject:  [patch 198/200] mm: slub: convert sysfs sprintf family to
 sysfs_emit/sysfs_emit_at
Message-ID: <20201215031457.KPync4aPb%akpm@linux-foundation.org>
In-Reply-To: <20201214190237.a17b70ae14f129e2dca3d204@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Joe Perches <joe@perches.com>
Subject: mm: slub: convert sysfs sprintf family to sysfs_emit/sysfs_emit_at

Convert the unbounded uses of sprintf to sysfs_emit.

A few conversions may now not end in a newline if the output buffer is
overflowed.

Link: https://lkml.kernel.org/r/0c90a90f466167f8c37de4b737553cf49c4a277f.1605376435.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |  146 ++++++++++++++++++++++++++--------------------------
 1 file changed, 75 insertions(+), 71 deletions(-)

--- a/mm/slub.c~mm-slub-convert-sysfs-sprintf-family-to-sysfs_emit-sysfs_emit_at
+++ a/mm/slub.c
@@ -4724,7 +4724,7 @@ static void process_slab(struct loc_trac
 }
 
 static int list_locations(struct kmem_cache *s, char *buf,
-					enum track_item alloc)
+			  enum track_item alloc)
 {
 	int len = 0;
 	unsigned long i;
@@ -4734,7 +4734,7 @@ static int list_locations(struct kmem_ca
 
 	if (!alloc_loc_track(&t, PAGE_SIZE / sizeof(struct location),
 			     GFP_KERNEL)) {
-		return sprintf(buf, "Out of memory\n");
+		return sysfs_emit(buf, "Out of memory\n");
 	}
 	/* Push back cpu slabs */
 	flush_all(s);
@@ -4757,50 +4757,45 @@ static int list_locations(struct kmem_ca
 	for (i = 0; i < t.count; i++) {
 		struct location *l = &t.loc[i];
 
-		if (len > PAGE_SIZE - KSYM_SYMBOL_LEN - 100)
-			break;
-		len += sprintf(buf + len, "%7ld ", l->count);
+		len += sysfs_emit_at(buf, len, "%7ld ", l->count);
 
 		if (l->addr)
-			len += sprintf(buf + len, "%pS", (void *)l->addr);
+			len += sysfs_emit_at(buf, len, "%pS", (void *)l->addr);
 		else
-			len += sprintf(buf + len, "<not-available>");
+			len += sysfs_emit_at(buf, len, "<not-available>");
 
-		if (l->sum_time != l->min_time) {
-			len += sprintf(buf + len, " age=%ld/%ld/%ld",
-				l->min_time,
-				(long)div_u64(l->sum_time, l->count),
-				l->max_time);
-		} else
-			len += sprintf(buf + len, " age=%ld",
-				l->min_time);
+		if (l->sum_time != l->min_time)
+			len += sysfs_emit_at(buf, len, " age=%ld/%ld/%ld",
+					     l->min_time,
+					     (long)div_u64(l->sum_time,
+							   l->count),
+					     l->max_time);
+		else
+			len += sysfs_emit_at(buf, len, " age=%ld", l->min_time);
 
 		if (l->min_pid != l->max_pid)
-			len += sprintf(buf + len, " pid=%ld-%ld",
-				l->min_pid, l->max_pid);
+			len += sysfs_emit_at(buf, len, " pid=%ld-%ld",
+					     l->min_pid, l->max_pid);
 		else
-			len += sprintf(buf + len, " pid=%ld",
-				l->min_pid);
+			len += sysfs_emit_at(buf, len, " pid=%ld",
+					     l->min_pid);
 
 		if (num_online_cpus() > 1 &&
-				!cpumask_empty(to_cpumask(l->cpus)) &&
-				len < PAGE_SIZE - 60)
-			len += scnprintf(buf + len, PAGE_SIZE - len - 50,
-					 " cpus=%*pbl",
-					 cpumask_pr_args(to_cpumask(l->cpus)));
-
-		if (nr_online_nodes > 1 && !nodes_empty(l->nodes) &&
-				len < PAGE_SIZE - 60)
-			len += scnprintf(buf + len, PAGE_SIZE - len - 50,
-					 " nodes=%*pbl",
-					 nodemask_pr_args(&l->nodes));
+		    !cpumask_empty(to_cpumask(l->cpus)))
+			len += sysfs_emit_at(buf, len, " cpus=%*pbl",
+					     cpumask_pr_args(to_cpumask(l->cpus)));
+
+		if (nr_online_nodes > 1 && !nodes_empty(l->nodes))
+			len += sysfs_emit_at(buf, len, " nodes=%*pbl",
+					     nodemask_pr_args(&l->nodes));
 
-		len += sprintf(buf + len, "\n");
+		len += sysfs_emit_at(buf, len, "\n");
 	}
 
 	free_loc_track(&t);
 	if (!t.count)
-		len += sprintf(buf, "No data\n");
+		len += sysfs_emit_at(buf, len, "No data\n");
+
 	return len;
 }
 #endif	/* CONFIG_SLUB_DEBUG */
@@ -4897,12 +4892,13 @@ __setup("slub_memcg_sysfs=", setup_slub_
 #endif
 
 static ssize_t show_slab_objects(struct kmem_cache *s,
-			    char *buf, unsigned long flags)
+				 char *buf, unsigned long flags)
 {
 	unsigned long total = 0;
 	int node;
 	int x;
 	unsigned long *nodes;
+	int len = 0;
 
 	nodes = kcalloc(nr_node_ids, sizeof(unsigned long), GFP_KERNEL);
 	if (!nodes)
@@ -4991,15 +4987,19 @@ static ssize_t show_slab_objects(struct
 			nodes[node] += x;
 		}
 	}
-	x = sprintf(buf, "%lu", total);
+
+	len += sysfs_emit_at(buf, len, "%lu", total);
 #ifdef CONFIG_NUMA
-	for (node = 0; node < nr_node_ids; node++)
+	for (node = 0; node < nr_node_ids; node++) {
 		if (nodes[node])
-			x += sprintf(buf + x, " N%d=%lu",
-					node, nodes[node]);
+			len += sysfs_emit_at(buf, len, " N%d=%lu",
+					     node, nodes[node]);
+	}
 #endif
+	len += sysfs_emit_at(buf, len, "\n");
 	kfree(nodes);
-	return x + sprintf(buf + x, "\n");
+
+	return len;
 }
 
 #define to_slab_attr(n) container_of(n, struct slab_attribute, attr)
@@ -5021,37 +5021,37 @@ struct slab_attribute {
 
 static ssize_t slab_size_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%u\n", s->size);
+	return sysfs_emit(buf, "%u\n", s->size);
 }
 SLAB_ATTR_RO(slab_size);
 
 static ssize_t align_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%u\n", s->align);
+	return sysfs_emit(buf, "%u\n", s->align);
 }
 SLAB_ATTR_RO(align);
 
 static ssize_t object_size_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%u\n", s->object_size);
+	return sysfs_emit(buf, "%u\n", s->object_size);
 }
 SLAB_ATTR_RO(object_size);
 
 static ssize_t objs_per_slab_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%u\n", oo_objects(s->oo));
+	return sysfs_emit(buf, "%u\n", oo_objects(s->oo));
 }
 SLAB_ATTR_RO(objs_per_slab);
 
 static ssize_t order_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%u\n", oo_order(s->oo));
+	return sysfs_emit(buf, "%u\n", oo_order(s->oo));
 }
 SLAB_ATTR_RO(order);
 
 static ssize_t min_partial_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%lu\n", s->min_partial);
+	return sysfs_emit(buf, "%lu\n", s->min_partial);
 }
 
 static ssize_t min_partial_store(struct kmem_cache *s, const char *buf,
@@ -5071,7 +5071,7 @@ SLAB_ATTR(min_partial);
 
 static ssize_t cpu_partial_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%u\n", slub_cpu_partial(s));
+	return sysfs_emit(buf, "%u\n", slub_cpu_partial(s));
 }
 
 static ssize_t cpu_partial_store(struct kmem_cache *s, const char *buf,
@@ -5096,13 +5096,13 @@ static ssize_t ctor_show(struct kmem_cac
 {
 	if (!s->ctor)
 		return 0;
-	return sprintf(buf, "%pS\n", s->ctor);
+	return sysfs_emit(buf, "%pS\n", s->ctor);
 }
 SLAB_ATTR_RO(ctor);
 
 static ssize_t aliases_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", s->refcount < 0 ? 0 : s->refcount - 1);
+	return sysfs_emit(buf, "%d\n", s->refcount < 0 ? 0 : s->refcount - 1);
 }
 SLAB_ATTR_RO(aliases);
 
@@ -5135,7 +5135,7 @@ static ssize_t slabs_cpu_partial_show(st
 	int objects = 0;
 	int pages = 0;
 	int cpu;
-	int len;
+	int len = 0;
 
 	for_each_online_cpu(cpu) {
 		struct page *page;
@@ -5148,52 +5148,53 @@ static ssize_t slabs_cpu_partial_show(st
 		}
 	}
 
-	len = sprintf(buf, "%d(%d)", objects, pages);
+	len += sysfs_emit_at(buf, len, "%d(%d)", objects, pages);
 
 #ifdef CONFIG_SMP
 	for_each_online_cpu(cpu) {
 		struct page *page;
 
 		page = slub_percpu_partial(per_cpu_ptr(s->cpu_slab, cpu));
-
-		if (page && len < PAGE_SIZE - 20)
-			len += sprintf(buf + len, " C%d=%d(%d)", cpu,
-				page->pobjects, page->pages);
+		if (page)
+			len += sysfs_emit_at(buf, len, " C%d=%d(%d)",
+					     cpu, page->pobjects, page->pages);
 	}
 #endif
-	return len + sprintf(buf + len, "\n");
+	len += sysfs_emit_at(buf, len, "\n");
+
+	return len;
 }
 SLAB_ATTR_RO(slabs_cpu_partial);
 
 static ssize_t reclaim_account_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_RECLAIM_ACCOUNT));
+	return sysfs_emit(buf, "%d\n", !!(s->flags & SLAB_RECLAIM_ACCOUNT));
 }
 SLAB_ATTR_RO(reclaim_account);
 
 static ssize_t hwcache_align_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_HWCACHE_ALIGN));
+	return sysfs_emit(buf, "%d\n", !!(s->flags & SLAB_HWCACHE_ALIGN));
 }
 SLAB_ATTR_RO(hwcache_align);
 
 #ifdef CONFIG_ZONE_DMA
 static ssize_t cache_dma_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_CACHE_DMA));
+	return sysfs_emit(buf, "%d\n", !!(s->flags & SLAB_CACHE_DMA));
 }
 SLAB_ATTR_RO(cache_dma);
 #endif
 
 static ssize_t usersize_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%u\n", s->usersize);
+	return sysfs_emit(buf, "%u\n", s->usersize);
 }
 SLAB_ATTR_RO(usersize);
 
 static ssize_t destroy_by_rcu_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_TYPESAFE_BY_RCU));
+	return sysfs_emit(buf, "%d\n", !!(s->flags & SLAB_TYPESAFE_BY_RCU));
 }
 SLAB_ATTR_RO(destroy_by_rcu);
 
@@ -5212,33 +5213,33 @@ SLAB_ATTR_RO(total_objects);
 
 static ssize_t sanity_checks_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_CONSISTENCY_CHECKS));
+	return sysfs_emit(buf, "%d\n", !!(s->flags & SLAB_CONSISTENCY_CHECKS));
 }
 SLAB_ATTR_RO(sanity_checks);
 
 static ssize_t trace_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_TRACE));
+	return sysfs_emit(buf, "%d\n", !!(s->flags & SLAB_TRACE));
 }
 SLAB_ATTR_RO(trace);
 
 static ssize_t red_zone_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_RED_ZONE));
+	return sysfs_emit(buf, "%d\n", !!(s->flags & SLAB_RED_ZONE));
 }
 
 SLAB_ATTR_RO(red_zone);
 
 static ssize_t poison_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_POISON));
+	return sysfs_emit(buf, "%d\n", !!(s->flags & SLAB_POISON));
 }
 
 SLAB_ATTR_RO(poison);
 
 static ssize_t store_user_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_STORE_USER));
+	return sysfs_emit(buf, "%d\n", !!(s->flags & SLAB_STORE_USER));
 }
 
 SLAB_ATTR_RO(store_user);
@@ -5282,7 +5283,7 @@ SLAB_ATTR_RO(free_calls);
 #ifdef CONFIG_FAILSLAB
 static ssize_t failslab_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%d\n", !!(s->flags & SLAB_FAILSLAB));
+	return sysfs_emit(buf, "%d\n", !!(s->flags & SLAB_FAILSLAB));
 }
 SLAB_ATTR_RO(failslab);
 #endif
@@ -5306,7 +5307,7 @@ SLAB_ATTR(shrink);
 #ifdef CONFIG_NUMA
 static ssize_t remote_node_defrag_ratio_show(struct kmem_cache *s, char *buf)
 {
-	return sprintf(buf, "%u\n", s->remote_node_defrag_ratio / 10);
+	return sysfs_emit(buf, "%u\n", s->remote_node_defrag_ratio / 10);
 }
 
 static ssize_t remote_node_defrag_ratio_store(struct kmem_cache *s,
@@ -5333,7 +5334,7 @@ static int show_stat(struct kmem_cache *
 {
 	unsigned long sum  = 0;
 	int cpu;
-	int len;
+	int len = 0;
 	int *data = kmalloc_array(nr_cpu_ids, sizeof(int), GFP_KERNEL);
 
 	if (!data)
@@ -5346,16 +5347,19 @@ static int show_stat(struct kmem_cache *
 		sum += x;
 	}
 
-	len = sprintf(buf, "%lu", sum);
+	len += sysfs_emit_at(buf, len, "%lu", sum);
 
 #ifdef CONFIG_SMP
 	for_each_online_cpu(cpu) {
-		if (data[cpu] && len < PAGE_SIZE - 20)
-			len += sprintf(buf + len, " C%d=%u", cpu, data[cpu]);
+		if (data[cpu])
+			len += sysfs_emit_at(buf, len, " C%d=%u",
+					     cpu, data[cpu]);
 	}
 #endif
 	kfree(data);
-	return len + sprintf(buf + len, "\n");
+	len += sysfs_emit_at(buf, len, "\n");
+
+	return len;
 }
 
 static void clear_stat(struct kmem_cache *s, enum stat_item si)
_
