From: akpm@linux-foundation.org
Subject: + mm-page_allocc-drop-dead-destroy_compound_page.patch added to
 -mm tree
Date: Fri, 09 Jan 2015 16:24:25 -0800
Message-ID: <54b07139.XW2GXFzp9Jc1+TDh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAJAY1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 9 Jan 2015 19:24:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: drop dead destroy_compound_page()
has been added to the -mm tree.  Its filename is
     mm-page_allocc-drop-dead-destroy_compound_page.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_allocc-drop-dead-destroy_compound_page.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_allocc-drop-dead-destroy_compound_page.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-protect-set_page_dirty-from-ongoing-truncation.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
mm-drop-support-of-non-linear-mapping-from-unmap-zap-codepath.patch
mm-drop-support-of-non-linear-mapping-from-fault-codepath.patch
mm-drop-vm_ops-remap_pages-and-generic_file_remap_pages-stub.patch
proc-drop-handling-non-linear-mappings.patch
rmap-drop-support-of-non-linear-mappings.patch
mm-replace-vma-shareadlinear-with-vma-shared.patch
mm-remove-rest-usage-of-vm_nonlinear-and-pte_file.patch
asm-generic-drop-unused-pte_file-helpers.patch
alpha-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers.patch
arc-drop-_page_file-and-pte_file-related-helpers-fix.patch
arm64-drop-pte_file-and-pte_file-related-helpers.patch
arm-drop-l_pte_file-and-pte_file-related-helpers.patch
avr32-drop-_page_file-and-pte_file-related-helpers.patch
blackfin-drop-pte_file.patch
c6x-drop-pte_file.patch
cris-drop-_page_file-and-pte_file-related-helpers.patch
frv-drop-_page_file-and-pte_file-related-helpers.patch
hexagon-drop-_page_file-and-pte_file-related-helpers.patch
ia64-drop-_page_file-and-pte_file-related-helpers.patch
m32r-drop-_page_file-and-pte_file-related-helpers.patch
m68k-drop-_page_file-and-pte_file-related-helpers.patch
metag-drop-_page_file-and-pte_file-related-helpers.patch
microblaze-drop-_page_file-and-pte_file-related-helpers.patch
mips-drop-_page_file-and-pte_file-related-helpers.patch
mn10300-drop-_page_file-and-pte_file-related-helpers.patch
nios2-drop-_page_file-and-pte_file-related-helpers.patch
openrisc-drop-_page_file-and-pte_file-related-helpers.patch
parisc-drop-_page_file-and-pte_file-related-helpers.patch
powerpc-drop-_page_file-and-pte_file-related-helpers.patch
s390-drop-pte_file-related-helpers.patch
score-drop-_page_file-and-pte_file-related-helpers.patch
sh-drop-_page_file-and-pte_file-related-helpers.patch
sparc-drop-pte_file-related-helpers.patch
tile-drop-pte_file-related-helpers.patch
um-drop-_page_file-and-pte_file-related-helpers.patch
unicore32-drop-pte_file-related-helpers.patch
x86-drop-_page_file-and-pte_file-related-helpers.patch
xtensa-drop-_page_file-and-pte_file-related-helpers.patch
mm-memory-remove-vm_file-check-on-shared-writable-vmas.patch
mm-memory-merge-shared-writable-dirtying-branches-in-do_wp_page.patch
mm-add-fields-for-compound-destructor-and-order-into-struct-page.patch
mm-add-vm_bug_on_page-for-page_mapcount.patch
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
mm-set-page-pfmemalloc-in-prep_new_page.patch
mm-page_alloc-reduce-number-of-alloc_pages-functions-parameters.patch
mm-reduce-try_to_compact_pages-parameters.patch
mm-microoptimize-zonelist-operations.patch
mm-page_allocc-drop-dead-destroy_compound_page.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages.patch
mm-more-checks-on-free_pages_prepare-for-tail-pages-fix.patch

