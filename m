From: akpm@linux-foundation.org
Subject: + thp-use-is_zero_pfn-only-after-pte_present-check.patch added to -mm tree
Date: Thu, 15 Oct 2015 13:32:29 -0700
Message-ID: <56200d5d.sRSLRIScbg2Y/xrv%akpm__44761.7155420177$1444941167$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58785 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbbJOUca (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Oct 2015 16:32:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aarcange@redhat.com, hughd@google.com, kirill.shutemov@linux.intel.com, mgorman@suse.de, riel@redhat.com, stable@vger.kernel.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: use is_zero_pfn() only after pte_present() check
has been added to the -mm tree.  Its filename is
     thp-use-is_zero_pfn-only-after-pte_present-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/thp-use-is_zero_pfn-only-after-pte_present-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/thp-use-is_zero_pfn-only-after-pte_present-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: thp: use is_zero_pfn() only after pte_present() check

Use is_zero_pfn() on pteval only after pte_present() check on pteval (It
might be better idea to introduce is_zero_pte() which checks pte_present()
first).

Otherwise when working on a swap or migration entry and if pte_pfn's
result is equal to zero_pfn by chance, we lose user's data in
__collapse_huge_page_copy().  So if you're unlucky, the application
segfaults and finally you could see below message on exit:

BUG: Bad rss-counter state mm:ffff88007f099300 idx:2 val:3

Fixes: ca0984caa823 ("mm: incorporate zero pages into transparent huge pages")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Reviewed-by: Andrea Arcangeli <aarcange@redhat.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: <stable@vger.kernel.org>	[4.1+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN mm/huge_memory.c~thp-use-is_zero_pfn-only-after-pte_present-check mm/huge_memory.c
--- a/mm/huge_memory.c~thp-use-is_zero_pfn-only-after-pte_present-check
+++ a/mm/huge_memory.c
@@ -2206,7 +2206,8 @@ static int __collapse_huge_page_isolate(
 	for (_pte = pte; _pte < pte+HPAGE_PMD_NR;
 	     _pte++, address += PAGE_SIZE) {
 		pte_t pteval = *_pte;
-		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
+		if (pte_none(pteval) || (pte_present(pteval) &&
+				is_zero_pfn(pte_pfn(pteval)))) {
 			if (!userfaultfd_armed(vma) &&
 			    ++none_or_zero <= khugepaged_max_ptes_none)
 				continue;
_

Patches currently in -mm which might be from minchan@kernel.org are

thp-use-is_zero_pfn-only-after-pte_present-check.patch
x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch

