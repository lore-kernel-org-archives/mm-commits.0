From: akpm@linux-foundation.org
Subject: - iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:36:55 -0800
Message-ID: <200802070336.m173aahM014142@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48931 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753123AbYBGDhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:37:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch

This patch was dropped because it was folded into iget-stop-romfs-from-using-iget-and-read_inode.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: printk() should include KERN_ facility level
#116: FILE: fs/romfs/inode.c:508:
+			printk("romfs: read error for inode 0x%lx\n", ino);

total: 0 errors, 1 warnings, 109 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/romfs/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN fs/romfs/inode.c~iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes fs/romfs/inode.c
--- a/fs/romfs/inode.c~iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes
+++ a/fs/romfs/inode.c
@@ -505,7 +505,8 @@ romfs_iget(struct super_block *sb, unsig
 	/* Loop for finding the real hard link */
 	for(;;) {
 		if (romfs_copyfrom(i, &ri, ino, ROMFH_SIZE) <= 0) {
-			printk("romfs: read error for inode 0x%lx\n", ino);
+			printk(KERN_ERR "romfs: read error for inode 0x%lx\n",
+				ino);
 			iget_failed(i);
 			return ERR_PTR(-EIO);
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
iget-stop-the-minix-filesystem-from-using-iget-and.patch
iget-stop-procfs-from-using-iget-and-read_inode.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try.patch
iget-stop-romfs-from-using-iget-and-read_inode.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
