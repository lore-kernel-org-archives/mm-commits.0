From: akpm@linux-foundation.org
Subject: [merged] fs-nfs-remove-unnecessary-new_valid_dev-check.patch
 removed from -mm tree
Date: Wed, 04 Nov 2015 14:44:53 -0800
Message-ID: <563a8a65.o0DpDW6cXI8w22EI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46032 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031007AbbKDWoy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 4 Nov 2015 17:44:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, anna.schumaker@netapp.com, trond.myklebust@primarydata.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/nfs/dir.c: remove unnecessary new_valid_dev() check
has been removed from the -mm tree.  Its filename was
     fs-nfs-remove-unnecessary-new_valid_dev-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: fs/nfs/dir.c: remove unnecessary new_valid_dev() check

new_valid_dev() always returns 1, so the !new_valid_dev() check is not
needed.  Remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Anna Schumaker <anna.schumaker@netapp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/dir.c |    3 ---
 1 file changed, 3 deletions(-)

diff -puN fs/nfs/dir.c~fs-nfs-remove-unnecessary-new_valid_dev-check fs/nfs/dir.c
--- a/fs/nfs/dir.c~fs-nfs-remove-unnecessary-new_valid_dev-check
+++ a/fs/nfs/dir.c
@@ -1714,9 +1714,6 @@ nfs_mknod(struct inode *dir, struct dent
 	dfprintk(VFS, "NFS: mknod(%s/%lu), %pd\n",
 			dir->i_sb->s_id, dir->i_ino, dentry);
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
-
 	attr.ia_mode = mode;
 	attr.ia_valid = ATTR_MODE;
 
_

Patches currently in -mm which might be from bywxiaobai@163.com are

kernel-watchdog-is_hardlockup-can-be-boolean.patch
mm-page_alloc-remove-unused-parameter-in-init_currently_empty_zone.patch
mm-vmscan-make-inactive_anon_is_low_global-return-directly.patch
mm-oom_kill-introduce-is_sysrq_oom-helper.patch
mm-compaction-add-an-is_via_compact_memory-helper-function.patch
mm-vmscan-make-inactive_anon-file_is_low-return-bool.patch
mm-memcontrol-make-mem_cgroup_inactive_anon_is_low-return-bool.patch
fs-kdev_t-remove-unused-huge_valid_dev-function.patch
fs-kdev_t-old-new_valid_dev-can-be-boolean.patch
fs-vfs-remove-unnecessary-new_valid_dev-check.patch
fs-btrfs-remove-unnecessary-new_valid_dev-check.patch
fs-exofs-remove-unnecessary-new_valid_dev-check.patch
fs-ext2-remove-unnecessary-new_valid_dev-check.patch
fs-f2fs-remove-unnecessary-new_valid_dev-check.patch
fs-hpfs-remove-unnecessary-new_valid_dev-check.patch
fs-jfs-remove-unnecessary-new_valid_dev-check.patch
fs-ncpfs-remove-unnecessary-new_valid_dev-check.patch
fs-nilfs2-remove-unnecessary-new_valid_dev-check.patch
fs-reiserfs-remove-unnecessary-new_valid_dev-check.patch
fs-stat-remove-unnecessary-new_valid_dev-check.patch
fs-ubifs-remove-unnecessary-new_valid_dev-check.patch

