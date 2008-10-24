From: akpm@linux-foundation.org
Subject: - vfs-add-lookup_rename_target-intent.patch removed from -mm tree
Date: Fri, 24 Oct 2008 12:41:13 -0700
Message-ID: <200810241941.m9OJfDH3001171@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60526 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752566AbYJXTlx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 24 Oct 2008 15:41:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hirofumi@mail.parknet.co.jp, hch@lst.de, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     vfs: add LOOKUP_RENAME_TARGET intent
has been removed from the -mm tree.  Its filename was
     vfs-add-lookup_rename_target-intent.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: vfs: add LOOKUP_RENAME_TARGET intent
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

This adds LOOKUP_RENAME_TARGET intent for lookup of rename destination.

LOOKUP_RENAME_TARGET is going to be used like LOOKUP_CREATE.  But since
the destination of rename() can be existing directory entry, so it has a
tells it to user of this intent.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/namei.c            |    1 +
 include/linux/namei.h |    1 +
 2 files changed, 2 insertions(+)

diff -puN fs/namei.c~vfs-add-lookup_rename_target-intent fs/namei.c
--- a/fs/namei.c~vfs-add-lookup_rename_target-intent
+++ a/fs/namei.c
@@ -2684,6 +2684,7 @@ asmlinkage long sys_renameat(int olddfd,
 
 	oldnd.flags &= ~LOOKUP_PARENT;
 	newnd.flags &= ~LOOKUP_PARENT;
+	newnd.flags |= LOOKUP_RENAME_TARGET;
 
 	trap = lock_rename(new_dir, old_dir);
 
diff -puN include/linux/namei.h~vfs-add-lookup_rename_target-intent include/linux/namei.h
--- a/include/linux/namei.h~vfs-add-lookup_rename_target-intent
+++ a/include/linux/namei.h
@@ -54,6 +54,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_OPEN		0x0100
 #define LOOKUP_CREATE		0x0200
 #define LOOKUP_EXCL		0x0400
+#define LOOKUP_RENAME_TARGET	0x0800
 
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
 
_

Patches currently in -mm which might be from hirofumi@mail.parknet.co.jp are

linux-next.patch
fat-document-additional-vfat-mount-options.patch
fat-move-fs-vfat-and-fs-msdos-to-fs-fat.patch
fat-split-include-msdos_fsh.patch
fat-fix-and-cleanup-timestamp-conversion.patch
fat-use-generic_file_llseek-for-directory.patch
fat-cleanup-fat_parse_long-error-handling.patch
fat-improve-fat_hash.patch
fat-fix-fat_ent_update_ptr-for-fat12.patch
fat-use-fat_detach-in-fat_clear_inode.patch
vfat-fix-vfat_find-error-path-in-vfat_lookup.patch
fat-fix-cleanup-dcache-handling-for-vfat.patch
fat-kill-d_invalidate-in-vfat_lookup.patch
fat-cleanup-msdos_lookup.patch
fat-cleanup-fat-attribute-stuff.patch
fat-fix-attr_ro-in-the-case-of-umask-s_wugo-==-0.patch
fat-fix-attr_ro-for-directory.patch
fat-fix-_fat_bmap-race.patch
fat-add-printf-attribute-to-fat_fs_panic.patch
fat-mmu_private-race-fix.patch
fat-i_pos-race-fix.patch
fat-i_blocks-warning-fix.patch

