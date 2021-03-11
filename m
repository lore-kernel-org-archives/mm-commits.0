Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E67EDC433E6
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6E3864F78
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbhCKWPF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 17:15:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230406AbhCKWPB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 17:15:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71BC764F7A;
        Thu, 11 Mar 2021 22:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615500901;
        bh=AKQ6BP/sYg1xk5pTs6juzTZtkIJa50pSHf+yu4Jmadw=;
        h=Date:From:To:Subject:From;
        b=MBoNQ8wkWlKx9Bg7d0qXhYv/w3dY0EFwSbm0A+4sy+JaECaZCzF74hpKxRTHZTV8y
         FutdN42JP6tWLfPsJ0i561VeeOTbmc3OEbtQgnl9h75lmt+4atN+gPr+DWa1ToF+D7
         AfI5BVPfaTxE5iBp6POUiUyKuhG2wb/OSUBq94vc=
Date:   Thu, 11 Mar 2021 14:14:59 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jnwang@linux.alibaba.com, khlebnikov@yandex-team.ru,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sming56@gmail.com, vbabka@suse.cz,
        wenyang@linux.alibaba.com, willy@infradead.org,
        xlpang@linux.alibaba.com
Subject:  +
 mm-slub-introduce-two-counters-for-partial-objects.patch added to -mm tree
Message-ID: <20210311221459.k6DMM1FqH%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: introduce two counters for partial objects
has been added to the -mm tree.  Its filename is
     mm-slub-introduce-two-counters-for-partial-objects.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-introduce-two-counters-for-partial-objects.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-introduce-two-counters-for-partial-objects.patch

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
Subject: mm/slub: introduce two counters for partial objects

Patch series "mm/slub: Fix count_partial() problem", v3.

count_partial() can hold the n->list_lock spinlock for quite a long time,
which makes much trouble to the system.  This series eliminates this
problem.


This patch (of 4):

The node list_lock in count_partial() spends long time iterating in case
of large amount of partial page lists, which can cause thunder herd effect
to the list_lock contention.

We have HSF RT(High-speed Service Framework Response-Time) monitors, the
RT figures fluctuated randomly, then we deployed a tool detecting "irq
off" and "preempt off" to dump the culprit's calltrace, capturing the
list_lock cost nearly 100ms with irq off issued by "ss", this also caused
network timeouts.

This patch introduces two counters to maintain the actual number of
partial objects dynamically instead of iterating the partial page lists
with list_lock held.

New counters of kmem_cache_node: partial_free_objs, partial_total_objs. 
The main operations are under list_lock in slow path, its performance
impact should be minimal except the __slab_free() path which will be
addressed later.

Link: https://lkml.kernel.org/r/1615303512-35058-1-git-send-email-xlpang@linux.alibaba.com
Link: https://lkml.kernel.org/r/1615303512-35058-2-git-send-email-xlpang@linux.alibaba.com
Signed-off-by: Xunlei Pang <xlpang@linux.alibaba.com>
Tested-by: James Wang <jnwang@linux.alibaba.com>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Roman Gushchin <guro@fb.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Shu Ming <sming56@gmail.com>
Cc: Wen Yang <wenyang@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    4 ++++
 mm/slub.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

--- a/mm/slab.h~mm-slub-introduce-two-counters-for-partial-objects
+++ a/mm/slab.h
@@ -547,6 +547,10 @@ struct kmem_cache_node {
 #ifdef CONFIG_SLUB
 	unsigned long nr_partial;
 	struct list_head partial;
+#if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SYSFS)
+	atomic_long_t partial_free_objs;
+	unsigned long partial_total_objs;
+#endif
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_t nr_slabs;
 	atomic_long_t total_objects;
--- a/mm/slub.c~mm-slub-introduce-two-counters-for-partial-objects
+++ a/mm/slub.c
@@ -1890,10 +1890,31 @@ static void discard_slab(struct kmem_cac
 /*
  * Management of partially allocated slabs.
  */
+#if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SYSFS)
+static inline void
+__update_partial_free(struct kmem_cache_node *n, long delta)
+{
+	atomic_long_add(delta, &n->partial_free_objs);
+}
+
+static inline void
+__update_partial_total(struct kmem_cache_node *n, long delta)
+{
+	n->partial_total_objs += delta;
+}
+#else
+static inline void
+__update_partial_free(struct kmem_cache_node *n, long delta) { }
+
+static inline void
+__update_partial_total(struct kmem_cache_node *n, long delta) { }
+#endif
+
 static inline void
 __add_partial(struct kmem_cache_node *n, struct page *page, int tail)
 {
 	n->nr_partial++;
+	__update_partial_total(n, page->objects);
 	if (tail == DEACTIVATE_TO_TAIL)
 		list_add_tail(&page->slab_list, &n->partial);
 	else
@@ -1913,6 +1934,7 @@ static inline void remove_partial(struct
 	lockdep_assert_held(&n->list_lock);
 	list_del(&page->slab_list);
 	n->nr_partial--;
+	__update_partial_total(n, -page->objects);
 }
 
 /*
@@ -1957,6 +1979,7 @@ static inline void *acquire_slab(struct
 		return NULL;
 
 	remove_partial(n, page);
+	__update_partial_free(n, -*objects);
 	WARN_ON(!freelist);
 	return freelist;
 }
@@ -2286,8 +2309,11 @@ redo:
 				"unfreezing slab"))
 		goto redo;
 
-	if (lock)
+	if (lock) {
+		if (m == M_PARTIAL)
+			__update_partial_free(n, new.objects - new.inuse);
 		spin_unlock(&n->list_lock);
+	}
 
 	if (m == M_PARTIAL)
 		stat(s, tail);
@@ -2353,6 +2379,7 @@ static void unfreeze_partials(struct kme
 			discard_page = page;
 		} else {
 			add_partial(n, page, DEACTIVATE_TO_TAIL);
+			__update_partial_free(n, new.objects - new.inuse);
 			stat(s, FREE_ADD_PARTIAL);
 		}
 	}
@@ -3039,6 +3066,13 @@ static void __slab_free(struct kmem_cach
 		head, new.counters,
 		"__slab_free"));
 
+	if (!was_frozen && prior) {
+		if (n)
+			__update_partial_free(n, cnt);
+		else
+			__update_partial_free(get_node(s, page_to_nid(page)), cnt);
+	}
+
 	if (likely(!n)) {
 
 		if (likely(was_frozen)) {
@@ -3069,6 +3103,7 @@ static void __slab_free(struct kmem_cach
 	if (!kmem_cache_has_cpu_partial(s) && unlikely(!prior)) {
 		remove_full(s, n, page);
 		add_partial(n, page, DEACTIVATE_TO_TAIL);
+		__update_partial_free(n, cnt);
 		stat(s, FREE_ADD_PARTIAL);
 	}
 	spin_unlock_irqrestore(&n->list_lock, flags);
@@ -3080,6 +3115,7 @@ slab_empty:
 		 * Slab on the partial list.
 		 */
 		remove_partial(n, page);
+		__update_partial_free(n, -page->objects);
 		stat(s, FREE_REMOVE_PARTIAL);
 	} else {
 		/* Slab must be on the full list */
@@ -3520,6 +3556,10 @@ init_kmem_cache_node(struct kmem_cache_n
 	n->nr_partial = 0;
 	spin_lock_init(&n->list_lock);
 	INIT_LIST_HEAD(&n->partial);
+#if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SYSFS)
+	atomic_long_set(&n->partial_free_objs, 0);
+	n->partial_total_objs = 0;
+#endif
 #ifdef CONFIG_SLUB_DEBUG
 	atomic_long_set(&n->nr_slabs, 0);
 	atomic_long_set(&n->total_objects, 0);
@@ -3592,6 +3632,7 @@ static void early_kmem_cache_node_alloc(
 	 * initialized and there is no concurrent access.
 	 */
 	__add_partial(n, page, DEACTIVATE_TO_HEAD);
+	__update_partial_free(n, page->objects - page->inuse);
 }
 
 static void free_kmem_cache_nodes(struct kmem_cache *s)
@@ -3922,6 +3963,7 @@ static void free_partial(struct kmem_cac
 	list_for_each_entry_safe(page, h, &n->partial, slab_list) {
 		if (!page->inuse) {
 			remove_partial(n, page);
+			__update_partial_free(n, -page->objects);
 			list_add(&page->slab_list, &discard);
 		} else {
 			list_slab_objects(s, page,
@@ -4263,6 +4305,8 @@ int __kmem_cache_shrink(struct kmem_cach
 			if (free == page->objects) {
 				list_move(&page->slab_list, &discard);
 				n->nr_partial--;
+				__update_partial_free(n, -free);
+				__update_partial_total(n, -free);
 			} else if (free <= SHRINK_PROMOTE_MAX)
 				list_move(&page->slab_list, promote + free - 1);
 		}
_

Patches currently in -mm which might be from xlpang@linux.alibaba.com are

mm-slub-introduce-two-counters-for-partial-objects.patch
mm-slub-get-rid-of-count_partial.patch
percpu-export-per_cpu_sum.patch
mm-slub-use-percpu-partial-free-counter.patch

