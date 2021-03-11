Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F1D7C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:16:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF39064F7B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbhCKWPh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 17:15:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229827AbhCKWPK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 17:15:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1268164F8F;
        Thu, 11 Mar 2021 22:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615500910;
        bh=REaaRynnfqXQt8l5nINIhgvtD7BHGWx3U7mHlvBLZcw=;
        h=Date:From:To:Subject:From;
        b=a79C8Nf/rR4nBItAcEug4tOxeNfq1K1JsqXTCpInNJqqaJm/6ZvAbPZ7UVUaXwgN5
         PLa0UZdMC565MUTNB+lJmz7aSGNQb3X4BrhtKsipMqowaDbFimDnoZHaWGi5OcRYwk
         tBmKoUy6yfvCPU8KflZkWumfTbeO2WWt/qwOSsAw=
Date:   Thu, 11 Mar 2021 14:15:09 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jnwang@linux.alibaba.com, khlebnikov@yandex-team.ru,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sming56@gmail.com, vbabka@suse.cz,
        wenyang@linux.alibaba.com, willy@infradead.org,
        xlpang@linux.alibaba.com
Subject:  + mm-slub-use-percpu-partial-free-counter.patch added to
 -mm tree
Message-ID: <20210311221509.19UyA5T-D%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: use percpu partial free counter
has been added to the -mm tree.  Its filename is
     mm-slub-use-percpu-partial-free-counter.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-use-percpu-partial-free-counter.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-use-percpu-partial-free-counter.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-slub-introduce-two-counters-for-partial-objects.patch
mm-slub-get-rid-of-count_partial.patch
percpu-export-per_cpu_sum.patch
mm-slub-use-percpu-partial-free-counter.patch

