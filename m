From: akpm@linux-foundation.org
Subject: + memcg-limit-change-shrink-usage.patch added to -mm tree
Date: Tue, 22 Jul 2008 01:45:50 -0700
Message-ID: <200807220845.m6M8joGQ019299@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752645AbYGVIqu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Jul 2008 04:46:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com, menage@google.com, xemul@openvz.org


The patch titled
     memcg: limit change shrink usage
has been added to the -mm tree.  Its filename is
     memcg-limit-change-shrink-usage.patch

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
Subject: memcg: limit change shrink usage
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Shrinking memory usage at limit change.

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
+        switch (cft->private) {
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

page-flags-record-page-flag-overlays-explicitly.patch
page-flags-record-page-flag-overlays-explicitly-xen.patch
memory-hotplugallocate-usemap-on-the-section-with-pgdat-take-4.patch
memory-hotplug-dont-calculate-vm_total_pages-twice-when-rebuilding-zonelists-in-online_pages.patch
memory-hotplug-add-sysfs-removable-attribute-for-hotplug-memory-remove.patch
mark-res_counter_charge_locked-with-__must_check.patch
cgroup-files-clean-up-whitespace-in-struct-cftype.patch
cgroup-files-add-write_string-cgroup-control-file-method.patch
cgroup-files-move-the-release_agent-file-to-use-typed-handlers.patch
cgroups-misc-cleanups-to-write_string-patchset.patch
cgroup-files-move-notify_on_release-file-to-separate-write-handler.patch
cgroup-files-turn-attach_task_by_pid-directly-into-a-cgroup-write-handler.patch
cgroup-files-remove-cpuset_common_file_write.patch
cgroup-files-convert-devcgroup_access_write-into-a-cgroup-write_string-handler.patch
cgroup-files-convert-res_counter_write-to-be-a-cgroups-write_string-handler.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-fix.patch
cgroup_clone-use-pid-of-newly-created-task-for-new-cgroup-checkpatch-fixes.patch
memcg-make-global-var-read_mostly.patch
memcg-avoid-unnecessary-initialization.patch
memcg-better-migration-handling.patch
memcg-remove-refcnt-from-page_cgroup.patch
memcg-remove-refcnt-from-page_cgroup-fix.patch
memcg-remove-refcnt-from-page_cgroup-fix-2.patch
memcg-remove-refcnt-from-page_cgroup-fix-memcg-fix-mem_cgroup_end_migration-race.patch
memcg-remove-refcnt-from-page_cgroup-memcg-fix-shmem_unuse_inode-charging.patch
memcg-helper-function-for-relcaim-from-shmem.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-shmem_getpage-release-page-sooner.patch
memcg-helper-function-for-relcaim-from-shmem-memcg-mem_cgroup_shrink_usage-css_put.patch
memcg-add-hints-for-branch.patch
memcg-remove-a-redundant-check.patch
memcg-clean-up-checking-of-the-disabled-flag.patch
memcg-clean-up-checking-of-the-disabled-flag-memcg-further-checking-of-disabled-flag.patch
res_counter-limit-change-support-ebusy.patch
memcg-limit-change-shrink-usage.patch
memcg-limit-change-shrink-usage-checkpatch-fixes.patch
memrlimit-add-memrlimit-controller-documentation.patch
memrlimit-setup-the-memrlimit-controller.patch
memrlimit-setup-the-memrlimit-controller-memrlimit-correct-mremap-and-move_vma-accounting.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-mmap_sem-deadlock.patch
memrlimit-cgroup-mm-owner-callback-changes-to-add-task-info-memrlimit-fix-sleep-inside-sleeplock-in-mm_update_next_owner.patch
memrlimit-add-memrlimit-controller-accounting-and-control.patch
memrlimit-add-memrlimit-controller-accounting-and-control-memrlimit-improve-fork-and-error-handling.patch
memrlimit-improve-error-handling.patch
memrlimit-improve-error-handling-update.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback.patch
memrlimit-handle-attach_task-failure-add-can_attach-callback-update.patch
mm-speculative-page-references-fix-migration_entry_wait-for-speculative-page-cache.patch
define-page_file_cache-function-fix-splitlru-shmem_getpage-setpageswapbacked-sooner.patch
vmscan-split-lru-lists-into-anon-file-sets-splitlru-memcg-swapbacked-pages-active.patch
vmscan-second-chance-replacement-for-anonymous-pages-fix.patch
unevictable-lru-infrastructure-putback_lru_page-unevictable-page-handling-rework.patch
mlock-mlocked-pages-are-unevictable-fix-truncate-race-and-sevaral-comments.patch
fix-double-unlock_page-in-2626-rc5-mm3-kernel-bug-at-mm-filemapc-575.patch
restore-patch-failure-of-vmstat-unevictable-and-mlocked-pages-vm-eventspatch.patch

