From: akpm@linux-foundation.org
Subject: +
 mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch added
 to -mm tree
Date: Tue, 24 Mar 2015 14:59:12 -0700
Message-ID: <5511de30.lqRIqSXF+B+3Z13y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37690 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbbCXV7N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 24 Mar 2015 17:59:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: r.peniaev@gmail.com, chaowang@redhat.com, cl@linux.com, edumazet@google.com, fabf@skynet.be, gioh.kim@lge.com, iamjoonsoo.kim@lge.com, rientjes@google.com, rob.jones@codethink.co.uk, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: get rid of dirty bitmap inside vmap_block structure
has been added to the -mm tree.  Its filename is
     mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Roman Pen <r.peniaev@gmail.com>
Subject: mm/vmalloc: get rid of dirty bitmap inside vmap_block structure

In original implementation of vm_map_ram made by Nick Piggin there were
two bitmaps: alloc_map and dirty_map.  None of them were used as supposed
to be: finding a suitable free hole for next allocation in block. 
vm_map_ram allocates space sequentially in block and on free call marks
pages as dirty, so freed space can't be reused anymore.

Actually it would be very interesting to know the real meaning of those
bitmaps, maybe implementation was incomplete, etc.

But long time ago Zhang Yanfei removed alloc_map by these two commits:

  mm/vmalloc.c: remove dead code in vb_alloc
     3fcd76e8028e0be37b02a2002b4f56755daeda06
  mm/vmalloc.c: remove alloc_map from vmap_block
     b8e748b6c32999f221ea4786557b8e7e6c4e4e7a

In this patch I replaced dirty_map with two range variables: dirty min and
max.  These variables store minimum and maximum position of dirty space in
a block, since we need only to know the dirty range, not exact position of
dirty pages.

Why it was made?  Several reasons: at first glance it seems that
vm_map_ram allocator concerns about fragmentation thus it uses bitmaps for
finding free hole, but it is not true.  To avoid complexity seems it is
better to use something simple, like min or max range values.  Secondly,
code also becomes simpler, without iteration over bitmap, just comparing
values in min and max macros.  Thirdly, bitmap occupies up to 1024 bits
(4MB is a max size of a block).  Here I replaced the whole bitmap with two
longs.

Finally vm_unmap_aliases should be slightly faster and the whole
vmap_block structure occupies less memory.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
Cc: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Eric Dumazet <edumazet@google.com>
Acked-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Rientjes <rientjes@google.com>
Cc: WANG Chao <chaowang@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Christoph Lameter <cl@linux.com>
Cc: Gioh Kim <gioh.kim@lge.com>
Cc: Rob Jones <rob.jones@codethink.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure
+++ a/mm/vmalloc.c
@@ -765,7 +765,7 @@ struct vmap_block {
 	spinlock_t lock;
 	struct vmap_area *va;
 	unsigned long free, dirty;
-	DECLARE_BITMAP(dirty_map, VMAP_BBMAP_BITS);
+	unsigned long dirty_min, dirty_max; /*< dirty range */
 	struct list_head free_list;
 	struct rcu_head rcu_head;
 	struct list_head purge;
@@ -851,7 +851,8 @@ static void *new_vmap_block(unsigned int
 	BUG_ON(VMAP_BBMAP_BITS <= (1UL << order));
 	vb->free = VMAP_BBMAP_BITS - (1UL << order);
 	vb->dirty = 0;
-	bitmap_zero(vb->dirty_map, VMAP_BBMAP_BITS);
+	vb->dirty_min = VMAP_BBMAP_BITS;
+	vb->dirty_max = 0;
 	INIT_LIST_HEAD(&vb->free_list);
 
 	vb_idx = addr_to_vb_idx(va->va_start);
@@ -902,7 +903,8 @@ static void purge_fragmented_blocks(int
 		if (vb->free + vb->dirty == VMAP_BBMAP_BITS && vb->dirty != VMAP_BBMAP_BITS) {
 			vb->free = 0; /* prevent further allocs after releasing lock */
 			vb->dirty = VMAP_BBMAP_BITS; /* prevent purging it again */
-			bitmap_fill(vb->dirty_map, VMAP_BBMAP_BITS);
+			vb->dirty_min = 0;
+			vb->dirty_max = VMAP_BBMAP_BITS;
 			spin_lock(&vbq->lock);
 			list_del_rcu(&vb->free_list);
 			spin_unlock(&vbq->lock);
@@ -995,6 +997,7 @@ static void vb_free(const void *addr, un
 	order = get_order(size);
 
 	offset = (unsigned long)addr & (VMAP_BLOCK_SIZE - 1);
+	offset >>= PAGE_SHIFT;
 
 	vb_idx = addr_to_vb_idx((unsigned long)addr);
 	rcu_read_lock();
@@ -1005,7 +1008,10 @@ static void vb_free(const void *addr, un
 	vunmap_page_range((unsigned long)addr, (unsigned long)addr + size);
 
 	spin_lock(&vb->lock);
-	BUG_ON(bitmap_allocate_region(vb->dirty_map, offset >> PAGE_SHIFT, order));
+
+	/* Expand dirty range */
+	vb->dirty_min = min(vb->dirty_min, offset);
+	vb->dirty_max = max(vb->dirty_max, offset + (1UL << order));
 
 	vb->dirty += 1UL << order;
 	if (vb->dirty == VMAP_BBMAP_BITS) {
@@ -1044,25 +1050,18 @@ void vm_unmap_aliases(void)
 
 		rcu_read_lock();
 		list_for_each_entry_rcu(vb, &vbq->free, free_list) {
-			int i, j;
-
 			spin_lock(&vb->lock);
-			i = find_first_bit(vb->dirty_map, VMAP_BBMAP_BITS);
-			if (i < VMAP_BBMAP_BITS) {
+			if (vb->dirty) {
+				unsigned long va_start = vb->va->va_start;
 				unsigned long s, e;
 
-				j = find_last_bit(vb->dirty_map,
-							VMAP_BBMAP_BITS);
-				j = j + 1; /* need exclusive index */
+				s = va_start + (vb->dirty_min << PAGE_SHIFT);
+				e = va_start + (vb->dirty_max << PAGE_SHIFT);
 
-				s = vb->va->va_start + (i << PAGE_SHIFT);
-				e = vb->va->va_start + (j << PAGE_SHIFT);
-				flush = 1;
+				start = min(s, start);
+				end   = max(e, end);
 
-				if (s < start)
-					start = s;
-				if (e > end)
-					end = e;
+				flush = 1;
 			}
 			spin_unlock(&vb->lock);
 		}
_

Patches currently in -mm which might be from r.peniaev@gmail.com are

mm-vmalloc-fix-possible-exhaustion-of-vmalloc-space-caused-by-vm_map_ram-allocator.patch
mm-vmalloc-occupy-newly-allocated-vmap-block-just-after-allocation.patch
mm-vmalloc-get-rid-of-dirty-bitmap-inside-vmap_block-structure.patch
fs-mpagec-forgotten-write_sync-in-case-of-data-integrity-write.patch

