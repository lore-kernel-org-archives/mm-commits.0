From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 079/131] mm/vmscan.c: use update_lru_size() in
 update_lru_sizes()
Date: Wed, 03 Jun 2020 16:01:12 -0700
Message-ID: <20200603230112.hyTngoiGE%akpm@linux-foundation.org>
References: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:43702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725821AbgFCXBN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 3 Jun 2020 19:01:13 -0400
In-Reply-To: <20200603155549.e041363450869eaae4c7f05b@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, linux-mm@kvack.org, mhocko@suse.com, mm-commits@vger.kernel.org, richard.weiyang@gmail.com, torvalds@linux-foundation.org

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
