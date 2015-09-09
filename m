From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch
 removed from -mm tree
Date: Wed, 09 Sep 2015 12:46:20 -0700
Message-ID: <55f08c8c.M6B/8nBcHTaAdpwp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752102AbbIITqV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 Sep 2015 15:46:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mike.kravetz@oracle.com, aneesh.kumar@linux.vnet.ibm.com, dave.hansen@linux.intel.com, dave@stgolabs.net, hch@infradead.org, hillf.zj@alibaba-inc.com, hughd@google.com, mhocko@suse.cz, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/hugetlb: vma_has_reserves() needs to handle fallocate hole punch
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: mm/hugetlb: vma_has_reserves() needs to handle fallocate hole punch

In vma_has_reserves(), the current assumption is that reserves are always
present for shared mappings.  However, this will not be the case with
fallocate hole punch.  When punching a hole, the present page will be
deleted as well as the region/reserve map entry (and hence any
reservation).  vma_has_reserves is passed "chg" which indicates whether or
not a region/reserve map is present.  Use this to determine if reserves
are actually present or were removed via hole punch.

Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-vma_has_reserves-needs-to-handle-fallocate-hole-punch
+++ a/mm/hugetlb.c
@@ -801,8 +801,19 @@ static bool vma_has_reserves(struct vm_a
 	}
 
 	/* Shared mappings always use reserves */
-	if (vma->vm_flags & VM_MAYSHARE)
-		return true;
+	if (vma->vm_flags & VM_MAYSHARE) {
+		/*
+		 * We know VM_NORESERVE is not set.  Therefore, there SHOULD
+		 * be a region map for all pages.  The only situation where
+		 * there is no region map is if a hole was punched via
+		 * fallocate.  In this case, there really are no reverves to
+		 * use.  This situation is indicated if chg != 0.
+		 */
+		if (chg)
+			return false;
+		else
+			return true;
+	}
 
 	/*
 	 * Only the process that called mmap() has reserves for
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


