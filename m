From: akpm@linux-foundation.org
Subject: + memcg-fix-mem_cgroup_shrink_usage.patch added to -mm tree
Date: Tue, 21 Apr 2009 13:42:38 -0700
Message-ID: <200904212042.n3LKgcHk023545@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46846 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950AbZDUUso (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Apr 2009 16:48:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, dhaval@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com, lizf@cn.fujitsu.cn, menage@google.com, rientjes@google.com, yamamoto@valinux.co.jp


The patch titled
     memcg: fix mem_cgroup_shrink_usage()
has been added to the -mm tree.  Its filename is
     memcg-fix-mem_cgroup_shrink_usage.patch

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
Subject: memcg: fix mem_cgroup_shrink_usage()
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Current mem_cgroup_shrink_usage() has two problems.

1. It doesn't call mem_cgroup_out_of_memory and doesn't update
   last_oom_jiffies, so pagefault_out_of_memory invokes global OOM.

2. Considering hierarchy, shrinking has to be done from the
   mem_over_limit, not from the memcg which the page would be charged to.

mem_cgroup_try_charge_swapin() does all of these things properly, so we
use it and call cancel_charge_swapin when it succeeded.

The name of "shrink_usage" is not appropriate for this behavior, so we
change it too.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Li Zefan <lizf@cn.fujitsu.cn>
Cc: Paul Menage <menage@google.com>
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    4 ++--
 mm/memcontrol.c            |   33 ++++++++++++---------------------
 mm/shmem.c                 |    8 ++++++--
 3 files changed, 20 insertions(+), 25 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-fix-mem_cgroup_shrink_usage include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-mem_cgroup_shrink_usage
+++ a/include/linux/memcontrol.h
@@ -56,7 +56,7 @@ extern void mem_cgroup_move_lists(struct
 				  enum lru_list from, enum lru_list to);
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_uncharge_cache_page(struct page *page);
-extern int mem_cgroup_shrink_usage(struct page *page,
+extern int mem_cgroup_shmem_charge_fallback(struct page *page,
 			struct mm_struct *mm, gfp_t gfp_mask);
 
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
@@ -155,7 +155,7 @@ static inline void mem_cgroup_uncharge_c
 {
 }
 
-static inline int mem_cgroup_shrink_usage(struct page *page,
+static inline int mem_cgroup_shmem_charge_fallback(struct page *page,
 			struct mm_struct *mm, gfp_t gfp_mask)
 {
 	return 0;
diff -puN mm/memcontrol.c~memcg-fix-mem_cgroup_shrink_usage mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-mem_cgroup_shrink_usage
+++ a/mm/memcontrol.c
@@ -1618,37 +1618,28 @@ void mem_cgroup_end_migration(struct mem
 }
 
 /*
- * A call to try to shrink memory usage under specified resource controller.
- * This is typically used for page reclaiming for shmem for reducing side
- * effect of page allocation from shmem, which is used by some mem_cgroup.
+ * A call to try to shrink memory usage on charge failure at shmem's swapin.
+ * Calling hierarchical_reclaim is not enough because we should update
+ * last_oom_jiffies to prevent pagefault_out_of_memory from invoking global OOM.
+ * Moreover considering hierarchy, we should reclaim from the mem_over_limit,
+ * not from the memcg which this page would be charged to.
+ * try_charge_swapin does all of these works properly.
  */
-int mem_cgroup_shrink_usage(struct page *page,
+int mem_cgroup_shmem_charge_fallback(struct page *page,
 			    struct mm_struct *mm,
 			    gfp_t gfp_mask)
 {
 	struct mem_cgroup *mem = NULL;
-	int progress = 0;
-	int retry = MEM_CGROUP_RECLAIM_RETRIES;
+	int ret;
 
 	if (mem_cgroup_disabled())
 		return 0;
-	if (page)
-		mem = try_get_mem_cgroup_from_swapcache(page);
-	if (!mem && mm)
-		mem = try_get_mem_cgroup_from_mm(mm);
-	if (unlikely(!mem))
-		return 0;
 
-	do {
-		progress = mem_cgroup_hierarchical_reclaim(mem,
-					gfp_mask, true, false);
-		progress += mem_cgroup_check_under_limit(mem);
-	} while (!progress && --retry);
+	ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &mem);
+	if (!ret)
+		mem_cgroup_cancel_charge_swapin(mem); /* it does !mem check */
 
-	css_put(&mem->css);
-	if (!retry)
-		return -ENOMEM;
-	return 0;
+	return ret;
 }
 
 static DEFINE_MUTEX(set_limit_mutex);
diff -puN mm/shmem.c~memcg-fix-mem_cgroup_shrink_usage mm/shmem.c
--- a/mm/shmem.c~memcg-fix-mem_cgroup_shrink_usage
+++ a/mm/shmem.c
@@ -1340,8 +1340,12 @@ repeat:
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			if (error == -ENOMEM) {
-				/* allow reclaim from this memory cgroup */
-				error = mem_cgroup_shrink_usage(swappage,
+				/*
+				 * reclaim from proper memory cgroup and
+				 * call memcg's OOM if needed.
+				 */
+				error = mem_cgroup_shmem_charge_fallback(
+								swappage,
 								current->mm,
 								gfp);
 				if (error) {
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

vmscanmemcg-reintroduce-sc-may_swap.patch
memcg-fix-mem_cgroup_shrink_usage.patch
memcg-add-file-based-rss-accounting.patch

