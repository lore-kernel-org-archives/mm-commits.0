From: akpm@linux-foundation.org
Subject: - mm-vmalloc-fix-lazy-unmapping-cache-aliasing.patch removed from -mm tree
Date: Tue, 02 Dec 2008 10:38:13 -0800
Message-ID: <200812021838.mB2IcEJs006783@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47462 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755AbYLBSie (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2008 13:38:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, radford@blackbean.org, rmk@arm.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     mm: vmalloc fix lazy unmapping cache aliasing
has been removed from the -mm tree.  Its filename was
     mm-vmalloc-fix-lazy-unmapping-cache-aliasing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: vmalloc fix lazy unmapping cache aliasing
From: Nick Piggin <npiggin@suse.de>

Jim Radford has reported that the vmap subsystem rewrite was sometimes
causing his VIVT ARM system to behave strangely (seemed like going into
infinite loops trying to fault in pages to userspace).

We determined that the problem was most likely due to a cache aliasing
issue.  flush_cache_vunmap was only being called at the moment the page
tables were to be taken down, however with lazy unmapping, this can happen
after the page has subsequently been freed and allocated for something
else.  The dangling alias may still have dirty data attached to it.

The fix for this problem is to do the cache flushing when the caller has
called vunmap -- it would be a bug for them to write anything else to the
mapping at that point.

That appeared to solve Jim's problems.

Reported-by: Jim Radford <radford@blackbean.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN mm/vmalloc.c~mm-vmalloc-fix-lazy-unmapping-cache-aliasing mm/vmalloc.c
--- a/mm/vmalloc.c~mm-vmalloc-fix-lazy-unmapping-cache-aliasing
+++ a/mm/vmalloc.c
@@ -77,7 +77,6 @@ static void vunmap_page_range(unsigned l
 
 	BUG_ON(addr >= end);
 	pgd = pgd_offset_k(addr);
-	flush_cache_vunmap(addr, end);
 	do {
 		next = pgd_addr_end(addr, end);
 		if (pgd_none_or_clear_bad(pgd))
@@ -543,9 +542,10 @@ static void purge_vmap_area_lazy(void)
 }
 
 /*
- * Free and unmap a vmap area
+ * Free and unmap a vmap area, caller ensuring flush_cache_vunmap had been
+ * called for the correct range previously.
  */
-static void free_unmap_vmap_area(struct vmap_area *va)
+static void free_unmap_vmap_area_noflush(struct vmap_area *va)
 {
 	va->flags |= VM_LAZY_FREE;
 	atomic_add((va->va_end - va->va_start) >> PAGE_SHIFT, &vmap_lazy_nr);
@@ -553,6 +553,15 @@ static void free_unmap_vmap_area(struct 
 		try_purge_vmap_area_lazy();
 }
 
+/*
+ * Free and unmap a vmap area
+ */
+static void free_unmap_vmap_area(struct vmap_area *va)
+{
+	flush_cache_vunmap(va->va_start, va->va_end);
+	free_unmap_vmap_area_noflush(va);
+}
+
 static struct vmap_area *find_vmap_area(unsigned long addr)
 {
 	struct vmap_area *va;
@@ -734,7 +743,7 @@ static void free_vmap_block(struct vmap_
 	spin_unlock(&vmap_block_tree_lock);
 	BUG_ON(tmp != vb);
 
-	free_unmap_vmap_area(vb->va);
+	free_unmap_vmap_area_noflush(vb->va);
 	call_rcu(&vb->rcu_head, rcu_free_vb);
 }
 
@@ -796,6 +805,9 @@ static void vb_free(const void *addr, un
 
 	BUG_ON(size & ~PAGE_MASK);
 	BUG_ON(size > PAGE_SIZE*VMAP_MAX_ALLOC);
+
+	flush_cache_vunmap((unsigned long)addr, (unsigned long)addr + size);
+
 	order = get_order(size);
 
 	offset = (unsigned long)addr & (VMAP_BLOCK_SIZE - 1);
_

Patches currently in -mm which might be from npiggin@suse.de are

linux-next.patch
mm-dont-mark_page_accessed-in-fault-path.patch
mm-dont-mark_page_accessed-in-shmem_fault.patch
mm-invoke-oom-killer-from-page-fault.patch
mm-invoke-oom-killer-from-page-fault-fix.patch
mm-invoke-oom-killer-from-page-fault-fix-fix-2.patch
mm-write_cache_pages-cyclic-fix.patch
mm-write_cache_pages-cyclic-fix-fix.patch
mm-write_cache_pages-early-loop-termination.patch
mm-write_cache_pages-writepage-error-fix.patch
mm-write_cache_pages-integrity-fix.patch
mm-write_cache_pages-cleanups.patch
mm-write_cache_pages-optimise-page-cleaning.patch
mm-write_cache_pages-terminate-quickly.patch
mm-write_cache_pages-more-terminate-quickly.patch
mm-do_sync_mapping_range-integrity-fix.patch
mm-get-rid-of-pagevec_release_nonlru.patch
mm-more-likely-reclaim-madv_sequential-mappings.patch
mm-vmalloc-tweak-failure-printk.patch
mm-vmalloc-improve-vmallocinfo.patch
mm-vmalloc-use-mutex-for-purge.patch
mm-vmalloc-make-lazy-unmapping-configurable.patch
reiser4.patch

