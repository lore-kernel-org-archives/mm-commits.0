From: akpm@linux-foundation.org
Subject: + mm-slub-introduce-kmem_cache_debug_flags.patch added to
 -mm tree
Date: Wed, 17 Jun 2020 09:57:14 -0700
Message-ID: <20200617165714.RUZYe%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgFQQ5P (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 12:57:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, rientjes@google.com, penberg@kernel.org, keescook@chromium.org, jannh@google.com, iamjoonsoo.kim@lge.com, guro@fb.com, cl@linux.com, vbabka@suse.cz


The patch titled
     Subject: mm, slub: introduce kmem_cache_debug_flags()
has been added to the -mm tree.  Its filename is
     mm-slub-introduce-kmem_cache_debug_flags.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-introduce-kmem_cache_debug_flags.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-introduce-kmem_cache_debug_flags.patch

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
Subject: mm, slub: introduce kmem_cache_debug_flags()

There are few places that call kmem_cache_debug(s) (which tests if any of
debug flags are enabled for a cache) immediatelly followed by a test for a
specific flag.  The compiler can probably eliminate the extra check, but
we can make the code nicer by introducing kmem_cache_debug_flags() that
works like kmem_cache_debug() (including the static key check) but tests
for specific flag(s).  The next patches will add more users.

Link: http://lkml.kernel.org/r/20200610163135.17364-8-vbabka@suse.cz
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

 mm/slub.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/mm/slub.c~mm-slub-introduce-kmem_cache_debug_flags
+++ a/mm/slub.c
@@ -122,18 +122,28 @@ DEFINE_STATIC_KEY_FALSE(slub_debug_enabl
 #endif
 #endif
 
-static inline int kmem_cache_debug(struct kmem_cache *s)
+/*
+ * Returns true if any of the specified slub_debug flags is enabled for the
+ * cache. Use only for flags parsed by setup_slub_debug() as it also enables
+ * the static key.
+ */
+static inline int kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t flags)
 {
 #ifdef CONFIG_SLUB_DEBUG
 	if (static_branch_unlikely(&slub_debug_enabled))
-		return s->flags & SLAB_DEBUG_FLAGS;
+		return s->flags & flags;
 #endif
 	return 0;
 }
 
+static inline int kmem_cache_debug(struct kmem_cache *s)
+{
+	return kmem_cache_debug_flags(s, SLAB_DEBUG_FLAGS);
+}
+
 void *fixup_red_left(struct kmem_cache *s, void *p)
 {
-	if (kmem_cache_debug(s) && s->flags & SLAB_RED_ZONE)
+	if (kmem_cache_debug_flags(s, SLAB_RED_ZONE))
 		p += s->red_left_pad;
 
 	return p;
@@ -4076,7 +4086,7 @@ void __check_heap_object(const void *ptr
 	offset = (ptr - page_address(page)) % s->size;
 
 	/* Adjust for redzone and reject if within the redzone. */
-	if (kmem_cache_debug(s) && s->flags & SLAB_RED_ZONE) {
+	if (kmem_cache_debug_flags(s, SLAB_RED_ZONE)) {
 		if (offset < s->red_left_pad)
 			usercopy_abort("SLUB object in left red zone",
 				       s->name, to_user, offset, n);
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
