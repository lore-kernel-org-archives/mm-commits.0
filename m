From: akpm@linux-foundation.org
Subject: - iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:33:08 -0800
Message-ID: <200802070332.m173WndT014023@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51879 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759272AbYBGDdh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:33:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch

This patch was dropped because it was folded into iget-stop-affs-from-using-iget-and-read_inode-try.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: line over 80 characters
#31: FILE: fs/affs/affs.h:177:
+extern struct inode		*affs_iget(struct super_block *sb, unsigned long ino);

WARNING: line over 80 characters
#44: FILE: fs/affs/amigaffs.c:173:
+		dir = affs_iget(sb, be32_to_cpu(AFFS_TAIL(sb, link_bh)->parent));

ERROR: need space after that ',' (ctx:VxV)
#81: FILE: fs/affs/inode.c:36:
+	pr_debug("AFFS: affs_iget(%lu)\n",inode->i_ino);
 	                                 ^

total: 1 errors, 2 warnings, 130 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Howells <dhowells@redhat.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/affs.h  |    3 ++-
 fs/affs/inode.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/affs/affs.h~iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes fs/affs/affs.h
--- a/fs/affs/affs.h~iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes
+++ a/fs/affs/affs.h
@@ -174,7 +174,8 @@ extern void			 affs_put_inode(struct ino
 extern void			 affs_drop_inode(struct inode *inode);
 extern void			 affs_delete_inode(struct inode *inode);
 extern void			 affs_clear_inode(struct inode *inode);
-extern struct inode		*affs_iget(struct super_block *sb, unsigned long ino);
+extern struct inode		*affs_iget(struct super_block *sb,
+					unsigned long ino);
 extern int			 affs_write_inode(struct inode *inode, int);
 extern int			 affs_add_entry(struct inode *dir, struct inode *inode, struct dentry *dentry, s32 type);
 
diff -puN fs/affs/inode.c~iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes fs/affs/inode.c
--- a/fs/affs/inode.c~iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes
+++ a/fs/affs/inode.c
@@ -33,7 +33,7 @@ struct inode *affs_iget(struct super_blo
 	if (!(inode->i_state & I_NEW))
 		return inode;
 
-	pr_debug("AFFS: affs_iget(%lu)\n",inode->i_ino);
+	pr_debug("AFFS: affs_iget(%lu)\n", inode->i_ino);
 
 	block = inode->i_ino;
 	bh = affs_bread(sb, block);
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
iget-stop-affs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-efs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext2-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-ext3-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
