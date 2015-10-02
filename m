From: akpm@linux-foundation.org
Subject: [merged]
 mm-slab-fix-unexpected-index-mapping-result-of-kmalloc_sizeindex_node1.patch removed from -mm tree
Date: Fri, 02 Oct 2015 12:36:16 -0700
Message-ID: <560edcb0.yFHuHIOliY2evBrN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59668 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbbJBTgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Oct 2015 15:36:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: js1304@gmail.com, cl@linux.com, iamjoonsoo.kim@lge.com, liu.hailong6@zte.com.cn, penberg@kernel.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slab: fix unexpected index mapping result of kmalloc_size(INDEX_NODE+1)
has been removed from the -mm tree.  Its filename was
     mm-slab-fix-unexpected-index-mapping-result-of-kmalloc_sizeindex_node1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <js1304@gmail.com>
Subject: mm/slab: fix unexpected index mapping result of kmalloc_size(INDEX_NODE+1)

Commit description is copied from original post of this bug.

http://comments.gmane.org/gmane.linux.kernel.mm/135349

Kernels after v3.9 use kmalloc_size(INDEX_NODE + 1) to get the next larger
cache size than the size index INDEX_NODE mapping.  In kernels 3.9 and
earlier we used malloc_sizes[INDEX_L3 + 1].cs_size.

However, sometimes we can't get the right output we expected via
kmalloc_size(INDEX_NODE + 1), causing a BUG().

The mapping table in the latest kernel is like:
    index = {0,   1,  2 ,  3,  4,   5,   6,   n}
     size = {0,   96, 192, 8, 16,  32,  64,   2^n}
The mapping table before 3.10 is like this:
    index = {0 , 1 , 2,   3,  4 ,  5 ,  6,   n}
    size  = {32, 64, 96, 128, 192, 256, 512, 2^(n+3)}

The problem on my mips64 machine is as follows:

(1) When configured DEBUG_SLAB && DEBUG_PAGEALLOC && DEBUG_LOCK_ALLOC
    && DEBUG_SPINLOCK, the sizeof(struct kmem_cache_node) will be "150",
    and the macro INDEX_NODE turns out to be "2": #define INDEX_NODE
    kmalloc_index(sizeof(struct kmem_cache_node))

(2) Then the result of kmalloc_size(INDEX_NODE + 1) is 8.

(3) Then "if(size >= kmalloc_size(INDEX_NODE + 1)" will lead to "size
    = PAGE_SIZE".

(4) Then "if ((size >= (PAGE_SIZE >> 3))" test will be satisfied and
    "flags |= CFLGS_OFF_SLAB" will be covered.

(5) if (flags & CFLGS_OFF_SLAB)" test will be satisfied and will go to
    "cachep->slabp_cache = kmalloc_slab(slab_size, 0u)", and the result
    here may be NULL while kernel bootup.

(6) Finally,"BUG_ON(ZERO_OR_NULL_PTR(cachep->slabp_cache));" causes the
    BUG info as the following shows (may be only mips64 has this problem):

This patch fixes the problem of kmalloc_size(INDEX_NODE + 1) and removes
the BUG by adding 'size >= 256' check to guarantee that all necessary
small sized slabs are initialized regardless sequence of slab size in
mapping table.

Fixes: e33660165c90 ("slab: Use common kmalloc_index/kmalloc_size...")
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Liuhailong <liu.hailong6@zte.com.cn>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff -puN mm/slab.c~mm-slab-fix-unexpected-index-mapping-result-of-kmalloc_sizeindex_node1 mm/slab.c
--- a/mm/slab.c~mm-slab-fix-unexpected-index-mapping-result-of-kmalloc_sizeindex_node1
+++ a/mm/slab.c
@@ -2190,9 +2190,16 @@ __kmem_cache_create (struct kmem_cache *
 			size += BYTES_PER_WORD;
 	}
 #if FORCED_DEBUG && defined(CONFIG_DEBUG_PAGEALLOC)
-	if (size >= kmalloc_size(INDEX_NODE + 1)
-	    && cachep->object_size > cache_line_size()
-	    && ALIGN(size, cachep->align) < PAGE_SIZE) {
+	/*
+	 * To activate debug pagealloc, off-slab management is necessary
+	 * requirement. In early phase of initialization, small sized slab
+	 * doesn't get initialized so it would not be possible. So, we need
+	 * to check size >= 256. It guarantees that all necessary small
+	 * sized slab is initialized in current slab initialization sequence.
+	 */
+	if (!slab_early_init && size >= kmalloc_size(INDEX_NODE) &&
+		size >= 256 && cachep->object_size > cache_line_size() &&
+		ALIGN(size, cachep->align) < PAGE_SIZE) {
 		cachep->obj_offset += PAGE_SIZE - ALIGN(size, cachep->align);
 		size = PAGE_SIZE;
 	}
_

Patches currently in -mm which might be from js1304@gmail.com are


