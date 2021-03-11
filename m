Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B90C433E0
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:15:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D6DD64F7B
	for <mm-commits@archiver.kernel.org>; Thu, 11 Mar 2021 22:15:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhCKWPF (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 11 Mar 2021 17:15:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:49748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230422AbhCKWPF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 11 Mar 2021 17:15:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3311E64F7B;
        Thu, 11 Mar 2021 22:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615500904;
        bh=g1/TE9J6Oo2gzFI2ITqxIjt8M7jAYr3gqfS0M45AoCE=;
        h=Date:From:To:Subject:From;
        b=THuCc2/UtEYxH3hAfoR6YdMqPZQR9CBAQvEaaCBXfF7fwmLDmPRiit6wRitHLR+ms
         C6wois/lsgT7TfLVvk6htyCDL5L9IbtCttaozB/QYB9HPz15QWavDsqE3Qut706Nfs
         mAAyjOGfoeNHsE75RQs9K1vx526Eeo1RnDBP93xA=
Date:   Thu, 11 Mar 2021 14:15:03 -0800
From:   akpm@linux-foundation.org
To:     cl@linux.com, guro@fb.com, iamjoonsoo.kim@lge.com,
        jnwang@linux.alibaba.com, khlebnikov@yandex-team.ru,
        mm-commits@vger.kernel.org, penberg@kernel.org,
        rientjes@google.com, sming56@gmail.com, vbabka@suse.cz,
        wenyang@linux.alibaba.com, willy@infradead.org,
        xlpang@linux.alibaba.com
Subject:  + mm-slub-get-rid-of-count_partial.patch added to -mm
 tree
Message-ID: <20210311221503.bExvAVa2N%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: get rid of count_partial()
has been added to the -mm tree.  Its filename is
     mm-slub-get-rid-of-count_partial.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-get-rid-of-count_partial.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-get-rid-of-count_partial.patch

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
Subject: mm/slub: get rid of count_partial()

Now the partial counters are ready, let's use them directly and get rid of
count_partial().

Link: https://lkml.kernel.org/r/1615303512-35058-3-git-send-email-xlpang@linux.alibaba.com
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

 mm/slub.c |   54 +++++++++++++++++++++-------------------------------
 1 file changed, 22 insertions(+), 32 deletions(-)

--- a/mm/slub.c~mm-slub-get-rid-of-count_partial
+++ a/mm/slub.c
@@ -2533,11 +2533,6 @@ static inline int node_match(struct page
 }
 
 #ifdef CONFIG_SLUB_DEBUG
-static int count_free(struct page *page)
-{
-	return page->objects - page->inuse;
-}
-
 static inline unsigned long node_nr_objs(struct kmem_cache_node *n)
 {
 	return atomic_long_read(&n->total_objects);
@@ -2545,19 +2540,26 @@ static inline unsigned long node_nr_objs
 #endif /* CONFIG_SLUB_DEBUG */
 
 #if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SYSFS)
-static unsigned long count_partial(struct kmem_cache_node *n,
-					int (*get_count)(struct page *))
+enum partial_item { PARTIAL_FREE, PARTIAL_INUSE, PARTIAL_TOTAL };
+
+static unsigned long partial_counter(struct kmem_cache_node *n,
+		enum partial_item item)
 {
-	unsigned long flags;
-	unsigned long x = 0;
-	struct page *page;
+	unsigned long ret = 0;
 
-	spin_lock_irqsave(&n->list_lock, flags);
-	list_for_each_entry(page, &n->partial, slab_list)
-		x += get_count(page);
-	spin_unlock_irqrestore(&n->list_lock, flags);
-	return x;
+	if (item == PARTIAL_FREE) {
+		ret = atomic_long_read(&n->partial_free_objs);
+	} else if (item == PARTIAL_TOTAL) {
+		ret = n->partial_total_objs;
+	} else if (item == PARTIAL_INUSE) {
+		ret = n->partial_total_objs - atomic_long_read(&n->partial_free_objs);
+		if ((long)ret < 0)
+			ret = 0;
+	}
+
+	return ret;
 }
+
 #endif /* CONFIG_SLUB_DEBUG || CONFIG_SYSFS */
 
 static noinline void
@@ -2587,7 +2589,7 @@ slab_out_of_memory(struct kmem_cache *s,
 		unsigned long nr_objs;
 		unsigned long nr_free;
 
-		nr_free  = count_partial(n, count_free);
+		nr_free  = partial_counter(n, PARTIAL_FREE);
 		nr_slabs = node_nr_slabs(n);
 		nr_objs  = node_nr_objs(n);
 
@@ -4643,18 +4645,6 @@ void *__kmalloc_node_track_caller(size_t
 EXPORT_SYMBOL(__kmalloc_node_track_caller);
 #endif
 
-#ifdef CONFIG_SYSFS
-static int count_inuse(struct page *page)
-{
-	return page->inuse;
-}
-
-static int count_total(struct page *page)
-{
-	return page->objects;
-}
-#endif
-
 #ifdef CONFIG_SLUB_DEBUG
 static void validate_slab(struct kmem_cache *s, struct page *page)
 {
@@ -5091,7 +5081,7 @@ static ssize_t show_slab_objects(struct
 				x = atomic_long_read(&n->total_objects);
 			else if (flags & SO_OBJECTS)
 				x = atomic_long_read(&n->total_objects) -
-					count_partial(n, count_free);
+					partial_counter(n, PARTIAL_FREE);
 			else
 				x = atomic_long_read(&n->nr_slabs);
 			total += x;
@@ -5105,9 +5095,9 @@ static ssize_t show_slab_objects(struct
 
 		for_each_kmem_cache_node(s, node, n) {
 			if (flags & SO_TOTAL)
-				x = count_partial(n, count_total);
+				x = partial_counter(n, PARTIAL_TOTAL);
 			else if (flags & SO_OBJECTS)
-				x = count_partial(n, count_inuse);
+				x = partial_counter(n, PARTIAL_INUSE);
 			else
 				x = n->nr_partial;
 			total += x;
@@ -5873,7 +5863,7 @@ void get_slabinfo(struct kmem_cache *s,
 	for_each_kmem_cache_node(s, node, n) {
 		nr_slabs += node_nr_slabs(n);
 		nr_objs += node_nr_objs(n);
-		nr_free += count_partial(n, count_free);
+		nr_free += partial_counter(n, PARTIAL_FREE);
 	}
 
 	sinfo->active_objs = nr_objs - nr_free;
_

Patches currently in -mm which might be from xlpang@linux.alibaba.com are

mm-slub-introduce-two-counters-for-partial-objects.patch
mm-slub-get-rid-of-count_partial.patch
percpu-export-per_cpu_sum.patch
mm-slub-use-percpu-partial-free-counter.patch

