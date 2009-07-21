From: akpm@linux-foundation.org
Subject: + memory-controller-soft-limit-refactor-reclaim-flags-v9.patch added to -mm tree
Date: Tue, 21 Jul 2009 14:14:29 -0700
Message-ID: <200907212114.n6LLETZ3025136@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41545 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755100AbZGUVOh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jul 2009 17:14:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.com


The patch titled
     memory controller: soft limit refactor reclaim flags
has been added to the -mm tree.  Its filename is
     memory-controller-soft-limit-refactor-reclaim-flags-v9.patch

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
Subject: memory controller: soft limit refactor reclaim flags
From: Balbir Singh <balbir@linux.vnet.ibm.com>

Refactor mem_cgroup_hierarchical_reclaim()

Refactor the arguments passed to mem_cgroup_hierarchical_reclaim() into
flags, so that new parameters don't have to be passed as we make the
reclaim routine more flexible

Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memory-controller-soft-limit-refactor-reclaim-flags-v9 mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-soft-limit-refactor-reclaim-flags-v9
+++ a/mm/memcontrol.c
@@ -252,6 +252,14 @@ enum charge_type {
 #define MEMFILE_TYPE(val)	(((val) >> 16) & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
 
+/*
+ * Reclaim flags for mem_cgroup_hierarchical_reclaim
+ */
+#define MEM_CGROUP_RECLAIM_NOSWAP_BIT	0x0
+#define MEM_CGROUP_RECLAIM_NOSWAP	(1 << MEM_CGROUP_RECLAIM_NOSWAP_BIT)
+#define MEM_CGROUP_RECLAIM_SHRINK_BIT	0x1
+#define MEM_CGROUP_RECLAIM_SHRINK	(1 << MEM_CGROUP_RECLAIM_SHRINK_BIT)
+
 static void mem_cgroup_get(struct mem_cgroup *mem);
 static void mem_cgroup_put(struct mem_cgroup *mem);
 static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
@@ -1031,11 +1039,14 @@ mem_cgroup_select_victim(struct mem_cgro
  * If shrink==true, for avoiding to free too much, this returns immedieately.
  */
 static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
-				   gfp_t gfp_mask, bool noswap, bool shrink)
+						gfp_t gfp_mask,
+						unsigned long reclaim_options)
 {
 	struct mem_cgroup *victim;
 	int ret, total = 0;
 	int loop = 0;
+	bool noswap = reclaim_options & MEM_CGROUP_RECLAIM_NOSWAP;
+	bool shrink = reclaim_options & MEM_CGROUP_RECLAIM_SHRINK;
 
 	/* If memsw_is_minimum==1, swap-out is of-no-use. */
 	if (root_mem->memsw_is_minimum)
@@ -1173,7 +1184,7 @@ static int __mem_cgroup_try_charge(struc
 
 	while (1) {
 		int ret;
-		bool noswap = false;
+		unsigned long flags = 0;
 
 		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res,
 						&soft_fail_res);
@@ -1186,7 +1197,7 @@ static int __mem_cgroup_try_charge(struc
 				break;
 			/* mem+swap counter fails */
 			res_counter_uncharge(&mem->res, PAGE_SIZE, NULL);
-			noswap = true;
+			flags |= MEM_CGROUP_RECLAIM_NOSWAP;
 			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
 									memsw);
 		} else
@@ -1198,7 +1209,7 @@ static int __mem_cgroup_try_charge(struc
 			goto nomem;
 
 		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
-							noswap, false);
+							flags);
 		if (ret)
 			continue;
 
@@ -2010,7 +2021,7 @@ static int mem_cgroup_resize_limit(struc
 			break;
 
 		progress = mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL,
-						   false, true);
+						   MEM_CGROUP_RECLAIM_SHRINK);
 		curusage = res_counter_read_u64(&memcg->res, RES_USAGE);
 		/* Usage is reduced ? */
   		if (curusage >= oldusage)
@@ -2062,7 +2073,9 @@ static int mem_cgroup_resize_memsw_limit
 		if (!ret)
 			break;
 
-		mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL, true, true);
+		mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL,
+						MEM_CGROUP_RECLAIM_NOSWAP |
+						MEM_CGROUP_RECLAIM_SHRINK);
 		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
 		/* Usage is reduced ? */
 		if (curusage >= oldusage)
_

Patches currently in -mm which might be from balbir@linux.vnet.ibm.com are

linux-next.patch
cgroup-avoid-permanent-sleep-at-rmdir-v7.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup-fix-2.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch

