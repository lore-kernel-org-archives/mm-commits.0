From: akpm@linux-foundation.org
Subject: + memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch added to -mm tree
Date: Wed, 08 Jun 2011 14:10:36 -0700
Message-ID: <201106082110.p58LAapA029076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37891 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951Ab1FHVLR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Jun 2011 17:11:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: imammedo@redhat.com, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz


The patch titled
     memcg: do not expose uninitialized mem_cgroup_per_node to world
has been added to the -mm tree.  Its filename is
     memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: do not expose uninitialized mem_cgroup_per_node to world
From: Igor Mammedov <imammedo@redhat.com>

Signed-off-by: Igor Mammedov <imammedo@redhat.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memcontrol.c~memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world
+++ a/mm/memcontrol.c
@@ -4707,7 +4707,6 @@ static int alloc_mem_cgroup_per_zone_inf
 	if (!pn)
 		return 1;
 
-	mem->info.nodeinfo[node] = pn;
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
 		for_each_lru(l)
@@ -4716,6 +4715,7 @@ static int alloc_mem_cgroup_per_zone_inf
 		mz->on_tree = false;
 		mz->mem = mem;
 	}
+	mem->info.nodeinfo[node] = pn;
 	return 0;
 }
 
_

Patches currently in -mm which might be from imammedo@redhat.com are

memcg-do-not-expose-uninitialized-mem_cgroup_per_node-to-world.patch

