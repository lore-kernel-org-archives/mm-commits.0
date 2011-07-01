From: akpm@linux-foundation.org
Subject: + memcg-fix-reclaimable-lru-check-in-memcg-fix-2.patch added to -mm tree
Date: Fri, 01 Jul 2011 12:36:20 -0700
Message-ID: <201107011936.p61JaKZE010589@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756134Ab1GATg2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 Jul 2011 15:36:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, randy.dunlap@oracle.com


The patch titled
     memcg-fix-reclaimable-lru-check-in-memcg-fix-2
has been added to the -mm tree.  Its filename is
     memcg-fix-reclaimable-lru-check-in-memcg-fix-2.patch

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
Subject: memcg-fix-reclaimable-lru-check-in-memcg-fix-2
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

 memcg-fix-reclaimable-lru-check-in-memcg.patch
 causes following error with !CONFIG_NUMA.

> mmotm-2011-0630-1559/mm/memcontrol.c:1579: error: implicit declaration of function 'mem_cgroup_node_nr_file_lru_pages'
> mmotm-2011-0630-1559/mm/memcontrol.c:1583: error: implicit declaration of function 'mem_cgroup_node_nr_anon_lru_pages'
>

This patch fixes it by moving functions out of #ifdef.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff -puN mm/memcontrol.c~memcg-fix-reclaimable-lru-check-in-memcg-fix-2 mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-reclaimable-lru-check-in-memcg-fix-2
+++ a/mm/memcontrol.c
@@ -1120,7 +1120,6 @@ unsigned long mem_cgroup_zone_nr_lru_pag
 	return MEM_CGROUP_ZSTAT(mz, lru);
 }
 
-#ifdef CONFIG_NUMA
 static unsigned long mem_cgroup_node_nr_file_lru_pages(struct mem_cgroup *memcg,
 							int nid)
 {
@@ -1132,6 +1131,17 @@ static unsigned long mem_cgroup_node_nr_
 	return ret;
 }
 
+static unsigned long mem_cgroup_node_nr_anon_lru_pages(struct mem_cgroup *memcg,
+							int nid)
+{
+	unsigned long ret;
+
+	ret = mem_cgroup_get_zonestat_node(memcg, nid, LRU_INACTIVE_ANON) +
+		mem_cgroup_get_zonestat_node(memcg, nid, LRU_ACTIVE_ANON);
+	return ret;
+}
+
+#if MAX_NUMNODES > 1
 static unsigned long mem_cgroup_nr_file_lru_pages(struct mem_cgroup *memcg)
 {
 	u64 total = 0;
@@ -1143,17 +1153,6 @@ static unsigned long mem_cgroup_nr_file_
 	return total;
 }
 
-static unsigned long mem_cgroup_node_nr_anon_lru_pages(struct mem_cgroup *memcg,
-							int nid)
-{
-	unsigned long ret;
-
-	ret = mem_cgroup_get_zonestat_node(memcg, nid, LRU_INACTIVE_ANON) +
-		mem_cgroup_get_zonestat_node(memcg, nid, LRU_ACTIVE_ANON);
-
-	return ret;
-}
