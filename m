From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 13 Sep 2017 15:30:52 -0700
Message-ID: <20170913223052.sZV2vZIvA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50948 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdIMWax (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 13 Sep 2017 18:30:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/f2fs/checkpoint.c~linux-next-git-rejects fs/f2fs/checkpoint.c
--- a/fs/f2fs/checkpoint.c~linux-next-git-rejects
+++ a/fs/f2fs/checkpoint.c
@@ -594,24 +594,14 @@ int recover_orphan_inodes(struct f2fs_sb
 	if (!is_set_ckpt_flags(sbi, CP_ORPHAN_PRESENT_FLAG))
 		return 0;
 
-<<<<<<< HEAD
-	if (s_flags & MS_RDONLY) {
-		f2fs_msg(sbi->sb, KERN_INFO, "orphan cleanup on readonly fs");
-		sbi->sb->s_flags &= ~MS_RDONLY;
-=======
 	if (s_flags & SB_RDONLY) {
 		f2fs_msg(sbi->sb, KERN_INFO, "orphan cleanup on readonly fs");
 		sbi->sb->s_flags &= ~SB_RDONLY;
->>>>>>> linux-next/akpm-base
 	}
 
 #ifdef CONFIG_QUOTA
 	/* Needed for iput() to work correctly and not trash data */
-<<<<<<< HEAD
-	sbi->sb->s_flags |= MS_ACTIVE;
-=======
 	sbi->sb->s_flags |= SB_ACTIVE;
->>>>>>> linux-next/akpm-base
 	/* Turn on quotas so that they are updated correctly */
 	f2fs_enable_quota_files(sbi);
 #endif
diff -puN fs/f2fs/recovery.c~linux-next-git-rejects fs/f2fs/recovery.c
--- a/fs/f2fs/recovery.c~linux-next-git-rejects
+++ a/fs/f2fs/recovery.c
@@ -595,24 +595,14 @@ int recover_fsync_data(struct f2fs_sb_in
 	unsigned long s_flags = sbi->sb->s_flags;
 	bool need_writecp = false;
 
-<<<<<<< HEAD
-	if (s_flags & MS_RDONLY) {
-		f2fs_msg(sbi->sb, KERN_INFO, "orphan cleanup on readonly fs");
-		sbi->sb->s_flags &= ~MS_RDONLY;
-=======
 	if (s_flags & SB_RDONLY) {
 		f2fs_msg(sbi->sb, KERN_INFO, "orphan cleanup on readonly fs");
 		sbi->sb->s_flags &= ~SB_RDONLY;
->>>>>>> linux-next/akpm-base
 	}
 
 #ifdef CONFIG_QUOTA
 	/* Needed for iput() to work correctly and not trash data */
-<<<<<<< HEAD
-	sbi->sb->s_flags |= MS_ACTIVE;
-=======
 	sbi->sb->s_flags |= SB_ACTIVE;
->>>>>>> linux-next/akpm-base
 	/* Turn on quotas so that they are updated correctly */
 	f2fs_enable_quota_files(sbi);
 #endif
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
drivers-media-cec-cec-adapc-fix-build-with-gcc-444.patch
mm-oom_reaper-skip-mm-structs-with-mmu-notifiers-checkpatch-fixes.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
mm.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
treewide-remove-gfp_temporary-allocation-flag-fix.patch
treewide-remove-gfp_temporary-allocation-flag-checkpatch-fixes.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

