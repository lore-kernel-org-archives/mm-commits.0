From: akpm@linux-foundation.org
Subject: [merged] mm-vmalloc-remove-guard-page-from-between-vmap-blocks.patch removed from -mm tree
Date: Wed, 25 May 2011 13:27:59 -0700
Message-ID: <201105252026.p4PKQM57014490@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932071Ab1EYU1b (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 25 May 2011 16:27:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, david@fromorbit.com, hch@infradead.org, hughd@google.com, mel@csn.ul.ie, npiggin@kernel.dk, mm-commits@vger.kernel.org


The patch titled
     mm/vmalloc: remove guard page from between vmap blocks
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-remove-guard-page-from-between-vmap-blocks.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm/vmalloc: remove guard page from between vmap blocks
From: Johannes Weiner <hannes@cmpxchg.org>

The vmap allocator is used to, among other things, allocate per-cpu vmap
blocks, where each vmap block is naturally aligned to its own size. 
Obviously, leaving a guard page after each vmap area forbids packing vmap
blocks efficiently and can make the kernel run out of possible vmap blocks
long before overall vmap space is exhausted.

The new interface to map a user-supplied page array into linear vmalloc
space (vm_map_ram) insists on allocating from a vmap block (instead of
falling back to a custom area) when the area size is below a certain
threshold.  With heavy users of this interface (e.g.  XFS) and limited
vmalloc space on 32-bit, vmap block exhaustion is a real problem.

Remove the guard page from the core vmap allocator.  vmalloc and the old
vmap interface enforce a guard page on their own at a higher level.

Note that without this patch, we had accidental guard pages after those
vm_map_ram areas that happened to be at the end of a vmap block, but not
between every area.  This patch removes this accidental guard page only.

If we want guard pages after every vm_map_ram area, this should be done
separately.  And just like with vmalloc and the old interface on a
different level, not in the core allocator.

Mel pointed out: "If necessary, the guard page could be reintroduced as a
debugging-only option (CONFIG_DEBUG_PAGEALLOC?).  Otherwise it seems
reasonable."

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>
Acked-by: Mel Gorman <mel@csn.ul.ie>
Cc: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-remove-guard-page-from-between-vmap-blocks mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-remove-guard-page-from-between-vmap-blocks
+++ a/mm/vmalloc.c
@@ -375,7 +375,7 @@ nocache:
 	/* find starting point for our search */
 	if (free_vmap_cache) {
 		first = rb_entry(free_vmap_cache, struct vmap_area, rb_node);
-		addr = ALIGN(first->va_end + PAGE_SIZE, align);
+		addr = ALIGN(first->va_end, align);
 		if (addr < vstart)
 			goto nocache;
 		if (addr + size - 1 < addr)
@@ -406,10 +406,10 @@ nocache:
 	}
 
 	/* from the starting point, walk areas until a suitable hole is found */
-	while (addr + size >= first->va_start && addr + size <= vend) {
+	while (addr + size > first->va_start && addr + size <= vend) {
 		if (addr + cached_hole_size < first->va_start)
 			cached_hole_size = first->va_start - addr;
-		addr = ALIGN(first->va_end + PAGE_SIZE, align);
+		addr = ALIGN(first->va_end, align);
 		if (addr + size - 1 < addr)
 			goto overflow;
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
memcg-add-the-soft_limit-reclaim-in-global-direct-reclaim.patch
memcg-remove-unused-retry-signal-from-reclaim.patch
memcg-rename-mem_cgroup_zone_nr_pages-to-mem_cgroup_zone_nr_lru_pages.patch

