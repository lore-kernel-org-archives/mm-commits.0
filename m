From: akpm@linux-foundation.org
Subject: + thp-reintroduce-split_huge_page-fix.patch added to -mm tree
Date: Fri, 15 Jan 2016 12:29:19 -0800
Message-ID: <5699569f.xTvm9yGhcRSaTyX5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbcAOU3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Jan 2016 15:29:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, sasha.levin@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: fix other mremap corner case handling in split_huge_page
has been added to the -mm tree.  Its filename is
     thp-reintroduce-split_huge_page-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-reintroduce-split_huge_page-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-reintroduce-split_huge_page-fix.patch

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
Subject: thp: fix other mremap corner case handling in split_huge_page

Syzkaller was able to trigger other corner case of splitting mremap()ed
transparent huge page:

	huge_memory: total_mapcount: 2, page_count(): 3
	page:ffffea0005e90000 count:3 mapcount:0 mapping:ffff88007b1177a1 index:0x400000000 compound_mapcount: 0
	flags: 0x2ffff000044079(locked|uptodate|dirty|lru|active|head|swapbacked)
	page dumped because: total_mapcount(head) > 0
	page->mem_cgroup:ffff88017b825be0
	------------[ cut here ]------------
	kernel BUG at /home/kas/linux/next/mm/huge_memory.c:3478!

The testcase to trigger the bug:

	#define _GNU_SOURCE
	#include <stdio.h>
	#include <stdlib.h>
	#include <unistd.h>
	#include <sys/mman.h>

	#define MB (1024UL*1024)
	#define SIZE (2*MB)
	#define BASE ((void *)0x400000000000)

	int main()
	{
		char *p;

		p = mmap(BASE, SIZE, PROT_READ | PROT_WRITE,
				MAP_FIXED | MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE,
				-1, 0);
		if (p == MAP_FAILED)
			perror("mmap"), exit(1);
		p = mremap(BASE + 8192, 8192, 8192, MREMAP_FIXED | MREMAP_MAYMOVE,
				BASE + 2 * SIZE);
		if (p == MAP_FAILED)
			perror("mremap"), exit(1);
		system("mount -t debugfs none /sys/kernel/debug");
		system("echo 1 > /sys/kernel/debug/split_huge_pages");
		return 0;
	}

Basically, in freeze/unfreeze_page() we should skip all pages which cannot
belong to the VMA before looking to the relevant page table.  Otherwise we
will request page table bases on head page's virtual address which may not
exist, like in test case above and we will miss PTEs.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff -puN mm/huge_memory.c~thp-reintroduce-split_huge_page-fix mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reintroduce-split_huge_page-fix
+++ a/mm/huge_memory.c
@@ -2899,7 +2899,15 @@ static void freeze_page_vma(struct vm_ar
 	pud_t *pud;
 	pmd_t *pmd;
 	pte_t *pte;
-	int i;
+	int i, nr = HPAGE_PMD_NR;
+
+	/* Skip pages which doesn't belong to the VMA */
+	if (address < vma->vm_start) {
+		int off = (vma->vm_start - address) >> PAGE_SHIFT;
+		page += off;
+		nr -= off;
+		address = vma->vm_start;
+	}
 
 	pgd = pgd_offset(vma->vm_mm, address);
 	if (!pgd_present(*pgd))
@@ -2922,7 +2930,7 @@ static void freeze_page_vma(struct vm_ar
 	spin_unlock(ptl);
 
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, address, &ptl);
-	for (i = 0; i < HPAGE_PMD_NR; i++, address += PAGE_SIZE, page++) {
+	for (i = 0; i < nr; i++, address += PAGE_SIZE, page++) {
 		pte_t entry, swp_pte;
 		swp_entry_t swp_entry;
 
@@ -2970,13 +2978,21 @@ static void unfreeze_page_vma(struct vm_
 	pmd_t *pmd;
 	pte_t *pte, entry;
 	swp_entry_t swp_entry;
-	int i;
+	int i, nr = HPAGE_PMD_NR;
+
+	/* Skip pages which doesn't belong to the VMA */
+	if (address < vma->vm_start) {
+		int off = (vma->vm_start - address) >> PAGE_SHIFT;
+		page += off;
+		nr -= off;
+		address = vma->vm_start;
+	}
 
 	pmd = mm_find_pmd(vma->vm_mm, address);
 	if (!pmd)
 		return;
 	pte = pte_offset_map_lock(vma->vm_mm, pmd, address, &ptl);
-	for (i = 0; i < HPAGE_PMD_NR; i++, address += PAGE_SIZE, page++) {
+	for (i = 0; i < nr; i++, address += PAGE_SIZE, page++) {
 		if (!is_swap_pte(pte[i]))
 			continue;
 
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

mm-make-sure-isolate_lru_page-is-never-called-for-tail-page.patch
page-flags-trivial-cleanup-for-pagetrans-helpers.patch
page-flags-move-code-around.patch
page-flags-introduce-page-flags-policies-wrt-compound-pages.patch
page-flags-define-pg_locked-behavior-on-compound-pages.patch
page-flags-define-behavior-of-fs-io-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-lru-related-flags-on-compound-pages.patch
page-flags-define-behavior-slb-related-flags-on-compound-pages.patch
page-flags-define-behavior-of-xen-related-flags-on-compound-pages.patch
page-flags-define-pg_reserved-behavior-on-compound-pages.patch
page-flags-define-pg_swapbacked-behavior-on-compound-pages.patch
page-flags-define-pg_swapcache-behavior-on-compound-pages.patch
page-flags-define-pg_mlocked-behavior-on-compound-pages.patch
page-flags-define-pg_uncached-behavior-on-compound-pages.patch
page-flags-define-pg_uptodate-behavior-on-compound-pages.patch
page-flags-look-at-head-page-if-the-flag-is-encoded-in-page-mapping.patch
mm-sanitize-page-mapping-for-tail-pages.patch
page-flags-drop-__testclearpage-helpers.patch
mm-proc-adjust-pss-calculation.patch
rmap-add-argument-to-charge-compound-page.patch
memcg-adjust-to-support-new-thp-refcounting.patch
mm-thp-adjust-conditions-when-we-can-reuse-the-page-on-wp-fault.patch
mm-adjust-foll_split-for-new-refcounting.patch
mm-handle-pte-mapped-tail-pages-in-gerneric-fast-gup-implementaiton.patch
thp-mlock-do-not-allow-huge-pages-in-mlocked-area.patch
khugepaged-ignore-pmd-tables-with-thp-mapped-with-ptes.patch
thp-rename-split_huge_page_pmd-to-split_huge_pmd.patch
mm-vmstats-new-thp-splitting-event.patch
mm-temporally-mark-thp-broken.patch
thp-drop-all-split_huge_page-related-code.patch
mm-drop-tail-page-refcounting.patch
futex-thp-remove-special-case-for-thp-in-get_futex_key.patch
ksm-prepare-to-new-thp-semantics.patch
mm-thp-remove-compound_lock.patch
arm64-thp-remove-infrastructure-for-handling-splitting-pmds.patch
arm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mips-thp-remove-infrastructure-for-handling-splitting-pmds.patch
powerpc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
s390-thp-remove-infrastructure-for-handling-splitting-pmds.patch
sparc-thp-remove-infrastructure-for-handling-splitting-pmds.patch
tile-thp-remove-infrastructure-for-handling-splitting-pmds.patch
x86-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-thp-remove-infrastructure-for-handling-splitting-pmds.patch
mm-rework-mapcount-accounting-to-enable-4k-mapping-of-thps.patch
mm-differentiate-page_mapped-from-page_mapcount-for-compound-pages.patch
mm-numa-skip-pte-mapped-thp-on-numa-fault.patch
thp-implement-split_huge_pmd.patch
thp-add-option-to-setup-migration-entries-during-pmd-split.patch
thp-mm-split_huge_page-caller-need-to-lock-page.patch
thp-reintroduce-split_huge_page.patch
thp-reintroduce-split_huge_page-fix.patch
migrate_pages-try-to-split-pages-on-qeueuing.patch
thp-introduce-deferred_split_huge_page.patch
mm-re-enable-thp.patch
thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
mm-dax-dax-pmd-vs-thp-pmd-vs-hugetlbfs-pmd-fix.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch

