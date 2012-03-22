From: akpm@linux-foundation.org
Subject: [merged] memcg-remove-pcg_file_mapped.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:19:59 -0700
Message-ID: <20120322201959.77A3CA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:39689 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759445Ab2CVUUA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:20:00 -0400
Received: by mail-qa0-f74.google.com with SMTP id g24so62245qab.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:20:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: remove PCG_FILE_MAPPED
has been removed from the -mm tree.  Its filename was
     memcg-remove-pcg_file_mapped.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: remove PCG_FILE_MAPPED

With the new lock scheme for updating memcg's page stat, we don't need a
flag PCG_FILE_MAPPED which was duplicated information of page_mapped().

[hughd@google.com: cosmetic fix]
[hughd@google.com: add comment to MEM_CGROUP_CHARGE_TYPE_MAPPED case in __mem_cgroup_uncharge_common()]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Greg Thelen <gthelen@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/page_cgroup.h |    6 ------
 mm/memcontrol.c             |   11 ++++++-----
 2 files changed, 6 insertions(+), 11 deletions(-)

diff -puN include/linux/page_cgroup.h~memcg-remove-pcg_file_mapped include/linux/page_cgroup.h
--- a/include/linux/page_cgroup.h~memcg-remove-pcg_file_mapped
+++ a/include/linux/page_cgroup.h
@@ -6,8 +6,6 @@ enum {
 	PCG_LOCK,  /* Lock for pc->mem_cgroup and following bits. */
 	PCG_USED, /* this object is in use. */
 	PCG_MIGRATION, /* under page migration */
-	/* flags for mem_cgroup and file and I/O status */
-	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
 	__NR_PCG_FLAGS,
 };
 
@@ -66,10 +64,6 @@ TESTPCGFLAG(Used, USED)
 CLEARPCGFLAG(Used, USED)
 SETPCGFLAG(Used, USED)
 
-SETPCGFLAG(FileMapped, FILE_MAPPED)
-CLEARPCGFLAG(FileMapped, FILE_MAPPED)
-TESTPCGFLAG(FileMapped, FILE_MAPPED)
-
 SETPCGFLAG(Migration, MIGRATION)
 CLEARPCGFLAG(Migration, MIGRATION)
 TESTPCGFLAG(Migration, MIGRATION)
diff -puN mm/memcontrol.c~memcg-remove-pcg_file_mapped mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-remove-pcg_file_mapped
+++ a/mm/memcontrol.c
@@ -1966,10 +1966,6 @@ void mem_cgroup_update_page_stat(struct 
 
 	switch (idx) {
 	case MEMCG_NR_FILE_MAPPED:
-		if (val > 0)
-			SetPageCgroupFileMapped(pc);
-		else if (!page_mapped(page))
-			ClearPageCgroupFileMapped(pc);
 		idx = MEM_CGROUP_STAT_FILE_MAPPED;
 		break;
 	default:
@@ -2617,7 +2613,7 @@ static int mem_cgroup_move_account(struc
 
 	move_lock_mem_cgroup(from, &flags);
 
-	if (PageCgroupFileMapped(pc)) {
+	if (!anon && page_mapped(page)) {
 		/* Update mapped_file data for mem_cgroup */
 		preempt_disable();
 		__this_cpu_dec(from->stat->count[MEM_CGROUP_STAT_FILE_MAPPED]);
@@ -2982,6 +2978,11 @@ __mem_cgroup_uncharge_common(struct page
 
 	switch (ctype) {
 	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
+		/*
+		 * Generally PageAnon tells if it's the anon statistics to be
+		 * updated; but sometimes e.g. mem_cgroup_uncharge_page() is
+		 * used before page reached the stage of being marked PageAnon.
+		 */
 		anon = true;
 		/* fallthrough */
 	case MEM_CGROUP_CHARGE_TYPE_DROP:
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
linux-next.patch
mm-hugetlb-cleanup-duplicated-code-in-unmapping-vm-range.patch
proc-speedup-proc-stat-handling.patch
procfs-add-num_to_str-to-speed-up-proc-stat.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix.patch
procfs-add-num_to_str-to-speed-up-proc-stat-fix-2.patch
procfs-speed-up-proc-pid-stat-statm.patch
procfs-speed-up-proc-pid-stat-statm-checkpatch-fixes.patch
seq_file-add-seq_set_overflow-seq_overflow.patch
seq_file-add-seq_set_overflow-seq_overflow-fix.patch
fs-proc-introduce-proc-pid-task-tid-children-entry-v9.patch
c-r-procfs-add-arg_start-end-env_start-end-and-exit_code-members-to-proc-pid-stat.patch
c-r-prctl-extend-pr_set_mm-to-set-up-more-mm_struct-entries-v2.patch

