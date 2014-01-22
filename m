From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch removed from -mm tree
Date: Wed, 22 Jan 2014 12:12:17 -0800
Message-ID: <52e02621.Ylj8DdG4NmyJrc+m%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449AbaAVUMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Jan 2014 15:12:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, mgorman@suse.de, dave.jiang@intel.com, dave.hansen@linux.intel.com

Subject: [merged] mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch removed from -mm tree
To: dave.hansen@linux.intel.com,dave.jiang@intel.com,mgorman@suse.de,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 22 Jan 2014 12:12:17 -0800


The patch titled
     Subject: mm: hugetlbfs: Add some VM_BUG_ON()s to catch non-hugetlbfs pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Hansen <dave.hansen@linux.intel.com>
Subject: mm: hugetlbfs: Add some VM_BUG_ON()s to catch non-hugetlbfs pages

Dave Jiang reported that he was seeing oopses when running NUMA systems
and default_hugepagesz=1G.  I traced the issue down to migrate_page_copy()
trying to use the same code for hugetlb pages and transparent hugepages. 
It should not have been trying to pass thp pages in there.

So, add some VM_BUG_ON()s for the next hapless VM developer that tries the
same thing.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Tested-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/hugetlb.h~mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages include/linux/hugetlb.h
--- a/include/linux/hugetlb.h~mm-hugetlbfs-add-some-vm_bug_ons-to-catch-non-hugetlbfs-pages
+++ a/include/linux/hugetlb.h
@@ -360,6 +360,7 @@ static inline pte_t arch_make_huge_pte(p
 
 static inline struct hstate *page_hstate(struct page *page)
 {
+	VM_BUG_ON(!PageHuge(page));
 	return size_to_hstate(PAGE_SIZE << compound_order(page));
 }
 
_

Patches currently in -mm which might be from dave.hansen@linux.intel.com are

origin.patch
mm-print-more-details-for-bad_page.patch
mm-print-more-details-for-bad_page-fix.patch
linux-next.patch

