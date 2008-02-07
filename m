From: akpm@linux-foundation.org
Subject: - iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 06 Feb 2008 19:36:10 -0800
Message-ID: <200802070335.m173ZqBC014122@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47322 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800AbYBGDgZ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Feb 2008 22:36:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch

This patch was dropped because it was folded into iget-stop-the-minix-filesystem-from-using-iget-and.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: "foo * bar" should be "foo *bar"
#85: FILE: fs/minix/inode.c:415:
+static struct inode *V1_minix_iget(struct inode * inode)

ERROR: "foo * bar" should be "foo *bar"
#112: FILE: fs/minix/inode.c:448:
+static struct inode *V2_minix_iget(struct inode * inode)

ERROR: use tabs not spaces
#181: FILE: fs/minix/namei.c:58:
+ ^I^Iif (IS_ERR(inode))$

total: 3 errors, 0 warnings, 144 lines checked
Your patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/minix/inode.c |    4 ++--
 fs/minix/namei.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/minix/inode.c~iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes fs/minix/inode.c
--- a/fs/minix/inode.c~iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes
+++ a/fs/minix/inode.c
@@ -412,7 +412,7 @@ void minix_set_inode(struct inode *inode
 /*
  * The minix V1 function to read an inode.
  */
-static struct inode *V1_minix_iget(struct inode * inode)
+static struct inode *V1_minix_iget(struct inode *inode)
 {
 	struct buffer_head * bh;
 	struct minix_inode * raw_inode;
@@ -445,7 +445,7 @@ static struct inode *V1_minix_iget(struc
 /*
  * The minix V2 function to read an inode.
  */
-static struct inode *V2_minix_iget(struct inode * inode)
+static struct inode *V2_minix_iget(struct inode *inode)
 {
 	struct buffer_head * bh;
 	struct minix2_inode * raw_inode;
diff -puN fs/minix/namei.c~iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes fs/minix/namei.c
--- a/fs/minix/namei.c~iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes
+++ a/fs/minix/namei.c
@@ -55,7 +55,7 @@ static struct dentry *minix_lookup(struc
 	ino = minix_inode_by_name(dentry);
 	if (ino) {
 		inode = minix_iget(dir->i_sb, ino);
- 		if (IS_ERR(inode))
+		if (IS_ERR(inode))
 			return ERR_CAST(inode);
 	}
 	d_add(dentry, inode);
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
iget-stop-the-minix-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-procfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-qnx4-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-romfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
iget-stop-the-sysv-filesystem-from-using-iget-and-checkpatch-fixes.patch
iget-stop-ufs-from-using-iget-and-read_inode-try-checkpatch-fixes.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
