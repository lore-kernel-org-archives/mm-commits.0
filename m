From: akpm@linux-foundation.org
Subject: + mm-slub-introduce-kmem_cache_debug_flags-fix.patch added
 to -mm tree
Date: Sat, 20 Jun 2020 18:59:24 -0700
Message-ID: <20200621015924.2QO0q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:35100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbgFUB7Z (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 21:59:25 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, rientjes@google.com, penberg@kernel.org, keescook@chromium.org, jannh@google.com, iamjoonsoo.kim@lge.com, guro@fb.com, cl@linux.com, vbabka@suse.cz


The patch titled
     Subject: mm, slub: introduce kmem_cache_debug_flags()-fix
has been added to the -mm tree.  Its filename is
     mm-slub-introduce-kmem_cache_debug_flags-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-introduce-kmem_cache_debug_flags-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-introduce-kmem_cache_debug_flags-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm, slub: introduce kmem_cache_debug_flags()-fix

Change return from int to bool, per Kees.  Add VM_WARN_ON_ONCE() for
invalid flags, per Roman.

Link: http://lkml.kernel.org/r/949b90ed-e0f0-07d7-4d21-e30ec0958a7c@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-introduce-kmem_cache_debug_flags-fix
+++ a/mm/slub.c
@@ -127,16 +127,17 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabl
  * cache. Use only for flags parsed by setup_slub_debug() as it also enables
  * the static key.
  */
-static inline int kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t flags)
+static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t flags)
 {
+	VM_WARN_ON_ONCE(!(flags & SLAB_DEBUG_FLAGS));
 #ifdef CONFIG_SLUB_DEBUG
 	if (static_branch_unlikely(&slub_debug_enabled))
 		return s->flags & flags;
 #endif
-	return 0;
+	return false;
 }
 
-static inline int kmem_cache_debug(struct kmem_cache *s)
+static inline bool kmem_cache_debug(struct kmem_cache *s)
 {
 	return kmem_cache_debug_flags(s, SLAB_DEBUG_FLAGS);
 }
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-compaction-make-capture-control-handling-safe-wrt-interrupts.patch
mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch
mm-slub-make-some-slub_debug-related-attributes-read-only.patch
mm-slub-remove-runtime-allocation-order-changes.patch
mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch
mm-slub-make-reclaim_account-attribute-read-only.patch
mm-slub-introduce-static-key-for-slub_debug.patch
mm-slub-introduce-kmem_cache_debug_flags.patch
mm-slub-introduce-kmem_cache_debug_flags-fix.patch
mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch
mm-slab-slub-move-and-improve-cache_from_obj.patch
mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj.patch
mm-page_alloc-use-unlikely-in-task_capc.patch
