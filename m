From: akpm@linux-foundation.org
Subject: [merged] mm-slab-fix-stale-code-comment.patch removed from -mm
 tree
Date: Wed, 16 Mar 2016 12:54:05 -0700
Message-ID: <56e9b9dd.BUQ5LqOf/3NCdiHD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190AbcCPTyG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 16 Mar 2016 15:54:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: iamjoonsoo.kim@lge.com, brouer@redhat.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: fix stale code comment
has been removed from the -mm tree.  Its filename was
     mm-slab-fix-stale-code-comment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/slab: fix stale code comment

This patchset implements new freed object management way, that is,
OBJFREELIST_SLAB.  Purpose of it is to reduce memory overhead in SLAB.

SLAB needs a array to manage freed objects in a slab.  If there is
leftover after objects are packed into a slab, we can use it as a
management array, and, in this case, there is no memory waste.  But, in
the other cases, we need to allocate extra memory for a management array
or utilize dedicated internal memory in a slab for it.  Both cases causes
memory waste so it's not good.

With this patchset, freed object itself can be used for a management
array.  So, memory waste could be reduced.  Detailed idea and numbers are
described in last patch's commit description.  Please refer it.

In fact, I tested another idea implementing OBJFREELIST_SLAB with
extendable linked array through another freed object.  It can remove
memory waste completely but it causes more computational overhead in
critical lock path and it seems that overhead outweigh benefit.  So, this
patchset doesn't include it.  I will attach prototype just for a
reference.



This patch (of 16):

We use freelist_idx_t type for free object management whose size would be
smaller than size of unsigned int.  Fix it.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slab.c~mm-slab-fix-stale-code-comment mm/slab.c
--- a/mm/slab.c~mm-slab-fix-stale-code-comment
+++ a/mm/slab.c
@@ -537,7 +537,7 @@ static void cache_estimate(unsigned long
 	 * on it. For the latter case, the memory allocated for a
 	 * slab is used for:
 	 *
-	 * - One unsigned int for each object
+	 * - One freelist_idx_t for each object
 	 * - Padding to respect alignment of @align
 	 * - @buffer_size bytes for each object
 	 *
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-vmalloc-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting.patch
mm-slub-query-dynamic-debug_pagealloc-setting-v2.patch
sound-query-dynamic-debug_pagealloc-setting.patch
powerpc-query-dynamic-debug_pagealloc-setting.patch
tile-query-dynamic-debug_pagealloc-setting.patch
mm-introduce-page-reference-manipulation-functions.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3.patch

