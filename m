From: akpm@linux-foundation.org
Subject: - slob-remove-bigblock-tracking.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:48:59 -0700
Message-ID: <200707162048.l6GKmxCR001122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760600AbXGPV3j (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:29:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: npiggin@suse.de, mpm@selenic.com, mm-commits@vger.kernel.org


The patch titled
     slob: remove bigblock tracking
has been removed from the -mm tree.  Its filename was
     slob-remove-bigblock-tracking.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: slob: remove bigblock tracking
From: Nick Piggin <npiggin@suse.de>

Remove the bigblock lists in favour of using compound pages and going directly
to the page allocator.  Allocation size is stored in page->private, which also
makes ksize more accurate than it previously was.

Saves ~.5K of code, and 12-24 bytes overhead per >= PAGE_SIZE allocation.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Acked-by: Matt Mackall <mpm@selenic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slob.c |  101 ++++++++++++++--------------------------------------
 1 file changed, 28 insertions(+), 73 deletions(-)

diff -puN mm/slob.c~slob-remove-bigblock-tracking mm/slob.c
--- a/mm/slob.c~slob-remove-bigblock-tracking
+++ a/mm/slob.c
@@ -18,9 +18,11 @@
  * Above this is an implementation of kmalloc/kfree. Blocks returned
  * from kmalloc are 4-byte aligned and prepended with a 4-byte header.
  * If kmalloc is asked for objects of PAGE_SIZE or larger, it calls
- * __get_free_pages directly so that it can return page-aligned blocks
- * and keeps a linked list of such pages and their orders. These
- * objects are detected in kfree() by their page alignment.
+ * __get_free_pages directly, allocating compound pages so the page order
+ * does not have to be separately tracked, and also stores the exact
+ * allocation size in page->private so that it can be used to accurately
+ * provide ksize(). These objects are detected in kfree() because slob_page()
+ * is false for them.
  *
  * SLAB is emulated on top of SLOB by simply calling constructors and
  * destructors for every SLAB allocation. Objects are returned with the
@@ -29,7 +31,8 @@
  * alignment. Again, objects of page-size or greater are allocated by
  * calling __get_free_pages. As SLAB objects know their size, no separate
  * size bookkeeping is necessary and there is essentially no allocation
- * space overhead.
+ * space overhead, and compound pages aren't needed for multi-page
+ * allocations.
  */
 
 #include <linux/kernel.h>
@@ -381,48 +384,26 @@ out:
  * End of slob allocator proper. Begin kmem_cache_alloc and kmalloc frontend.
  */
 
-struct bigblock {
-	int order;
-	void *pages;
-	struct bigblock *next;
-};
-typedef struct bigblock bigblock_t;
-
-static bigblock_t *bigblocks;
-
-static DEFINE_SPINLOCK(block_lock);
-
-
 void *__kmalloc(size_t size, gfp_t gfp)
 {
-	slob_t *m;
-	bigblock_t *bb;
-	unsigned long flags;
-
 	if (size < PAGE_SIZE - SLOB_UNIT) {
+		slob_t *m;
 		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
 		if (m)
 			m->units = size;
 		return m+1;
-	}
-
-	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
-	if (!bb)
-		return 0;
-
-	bb->order = get_order(size);
-	bb->pages = (void *)__get_free_pages(gfp, bb->order);
+	} else {
+		void *ret;
 
-	if (bb->pages) {
-		spin_lock_irqsave(&block_lock, flags);
-		bb->next = bigblocks;
-		bigblocks = bb;
-		spin_unlock_irqrestore(&block_lock, flags);
-		return bb->pages;
+		ret = (void *) __get_free_pages(gfp | __GFP_COMP,
+						get_order(size));
+		if (ret) {
+			struct page *page;
+			page = virt_to_page(ret);
+			page->private = size;
+		}
+		return ret;
 	}
-
-	slob_free(bb, sizeof(bigblock_t));
-	return 0;
 }
 EXPORT_SYMBOL(__kmalloc);
 
@@ -462,59 +443,33 @@ EXPORT_SYMBOL(krealloc);
 void kfree(const void *block)
 {
 	struct slob_page *sp;
-	slob_t *m;
-	bigblock_t *bb, **last = &bigblocks;
-	unsigned long flags;
 
 	if (!block)
 		return;
 
 	sp = (struct slob_page *)virt_to_page(block);
-	if (!slob_page(sp)) {
-		/* on the big block list */
-		spin_lock_irqsave(&block_lock, flags);
-		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
-			if (bb->pages == block) {
-				*last = bb->next;
-				spin_unlock_irqrestore(&block_lock, flags);
-				free_pages((unsigned long)block, bb->order);
-				slob_free(bb, sizeof(bigblock_t));
-				return;
-			}
-		}
-		spin_unlock_irqrestore(&block_lock, flags);
-		WARN_ON(1);
-		return;
-	}
-
-	m = (slob_t *)block - 1;
-	slob_free(m, m->units + SLOB_UNIT);
-	return;
+	if (slob_page(sp)) {
+		slob_t *m = (slob_t *)block - 1;
+		slob_free(m, m->units + SLOB_UNIT);
+	} else
+		put_page(&sp->page);
 }
 
 EXPORT_SYMBOL(kfree);
 
+/* can't use ksize for kmem_cache_alloc memory, only kmalloc */
 size_t ksize(const void *block)
 {
 	struct slob_page *sp;
-	bigblock_t *bb;
-	unsigned long flags;
 
 	if (!block)
 		return 0;
 
 	sp = (struct slob_page *)virt_to_page(block);
-	if (!slob_page(sp)) {
-		spin_lock_irqsave(&block_lock, flags);
-		for (bb = bigblocks; bb; bb = bb->next)
-			if (bb->pages == block) {
-				spin_unlock_irqrestore(&slob_lock, flags);
-				return PAGE_SIZE << bb->order;
-			}
-		spin_unlock_irqrestore(&block_lock, flags);
-	}
-
-	return ((slob_t *)block - 1)->units + SLOB_UNIT;
+	if (slob_page(sp))
+		return ((slob_t *)block - 1)->units + SLOB_UNIT;
+	else
+		return sp->page.private;
 }
 
 struct kmem_cache {
_

Patches currently in -mm which might be from npiggin@suse.de are

origin.patch
mm-fix-fault-vs-invalidate-race-for-linear-mappings.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
mm-fault-feedback-1.patch
mm-fault-feedback-2.patch
mm-fix-clear_page_dirty_for_io-vs-fault-race.patch
mm-revert-kernel_ds-buffered-write-optimisation.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
mm-debug-write-deadlocks.patch
mm-trim-more-holes.patch
mm-buffered-write-cleanup.patch
mm-write-iovec-cleanup.patch
mm-fix-pagecache-write-deadlocks.patch
mm-buffered-write-iterator.patch
fs-fix-data-loss-on-error.patch
fs-introduce-write_begin-write_end-and-perform_write-aops.patch
mm-restore-kernel_ds-optimisations.patch
implement-simple-fs-aops.patch
block_dev-convert-to-new-aops.patch
ext2-convert-to-new-aops.patch
ext3-convert-to-new-aops.patch
ext3-convert-to-new-aops-fix.patch
ext4-convert-to-new-aops.patch
ext4-convert-to-new-aops-fix.patch
xfs-convert-to-new-aops.patch
fs-new-cont-helpers.patch
fat-convert-to-new-aops.patch
hfs-convert-to-new-aops.patch
hfsplus-convert-to-new-aops.patch
hpfs-convert-to-new-aops.patch
bfs-convert-to-new-aops.patch
qnx4-convert-to-new-aops.patch
reiserfs-use-generic-write.patch
reiserfs-convert-to-new-aops.patch
reiserfs-use-generic_cont_expand_simple.patch
with-reiserfs-no-longer-using-the-weird-generic_cont_expand-remove-it-completely.patch
nfs-convert-to-new-aops.patch
smb-convert-to-new-aops.patch
fuse-convert-to-new-aops.patch
hostfs-convert-to-new-aops.patch
jffs2-convert-to-new-aops.patch
ufs-convert-to-new-aops.patch
udf-convert-to-new-aops.patch
sysv-convert-to-new-aops.patch
minix-convert-to-new-aops.patch
jfs-convert-to-new-aops.patch
fs-adfs-convert-to-new-aops.patch
fs-affs-convert-to-new-aops.patch
ocfs2-convert-to-new-aops.patch
fix-read-truncate-race.patch
fs-remove-some-aop_truncated_page.patch
fs-introduce-some-page-buffer-invariants.patch
fs-reiserfs-cleanups.patch
fs-introduce-write_begin-write_end-and-perform_write-aops-revoke.patch
reiser4-fix-for-new-aops-patches.patch
