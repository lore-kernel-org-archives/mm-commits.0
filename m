From: akpm@linux-foundation.org
Subject: [merged] mm-adjust-foll_split-for-new-refcounting.patch removed
 from -mm tree
Date: Tue, 19 Jan 2016 12:01:29 -0800
Message-ID: <569e9619.Spkt17IqhVkfoz8Y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42649 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933044AbcASUBa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:01:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: adjust FOLL_SPLIT for new refcounting
has been removed from the -mm tree.  Its filename was
     mm-adjust-foll_split-for-new-refcounting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: adjust FOLL_SPLIT for new refcounting

We need to prepare kernel to allow transhuge pages to be mapped with
ptes too. We need to handle FOLL_SPLIT in follow_page_pte().

Also we use split_huge_page() directly instead of split_huge_page_pmd().
split_huge_page_pmd() will gone.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Steve Capper <steve.capper@linaro.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   67 ++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 49 insertions(+), 18 deletions(-)

diff -puN mm/gup.c~mm-adjust-foll_split-for-new-refcounting mm/gup.c
--- a/mm/gup.c~mm-adjust-foll_split-for-new-refcounting
+++ a/mm/gup.c
@@ -116,6 +116,19 @@ retry:
 		}
 	}
 
+	if (flags & FOLL_SPLIT && PageTransCompound(page)) {
+		int ret;
+		get_page(page);
+		pte_unmap_unlock(ptep, ptl);
+		lock_page(page);
+		ret = split_huge_page(page);
+		unlock_page(page);
+		put_page(page);
+		if (ret)
+			return ERR_PTR(ret);
+		goto retry;
+	}
+
 	if (flags & FOLL_GET)
 		get_page_foll(page);
 	if (flags & FOLL_TOUCH) {
@@ -220,27 +233,45 @@ struct page *follow_page_mask(struct vm_
 	}
 	if ((flags & FOLL_NUMA) && pmd_protnone(*pmd))
 		return no_page_table(vma, flags);
-	if (pmd_trans_huge(*pmd)) {
-		if (flags & FOLL_SPLIT) {
+	if (likely(!pmd_trans_huge(*pmd)))
+		return follow_page_pte(vma, address, pmd, flags);
+
+	ptl = pmd_lock(mm, pmd);
+	if (unlikely(!pmd_trans_huge(*pmd))) {
+		spin_unlock(ptl);
+		return follow_page_pte(vma, address, pmd, flags);
+	}
+
+	if (unlikely(pmd_trans_splitting(*pmd))) {
+		spin_unlock(ptl);
+		wait_split_huge_page(vma->anon_vma, pmd);
+		return follow_page_pte(vma, address, pmd, flags);
+	}
+
+	if (flags & FOLL_SPLIT) {
+		int ret;
+		page = pmd_page(*pmd);
+		if (is_huge_zero_page(page)) {
+			spin_unlock(ptl);
+			ret = 0;
 			split_huge_page_pmd(vma, address, pmd);
-			return follow_page_pte(vma, address, pmd, flags);
-		}
-		ptl = pmd_lock(mm, pmd);
-		if (likely(pmd_trans_huge(*pmd))) {
-			if (unlikely(pmd_trans_splitting(*pmd))) {
-				spin_unlock(ptl);
-				wait_split_huge_page(vma->anon_vma, pmd);
-			} else {
-				page = follow_trans_huge_pmd(vma, address,
-							     pmd, flags);
-				spin_unlock(ptl);
-				*page_mask = HPAGE_PMD_NR - 1;
-				return page;
-			}
-		} else
+		} else {
+			get_page(page);
 			spin_unlock(ptl);
+			lock_page(page);
+			ret = split_huge_page(page);
+			unlock_page(page);
+			put_page(page);
+		}
+
+		return ret ? ERR_PTR(ret) :
+			follow_page_pte(vma, address, pmd, flags);
 	}
-	return follow_page_pte(vma, address, pmd, flags);
+
+	page = follow_trans_huge_pmd(vma, address, pmd, flags);
+	spin_unlock(ptl);
+	*page_mask = HPAGE_PMD_NR - 1;
+	return page;
 }
 
 static int get_gate_page(struct mm_struct *mm, unsigned long address,
_

Patches currently in -mm which might be from kirill.shutemov@linux.intel.com are

thp-update-documentation.patch
thp-allow-mlocked-thp-again.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting.patch
thp-add-debugfs-handle-to-split-all-huge-pages.patch
thp-increase-split_huge_page-success-rate.patch
thp-fix-split_huge_page-after-mremap-of-thp.patch
memblock-fix-section-mismatch.patch
mm-fix-locking-order-in-mm_take_all_locks.patch
mm-make-optimistic-check-for-swapin-readahead-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-2.patch
mm-make-swapin-readahead-to-improve-thp-collapse-rate-fix-3.patch

