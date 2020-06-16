From: akpm@linux-foundation.org
Subject: +
 =?us-ascii?Q?mm-swap-fix-for-mm-workingset-age-nonresident-information?=
 =?us-ascii?Q?-alongside-anonymous-pages.patch?= added to -mm tree
Date: Tue, 16 Jun 2020 11:38:59 -0700
Message-ID: <20200616183859.790v9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgFPSjA (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 16 Jun 2020 14:39:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, riel@surriel.com, minchan.kim@gmail.com, mhocko@suse.com, js1304@gmail.com, hannes@cmpxchg.org, iamjoonsoo.kim@lge.com


The patch titled
     Subject: mm/swap: fix for "mm: workingset: age nonresident information alongside anonymous pages"
has been added to the -mm tree.  Its filename is
     mm-swap-fix-for-mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-for-mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-for-mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: mm/swap: fix for "mm: workingset: age nonresident information alongside anonymous pages"

Non-file-lru page could also be activated in mark_page_accessed()
and we need to count this activation for nonresident_age.

Note that it's better for this patch to be squashed into the patch
"mm: workingset: age nonresident information alongside anonymous pages".

Link: http://lkml.kernel.org/r/1592288204-27734-3-git-send-email-iamjoonsoo.kim@lge.com
Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joonsoo Kim <js1304@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/swap.c~mm-swap-fix-for-mm-workingset-age-nonresident-information-alongside-anonymous-pages
+++ a/mm/swap.c
@@ -443,8 +443,7 @@ void mark_page_accessed(struct page *pag
 		else
 			__lru_cache_activate_page(page);
 		ClearPageReferenced(page);
-		if (page_is_file_lru(page))
-			workingset_activation(page);
+		workingset_activation(page);
 	}
 	if (page_is_idle(page))
 		clear_page_idle(page);
_

Patches currently in -mm which might be from iamjoonsoo.kim@lge.com are

mm-swap-fix-for-mm-workingset-age-nonresident-information-alongside-anonymous-pages.patch
mm-memory-fix-io-cost-for-anonymous-page.patch
