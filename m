From: akpm@linux-foundation.org
Subject: + mm-page_alloc-drop-nr_free_pagecache_pages.patch added to
 -mm tree
Date: Sat, 20 Jun 2020 15:55:17 -0700
Message-ID: <20200620225517.fDG-0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727930AbgFTWzS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 20 Jun 2020 18:55:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ying.huang@intel.com, richard.weiyang@gmail.com, minchan@kernel.org, mhocko@suse.com, hannes@cmpxchg.org, david@redhat.com


The patch titled
     Subject: mm/page_alloc: remove nr_free_pagecache_pages()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-drop-nr_free_pagecache_pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-drop-nr_free_pagecache_pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-drop-nr_free_pagecache_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/page_alloc: remove nr_free_pagecache_pages()

nr_free_pagecache_pages() isn't used outside page_alloc.c anymore - and
the name does not really help to understand what's going on.  Let's
open-code it instead and add a comment.

Link: http://lkml.kernel.org/r/20200619132410.23859-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    1 -
 mm/page_alloc.c      |   16 ++--------------
 2 files changed, 2 insertions(+), 15 deletions(-)

--- a/include/linux/swap.h~mm-page_alloc-drop-nr_free_pagecache_pages
+++ a/include/linux/swap.h
@@ -328,7 +328,6 @@ void workingset_update_node(struct xa_no
 /* linux/mm/page_alloc.c */
 extern unsigned long totalreserve_pages;
 extern unsigned long nr_free_buffer_pages(void);
-extern unsigned long nr_free_pagecache_pages(void);
 
 /* Definition of global_zone_page_state not available yet */
 #define nr_free_pages() global_zone_page_state(NR_FREE_PAGES)
--- a/mm/page_alloc.c~mm-page_alloc-drop-nr_free_pagecache_pages
+++ a/mm/page_alloc.c
@@ -5193,19 +5193,6 @@ unsigned long nr_free_buffer_pages(void)
 }
 EXPORT_SYMBOL_GPL(nr_free_buffer_pages);
 
-/**
- * nr_free_pagecache_pages - count number of pages beyond high watermark
- *
- * nr_free_pagecache_pages() counts the number of pages which are beyond the
- * high watermark within all zones.
- *
- * Return: number of pages beyond high watermark within all zones.
- */
-unsigned long nr_free_pagecache_pages(void)
-{
-	return nr_free_zone_pages(gfp_zone(GFP_HIGHUSER_MOVABLE));
-}
