From: akpm@linux-foundation.org
Subject: + mm-slub-introduce-static-key-for-slub_debug.patch added
 to -mm tree
Date: Wed, 17 Jun 2020 09:57:12 -0700
Message-ID: <20200617165712.POp7s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgFQQ5O (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 12:57:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, rientjes@google.com, penberg@kernel.org, keescook@chromium.org, jannh@google.com, iamjoonsoo.kim@lge.com, guro@fb.com, cl@linux.com, vbabka@suse.cz


The patch titled
     Subject: mm, slub: introduce static key for slub_debug()
has been added to the -mm tree.  Its filename is
     mm-slub-introduce-static-key-for-slub_debug.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-introduce-static-key-for-slub_debug.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-introduce-static-key-for-slub_debug.patch

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
Subject: mm, slub: introduce static key for slub_debug()

One advantage of CONFIG_SLUB_DEBUG is that a generic distro kernel can be
built with the option enabled, but it's inactive until simply enabled on
boot, without rebuilding the kernel.  With a static key, we can further
eliminate the overhead of checking whether a cache has a particular debug
flag enabled if we know that there are no such caches (slub_debug was not
enabled during boot).  We use the same mechanism also for e.g. 
page_owner, debug_pagealloc or kmemcg functionality.

This patch introduces the static key and makes the general check for
per-cache debug flags kmem_cache_debug() use it.  This benefits several
call sites, including (slow path but still rather frequent) __slab_free().
The next patches will add more uses.

Link: http://lkml.kernel.org/r/20200610163135.17364-7-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Roman Gushchin <guro@fb.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Vijayanand Jitta <vjitta@codeaurora.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-introduce-static-key-for-slub_debug
+++ a/mm/slub.c
@@ -114,13 +114,21 @@
  * 			the fast path and disables lockless freelists.
  */
 
+#ifdef CONFIG_SLUB_DEBUG
+#ifdef CONFIG_SLUB_DEBUG_ON
+DEFINE_STATIC_KEY_TRUE(slub_debug_enabled);
+#else
+DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
+#endif
+#endif
+
 static inline int kmem_cache_debug(struct kmem_cache *s)
 {
 #ifdef CONFIG_SLUB_DEBUG
-	return unlikely(s->flags & SLAB_DEBUG_FLAGS);
-#else
-	return 0;
+	if (static_branch_unlikely(&slub_debug_enabled))
+		return s->flags & SLAB_DEBUG_FLAGS;
 #endif
+	return 0;
 }
 
 void *fixup_red_left(struct kmem_cache *s, void *p)
@@ -1389,6 +1397,8 @@ static int __init setup_slub_debug(char
 		slub_debug_string = saved_str;
 	}
 out:
+	if (slub_debug != 0 || slub_debug_string)
+		static_branch_enable(&slub_debug_enabled);
 	if ((static_branch_unlikely(&init_on_alloc) ||
 	     static_branch_unlikely(&init_on_free)) &&
 	    (slub_debug & SLAB_POISON))
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-extend-slub_debug-syntax-for-multiple-blocks.patch
mm-slub-make-some-slub_debug-related-attributes-read-only.patch
mm-slub-remove-runtime-allocation-order-changes.patch
mm-slub-make-remaining-slub_debug-related-attributes-read-only.patch
mm-slub-make-reclaim_account-attribute-read-only.patch
mm-slub-introduce-static-key-for-slub_debug.patch
mm-slub-introduce-kmem_cache_debug_flags.patch
mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch
mm-slab-slub-move-and-improve-cache_from_obj.patch
