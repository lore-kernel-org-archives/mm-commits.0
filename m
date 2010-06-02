From: akpm@linux-foundation.org
Subject: + mm-vmap-area-cache.patch added to -mm tree
Date: Wed, 02 Jun 2010 14:49:38 -0700
Message-ID: <201006022149.o52LncTH018933@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932382Ab0FBVtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jun 2010 17:49:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: npiggin@suse.de, minchan.kim@gmail.com, swhiteho@redhat.com


The patch titled
     mm: vmap area cache
has been added to the -mm tree.  Its filename is
     mm-vmap-area-cache.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmap area cache
From: Nick Piggin <npiggin@suse.de>

Provide a free area cache for the vmalloc virtual address allocator, based
on the approach taken in the user virtual memory allocator.

This reduces the number of rbtree operations and linear traversals over
the vmap extents to find a free area.  The lazy vmap flushing makes this
problem worse because because freed but not yet flushed vmaps tend to
build up in the address space between flushes.

Steven noticed a performance problem with GFS2. Results are as follows...

Signed-off-by: Nick Piggin <npiggin@suse.de>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |  100 ++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 78 insertions(+), 22 deletions(-)

diff -puN mm/vmalloc.c~mm-vmap-area-cache mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmap-area-cache
+++ a/mm/vmalloc.c
@@ -262,8 +262,14 @@ struct vmap_area {
 };
 
 static DEFINE_SPINLOCK(vmap_area_lock);
-static struct rb_root vmap_area_root = RB_ROOT;
 static LIST_HEAD(vmap_area_list);
+static struct rb_root vmap_area_root = RB_ROOT;
+
+static struct rb_node *free_vmap_cache;
+static unsigned long cached_hole_size;
+static unsigned long cached_start;
+static unsigned long cached_align;
+
 static unsigned long vmap_area_pcpu_hole;
 
 static struct vmap_area *__find_vmap_area(unsigned long addr)
@@ -332,9 +338,11 @@ static struct vmap_area *alloc_vmap_area
 	struct rb_node *n;
 	unsigned long addr;
 	int purged = 0;
+	struct vmap_area *first;
 
 	BUG_ON(!size);
 	BUG_ON(size & ~PAGE_MASK);
+	BUG_ON(!is_power_of_2(align));
 
 	va = kmalloc_node(sizeof(struct vmap_area),
 			gfp_mask & GFP_RECLAIM_MASK, node);
@@ -342,17 +350,39 @@ static struct vmap_area *alloc_vmap_area
 		return ERR_PTR(-ENOMEM);
 
 retry:
-	addr = ALIGN(vstart, align);
-
 	spin_lock(&vmap_area_lock);
-	if (addr + size - 1 < addr)
-		goto overflow;
+	/* invalidate cache if we have more permissive parameters */
+	if (!free_vmap_cache ||
+			size <= cached_hole_size ||
+			vstart < cached_start ||
+			align < cached_align) {
+nocache:
+		cached_hole_size = 0;
+		free_vmap_cache = NULL;
+	}
+	/* record if we encounter less permissive parameters */
+	cached_start = vstart;
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
 
-	/* XXX: could have a last_hole cache */
-	n = vmap_area_root.rb_node;
-	if (n) {
-		struct vmap_area *first = NULL;
+	} else {
+		addr = ALIGN(vstart, align);
+		if (addr + size - 1 < addr)
+			goto overflow;
 
+		n = vmap_area_root.rb_node;
+		if (!n)
+			goto found;
+
+		first = NULL;
 		do {
 			struct vmap_area *tmp;
 			tmp = rb_entry(n, struct vmap_area, rb_node);
@@ -369,26 +399,36 @@ retry:
 		if (!first)
 			goto found;
 
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
+		if (first->va_start < addr) {
+			addr = ALIGN(max(first->va_end + PAGE_SIZE, addr), align);
 			if (addr + size - 1 < addr)
 				goto overflow;
-
 			n = rb_next(&first->rb_node);
 			if (n)
 				first = rb_entry(n, struct vmap_area, rb_node);
 			else
 				goto found;
 		}
+		BUG_ON(first->va_start < addr);
+		if (addr + cached_hole_size < first->va_start)
+			cached_hole_size = first->va_start - addr;
+	}
+
+	/* from the starting point, walk areas until a suitable hole is found */
+	while (addr + size > first->va_start && addr + size <= vend) {
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
+
 found:
 	if (addr + size > vend) {
 overflow:
@@ -406,14 +446,17 @@ overflow:
 		return ERR_PTR(-EBUSY);
 	}
 
-	BUG_ON(addr & (align-1));
-
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
 }
 
@@ -427,6 +470,19 @@ static void rcu_free_va(struct rcu_head 
 static void __free_vmap_area(struct vmap_area *va)
 {
 	BUG_ON(RB_EMPTY_NODE(&va->rb_node));
+
+	if (free_vmap_cache) {
+		if (va->va_end < cached_start) {
+			free_vmap_cache = NULL;
+		} else {
+			struct vmap_area *cache;
+			cache = rb_entry(free_vmap_cache, struct vmap_area, rb_node);
+			if (va->va_start <= cache->va_start) {
+				free_vmap_cache = rb_prev(&va->rb_node);
+				cache = rb_entry(free_vmap_cache, struct vmap_area, rb_node);
+			}
+		}
+	}
 	rb_erase(&va->rb_node, &vmap_area_root);
 	RB_CLEAR_NODE(&va->rb_node);
 	list_del_rcu(&va->list);
_

Patches currently in -mm which might be from npiggin@suse.de are

frv-invoke-oom-killer-from-page-fault.patch
m32r-invoke-oom-killer-from-page-fault.patch
mn10300-invoke-oom-killer-from-page-fault.patch
xtensa-invoke-oom-killer-from-page-fault.patch
linux-next.patch
fb_defio-redo-fix-for-non-dirty-ptes.patch
block-bd_start_claiming-fix-module-refcount.patch
block-bd_start_claiming-cleanup.patch
avr32-invoke-oom-killer-from-page-fault.patch
mm-vmap-area-cache.patch
mm-vmap-area-cache-fix.patch
reiser4.patch

