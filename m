Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC40FC433FE
	for <mm-commits@archiver.kernel.org>; Tue,  7 Sep 2021 21:18:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDE63610C9
	for <mm-commits@archiver.kernel.org>; Tue,  7 Sep 2021 21:18:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347076AbhIGVTu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Sep 2021 17:19:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:60224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243883AbhIGVTu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 7 Sep 2021 17:19:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FCFC61102;
        Tue,  7 Sep 2021 21:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1631049524;
        bh=KQKnP6xm6b5mia8RwZFCKpd9lzn37hBvbJOu9/6JCtM=;
        h=Date:From:To:Subject:From;
        b=2m1T9tb/Lj+4zH51BbjPPhFTopFz/ydoJ/CZt3u1Xvh89TO6LQ21GqCgYRWp5RSOK
         UZyj2khpsChy2b8vy1N820qFwOPRnRCJvYA6luO7Vvo+oi/Uawd4HtB6+rjEB4AoFt
         XHC5z6LC/vsVwtIXHcABjrIfx5g/h9wdFNGTBCRo=
Date:   Tue, 07 Sep 2021 14:18:43 -0700
From:   akpm@linux-foundation.org
To:     bigeasy@linutronix.de, brouer@redhat.com, cl@linux.com,
        efault@gmx.de, iamjoonsoo.kim@lge.com, jannh@google.com,
        mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        penberg@kernel.org, rientjes@google.com, tglx@linutronix.de,
        vbabka@suse.cz
Subject:  [to-be-updated]
 mm-slub-allocate-private-object-map-for-debugfs-listings.patch removed from
 -mm tree
Message-ID: <20210907211843.QN1pvhb7u%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: allocate private object map for debugfs listings
has been removed from the -mm tree.  Its filename was
     mm-slub-allocate-private-object-map-for-debugfs-listings.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
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

Link: https://lkml.kernel.org/r/20210805152000.12817-3-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Christoph Lameter <cl@linux.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Cc: David Rientjes <rientjes@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Pekka Enberg <penberg@kernel.org>
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

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-allocate-private-object-map-for-validate_slab_cache.patch
mm-slub-dont-disable-irq-for-debug_check_no_locks_freed.patch
mm-slub-remove-redundant-unfreeze_partials-from-put_cpu_partial.patch
mm-slub-extract-get_partial-from-new_slab_objects.patch
mm-slub-dissolve-new_slab_objects-into-___slab_alloc.patch
mm-slub-return-slab-page-from-get_partial-and-set-c-page-afterwards.patch
mm-slub-restructure-new-page-checks-in-___slab_alloc.patch
mm-slub-simplify-kmem_cache_cpu-and-tid-setup.patch
mm-slub-move-disabling-enabling-irqs-to-___slab_alloc.patch
mm-slub-do-initial-checks-in-___slab_alloc-with-irqs-enabled.patch
mm-slub-move-disabling-irqs-closer-to-get_partial-in-___slab_alloc.patch
mm-slub-restore-irqs-around-calling-new_slab.patch
mm-slub-validate-slab-from-partial-list-or-page-allocator-before-making-it-cpu-slab.patch
mm-slub-check-new-pages-with-restored-irqs.patch
mm-slub-stop-disabling-irqs-around-get_partial.patch
mm-slub-move-reset-of-c-page-and-freelist-out-of-deactivate_slab.patch
mm-slub-make-locking-in-deactivate_slab-irq-safe.patch
mm-slub-call-deactivate_slab-without-disabling-irqs.patch
mm-slub-move-irq-control-into-unfreeze_partials.patch
mm-slub-discard-slabs-in-unfreeze_partials-without-irqs-disabled.patch
mm-slub-detach-whole-partial-list-at-once-in-unfreeze_partials.patch
mm-slub-separate-detaching-of-partial-list-in-unfreeze_partials-from-unfreezing.patch
mm-slub-only-disable-irq-with-spin_lock-in-__unfreeze_partials.patch
mm-slub-dont-disable-irqs-in-slub_cpu_dead.patch
mm-slub-optionally-save-restore-irqs-in-slab_lock.patch
mm-slub-make-slab_lock-disable-irqs-with-preempt_rt.patch
mm-slub-protect-put_cpu_partial-with-disabled-irqs-instead-of-cmpxchg.patch
mm-slub-use-migrate_disable-on-preempt_rt.patch
mm-slub-convert-kmem_cpu_slab-protection-to-local_lock.patch
mm-slub-remove-conditional-locking-parameter-from-flush_slab.patch

