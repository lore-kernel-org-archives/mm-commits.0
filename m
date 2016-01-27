From: akpm@linux-foundation.org
Subject: +
 mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch added
 to -mm tree
Date: Tue, 26 Jan 2016 21:30:34 -0800
Message-ID: <56a855fa.IxKoGhHqPwqZCM8u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbcA0Faf (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 00:30:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: factor out debugging initialization in cache_init_objs()
has been added to the -mm tree.  Its filename is
     mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/slab: factor out debugging initialization in cache_init_objs()

cache_init_objs() will be changed in following patch and current form
doesn't fit well for that change.  So, before doing it, this patch
separates debugging initialization.  This would cause two loop iteration
when debugging is enabled, but, this overhead seems too light than debug
feature itself so effect may not be visible.  This patch will greatly
simplify changes in cache_init_objs() in following patch.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff -puN mm/slab.c~mm-slab-factor-out-debugging-initialization-in-cache_init_objs mm/slab.c
--- a/mm/slab.c~mm-slab-factor-out-debugging-initialization-in-cache_init_objs
+++ a/mm/slab.c
@@ -2461,14 +2461,14 @@ static inline void set_free_obj(struct p
 	((freelist_idx_t *)(page->freelist))[idx] = val;
 }
 
-static void cache_init_objs(struct kmem_cache *cachep,
-			    struct page *page)
+static void cache_init_objs_debug(struct kmem_cache *cachep, struct page *page)
 {
+#if DEBUG
 	int i;
 
 	for (i = 0; i < cachep->num; i++) {
 		void *objp = index_to_obj(cachep, page, i);
-#if DEBUG
+
 		if (cachep->flags & SLAB_STORE_USER)
 			*dbg_userword(cachep, objp) = NULL;
 
@@ -2497,10 +2497,22 @@ static void cache_init_objs(struct kmem_
 			poison_obj(cachep, objp, POISON_FREE);
 			slab_kernel_map(cachep, objp, 0, 0);
 		}
-#else
-		if (cachep->ctor)
-			cachep->ctor(objp);
+	}
 #endif
+}
+
+static void cache_init_objs(struct kmem_cache *cachep,
+			    struct page *page)
+{
+	int i;
+
+	cache_init_objs_debug(cachep, page);
+
+	for (i = 0; i < cachep->num; i++) {
+		/* constructor could break poison info */
+		if (DEBUG == 0 && cachep->ctor)
+			cachep->ctor(index_to_obj(cachep, page, i));
+
 		set_free_obj(page, i, i);
 	}
 }
_

Patches currently in -mm which might be from js1304@gmail.com are

mm-slab-fix-stale-code-comment.patch
mm-slab-remove-useless-structure-define.patch
mm-slab-remove-the-checks-for-slab-implementation-bug.patch
mm-slab-activate-debug_pagealloc-in-slab-when-it-is-actually-enabled.patch
mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
mm-slab-clean-up-debug_pagealloc-processing-code.patch
mm-slab-alternative-implementation-for-debug_slab_leak.patch
mm-slab-remove-object-status-buffer-for-debug_slab_leak.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page.patch
mm-slab-align-cache-size-first-before-determination-of-off_slab-candidate.patch
mm-slab-clean-up-cache-type-determination.patch
mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
mm-slab-make-criteria-for-off-slab-determination-robust-and-simple.patch
mm-slab-factor-out-slab-list-fixup-code.patch
mm-slab-factor-out-debugging-initialization-in-cache_init_objs.patch
mm-slab-introduce-new-slab-management-type-objfreelist_slab.patch

