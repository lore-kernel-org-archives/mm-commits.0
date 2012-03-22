From: akpm@linux-foundation.org
Subject: [merged] memcg-fix-performance-of-mem_cgroup_begin_update_page_stat.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:20:01 -0700
Message-ID: <20120322202002.46F3FA024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:34424 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759498Ab2CVUUI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:20:08 -0400
Received: by mail-yw0-f74.google.com with SMTP id m50so403323yhg.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:20:07 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, gthelen@google.com, hannes@cmpxchg.org, kosaki.motohiro@jp.fujitsu.com, mhocko@suse.cz, yinghan@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: fix performance of mem_cgroup_begin_update_page_stat()
has been removed from the -mm tree.  Its filename was
     memcg-fix-performance-of-mem_cgroup_begin_update_page_stat.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: memcg: fix performance of mem_cgroup_begin_update_page_stat()

mem_cgroup_begin_update_page_stat() should be very fast because it's
called very frequently.  Now, it needs to look up page_cgroup and its
memcg....this is slow.

This patch adds a global variable to check "any memcg is moving or not". 
With this, the caller doesn't need to visit page_cgroup and memcg.

Here is a test result.  A test program makes page faults onto a file,
MAP_SHARED and makes each page's page_mapcount(page) > 1, and free the
range by madvise() and page fault again.  This program causes 26214400
times of page fault onto a file(size was 1G.) and shows shows the cost of
mem_cgroup_begin_update_page_stat().

Before this patch for mem_cgroup_begin_update_page_stat()
[kamezawa@bluextal test]$ time ./mmap 1G

real    0m21.765s
user    0m5.999s
sys     0m15.434s

    27.46%     mmap  mmap               [.] reader
    21.15%     mmap  [kernel.kallsyms]  [k] page_fault
     9.17%     mmap  [kernel.kallsyms]  [k] filemap_fault
     2.96%     mmap  [kernel.kallsyms]  [k] __do_fault
     2.83%     mmap  [kernel.kallsyms]  [k] __mem_cgroup_begin_update_page_stat

After this patch
[root@bluextal test]# time ./mmap 1G

real    0m21.373s
user    0m6.113s
sys     0m15.016s

In usual path, calls to __mem_cgroup_begin_update_page_stat() goes away.

Note: we may be able to remove this optimization in future if
      we can get pointer to memcg directly from struct page.

[akpm@linux-foundation.org: don't return a void]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Acked-by: Greg Thelen <gthelen@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 ++++-
 mm/memcontrol.c            |    9 ++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-fix-performance-of-mem_cgroup_begin_update_page_stat include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-fix-performance-of-mem_cgroup_begin_update_page_stat
+++ a/include/linux/memcontrol.h
@@ -144,6 +144,8 @@ static inline bool mem_cgroup_disabled(v
 void __mem_cgroup_begin_update_page_stat(struct page *page, bool *locked,
 					 unsigned long *flags);
 
+extern atomic_t memcg_moving;
+
 static inline void mem_cgroup_begin_update_page_stat(struct page *page,
 					bool *locked, unsigned long *flags)
 {
@@ -151,7 +153,8 @@ static inline void mem_cgroup_begin_upda
 		return;
 	rcu_read_lock();
 	*locked = false;
-	return __mem_cgroup_begin_update_page_stat(page, locked, flags);
+	if (atomic_read(&memcg_moving))
+		__mem_cgroup_begin_update_page_stat(page, locked, flags);
 }
 
 void __mem_cgroup_end_update_page_stat(struct page *page,
diff -puN mm/memcontrol.c~memcg-fix-performance-of-mem_cgroup_begin_update_page_stat mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-fix-performance-of-mem_cgroup_begin_update_page_stat
+++ a/mm/memcontrol.c
@@ -1306,8 +1306,13 @@ int mem_cgroup_swappiness(struct mem_cgr
  *                                              rcu_read_unlock()
  *         start move here.
  */
+
+/* for quick checking without looking up memcg */
+atomic_t memcg_moving __read_mostly;
+
 static void mem_cgroup_start_move(struct mem_cgroup *memcg)
 {
+	atomic_inc(&memcg_moving);
 	atomic_inc(&memcg->moving_account);
 	synchronize_rcu();
 }
@@ -1318,8 +1323,10 @@ static void mem_cgroup_end_move(struct m
 	 * Now, mem_cgroup_clear_mc() may call this function with NULL.
 	 * We check NULL in callee rather than caller.
 	 */
-	if (memcg)
+	if (memcg) {
+		atomic_dec(&memcg_moving);
 		atomic_dec(&memcg->moving_account);
+	}
 }
 
 /*
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

