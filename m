From: akpm@linux-foundation.org
Subject: - memcg-css_put-after-remove_list.patch removed from -mm tree
Date: Tue, 04 Mar 2008 23:45:36 -0800
Message-ID: <200803050745.m257ja6C021608@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56046 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758098AbYCEHvA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Mar 2008 02:51:00 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hugh@veritas.com, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, rientjes@google.com, taka@valinux.co.jp, yamamoto@valinux.co.jp, mm-commits@vger.kernel.org


The patch titled
     memcg: css_put after remove_list
has been removed from the -mm tree.  Its filename was
     memcg-css_put-after-remove_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: css_put after remove_list
From: Hugh Dickins <hugh@veritas.com>

mem_cgroup_uncharge_page does css_put on the mem_cgroup before uncharging from
it, and before removing page_cgroup from one of its lru lists: isn't there a
danger that struct mem_cgroup memory could be freed and reused before
completing that, so corrupting something?  Never seen it, and for all I know
there may be other constraints which make it impossible; but let's be
defensive and reverse the ordering there.

mem_cgroup_force_empty_list is safe because there's an extra css_get around
all its works; but even so, change its ordering the same way round, to help
get in the habit of doing it like this.

Signed-off-by: Hugh Dickins <hugh@veritas.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Hirokazu Takahashi <taka@valinux.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff -puN mm/memcontrol.c~memcg-css_put-after-remove_list mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-css_put-after-remove_list
+++ a/mm/memcontrol.c
@@ -665,15 +665,15 @@ void mem_cgroup_uncharge_page(struct pag
 		page_assign_page_cgroup(page, NULL);
 		unlock_page_cgroup(page);
 
-		mem = pc->mem_cgroup;
-		css_put(&mem->css);
-		res_counter_uncharge(&mem->res, PAGE_SIZE);
-
 		mz = page_cgroup_zoneinfo(pc);
 		spin_lock_irqsave(&mz->lru_lock, flags);
 		__mem_cgroup_remove_list(pc);
 		spin_unlock_irqrestore(&mz->lru_lock, flags);
 
+		mem = pc->mem_cgroup;
+		res_counter_uncharge(&mem->res, PAGE_SIZE);
+		css_put(&mem->css);
+
 		kfree(pc);
 		return;
 	}
@@ -774,9 +774,9 @@ retry:
 		if (page_get_page_cgroup(page) == pc) {
 			page_assign_page_cgroup(page, NULL);
 			unlock_page_cgroup(page);
-			css_put(&mem->css);
-			res_counter_uncharge(&mem->res, PAGE_SIZE);
 			__mem_cgroup_remove_list(pc);
+			res_counter_uncharge(&mem->res, PAGE_SIZE);
+			css_put(&mem->css);
 			kfree(pc);
 		} else {
 			/* racing uncharge: let page go then retry */
_

Patches currently in -mm which might be from hugh@veritas.com are

git-unionfs.patch
mmap_region-cleanup-the-final-vma_merge-related-code.patch
mm-use-zonelists-instead-of-zones-when-direct-reclaiming-pages.patch
mm-introduce-node_zonelist-for-accessing-the-zonelist-for-a-gfp-mask.patch
mm-remember-what-the-preferred-zone-is-for-zone_statistics.patch
mm-use-two-zonelist-that-are-filtered-by-gfp-mask.patch
mm-have-zonelist-contains-structs-with-both-a-zone-pointer-and-zone_idx.patch
mm-filter-based-on-a-nodemask-as-well-as-a-gfp_mask.patch
mm-try-both-endianess-when-checking-for-endianess.patch
procfs-task-exe-symlink.patch
procfs-task-exe-symlink-fix.patch
procfs-task-exe-symlink-fix-2.patch
prio_tree-debugging-patch.patch

