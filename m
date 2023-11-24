Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD21C61D97
	for <mm-commits@archiver.kernel.org>; Fri, 24 Nov 2023 19:59:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjKXT7H (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Nov 2023 14:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjKXT7H (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Nov 2023 14:59:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8936E10F6
        for <mm-commits@vger.kernel.org>; Fri, 24 Nov 2023 11:59:13 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D54C433C7;
        Fri, 24 Nov 2023 19:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700855953;
        bh=NuVZoxx9uTiBT0uZWEJ0mLDSuOmkdUXHWKN2CwuomY8=;
        h=Date:To:From:Subject:From;
        b=BD7ZGu0a+vgRLspkriuM3ADwjCRFARPWbdalh/pn2nTD0ZS3w1O7teZiocK4tDbWb
         a9MNjpQepF+zIjdIQOjb/bUsubbESiT3lsz1Q3oeNuZ52wI1jypAavi/Cl+Y/p/DQP
         wkHxmfvxnwYx1frS/r2rCris3OmAml29YHcUpRbQ=
Date:   Fri, 24 Nov 2023 11:59:12 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, feng.tang@intel.com, eugenis@google.com,
        elver@google.com, dvyukov@google.com, 42.hyeyoo@gmail.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + slub-kasan-improve-interaction-of-kasan-and-slub_debug-poisoning.patch added to mm-unstable branch
Message-Id: <20231124195913.28D54C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: slub, kasan: improve interaction of KASAN and slub_debug poisoning
has been added to the -mm mm-unstable branch.  Its filename is
     slub-kasan-improve-interaction-of-kasan-and-slub_debug-poisoning.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/slub-kasan-improve-interaction-of-kasan-and-slub_debug-poisoning.patch

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
Subject: slub, kasan: improve interaction of KASAN and slub_debug poisoning
Date: Thu, 23 Nov 2023 00:12:02 +0100

When both KASAN and slub_debug are enabled, when a free object is being
prepared in setup_object, slub_debug poisons the object data before KASAN
initializes its per-object metadata.

Right now, in setup_object, KASAN only initializes the alloc metadata,
which is always stored outside of the object.  slub_debug is aware of this
and it skips poisoning and checking that memory area.

However, with the following patch in this series, KASAN also starts
initializing its free medata in setup_object.  As this metadata might be
stored within the object, this initialization might overwrite the
slub_debug poisoning.  This leads to slub_debug reports.

Thus, skip checking slub_debug poisoning of the object data area that
overlaps with the in-object KASAN free metadata.

Also make slub_debug poisoning of tail kmalloc redzones more precise when
KASAN is enabled: slub_debug can still poison and check the tail kmalloc
allocation area that comes after the KASAN free metadata.

Link: https://lkml.kernel.org/r/20231122231202.121277-1-andrey.konovalov@linux.dev
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Tested-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

--- a/mm/slub.c~slub-kasan-improve-interaction-of-kasan-and-slub_debug-poisoning
+++ a/mm/slub.c
@@ -870,20 +870,20 @@ static inline void set_orig_size(struct
 				void *object, unsigned int orig_size)
 {
 	void *p = kasan_reset_tag(object);
+	unsigned int kasan_meta_size;
 
 	if (!slub_debug_orig_size(s))
 		return;
 
-#ifdef CONFIG_KASAN_GENERIC
 	/*
-	 * KASAN could save its free meta data in object's data area at
-	 * offset 0, if the size is larger than 'orig_size', it will
-	 * overlap the data redzone in [orig_size+1, object_size], and
-	 * the check should be skipped.
+	 * KASAN can save its free meta data inside of the object at offset 0.
+	 * If this meta data size is larger than 'orig_size', it will overlap
+	 * the data redzone in [orig_size+1, object_size]. Thus, we adjust
+	 * 'orig_size' to be as at least as big as KASAN's meta data.
 	 */
-	if (kasan_metadata_size(s, true) > orig_size)
-		orig_size = s->object_size;
-#endif
+	kasan_meta_size = kasan_metadata_size(s, true);
+	if (kasan_meta_size > orig_size)
+		orig_size = kasan_meta_size;
 
 	p += get_info_end(s);
 	p += sizeof(struct track) * 2;
@@ -1192,7 +1192,7 @@ static int check_object(struct kmem_cach
 {
 	u8 *p = object;
 	u8 *endobject = object + s->object_size;
-	unsigned int orig_size;
+	unsigned int orig_size, kasan_meta_size;
 
 	if (s->flags & SLAB_RED_ZONE) {
 		if (!check_bytes_and_report(s, slab, object, "Left Redzone",
@@ -1222,12 +1222,23 @@ static int check_object(struct kmem_cach
 	}
 
 	if (s->flags & SLAB_POISON) {
-		if (val != SLUB_RED_ACTIVE && (s->flags & __OBJECT_POISON) &&
-			(!check_bytes_and_report(s, slab, p, "Poison", p,
-					POISON_FREE, s->object_size - 1) ||
-			 !check_bytes_and_report(s, slab, p, "End Poison",
-				p + s->object_size - 1, POISON_END, 1)))
-			return 0;
+		if (val != SLUB_RED_ACTIVE && (s->flags & __OBJECT_POISON)) {
+			/*
+			 * KASAN can save its free meta data inside of the
+			 * object at offset 0. Thus, skip checking the part of
+			 * the redzone that overlaps with the meta data.
+			 */
+			kasan_meta_size = kasan_metadata_size(s, true);
+			if (kasan_meta_size < s->object_size - 1 &&
+			    !check_bytes_and_report(s, slab, p, "Poison",
+					p + kasan_meta_size, POISON_FREE,
+					s->object_size - kasan_meta_size - 1))
+				return 0;
+			if (kasan_meta_size < s->object_size &&
+			    !check_bytes_and_report(s, slab, p, "End Poison",
+					p + s->object_size - 1, POISON_END, 1))
+				return 0;
+		}
 		/*
 		 * check_pad_bytes cleans up on its own.
 		 */
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
slub-kasan-improve-interaction-of-kasan-and-slub_debug-poisoning.patch

