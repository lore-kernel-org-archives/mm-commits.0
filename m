From: akpm@linux-foundation.org
Subject: - define-functions-for-page-cache-handling.patch removed from -mm tree
Date: Tue, 04 Mar 2008 11:47:30 -0800
Message-ID: <200803041947.m24JlU2S025672@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47754 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750765AbYCDTsC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Mar 2008 14:48:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clameter@sgi.com, dgc@sgi.com, mm-commits@vger.kernel.org


The patch titled
     Define functions for page cache handling
has been removed from the -mm tree.  Its filename was
     define-functions-for-page-cache-handling.patch

This patch was dropped because it was nacked

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Define functions for page cache handling
From: Christoph Lameter <clameter@sgi.com>

We use the macros PAGE_CACHE_SIZE PAGE_CACHE_SHIFT PAGE_CACHE_MASK and
PAGE_CACHE_ALIGN in various places in the kernel.  Many times common
operations like calculating the offset or the index are coded using shifts and
adds.  This patch provides inline functions to get the calculations
accomplished without having to explicitly shift and add constants.

All functions take an address_space pointer. The address space pointer
will be used in the future to eventually support a variable size
page cache. Information reachable via the mapping may then determine
page size.

New function                    Related base page constant
====================================================================
page_cache_shift(a)             PAGE_CACHE_SHIFT
page_cache_size(a)              PAGE_CACHE_SIZE
page_cache_mask(a)              PAGE_CACHE_MASK
page_cache_index(a, pos)        Calculate page number from position
page_cache_next(addr, pos)      Page number of next page
page_cache_offset(a, pos)       Calculate offset into a page
page_cache_pos(a, index, offset)
                                Form position based on page number
                                and an offset.

This provides a basis that would allow the conversion of all page cache
handling in the kernel and ultimately allow the removal of the PAGE_CACHE_*
constants.

Reviewed-by: Dave Chinner <dgc@sgi.com>
Signed-off-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |   49 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff -puN include/linux/pagemap.h~define-functions-for-page-cache-handling include/linux/pagemap.h
--- a/include/linux/pagemap.h~define-functions-for-page-cache-handling
+++ a/include/linux/pagemap.h
@@ -52,12 +52,61 @@ static inline void mapping_set_gfp_mask(
  * space in smaller chunks for same flexibility).
  *
  * Or rather, it _will_ be done in larger chunks.
+ *
+ * The following constants can be used if a filesystem only supports a single
+ * page size.
  */
 #define PAGE_CACHE_SHIFT	PAGE_SHIFT
 #define PAGE_CACHE_SIZE		PAGE_SIZE
 #define PAGE_CACHE_MASK		PAGE_MASK
 #define PAGE_CACHE_ALIGN(addr)	(((addr)+PAGE_CACHE_SIZE-1)&PAGE_CACHE_MASK)
 
+/*
+ * Functions that are currently setup for a fixed PAGE_SIZE. The use of
+ * these may allow larger page sizes in the future.
+ */
+static inline int mapping_order(struct address_space *mapping)
+{
+	return 0;
+}
+
+static inline int page_cache_shift(struct address_space *mapping)
+{
+	return PAGE_SHIFT;
+}
+
+static inline unsigned int page_cache_size(struct address_space *mapping)
+{
+	return PAGE_SIZE;
+}
+
+static inline unsigned int page_cache_offset(struct address_space *mapping,
+		loff_t pos)
+{
+	return pos & ~PAGE_MASK;
+}
+
+static inline pgoff_t page_cache_index(struct address_space *mapping,
+		loff_t pos)
+{
+	return pos >> page_cache_shift(mapping);
+}
+
+/*
+ * Index of the page starting on or after the given position.
+ */
+static inline pgoff_t page_cache_next(struct address_space *mapping,
+		loff_t pos)
+{
+	return page_cache_index(mapping, pos + page_cache_size(mapping) - 1);
+}
+
+static inline loff_t page_cache_pos(struct address_space *mapping,
+		pgoff_t index, unsigned long offset)
+{
+	return ((loff_t)index << page_cache_shift(mapping)) + offset;
+}
+
 #define page_cache_get(page)		get_page(page)
 #define page_cache_release(page)	put_page(page)
 void release_pages(struct page **pages, int nr, int cold);
_

Patches currently in -mm which might be from clameter@sgi.com are

origin.patch
define-functions-for-page-cache-handling.patch
use-page_cache_xxx-in-fs-splicec.patch
git-unionfs.patch
use-page_cache_xxx-for-fs-xfs.patch
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
use-page_cache_xxx-functions-in-mm-filemapc.patch
use-page_cache_xxx-in-mm-page-writebackc.patch
use-page_cache_xxx-in-mm-truncatec.patch
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

