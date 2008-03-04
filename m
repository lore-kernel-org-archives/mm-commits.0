From: akpm@linux-foundation.org
Subject: - use-page_cache_xxx-in-mm-rmapc.patch removed from -mm tree
Date: Tue, 04 Mar 2008 11:47:43 -0800
Message-ID: <200803041947.m24JlhjA025690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578AbYCDTsO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 14:48:14 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dgc@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Use page_cache_xxx in mm/rmap.c
has been removed from the -mm tree.  Its filename was
     use-page_cache_xxx-in-mm-rmapc.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Use page_cache_xxx in mm/rmap.c
From: Christoph Lameter <clameter@sgi.com>

Use page_cache_xxx in mm/rmap.c

Reviewed-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff -puN mm/rmap.c~use-page_cache_xxx-in-mm-rmapc mm/rmap.c
--- a/mm/rmap.c~use-page_cache_xxx-in-mm-rmapc
+++ a/mm/rmap.c
@@ -190,9 +190,21 @@ static void page_unlock_anon_vma(struct 
 static inline unsigned long
 vma_address(struct page *page, struct vm_area_struct *vma)
 {
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff;
 	unsigned long address;
 
+	if (PageAnon(page))
+		pgoff = page->index;
+	else {
+		struct address_space *mapping = page->mapping;
+
+		if (!mapping)
+			/* Page was truncated */
+			return -EFAULT;
+
+		pgoff = page->index << mapping_order(mapping);
+	}
+
 	address = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 	if (unlikely(address < vma->vm_start || address >= vma->vm_end)) {
 		/* page should be within @vma mapping range */
@@ -348,7 +360,7 @@ static int page_referenced_file(struct p
 {
 	unsigned int mapcount;
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff;
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 	int referenced = 0;
@@ -368,6 +380,9 @@ static int page_referenced_file(struct p
 	 */
 	BUG_ON(!PageLocked(page));
 
+	/* Safe to use mapping */
+	pgoff = page->index << mapping_order(mapping);
+
 	spin_lock(&mapping->i_mmap_lock);
 
 	/*
@@ -468,7 +483,7 @@ out:
 
 static int page_mkclean_file(struct address_space *mapping, struct page *page)
 {
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = page->index << mapping_order(mapping);
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 	int ret = 0;
@@ -898,7 +913,7 @@ static int try_to_unmap_anon(struct page
 static int try_to_unmap_file(struct page *page, int migration)
 {
 	struct address_space *mapping = page->mapping;
-	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
+	pgoff_t pgoff = page->index << mapping_order(mapping);
 	struct vm_area_struct *vma;
 	struct prio_tree_iter iter;
 	int ret = SWAP_AGAIN;
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
git-unionfs.patch
git-slub.patch
hugetlb-fix-pool-shrinking-while-in-restricted-cpuset.patch
x86-cast-cmpxchg-and-cmpxchg_local-result-for-386-and-486.patch
ntfs-fix-nommu-build.patch
slub-fix-possible-null-pointer-dereference.patch
slub-fix-possible-null-pointer-dereference-fix.patch
remove-set_migrateflags.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
use-page_cache_xxx-in-mm-rmapc.patch
use-page_cache_xxx-in-mm-filemap_xipc.patch
use-page_cache_xxx-in-mm-migratec.patch
use-page_cache_xxx-in-fs-libfsc.patch
use-page_cache_xxx-in-fs-sync.patch
use-page_cache_xxx-in-fs-bufferc.patch
use-page_cache_xxx-in-mm-mpagec.patch
use-page_cache_xxx-in-mm-fadvisec.patch
mm-move-cache_line_size-to-linux-cacheh.patch
use-page_cache_xxx-in-ext2.patch
use-page_cache_xxx-in-ext2-fix.patch
use-page_cache_xxx-in-ext2-fix-2.patch
use-page_cache_xxx-in-fs-ext3.patch
use-page_cache_xxx-in-fs-reiserfs.patch
use-page_cache_xxx-in-fs-ext4.patch
reiser4.patch
reiser4-portion-of-zero_user-cleanup-patch.patch
page-owner-tracking-leak-detector.patch

