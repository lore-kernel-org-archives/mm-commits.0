From: akpm@linux-foundation.org
Subject: - memcg-helper-function-for-relcaim-from-shmem.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:58:49 -0700
Message-ID: <200807252258.m6PMwnic003315@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789AbYGYW7m (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 18:59:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, ebiederm@xmission.com, hugh@veritas.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@val


The patch titled
     memcg: helper function for relcaim from shmem.
has been removed from the -mm tree.  Its filename was
     memcg-helper-function-for-relcaim-from-shmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: helper function for relcaim from shmem.
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

A new call, mem_cgroup_shrink_usage() is added for shmem handling and
relacing non-standard usage of mem_cgroup_charge/uncharge.

Now, shmem calls mem_cgroup_charge() just for reclaim some pages from
mem_cgroup.  In general, shmem is used by some process group and not for
global resource (like file caches).  So, it's reasonable to reclaim pages
from mem_cgroup where shmem is mainly used.

[hugh@veritas.com: shmem_getpage release page sooner]
[hugh@veritas.com: mem_cgroup_shrink_usage css_put]
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++++++
 mm/memcontrol.c            |   26 ++++++++++++++++++++++++++
 mm/shmem.c                 |   11 ++++-------
 3 files changed, 37 insertions(+), 7 deletions(-)

diff -puN include/linux/memcontrol.h~memcg-helper-function-for-relcaim-from-shmem include/linux/memcontrol.h
--- a/include/linux/memcontrol.h~memcg-helper-function-for-relcaim-from-shmem
+++ a/include/linux/memcontrol.h
@@ -37,6 +37,8 @@ extern int mem_cgroup_cache_charge(struc
 extern void mem_cgroup_uncharge_page(struct page *page);
 extern void mem_cgroup_uncharge_cache_page(struct page *page);
 extern void mem_cgroup_move_lists(struct page *page, bool active);
+extern int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask);
+
 extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
 					struct list_head *dst,
 					unsigned long *scanned, int order,
@@ -102,6 +104,11 @@ static inline void mem_cgroup_uncharge_c
 {
 }
 
+static inline int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
+{
+	return 0;
+}
+
 static inline void mem_cgroup_move_lists(struct page *page, bool active)
 {
 }
diff -puN mm/memcontrol.c~memcg-helper-function-for-relcaim-from-shmem mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-helper-function-for-relcaim-from-shmem
+++ a/mm/memcontrol.c
@@ -781,6 +781,32 @@ void mem_cgroup_end_migration(struct pag
 }
 
 /*
+ * A call to try to shrink memory usage under specified resource controller.
+ * This is typically used for page reclaiming for shmem for reducing side
+ * effect of page allocation from shmem, which is used by some mem_cgroup.
+ */
+int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
+{
+	struct mem_cgroup *mem;
+	int progress = 0;
+	int retry = MEM_CGROUP_RECLAIM_RETRIES;
+
+	rcu_read_lock();
+	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
+	css_get(&mem->css);
+	rcu_read_unlock();
+
+	do {
+		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask);
+	} while (!progress && --retry);
+
+	css_put(&mem->css);
+	if (!retry)
+		return -ENOMEM;
+	return 0;
+}
+
+/*
  * This routine traverse page_cgroup in given list and drop them all.
  * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
  */
diff -puN mm/shmem.c~memcg-helper-function-for-relcaim-from-shmem mm/shmem.c
--- a/mm/shmem.c~memcg-helper-function-for-relcaim-from-shmem
+++ a/mm/shmem.c
@@ -1315,17 +1315,14 @@ repeat:
 			shmem_swp_unmap(entry);
 			spin_unlock(&info->lock);
 			unlock_page(swappage);
+			page_cache_release(swappage);
 			if (error == -ENOMEM) {
 				/* allow reclaim from this memory cgroup */
-				error = mem_cgroup_cache_charge(swappage,
-					current->mm, gfp & ~__GFP_HIGHMEM);
-				if (error) {
-					page_cache_release(swappage);
+				error = mem_cgroup_shrink_usage(current->mm,
+								gfp);
+				if (error)
 					goto failed;
-				}
-				mem_cgroup_uncharge_cache_page(swappage);
 			}
-			page_cache_release(swappage);
 			goto repeat;
 		}
 	} else if (sgp == SGP_READ && !filepage) {
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
vmscan-second-chance-replacement-for-anonymous-pages-memcg-lru-scan-fix.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch

