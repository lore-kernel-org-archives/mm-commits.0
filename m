From: akpm@linux-foundation.org
Subject: + mm-vmalloc-remove-guard-page-from-between-vmap-blocks.patch added to -mm tree
Date: Mon, 18 Apr 2011 11:55:35 -0700
Message-ID: <201104181855.p3IItZqu018901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39228 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754822Ab1DRS4q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Apr 2011 14:56:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, david@fromorbit.com, hch@infradead.org, hughd@google.com, mel@csn.ul.ie, npiggin@kernel.dk


The patch titled
     mm/vmalloc: remove guard page from between vmap blocks
has been added to the -mm tree.  Its filename is
     mm-vmalloc-remove-guard-page-from-between-vmap-blocks.patch

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

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Mel Gorman <mel@csn.ul.ie>
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
mm-mem-hotplug-fix-section-mismatch-setup_per_zone_inactive_ratio-should-be-__meminit.patch
mm-vmalloc-remove-guard-page-from-between-vmap-blocks.patch
mm-batch-activate_page-to-reduce-lock-contention.patch

