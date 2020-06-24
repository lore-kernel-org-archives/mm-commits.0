From: akpm@linux-foundation.org
Subject: +
 mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj-fix.patch
 added to -mm tree
Date: Wed, 24 Jun 2020 13:18:29 -0700
Message-ID: <20200624201829.q4YDj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:55364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406318AbgFXUSa (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Jun 2020 16:18:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, vinmenon@codeaurora.org, rong.a.chen@intel.com, rientjes@google.com, penberg@kernel.org, mjg59@google.com, keescook@chromium.org, jannh@google.com, iamjoonsoo.kim@lge.com, guro@fb.com, cl@linux.com, vbabka@suse.cz


The patch titled
     Subject: mm, slab/slub: improve error reporting and overhead of cache_from_obj()-fix
has been added to the -mm tree.  Its filename is
     mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj-fix.patch

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
Subject: mm, slab/slub: improve error reporting and overhead of cache_from_obj()-fix

The added VM_WARN_ON_ONCE triggers [1] with CONFIG_SLAB, as
SLAB_DEBUG_FLAGS doesn't include SLAB_CONSISTENCY_CHECKS.  Move the check
under #ifdef SLUB_DEBUG.

[1] https://lore.kernel.org/r/20200623090213.GW5535@shao2-debian

Link: http://lkml.kernel.org/r/b33e0fa7-cd28-4788-9e54-5927846329ef@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: kernel test robot <rong.a.chen@intel.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Matthew Garrett <mjg59@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: Vinayak Menon <vinmenon@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slab.h~mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj-fix
+++ a/mm/slab.h
@@ -295,8 +295,8 @@ static inline void print_tracking(struct
  */
 static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t flags)
 {
-	VM_WARN_ON_ONCE(!(flags & SLAB_DEBUG_FLAGS));
 #ifdef CONFIG_SLUB_DEBUG
+	VM_WARN_ON_ONCE(!(flags & SLAB_DEBUG_FLAGS));
 	if (static_branch_unlikely(&slub_debug_enabled))
 		return s->flags & flags;
 #endif
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
mm-slab-slub-improve-error-reporting-and-overhead-of-cache_from_obj-fix.patch
mm-page_alloc-use-unlikely-in-task_capc.patch
