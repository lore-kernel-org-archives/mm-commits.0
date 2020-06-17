From: akpm@linux-foundation.org
Subject: +
 mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch added to -mm
 tree
Date: Wed, 17 Jun 2020 09:57:16 -0700
Message-ID: <20200617165716.DfSMo%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726329AbgFQQ5R (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Jun 2020 12:57:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vjitta@codeaurora.org, rientjes@google.com, penberg@kernel.org, keescook@chromium.org, jannh@google.com, iamjoonsoo.kim@lge.com, guro@fb.com, cl@linux.com, vbabka@suse.cz


The patch titled
     Subject: mm, slub: extend checks guarded by slub_debug static key
has been added to the -mm tree.  Its filename is
     mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-extend-checks-guarded-by-slub_debug-static-key.patch

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
Subject: mm, slub: extend checks guarded by slub_debug static key

There are few more places in SLUB that could benefit from reduced overhead
of the static key introduced by a previous patch:

- setup_object_debug() called on each object in newly allocated slab page
- setup_page_debug() called on newly allocated slab page
- __free_slab() called on freed slab page

Link: http://lkml.kernel.org/r/20200610163135.17364-9-vbabka@suse.cz
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

 mm/slub.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/slub.c~mm-slub-extend-checks-guarded-by-slub_debug-static-key
+++ a/mm/slub.c
@@ -1130,7 +1130,7 @@ static inline void dec_slabs_node(struct
 static void setup_object_debug(struct kmem_cache *s, struct page *page,
 								void *object)
 {
-	if (!(s->flags & (SLAB_STORE_USER|SLAB_RED_ZONE|__OBJECT_POISON)))
+	if (!kmem_cache_debug_flags(s, SLAB_STORE_USER|SLAB_RED_ZONE|__OBJECT_POISON))
 		return;
 
 	init_object(s, object, SLUB_RED_INACTIVE);
@@ -1140,7 +1140,7 @@ static void setup_object_debug(struct km
 static
 void setup_page_debug(struct kmem_cache *s, struct page *page, void *addr)
 {
-	if (!(s->flags & SLAB_POISON))
+	if (!kmem_cache_debug_flags(s, SLAB_POISON))
 		return;
 
 	metadata_access_enable();
@@ -1857,7 +1857,7 @@ static void __free_slab(struct kmem_cach
 	int order = compound_order(page);
 	int pages = 1 << order;
 
-	if (s->flags & SLAB_CONSISTENCY_CHECKS) {
+	if (kmem_cache_debug_flags(s, SLAB_CONSISTENCY_CHECKS)) {
 		void *p;
 
 		slab_pad_check(s, page);
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
