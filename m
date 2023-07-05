Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2822EB64DA
	for <mm-commits@archiver.kernel.org>; Wed,  5 Jul 2023 15:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbjGEPyD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Jul 2023 11:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232726AbjGEPyB (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2023 11:54:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9637B133;
        Wed,  5 Jul 2023 08:53:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0732261600;
        Wed,  5 Jul 2023 15:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BA6C433C7;
        Wed,  5 Jul 2023 15:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688572438;
        bh=AEAtWD3d1LwbQvafKDuUpkOqzW4QebBziXMK3a5DQWw=;
        h=Date:To:From:Subject:From;
        b=1TDuRhte21jvghDngmgZCY2o6SgQcNGopp9eR66Q/Ya23mOnIqPYncbHEbfiXEUkF
         DKGfgXBgT5NU1PjNQg6Tf7AToleO0BEZhqdDvNQpdNhyL2j54IM6l2dz0vg+AEGt0y
         EyH2YB5VCzzxqBLIDzvGA8dCgfzmLwJFg073soks=
Date:   Wed, 05 Jul 2023 08:53:56 -0700
To:     mm-commits@vger.kernel.org, will@kernel.org,
        vincenzo.frascino@arm.com, vbabka@suse.cz, stable@vger.kernel.org,
        ryabinin.a.a@gmail.com, roman.gushchin@linux.dev,
        rientjes@google.com, penberg@kernel.org, pcc@google.com,
        mark.rutland@arm.com, iamjoonsoo.kim@lge.com, glider@google.com,
        feng.tang@intel.com, elver@google.com, dvyukov@google.com,
        cl@linux.com, catalin.marinas@arm.com, 42.hyeyoo@gmail.com,
        andreyknvl@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kasan-slub-fix-hw_tags-zeroing-with-slub_debug.patch added to mm-hotfixes-unstable branch
Message-Id: <20230705155358.53BA6C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kasan, slub: fix HW_TAGS zeroing with slub_debug
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kasan-slub-fix-hw_tags-zeroing-with-slub_debug.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kasan-slub-fix-hw_tags-zeroing-with-slub_debug.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: kasan, slub: fix HW_TAGS zeroing with slub_debug
Date: Wed, 5 Jul 2023 14:44:02 +0200

Commit 946fa0dbf2d8 ("mm/slub: extend redzone check to extra allocated
kmalloc space than requested") added precise kmalloc redzone poisoning to
the slub_debug functionality.

However, this commit didn't account for HW_TAGS KASAN fully initializing
the object via its built-in memory initialization feature.  Even though
HW_TAGS KASAN memory initialization contains special memory initialization
handling for when slub_debug is enabled, it does not account for in-object
slub_debug redzones.  As a result, HW_TAGS KASAN can overwrite these
redzones and cause false-positive slub_debug reports.

To fix the issue, avoid HW_TAGS KASAN memory initialization when
slub_debug is enabled altogether.  Implement this by moving the
__slub_debug_enabled check to slab_post_alloc_hook.  Common slab code
seems like a more appropriate place for a slub_debug check anyway.

Link: https://lkml.kernel.org/r/678ac92ab790dba9198f9ca14f405651b97c8502.1688561016.git.andreyknvl@google.com
Fixes: 946fa0dbf2d8 ("mm/slub: extend redzone check to extra allocated kmalloc space than requested")
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Reported-by: Will Deacon <will@kernel.org>
Acked-by: Marco Elver <elver@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: kasan-dev@googlegroups.com
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan.h |   12 ------------
 mm/slab.h        |   16 ++++++++++++++--
 2 files changed, 14 insertions(+), 14 deletions(-)

--- a/mm/kasan/kasan.h~kasan-slub-fix-hw_tags-zeroing-with-slub_debug
+++ a/mm/kasan/kasan.h
@@ -466,18 +466,6 @@ static inline void kasan_unpoison(const
 
 	if (WARN_ON((unsigned long)addr & KASAN_GRANULE_MASK))
 		return;
-	/*
-	 * Explicitly initialize the memory with the precise object size to
-	 * avoid overwriting the slab redzone. This disables initialization in
-	 * the arch code and may thus lead to performance penalty. This penalty
-	 * does not affect production builds, as slab redzones are not enabled
-	 * there.
-	 */
-	if (__slub_debug_enabled() &&
-	    init && ((unsigned long)size & KASAN_GRANULE_MASK)) {
-		init = false;
-		memzero_explicit((void *)addr, size);
-	}
 	size = round_up(size, KASAN_GRANULE_SIZE);
 
 	hw_set_mem_tag_range((void *)addr, size, tag, init);
--- a/mm/slab.h~kasan-slub-fix-hw_tags-zeroing-with-slub_debug
+++ a/mm/slab.h
@@ -723,6 +723,7 @@ static inline void slab_post_alloc_hook(
 					unsigned int orig_size)
 {
 	unsigned int zero_size = s->object_size;
+	bool kasan_init = init;
 	size_t i;
 
 	flags &= gfp_allowed_mask;
@@ -740,6 +741,17 @@ static inline void slab_post_alloc_hook(
 		zero_size = orig_size;
 
 	/*
+	 * When slub_debug is enabled, avoid memory initialization integrated
+	 * into KASAN and instead zero out the memory via the memset below with
+	 * the proper size. Otherwise, KASAN might overwrite SLUB redzones and
+	 * cause false-positive reports. This does not lead to a performance
+	 * penalty on production builds, as slub_debug is not intended to be
+	 * enabled there.
+	 */
+	if (__slub_debug_enabled())
+		kasan_init = false;
+
+	/*
 	 * As memory initialization might be integrated into KASAN,
 	 * kasan_slab_alloc and initialization memset must be
 	 * kept together to avoid discrepancies in behavior.
@@ -747,8 +759,8 @@ static inline void slab_post_alloc_hook(
 	 * As p[i] might get tagged, memset and kmemleak hook come after KASAN.
 	 */
 	for (i = 0; i < size; i++) {
-		p[i] = kasan_slab_alloc(s, p[i], flags, init);
-		if (p[i] && init && !kasan_has_integrated_init())
+		p[i] = kasan_slab_alloc(s, p[i], flags, kasan_init);
+		if (p[i] && init && (!kasan_init || !kasan_has_integrated_init()))
 			memset(p[i], 0, zero_size);
 		kmemleak_alloc_recursive(p[i], s->object_size, 1,
 					 s->flags, flags);
_

Patches currently in -mm which might be from andreyknvl@google.com are

kasan-fix-type-cast-in-memory_is_poisoned_n.patch
kasan-slub-fix-hw_tags-zeroing-with-slub_debug.patch

