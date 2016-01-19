From: akpm@linux-foundation.org
Subject: [merged] migrate_pages-try-to-split-pages-on-qeueuing.patch
 removed from -mm tree
Date: Tue, 19 Jan 2016 12:02:58 -0800
Message-ID: <569e9672.T3C5z12oCGbFzH0c%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43125 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757203AbcASUC7 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 19 Jan 2016 15:02:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, aarcange@redhat.com, aneesh.kumar@linux.vnet.ibm.com, cl@linux.com, dave.hansen@intel.com, hannes@cmpxchg.org, hughd@google.com, jmarchan@redhat.com, mgorman@suse.de, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, riel@redhat.com, rientjes@google.com, sasha.levin@oracle.com, steve.capper@linaro.org, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: migrate_pages: try to split pages on queuing
has been removed from the -mm tree.  Its filename was
     migrate_pages-try-to-split-pages-on-qeueuing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: migrate_pages: try to split pages on queuing

We are not able to migrate THPs. It means it's not enough to split only
PMD on migration -- we need to split compound page under it too.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Tested-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Acked-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
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

 mm/mempolicy.c |   42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~migrate_pages-try-to-split-pages-on-qeueuing mm/mempolicy.c
--- a/mm/mempolicy.c~migrate_pages-try-to-split-pages-on-qeueuing
+++ a/mm/mempolicy.c
@@ -489,14 +489,33 @@ static int queue_pages_pte_range(pmd_t *
 	struct page *page;
 	struct queue_pages *qp = walk->private;
 	unsigned long flags = qp->flags;
-	int nid;
+	int nid, ret;
 	pte_t *pte;
 	spinlock_t *ptl;
 
-	split_huge_pmd(vma, pmd, addr);
-	if (pmd_trans_unstable(pmd))
-		return 0;
+	if (pmd_trans_huge(*pmd)) {
+		ptl = pmd_lock(walk->mm, pmd);
+		if (pmd_trans_huge(*pmd)) {
+			page = pmd_page(*pmd);
+			if (is_huge_zero_page(page)) {
+				spin_unlock(ptl);
+				split_huge_pmd(vma, pmd, addr);
+			} else {
+				get_page(page);
+				spin_unlock(ptl);
+				lock_page(page);
+				ret = split_huge_page(page);
+				unlock_page(page);
+				put_page(page);
+				if (ret)
+					return 0;
+			}
+		} else {
+			spin_unlock(ptl);
+		}
+	}
 
+retry:
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
 	for (; addr != end; pte++, addr += PAGE_SIZE) {
 		if (!pte_present(*pte))
@@ -513,6 +532,21 @@ static int queue_pages_pte_range(pmd_t *
 		nid = page_to_nid(page);
 		if (node_isset(nid, *qp->nmask) == !!(flags & MPOL_MF_INVERT))
 			continue;
+		if (PageTail(page) && PageAnon(page)) {
+			get_page(page);
+			pte_unmap_unlock(pte, ptl);
+			lock_page(page);
+			ret = split_huge_page(page);
+			unlock_page(page);
+			put_page(page);
+			/* Failed to split -- skip. */
+			if (ret) {
+				pte = pte_offset_map_lock(walk->mm, pmd,
+						addr, &ptl);
+				continue;
+			}
+			goto retry;
+		}
 
 		if (flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL))
 			migrate_page_add(page, qp->pagelist, flags);
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

