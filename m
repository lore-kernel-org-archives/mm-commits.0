From: akpm@linux-foundation.org
Subject: [patch 050/102] mm: remove SWAP_MLOCK check for
 SWAP_SUCCESS in ttu
Date: Wed, 03 May 2017 14:54:07 -0700
Message-ID: <20170503215407.t1GO0b7kb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49486 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751821AbdECVyu (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2017 17:54:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, torvalds@linux-foundation.org, vbabka@suse.cz

From: Minchan Kim <minchan@kernel.org>
Subject: mm: remove SWAP_MLOCK check for SWAP_SUCCESS in ttu

If the page is mapped and rescue in try_to_unmap_one, page_mapcount(page)
== 0 cannot be true so page_mapcount check in try_to_unmap is enough to
return SWAP_SUCCESS.  IOW, SWAP_MLOCK check is redundant so remove it.

Link: http://lkml.kernel.org/r/1489555493-14659-4-git-send-email-minchan@kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/rmap.c~mm-remove-swap_mlock-check-for-swap_success-in-ttu mm/rmap.c
--- a/mm/rmap.c~mm-remove-swap_mlock-check-for-swap_success-in-ttu
+++ a/mm/rmap.c
@@ -1535,7 +1535,7 @@ int try_to_unmap(struct page *page, enum
 	else
 		ret = rmap_walk(page, &rwc);
 
-	if (ret != SWAP_MLOCK && !page_mapcount(page))
+	if (!page_mapcount(page))
 		ret = SWAP_SUCCESS;
 	return ret;
 }
_
