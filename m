From: akpm@linux-foundation.org
Subject: +
 mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch added
 to -mm tree
Date: Thu, 29 Jan 2015 13:23:44 -0800
Message-ID: <54caa4e0.NfNvFyFr9OtJvw/P%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbbA2VXp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 29 Jan 2015 16:23:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill@shutemov.name, mgorman@suse.de, mhocko@suse.cz, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, vbabka@suse.cz, zhangyanfei@cn.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: incorporate read-only pages into transparent huge pages
has been added to the -mm tree.  Its filename is
     mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch

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

This patch aims to improve THP collapse rates, by allowing
THP collapse in the presence of read-only ptes, like those
left in place by do_swap_page after a read fault.

Currently THP can collapse 4kB pages into a THP when
there are up to khugepaged_max_ptes_none pte_none ptes
in a 2MB range. This patch applies the same limit for
read-only ptes.

The patch was tested with a test program that allocates
800MB of memory, writes to it, and then sleeps. I force
the system to swap out all but 190MB of the program by
touching other memory. Afterwards, the test program does
a mix of reads and writes to its memory, and the memory
gets swapped back in.

Without the patch, only the memory that did not get
swapped out remained in THPs, which corresponds to 24% of
the memory of the program. The percentage did not increase
over time.

With this patch, after 5 minutes of waiting khugepaged had
collapsed 60% of the program's memory back into THPs.

Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Acked-by: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>
Cc: David Rientjes <rientjes@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff -puN mm/huge_memory.c~mm-incorporate-read-only-pages-into-transparent-huge-pages-v4 mm/huge_memory.c
--- a/mm/huge_memory.c~mm-incorporate-read-only-pages-into-transparent-huge-pages-v4
+++ a/mm/huge_memory.c
@@ -2115,12 +2115,12 @@ static int __collapse_huge_page_isolate(
 {
 	struct page *page;
 	pte_t *_pte;
-	int referenced = 0, none = 0, ro = 0, writable = 0;
+	int none = 0;
+	bool referenced = false, writable = false;
 	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (pte_none(pteval)) {
-			ro++;
 			if (++none <= khugepaged_max_ptes_none)
 				continue;
 			else
@@ -2154,22 +2154,17 @@ static int __collapse_huge_page_isolate(
 			unlock_page(page);
 			goto out;
 		}
-		if (!pte_write(pteval)) {
-			if (++ro > khugepaged_max_ptes_none) {
-				unlock_page(page);
-				goto out;
-			}
+		if (pte_write(pteval)) {
+			writable = true;
+		} else {
 			if (PageSwapCache(page) && !reuse_swap_page(page)) {
 				unlock_page(page);
 				goto out;
 			}
 			/*
-			 * Page is not in the swap cache, and page count is
-			 * one (see above). It can be collapsed into a THP.
+			 * Page is not in the swap cache. It can be collapsed
+			 * into a THP.
 			 */
-			VM_BUG_ON(page_count(page) != 1);
-		} else {
-			writable = 1;
 		}
 
 		/*
@@ -2188,7 +2183,7 @@ static int __collapse_huge_page_isolate(
 		/* If there is no mapped pte young don't collapse the page */
 		if (pte_young(pteval) || PageReferenced(page) ||
 		    mmu_notifier_test_young(vma->vm_mm, address))
-			referenced = 1;
+			referenced = true;
 	}
 	if (likely(referenced && writable))
 		return 1;
@@ -2543,11 +2538,12 @@ static int khugepaged_scan_pmd(struct mm
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
-	int ret = 0, referenced = 0, none = 0, ro = 0, writable = 0;
+	int ret = 0, none = 0;
 	struct page *page;
 	unsigned long _address;
 	spinlock_t *ptl;
 	int node = NUMA_NO_NODE;
+	bool writable = false, referenced = false;
 
 	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
 
@@ -2561,7 +2557,6 @@ static int khugepaged_scan_pmd(struct mm
 	     _pte++, _address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
 		if (pte_none(pteval)) {
-			ro++;
 			if (++none <= khugepaged_max_ptes_none)
 				continue;
 			else
@@ -2569,12 +2564,8 @@ static int khugepaged_scan_pmd(struct mm
 		}
 		if (!pte_present(pteval))
 			goto out_unmap;
-		if (!pte_write(pteval)) {
-			if (++ro > khugepaged_max_ptes_none)
-				goto out_unmap;
-		} else {
-			writable = 1;
-		}
+		if (pte_write(pteval))
+			writable = true;
 
 		page = vm_normal_page(vma, _address, pteval);
 		if (unlikely(!page))
@@ -2601,7 +2592,7 @@ static int khugepaged_scan_pmd(struct mm
 			goto out_unmap;
 		if (pte_young(pteval) || PageReferenced(page) ||
 		    mmu_notifier_test_young(vma->vm_mm, address))
-			referenced = 1;
+			referenced = true;
 	}
 	if (referenced && writable)
 		ret = 1;
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

mm-incorporate-read-only-pages-into-transparent-huge-pages.patch
mm-incorporate-read-only-pages-into-transparent-huge-pages-v4.patch

