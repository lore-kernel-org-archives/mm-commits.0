From: akpm@linux-foundation.org
Subject: - iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:35:06 -0800
Message-ID: <200802070334.m173YlkA014090@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58890 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbYBGDfi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:35:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, hch@lst.de, mm-commits@vger.kernel.org


The patch titled
     iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch

This patch was dropped because it was folded into iget-stop-freevxfs-from-using-iget-and-read_inode.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#30: FILE: fs/freevxfs/vxfs_extern.h:61:
+extern struct inode *		vxfs_iget(struct super_block *, unsigned long);

ERROR: use tabs not spaces
#68: FILE: fs/freevxfs/vxfs_inode.c:183:
+        vip = __vxfs_iget(ino, VXFS_SBI(sbp)->vsi_stilist);$

total: 2 errors, 0 warnings, 139 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Christoph Hellwig <hch@lst.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/freevxfs/vxfs_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/freevxfs/vxfs_inode.c~iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes fs/freevxfs/vxfs_inode.c
--- a/fs/freevxfs/vxfs_inode.c~iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes
+++ a/fs/freevxfs/vxfs_inode.c
@@ -180,7 +180,7 @@ vxfs_stiget(struct super_block *sbp, ino
 {
 	struct vxfs_inode_info *vip;
 
-        vip = __vxfs_iget(ino, VXFS_SBI(sbp)->vsi_stilist);
+	vip = __vxfs_iget(ino, VXFS_SBI(sbp)->vsi_stilist);
 	return IS_ERR(vip) ? NULL : vip;
 }
 
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
iget-stop-freevxfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
