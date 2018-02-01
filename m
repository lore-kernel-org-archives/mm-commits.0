From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-further-simplify-hugetlb-allocation-api-fix.patch removed from
 -mm tree
Date: Wed, 31 Jan 2018 16:07:06 -0800
Message-ID: <5a725a2a.3wPwtZeeeSjWFhow%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58750 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753476AbeBAAHI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 31 Jan 2018 19:07:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mhocko@kernel.org, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: fix a double unlock bug in alloc_surplus_huge_page()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-further-simplify-hugetlb-allocation-api-fix.patch

This patch was dropped because it was folded into mm-hugetlb-further-simplify-hugetlb-allocation-api.patch

------------------------------------------------------
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: mm, hugetlb: fix a double unlock bug in alloc_surplus_huge_page()

We aren't holding the hugetlb_lock so there is no need to unlock.

Link: http://lkml.kernel.org/r/20180109200559.g3iz5kvbdrz7yydp@mwanda
Fixes: b27f11e5e675 ("mm, hugetlb: get rid of surplus page accounting tricks")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-further-simplify-hugetlb-allocation-api-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-further-simplify-hugetlb-allocation-api-fix
+++ a/mm/hugetlb.c
@@ -1567,7 +1567,7 @@ static struct page *alloc_surplus_huge_p
 
 	page = alloc_fresh_huge_page(h, gfp_mask, nid, nmask);
 	if (!page)
-		goto out_unlock;
+		return NULL;
 
 	spin_lock(&hugetlb_lock);
 	/*
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-hugetlb-further-simplify-hugetlb-allocation-api.patch

