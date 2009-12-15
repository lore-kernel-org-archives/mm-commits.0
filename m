From: akpm@linux-foundation.org
Subject: [folded] mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update.patch removed from -mm tree
Date: Mon, 14 Dec 2009 17:05:13 -0800
Message-ID: <200912150105.nBF15DhL006593@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60620 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758331AbZLOBGF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Dec 2009 20:06:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, ak@linux.intel.com, apw@canonical.com, fengguang.wu@intel.com, hugh.dickins@tiscali.co.uk, lee.schermerhorn@hp.com, mel@csn.ul.ie, rientjes@google.com, stab


The patch titled
     mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update.patch

This patch was dropped because it was folded into mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch

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
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range.patch
mm-hugetlb-fix-hugepage-memory-leak-in-walk_page_range-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap.patch
mm-hugetlb-add-hugepage-support-to-pagemap-update.patch
mm-hugetlb-add-hugepage-support-to-pagemap-build-fix.patch

