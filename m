Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE36C8BFC
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803803; cv=none; b=g7DvRfbgyStNW8zfLxRt9fmDtk2gh0iH03vbgWJndT8eqtJSMYhcqoerSih+gKvl/EKjyeB5io2RVzax7A+7vyslJAFh3y93pDN6/k+SWyzScZfgbEfHLXOlk53HiuZdQFFE5A7iCA4+0jOYSN+k1Kg8NK358hD1jklPseZpLuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803803; c=relaxed/simple;
	bh=PpJo/6YPaiZKerT2bre57bw6KpekzGCKUrRBuCM92cY=;
	h=Date:To:From:Subject:Message-Id; b=aipUKhHuw7YlVcCMduGXSUBzij8mp/AjBYuNeXY12aG3ZH4DXICgHKg0sL8vahQtEhz12HL/ZLgcjxNih8fMjVcVNRDRGTsvvoJdk4mTgGWgJju4soJN/kXifRxViLSbjfeIMg7ggo2IfSNvvaiu/GrxDus/yiGBqb+tp5lgL7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x3C9kkbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x3C9kkbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781ADC4AF48;
	Wed, 28 Aug 2024 00:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803802;
	bh=PpJo/6YPaiZKerT2bre57bw6KpekzGCKUrRBuCM92cY=;
	h=Date:To:From:Subject:From;
	b=x3C9kkbWUxKovtJsXfnuqDiIGeTWQicyhTy+x4mgX01Y5Irm2cYda8ScgQ4SfyJhd
	 z+r51yLAm+GvuJYydqozlkLbiDpTVteVoR8W8BiAuymwGmZ/m4mVwfhzCwU5gLoHIG
	 iPrpEXoL7lkebKKSa5PBKWVQ+2tC93lKLMPY8d/c=
Date: Tue, 27 Aug 2024 17:10:01 -0700
To: mm-commits@vger.kernel.org,huangxiaojia2@huawei.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation.patch added to mm-nonmm-unstable branch
Message-Id: <20240828001002.781ADC4AF48@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: eliminate the shared counter and spinlock for i_generation
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: eliminate the shared counter and spinlock for i_generation
Date: Tue, 27 Aug 2024 02:41:12 +0900

Use get_random_u32() as the source for inode->i_generation for new inodes,
and eliminate the original source, the shared counter ns_next_generation
along with its exclusive access spinlock ns_next_gen_lock.

Link: https://lkml.kernel.org/r/20240826174116.5008-5-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c     |    6 ++----
 fs/nilfs2/the_nilfs.c |    5 -----
 fs/nilfs2/the_nilfs.h |    6 ------
 3 files changed, 2 insertions(+), 15 deletions(-)

--- a/fs/nilfs2/inode.c~nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation
+++ a/fs/nilfs2/inode.c
@@ -15,6 +15,7 @@
 #include <linux/writeback.h>
 #include <linux/uio.h>
 #include <linux/fiemap.h>
+#include <linux/random.h>
 #include "nilfs.h"
 #include "btnode.h"
 #include "segment.h"
@@ -320,7 +321,6 @@ static int nilfs_insert_inode_locked(str
 struct inode *nilfs_new_inode(struct inode *dir, umode_t mode)
 {
 	struct super_block *sb = dir->i_sb;
-	struct the_nilfs *nilfs = sb->s_fs_info;
 	struct inode *inode;
 	struct nilfs_inode_info *ii;
 	struct nilfs_root *root;
@@ -381,9 +381,7 @@ struct inode *nilfs_new_inode(struct ino
 	/* ii->i_dir_acl = 0; */
 	ii->i_dir_start_lookup = 0;
 	nilfs_set_inode_flags(inode);
-	spin_lock(&nilfs->ns_next_gen_lock);
-	inode->i_generation = nilfs->ns_next_generation++;
-	spin_unlock(&nilfs->ns_next_gen_lock);
+	inode->i_generation = get_random_u32();
 	if (nilfs_insert_inode_locked(inode, root, ino) < 0) {
 		err = -EIO;
 		goto failed_after_creation;
--- a/fs/nilfs2/the_nilfs.c~nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation
+++ a/fs/nilfs2/the_nilfs.c
@@ -12,7 +12,6 @@
 #include <linux/slab.h>
 #include <linux/blkdev.h>
 #include <linux/backing-dev.h>
-#include <linux/random.h>
 #include <linux/log2.h>
 #include <linux/crc32.h>
 #include "nilfs.h"
@@ -69,7 +68,6 @@ struct the_nilfs *alloc_nilfs(struct sup
 	INIT_LIST_HEAD(&nilfs->ns_dirty_files);
 	INIT_LIST_HEAD(&nilfs->ns_gc_inodes);
 	spin_lock_init(&nilfs->ns_inode_lock);
-	spin_lock_init(&nilfs->ns_next_gen_lock);
 	spin_lock_init(&nilfs->ns_last_segment_lock);
 	nilfs->ns_cptree = RB_ROOT;
 	spin_lock_init(&nilfs->ns_cptree_lock);
@@ -754,9 +752,6 @@ int init_nilfs(struct the_nilfs *nilfs,
 	nilfs->ns_blocksize_bits = sb->s_blocksize_bits;
 	nilfs->ns_blocksize = blocksize;
 
-	get_random_bytes(&nilfs->ns_next_generation,
-			 sizeof(nilfs->ns_next_generation));
-
 	err = nilfs_store_disk_layout(nilfs, sbp);
 	if (err)
 		goto failed_sbh;
--- a/fs/nilfs2/the_nilfs.h~nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation
+++ a/fs/nilfs2/the_nilfs.h
@@ -71,8 +71,6 @@ enum {
  * @ns_dirty_files: list of dirty files
  * @ns_inode_lock: lock protecting @ns_dirty_files
  * @ns_gc_inodes: dummy inodes to keep live blocks
- * @ns_next_generation: next generation number for inodes
- * @ns_next_gen_lock: lock protecting @ns_next_generation
  * @ns_mount_opt: mount options
  * @ns_resuid: uid for reserved blocks
  * @ns_resgid: gid for reserved blocks
@@ -161,10 +159,6 @@ struct the_nilfs {
 	/* GC inode list */
 	struct list_head	ns_gc_inodes;
 
-	/* Inode allocator */
-	u32			ns_next_generation;
-	spinlock_t		ns_next_gen_lock;
-
 	/* Mount options */
 	unsigned long		ns_mount_opt;
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-protect-references-to-superblock-parameters-exposed-in-sysfs.patch
nilfs2-fix-missing-cleanup-on-rollforward-recovery-error.patch
nilfs2-fix-state-management-in-error-path-of-log-writing-function.patch
nilfs2-add-support-for-fs_ioc_getuuid.patch
nilfs2-add-support-for-fs_ioc_getfssysfspath.patch
nilfs2-add-support-for-fs_ioc_getfslabel.patch
nilfs2-add-support-for-fs_ioc_setfslabel.patch
nilfs2-do-not-output-warnings-when-clearing-dirty-buffers.patch
nilfs2-add-missing-argument-description-for-__nilfs_error.patch
nilfs2-add-missing-argument-descriptions-for-ioctl-related-helpers.patch
nilfs2-improve-kernel-doc-comments-for-b-tree-node-helpers.patch
nilfs2-fix-incorrect-kernel-doc-declaration-of-nilfs_palloc_req-structure.patch
nilfs2-add-missing-description-of-nilfs_btree_path-structure.patch
nilfs2-describe-the-members-of-nilfs_bmap_operations-structure.patch
nilfs2-fix-inconsistencies-in-kernel-doc-comments-in-segmenth.patch
nilfs2-fix-missing-initial-short-descriptions-of-kernel-doc-comments.patch
nilfs2-treat-missing-sufile-header-block-as-metadata-corruption.patch
nilfs2-treat-missing-cpfile-header-block-as-metadata-corruption.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-recovery.patch
nilfs2-do-not-propagate-enoent-error-from-sufile-during-gc.patch
nilfs2-do-not-propagate-enoent-error-from-nilfs_sufile_mark_dirty.patch
nilfs2-use-the-bits_per_long-macro.patch
nilfs2-separate-inode-type-information-from-i_state-field.patch
nilfs2-eliminate-the-shared-counter-and-spinlock-for-i_generation.patch
nilfs2-do-not-repair-reserved-inode-bitmap-in-nilfs_new_inode.patch
nilfs2-remove-sc_timer_task.patch
nilfs2-use-kthread_create-and-kthread_stop-for-the-log-writer-thread.patch
nilfs2-refactor-nilfs_segctor_thread.patch

