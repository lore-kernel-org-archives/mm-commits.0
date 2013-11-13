From: akpm@linux-foundation.org
Subject: [merged] mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch
 removed from -mm tree
Date: Wed, 13 Nov 2013 12:38:24 -0800
Message-ID: <5283e340.0cE1vVoTrwgy18Jh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42588 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab3KMUiZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Nov 2013 15:38:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mel@csn.ul.ie, liwanp@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, isimatu.yasuaki@jp.fujitsu.com, davidoff@qedmf.net, bob.liu@oracle.com, aarcange@redhat.com, lliubbo@gmail.com

Subject: [merged] mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch removed from -mm tree
To: lliubbo@gmail.com,aarcange@redhat.com,bob.liu@oracle.com,davidoff@qedmf.net,isimatu.yasuaki@jp.fujitsu.com,kirill.shutemov@linux.intel.com,liwanp@linux.vnet.ibm.com,mel@csn.ul.ie,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 13 Nov 2013 12:38:24 -0800


The patch titled
     Subject: mm: thp: cleanup: mv alloc_hugepage to better place
has been removed from the -mm tree.  Its filename was
     mm-thp-cleanup-mv-alloc_hugepage-to-better-place.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bob Liu <lliubbo@gmail.com>
Subject: mm: thp: cleanup: mv alloc_hugepage to better place

Move alloc_hugepage() to a better place, no need for a seperate #ifndef
CONFIG_NUMA

Signed-off-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Andrew Davidoff <davidoff@qedmf.net>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff -puN mm/huge_memory.c~mm-thp-cleanup-mv-alloc_hugepage-to-better-place mm/huge_memory.c
--- a/mm/huge_memory.c~mm-thp-cleanup-mv-alloc_hugepage-to-better-place
+++ a/mm/huge_memory.c
@@ -759,14 +759,6 @@ static inline struct page *alloc_hugepag
 			       HPAGE_PMD_ORDER, vma, haddr, nd);
 }
 
-#ifndef CONFIG_NUMA
-static inline struct page *alloc_hugepage(int defrag)
-{
-	return alloc_pages(alloc_hugepage_gfpmask(defrag, 0),
-			   HPAGE_PMD_ORDER);
-}
-#endif
