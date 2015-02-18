From: akpm@linux-foundation.org
Subject: + mm-incorporate-zero-pages-into-transparent-huge-pages.patch
 added to -mm tree
Date: Wed, 18 Feb 2015 15:31:29 -0800
Message-ID: <54e520d1./3yxsOAGHJxSa2KM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48461 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbbBRXba (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 18:31:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ebru.akagunduz@gmail.com, aarcange@redhat.com, hannes@cmpxchg.org, hughd@google.com, kirill.shutemov@linux.intel.com, mel@csn.ul.ie, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: incorporate zero pages into transparent huge pages
has been added to the -mm tree.  Its filename is
     mm-incorporate-zero-pages-into-transparent-huge-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-incorporate-zero-pages-into-transparent-huge-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-incorporate-zero-pages-into-transparent-huge-pages.patch

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
Subject: mm: incorporate zero pages into transparent huge pages

This patch improves THP collapse rates, by allowing zero pages.

Currently THP can collapse 4kB pages into a THP when there are up to
khugepaged_max_ptes_none pte_none ptes in a 2MB range.  This patch counts
pte none and mapped zero pages with the same variable.

The patch was tested with a program that allocates 800MB of
memory, and performs interleaved reads and writes, in a pattern
that causes some 2MB areas to first see read accesses, resulting
in the zero pfn being mapped there.

To simulate memory fragmentation at allocation time, I modified
do_huge_pmd_anonymous_page to return VM_FAULT_FALLBACK for read faults.

Without the patch, only %50 of the program was collapsed into THP and the
percentage did not increase over time.

With this patch after 10 minutes of waiting khugepaged had collapsed %99
of the program's memory.

Signed-off-by: Ebru Akagunduz <ebru.akagunduz@gmail.com>
Reviewed-by: Rik van Riel <riel@redhat.com>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff -puN mm/huge_memory.c~mm-incorporate-zero-pages-into-transparent-huge-pages mm/huge_memory.c
--- a/mm/huge_memory.c~mm-incorporate-zero-pages-into-transparent-huge-pages
+++ a/mm/huge_memory.c
@@ -2104,7 +2104,7 @@ static void release_pte_pages(pte_t *pte
 {
 	while (--_pte >= pte) {
 		pte_t pteval = *_pte;
-		if (!pte_none(pteval))
+		if (!pte_none(pteval) && !is_zero_pfn(pte_pfn(pteval)))
 			release_pte_page(pte_page(pteval));
 	}
 }
@@ -2115,13 +2115,13 @@ static int __collapse_huge_page_isolate(
 {
 	struct page *page;
 	pte_t *_pte;
-	int none = 0;
+	int none_or_zero = 0;
 	bool referenced = false, writable = false;
 	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
-		if (pte_none(pteval)) {
-			if (++none <= khugepaged_max_ptes_none)
+		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+			if (++none_or_zero <= khugepaged_max_ptes_none)
 				continue;
 			else
 				goto out;
@@ -2202,7 +2202,7 @@ static void __collapse_huge_page_copy(pt
 		pte_t pteval = *_pte;
 		struct page *src_page;
 
-		if (pte_none(pteval)) {
+		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
 			clear_user_highpage(page, address);
 			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
 		} else {
@@ -2538,7 +2538,7 @@ static int khugepaged_scan_pmd(struct mm
 {
 	pmd_t *pmd;
 	pte_t *pte, *_pte;
-	int ret = 0, none = 0;
+	int ret = 0, none_or_zero = 0;
 	struct page *page;
 	unsigned long _address;
 	spinlock_t *ptl;
@@ -2556,8 +2556,8 @@ static int khugepaged_scan_pmd(struct mm
 	for (_address = address, _pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, _address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
-		if (pte_none(pteval)) {
-			if (++none <= khugepaged_max_ptes_none)
+		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+			if (++none_or_zero <= khugepaged_max_ptes_none)
 				continue;
 			else
 				goto out_unmap;
_

Patches currently in -mm which might be from ebru.akagunduz@gmail.com are

origin.patch
mm-incorporate-zero-pages-into-transparent-huge-pages.patch

