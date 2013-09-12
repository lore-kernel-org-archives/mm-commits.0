From: akpm@linux-foundation.org
Subject: [merged] mm-hugetlb-remove-useless-check-about-mapping-type.patch removed from -mm tree
Date: Thu, 12 Sep 2013 12:44:05 -0700
Message-ID: <52321985.0YJEo5C0stdtSb4Q%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58296 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755456Ab3ILToG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 12 Sep 2013 15:44:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, liwanp@linux.vnet.ibm.com, dhillf@gmail.com, davidlohr@hp.com, david@gibson.dropbear.id.au, aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com

Subject: [merged] mm-hugetlb-remove-useless-check-about-mapping-type.patch removed from -mm tree
To: iamjoonsoo.kim@lge.com,aneesh.kumar@linux.vnet.ibm.com,david@gibson.dropbear.id.au,davidlohr@hp.com,dhillf@gmail.com,liwanp@linux.vnet.ibm.com,n-horiguchi@ah.jp.nec.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 12 Sep 2013 12:44:05 -0700


The patch titled
     Subject: mm, hugetlb: remove useless check about mapping type
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-remove-useless-check-about-mapping-type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm, hugetlb: remove useless check about mapping type

is_vma_resv_set(vma, HPAGE_RESV_OWNER) implys that this mapping is for
private.  So we don't need to check whether this mapping is for shared or
not.

This patch is just for clean-up.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>
Cc: David Gibson <david@gibson.dropbear.id.au>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Hillf Danton <dhillf@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN mm/hugetlb.c~mm-hugetlb-remove-useless-check-about-mapping-type mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-remove-useless-check-about-mapping-type
+++ a/mm/hugetlb.c
@@ -2564,8 +2564,7 @@ retry_avoidcopy:
 	 * at the time of fork() could consume its reserves on COW instead
 	 * of the full address range.
 	 */
-	if (!(vma->vm_flags & VM_MAYSHARE) &&
-			is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
+	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
 			old_page != pagecache_page)
 		outside_reserve = 1;
 
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

origin.patch

