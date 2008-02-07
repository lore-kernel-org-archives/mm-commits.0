From: akpm@linux-foundation.org
Subject: - iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:37:12 -0800
Message-ID: <200802070336.m173ara6014145@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56989 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753246AbYBGDhl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:37:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch

This patch was dropped because it was folded into iget-stop-the-sysv-filesystem-from-using-iget-and.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: need space after that ',' (ctx:VxV)
#104: FILE: fs/sysv/super.c:335:
+	root_inode = sysv_iget(sb,SYSV_ROOT_INO);
 	                         ^

total: 1 errors, 0 warnings, 83 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/sysv/super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/sysv/super.c~iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes fs/sysv/super.c
--- a/fs/sysv/super.c~iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes
+++ a/fs/sysv/super.c
@@ -332,7 +332,7 @@ static int complete_read_super(struct su
 	sb->s_magic = SYSV_MAGIC_BASE + sbi->s_type;
 	/* set up enough so that it can read an inode */
 	sb->s_op = &sysv_sops;
-	root_inode = sysv_iget(sb,SYSV_ROOT_INO);
+	root_inode = sysv_iget(sb, SYSV_ROOT_INO);
 	if (IS_ERR(root_inode)) {
 		printk("SysV FS: get root inode failed\n");
 		return 0;
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
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-the-sysv-filesystem-from-using-iget-and.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
