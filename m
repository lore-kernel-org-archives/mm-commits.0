From: akpm@linux-foundation.org
Subject: + mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update.patch added to -mm tree
Date: Wed, 09 Dec 2009 15:54:46 -0800
Message-ID: <200912092354.nB9Nskkj027384@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53748 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758667AbZLIX4E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Dec 2009 18:56:04 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, apw@canonical.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com, stable@kernel.org


The patch titled
     mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update
has been added to the -mm tree.  Its filename is
     mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

- NULL check of vma
- remove redundant ternary operation

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: David Rientjes <rientjes@google.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pagewalk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/pagewalk.c~mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update mm/pagewalk.c
--- a/mm/pagewalk.c~mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update
+++ a/mm/pagewalk.c
@@ -123,8 +123,9 @@ int walk_page_range(unsigned long addr, 
 		/* skip hugetlb vma to avoid hugepage PMD being cleared
 		 * in pmd_none_or_clear_bad(). */
 		vma = find_vma(walk->mm, addr);
-		if (is_vm_hugetlb_page(vma)) {
-			next = (vma->vm_end < next) ? vma->vm_end : next;
+		if (vma && is_vm_hugetlb_page(vma)) {
+			if (vma->vm_end < next)
+				next = vma->vm_end;
 			continue;
 		}
 
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

mm-hugetlb-fix-hugepage-memory-leak-in-mincore.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-cleanup.patch
mm-hugetlb-fix-hugepage-memory-leak-in-mincore-build-fix.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch

