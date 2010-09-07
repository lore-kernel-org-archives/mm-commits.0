From: akpm@linux-foundation.org
Subject: + vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos-fix.patch added to -mm tree
Date: Tue, 07 Sep 2010 14:12:57 -0700
Message-ID: <201009072112.o87LCvE8006416@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42645 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752440Ab0IGVNG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Sep 2010 17:13:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: kamezawa.hiroyu@jp.fujitsu.com, fengguang.wu@intel.com, heiko.carstens@de.ibm.com, viro@ZenIV.linux.org.uk


The patch titled
     vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos-fix
has been added to the -mm tree.  Its filename is
     vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos-fix.patch

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
Subject: vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos-fix
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch adds
"UNSIGINED" fpos support.  But it dones't handle llseek.  Fix it.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/read_write.c |   33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff -puN fs/read_write.c~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos-fix fs/read_write.c
--- a/fs/read_write.c~vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos-fix
+++ a/fs/read_write.c
@@ -31,6 +31,20 @@ const struct file_operations generic_ro_
 
 EXPORT_SYMBOL(generic_ro_fops);
 
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
 /**
  * generic_file_llseek_unlocked - lockless generic llseek implementation
  * @file:	file structure to seek on
@@ -62,7 +76,9 @@ generic_file_llseek_unlocked(struct file
 		break;
 	}
 
-	if (offset < 0 || offset > inode->i_sb->s_maxbytes)
+	if (offset < 0 && __negative_fpos_check(file, offset, 0))
+		return -EINVAL;
+	if (offset > inode->i_sb->s_maxbytes)
 		return -EINVAL;
 
 	/* Special lock needed here? */
@@ -137,7 +153,7 @@ loff_t default_llseek(struct file *file,
 			offset += file->f_pos;
 	}
 	retval = -EINVAL;
-	if (offset >= 0) {
+	if (offset >= 0 || !__negative_fpos_check(file, offset, 0)) {
 		if (offset != file->f_pos) {
 			file->f_pos = offset;
 			file->f_version = 0;
@@ -222,19 +238,6 @@ bad:
 }
 #endif
 
-static int
-__negative_fpos_check(struct file *file, loff_t pos, size_t count)
-{
-	/*
-	 * pos or pos+count is negative here, check overflow.
-	 * too big "count" will be caught in rw_verify_area().
-	 */
-	if ((pos < 0) && (pos + count < pos))
-		return -EOVERFLOW;
-	if (file->f_mode & FMODE_UNSIGNED_OFFSET)
-		return 0;
-	return -EINVAL;
-}
 
 /*
  * rw_verify_area doesn't like huge counts. We limit
_

Patches currently in -mm which might be from kamezawa.hiroyu@jp.fujitsu.com are

linux-next.patch
memory-hotplug-fix-next-block-calculation-in-is_removable.patch
swap-revert-special-hibernation-allocation.patch
swap-prevent-reuse-during-hibernation.patch
vmstat-update-zone-stat-threshold-when-onlining-a-cpu.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list.patch
mm-page-allocator-update-free-page-counters-after-pages-are-placed-on-the-free-list-fix.patch
mm-page-allocator-drain-per-cpu-lists-after-direct-reclaim-allocation-fails.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos.patch
vfs-introduce-fmode_neg_offset-for-allowing-negative-f_pos-fix.patch
vmscan-do-not-writeback-filesystem-pages-in-direct-reclaim.patch
vmscan-kick-flusher-threads-to-clean-pages-when-reclaim-is-encountering-dirty-pages.patch
oom-add-per-mm-oom-disable-count.patch
oom-avoid-killing-a-task-if-a-thread-sharing-its-mm-cannot-be-killed.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix.patch
oom-kill-all-threads-sharing-oom-killed-tasks-mm-fix-fix.patch
oom-rewrite-error-handling-for-oom_adj-and-oom_score_adj-tunables.patch
oom-fix-locking-for-oom_adj-and-oom_score_adj.patch
memory-hotplug-fix-notifiers-return-value-check.patch
memory-hotplug-unify-is_removable-and-offline-detection-code.patch
memory-hotplug-unify-is_removable-and-offline-detection-code-checkpatch-fixes.patch

