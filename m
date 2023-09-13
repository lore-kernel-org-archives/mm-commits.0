Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB0DEE020C
	for <mm-commits@archiver.kernel.org>; Wed, 13 Sep 2023 19:29:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjIMT3d (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Sep 2023 15:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232500AbjIMT3X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2023 15:29:23 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EAAB7
        for <mm-commits@vger.kernel.org>; Wed, 13 Sep 2023 12:29:19 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D63AC433C8;
        Wed, 13 Sep 2023 19:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694633359;
        bh=rH5qtFXrUqI/f22Vq00zvf68/Eg8IEWAmTFXpOGKKFQ=;
        h=Date:To:From:Subject:From;
        b=d3ZBxQyCrOrOjWKwX70Bt50By7/5UTPbUgvpELAJv62j0kiDPiLauooVfBqJEf089
         5sqsHVRgZaWrWA8gyAqUL855bncdJiXgNeIyx4nwxqaVy9KvtJZak9xmit58ACd6xb
         xL+cz6CWnM8GV+aSqrDQDLFRf6YRXJ3QtsiV9qGc=
Date:   Wed, 13 Sep 2023 12:29:18 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, osalvador@suse.de,
        glider@google.com, eugenis@google.com, elver@google.com,
        dvyukov@google.com, andreyknvl@gmail.com, andreyknvl@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-use-stack_depot_put-for-tag-based-modes.patch added to mm-unstable branch
Message-Id: <20230913192919.0D63AC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan: use stack_depot_put for tag-based modes
has been added to the -mm mm-unstable branch.  Its filename is
     kasan-use-stack_depot_put-for-tag-based-modes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-use-stack_depot_put-for-tag-based-modes.patch

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
Subject: kasan: use stack_depot_put for tag-based modes
Date: Wed, 13 Sep 2023 19:14:44 +0200

Make tag-based KASAN modes to evict stack traces from the stack depot once
they are evicted from the stack ring.

Internally, pass STACK_DEPOT_FLAG_GET to stack_depot_save_flags (via
kasan_save_stack) to increment the refcount when saving a new entry to
stack ring and call stack_depot_put when removing an entry from stack
ring.

Link: https://lkml.kernel.org/r/6e2367e7693aa107f05c649abe06180fff847bb4.1694625260.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/report_tags.c |    1 +
 mm/kasan/tags.c        |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

--- a/mm/kasan/report_tags.c~kasan-use-stack_depot_put-for-tag-based-modes
+++ a/mm/kasan/report_tags.c
@@ -7,6 +7,7 @@
 #include <linux/atomic.h>
 
 #include "kasan.h"
+#include "../slab.h"
 
 extern struct kasan_stack_ring stack_ring;
 
--- a/mm/kasan/tags.c~kasan-use-stack_depot_put-for-tag-based-modes
+++ a/mm/kasan/tags.c
@@ -97,12 +97,13 @@ static void save_stack_info(struct kmem_
 			gfp_t gfp_flags, bool is_free)
 {
 	unsigned long flags;
-	depot_stack_handle_t stack;
+	depot_stack_handle_t stack, old_stack;
 	u64 pos;
 	struct kasan_stack_ring_entry *entry;
 	void *old_ptr;
 
-	stack = kasan_save_stack(gfp_flags, STACK_DEPOT_FLAG_CAN_ALLOC);
+	stack = kasan_save_stack(gfp_flags,
+			STACK_DEPOT_FLAG_CAN_ALLOC | STACK_DEPOT_FLAG_GET);
 
 	/*
 	 * Prevent save_stack_info() from modifying stack ring
@@ -121,6 +122,8 @@ next:
 	if (!try_cmpxchg(&entry->ptr, &old_ptr, STACK_RING_BUSY_PTR))
 		goto next; /* Busy slot. */
 
+	old_stack = entry->stack;
+
 	entry->size = cache->object_size;
 	entry->pid = current->pid;
 	entry->stack = stack;
@@ -129,6 +132,9 @@ next:
 	entry->ptr = object;
 
 	read_unlock_irqrestore(&stack_ring.lock, flags);
+
+	if (old_stack)
+		stack_depot_put(old_stack);
 }
 
 void kasan_save_alloc_info(struct kmem_cache *cache, void *object, gfp_t flags)
_

Patches currently in -mm which might be from andreyknvl@google.com are

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

