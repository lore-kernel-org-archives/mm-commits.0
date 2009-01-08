From: akpm@linux-foundation.org
Subject: - memcg-remove-mem_cgroup_try_charge.patch removed from -mm tree
Date: Thu, 08 Jan 2009 14:49:37 -0800
Message-ID: <200901082249.n08MnbpS028869@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34253 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760879AbZAHW6p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Jan 2009 17:58:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: nishimura@mxp.nes.nec.co.jp, balbir@in.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, mm-commits@vger.kernel.org


The patch titled
     memcg: remove mem_cgroup_try_charge
has been removed from the -mm tree.  Its filename was
     memcg-remove-mem_cgroup_try_charge.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: remove mem_cgroup_try_charge
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

After previous patch, mem_cgroup_try_charge is not used by anyone, so we
can remove it.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    8 --------
 mm/memcontrol.c            |   21 +--------------------
 2 files changed, 1 insertion(+), 28 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-remove-mem_cgroup_try_charge include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-remove-mem_cgroup_try_charge
+++ a/include/linux/memcontrol.h
@@ -40,8 +40,6 @@ struct mm_struct;
 extern int mem_cgroup_newpage_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask);
 /* for swap handling */
-extern int mem_cgroup_try_charge(struct mm_struct *mm,
-		gfp_t gfp_mask, struct mem_cgroup **ptr);
 extern int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 		struct page *page, gfp_t mask, struct mem_cgroup **ptr);
 extern void mem_cgroup_commit_charge_swapin(struct page *page,
@@ -134,12 +132,6 @@ static inline int mem_cgroup_cache_charg
 	return 0;
 }
 
-static inline int mem_cgroup_try_charge(struct mm_struct *mm,
-			gfp_t gfp_mask, struct mem_cgroup **ptr)
-{
-	return 0;
-}
-
 static inline int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
 		struct page *page, gfp_t gfp_mask, struct mem_cgroup **ptr)
 {
diff -puN mm/memcontrol.c~memcg-remove-mem_cgroup_try_charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-mem_cgroup_try_charge
+++ a/mm/memcontrol.c
@@ -839,27 +839,8 @@ nomem:
 	return -ENOMEM;
 }
 
-/**
- * mem_cgroup_try_charge - get charge of PAGE_SIZE.
- * @mm: an mm_struct which is charged against. (when *memcg is NULL)
- * @gfp_mask: gfp_mask for reclaim.
- * @memcg: a pointer to memory cgroup which is charged against.
- *
- * charge against memory cgroup pointed by *memcg. if *memcg == NULL, estimated
- * memory cgroup from @mm is got and stored in *memcg.
- *
- * Returns 0 if success. -ENOMEM at failure.
- * This call can invoke OOM-Killer.
- */
-
-int mem_cgroup_try_charge(struct mm_struct *mm,
-			  gfp_t mask, struct mem_cgroup **memcg)
-{
-	return __mem_cgroup_try_charge(mm, mask, memcg, true);
-}
