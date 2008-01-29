From: akpm@linux-foundation.org
Subject: + mount-options-fix-befs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:13 -0800
Message-ID: <200801292322.m0TNMDXC009691@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56053 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbYA2XWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, rathamahata@php4.ru


The patch titled
     mount options: fix befs
has been added to the -mm tree.  Its filename is
     mount-options-fix-befs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mount options: fix befs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to befs.

Use generic_show_options() and save the complete option string in
befs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Sergey S. Kostyliov <rathamahata@php4.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/linuxvfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/befs/linuxvfs.c~mount-options-fix-befs fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~mount-options-fix-befs
+++ a/fs/befs/linuxvfs.c
@@ -57,6 +57,7 @@ static const struct super_operations bef
 	.put_super	= befs_put_super,	/* uninit super */
 	.statfs		= befs_statfs,	/* statfs */
 	.remount_fs	= befs_remount,
+	.show_options	= generic_show_options,
 };
 
 /* slab cache for befs_inode_info objects */
@@ -759,10 +760,11 @@ befs_fill_super(struct super_block *sb, 
 	befs_super_block *disk_sb;
 	struct inode *root;
 	long ret = -EINVAL;
-
 	const unsigned long sb_block = 0;
 	const off_t x86_sb_off = 512;
 
+	save_mount_options(sb, data);
+
 	sb->s_fs_info = kmalloc(sizeof (*befs_sb), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
 		printk(KERN_ERR
_

Patches currently in -mm which might be from mszeredi@suse.cz are

origin.patch
git-x86.patch
fuse-fix-attribute-caching-after-create.patch
fuse-save-space-in-struct-fuse_req.patch
fuse-limit-queued-background-requests.patch
mount-options-add-documentation.patch
mount-options-add-generic_show_options.patch
mount-options-fix-adfs.patch
mount-options-fix-affs.patch
mount-options-fix-afs.patch
mount-options-fix-autofs4.patch
mount-options-fix-autofs.patch
mount-options-fix-befs.patch
mount-options-fix-capifs.patch
mount-options-fix-devpts.patch
mount-options-fix-ext2.patch
mount-options-fix-fat.patch
mount-options-fix-fuse.patch
mount-options-fix-hostfs.patch
mount-options-fix-hpfs.patch
mount-options-fix-hugetlbfs.patch
mount-options-fix-isofs.patch
mount-options-fix-ncpfs.patch
mount-options-fix-reiserfs.patch
mount-options-fix-spufs.patch
mount-options-fix-tmpfs.patch
mount-options-fix-udf.patch
