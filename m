From: akpm@linux-foundation.org
Subject: +
 mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 21:30:30 -0800
Message-ID: <56a855f6./MYFK897VgSwReI6%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36825 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbcA0Fab (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 00:30:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: do not change cache size if debug pagealloc isn't possible
has been added to the -mm tree.  Its filename is
     mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible.patch

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
Subject: mm/slab: do not change cache size if debug pagealloc isn't possible

We can fail to setup off slab in some conditions.  Even in this case,
debug pagealloc increases cache size to PAGE_SIZE in advance and it is
waste because debug pagealloc cannot work for it when it isn't the off
slab.  To improve this situation, this patch checks first that this cache
with increased size is suitable for off slab.  It actually increases cache
size when it is suitable for off-slab, so possible waste is removed.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/slab.c~mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible mm/slab.c
--- a/mm/slab.c~mm-slab-do-not-change-cache-size-if-debug-pagealloc-isnt-possible
+++ a/mm/slab.c
@@ -2207,10 +2207,17 @@ __kmem_cache_create (struct kmem_cache *
 	 */
 	if (debug_pagealloc_enabled() && (flags & SLAB_POISON) &&
 		!slab_early_init && size >= kmalloc_size(INDEX_NODE) &&
-		size >= 256 && cachep->object_size > cache_line_size() &&
-		size < PAGE_SIZE) {
-		cachep->obj_offset += PAGE_SIZE - size;
-		size = PAGE_SIZE;
+		size >= 256 && cachep->object_size > cache_line_size()) {
+		if (size < PAGE_SIZE || size % PAGE_SIZE == 0) {
+			size_t tmp_size = ALIGN(size, PAGE_SIZE);
+
+			if (set_off_slab_cache(cachep, tmp_size, flags)) {
+				flags |= CFLGS_OFF_SLAB;
+				cachep->obj_offset += tmp_size - size;
+				size = tmp_size;
+				goto done;
+			}
+		}
 	}
 #endif
 
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

