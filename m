From: akpm@linux-foundation.org
Subject: +
 mm-incorporate-read-only-pages-into-transparent-huge-pages.patch added to
 -mm tree
Date: Tue, 27 Jan 2015 14:12:39 -0800
Message-ID: <54c80d57.BH5MHLTULMKn+QKH%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38337 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760113AbbA0WMl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Jan 2015 17:12:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: incorporate read-only pages into transparent huge pages
has been added to the -mm tree.  Its filename is
     mm-incorporate-read-only-pages-into-transparent-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-incorporate-read-only-pages-into-transparent-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-incorporate-read-only-pages-into-transparent-huge-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Subject: mm: incorporate read-only pages into transparent huge pages

This patch aims to improve THP collapse rates, by allowing THP collapse in
the presence of read-only ptes, like those left in place by do_swap_page
after a read fault.

Currently THP can collapse 4kB pages into a THP when there are up to
khugepaged_max_ptes_none pte_none ptes in a 2MB range.  This patch applies
the same limit for read-only ptes.

The patch was tested with a test program that allocates 800MB of memory,
writes to it, and then sleeps.  I force the system to swap out all but
190MB of the program by touching other memory.  Afterwards, the test
program does a mix of reads and writes to its memory, and the memory gets
swapped back in.

Without the patch, only the memory that did not get swapped out remained
in THPs, which corresponds to 24% of the memory of the program.  The
percentage did not increase over time.

With this patch, after 5 minutes of waiting khugepaged had collapsed 50%
of the program's memory back into THPs.

Test results:

With the patch:
After swapped out:
cat /proc/pid/smaps:
Anonymous:      100464 kB
AnonHugePages:  100352 kB
Swap:           699540 kB
Fraction:       99,88

cat /proc/meminfo:
AnonPages:      1754448 kB
AnonHugePages:  1716224 kB
Fraction:       97,82

After swapped in:
In a few seconds:
cat /proc/pid/smaps:
Anonymous:      800004 kB
AnonHugePages:  145408 kB
Swap:           0 kB
Fraction:       18,17

cat /proc/meminfo:
AnonPages:      2455016 kB
AnonHugePages:  1761280 kB
Fraction:       71,74

In 5 minutes:
cat /proc/pid/smaps
Anonymous:      800004 kB
AnonHugePages:  407552 kB
Swap:           0 kB
Fraction:       50,94

cat /proc/meminfo:
AnonPages:      2456872 kB
AnonHugePages:  2023424 kB
Fraction:       82,35

Without the patch:
After swapped out:
cat /proc/pid/smaps:
Anonymous:      190660 kB
AnonHugePages:  190464 kB
Swap:           609344 kB
Fraction:       99,89

cat /proc/meminfo:
AnonPages:      1740456 kB
AnonHugePages:  1667072 kB
Fraction:       95,78

After swapped in:
cat /proc/pid/smaps:
Anonymous:      800004 kB
AnonHugePages:  190464 kB
Swap:           0 kB
Fraction:       23,80

cat /proc/meminfo:
AnonPages:      2350032 kB
AnonHugePages:  1667072 kB
Fraction:       70,93

I waited 10 minutes the fractions did not change without the patch.

Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   60 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 11 deletions(-)

diff -puN mm/huge_memory.c~mm-incorporate-read-only-pages-into-transparent-huge-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-incorporate-read-only-pages-into-transparent-huge-pages
+++ a/mm/huge_memory.c
@@ -2115,17 +2115,18 @@ static int __collapse_huge_page_isolate(
 {
 	struct page *page;
 	pte_t *_pte;
-	int referenced = 0, none = 0;
+	int referenced = 0, none = 0, ro = 0, writable = 0;
 	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (pte_none(pteval)) {
+			ro++;
 			if (++none <= khugepaged_max_ptes_none)
 				continue;
 			else
 				goto out;
 		}
-		if (!pte_present(pteval) || !pte_write(pteval))
+		if (!pte_present(pteval))
 			goto out;
 		page = vm_normal_page(vma, address, pteval);
 		if (unlikely(!page))
@@ -2135,9 +2136,6 @@ static int __collapse_huge_page_isolate(
 		VM_BUG_ON_PAGE(!PageAnon(page), page);
 		VM_BUG_ON_PAGE(!PageSwapBacked(page), page);
 
-		/* cannot use mapcount: can't collapse if there's a gup pin */
-		if (page_count(page) != 1)
-			goto out;
 		/*
 		 * We can do it before isolate_lru_page because the
 		 * page can't be freed from under us. NOTE: PG_lock
@@ -2146,6 +2144,34 @@ static int __collapse_huge_page_isolate(
 		 */
 		if (!trylock_page(page))
 			goto out;
+
+		/*
+		 * cannot use mapcount: can't collapse if there's a gup pin.
+		 * The page must only be referenced by the scanned process
+		 * and page swap cache.
+		 */
+		if (page_count(page) != 1 + !!PageSwapCache(page)) {
+			unlock_page(page);
+			goto out;
+		}
+		if (!pte_write(pteval)) {
+			if (++ro > khugepaged_max_ptes_none) {
+				unlock_page(page);
+				goto out;
+			}
+			if (PageSwapCache(page) && !reuse_swap_page(page)) {
+				unlock_page(page);
+				goto out;
+			}
+			/*
+			 * Page is not in the swap cache, and page count is
+			 * one (see above). It can be collapsed into a THP.
+			 */
+			VM_BUG_ON(page_count(page) != 1);
+		} else {
+			writable = 1;
+		}
+
 		/*
 		 * Isolate the page to avoid collapsing an hugepage
 		 * currently in use by the VM.
@@ -2164,7 +2190,7 @@ static int __collapse_huge_page_isolate(
 		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced = 1;
 	}
-	if (likely(referenced))
+	if (likely(referenced && writable))
 		return 1;
 out:
 	release_pte_pages(pte, _pte);
@@ -2517,7 +2543,7 @@ static int khugepaged_scan_pmd(struct mm
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
-	int ret = 0, referenced = 0, none = 0;
+	int ret = 0, referenced = 0, none = 0, ro = 0, writable = 0;
 	struct page *page;
 	unsigned long _address;
 	spinlock_t *ptl;
@@ -2535,13 +2561,21 @@ static int khugepaged_scan_pmd(struct mm
 	     _pte++, _address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (pte_none(pteval)) {
+			ro++;
 			if (++none <= khugepaged_max_ptes_none)
 				continue;
 			else
 				goto out_unmap;
 		}
-		if (!pte_present(pteval) || !pte_write(pteval))
+		if (!pte_present(pteval))
 			goto out_unmap;
+		if (!pte_write(pteval)) {
+			if (++ro > khugepaged_max_ptes_none)
+				goto out_unmap;
+		} else {
+			writable = 1;
+		}
+
 		page = vm_normal_page(vma, _address, pteval);
 		if (unlikely(!page))
 			goto out_unmap;
@@ -2558,14 +2592,18 @@ static int khugepaged_scan_pmd(struct mm
 		VM_BUG_ON_PAGE(PageCompound(page), page);
 		if (!PageLRU(page) || PageLocked(page) || !PageAnon(page))
 			goto out_unmap;
-		/* cannot use mapcount: can't collapse if there's a gup pin */
-		if (page_count(page) != 1)
+		/*
+		 * cannot use mapcount: can't collapse if there's a gup pin.
+		 * The page must only be referenced by the scanned process
+		 * and page swap cache.
+		 */
+		if (page_count(page) != 1 + !!PageSwapCache(page))
 			goto out_unmap;
 		if (pte_young(pteval) || PageReferenced(page) ||
 		    mmu_notifier_test_young(vma->vm_mm, address))
 			referenced = 1;
 	}
-	if (referenced)
+	if (referenced && writable)
 		ret = 1;
 out_unmap:
 	pte_unmap_unlock(pte, ptl);
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-incorporate-read-only-pages-into-transparent-huge-pages.patch

