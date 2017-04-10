From: akpm@linux-foundation.org
Subject: [merged]
 mm-swap_cgroup-reschedule-when-neeed-in-swap_cgroup_swapoff.patch removed
 from -mm tree
Date: Mon, 10 Apr 2017 11:51:04 -0700
Message-ID: <58ebd418.4E9TwgbpCLpSr6dv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46960 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752114AbdDJSvF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 14:51:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.com, vdavydov.dev@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, swap_cgroup: reschedule when neeed in swap_cgroup_swapoff()
has been removed from the -mm tree.  Its filename was
     mm-swap_cgroup-reschedule-when-neeed-in-swap_cgroup_swapoff.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, swap_cgroup: reschedule when neeed in swap_cgroup_swapoff()

We got need_resched() warnings in swap_cgroup_swapoff() because
swap_cgroup_ctrl[type].length is particularly large.

Reschedule when needed.

Link: http://lkml.kernel.org/r/alpine.DEB.2.10.1704061315270.80559@chino.kir.corp.google.com
Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN mm/swap_cgroup.c~mm-swap_cgroup-reschedule-when-neeed-in-swap_cgroup_swapoff mm/swap_cgroup.c
--- a/mm/swap_cgroup.c~mm-swap_cgroup-reschedule-when-neeed-in-swap_cgroup_swapoff
+++ a/mm/swap_cgroup.c
@@ -201,6 +201,8 @@ void swap_cgroup_swapoff(int type)
 			struct page *page = map[i];
 			if (page)
 				__free_page(page);
+			if (!(i % SWAP_CLUSTER_MAX))
+				cond_resched();
 		}
 		vfree(map);
 	}
_

Patches currently in -mm which might be from rientjes@google.com are

mm-vmstat-print-non-populated-zones-in-zoneinfo.patch
mm-vmstat-suppress-pcp-stats-for-unpopulated-zones-in-zoneinfo.patch

