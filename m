From: akpm@linux-foundation.org
Subject: [merged]
 mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:02:35 -0800
Message-ID: <569e965b.NC/0YyyLm3z3MwqT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42950 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757110AbcASUCg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: differentiate page_mapped() from page_mapcount() for compound pages
has been removed from the -mm tree.  Its filename was
     mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: differentiate page_mapped() from page_mapcount() for compound pages

Let's define page_mapped() to be true for compound pages if any
sub-pages of the compound page is mapped (with PMD or PTE).

On other hand page_mapcount() return mapcount for this particular small
page.

This will make cases like page_get_anon_vma() behave correctly once we
allow huge pages to be mapped with PTE.

Most users outside core-mm should use page_mapcount() instead of
page_mapped().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/cache.c    |    4 ++--
 arch/arm/mm/flush.c    |    2 +-
 arch/mips/mm/c-r4k.c   |    3 ++-
 arch/mips/mm/cache.c   |    2 +-
 arch/mips/mm/init.c    |    6 +++---
 arch/sh/mm/cache-sh4.c |    2 +-
 arch/sh/mm/cache.c     |    8 ++++----
 arch/xtensa/mm/tlb.c   |    2 +-
 fs/proc/page.c         |    4 ++--
 include/linux/mm.h     |   15 +++++++++++++--
 mm/filemap.c           |    2 +-
 11 files changed, 31 insertions(+), 19 deletions(-)

diff -puN arch/arc/mm/cache.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages arch/arc/mm/cache.c
--- a/arch/arc/mm/cache.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages
+++ a/arch/arc/mm/cache.c
@@ -617,7 +617,7 @@ void flush_dcache_page(struct page *page
 	 */
 	if (!mapping_mapped(mapping)) {
 		clear_bit(PG_dc_clean, &page->flags);
-	} else if (page_mapped(page)) {
+	} else if (page_mapcount(page)) {
 
 		/* kernel reading from page with U-mapping */
 		phys_addr_t paddr = (unsigned long)page_address(page);
@@ -857,7 +857,7 @@ void copy_user_highpage(struct page *to,
 	 * For !VIPT cache, all of this gets compiled out as
 	 * addr_not_cache_congruent() is 0
 	 */
-	if (page_mapped(from) && addr_not_cache_congruent(kfrom, u_vaddr)) {
+	if (page_mapcount(from) && addr_not_cache_congruent(kfrom, u_vaddr)) {
 		__flush_dcache_page((unsigned long)kfrom, u_vaddr);
 		clean_src_k_mappings = 1;
 	}
diff -puN arch/arm/mm/flush.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages arch/arm/mm/flush.c
--- a/arch/arm/mm/flush.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages
+++ a/arch/arm/mm/flush.c
@@ -330,7 +330,7 @@ void flush_dcache_page(struct page *page
 	mapping = page_mapping(page);
 
 	if (!cache_ops_need_broadcast() &&
-	    mapping && !page_mapped(page))
+	    mapping && !page_mapcount(page))
 		clear_bit(PG_dcache_clean, &page->flags);
 	else {
 		__flush_dcache_page(mapping, page);
diff -puN arch/mips/mm/c-r4k.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages arch/mips/mm/c-r4k.c
--- a/arch/mips/mm/c-r4k.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages
+++ a/arch/mips/mm/c-r4k.c
@@ -587,7 +587,8 @@ static inline void local_r4k_flush_cache
 		 * another ASID than the current one.
 		 */
 		map_coherent = (cpu_has_dc_aliases &&
-				page_mapped(page) && !Page_dcache_dirty(page));
+				page_mapcount(page) &&
+				!Page_dcache_dirty(page));
 		if (map_coherent)
 			vaddr = kmap_coherent(page, addr);
 		else
diff -puN arch/mips/mm/cache.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages arch/mips/mm/cache.c
--- a/arch/mips/mm/cache.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages
+++ a/arch/mips/mm/cache.c
@@ -106,7 +106,7 @@ void __flush_anon_page(struct page *page
 	unsigned long addr = (unsigned long) page_address(page);
 
 	if (pages_do_alias(addr, vmaddr)) {
-		if (page_mapped(page) && !Page_dcache_dirty(page)) {
+		if (page_mapcount(page) && !Page_dcache_dirty(page)) {
 			void *kaddr;
 
 			kaddr = kmap_coherent(page, vmaddr);
diff -puN arch/mips/mm/init.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages arch/mips/mm/init.c
--- a/arch/mips/mm/init.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages
+++ a/arch/mips/mm/init.c
@@ -165,7 +165,7 @@ void copy_user_highpage(struct page *to,
 
 	vto = kmap_atomic(to);
 	if (cpu_has_dc_aliases &&
-	    page_mapped(from) && !Page_dcache_dirty(from)) {
+	    page_mapcount(from) && !Page_dcache_dirty(from)) {
 		vfrom = kmap_coherent(from, vaddr);
 		copy_page(vto, vfrom);
 		kunmap_coherent();
@@ -187,7 +187,7 @@ void copy_to_user_page(struct vm_area_st
 	unsigned long len)
 {
 	if (cpu_has_dc_aliases &&
-	    page_mapped(page) && !Page_dcache_dirty(page)) {
+	    page_mapcount(page) && !Page_dcache_dirty(page)) {
 		void *vto = kmap_coherent(page, vaddr) + (vaddr & ~PAGE_MASK);
 		memcpy(vto, src, len);
 		kunmap_coherent();
@@ -205,7 +205,7 @@ void copy_from_user_page(struct vm_area_
 	unsigned long len)
 {
 	if (cpu_has_dc_aliases &&
-	    page_mapped(page) && !Page_dcache_dirty(page)) {
+	    page_mapcount(page) && !Page_dcache_dirty(page)) {
 		void *vfrom = kmap_coherent(page, vaddr) + (vaddr & ~PAGE_MASK);
 		memcpy(dst, vfrom, len);
 		kunmap_coherent();
diff -puN arch/sh/mm/cache-sh4.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages arch/sh/mm/cache-sh4.c
--- a/arch/sh/mm/cache-sh4.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages
+++ a/arch/sh/mm/cache-sh4.c
@@ -241,7 +241,7 @@ static void sh4_flush_cache_page(void *a
 		 */
 		map_coherent = (current_cpu_data.dcache.n_aliases &&
 			test_bit(PG_dcache_clean, &page->flags) &&
-			page_mapped(page));
+			page_mapcount(page));
 		if (map_coherent)
 			vaddr = kmap_coherent(page, address);
 		else
diff -puN arch/sh/mm/cache.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages arch/sh/mm/cache.c
--- a/arch/sh/mm/cache.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages
+++ a/arch/sh/mm/cache.c
@@ -59,7 +59,7 @@ void copy_to_user_page(struct vm_area_st
 		       unsigned long vaddr, void *dst, const void *src,
 		       unsigned long len)
 {
-	if (boot_cpu_data.dcache.n_aliases && page_mapped(page) &&
+	if (boot_cpu_data.dcache.n_aliases && page_mapcount(page) &&
 	    test_bit(PG_dcache_clean, &page->flags)) {
 		void *vto = kmap_coherent(page, vaddr) + (vaddr & ~PAGE_MASK);
 		memcpy(vto, src, len);
@@ -78,7 +78,7 @@ void copy_from_user_page(struct vm_area_
 			 unsigned long vaddr, void *dst, const void *src,
 			 unsigned long len)
 {
-	if (boot_cpu_data.dcache.n_aliases && page_mapped(page) &&
+	if (boot_cpu_data.dcache.n_aliases && page_mapcount(page) &&
 	    test_bit(PG_dcache_clean, &page->flags)) {
 		void *vfrom = kmap_coherent(page, vaddr) + (vaddr & ~PAGE_MASK);
 		memcpy(dst, vfrom, len);
@@ -97,7 +97,7 @@ void copy_user_highpage(struct page *to,
 
 	vto = kmap_atomic(to);
 
-	if (boot_cpu_data.dcache.n_aliases && page_mapped(from) &&
+	if (boot_cpu_data.dcache.n_aliases && page_mapcount(from) &&
 	    test_bit(PG_dcache_clean, &from->flags)) {
 		vfrom = kmap_coherent(from, vaddr);
 		copy_page(vto, vfrom);
@@ -153,7 +153,7 @@ void __flush_anon_page(struct page *page
 	unsigned long addr = (unsigned long) page_address(page);
 
 	if (pages_do_alias(addr, vmaddr)) {
-		if (boot_cpu_data.dcache.n_aliases && page_mapped(page) &&
+		if (boot_cpu_data.dcache.n_aliases && page_mapcount(page) &&
 		    test_bit(PG_dcache_clean, &page->flags)) {
 			void *kaddr;
 
diff -puN arch/xtensa/mm/tlb.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages arch/xtensa/mm/tlb.c
--- a/arch/xtensa/mm/tlb.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages
+++ a/arch/xtensa/mm/tlb.c
@@ -245,7 +245,7 @@ static int check_tlb_entry(unsigned w, u
 						page_mapcount(p));
 				if (!page_count(p))
 					rc |= TLB_INSANE;
-				else if (page_mapped(p))
+				else if (page_mapcount(p))
 					rc |= TLB_SUSPICIOUS;
 			} else {
 				rc |= TLB_INSANE;
diff -puN fs/proc/page.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages fs/proc/page.c
--- a/fs/proc/page.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages
+++ a/fs/proc/page.c
@@ -103,9 +103,9 @@ u64 stable_page_flags(struct page *page)
 	 * pseudo flags for the well known (anonymous) memory mapped pages
 	 *
 	 * Note that page->_mapcount is overloaded in SLOB/SLUB/SLQB, so the
-	 * simple test in page_mapped() is not enough.
+	 * simple test in page_mapcount() is not enough.
 	 */
-	if (!PageSlab(page) && page_mapped(page))
+	if (!PageSlab(page) && page_mapcount(page))
 		u |= 1 << KPF_MMAP;
 	if (PageAnon(page))
 		u |= 1 << KPF_ANON;
diff -puN include/linux/mm.h~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages
+++ a/include/linux/mm.h
@@ -953,10 +953,21 @@ static inline pgoff_t page_file_index(st
 
 /*
  * Return true if this page is mapped into pagetables.
+ * For compound page it returns true if any subpage of compound page is mapped.
  */
-static inline int page_mapped(struct page *page)
+static inline bool page_mapped(struct page *page)
 {
-	return atomic_read(&(page)->_mapcount) + compound_mapcount(page) >= 0;
+	int i;
+	if (likely(!PageCompound(page)))
+		return atomic_read(&page->_mapcount) >= 0;
+	page = compound_head(page);
+	if (atomic_read(compound_mapcount_ptr(page)) >= 0)
+		return true;
+	for (i = 0; i < hpage_nr_pages(page); i++) {
+		if (atomic_read(&page[i]._mapcount) >= 0)
+			return true;
+	}
+	return false;
 }
 
 /*
diff -puN mm/filemap.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages mm/filemap.c
--- a/mm/filemap.c~mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages
+++ a/mm/filemap.c
@@ -204,7 +204,7 @@ void __delete_from_page_cache(struct pag
 		__dec_zone_page_state(page, NR_FILE_PAGES);
 	if (PageSwapBacked(page))
 		__dec_zone_page_state(page, NR_SHMEM);
-	BUG_ON(page_mapped(page));
+	VM_BUG_ON_PAGE(page_mapped(page), page);
 
 	/*
 	 * At this point page must be either written or cleaned by truncate.
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

