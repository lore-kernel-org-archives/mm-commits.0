From: akpm@linux-foundation.org
Subject: + mm-hugetlb-further-simplify-hugetlb-allocation-api-fix.patch
 added to -mm tree
Date: Wed, 10 Jan 2018 14:36:07 -0800
Message-ID: <5a569557.k4qtl3RJOHWXlRMA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47140 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750782AbeAJWgJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 10 Jan 2018 17:36:09 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mhocko@kernel.org, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: fix a double unlock bug in alloc_surplus_huge_page()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-further-simplify-hugetlb-allocation-api-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-further-simplify-hugetlb-allocation-api-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-further-simplify-hugetlb-allocation-api-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-hugetlb-further-simplify-hugetlb-allocation-api-fix.patch
ipc-mqueue-add-missing-error-code-in-init_mqueue_fs.patch

