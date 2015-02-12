From: akpm@linux-foundation.org
Subject: [merged]
 mm-more-checks-on-free_pages_prepare-for-tail-pages.patch removed from -mm
 tree
Date: Thu, 12 Feb 2015 11:36:46 -0800
Message-ID: <54dd00ce.B/ATp4xuMVzqhXra%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58127 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbbBLTgr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Feb 2015 14:36:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: more checks on free_pages_prepare() for tail pages
has been removed from the -mm tree.  Its filename was
     mm-more-checks-on-free_pages_prepare-for-tail-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: more checks on free_pages_prepare() for tail pages

Although it was not called, destroy_compound_page() did some potentially
useful checks.  Let's re-introduce them in free_pages_prepare(), where
they can be actually triggered when CONFIG_DEBUG_VM=y.

compound_order() assert is already in free_pages_prepare().  We have few
checks for tail pages left.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff -puN mm/page_alloc.c~mm-more-checks-on-free_pages_prepare-for-tail-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-more-checks-on-free_pages_prepare-for-tail-pages
+++ a/mm/page_alloc.c
@@ -764,21 +764,40 @@ static void free_one_page(struct zone *z
 	spin_unlock(&zone->lock);
 }
 
+static int free_tail_pages_check(struct page *head_page, struct page *page)
+{
+	if (!IS_ENABLED(CONFIG_DEBUG_VM))
+		return 0;
+	if (unlikely(!PageTail(page))) {
+		bad_page(page, "PageTail not set", 0);
+		return 1;
+	}
+	if (unlikely(page->first_page != head_page)) {
+		bad_page(page, "first_page not consistent", 0);
+		return 1;
+	}
+	return 0;
+}
+
 static bool free_pages_prepare(struct page *page, unsigned int order)
 {
-	int i;
-	int bad = 0;
+	bool compound = PageCompound(page);
+	int i, bad = 0;
 
 	VM_BUG_ON_PAGE(PageTail(page), page);
-	VM_BUG_ON_PAGE(PageHead(page) && compound_order(page) != order, page);
+	VM_BUG_ON_PAGE(compound && compound_order(page) != order, page);
 
 	trace_mm_page_free(page, order);
 	kmemcheck_free_shadow(page, order);
 
 	if (PageAnon(page))
 		page->mapping = NULL;
-	for (i = 0; i < (1 << order); i++)
+	bad += free_pages_check(page);
+	for (i = 1; i < (1 << order); i++) {
+		if (compound)
+			bad += free_tail_pages_check(page, page + i);
 		bad += free_pages_check(page + i);
+	}
 	if (bad)
 		return false;
 
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

