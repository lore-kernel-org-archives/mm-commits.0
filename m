Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E9A7C4332F
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17B9F61100
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347509AbhIHCy0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:54:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347291AbhIHCyN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:54:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17B6D610C9;
        Wed,  8 Sep 2021 02:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069586;
        bh=Ga4Couddr396dCEe/4wWVWoAX+tGISvaf0iNFUsO1Bg=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=fs+ebpVAyH/hbjRcbvM3nDG5KWW3ZhKiTxM/w0eWs9NEMJ5NzKQNAoiST4wqb4C0e
         59UD6ykQElypWhXzrgyZrMHkgLgki+zE6mqAq34M/BXvpcvdZytKkEle+KFBNTvv6g
         Cc9ILeVc1bR5g626tHMbK9202VY9fivFwndFWOO0=
Date:   Tue, 07 Sep 2021 19:53:05 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 003/147] mm, slub: allocate private object map for
 validate_slab_cache()
Message-ID: <20210908025305.gswNP7HrX%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: allocate private object map for validate_slab_cache()

validate_slab_cache() is called either to handle a sysfs write, or from a
self-test context.  In both situations it's straightforward to preallocate
a private object bitmap instead of grabbing the shared static one meant
for critical sections, so let's do that.

Link: https://lkml.kernel.org/r/20210904105003.11688-4-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Qian Cai <quic_qiancai@quicinc.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/mm/slub.c~mm-slub-allocate-private-object-map-for-validate_slab_cache
+++ a/mm/slub.c
@@ -4679,11 +4679,11 @@ static int count_total(struct page *page
 #endif
 
 #ifdef CONFIG_SLUB_DEBUG
-static void validate_slab(struct kmem_cache *s, struct page *page)
+static void validate_slab(struct kmem_cache *s, struct page *page,
+			  unsigned long *obj_map)
 {
 	void *p;
 	void *addr = page_address(page);
-	unsigned long *map;
 
 	slab_lock(page);
 
@@ -4691,21 +4691,20 @@ static void validate_slab(struct kmem_ca
 		goto unlock;
 
 	/* Now we know that a valid freelist exists */
-	map = get_map(s, page);
+	__fill_map(obj_map, s, page);
 	for_each_object(p, s, addr, page->objects) {
-		u8 val = test_bit(__obj_to_index(s, addr, p), map) ?
+		u8 val = test_bit(__obj_to_index(s, addr, p), obj_map) ?
 			 SLUB_RED_INACTIVE : SLUB_RED_ACTIVE;
 
 		if (!check_object(s, page, p, val))
 			break;
 	}
-	put_map(map);
 unlock:
 	slab_unlock(page);
 }
 
 static int validate_slab_node(struct kmem_cache *s,
-		struct kmem_cache_node *n)
+		struct kmem_cache_node *n, unsigned long *obj_map)
 {
 	unsigned long count = 0;
 	struct page *page;
@@ -4714,7 +4713,7 @@ static int validate_slab_node(struct kme
 	spin_lock_irqsave(&n->list_lock, flags);
 
 	list_for_each_entry(page, &n->partial, slab_list) {
-		validate_slab(s, page);
+		validate_slab(s, page, obj_map);
 		count++;
 	}
 	if (count != n->nr_partial) {
@@ -4727,7 +4726,7 @@ static int validate_slab_node(struct kme
 		goto out;
 
 	list_for_each_entry(page, &n->full, slab_list) {
-		validate_slab(s, page);
+		validate_slab(s, page, obj_map);
 		count++;
 	}
 	if (count != atomic_long_read(&n->nr_slabs)) {
@@ -4746,10 +4745,17 @@ long validate_slab_cache(struct kmem_cac
 	int node;
 	unsigned long count = 0;
 	struct kmem_cache_node *n;
+	unsigned long *obj_map;
+
+	obj_map = bitmap_alloc(oo_objects(s->oo), GFP_KERNEL);
+	if (!obj_map)
+		return -ENOMEM;
 
 	flush_all(s);
 	for_each_kmem_cache_node(s, node, n)
-		count += validate_slab_node(s, n);
+		count += validate_slab_node(s, n, obj_map);
+
+	bitmap_free(obj_map);
 
 	return count;
 }
_
