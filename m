From: akpm@linux-foundation.org
Subject: + vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch added to -mm tree
Date: Tue, 20 Jul 2010 21:03:49 -0700
Message-ID: <201007210403.o6L43qGb002771@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36386 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847Ab0GUEEg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Jul 2010 00:04:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, fengguang.wu@intel.com, heiko.carstens@de.ibm.com, viro@ZenIV.linux.org.uk


The patch titled
     vfs: introduce FMODE_UNSIGNED_OFFSET for allowing negative f_pos
has been added to the -mm tree.  Its filename is
     vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch

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
Subject: vfs: introduce FMODE_UNSIGNED_OFFSET for allowing negative f_pos
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, rw_verify_area() checsk f_pos is negative or not.  And if negative,
returns -EINVAL.

But, some special files as /dev/(k)mem and /proc/<pid>/mem etc..  has
negative offsets.  And we can't do any access via read/write to the
file(device).

So introduce FMODE_UNSIGNED_OFFSET to allow negative file offsets.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    4 ++++
 fs/proc/base.c     |    2 ++
 fs/read_write.c    |   21 +++++++++++++++++++--
 include/linux/fs.h |    3 +++
 4 files changed, 28 insertions(+), 2 deletions(-)

diff -puN drivers/char/mem.c~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos drivers/char/mem.c
--- a/drivers/char/mem.c~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos
+++ a/drivers/char/mem.c
@@ -873,6 +873,10 @@ static int memory_open(struct inode *ino
 	if (dev->dev_info)
 		filp->f_mapping->backing_dev_info = dev->dev_info;
 
+	/* Is /dev/mem or /dev/kmem ? */
+	if (dev->dev_info == &directly_mappable_cdev_bdi)
+		filp->f_mode |= FMODE_UNSIGNED_OFFSET;
+
 	if (dev->fops->open)
 		return dev->fops->open(inode, filp);
 
diff -puN fs/proc/base.c~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos fs/proc/base.c
--- a/fs/proc/base.c~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos
+++ a/fs/proc/base.c
@@ -773,6 +773,8 @@ static const struct file_operations proc
 static int mem_open(struct inode* inode, struct file* file)
 {
 	file->private_data = (void*)((long)current->self_exec_id);
+	/* OK to pass negative loff_t, we can catch out-of-range */
+	file->f_mode |= FMODE_UNSIGNED_OFFSET;
 	return 0;
 }
 
diff -puN fs/read_write.c~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos fs/read_write.c
--- a/fs/read_write.c~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos
+++ a/fs/read_write.c
@@ -222,6 +222,20 @@ bad:
 }
 #endif
 
+static int
+__negative_fpos_check(struct file *file, loff_t pos, size_t count)
+{
+	/*
+	 * pos or pos+count is negative here, check overflow.
+	 * too big "count" will be caught in rw_verify_area().
+	 */
+	if ((pos < 0) && (pos + count < pos))
+		return -EOVERFLOW;
+	if (file->f_mode & FMODE_UNSIGNED_OFFSET)
+		return 0;
+	return -EINVAL;
+}
+
 /*
  * rw_verify_area doesn't like huge counts. We limit
  * them to something that fits in "int" so that others
@@ -239,8 +253,11 @@ int rw_verify_area(int read_write, struc
 	if (unlikely((ssize_t) count < 0))
 		return retval;
 	pos = *ppos;
-	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
-		return retval;
+	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0)) {
+		retval = __negative_fpos_check(file, pos, count);
+		if (retval)
+			return retval;
+	}
 
 	if (unlikely(inode->i_flock && mandatory_lock(inode))) {
 		retval = locks_mandatory_area(
diff -puN include/linux/fs.h~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos include/linux/fs.h
--- a/include/linux/fs.h~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos
+++ a/include/linux/fs.h
@@ -90,6 +90,9 @@ struct inodes_stat_t {
 /* Expect random access pattern */
 #define FMODE_RANDOM		((__force fmode_t)0x1000)
 
+/* File is huge (eg. /dev/kmem): treat loff_t as unsigned */
+#define FMODE_UNSIGNED_OFFSET	((__force fmode_t)0x2000)
+
 /* File was opened by fanotify and shouldn't generate fanotify events */
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

origin.patch
ipc-semc-bugfix-for-semop-not-reporting-successful-operation.patch
linux-next.patch
percpu-online-cpu-before-memory-failed-in-pcpu_alloc_pages.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-rename-anon_vma_lock-to-vma_lock_anon_vma.patch
mm-change-direct-call-of-spin_lockanon_vma-lock-to-inline-function.patch
mm-track-the-root-oldest-anon_vma.patch
mm-always-lock-the-root-oldest-anon_vma.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root.patch
mm-extend-ksm-refcounts-to-the-anon_vma-root-fix.patch
oom-check-pf_kthread-instead-of-mm-to-skip-kthreads.patch
oom-give-current-access-to-memory-reserves-if-it-has-been-killed.patch
oom-avoid-sending-exiting-tasks-a-sigkill.patch
oom-filter-tasks-not-sharing-the-same-cpuset.patch
oom-sacrifice-child-with-highest-badness-score-for-parent.patch
oom-select-task-from-tasklist-for-mempolicy-ooms.patch
oom-enable-oom-tasklist-dump-by-default.patch
oom-avoid-oom-killer-for-lowmem-allocations.patch
oom-extract-panic-helper-function.patch
oom-remove-special-handling-for-pagefault-ooms.patch
oom-move-sysctl-declarations-to-oomh.patch
oom-remove-unnecessary-code-and-cleanup.patch
mm-rename-try_set_zone_oom-to-try_set_zonelist_oom.patch
oom-remove-constraint-argument-from-select_bad_process-and-__out_of_memory.patch
oom-fold-__out_of_memory-into-out_of_memory.patch
mm-use-for_each_online_cpu-in-vmstat.patch
mempolicy-reduce-stack-size-of-migrate_pages.patch
mempolicy-reduce-stack-size-of-migrate_pages-fix.patch
vmscan-tracing-add-trace-events-for-kswapd-wakeup-sleeping-and-direct-reclaim.patch
vmscan-tracing-add-trace-events-for-lru-page-isolation.patch
vmscan-tracing-add-trace-event-when-a-page-is-written.patch
vmscan-tracing-add-a-postprocessing-script-for-reclaim-related-ftrace-events.patch
vmscan-kill-prev_priority-completely.patch
vmscan-simplify-shrink_inactive_list.patch
vmscan-remove-unnecessary-temporary-vars-in-do_try_to_free_pages.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_inactive_list.patch
vmscan-set-up-pagevec-as-late-as-possible-in-shrink_page_list.patch
vmscan-update-isolated-page-counters-outside-of-main-path-in-shrink_inactive_list.patch
oom-dont-try-to-kill-oom_unkillable-child.patch
oom-oom_kill_process-doesnt-select-kthread-child.patch
oom-make-oom_unkillable_task-helper-function.patch
oom-oom_kill_process-needs-to-check-that-p-is-unkillable.patch
oom-proc-pid-oom_score-treat-kernel-thread-honestly.patch
oom-kill-duplicate-oom_disable-check.patch
oom-move-oom_disable-check-from-oom_kill_task-to-out_of_memory.patch
oom-cleanup-has_intersects_mems_allowed.patch
oom-remove-child-mm-check-from-oom_kill_process.patch
oom-give-the-dying-task-a-higher-priority.patch
oom-multi-threaded-process-coredump-dont-make-deadlock.patch
oom-move-badness-declaration-into-oomh.patch
oom-move-badness-declaration-into-oomh-fix.patch
cgroups-save-space-for-the-terminator.patch
memcg-remove-experimental-from-swap-account-config.patch
memcg-clean-up-try_charge-main-loop-v2.patch
memcg-clean-up-waiting-move-acct-v2.patch
memcg-clean-up-waiting-move-acct-v2-fix.patch
memcg-remove-redundant-codes.patch
memcg-remove-mem-from-arg-of-charge_common.patch
memcg-use-find_lock_task_mm-in-memory-cgroups-oom.patch
memcg-avoid-css_get.patch

