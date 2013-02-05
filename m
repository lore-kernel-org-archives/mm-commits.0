From: akpm@linux-foundation.org
Subject: + mm-accelerate-mm_populate-treatment-of-thp-pages.patch added to -mm tree
Date: Mon, 04 Feb 2013 16:31:08 -0800
Message-ID: <20130205003109.667245A406B@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:36325 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab3BEAbK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Feb 2013 19:31:10 -0500
Received: by mail-qa0-f74.google.com with SMTP id o13so410992qaj.3
        for <mm-commits@vger.kernel.org>; Mon, 04 Feb 2013 16:31:10 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, aarcange@redhat.com, hughd@google.com, mgorman@suse.de, riel@redhat.com


The patch titled
     Subject: mm: accelerate mm_populate() treatment of THP pages
has been added to the -mm tree.  Its filename is
     mm-accelerate-mm_populate-treatment-of-thp-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: mm: accelerate mm_populate() treatment of THP pages

This change adds a follow_page_mask function which is equivalent to
follow_page, but with an extra page_mask argument.

follow_page_mask sets *page_mask to HPAGE_PMD_NR - 1 when it encounters a
THP page, and to 0 in other cases.

__get_user_pages() makes use of this in order to accelerate populating THP
ranges - that is, when both the pages and vmas arrays are NULL, we don't
need to iterate HPAGE_PMD_NR times to cover a single THP page (and we also
avoid taking mm->page_table_lock that many times).

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |   13 +++++++++++--
 mm/memory.c        |   31 +++++++++++++++++++++++--------
 mm/nommu.c         |    6 ++++--
 3 files changed, 38 insertions(+), 12 deletions(-)

diff -puN include/linux/mm.h~mm-accelerate-mm_populate-treatment-of-thp-pages include/linux/mm.h
--- a/include/linux/mm.h~mm-accelerate-mm_populate-treatment-of-thp-pages
+++ a/include/linux/mm.h
@@ -1626,8 +1626,17 @@ int vm_insert_pfn(struct vm_area_struct 
 int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
 			unsigned long pfn);
 
-struct page *follow_page(struct vm_area_struct *, unsigned long address,
-			unsigned int foll_flags);
+struct page *follow_page_mask(struct vm_area_struct *vma,
+			      unsigned long address, unsigned int foll_flags,
+			      unsigned int *page_mask);
+
+static inline struct page *follow_page(struct vm_area_struct *vma,
+		unsigned long address, unsigned int foll_flags)
+{
+	unsigned int unused_page_mask;
+	return follow_page_mask(vma, address, foll_flags, &unused_page_mask);
+}
+
 #define FOLL_WRITE	0x01	/* check pte is writable */
 #define FOLL_TOUCH	0x02	/* mark page accessed */
 #define FOLL_GET	0x04	/* do get_page on page */
diff -puN mm/memory.c~mm-accelerate-mm_populate-treatment-of-thp-pages mm/memory.c
--- a/mm/memory.c~mm-accelerate-mm_populate-treatment-of-thp-pages
+++ a/mm/memory.c
@@ -1462,10 +1462,11 @@ int zap_vma_ptes(struct vm_area_struct *
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
 /**
- * follow_page - look up a page descriptor from a user-virtual address
+ * follow_page_mask - look up a page descriptor from a user-virtual address
  * @vma: vm_area_struct mapping @address
  * @address: virtual address to look up
  * @flags: flags modifying lookup behaviour
+ * @page_mask: on output, *page_mask is set according to the size of the page
  *
  * @flags can have FOLL_ flags set, defined in <linux/mm.h>
  *
@@ -1473,8 +1474,9 @@ EXPORT_SYMBOL_GPL(zap_vma_ptes);
  * an error pointer if there is a mapping to something not represented
  * by a page descriptor (see also vm_normal_page()).
  */
-struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
-			unsigned int flags)
+struct page *follow_page_mask(struct vm_area_struct *vma,
+			      unsigned long address, unsigned int flags,
+			      unsigned int *page_mask)
 {
 	pgd_t *pgd;
 	pud_t *pud;
@@ -1484,6 +1486,8 @@ struct page *follow_page(struct vm_area_
 	struct page *page;
 	struct mm_struct *mm = vma->vm_mm;
 
+	*page_mask = 0;
+
 	page = follow_huge_addr(mm, address, flags & FOLL_WRITE);
 	if (!IS_ERR(page)) {
 		BUG_ON(flags & FOLL_GET);
@@ -1530,6 +1534,7 @@ struct page *follow_page(struct vm_area_
 				page = follow_trans_huge_pmd(vma, address,
 							     pmd, flags);
 				spin_unlock(&mm->page_table_lock);
+				*page_mask = HPAGE_PMD_NR - 1;
 				goto out;
 			}
 		} else
@@ -1684,6 +1689,7 @@ long __get_user_pages(struct task_struct
 {
 	long i;
 	unsigned long vm_flags;
+	unsigned int page_mask;
 
 	if (!nr_pages)
 		return 0;
@@ -1761,6 +1767,7 @@ long __get_user_pages(struct task_struct
 				get_page(page);
 			}
 			pte_unmap(pte);
+			page_mask = 0;
 			goto next_page;
 		}
 
@@ -1778,6 +1785,7 @@ long __get_user_pages(struct task_struct
 		do {
 			struct page *page;
 			unsigned int foll_flags = gup_flags;
+			unsigned int page_increm;
 
 			/*
 			 * If we have a pending SIGKILL, don't keep faulting
@@ -1787,7 +1795,8 @@ long __get_user_pages(struct task_struct
 				return i ? i : -ERESTARTSYS;
 
 			cond_resched();
-			while (!(page = follow_page(vma, start, foll_flags))) {
+			while (!(page = follow_page_mask(vma, start,
+						foll_flags, &page_mask))) {
 				int ret;
 				unsigned int fault_flags = 0;
 
@@ -1861,13 +1870,19 @@ long __get_user_pages(struct task_struct
 
 				flush_anon_page(vma, page, start);
 				flush_dcache_page(page);
+				page_mask = 0;
 			}
 next_page:
-			if (vmas)
+			if (vmas) {
 				vmas[i] = vma;
-			i++;
-			start += PAGE_SIZE;
-			nr_pages--;
+				page_mask = 0;
+			}
+			page_increm = 1 + (~(start >> PAGE_SHIFT) & page_mask);
+			if (page_increm > nr_pages)
+				page_increm = nr_pages;
+			i += page_increm;
+			start += page_increm * PAGE_SIZE;
+			nr_pages -= page_increm;
 		} while (nr_pages && start < vma->vm_end);
 	} while (nr_pages);
 	return i;
diff -puN mm/nommu.c~mm-accelerate-mm_populate-treatment-of-thp-pages mm/nommu.c
--- a/mm/nommu.c~mm-accelerate-mm_populate-treatment-of-thp-pages
+++ a/mm/nommu.c
@@ -1817,9 +1817,11 @@ SYSCALL_DEFINE5(mremap, unsigned long, a
 	return ret;
 }
 
-struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
-			unsigned int foll_flags)
+struct page *follow_page_mask(struct vm_area_struct *vma,
+			      unsigned long address, unsigned int flags,
+			      unsigned int *page_mask)
 {
+	*page_mask = 0;
 	return NULL;
 }
 
_

Patches currently in -mm which might be from walken@google.com are

thp-avoid-dumping-huge-zero-page.patch
linux-next.patch
mm-remove-free_area_cache-use-in-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-powerpc-architecture.patch
mm-use-vm_unmapped_area-on-ia64-architecture.patch
mm-use-vm_unmapped_area-in-hugetlbfs-on-ia64-architecture.patch
mm-use-vm_unmapped_area-on-parisc-architecture.patch
mm-make-mlockall-preserve-flags-other-than-vm_locked-in-def_flags.patch
mm-remap_file_pages-fixes.patch
mm-introduce-mm_populate-for-populating-new-vmas.patch
mm-use-mm_populate-for-blocking-remap_file_pages.patch
mm-use-mm_populate-when-adjusting-brk-with-mcl_future-in-effect.patch
mm-use-mm_populate-for-mremap-of-vm_locked-vmas.patch
mm-remove-flags-argument-to-mmap_region.patch
mm-remove-flags-argument-to-mmap_region-fix.patch
mm-directly-use-__mlock_vma_pages_range-in-find_extend_vma.patch
mm-introduce-vm_populate-flag-to-better-deal-with-racy-userspace-programs.patch
mm-make-do_mmap_pgoff-return-populate-as-a-size-in-bytes-not-as-a-bool.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages.patch
mm-use-long-type-for-page-counts-in-mm_populate-and-get_user_pages-fix.patch
mm-accelerate-mm_populate-treatment-of-thp-pages.patch
mm-accelerate-munlock-treatment-of-thp-pages.patch
mm-remove-free_area_cache.patch
mm-use-vm_unmapped_area-on-frv-architecture.patch
mm-use-vm_unmapped_area-on-alpha-architecture.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
mutex-subsystem-synchro-test-module.patch

