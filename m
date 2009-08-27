From: akpm@linux-foundation.org
Subject: + oom-fix-oom_adjust_write-input-sanity-check.patch added to -mm tree
Date: Thu, 27 Aug 2009 14:27:49 -0700
Message-ID: <200908272127.n7RLRnHS014848@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753191AbZH0V2E (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 27 Aug 2009 17:28:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, menage@google.com, oleg@redhat.com, rientjes@google.com


The patch titled
     oom: fix oom_adjust_write() input sanity check
has been added to the -mm tree.  Its filename is
     oom-fix-oom_adjust_write-input-sanity-check.patch

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
Subject: oom: fix oom_adjust_write() input sanity check
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

Andrew Morton pointed out oom_adjust_write() has very strange EIO
and new line handling. this patch fixes it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/base.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff -puN fs/proc/base.c~oom-fix-oom_adjust_write-input-sanity-check fs/proc/base.c
--- a/fs/proc/base.c~oom-fix-oom_adjust_write-input-sanity-check
+++ a/fs/proc/base.c
@@ -1021,21 +1021,24 @@ static ssize_t oom_adjust_write(struct f
 				size_t count, loff_t *ppos)
 {
 	struct task_struct *task;
-	char buffer[PROC_NUMBUF], *end;
-	int oom_adjust;
+	char buffer[PROC_NUMBUF];
+	long oom_adjust;
 	unsigned long flags;
+	int err;
 
 	memset(buffer, 0, sizeof(buffer));
 	if (count > sizeof(buffer) - 1)
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
-	oom_adjust = simple_strtol(buffer, &end, 0);
+
+	err = strict_strtol(strstrip(buffer), 0, &oom_adjust);
+	if (err)
+		return -EINVAL;
 	if ((oom_adjust < OOM_ADJUST_MIN || oom_adjust > OOM_ADJUST_MAX) &&
 	     oom_adjust != OOM_DISABLE)
 		return -EINVAL;
-	if (*end == '\n')
-		end++;
+
 	task = get_proc_task(file->f_path.dentry->d_inode);
 	if (!task)
 		return -ESRCH;
@@ -1054,9 +1057,8 @@ static ssize_t oom_adjust_write(struct f
 
 	unlock_task_sighand(task, &flags);
 	put_task_struct(task);
-	if (end - buffer == 0)
-		return -EIO;
-	return end - buffer;
+
+	return count;
 }
 
 static const struct file_operations proc_oom_adjust_operations = {
_

Patches currently in -mm which might be from kosaki.motohiro@jp.fujitsu.com are

origin.patch
linux-next.patch
readahead-add-blk_run_backing_dev.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
mm-clean-up-page_remove_rmap.patch
mm-show_free_areas-display-slab-pages-in-two-separate-fields.patch
mm-oom-analysis-add-per-zone-statistics-to-show_free_areas.patch
mm-oom-analysis-add-buffer-cache-information-to-show_free_areas.patch
mm-oom-analysis-show-kernel-stack-usage-in-proc-meminfo-and-oom-log-output.patch
mm-oom-analysis-add-shmem-vmstat.patch
mm-rename-pgmoved-variable-in-shrink_active_list.patch
mm-shrink_inactive_list-nr_scan-accounting-fix-fix.patch
mm-vmstat-add-isolate-pages.patch
mm-vmstat-add-isolate-pages-fix.patch
vmscan-throttle-direct-reclaim-when-too-many-pages-are-isolated-already.patch
mm-remove-__addsub_zone_page_state.patch
mm-count-only-reclaimable-lru-pages-v2.patch
vmscan-dont-attempt-to-reclaim-anon-page-in-lumpy-reclaim-when-no-swap-space-is-avilable.patch
vmscan-move-clearpageactive-from-move_active_pages-to-shrink_active_list.patch
vmscan-kill-unnecessary-page-flag-test.patch
vmscan-kill-unnecessary-prefetch.patch
mm-perform-non-atomic-test-clear-of-pg_mlocked-on-free.patch
tracing-page-allocator-add-trace-events-for-page-allocation-and-page-freeing.patch
tracing-page-allocator-add-trace-event-for-page-traffic-related-to-the-buddy-lists.patch
mm-drop-unneeded-double-negations.patch
mm-introduce-page_lru_base_type.patch
mm-introduce-page_lru_base_type-fix.patch
mm-return-boolean-from-page_is_file_cache.patch
mm-return-boolean-from-page_has_private.patch
mm-document-is_page_cache_freeable.patch
mm-vmscan-rename-zone_nr_pages-to-zone_lru_nr_pages.patch
oom-move-oom_killer_enable-oom_killer_disable-to-where-they-belong.patch
mm-do-batched-scans-for-mem_cgroup.patch
mm-vmscan-remove-page_queue_congested-comment.patch
oom-move-oom_adj-value-from-task_struct-to-signal_struct.patch
oom-make-oom_score-to-per-process-value.patch
oom-oom_kill-doesnt-kill-vfork-parentor-child.patch
oom-fix-oom_adjust_write-input-sanity-check.patch
getrusage-fill-ru_maxrss-value.patch
getrusage-fill-ru_maxrss-value-update.patch
memory-controller-soft-limit-documentation-v9.patch
memory-controller-soft-limit-interface-v9.patch
memory-controller-soft-limit-organize-cgroups-v9.patch
memory-controller-soft-limit-organize-cgroups-v9-fix.patch
memory-controller-soft-limit-refactor-reclaim-flags-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memory-controller-soft-limit-reclaim-on-contention-v9-fix.patch
memcg-improve-resource-counter-scalability.patch
memcg-improve-resource-counter-scalability-v5.patch
fs-symlink-write_begin-allocation-context-fix-reiser4-fix.patch

