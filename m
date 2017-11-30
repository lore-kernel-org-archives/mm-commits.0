From: akpm@linux-foundation.org
Subject: [patch 23/28] mm, memcg: fix mem_cgroup_swapout() for THPs
Date: Wed, 29 Nov 2017 16:11:15 -0800
Message-ID: <5a1f4ca3.6zVgnUfosPaIUjsI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60792 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753589AbdK3ALR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 29 Nov 2017 19:11:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, shakeelb@google.com, gthelen@google.com, hannes@cmpxchg.org, mhocko@suse.com, stable@vger.kernel.org, vdavydov.dev@gmail.com, ying.huang@intel.com

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
