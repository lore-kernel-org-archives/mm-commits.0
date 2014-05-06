From: akpm@linux-foundation.org
Subject: [merged]
 slab-fix-the-type-of-the-index-on-freelist-index-accessor.patch removed
 from -mm tree
Date: Tue, 06 May 2014 12:05:50 -0700
Message-ID: <5369328e.BKIPNBs2PgIvYItH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752469AbaEFTFv (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 May 2014 15:05:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sfking@fdwdc.com, penberg@kernel.org, james.hogan@imgtec.com, cl@linux.com, iamjoonsoo.kim@lge.com

Subject: [merged] slab-fix-the-type-of-the-index-on-freelist-index-accessor.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,cl@linux.com,james.hogan@imgtec.com,penberg@kernel.org,sfking@fdwdc.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 06 May 2014 12:05:50 -0700


The patch titled
     Subject: slab: fix the type of the index on freelist index accessor
has been removed from the -mm tree.  Its filename was
     slab-fix-the-type-of-the-index-on-freelist-index-accessor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: slab: fix the type of the index on freelist index accessor

commit a41adfaa23dfe58d ("slab: introduce byte sized index for the
freelist of a slab") changes the size of freelist index and also changes
prototype of accessor function to freelist index.  And there was a
mistake.

The mistake is that although it changes the size of freelist index
correctly, it changes the size of the index of freelist index incorrectly.
 With patch, freelist index can be 1 byte or 2 bytes, that means that num
of object on on a slab can be more than 255.  So we need more than 1 byte
for the index to find the index of free object on freelist.  But, above
patch makes this index type 1 byte, so slab which have more than 255
objects cannot work properly and in consequence of it, the system cannot
boot.

This issue was reported by Steven King on m68knommu which would use 2
bytes freelist index.  Please refer following link.

https://lkml.org/lkml/2014/4/16/433

To fix it is so easy.  To change the type of the index of freelist index
on accessor functions is enough to fix this bug.  Although 2 bytes is
enough, I use 4 bytes since it have no bad effect and make things more
easier.  This fix was suggested and tested by Steven in his original
report.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reported-by: Steven King <sfking@fdwdc.com>
Acked-by: Steven King <sfking@fdwdc.com>
Acked-by: Christoph Lameter <cl@linux.com>
Tested-by: James Hogan <james.hogan@imgtec.com>
Cc: Pekka Enberg <penberg@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slab.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/slab.c~slab-fix-the-type-of-the-index-on-freelist-index-accessor mm/slab.c
--- a/mm/slab.c~slab-fix-the-type-of-the-index-on-freelist-index-accessor
+++ a/mm/slab.c
@@ -2572,13 +2572,13 @@ static void *alloc_slabmgmt(struct kmem_
 	return freelist;
 }
 
-static inline freelist_idx_t get_free_obj(struct page *page, unsigned char idx)
+static inline freelist_idx_t get_free_obj(struct page *page, unsigned int idx)
 {
 	return ((freelist_idx_t *)page->freelist)[idx];
 }
 
 static inline void set_free_obj(struct page *page,
-					unsigned char idx, freelist_idx_t val)
+					unsigned int idx, freelist_idx_t val)
 {
 	((freelist_idx_t *)(page->freelist))[idx] = val;
 }
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-compaction-make-isolate_freepages-start-at-pageblock-boundary.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-page_alloc-prevent-migrate_reserve-pages-from-being-misplaced.patch
mm-page_alloc-debug_vm-checks-for-free_list-placement-of-cma-and-reserve-pages.patch
mm-compaction-clean-up-unused-code-lines.patch
mm-compaction-cleanup-isolate_freepages.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
mm-compaction-cleanup-isolate_freepages-fix-2.patch
mm-compaction-cleanup-isolate_freepages-fix3.patch
mm-swapc-clean-up-lru_cache_add-functions.patch
zram-correct-offset-usage-in-zram_bio_discard.patch
page-owners-correct-page-order-when-to-free-page.patch

