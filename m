From: akpm@linux-foundation.org
Subject: + fs-jfs-remove-unnecessary-new_valid_dev-check.patch added to
 -mm tree
Date: Thu, 08 Oct 2015 15:00:04 -0700
Message-ID: <5616e764.oJJXwNn/YpboqdUh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58175 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbbJHWAF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2015 18:00:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, dave.kleikamp@oracle.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/jfs: remove unnecessary new_valid_dev() checks
has been added to the -mm tree.  Its filename is
     fs-jfs-remove-unnecessary-new_valid_dev-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-jfs-remove-unnecessary-new_valid_dev-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-jfs-remove-unnecessary-new_valid_dev-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yaowei Bai <bywxiaobai@163.com>
Subject: fs/jfs: remove unnecessary new_valid_dev() checks

new_valid_dev() always returns 1, so the !new_valid_dev() checks are not
needed.  Remove them.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Acked-by: Dave Kleikamp <dave.kleikamp@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/jfs/namei.c |    3 ---
 fs/jfs/super.c |    3 ---
 2 files changed, 6 deletions(-)

diff -puN fs/jfs/namei.c~fs-jfs-remove-unnecessary-new_valid_dev-check fs/jfs/namei.c
--- a/fs/jfs/namei.c~fs-jfs-remove-unnecessary-new_valid_dev-check
+++ a/fs/jfs/namei.c
@@ -1372,9 +1372,6 @@ static int jfs_mknod(struct inode *dir,
 	tid_t tid;
 	struct tblock *tblk;
 
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
-
 	jfs_info("jfs_mknod: %pd", dentry);
 
 	rc = dquot_initialize(dir);
diff -puN fs/jfs/super.c~fs-jfs-remove-unnecessary-new_valid_dev-check fs/jfs/super.c
--- a/fs/jfs/super.c~fs-jfs-remove-unnecessary-new_valid_dev-check
+++ a/fs/jfs/super.c
@@ -496,9 +496,6 @@ static int jfs_fill_super(struct super_b
 
 	jfs_info("In jfs_read_super: s_flags=0x%lx", sb->s_flags);
 
-	if (!new_valid_dev(sb->s_bdev->bd_dev))
-		return -EOVERFLOW;
-
 	sbi = kzalloc(sizeof(struct jfs_sb_info), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
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
fs-ext4-remove-unnecessary-new_valid_dev-check.patch
fs-f2fs-remove-unnecessary-new_valid_dev-check.patch
fs-hpfs-remove-unnecessary-new_valid_dev-check.patch
fs-jfs-remove-unnecessary-new_valid_dev-check.patch
fs-ncpfs-remove-unnecessary-new_valid_dev-check.patch
fs-nfs-remove-unnecessary-new_valid_dev-check.patch
fs-nilfs2-remove-unnecessary-new_valid_dev-check.patch
fs-reiserfs-remove-unnecessary-new_valid_dev-check.patch
fs-stat-remove-unnecessary-new_valid_dev-check.patch
fs-ubifs-remove-unnecessary-new_valid_dev-check.patch

