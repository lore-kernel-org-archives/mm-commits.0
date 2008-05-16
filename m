From: akpm@linux-foundation.org
Subject: + memcg-helper-function-for-relcaim-from-shmem.patch added to -mm tree
Date: Thu, 15 May 2008 19:53:22 -0700
Message-ID: <200805160253.m4G2rMbZ023238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46689 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751645AbYEPCyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 May 2008 22:54:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@in.ibm.com, ebiederm@xmission.com, hugh@veritas.com, lizf@cn.fujitsu.com, menage@google.com, rientjes@google.com, xemul@openvz.org, yamamoto@valinux.co.jp


The patch titled
     memcg: helper function for relcaim from shmem.
has been added to the -mm tree.  Its filename is
     memcg-helper-function-for-relcaim-from-shmem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    7 +++++++
 mm/memcontrol.c            |   25 +++++++++++++++++++++++++
 mm/shmem.c                 |    5 ++---
 3 files changed, 34 insertions(+), 3 deletions(-)

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
@@ -770,6 +770,31 @@ void mem_cgroup_end_migration(struct pag
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
@@ -1321,13 +1321,12 @@ repeat:
 			unlock_page(swappage);
 			if (error == -ENOMEM) {
 				/* allow reclaim from this memory cgroup */
-				error = mem_cgroup_cache_charge(swappage,
-					current->mm, gfp & ~__GFP_HIGHMEM);
+				error = mem_cgroup_shrink_usage(current->mm,
+					gfp & ~__GFP_HIGHMEM);
 				if (error) {
 					page_cache_release(swappage);
 					goto failed;
 				}
-				mem_cgroup_uncharge_cache_page(swappage);
 			}
 			page_cache_release(swappage);
 			goto repeat;
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
memory-hotplug-memmap_init_zone-called-twice.patch
memory_hotplug-check-for-walk_memory_resource-failure-in-online_pages.patch
memory_hotplug-always-initialize-pageblock-bitmap.patch
mark-res_counter_charge_locked-with-__must_check.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-handle-swap-cache.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch

