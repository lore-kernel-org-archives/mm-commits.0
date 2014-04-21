From: akpm@linux-foundation.org
Subject: + mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
 added to -mm tree
Date: Mon, 21 Apr 2014 15:03:57 -0700
Message-ID: <535595cd.oG/+BZUns3Gi/Wuf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37259 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151AbaDUWD6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 18:03:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, hannes@cmpxchg.org, bsingharora@gmail.com, nasa4836@gmail.com

Subject: + mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch added to -mm tree
To: nasa4836@gmail.com,bsingharora@gmail.com,hannes@cmpxchg.org,kamezawa.hiroyu@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 15:03:57 -0700


The patch titled
     Subject: mm/memcontrol.c: introduce helper mem_cgroup_zoneinfo_zone()
has been added to the -mm tree.  Its filename is
     mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jianyu Zhan <nasa4836@gmail.com>
Subject: mm/memcontrol.c: introduce helper mem_cgroup_zoneinfo_zone()

Introduce helper mem_cgroup_zoneinfo_zone().  This makes mem_cgroup_iter()
code more compact.

Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jianyu Zhan <nasa4836@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff -puN mm/memcontrol.c~mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone mm/memcontrol.c
--- a/mm/memcontrol.c~mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone
+++ a/mm/memcontrol.c
@@ -683,6 +683,15 @@ mem_cgroup_zoneinfo(struct mem_cgroup *m
 	return &memcg->nodeinfo[nid]->zoneinfo[zid];
 }
 
+static struct mem_cgroup_per_zone *
+mem_cgroup_zoneinfo_zone(struct mem_cgroup *memcg, struct zone *zone)
+{
+       int nid = zone_to_nid(zone);
+       int zid = zone_idx(zone);
+
+       return mem_cgroup_zoneinfo(memcg, nid, zid);
+}
+
 struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
 {
 	return &memcg->css;
@@ -1232,11 +1241,9 @@ struct mem_cgroup *mem_cgroup_iter(struc
 
 	rcu_read_lock();
 	if (reclaim) {
-		int nid = zone_to_nid(reclaim->zone);
-		int zid = zone_idx(reclaim->zone);
 		struct mem_cgroup_per_zone *mz;
 
-		mz = mem_cgroup_zoneinfo(root, nid, zid);
+		mz = mem_cgroup_zoneinfo_zone(root, reclaim->zone);
 		iter = &mz->reclaim_iter[reclaim->priority];
 		if (prev && reclaim->generation != iter->generation) {
 			iter->last_visited = NULL;
@@ -1340,7 +1347,7 @@ struct lruvec *mem_cgroup_zone_lruvec(st
 		goto out;
 	}
 
-	mz = mem_cgroup_zoneinfo(memcg, zone_to_nid(zone), zone_idx(zone));
+	mz = mem_cgroup_zoneinfo_zone(memcg, zone);
 	lruvec = &mz->lruvec;
 out:
 	/*
_

Patches currently in -mm which might be from nasa4836@gmail.com are

mm-memcontrolc-remove-meaningless-while-loop-in-mem_cgroup_iter.patch
mm-memcontrolc-introduce-helper-mem_cgroup_zoneinfo_zone.patch
linux-next.patch

