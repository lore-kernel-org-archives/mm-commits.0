From: akpm@linux-foundation.org
Subject: [merged]
 mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch removed from -mm
 tree
Date: Thu, 04 Jun 2020 10:19:40 -0700
Message-ID: <20200604171940.sV92P672j%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730043AbgFDRTl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:19:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com


The patch titled
     Subject: mm/vmscan.c: use update_lru_size() in update_lru_sizes()
has been removed from the -mm tree.  Its filename was
     mm-vmscanc-use-update_lru_size-in-update_lru_sizes.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

bitops-simplify-get_count_order_long.patch
bitops-use-the-same-mechanism-for-get_count_order.patch
lib-test-get_count_order-long-in-test_bitopsc.patch
