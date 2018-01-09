From: akpm@linux-foundation.org
Subject: + mm-hugetlb-get-rid-of-surplus-page-accounting-tricks-fix.patch
 added to -mm tree
Date: Tue, 09 Jan 2018 15:13:35 -0800
Message-ID: <5a554c9f.t3OaKjdozTHUBg3O%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56148 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932091AbeAIXNg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jan 2018 18:13:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.carpenter@oracle.com, mike.kravetz@oracle.com, n-horiguchi@ah.jp.nec.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, hugetlb: fix a double unlock bug in alloc_surplus_huge_page()
has been added to the -mm tree.  Its filename is
     mm-hugetlb-get-rid-of-surplus-page-accounting-tricks-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlb-get-rid-of-surplus-page-accounting-tricks-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlb-get-rid-of-surplus-page-accounting-tricks-fix.patch

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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/hugetlb.c~mm-hugetlb-get-rid-of-surplus-page-accounting-tricks-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-get-rid-of-surplus-page-accounting-tricks-fix
+++ a/mm/hugetlb.c
@@ -1552,7 +1552,7 @@ static struct page *__alloc_surplus_huge
 
 	page = __hugetlb_alloc_buddy_huge_page(h, gfp_mask, nid, nmask);
 	if (!page)
-		goto out_unlock;
+		return NULL;
 
 	spin_lock(&hugetlb_lock);
 	/*
_

Patches currently in -mm which might be from dan.carpenter@oracle.com are

mm-hugetlb-get-rid-of-surplus-page-accounting-tricks-fix.patch

