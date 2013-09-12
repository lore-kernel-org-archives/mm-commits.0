From: akpm@linux-foundation.org
Subject: [merged]
 mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch removed
 from -mm tree
Date: Thu, 12 Sep 2013 12:44:07 -0700
Message-ID: <52321987.xEXM3wHoQP9mT6Yi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab3ILToI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, liwanp@linux.vnet.ibm.com, dhillf@gmail.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,dhillf@gmail.com,liwanp@linux.vnet.ibm.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:07 -0700


The patch titled
     Subject: mm, hugetlb: grab a page_table_lock after page_cache_release
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-grab-a-page_table_lock-after-page_cache_release.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: grab a page_table_lock after page_cache_release

We don't need to grab a page_table_lock when we try to release a page. 
So, defer to grab a page_table_lock.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-grab-a-page_table_lock-after-page_cache_release mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-grab-a-page_table_lock-after-page_cache_release
+++ a/mm/hugetlb.c
@@ -2647,10 +2647,11 @@ retry_avoidcopy:
 	}
 	spin_unlock(&mm->page_table_lock);
 	mmu_notifier_invalidate_range_end(mm, mmun_start, mmun_end);
-	/* Caller expects lock to be held */
-	spin_lock(&mm->page_table_lock);
 	page_cache_release(new_page);
 	page_cache_release(old_page);
+
+	/* Caller expects lock to be held */
+	spin_lock(&mm->page_table_lock);
 	return 0;
 }
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

