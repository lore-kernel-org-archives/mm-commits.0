From: akpm@linux-foundation.org
Subject: +
 mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
 added to -mm tree
Date: Tue, 26 Jan 2016 21:30:21 -0800
Message-ID: <56a855ed.2/AsAeBjfgStskje%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36807 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413AbcA0FaX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jan 2016 00:30:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, brouer@redhat.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: use more appropriate condition check for debug_pagealloc
has been added to the -mm tree.  Its filename is
     mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc.patch

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
Subject: mm/slab: use more appropriate condition check for debug_pagealloc

debug_pagealloc debugging is related to SLAB_POISON flag rather than
FORCED_DEBUG option, although FORCED_DEBUG option will enable SLAB_POISON.
Fix it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN mm/slab.c~mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc mm/slab.c
--- a/mm/slab.c~mm-slab-use-more-appropriate-condition-check-for-debug_pagealloc
+++ a/mm/slab.c
@@ -2169,7 +2169,6 @@ __kmem_cache_create (struct kmem_cache *
 		else
 			size += BYTES_PER_WORD;
 	}
-#if FORCED_DEBUG && defined(CONFIG_DEBUG_PAGEALLOC)
 	/*
 	 * To activate debug pagealloc, off-slab management is necessary
 	 * requirement. In early phase of initialization, small sized slab
@@ -2177,7 +2176,7 @@ __kmem_cache_create (struct kmem_cache *
 	 * to check size >= 256. It guarantees that all necessary small
 	 * sized slab is initialized in current slab initialization sequence.
 	 */
-	if (debug_pagealloc_enabled() &&
+	if (debug_pagealloc_enabled() && (flags & SLAB_POISON) &&
 		!slab_early_init && size >= kmalloc_size(INDEX_NODE) &&
 		size >= 256 && cachep->object_size > cache_line_size() &&
 		ALIGN(size, cachep->align) < PAGE_SIZE) {
@@ -2185,7 +2184,6 @@ __kmem_cache_create (struct kmem_cache *
 		size = PAGE_SIZE;
 	}
 #endif
-#endif
 
 	/*
 	 * Determine if the slab management is 'on' or 'off' slab.
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

