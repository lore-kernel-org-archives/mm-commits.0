From: akpm@linux-foundation.org
Subject: + mm-slab-factor-out-slab-list-fixup-code.patch added to -mm tree
Date: Tue, 26 Jan 2016 21:30:33 -0800
Message-ID: <56a855f9.XSvt26j/qRXVdbpq%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36864 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbcA0Fae (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 00:30:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: factor out slab list fixup code
has been added to the -mm tree.  Its filename is
     mm-slab-factor-out-slab-list-fixup-code.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-factor-out-slab-list-fixup-code.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-factor-out-slab-list-fixup-code.patch

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
Subject: mm/slab: factor out slab list fixup code

Slab list should be fixed up after object is detached from the slab and
this happens at two places.  They do exactly same thing.  They will be
changed in the following patch, so, to reduce code duplication, this patch
factor out them and make it common function.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff -puN mm/slab.c~mm-slab-factor-out-slab-list-fixup-code mm/slab.c
--- a/mm/slab.c~mm-slab-factor-out-slab-list-fixup-code
+++ a/mm/slab.c
@@ -2724,6 +2724,17 @@ static void *cache_free_debugcheck(struc
 #define cache_free_debugcheck(x,objp,z) (objp)
 #endif
 
+static inline void fixup_slab_list(struct kmem_cache *cachep,
+				struct kmem_cache_node *n, struct page *page)
+{
+	/* move slabp to correct slabp list: */
+	list_del(&page->lru);
+	if (page->active == cachep->num)
+		list_add(&page->lru, &n->slabs_full);
+	else
+		list_add(&page->lru, &n->slabs_partial);
+}
+
 static struct page *get_first_slab(struct kmem_cache_node *n)
 {
 	struct page *page;
@@ -2797,12 +2808,7 @@ retry:
 			ac_put_obj(cachep, ac, slab_get_obj(cachep, page));
 		}
 
-		/* move slabp to correct slabp list: */
-		list_del(&page->lru);
-		if (page->active == cachep->num)
-			list_add(&page->lru, &n->slabs_full);
-		else
-			list_add(&page->lru, &n->slabs_partial);
+		fixup_slab_list(cachep, n, page);
 	}
 
 must_grow:
@@ -3068,13 +3074,8 @@ retry:
 
 	obj = slab_get_obj(cachep, page);
 	n->free_objects--;
-	/* move slabp to correct slabp list: */
-	list_del(&page->lru);
 
-	if (page->active == cachep->num)
-		list_add(&page->lru, &n->slabs_full);
-	else
-		list_add(&page->lru, &n->slabs_partial);
+	fixup_slab_list(cachep, n, page);
 
 	spin_unlock(&n->list_lock);
 	goto done;
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

