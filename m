Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE94C5AE5C
	for <mm-commits@archiver.kernel.org>; Mon, 20 Nov 2023 18:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234190AbjKTSE1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 20 Nov 2023 13:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234194AbjKTSET (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2023 13:04:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E409BC8
        for <mm-commits@vger.kernel.org>; Mon, 20 Nov 2023 10:04:12 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822B5C433C7;
        Mon, 20 Nov 2023 18:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700503452;
        bh=5hWHUnivgBU9AfusvOLzWx6obipEdimPXo0mFu6tY+U=;
        h=Date:To:From:Subject:From;
        b=PGXoYRqnO/PfIErKPTjPAY4YL3OK0/y0haNzwvAkRQzDbp1VUyzkqNRxggRERiVHr
         3u7GRYbkHvj6UhK1MHwUJ08G8IHJhuoBi+dQIEysh5IE6nRxBlTaQMsyPrbO6HON4q
         QKQwEy6T54BFKSYF42T81y1qq1eOU+vaGXMn1Mgo=
Date:   Mon, 20 Nov 2023 10:04:10 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-use-stack_depot_put-for-generic-mode.patch added to mm-unstable branch
Message-Id: <20231120180412.822B5C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use stack_depot_put for Generic mode
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-use-stack_depot_put-for-generic-mode.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-use-stack_depot_put-for-generic-mode.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrey Konovalov <andreyknvl@google.com>
Subject: kasan: use stack_depot_put for Generic mode
Date: Mon, 20 Nov 2023 18:47:19 +0100

Evict alloc/free stack traces from the stack depot for Generic KASAN once
they are evicted from the quaratine.

For auxiliary stack traces, evict the oldest stack trace once a new one is
saved (KASAN only keeps references to the last two).

Also evict all saved stack traces on krealloc.

To avoid double-evicting and mis-evicting stack traces (in case KASAN's
metadata was corrupted), reset KASAN's per-object metadata that stores
stack depot handles when the object is initialized and when it's evicted
from the quarantine.

Note that stack_depot_put is no-op if the handle is 0.

Link: https://lkml.kernel.org/r/5cef104d9b842899489b4054fe8d1339a71acee0.1700502145.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/common.c     |    3 ++-
 mm/kasan/generic.c    |   22 ++++++++++++++++++----
 mm/kasan/quarantine.c |   26 ++++++++++++++++++++------
 3 files changed, 40 insertions(+), 11 deletions(-)

--- a/mm/kasan/common.c~kasan-use-stack_depot_put-for-generic-mode
+++ a/mm/kasan/common.c
@@ -50,7 +50,8 @@ depot_stack_handle_t kasan_save_stack(gf
 void kasan_set_track(struct kasan_track *track, gfp_t flags)
 {
 	track->pid = current->pid;
-	track->stack = kasan_save_stack(flags, STACK_DEPOT_FLAG_CAN_ALLOC);
+	track->stack = kasan_save_stack(flags,
+			STACK_DEPOT_FLAG_CAN_ALLOC | STACK_DEPOT_FLAG_GET);
 }
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
--- a/mm/kasan/generic.c~kasan-use-stack_depot_put-for-generic-mode
+++ a/mm/kasan/generic.c
@@ -449,10 +449,14 @@ struct kasan_free_meta *kasan_get_free_m
 void kasan_init_object_meta(struct kmem_cache *cache, const void *object)
 {
 	struct kasan_alloc_meta *alloc_meta;
+	struct kasan_free_meta *free_meta;
 
 	alloc_meta = kasan_get_alloc_meta(cache, object);
 	if (alloc_meta)
 		__memset(alloc_meta, 0, sizeof(*alloc_meta));
+	free_meta = kasan_get_free_meta(cache, object);
+	if (free_meta)
+		__memset(free_meta, 0, sizeof(*free_meta));
 }
 
 size_t kasan_metadata_size(struct kmem_cache *cache, bool in_object)
@@ -489,18 +493,20 @@ static void __kasan_record_aux_stack(voi
 	if (!alloc_meta)
 		return;
 
+	stack_depot_put(alloc_meta->aux_stack[1]);
 	alloc_meta->aux_stack[1] = alloc_meta->aux_stack[0];
 	alloc_meta->aux_stack[0] = kasan_save_stack(0, depot_flags);
 }
 
 void kasan_record_aux_stack(void *addr)
 {
-	return __kasan_record_aux_stack(addr, STACK_DEPOT_FLAG_CAN_ALLOC);
+	return __kasan_record_aux_stack(addr,
+			STACK_DEPOT_FLAG_CAN_ALLOC | STACK_DEPOT_FLAG_GET);
 }
 
 void kasan_record_aux_stack_noalloc(void *addr)
 {
-	return __kasan_record_aux_stack(addr, 0);
+	return __kasan_record_aux_stack(addr, STACK_DEPOT_FLAG_GET);
 }
 
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
@@ -508,8 +514,16 @@ void kasan_save_alloc_info(struct kmem_c
 	struct kasan_alloc_meta *alloc_meta;
 
 	alloc_meta = kasan_get_alloc_meta(cache, object);
-	if (alloc_meta)
-		kasan_set_track(&alloc_meta->alloc_track, flags);
+	if (!alloc_meta)
+		return;
+
+	/* Evict previous stack traces (might exist for krealloc). */
+	stack_depot_put(alloc_meta->alloc_track.stack);
+	stack_depot_put(alloc_meta->aux_stack[0]);
+	stack_depot_put(alloc_meta->aux_stack[1]);
+	__memset(alloc_meta, 0, sizeof(*alloc_meta));
+
+	kasan_set_track(&alloc_meta->alloc_track, flags);
 }
 
 void kasan_save_free_info(struct kmem_cache *cache, void *object)
--- a/mm/kasan/quarantine.c~kasan-use-stack_depot_put-for-generic-mode
+++ a/mm/kasan/quarantine.c
@@ -143,11 +143,22 @@ static void *qlink_to_object(struct qlis
 static void qlink_free(struct qlist_node *qlink, struct kmem_cache *cache)
 {
 	void *object = qlink_to_object(qlink, cache);
-	struct kasan_free_meta *meta = kasan_get_free_meta(cache, object);
+	struct kasan_alloc_meta *alloc_meta = kasan_get_alloc_meta(cache, object);
+	struct kasan_free_meta *free_meta = kasan_get_free_meta(cache, object);
 	unsigned long flags;
 
-	if (IS_ENABLED(CONFIG_SLAB))
-		local_irq_save(flags);
+	if (alloc_meta) {
+		stack_depot_put(alloc_meta->alloc_track.stack);
+		stack_depot_put(alloc_meta->aux_stack[0]);
+		stack_depot_put(alloc_meta->aux_stack[1]);
+		__memset(alloc_meta, 0, sizeof(*alloc_meta));
+	}
+
+	if (free_meta &&
+	    *(u8 *)kasan_mem_to_shadow(object) == KASAN_SLAB_FREETRACK) {
+		stack_depot_put(free_meta->free_track.stack);
+		free_meta->free_track.stack = 0;
+	}
 
 	/*
 	 * If init_on_free is enabled and KASAN's free metadata is stored in
@@ -157,14 +168,17 @@ static void qlink_free(struct qlist_node
 	 */
 	if (slab_want_init_on_free(cache) &&
 	    cache->kasan_info.free_meta_offset == 0)
-		memzero_explicit(meta, sizeof(*meta));
+		memzero_explicit(free_meta, sizeof(*free_meta));
 
 	/*
-	 * As the object now gets freed from the quarantine, assume that its
-	 * free track is no longer valid.
+	 * As the object now gets freed from the quarantine,
+	 * take note that its free track is no longer exists.
 	 */
 	*(u8 *)kasan_mem_to_shadow(object) = KASAN_SLAB_FREE;
 
+	if (IS_ENABLED(CONFIG_SLAB))
+		local_irq_save(flags);
+
 	___cache_free(cache, object, _THIS_IP_);
 
 	if (IS_ENABLED(CONFIG_SLAB))
_

Patches currently in -mm which might be from andreyknvl@google.com are

lib-stackdepot-print-disabled-message-only-if-truly-disabled.patch
lib-stackdepot-check-disabled-flag-when-fetching.patch
lib-stackdepot-simplify-__stack_depot_save.patch
lib-stackdepot-drop-valid-bit-from-handles.patch
lib-stackdepot-add-depot_fetch_stack-helper.patch
lib-stackdepot-use-fixed-sized-slots-for-stack-records.patch
lib-stackdepot-fix-and-clean-up-atomic-annotations.patch
lib-stackdepot-rework-helpers-for-depot_alloc_stack.patch
lib-stackdepot-rename-next_pool_required-to-new_pool_required.patch
lib-stackdepot-store-next-pool-pointer-in-new_pool.patch
lib-stackdepot-store-free-stack-records-in-a-freelist.patch
lib-stackdepot-use-read-write-lock.patch
lib-stackdepot-use-list_head-for-stack-record-links.patch
kmsan-use-stack_depot_save-instead-of-__stack_depot_save.patch
lib-stackdepot-kasan-add-flags-to-__stack_depot_save-and-rename.patch
lib-stackdepot-add-refcount-for-records.patch
lib-stackdepot-allow-users-to-evict-stack-traces.patch
kasan-remove-atomic-accesses-to-stack-ring-entries.patch
kasan-check-object_size-in-kasan_complete_mode_report_info.patch
kasan-use-stack_depot_put-for-tag-based-modes.patch
kasan-use-stack_depot_put-for-generic-mode.patch
lib-stackdepot-adjust-depot_pools_cap-for-kmsan.patch

