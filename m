From: akpm@linux-foundation.org
Subject: [merged]
 mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch removed from -mm
 tree
Date: Thu, 04 May 2017 12:11:28 -0700
Message-ID: <20170504191128.Li6U5QFDi%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51432 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755434AbdEDTLa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 4 May 2017 15:11:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, minchan@kernel.org, mm-commits@vger.kernel.org, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz


The patch titled
     Subject: mm: remove SWAP_MLOCK check for SWAP_SUCCESS in ttu
has been removed from the -mm tree.  Its filename was
     mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from minchan@kernel.org are


