From: akpm@linux-foundation.org
Subject: + vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch added to -mm tree
Date: Mon, 08 Feb 2010 14:56:18 -0800
Message-ID: <201002082256.o18MuITa008323@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52623 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752153Ab0BHW42 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Feb 2010 17:56:28 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, fengguang.wu@intel.com, heiko.carstens@de.ibm.com, viro@ZenIV.linux.org.uk


The patch titled
     vfs: introduce FMODE_NEG_OFFSET for allowing negative f_pos
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
Subject: vfs: introduce FMODE_NEG_OFFSET for allowing negative f_pos
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Now, rw_verify_area() checsk f_pos is negative or not.  And if negative,
returns -EINVAL.

But, some special files as /dev/(k)mem and /proc/<pid>/mem etc..  has
negative offsets.  And we can't do any access via read/write to the
file(device).

So introduce FMODE_NEG_OFFSET to allow negative file offsets.

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
@@ -869,6 +869,10 @@ static int memory_open(struct inode *ino
 	if (dev->dev_info)
 		filp->f_mapping->backing_dev_info = dev->dev_info;
 
+	/* Is /dev/mem or /dev/kmem ? */
+	if (dev->dev_info == &directly_mappable_cdev_bdi)
+		filp->f_mode |= FMODE_NEG_OFFSET;
+
 	if (dev->fops->open)
 		return dev->fops->open(inode, filp);
 
diff -puN fs/proc/base.c~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos fs/proc/base.c
--- a/fs/proc/base.c~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos
+++ a/fs/proc/base.c
@@ -855,6 +855,8 @@ static const struct file_operations proc
 static int mem_open(struct inode* inode, struct file* file)
 {
 	file->private_data = (void*)((long)current->self_exec_id);
+	/* OK to pass negative loff_t, we can catch out-of-range */
+	file->f_mode |= FMODE_NEG_OFFSET;
 	return 0;
 }
 
diff -puN fs/read_write.c~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos fs/read_write.c
--- a/fs/read_write.c~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos
+++ a/fs/read_write.c
@@ -205,6 +205,20 @@ bad:
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
+	if (file->f_mode & FMODE_NEG_OFFSET)
+		return 0;
+	return -EINVAL;
+}
+
 /*
  * rw_verify_area doesn't like huge counts. We limit
  * them to something that fits in "int" so that others
@@ -222,8 +236,11 @@ int rw_verify_area(int read_write, struc
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
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x1000000)
 
+/* File is huge (eg. /dev/kmem): treat loff_t as unsigned */
+#define FMODE_NEG_OFFSET	((__force fmode_t)0x2000)
+
 /*
  * The below are the various read and write types that we support. Some of
  * them include behavioral modifiers that send information down to the
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
mm-clean-up-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-get_scan_ratio-cleanup.patch
mm-restore-zone-all_unreclaimable-to-independence-word.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix-2.patch
mm-migratec-kill-anon-local-variable-from-migrate_page_copy.patch
nodemaskh-remove-macro-any_online_node.patch
cgroup-introduce-cancel_attach.patch
cgroup-introduce-coalesce-css_get-and-css_put.patch
cgroups-revamp-subsys-array.patch
cgroups-subsystem-module-loading-interface.patch
cgroups-subsystem-module-loading-interface-fix.patch
cgroups-subsystem-module-unloading.patch
cgroups-net_cls-as-module.patch
cgroups-blkio-subsystem-as-module.patch
cgroups-clean-up-cgroup_pidlist_find-a-bit.patch
memcg-add-interface-to-move-charge-at-task-migration.patch
memcg-move-charges-of-anonymous-page.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-improve-performance-in-moving-charge.patch
memcg-avoid-oom-during-moving-charge.patch
memcg-move-charges-of-anonymous-swap.patch
memcg-move-charges-of-anonymous-swap-fix.patch
memcg-improve-performance-in-moving-swap-charge.patch
memcg-improve-performance-in-moving-swap-charge-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-kconfig-fix.patch
cgroup-implement-eventfd-based-generic-api-for-notifications-fixes.patch
memcg-extract-mem_group_usage-from-mem_cgroup_read.patch
memcg-rework-usage-of-stats-by-soft-limit.patch
memcg-implement-memory-thresholds.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
memcg-implement-memory-thresholds-checkpatch-fixes-fix.patch
memcg-typo-in-comment-to-mem_cgroup_print_oom_info.patch
memcg-use-generic-percpu-instead-of-private-implementation.patch
sysctl-clean-up-vm-related-variable-declarations.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
devmem-dont-allow-seek-to-last-page.patch

