From: akpm@linux-foundation.org
Subject: + mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch added
 to -mm tree
Date: Wed, 15 Mar 2017 12:36:49 -0700
Message-ID: <58c997d1.kIpBM5TSAyGTn0zU%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49822 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbdCOTgv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Mar 2017 15:36:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, hannes@cmpxchg.org, hillf.zj@alibaba-inc.com, khandual@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, mhocko@suse.com, n-horiguchi@ah.jp.nec.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove SWAP_MLOCK check for SWAP_SUCCESS in ttu
has been added to the -mm tree.  Its filename is
     mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-reclaim-madv_free-pages-fix.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one.patch
mm-fix-lazyfree-bug-on-check-in-try_to_unmap_one-fix.patch
mm-do-not-use-double-negation-for-testing-page-flags.patch
mm-remove-unncessary-ret-in-page_referenced.patch
mm-remove-swap_dirty-in-ttu.patch
mm-remove-swap_mlock-check-for-swap_success-in-ttu.patch
mm-make-the-try_to_munlock-void-function.patch
mm-remove-swap_mlock-in-ttu.patch
mm-remove-swap_again-in-ttu.patch
mm-make-ttus-return-boolean.patch
mm-make-rmap_walk-void-function.patch
mm-make-rmap_one-boolean-function.patch
mm-remove-swap_.patch

