From: akpm@linux-foundation.org
Subject: - r-o-bind-mounts-drop-write-during-emergency-remount.patch removed from -mm tree
Date: Wed, 26 Mar 2008 11:40:18 -0700
Message-ID: <200803261840.m2QIeIXd028650@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49737 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759359AbYCZSqF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 26 Mar 2008 14:46:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: haveblue@us.ibm.com, hch@infradead.org, viro@ZenIV.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     r/o bind mounts: drop write during emergency remount
has been removed from the -mm tree.  Its filename was
     r-o-bind-mounts-drop-write-during-emergency-remount.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: r/o bind mounts: drop write during emergency remount
From: Dave Hansen <haveblue@us.ibm.com>

The emergency remount code forcibly removes FMODE_WRITE from filps.  The r/o
bind mount code notices that this was done without a proper mnt_drop_write()
and properly gives a warning.

This patch does a mnt_drop_write() to keep everything balanced.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/super.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff -puN fs/super.c~r-o-bind-mounts-drop-write-during-emergency-remount fs/super.c
--- a/fs/super.c~r-o-bind-mounts-drop-write-during-emergency-remount
+++ a/fs/super.c
@@ -37,6 +37,7 @@
 #include <linux/idr.h>
 #include <linux/kobject.h>
 #include <linux/mutex.h>
+#include <linux/file.h>
 #include <asm/uaccess.h>
 
 
@@ -567,10 +568,25 @@ static void mark_files_ro(struct super_b
 {
 	struct file *f;
 
+retry:
 	file_list_lock();
 	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
-		if (S_ISREG(f->f_path.dentry->d_inode->i_mode) && file_count(f))
-			f->f_mode &= ~FMODE_WRITE;
+		struct vfsmount *mnt;
+		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
+		       continue;
+		if (!file_count(f))
+			continue;
+		if (!(f->f_mode & FMODE_WRITE))
+			continue;
+		f->f_mode &= ~FMODE_WRITE;
+		mnt = f->f_path.mnt;
+		file_list_unlock();
+		/*
+		 * This can sleep, so we can't hold
+		 * the file_list_lock() spinlock.
+		 */
+		mnt_drop_write(mnt);
+		goto retry;
 	}
 	file_list_unlock();
 }
_

Patches currently in -mm which might be from haveblue@us.ibm.com are

git-vfs.patch
hugetlb-decrease-hugetlb_lock-cycling-in-gather_surplus_huge_pages.patch
mm-make-mem_map-allocation-continuous.patch
vfs-create-proc-pid-mountinfo.patch
vfs-mountinfo-mm-fix.patch
vfs-pnode-cleanup.patch
vfs-mountinfo-stable-peer-group-id.patch
vfs-mountinfo-show-dominating-group-id.patch
vfs-optimization-to-proc-pid-mountinfo-patch.patch
vfs-mountinfo-only-show-mounts-under-tasks-root.patch
kprobes-prevent-probing-of-preempt_schedule.patch
kprobes-prevent-probing-of-preempt_schedule-fix.patch
kprobes-prevent-probing-of-preempt_schedule-checkpatch-fixes.patch
reiser4.patch
page-owner-tracking-leak-detector.patch

