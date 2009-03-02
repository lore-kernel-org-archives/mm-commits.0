From: akpm@linux-foundation.org
Subject: [merged] mm-vmap-fix-overflow.patch removed from -mm tree
Date: Mon, 02 Mar 2009 11:23:03 -0800
Message-ID: <200903021923.n22JN3LM014367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45249 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753582AbZCBTYB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Mar 2009 14:24:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, hch@lst.de, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     mm: vmap fix overflow
has been removed from the -mm tree.  Its filename was
     mm-vmap-fix-overflow.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmap fix overflow
From: Nick Piggin <npiggin@suse.de>

The new vmap allocator can wrap the address and get confused in the case
of large allocations or VMALLOC_END near the end of address space.

Problem reported by Christoph Hellwig on a 32-bit XFS workload.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Reported-by: Christoph Hellwig <hch@lst.de>
Cc: <stable@kernel.org>		[2.6.28.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN mm/vmalloc.c~mm-vmap-fix-overflow mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmap-fix-overflow
+++ a/mm/vmalloc.c
@@ -323,6 +323,7 @@ static struct vmap_area *alloc_vmap_area
 	unsigned long addr;
 	int purged = 0;
 
+	BUG_ON(!size);
 	BUG_ON(size & ~PAGE_MASK);
 
 	va = kmalloc_node(sizeof(struct vmap_area),
@@ -334,6 +335,9 @@ retry:
 	addr = ALIGN(vstart, align);
 
 	spin_lock(&vmap_area_lock);
+	if (addr + size - 1 < addr)
+		goto overflow;
+
 	/* XXX: could have a last_hole cache */
 	n = vmap_area_root.rb_node;
 	if (n) {
@@ -365,6 +369,8 @@ retry:
 
 		while (addr + size > first->va_start && addr + size <= vend) {
 			addr = ALIGN(first->va_end + PAGE_SIZE, align);
+			if (addr + size - 1 < addr)
+				goto overflow;
 
 			n = rb_next(&first->rb_node);
 			if (n)
@@ -375,6 +381,7 @@ retry:
 	}
 found:
 	if (addr + size > vend) {
+overflow:
 		spin_unlock(&vmap_area_lock);
 		if (!purged) {
 			purge_vmap_area_lazy();
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
linux-next.patch
vmap-remove-needless-lock-and-list-in-vmap.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
radix-tree-gang-set-if-tagged-operation.patch
mm-dont-call-mark_page_accessed-in-do_swap_page.patch
mm-update_page_reclaim_stat-is-called-from-page-fault-path.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page.patch
mm-add-comment-why-mark_page_accessed-would-be-better-than-pte_mkyoung-in-follow_page-fix.patch
reiser4.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

