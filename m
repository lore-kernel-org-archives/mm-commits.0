From: akpm@linux-foundation.org
Subject: [merged] memcg-mem_cgroup_move_parent-doesnt-need-gfp_mask.patch removed from -mm tree
Date: Wed, 01 Aug 2012 13:13:20 -0700
Message-ID: <20120801201321.18979200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:46279 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755945Ab2HAUNX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 1 Aug 2012 16:13:23 -0400
Received: by weyr1 with SMTP id r1so344113wey.1
        for <mm-commits@vger.kernel.org>; Wed, 01 Aug 2012 13:13:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, mhocko@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: mem_cgroup_move_parent() doesn't need gfp_mask
has been removed from the -mm tree.  Its filename was
     memcg-mem_cgroup_move_parent-doesnt-need-gfp_mask.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: mem_cgroup_move_parent() doesn't need gfp_mask

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/memcontrol.c~memcg-mem_cgroup_move_parent-doesnt-need-gfp_mask mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-mem_cgroup_move_parent-doesnt-need-gfp_mask
+++ a/mm/memcontrol.c
@@ -2643,8 +2643,7 @@ out:
 
 static int mem_cgroup_move_parent(struct page *page,
 				  struct page_cgroup *pc,
-				  struct mem_cgroup *child,
-				  gfp_t gfp_mask)
+				  struct mem_cgroup *child)
 {
 	struct mem_cgroup *parent;
 	unsigned int nr_pages;
@@ -3652,7 +3651,7 @@ static int mem_cgroup_force_empty_list(s
 
 		pc = lookup_page_cgroup(page);
 
-		ret = mem_cgroup_move_parent(page, pc, memcg, GFP_KERNEL);
+		ret = mem_cgroup_move_parent(page, pc, memcg);
 
 		if (ret == -EBUSY || ret == -EINVAL) {
 			/* found lock contention or "pc" is obsolete. */
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch

