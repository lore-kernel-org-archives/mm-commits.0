From: akpm@linux-foundation.org
Subject: [merged] mm-page_allocc-drop-dead-destroy_compound_page.patch
 removed from -mm tree
Date: Thu, 12 Feb 2015 11:36:44 -0800
Message-ID: <54dd00cc.yVRRxhL16u4meQ1s%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbbBLTgp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: drop dead destroy_compound_page()
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-drop-dead-destroy_compound_page.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm/page_alloc.c: drop dead destroy_compound_page()

The only caller is __free_one_page(). By the time we should have
page->flags to be cleared already:

 - for 0-order pages though PCP list:
	free_hot_cold_page()
		free_pages_prepare()
			free_pages_check()
				page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
		<put the page to PCP list>

	free_pcppages_bulk()
		page = <withdraw pages from PCP list>
		__free_one_page(page)

 - for non-0-order pages:
	__free_pages_ok()
		free_pages_prepare()
			free_pages_check()
				page->flags &= ~PAGE_FLAGS_CHECK_AT_PREP;
		free_one_page()
			__free_one_page()

So there's no way PageCompound() will return true in __free_one_page().
Let's remove dead destroy_compound_page() and put assert for page->flags
there instead.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   35 +----------------------------------
 1 file changed, 1 insertion(+), 34 deletions(-)

diff -puN mm/page_alloc.c~mm-page_allocc-drop-dead-destroy_compound_page mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_allocc-drop-dead-destroy_compound_page
+++ a/mm/page_alloc.c
@@ -381,36 +381,6 @@ void prep_compound_page(struct page *pag
 	}
 }
 
-/* update __split_huge_page_refcount if you change this function */
-static int destroy_compound_page(struct page *page, unsigned long order)
-{
-	int i;
-	int nr_pages = 1 << order;
-	int bad = 0;
-
-	if (unlikely(compound_order(page) != order)) {
-		bad_page(page, "wrong compound order", 0);
-		bad++;
-	}
-
-	__ClearPageHead(page);
-
-	for (i = 1; i < nr_pages; i++) {
-		struct page *p = page + i;
-
-		if (unlikely(!PageTail(p))) {
-			bad_page(page, "PageTail not set", 0);
-			bad++;
-		} else if (unlikely(p->first_page != page)) {
-			bad_page(page, "first_page not consistent", 0);
-			bad++;
-		}
-		__ClearPageTail(p);
-	}
-
-	return bad;
-}
-
 static inline void prep_zero_page(struct page *page, unsigned int order,
 							gfp_t gfp_flags)
 {
@@ -613,10 +583,7 @@ static inline void __free_one_page(struc
 	int max_order = MAX_ORDER;
 
 	VM_BUG_ON(!zone_is_initialized(zone));
-
-	if (unlikely(PageCompound(page)))
-		if (unlikely(destroy_compound_page(page, order)))
-			return;
+	VM_BUG_ON_PAGE(page->flags & PAGE_FLAGS_CHECK_AT_PREP, page);
 
 	VM_BUG_ON(migratetype == -1);
 	if (is_migrate_isolate(migratetype)) {
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

origin.patch
mm-numa-do-not-dereference-pmd-outside-of-the-lock-during-numa-hinting-fault.patch
mm-add-p-protnone-helpers-for-use-by-numa-balancing.patch
mm-convert-p_numa-users-to-p_protnone_numa.patch
ppc64-add-paranoid-warnings-for-unexpected-dsisr_protfault.patch
mm-convert-p_mknonnuma-and-remaining-page-table-manipulations.patch
mm-remove-remaining-references-to-numa-hinting-bits-and-helpers.patch
mm-numa-do-not-trap-faults-on-the-huge-zero-page.patch
x86-mm-restore-original-pte_special-check.patch
mm-numa-add-paranoid-check-around-pte_protnone_numa.patch
mm-numa-avoid-unnecessary-tlb-flushes-when-setting-numa-hinting-entries.patch
mm-do-not-use-mm-nr_pmds-on-mmu-configurations.patch
mm-fix-xip-fault-vs-truncate-race.patch
mm-fix-xip-fault-vs-truncate-race-fix.patch
mm-allow-page-fault-handlers-to-perform-the-cow.patch
mm-allow-page-fault-handlers-to-perform-the-cow-fix.patch
vfsext2-introduce-is_daxinode.patch
daxext2-replace-xip-read-and-write-with-dax-i-o.patch
daxext2-replace-ext2_clear_xip_target-with-dax_clear_blocks.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler.patch
daxext2-replace-the-xip-page-fault-handler-with-the-dax-page-fault-handler-fix.patch
daxext2-replace-xip_truncate_page-with-dax_truncate_page.patch
dax-replace-xip-documentation-with-dax-documentation.patch
vfs-remove-get_xip_mem.patch
ext2-remove-ext2_xip_verify_sb.patch
ext2-remove-ext2_use_xip.patch
ext2-remove-xipc-and-xiph.patch
vfsext2-remove-config_ext2_fs_xip-and-rename-config_fs_xip-to-config_fs_dax.patch
ext2-remove-ext2_aops_xip.patch
ext2-get-rid-of-most-mentions-of-xip-in-ext2.patch
dax-add-dax_zero_page_range.patch
dax-add-dax_zero_page_range-fix.patch
ext4-add-dax-functionality.patch
brd-rename-xip-to-dax.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch

