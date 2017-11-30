From: akpm@linux-foundation.org
Subject: [merged] mm-memcg-fix-mem_cgroup_swapout-for-thps.patch
 removed from -mm tree
Date: Thu, 30 Nov 2017 12:19:14 -0800
Message-ID: <20171130201914.vEgbXTphy%akpm__5905.33099971271$1512073169$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52452 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbdK3UTQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 30 Nov 2017 15:19:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com, stable@vger.kernel.org, vdavydov.dev@gmail.com, ying.huang@intel.com


The patch titled
     Subject: mm, memcg: fix mem_cgroup_swapout() for THPs
has been removed from the -mm tree.  Its filename was
     mm-memcg-fix-mem_cgroup_swapout-for-thps.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: mm, memcg: fix mem_cgroup_swapout() for THPs

d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout() support THP")
changed mem_cgroup_swapout() to support transparent huge page (THP). 
However the patch missed one location which should be changed for
correctly handling THPs.  The resulting bug will cause the memory cgroups
whose THPs were swapped out to become zombies on deletion.

Link: http://lkml.kernel.org/r/20171128161941.20931-1-shakeelb@google.com
Fixes: d6810d730022 ("memcg, THP, swap: make mem_cgroup_swapout() support THP")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Greg Thelen <gthelen@google.com>
Cc: <stable@vger.kernel.org>

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~mm-memcg-fix-mem_cgroup_swapout-for-thps mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcg-fix-mem_cgroup_swapout-for-thps
+++ a/mm/memcontrol.c
@@ -6044,7 +6044,7 @@ void mem_cgroup_swapout(struct page *pag
 	memcg_check_events(memcg, page);
 
 	if (!mem_cgroup_is_root(memcg))
-		css_put(&memcg->css);
+		css_put_many(&memcg->css, nr_entries);
 }
 
 /**
_

Patches currently in -mm which might be from shakeelb@google.com are

mm-mlock-vmscan-no-more-skipping-pagevecs.patch
vfs-remove-might_sleep-from-clear_inode.patch

