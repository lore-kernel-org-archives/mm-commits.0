From: akpm@linux-foundation.org
Subject: + memcg-fix-race-in-file_mapped-accounting.patch added to -mm tree
Date: Fri, 26 Mar 2010 14:37:32 -0700
Message-ID: <201003262137.o2QLbW4B021968@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52611 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752488Ab0CZViD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Mar 2010 17:38:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com, arighi@develer.com, balbir@in.ibm.com, nishimura@mxp.nes.nec.co.jp


The patch titled
     memcg: fix race in file_mapped accounting
has been added to the -mm tree.  Its filename is
     memcg-fix-race-in-file_mapped-accounting.patch

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
Subject: memcg: fix race in file_mapped accounting
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Presently, memcg's FILE_MAPPED accounting has following race with
move_account (happens at rmdir()).

    increment page->mapcount (rmap.c)
    mem_cgroup_update_file_mapped()           move_account()
					      lock_page_cgroup()
					      check page_mapped() if
					      page_mapped(page)>1 {
						FILE_MAPPED -1 from old memcg
						FILE_MAPPED +1 to old memcg
					      }
					      .....
					      overwrite pc->mem_cgroup
					      unlock_page_cgroup()
    lock_page_cgroup()
    FILE_MAPPED + 1 to pc->mem_cgroup
    unlock_page_cgroup()

Then,
	old memcg (-1 file mapped)
	new memcg (+2 file mapped)

This happens because move_account see page_mapped() which is not guarded
by lock_page_cgroup().  This patch adds FILE_MAPPED flag to page_cgroup
and move account information based on it.  Now, all checks are synchronous
with lock_page_cgroup().

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Balbir Singh <balbir@in.ibm.com>
Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Andrea Righi <arighi@develer.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    6 ++++++
 mm/memcontrol.c             |   18 +++++++++---------
 2 files changed, 15 insertions(+), 9 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-fix-race-in-file_mapped-accounting include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-fix-race-in-file_mapped-accounting
+++ a/include/linux/page_cgroup.h
@@ -39,6 +39,7 @@ enum {
 	PCG_CACHE, /* charged as cache */
 	PCG_USED, /* this object is in use. */
 	PCG_ACCT_LRU, /* page has been accounted for */
+	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
 };
 
 #define TESTPCGFLAG(uname, lname)			\
@@ -73,6 +74,11 @@ CLEARPCGFLAG(AcctLRU, ACCT_LRU)
 TESTPCGFLAG(AcctLRU, ACCT_LRU)
 TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
 
+
+SETPCGFLAG(FileMapped, FILE_MAPPED)
+CLEARPCGFLAG(FileMapped, FILE_MAPPED)
+TESTPCGFLAG(FileMapped, FILE_MAPPED)
+
 static inline int page_cgroup_nid(struct page_cgroup *pc)
 {
 	return page_to_nid(pc->page);
diff -puN mm/memcontrol.c~memcg-fix-race-in-file_mapped-accounting mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-race-in-file_mapped-accounting
+++ a/mm/memcontrol.c
@@ -1359,16 +1359,19 @@ void mem_cgroup_update_file_mapped(struc
 
 	lock_page_cgroup(pc);
 	mem = pc->mem_cgroup;
-	if (!mem)
-		goto done;
-
-	if (!PageCgroupUsed(pc))
+	if (!mem || !PageCgroupUsed(pc))
 		goto done;
 
 	/*
 	 * Preemption is already disabled. We can use __this_cpu_xxx
 	 */
-	__this_cpu_add(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED], val);
+	if (val > 0) {
+		__this_cpu_inc(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
+		SetPageCgroupFileMapped(pc);
+	} else {
+		__this_cpu_dec(mem->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
+		ClearPageCgroupFileMapped(pc);
+	}
 
 done:
 	unlock_page_cgroup(pc);
@@ -1801,16 +1804,13 @@ static void __mem_cgroup_commit_charge(s
 static void __mem_cgroup_move_account(struct page_cgroup *pc,
 	struct mem_cgroup *from, struct mem_cgroup *to, bool uncharge)
 {
-	struct page *page;
-
 	VM_BUG_ON(from == to);
 	VM_BUG_ON(PageLRU(pc->page));
 	VM_BUG_ON(!PageCgroupLocked(pc));
 	VM_BUG_ON(!PageCgroupUsed(pc));
 	VM_BUG_ON(pc->mem_cgroup != from);
 
-	page = pc->page;
-	if (page_mapped(page) && !PageAnon(page)) {
+	if (PageCgroupFileMapped(pc)) {
 		/* Update mapped_file data for mem_cgroup */
 		preempt_disable();
 		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
pagemap-fix-pfn-calculation-for-hugepage-v3.patch
memcg-fix-race-in-file_mapped-accounting.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-remove-return-value-of-putback_lru_pages.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-badness-heuristic-rewrite.patch
oom-deprecate-oom_adj-tunable.patch
oom-replace-sysctls-with-quick-mode.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-remove-unnecessary-code-and-cleanup.patch
oom-default-to-killing-current-for-pagefault-ooms.patch
oom-avoid-race-for-oom-killed-tasks-detaching-mm-prior-to-exit.patch
memcg-oom-wakeup-filter.patch
memcg-oom-wakeup-filter-update.patch
memcg-oom-notifier.patch
memcg-oom-notifier-update.patch
memcg-oom-kill-disable-and-oom-status.patch
memcg-oom-kill-disable-and-oom-status-update.patch
memcg-oom-kill-disable-and-oom-status-update-checkpatch-fixes.patch

