From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-correct-missing-private-flag-clearing.patch
 removed from -mm tree
Date: Thu, 17 Oct 2013 11:13:01 -0700
Message-ID: <526028ad.LRNdKB4s70uBHjnm%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758709Ab3JQSNC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Oct 2013 14:13:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com, mhocko@suse.cz, mgorman@suse.de, liwanp@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com, dhillf@gmail.com, davidlohr.bueso@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-correct-missing-private-flag-clearing.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr.bueso@hp.com,dhillf@gmail.com,hughd@google.com,kamezawa.hiroyu@jp.fujitsu.com,liwanp@linux.vnet.ibm.com,mgorman@suse.de,mhocko@suse.cz,n-horiguchi@ah.jp.nec.com,riel@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 17 Oct 2013 11:13:01 -0700


The patch titled
     Subject: mm/hugetlb.c: correct missing private flag clearing
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-correct-missing-private-flag-clearing.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/hugetlb.c: correct missing private flag clearing

We should clear the page's private flag when returing the page to the
hugepage pool.  Otherwise, marked hugepage can be allocated to the user
who tries to allocate the non-reserved hugepage.  If this user fail to map
this hugepage, he would try to return the page to the hugepage pool. 
Since this page has a private flag, resv_huge_pages would mistakenly
increase.  This patch fixes this situation.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/hugetlb.c~mm-hugetlb-correct-missing-private-flag-clearing mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-correct-missing-private-flag-clearing
+++ a/mm/hugetlb.c
@@ -653,6 +653,7 @@ static void free_huge_page(struct page *
 	BUG_ON(page_count(page));
 	BUG_ON(page_mapcount(page));
 	restore_reserve = PagePrivate(page);
+	ClearPagePrivate(page);
 
 	spin_lock(&hugetlb_lock);
 	hugetlb_cgroup_uncharge_page(hstate_index(h),
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch
mm-vmalloc-dont-set-area-caller-twice.patch
mm-vmalloc-fix-show-vmap_area-information-race-with-vmap_area-tear-down.patch
mm-vmalloc-revert-mm-vmallocc-check-vm_uninitialized-flag-in-s_show-instead-of-show_numa_info.patch
revert-mm-vmallocc-emit-the-failure-message-before-return.patch

