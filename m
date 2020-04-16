From: akpm@linux-foundation.org
Subject: +
 mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch added to -mm tree
Date: Wed, 15 Apr 2020 21:05:45 -0700
Message-ID: <20200416040545.Y7ZHXn2ja%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:54016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgDPEFs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 16 Apr 2020 00:05:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: mm/vmscan.c: use update_lru_size() in update_lru_sizes()
has been added to the -mm tree.  Its filename is
     mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <richard.weiyang@gmail.com>
Subject: mm/vmscan.c: use update_lru_size() in update_lru_sizes()

We already defined the helper update_lru_size().

Let's use this to reduce code duplication.

Link: http://lkml.kernel.org/r/20200331221550.1011-1-richard.weiyang@gmail.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Baoquan He <bhe@redhat.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/mm/vmscan.c~mm-vmscanc-use-update_lru_size-in-update_lru_sizes
+++ a/mm/vmscan.c
@@ -1602,10 +1602,7 @@ static __always_inline void update_lru_s
 		if (!nr_zone_taken[zid])
 			continue;
 
-		__update_lru_size(lruvec, lru, zid, -nr_zone_taken[zid]);
-#ifdef CONFIG_MEMCG
-		mem_cgroup_update_lru_size(lruvec, lru, zid, -nr_zone_taken[zid]);
-#endif
+		update_lru_size(lruvec, lru, zid, -nr_zone_taken[zid]);
 	}
 
 }
_

Patches currently in -mm which might be from richard.weiyang@gmail.com are

mm-page_allocc-bad_-is-not-necessary-when-pagehwpoison.patch
mm-page_allocc-bad_flags-is-not-necessary-for-bad_page.patch
mm-page_allocc-rename-free_pages_check_bad-to-check_free_page_bad.patch
mm-page_allocc-rename-free_pages_check-to-check_free_page.patch
mm-page_allocc-extract-check__page_bad-common-part-to-page_bad_reason.patch
mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch
