From: akpm@linux-foundation.org
Subject: + fs-hpfs-remove-unnecessary-new_valid_dev-check.patch added to
 -mm tree
Date: Thu, 08 Oct 2015 15:00:02 -0700
Message-ID: <5616e762.U6KxBuDMy1fjbWAN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58170 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452AbbJHWAD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 Oct 2015 18:00:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bywxiaobai@163.com, mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/hpfs/namei.c: remove unnecessary new_valid_dev() check
has been added to the -mm tree.  Its filename is
     fs-hpfs-remove-unnecessary-new_valid_dev-check.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/fs-hpfs-remove-unnecessary-new_valid_dev-check.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/fs-hpfs-remove-unnecessary-new_valid_dev-check.patch

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
Subject: fs/hpfs/namei.c: remove unnecessary new_valid_dev() check

new_valid_dev() always returns 1, so the !new_valid_dev() check is not
needed.  Remove it.

Signed-off-by: Yaowei Bai <bywxiaobai@163.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/namei.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN fs/hpfs/namei.c~fs-hpfs-remove-unnecessary-new_valid_dev-check fs/hpfs/namei.c
--- a/fs/hpfs/namei.c~fs-hpfs-remove-unnecessary-new_valid_dev-check
+++ a/fs/hpfs/namei.c
@@ -227,8 +227,6 @@ static int hpfs_mknod(struct inode *dir,
 	int err;
 	if ((err = hpfs_chk_name(name, &len))) return err==-ENOENT ? -EINVAL : err;
 	if (hpfs_sb(dir->i_sb)->sb_eas < 2) return -EPERM;
-	if (!new_valid_dev(rdev))
-		return -EINVAL;
 	hpfs_lock(dir->i_sb);
 	err = -ENOSPC;
 	fnode = hpfs_alloc_fnode(dir->i_sb, hpfs_i(dir)->i_dno, &fno, &bh);
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

