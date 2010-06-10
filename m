From: akpm@linux-foundation.org
Subject: + memcg-remove-redundant-codes.patch added to -mm tree
Date: Thu, 10 Jun 2010 14:16:39 -0700
Message-ID: <201006102116.o5ALGdwk024073@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42945 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab0FJVQt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Jun 2010 17:16:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nishimura@mxp.nes.nec.co.jp, balbir@linux.vnet.ibm.com, kamezawa.hiroyu@jp.fujitsu.com


The patch titled
     memcg: remove redundant code
has been added to the -mm tree.  Its filename is
     memcg-remove-redundant-codes.patch

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
Subject: memcg: remove redundant code
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

- try_get_mem_cgroup_from_mm() calls rcu_read_lock/unlock by itself, so we
  don't have to call them in task_in_mem_cgroup().
- *mz is not used in __mem_cgroup_uncharge_common().
- we don't have to call lookup_page_cgroup() in mem_cgroup_end_migration()
  after we've cleared PCG_MIGRATION of @oldpage.
- remove empty comment.
- remove redundant empty line in mem_cgroup_cache_charge().

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN mm/memcontrol.c~memcg-remove-redundant-codes mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-redundant-codes
+++ a/mm/memcontrol.c
@@ -840,9 +840,7 @@ int task_in_mem_cgroup(struct task_struc
 	struct mem_cgroup *curr = NULL;
 
 	task_lock(task);
-	rcu_read_lock();
 	curr = try_get_mem_cgroup_from_mm(task->mm);
-	rcu_read_unlock();
 	task_unlock(task);
 	if (!curr)
 		return 0;
@@ -2099,7 +2097,6 @@ int mem_cgroup_cache_charge(struct page 
 	if (!(gfp_mask & __GFP_WAIT)) {
 		struct page_cgroup *pc;
 
-
 		pc = lookup_page_cgroup(page);
 		if (!pc)
 			return 0;
@@ -2293,7 +2290,6 @@ __mem_cgroup_uncharge_common(struct page
 {
 	struct page_cgroup *pc;
 	struct mem_cgroup *mem = NULL;
-	struct mem_cgroup_per_zone *mz;
 
 	if (mem_cgroup_disabled())
 		return NULL;
@@ -2347,7 +2343,6 @@ __mem_cgroup_uncharge_common(struct page
 	 * special functions.
 	 */
 
-	mz = page_cgroup_zoneinfo(pc);
 	unlock_page_cgroup(pc);
 
 	memcg_check_events(mem, page);
@@ -2659,11 +2654,8 @@ void mem_cgroup_end_migration(struct mem
 	ClearPageCgroupMigration(pc);
 	unlock_page_cgroup(pc);
 
-	if (unused != oldpage)
-		pc = lookup_page_cgroup(unused);
 	__mem_cgroup_uncharge_common(unused, MEM_CGROUP_CHARGE_TYPE_FORCE);
 
-	pc = lookup_page_cgroup(used);
 	/*
 	 * If a page is a file cache, radix-tree replacement is very atomic
 	 * and we can skip this check. When it was an Anon page, its mapcount
@@ -3807,8 +3799,6 @@ static int mem_cgroup_oom_control_read(s
 	return 0;
 }
 
-/*
- */
 static int mem_cgroup_oom_control_write(struct cgroup *cgrp,
 	struct cftype *cft, u64 val)
 {
_

Patches currently in -mm which might be from nishimura@mxp.nes.nec.co.jp are

memcg-fix-wake-up-in-oom-wait-queue.patch
memcg-remove-experimental-from-swap-account-config.patch
memcg-clean-up-try_charge-main-loop-v2.patch
memcg-clean-up-waiting-move-acct-v2.patch
memcg-remove-redundant-codes.patch
memcg-remove-mem-from-arg-of-charge_common.patch

