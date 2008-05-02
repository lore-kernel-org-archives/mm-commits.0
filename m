From: akpm@linux-foundation.org
Subject: - memcg-simple-stats-for-memory-resource-controller.patch removed from -mm tree
Date: Fri, 02 May 2008 12:43:21 -0700
Message-ID: <200805021943.m42JhLvE011281@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42880 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932496AbYEBToJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 May 2008 15:44:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: balajirrao@gmail.com, balbir@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     memcg: simple stats for memory resource controller
has been removed from the -mm tree.  Its filename was
     memcg-simple-stats-for-memory-resource-controller.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: simple stats for memory resource controller
From: Balaji Rao <balajirrao@gmail.com>

Implement trivial statistics for the memory resource controller.

Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff -puN mm/memcontrol.c~memcg-simple-stats-for-memory-resource-controller mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-simple-stats-for-memory-resource-controller
+++ a/mm/memcontrol.c
@@ -48,6 +48,8 @@ enum mem_cgroup_stat_index {
 	 */
 	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
 	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as rss */
+	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
+	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
 
 	MEM_CGROUP_STAT_NSTATS,
 };
@@ -199,6 +201,13 @@ static void mem_cgroup_charge_statistics
 		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_CACHE, val);
 	else
 		__mem_cgroup_stat_add_safe(stat, MEM_CGROUP_STAT_RSS, val);
+
+	if (charge)
+		__mem_cgroup_stat_add_safe(stat,
+				MEM_CGROUP_STAT_PGPGIN_COUNT, 1);
+	else
+		__mem_cgroup_stat_add_safe(stat,
+				MEM_CGROUP_STAT_PGPGOUT_COUNT, 1);
 }
 
 static struct mem_cgroup_per_zone *
@@ -884,6 +893,8 @@ static const struct mem_cgroup_stat_desc
 } mem_cgroup_stat_desc[] = {
 	[MEM_CGROUP_STAT_CACHE] = { "cache", PAGE_SIZE, },
 	[MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
+	[MEM_CGROUP_STAT_PGPGIN_COUNT] = {"pgpgin", 1, },
+	[MEM_CGROUP_STAT_PGPGOUT_COUNT] = {"pgpgout", 1, },
 };
 
 static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
_

Patches currently in -mm which might be from balajirrao@gmail.com are

origin.patch

