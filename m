From: akpm@linux-foundation.org
Subject: [merged] mm-page_alloc-fix-the-page-address-of-higher-pages-buddy-calculation.patch removed from -mm tree
Date: Tue, 18 Sep 2012 12:05:21 -0700
Message-ID: <20120918190522.27B765C0065@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f74.google.com ([209.85.161.74]:41190 "EHLO
	mail-fa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab2IRTFZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Sep 2012 15:05:25 -0400
Received: by faet1 with SMTP id t1so8607fae.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Sep 2012 12:05:24 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: omycle@gmail.com, jweiner@redhat.com, mgorman@suse.de, mhocko@suse.cz, minchan.kim@gmail.com, pullip.cho@samsung.com, shangw@linux.vnet.ibm.com, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc: fix the page address of higher page's buddy calculation
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-the-page-address-of-higher-pages-buddy-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Li Haifeng <omycle@gmail.com>
Subject: mm/page_alloc: fix the page address of higher page's buddy calculation

The heuristic method for buddy has been introduced since 43506fad
("mm/page_alloc.c: simplify calculation of combined index of adjacent
buddy lists").  But the page address of higher page's buddy was wrongly
calculated, which will lead page_is_buddy to fail for ever.  IOW, the
heuristic method would be disabled with the wrong page address of higher
page's buddy.

Calculating the page address of higher page's buddy should be based
higher_page with the offset between index of higher page and index of
higher page's buddy.

Signed-off-by: Haifeng Li <omycle@gmail.com>
Signed-off-by: Gavin Shan <shangw@linux.vnet.ibm.com>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Cc: KyongHo Cho <pullip.cho@samsung.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: Johannes Weiner <jweiner@redhat.com>
Cc: <stable@vger.kernel.org>	[2.6.38+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-page_alloc-fix-the-page-address-of-higher-pages-buddy-calculation mm/page_alloc.c
--- a/mm/page_alloc.c~mm-page_alloc-fix-the-page-address-of-higher-pages-buddy-calculation
+++ a/mm/page_alloc.c
@@ -584,7 +584,7 @@ static inline void __free_one_page(struc
 		combined_idx = buddy_idx & page_idx;
 		higher_page = page + (combined_idx - page_idx);
 		buddy_idx = __find_buddy_index(combined_idx, order + 1);
-		higher_buddy = page + (buddy_idx - combined_idx);
+		higher_buddy = higher_page + (buddy_idx - combined_idx);
 		if (page_is_buddy(higher_page, higher_buddy, order + 1)) {
 			list_add_tail(&page->lru,
 				&zone->free_area[order].free_list[migratetype]);
_

Patches currently in -mm which might be from omycle@gmail.com are

origin.patch

