From: akpm@linux-foundation.org
Subject: + memcg-reduce-check-for-softlimit-excess.patch added to -mm tree
Date: Tue, 29 Sep 2009 15:24:47 -0700
Message-ID: <200909292224.n8TMOlpZ025533@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42062 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbZI2WZT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Sep 2009 18:25:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: reduce check for softlimit excess
has been added to the -mm tree.  Its filename is
     memcg-reduce-check-for-softlimit-excess.patch

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
Subject: memcg: reduce check for softlimit excess
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

In charge/uncharge/reclaim path, usage_in_excess is calculated repeatedly
and it takes res_counter's spin_lock every time.

This patch removes unnecessary calls for res_count_soft_limit_excess.

Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff -puN mm/memcontrol.c~memcg-reduce-check-for-softlimit-excess mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-reduce-check-for-softlimit-excess
+++ a/mm/memcontrol.c
@@ -313,7 +313,8 @@ soft_limit_tree_from_page(struct page *p
 static void
 __mem_cgroup_insert_exceeded(struct mem_cgroup *mem,
 				struct mem_cgroup_per_zone *mz,
-				struct mem_cgroup_tree_per_zone *mctz)
+				struct mem_cgroup_tree_per_zone *mctz,
+				unsigned long long new_usage_in_excess)
 {
 	struct rb_node **p = &mctz->rb_root.rb_node;
 	struct rb_node *parent = NULL;
@@ -322,7 +323,9 @@ __mem_cgroup_insert_exceeded(struct mem_
 	if (mz->on_tree)
 		return;
 
-	mz->usage_in_excess = res_counter_soft_limit_excess(&mem->res);
+	mz->usage_in_excess = new_usage_in_excess;
+	if (!mz->usage_in_excess)
+		return;
 	while (*p) {
 		parent = *p;
 		mz_node = rb_entry(parent, struct mem_cgroup_per_zone,
@@ -382,7 +385,7 @@ static bool mem_cgroup_soft_limit_check(
 
 static void mem_cgroup_update_tree(struct mem_cgroup *mem, struct page *page)
 {
-	unsigned long long new_usage_in_excess;
+	unsigned long long excess;
 	struct mem_cgroup_per_zone *mz;
 	struct mem_cgroup_tree_per_zone *mctz;
 	int nid = page_to_nid(page);
@@ -395,25 +398,21 @@ static void mem_cgroup_update_tree(struc
 	 */
 	for (; mem; mem = parent_mem_cgroup(mem)) {
 		mz = mem_cgroup_zoneinfo(mem, nid, zid);
-		new_usage_in_excess =
-			res_counter_soft_limit_excess(&mem->res);
+		excess = res_counter_soft_limit_excess(&mem->res);
 		/*
 		 * We have to update the tree if mz is on RB-tree or
 		 * mem is over its softlimit.
 		 */
-		if (new_usage_in_excess || mz->on_tree) {
+		if (excess || mz->on_tree) {
 			spin_lock(&mctz->lock);
 			/* if on-tree, remove it */
 			if (mz->on_tree)
 				__mem_cgroup_remove_exceeded(mem, mz, mctz);
 			/*
-			 * if over soft limit, insert again. mz->usage_in_excess
-			 * will be updated properly.
+			 * Insert again. mz->usage_in_excess will be updated.
+			 * If excess is 0, no tree ops.
 			 */
-			if (new_usage_in_excess)
-				__mem_cgroup_insert_exceeded(mem, mz, mctz);
-			else
-				mz->usage_in_excess = 0;
+			__mem_cgroup_insert_exceeded(mem, mz, mctz, excess);
 			spin_unlock(&mctz->lock);
 		}
 	}
@@ -2221,6 +2220,7 @@ unsigned long mem_cgroup_soft_limit_recl
 	unsigned long reclaimed;
 	int loop = 0;
 	struct mem_cgroup_tree_per_zone *mctz;
+	unsigned long long excess;
 
 	if (order > 0)
 		return 0;
@@ -2272,9 +2272,8 @@ unsigned long mem_cgroup_soft_limit_recl
 					break;
 			} while (1);
 		}
-		mz->usage_in_excess =
-			res_counter_soft_limit_excess(&mz->mem->res);
 		__mem_cgroup_remove_exceeded(mz->mem, mz, mctz);
+		excess = res_counter_soft_limit_excess(&mz->mem->res);
 		/*
 		 * One school of thought says that we should not add
 		 * back the node to the tree if reclaim returns 0.
@@ -2283,8 +2282,8 @@ unsigned long mem_cgroup_soft_limit_recl
 		 * memory to reclaim from. Consider this as a longer
 		 * term TODO.
 		 */
-		if (mz->usage_in_excess)
-			__mem_cgroup_insert_exceeded(mz->mem, mz, mctz);
+		/* If excess == 0, no tree ops */
+		__mem_cgroup_insert_exceeded(mz->mem, mz, mctz, excess);
 		spin_unlock(&mctz->lock);
 		css_put(&mz->mem->css);
 		loop++;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

memcg-fix-refcnt-goes-to-minus.patch
cgroup-catch-bad-css-refcnt-at-css_put.patch
memcg-some-modification-to-softlimit-under-hierarchical-memory-reclaim.patch
memcg-reduce-check-for-softlimit-excess.patch

