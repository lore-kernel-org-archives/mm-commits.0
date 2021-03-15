Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCDFC433E0
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44D2364F64
	for <mm-commits@archiver.kernel.org>; Mon, 15 Mar 2021 23:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231324AbhCOXMC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 15 Mar 2021 19:12:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233477AbhCOXL3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 15 Mar 2021 19:11:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE92764F6B;
        Mon, 15 Mar 2021 23:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615849889;
        bh=s5XSHhuam6esp1hoDfSRMtb3CPDXeUpphnhIb7eRJFM=;
        h=Date:From:To:Subject:From;
        b=1Dy9duxKOXnNg4NhOp5LgELdoyj9FkvBoHmz4wbn4EehBdTihSidSRu2JcM/1ircM
         B3v2vQifBw8Jj2l2KtBkb2Wq8XD78FFqFZF1qfhnRkpnSdvvSE1ilHDPF+dHjrqQtc
         NJ0fiMf3coxCfAlzd3yV29gugDsnZU2q6SqXmDpU=
Date:   Mon, 15 Mar 2021 16:11:28 -0700
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jnwang@linux.alibaba.com, khlebnikov@yandex-team.ru,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sming56@gmail.com, vbabka@suse.cz,
        wenyang@linux.alibaba.com, willy@infradead.org,
        xlpang@linux.alibaba.com
Subject:  [nacked] mm-slub-use-percpu-partial-free-counter.patch
 removed from -mm tree
Message-ID: <20210315231128.UeWDuqBQN%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: use percpu partial free counter
has been removed from the -mm tree.  Its filename was
     mm-slub-use-percpu-partial-free-counter.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Xunlei Pang <xlpang@linux.alibaba.com>
Subject: mm/slub: use percpu partial free counter

The only concern of introducing partial counter is that, partial_free_objs
may cause cache and atomic operation contention in case of same SLUB
concurrent __slab_free().

This patch changes it to be a percpu counter, also replace the counter
variables to avoid cacheline issues.

Link: https://lkml.kernel.org/r/1615303512-35058-5-git-send-email-xlpang@linux.alibaba.com
Signed-off-by: Xunlei Pang <xlpang@linux.alibaba.com>
Tested-by: James Wang <jnwang@linux.alibaba.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shu Ming <sming56@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wen Yang <wenyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    6 ++++--
 mm/slub.c |   30 +++++++++++++++++++++++-------
 2 files changed, 27 insertions(+), 9 deletions(-)

--- a/mm/slab.h~mm-slub-use-percpu-partial-free-counter
+++ a/mm/slab.h
@@ -546,16 +546,18 @@ struct kmem_cache_node {
 
 #ifdef CONFIG_SLUB
 	unsigned long nr_partial;
-	struct list_head partial;
 #if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SYSFS)
-	atomic_long_t partial_free_objs;
 	unsigned long partial_total_objs;
 #endif
+	struct list_head partial;
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_t nr_slabs;
 	atomic_long_t total_objects;
 	struct list_head full;
 #endif
+#if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SYSFS)
+	unsigned long __percpu *partial_free_objs;
+#endif
 #endif
 
 };
--- a/mm/slub.c~mm-slub-use-percpu-partial-free-counter
+++ a/mm/slub.c
@@ -1894,7 +1894,7 @@ static void discard_slab(struct kmem_cac
 static inline void
 __update_partial_free(struct kmem_cache_node *n, long delta)
 {
-	atomic_long_add(delta, &n->partial_free_objs);
+	this_cpu_add(*n->partial_free_objs, delta);
 }
 
 static inline void
@@ -2548,11 +2548,16 @@ static unsigned long partial_counter(str
 	unsigned long ret = 0;
 
 	if (item == PARTIAL_FREE) {
-		ret = atomic_long_read(&n->partial_free_objs);
+		ret = per_cpu_sum(*n->partial_free_objs);
+		if ((long)ret < 0)
+			ret = 0;
 	} else if (item == PARTIAL_TOTAL) {
 		ret = n->partial_total_objs;
 	} else if (item == PARTIAL_INUSE) {
-		ret = n->partial_total_objs - atomic_long_read(&n->partial_free_objs);
+		ret = per_cpu_sum(*n->partial_free_objs);
+		if ((long)ret < 0)
+			ret = 0;
+		ret = n->partial_total_objs - ret;
 		if ((long)ret < 0)
 			ret = 0;
 	}
@@ -3552,14 +3557,16 @@ static inline int calculate_order(unsign
 	return -ENOSYS;
 }
 
-static void
+static int
 init_kmem_cache_node(struct kmem_cache_node *n)
 {
 	n->nr_partial = 0;
 	spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
 #if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SYSFS)
-	atomic_long_set(&n->partial_free_objs, 0);
+	n->partial_free_objs = alloc_percpu(unsigned long);
+	if (!n->partial_free_objs)
+		return -ENOMEM;
 	n->partial_total_objs = 0;
 #endif
 #ifdef CONFIG_SLUB_DEBUG
@@ -3567,6 +3574,8 @@ init_kmem_cache_node(struct kmem_cache_n
 	atomic_long_set(&n->total_objects, 0);
 	INIT_LIST_HEAD(&n->full);
 #endif
+
+	return 0;
 }
 
 static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
@@ -3626,7 +3635,7 @@ static void early_kmem_cache_node_alloc(
 	page->inuse = 1;
 	page->frozen = 0;
 	kmem_cache_node->node[node] = n;
-	init_kmem_cache_node(n);
+	BUG_ON(init_kmem_cache_node(n) < 0);
 	inc_slabs_node(kmem_cache_node, node, page->objects);
 
 	/*
@@ -3644,6 +3653,9 @@ static void free_kmem_cache_nodes(struct
 
 	for_each_kmem_cache_node(s, node, n) {
 		s->node[node] = NULL;
+#if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SYSFS)
+		free_percpu(n->partial_free_objs);
+#endif
 		kmem_cache_free(kmem_cache_node, n);
 	}
 }
@@ -3674,7 +3686,11 @@ static int init_kmem_cache_nodes(struct
 			return 0;
 		}
 
-		init_kmem_cache_node(n);
+		if (init_kmem_cache_node(n) < 0) {
+			free_kmem_cache_nodes(s);
+			return 0;
+		}
+
 		s->node[node] = n;
 	}
 	return 1;
_

Patches currently in -mm which might be from xlpang@linux.alibaba.com are


