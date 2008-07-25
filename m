From: akpm@linux-foundation.org
Subject: - memcg-limit-change-shrink-usage.patch removed from -mm tree
Date: Fri, 25 Jul 2008 15:59:02 -0700
Message-ID: <200807252259.m6PMx2VS003344@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37033 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754084AbYGYXFJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 19:05:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, menage@google.com, xemul@openvz.org, mm-commits@vger.kernel.org


The patch titled
     memcg: limit change shrink usage
has been removed from the -mm tree.  Its filename was
     memcg-limit-change-shrink-usage.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: memcg: limit change shrink usage
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Shrinking memory usage at limit change.

[akpm@linux-foundation.org: coding-style fixes]
Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Acked-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/controllers/memory.txt |    3 -
 mm/memcontrol.c                      |   48 ++++++++++++++++++++++---
 2 files changed, 45 insertions(+), 6 deletions(-)

diff -puN Documentation/controllers/memory.txt~memcg-limit-change-shrink-usage Documentation/controllers/memory.txt
--- a/Documentation/controllers/memory.txt~memcg-limit-change-shrink-usage
+++ a/Documentation/controllers/memory.txt
@@ -242,8 +242,7 @@ rmdir() if there are no tasks.
 1. Add support for accounting huge pages (as a separate controller)
 2. Make per-cgroup scanner reclaim not-shared pages first
 3. Teach controller to account for shared-pages
-4. Start reclamation when the limit is lowered
-5. Start reclamation in the background when the limit is
+4. Start reclamation in the background when the limit is
    not yet hit but the usage is getting closer
 
 Summary
diff -puN mm/memcontrol.c~memcg-limit-change-shrink-usage mm/memcontrol.c
--- a/mm/memcontrol.c~memcg-limit-change-shrink-usage
+++ a/mm/memcontrol.c
@@ -812,6 +812,30 @@ int mem_cgroup_shrink_usage(struct mm_st
 	return 0;
 }
 
+int mem_cgroup_resize_limit(struct mem_cgroup *memcg, unsigned long long val)
+{
+
+	int retry_count = MEM_CGROUP_RECLAIM_RETRIES;
+	int progress;
+	int ret = 0;
+
+	while (res_counter_set_limit(&memcg->res, val)) {
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+		if (!retry_count) {
+			ret = -EBUSY;
+			break;
+		}
+		progress = try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL);
+		if (!progress)
+			retry_count--;
+	}
+	return ret;
+}
+
+
 /*
  * This routine traverse page_cgroup in given list and drop them all.
  * *And* this routine doesn't reclaim page itself, just removes page_cgroup.
@@ -896,13 +920,29 @@ static u64 mem_cgroup_read(struct cgroup
 	return res_counter_read_u64(&mem_cgroup_from_cont(cont)->res,
 				    cft->private);
 }
-
+/*
+ * The user of this function is...
+ * RES_LIMIT.
+ */
 static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
 			    const char *buffer)
 {
-	return res_counter_write(&mem_cgroup_from_cont(cont)->res,
-				 cft->private, buffer,
-				 res_counter_memparse_write_strategy);
+	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
+	unsigned long long val;
+	int ret;
+
+	switch (cft->private) {
+	case RES_LIMIT:
+		/* This function does all necessary parse...reuse it */
+		ret = res_counter_memparse_write_strategy(buffer, &val);
+		if (!ret)
+			ret = mem_cgroup_resize_limit(memcg, val);
+		break;
+	default:
+		ret = -EINVAL; /* should be BUG() ? */
+		break;
+	}
+	return ret;
 }
 
 static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
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

