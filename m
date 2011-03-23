From: akpm@linux-foundation.org
Subject: [merged] mm-vmap-area-cache.patch removed from -mm tree
Date: Wed, 23 Mar 2011 13:33:32 -0700
Message-ID: <201103232037.p2NKb9kq028211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933284Ab1CWU5k (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Mar 2011 16:57:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, avi@redhat.com, bmarson@redhat.com, hughd@google.com, minchan.kim@gmail.com, prarit@redhat.com, swhiteho@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: vmap area cache
has been removed from the -mm tree.  Its filename was
     mm-vmap-area-cache.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmap area cache
From: Nick Piggin <npiggin@suse.de>

Provide a free area cache for the vmalloc virtual address allocator, based
on the algorithm used by the user virtual memory allocator.

This reduces the number of rbtree operations and linear traversals over
the vmap extents in order to find a free area, by starting off at the last
point that a free area was found.

The free area cache is reset if areas are freed behind it, or if we are
searching for a smaller area or alignment than last time.  So allocation
patterns are not changed (verified by corner-case and random test cases in
userspace testing).

This solves a regression caused by lazy vunmap TLB purging introduced in
db64fe02 (mm: rewrite vmap layer).  That patch will leave extents in the
vmap allocator after they are vunmapped, and until a significant number
accumulate that can be flushed in a single batch.  So in a workload that
vmalloc/vfree frequently, a chain of extents will build up from
VMALLOC_START address, which have to be iterated over each time (giving an
O(n) type of behaviour).

After this patch, the search will start from where it left off, giving
closer to an amortized O(1).

This is verified to solve regressions reported Steven in GFS2, and Avi in
KVM.

Hugh's update:

: I tried out the recent mmotm, and on one machine was fortunate to hit
: the BUG_ON(first->va_start < addr) which seems to have been stalling
: your vmap area cache patch ever since May.

: I can get you addresses etc, I did dump a few out; but once I stared
: at them, it was easier just to look at the code: and I cannot see how
: you would be so sure that first->va_start < addr, once you've done
: that addr = ALIGN(max(...), align) above, if align is over 0x1000
: (align was 0x8000 or 0x4000 in the cases I hit: ioremaps like Steve).

: I originally got around it by just changing the
: 		if (first->va_start < addr) {
: to
: 		while (first->va_start < addr) {
: without thinking about it any further; but that seemed unsatisfactory,
: why would we want to loop here when we've got another very similar
: loop just below it?

: I am never going to admit how long I've spent trying to grasp your
: "while (n)" rbtree loop just above this, the one with the peculiar
: 		if (!first && tmp->va_start < addr + size)
: in.  That's unfamiliar to me, I'm guessing it's designed to save a
: subsequent rb_next() in a few circumstances (at risk of then setting
: a wrong cached_hole_size?); but they did appear few to me, and I didn't
: feel I could sign off something with that in when I don't grasp it,
: and it seems responsible for extra code and mistaken BUG_ON below it.

: I've reverted to the familiar rbtree loop that find_vma() does (but
: with va_end >= addr as you had, to respect the additional guard page):
: and then (given that cached_hole_size starts out 0) I don't see the
: need for any complications below it.  If you do want to keep that loop
: as you had it, please add a comment to explain what it's trying to do,
: and where addr is relative to first when you emerge from it.

: Aren't your tests "size <= cached_hole_size" and
: "addr + size > first->va_start" forgetting the guard page we want
: before the next area?  I've changed those.

: I have not changed your many "addr + size - 1 < addr" overflow tests,
: but have since come to wonder, shouldn't they be "addr + size < addr"
: tests - won't the vend checks go wrong if addr + size is 0?

: I have added a few comments - Wolfgang Wander's 2.6.13 description of
: 1363c3cd8603a913a27e2995dccbd70d5312d8e6 Avoiding mmap fragmentation
: helped me a lot, perhaps a pointer to that would be good too.  And I found
: it easier to understand when I renamed cached_start slightly and moved the
: overflow label down.

: This patch would go after your mm-vmap-area-cache.patch in mmotm. 
: Trivially, nobody is going to get that BUG_ON with this patch, and it
: appears to work fine on my machines; but I have not given it anything like
: the testing you did on your original, and may have broken all the
: performance you were aiming for.  Please take a look and test it out
: integrate with yours if you're satisfied - thanks.

[akpm@linux-foundation.org: add locking comment]
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Reported-and-tested-by: Steven Whitehouse <swhiteho@redhat.com>
Reported-and-tested-by: Avi Kivity <avi@redhat.com>
Tested-by: "Barry J. Marson" <bmarson@redhat.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |  156 ++++++++++++++++++++++++++++++++-----------------
 1 file changed, 104 insertions(+), 52 deletions(-)

diff -puN mm/vmalloc.c~mm-vmap-area-cache mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmap-area-cache
+++ a/mm/vmalloc.c
@@ -261,8 +261,15 @@ struct vmap_area {
 };
 
 static DEFINE_SPINLOCK(vmap_area_lock);
-static struct rb_root vmap_area_root = RB_ROOT;
 static LIST_HEAD(vmap_area_list);
+static struct rb_root vmap_area_root = RB_ROOT;
+
+/* The vmap cache globals are protected by vmap_area_lock */
+static struct rb_node *free_vmap_cache;
+static unsigned long cached_hole_size;
+static unsigned long cached_vstart;
+static unsigned long cached_align;
+
 static unsigned long vmap_area_pcpu_hole;
 
 static struct vmap_area *__find_vmap_area(unsigned long addr)
@@ -331,9 +338,11 @@ static struct vmap_area *alloc_vmap_area
 	struct rb_node *n;
 	unsigned long addr;
 	int purged = 0;
+	struct vmap_area *first;
 
 	BUG_ON(!size);
 	BUG_ON(size & ~PAGE_MASK);
+	BUG_ON(!is_power_of_2(align));
 
 	va = kmalloc_node(sizeof(struct vmap_area),
 			gfp_mask & GFP_RECLAIM_MASK, node);
@@ -341,79 +350,106 @@ static struct vmap_area *alloc_vmap_area
 		return ERR_PTR(-ENOMEM);
 
 retry:
-	addr = ALIGN(vstart, align);
-
 	spin_lock(&vmap_area_lock);
-	if (addr + size - 1 < addr)
-		goto overflow;
+	/*
+	 * Invalidate cache if we have more permissive parameters.
+	 * cached_hole_size notes the largest hole noticed _below_
+	 * the vmap_area cached in free_vmap_cache: if size fits
+	 * into that hole, we want to scan from vstart to reuse
+	 * the hole instead of allocating above free_vmap_cache.
+	 * Note that __free_vmap_area may update free_vmap_cache
+	 * without updating cached_hole_size or cached_align.
+	 */
+	if (!free_vmap_cache ||
+			size < cached_hole_size ||
+			vstart < cached_vstart ||
+			align < cached_align) {
+nocache:
+		cached_hole_size = 0;
+		free_vmap_cache = NULL;
+	}
+	/* record if we encounter less permissive parameters */
+	cached_vstart = vstart;
+	cached_align = align;
+
+	/* find starting point for our search */
+	if (free_vmap_cache) {
+		first = rb_entry(free_vmap_cache, struct vmap_area, rb_node);
+		addr = ALIGN(first->va_end + PAGE_SIZE, align);
+		if (addr < vstart)
+			goto nocache;
+		if (addr + size - 1 < addr)
+			goto overflow;
+
+	} else {
+		addr = ALIGN(vstart, align);
+		if (addr + size - 1 < addr)
+			goto overflow;
 
-	/* XXX: could have a last_hole cache */
-	n = vmap_area_root.rb_node;
-	if (n) {
-		struct vmap_area *first = NULL;
+		n = vmap_area_root.rb_node;
+		first = NULL;
 
-		do {
+		while (n) {
 			struct vmap_area *tmp;
 			tmp = rb_entry(n, struct vmap_area, rb_node);
 			if (tmp->va_end >= addr) {
-				if (!first && tmp->va_start < addr + size)
-					first = tmp;
-				n = n->rb_left;
-			} else {
 				first = tmp;
+				if (tmp->va_start <= addr)
+					break;
+				n = n->rb_left;
+			} else
 				n = n->rb_right;
-			}
-		} while (n);
+		}
 
 		if (!first)
 			goto found;
-
-		if (first->va_end < addr) {
-			n = rb_next(&first->rb_node);
-			if (n)
-				first = rb_entry(n, struct vmap_area, rb_node);
-			else
-				goto found;
-		}
-
-		while (addr + size > first->va_start && addr + size <= vend) {
-			addr = ALIGN(first->va_end + PAGE_SIZE, align);
-			if (addr + size - 1 < addr)
-				goto overflow;
-
-			n = rb_next(&first->rb_node);
-			if (n)
-				first = rb_entry(n, struct vmap_area, rb_node);
-			else
-				goto found;
-		}
 	}
-found:
-	if (addr + size > vend) {
-overflow:
-		spin_unlock(&vmap_area_lock);
-		if (!purged) {
-			purge_vmap_area_lazy();
-			purged = 1;
-			goto retry;
-		}
-		if (printk_ratelimit())
-			printk(KERN_WARNING
-				"vmap allocation for size %lu failed: "
-				"use vmalloc=<size> to increase size.\n", size);
-		kfree(va);
-		return ERR_PTR(-EBUSY);
+
+	/* from the starting point, walk areas until a suitable hole is found */
+	while (addr + size >= first->va_start && addr + size <= vend) {
+		if (addr + cached_hole_size < first->va_start)
+			cached_hole_size = first->va_start - addr;
+		addr = ALIGN(first->va_end + PAGE_SIZE, align);
+		if (addr + size - 1 < addr)
+			goto overflow;
+
+		n = rb_next(&first->rb_node);
+		if (n)
+			first = rb_entry(n, struct vmap_area, rb_node);
+		else
+			goto found;
 	}
 
-	BUG_ON(addr & (align-1));
+found:
+	if (addr + size > vend)
+		goto overflow;
 
 	va->va_start = addr;
 	va->va_end = addr + size;
 	va->flags = 0;
 	__insert_vmap_area(va);
+	free_vmap_cache = &va->rb_node;
 	spin_unlock(&vmap_area_lock);
 
+	BUG_ON(va->va_start & (align-1));
+	BUG_ON(va->va_start < vstart);
+	BUG_ON(va->va_end > vend);
+
 	return va;
+
+overflow:
+	spin_unlock(&vmap_area_lock);
+	if (!purged) {
+		purge_vmap_area_lazy();
+		purged = 1;
+		goto retry;
+	}
+	if (printk_ratelimit())
+		printk(KERN_WARNING
+			"vmap allocation for size %lu failed: "
+			"use vmalloc=<size> to increase size.\n", size);
+	kfree(va);
+	return ERR_PTR(-EBUSY);
 }
 
 static void rcu_free_va(struct rcu_head *head)
@@ -426,6 +462,22 @@ static void rcu_free_va(struct rcu_head 
 static void __free_vmap_area(struct vmap_area *va)
 {
 	BUG_ON(RB_EMPTY_NODE(&va->rb_node));
+
+	if (free_vmap_cache) {
+		if (va->va_end < cached_vstart) {
+			free_vmap_cache = NULL;
+		} else {
+			struct vmap_area *cache;
+			cache = rb_entry(free_vmap_cache, struct vmap_area, rb_node);
+			if (va->va_start <= cache->va_start) {
+				free_vmap_cache = rb_prev(&va->rb_node);
+				/*
+				 * We don't try to update cached_hole_size or
+				 * cached_align, but it won't go very wrong.
+				 */
+			}
+		}
+	}
 	rb_erase(&va->rb_node, &vmap_area_root);
 	RB_CLEAR_NODE(&va->rb_node);
 	list_del_rcu(&va->list);
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch

