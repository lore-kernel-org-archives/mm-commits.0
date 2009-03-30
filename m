From: akpm@linux-foundation.org
Subject: + memcg-cleanup-cache_charge.patch added to -mm tree
Date: Mon, 30 Mar 2009 16:40:51 -0700
Message-ID: <200903302340.n2UNepXq026371@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752427AbZC3XnP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Mar 2009 19:43:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: cleanup cache_charge
has been added to the -mm tree.  Its filename is
     memcg-cleanup-cache_charge.patch

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
Subject: memcg: cleanup cache_charge
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Current mem_cgroup_cache_charge is a bit complicated especially
in the case of shmem's swap-in.

This patch cleans it up by using try_charge_swapin and commit_charge_swapin.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   60 +++++++++++++++++-----------------------------
 1 file changed, 23 insertions(+), 37 deletions(-)

diff -puN mm/memcontrol.c~memcg-cleanup-cache_charge mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-cleanup-cache_charge
+++ a/mm/memcontrol.c
@@ -1238,6 +1238,10 @@ int mem_cgroup_newpage_charge(struct pag
 				MEM_CGROUP_CHARGE_TYPE_MAPPED, NULL);
 }
 
+static void
+__mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr,
+					enum charge_type ctype);
+
 int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
 				gfp_t gfp_mask)
 {
@@ -1274,16 +1278,6 @@ int mem_cgroup_cache_charge(struct page 
 		unlock_page_cgroup(pc);
 	}
 
-	if (do_swap_account && PageSwapCache(page)) {
-		mem = try_get_mem_cgroup_from_swapcache(page);
-		if (mem)
-			mm = NULL;
-		  else
-			mem = NULL;
-		/* SwapCache may be still linked to LRU now. */
-		mem_cgroup_lru_del_before_commit_swapcache(page);
-	}
-
 	if (unlikely(!mm && !mem))
 		mm = &init_mm;
 
@@ -1291,32 +1285,16 @@ int mem_cgroup_cache_charge(struct page 
 		return mem_cgroup_charge_common(page, mm, gfp_mask,
 				MEM_CGROUP_CHARGE_TYPE_CACHE, NULL);
 
-	ret = mem_cgroup_charge_common(page, mm, gfp_mask,
-				MEM_CGROUP_CHARGE_TYPE_SHMEM, mem);
-	if (mem)
-		css_put(&mem->css);
-	if (PageSwapCache(page))
-		mem_cgroup_lru_add_after_commit_swapcache(page);
+	/* shmem */
+	if (PageSwapCache(page)) {
+		ret = mem_cgroup_try_charge_swapin(mm, page, gfp_mask, &mem);
+		if (!ret)
+			__mem_cgroup_commit_charge_swapin(page, mem,
+					MEM_CGROUP_CHARGE_TYPE_SHMEM);
+	} else
+		ret = mem_cgroup_charge_common(page, mm, gfp_mask,
+					MEM_CGROUP_CHARGE_TYPE_SHMEM, mem);
 
-	if (do_swap_account && !ret && PageSwapCache(page)) {
-		swp_entry_t ent = {.val = page_private(page)};
-		unsigned short id;
-		/* avoid double counting */
-		id = swap_cgroup_record(ent, 0);
-		rcu_read_lock();
-		mem = mem_cgroup_lookup(id);
-		if (mem) {
-			/*
-			 * We did swap-in. Then, this entry is doubly counted
-			 * both in mem and memsw. We uncharge it, here.
-			 * Recorded ID can be obsolete. We avoid calling
-			 * css_tryget()
-			 */
-			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
-			mem_cgroup_put(mem);
-		}
-		rcu_read_unlock();
-	}
 	return ret;
 }
 
@@ -1359,7 +1337,9 @@ charge_cur_mm:
 	return __mem_cgroup_try_charge(mm, mask, ptr, true);
 }
 
-void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
+static void
+__mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr,
+					enum charge_type ctype)
 {
 	struct page_cgroup *pc;
 
@@ -1369,7 +1349,7 @@ void mem_cgroup_commit_charge_swapin(str
 		return;
 	pc = lookup_page_cgroup(page);
 	mem_cgroup_lru_del_before_commit_swapcache(page);
-	__mem_cgroup_commit_charge(ptr, pc, MEM_CGROUP_CHARGE_TYPE_MAPPED);
+	__mem_cgroup_commit_charge(ptr, pc, ctype);
 	mem_cgroup_lru_add_after_commit_swapcache(page);
 	/*
 	 * Now swap is on-memory. This means this page may be
@@ -1400,6 +1380,12 @@ void mem_cgroup_commit_charge_swapin(str
 
 }
 
+void mem_cgroup_commit_charge_swapin(struct page *page, struct mem_cgroup *ptr)
+{
+	__mem_cgroup_commit_charge_swapin(page, ptr,
+					MEM_CGROUP_CHARGE_TYPE_MAPPED);
+}
+
 void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *mem)
 {
 	if (mem_cgroup_disabled())
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

cgroup-css-id-support.patch
cgroup-fix-frequent-ebusy-at-rmdir.patch
memcg-use-css-id.patch
memcg-hierarchical-stat.patch
memcg-fix-shrinking-memory-to-return-ebusy-by-fixing-retry-algorithm.patch
memcg-fix-oom-killer-under-memcg.patch
memcg-fix-oom-killer-under-memcg-fix2.patch
memcg-fix-oom-killer-under-memcg-fix.patch
memcg-show-memcg-information-during-oom.patch
memcg-show-memcg-information-during-oom-fix2.patch
memcg-show-memcg-information-during-oom-fix.patch
memcg-show-memcg-information-during-oom-fix-fix.patch
memcg-show-memcg-information-during-oom-fix-fix-checkpatch-fixes.patch
memcg-charge-swapcache-to-proper-memcg.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5.patch
cgroups-use-css-id-in-swap-cgroup-for-saving-memory-v5-fix.patch
memcg-cleanup-cache_charge.patch

