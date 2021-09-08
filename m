Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D52C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA9BD61108
	for <mm-commits@archiver.kernel.org>; Wed,  8 Sep 2021 02:53:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347371AbhIHCyN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 22:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347339AbhIHCyK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 22:54:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA5E61101;
        Wed,  8 Sep 2021 02:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631069583;
        bh=+dxObjxH51aVY5Ln+C3HNBF7tR9KX13/wzZtl1/nrbs=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=jo4w/G/yEg7jmdk7s2Qv/b4p42zFLuDObX1xIv2QgTJkWEQe9dgK0vg58zEaIR/p+
         XpYtSmlzdOr4oiBlJkPv4duR4HbizqOS+qVAc27yMfq5sE4U1FrT3WNbTXfiq8QESM
         aqUvFqGnyX+BAJy2cebvyHbEq19CWElbqGkw/PrE=
Date:   Tue, 07 Sep 2021 19:53:02 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, bigeasy@linutronix.de,
        brouer@redhat.com, cl@linux.com, efault@gmx.de,
        iamjoonsoo.kim@lge.com, jannh@google.com, linux-mm@kvack.org,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, quic_qiancai@quicinc.com, rientjes@google.com,
        tglx@linutronix.de, torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 002/147] mm, slub: allocate private object map for
 debugfs listings
Message-ID: <20210908025302.DbvVlK0Us%akpm@linux-foundation.org>
In-Reply-To: <20210907195226.14b1d22a07c085b22968b933@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: allocate private object map for debugfs listings

Slub has a static spinlock protected bitmap for marking which objects are
on freelist when it wants to list them, for situations where dynamically
allocating such map can lead to recursion or locking issues, and on-stack
bitmap would be too large.

The handlers of debugfs files alloc_traces and free_traces also currently
use this shared bitmap, but their syscall context makes it straightforward
to allocate a private map before entering locked sections, so switch these
processing paths to use a private bitmap.

Link: https://lkml.kernel.org/r/20210904105003.11688-3-vbabka@suse.cz
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

 mm/slub.c |   44 +++++++++++++++++++++++++++++---------------
 1 file changed, 29 insertions(+), 15 deletions(-)

--- a/mm/slub.c~mm-slub-allocate-private-object-map-for-debugfs-listings
+++ a/mm/slub.c
@@ -454,6 +454,18 @@ static inline bool cmpxchg_double_slab(s
 static unsigned long object_map[BITS_TO_LONGS(MAX_OBJS_PER_PAGE)];
 static DEFINE_SPINLOCK(object_map_lock);
 
+static void __fill_map(unsigned long *obj_map, struct kmem_cache *s,
+		       struct page *page)
+{
+	void *addr = page_address(page);
+	void *p;
+
+	bitmap_zero(obj_map, page->objects);
+
+	for (p = page->freelist; p; p = get_freepointer(s, p))
+		set_bit(__obj_to_index(s, addr, p), obj_map);
+}
+
 #if IS_ENABLED(CONFIG_KUNIT)
 static bool slab_add_kunit_errors(void)
 {
@@ -483,17 +495,11 @@ static inline bool slab_add_kunit_errors
 static unsigned long *get_map(struct kmem_cache *s, struct page *page)
 	__acquires(&object_map_lock)
 {
-	void *p;
-	void *addr = page_address(page);
-
 	VM_BUG_ON(!irqs_disabled());
 
 	spin_lock(&object_map_lock);
 
-	bitmap_zero(object_map, page->objects);
-
-	for (p = page->freelist; p; p = get_freepointer(s, p))
-		set_bit(__obj_to_index(s, addr, p), object_map);
+	__fill_map(object_map, s, page);
 
 	return object_map;
 }
@@ -4879,17 +4885,17 @@ static int add_location(struct loc_track
 }
 
 static void process_slab(struct loc_track *t, struct kmem_cache *s,
-		struct page *page, enum track_item alloc)
+		struct page *page, enum track_item alloc,
+		unsigned long *obj_map)
 {
 	void *addr = page_address(page);
 	void *p;
-	unsigned long *map;
 
-	map = get_map(s, page);
+	__fill_map(obj_map, s, page);
+
 	for_each_object(p, s, addr, page->objects)
-		if (!test_bit(__obj_to_index(s, addr, p), map))
+		if (!test_bit(__obj_to_index(s, addr, p), obj_map))
 			add_location(t, s, get_track(s, p, alloc));
-	put_map(map);
 }
 #endif  /* CONFIG_DEBUG_FS   */
 #endif	/* CONFIG_SLUB_DEBUG */
@@ -5816,14 +5822,21 @@ static int slab_debug_trace_open(struct
 	struct loc_track *t = __seq_open_private(filep, &slab_debugfs_sops,
 						sizeof(struct loc_track));
 	struct kmem_cache *s = file_inode(filep)->i_private;
+	unsigned long *obj_map;
+
+	obj_map = bitmap_alloc(oo_objects(s->oo), GFP_KERNEL);
+	if (!obj_map)
+		return -ENOMEM;
 
 	if (strcmp(filep->f_path.dentry->d_name.name, "alloc_traces") == 0)
 		alloc = TRACK_ALLOC;
 	else
 		alloc = TRACK_FREE;
 
-	if (!alloc_loc_track(t, PAGE_SIZE / sizeof(struct location), GFP_KERNEL))
+	if (!alloc_loc_track(t, PAGE_SIZE / sizeof(struct location), GFP_KERNEL)) {
+		bitmap_free(obj_map);
 		return -ENOMEM;
+	}
 
 	for_each_kmem_cache_node(s, node, n) {
 		unsigned long flags;
@@ -5834,12 +5847,13 @@ static int slab_debug_trace_open(struct
 
 		spin_lock_irqsave(&n->list_lock, flags);
 		list_for_each_entry(page, &n->partial, slab_list)
-			process_slab(t, s, page, alloc);
+			process_slab(t, s, page, alloc, obj_map);
 		list_for_each_entry(page, &n->full, slab_list)
-			process_slab(t, s, page, alloc);
+			process_slab(t, s, page, alloc, obj_map);
 		spin_unlock_irqrestore(&n->list_lock, flags);
 	}
 
+	bitmap_free(obj_map);
 	return 0;
 }
 
_
