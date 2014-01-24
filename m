From: akpm@linux-foundation.org
Subject: [merged]
 mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch removed from
 -mm tree
Date: Fri, 24 Jan 2014 10:59:05 -0800
Message-ID: <52e2b7f9.9JZdqS52WFTPErXa%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43272 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaAXS7G (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 13:59:06 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, sasha.levin@oracle.com, n-horiguchi@ah.jp.nec.com, liwanp@linux.vnet.ibm.com, bob.liu@oracle.com, mhocko@suse.cz

Subject: [merged] mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch removed from -mm tree
To: mhocko@suse.cz,bob.liu@oracle.com,liwanp@linux.vnet.ibm.com,n-horiguchi@ah.jp.nec.com,sasha.levin@oracle.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 10:59:05 -0800


The patch titled
     Subject: mm: new_vma_page() cannot see NULL vma for hugetlb pages
has been removed from the -mm tree.  Its filename was
     mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Michal Hocko <mhocko@suse.cz>
Subject: mm: new_vma_page() cannot see NULL vma for hugetlb pages

11c731e81bb0 ("mm/mempolicy: fix !vma in new_vma_page()") has removed
BUG_ON(!vma) from new_vma_page which is partially correct because
page_address_in_vma will return EFAULT for non-linear mappings and at
least shared shmem might be mapped this way.

The patch also tried to prevent NULL ptr for hugetlb pages which is not
correct AFAICS because hugetlb pages cannot be mapped as VM_NONLINEAR and
other conditions in page_address_in_vma seem to be legit and catch real
bugs.

This patch restores BUG_ON for PageHuge to catch potential issues when the
to-be-migrated page is not setup properly.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN mm/mempolicy.c~mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages mm/mempolicy.c
--- a/mm/mempolicy.c~mm-new_vma_page-cannot-see-null-vma-for-hugetlb-pages
+++ a/mm/mempolicy.c
@@ -1199,10 +1199,8 @@ static struct page *new_vma_page(struct
 	}
 
 	if (PageHuge(page)) {
-		if (vma)
-			return alloc_huge_page_noerr(vma, address, 1);
-		else
-			return NULL;
+		BUG_ON(!vma);
+		return alloc_huge_page_noerr(vma, address, 1);
 	}
 	/*
 	 * if !vma, alloc_page_vma() will use task or system default policy
_

Patches currently in -mm which might be from mhocko@suse.cz are

origin.patch
mm-page_alloc-allow-__gfp_nofail-to-allocate-below-watermarks-after-reclaim.patch
memcg-do-not-hang-on-oom-when-killed-by-userspace-oom-access-to-memory-reserves.patch
mm-vmscan-respect-numa-policy-mask-when-shrinking-slab-on-direct-reclaim.patch
mm-vmscan-move-call-to-shrink_slab-to-shrink_zones.patch
mm-vmscan-remove-shrink_control-arg-from-do_try_to_free_pages.patch

