From: akpm@linux-foundation.org
Subject: - iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:36:40 -0800
Message-ID: <200802070336.m173aLAt014139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57861 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753081AbYBGDg6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:36:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, al@alarsen.net, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch

This patch was dropped because it was folded into iget-stop-qnx4-from-using-iget-and-read_inode-try.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: use tabs not spaces
#54: FILE: fs/qnx4/inode.c:398:
+ ^Iroot = qnx4_iget(s, QNX4_ROOT_INO * QNX4_INODES_PER_BLOCK);$

ERROR: use tabs not spaces
#55: FILE: fs/qnx4/inode.c:399:
+ ^Iif (IS_ERR(root)) {$

WARNING: line over 80 characters
#103: FILE: fs/qnx4/inode.c:485:
+		printk("qnx4: bad inode number on dev %s: %lu is out of range\n",

WARNING: printk() should include KERN_ facility level
#103: FILE: fs/qnx4/inode.c:485:
+		printk("qnx4: bad inode number on dev %s: %lu is out of range\n",

WARNING: printk() should include KERN_ facility level
#127: FILE: fs/qnx4/inode.c:528:
+		printk("qnx4: bad inode %lu on dev %s\n",ino,sb->s_id);

ERROR: need space after that ',' (ctx:VxV)
#127: FILE: fs/qnx4/inode.c:528:
+		printk("qnx4: bad inode %lu on dev %s\n",ino,sb->s_id);
 		                                        ^

ERROR: need space after that ',' (ctx:VxV)
#127: FILE: fs/qnx4/inode.c:528:
+		printk("qnx4: bad inode %lu on dev %s\n",ino,sb->s_id);
 		                                            ^

total: 4 errors, 3 warnings, 129 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Anders Larsen <al@alarsen.net>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/qnx4/inode.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff -puN fs/qnx4/inode.c~iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes fs/qnx4/inode.c
--- a/fs/qnx4/inode.c~iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes
+++ a/fs/qnx4/inode.c
@@ -395,8 +395,8 @@ static int qnx4_fill_super(struct super_
 	}
 
  	/* does root not have inode number QNX4_ROOT_INO ?? */
- 	root = qnx4_iget(s, QNX4_ROOT_INO * QNX4_INODES_PER_BLOCK);
- 	if (IS_ERR(root)) {
+	root = qnx4_iget(s, QNX4_ROOT_INO * QNX4_INODES_PER_BLOCK);
+	if (IS_ERR(root)) {
  		printk("qnx4: get inode failed\n");
 		ret = PTR_ERR(root);
  		goto out;
@@ -482,7 +482,8 @@ struct inode *qnx4_iget(struct super_blo
 
 	QNX4DEBUG(("Reading inode : [%d]\n", ino));
 	if (!ino) {
-		printk("qnx4: bad inode number on dev %s: %lu is out of range\n",
+		printk(KERN_ERR "qnx4: bad inode number on dev %s: %lu is "
+				"out of range\n",
 		       sb->s_id, ino);
 		iget_failed(inode);
 		return ERR_PTR(-EIO);
@@ -525,7 +526,8 @@ struct inode *qnx4_iget(struct super_blo
 		inode->i_mapping->a_ops = &qnx4_aops;
 		qnx4_i(inode)->mmu_private = inode->i_size;
 	} else {
-		printk("qnx4: bad inode %lu on dev %s\n",ino,sb->s_id);
+		printk(KERN_ERR "qnx4: bad inode %lu on dev %s\n",
+			ino, sb->s_id);
 		iget_failed(inode);
 		brelse(bh);
 		return ERR_PTR(-EIO);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
vfs-swap-do_ioctl-and-vfs_ioctl-names.patch
cgroup-simplify-space-stripping.patch
memory-controller-memory-accounting-v7.patch
memory-controller-add-per-container-lru-and-reclaim-v7.patch
memory-controller-oom-handling-v7.patch
memory-controller-add-switch-to-control-what-type-of-pages-to-limit-v7.patch
memcontrol-move-mm_cgroup-to-header-file.patch
memcontrol-move-oom-task-exclusion-to-tasklist.patch
memory-cgroup-enhancements-fix-zone-handling-in-try_to_free_mem_cgroup_page.patch
memory-cgroup-enhancements-add-status-accounting-function-for-memory-cgroup.patch
memory-cgroup-enhancements-add-memorystat-file.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-remember-reclaim-priority-in-memory-cgroup.patch
per-zone-and-reclaim-enhancements-for-memory-controller-take-3-modifies-vmscanc-for-isolate-globa-cgroup-lru-activity.patch
cgroups-mechanism-to-process-each-task-in-a-cgroup.patch
hotplug-cpu-move-tasks-in-empty-cpusets-to-parent.patch
cpusets-update_cpumask-revision.patch
drivers-edac-add-marvell-mv64x60-driver.patch
introduce-flags-for-reserve_bootmem.patch
iget-stop-affs-from-using-iget-and-read_inode-try.patch
iget-stop-efs-from-using-iget-and-read_inode-try.patch
iget-stop-ext2-from-using-iget-and-read_inode-try.patch
iget-stop-ext3-from-using-iget-and-read_inode-try.patch
iget-stop-freevxfs-from-using-iget-and-read_inode.patch
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
