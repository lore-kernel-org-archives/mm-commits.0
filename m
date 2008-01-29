From: akpm@linux-foundation.org
Subject: + mount-options-fix-isofs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:46 -0800
Message-ID: <200801292322.m0TNMkGQ009725@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57836 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754939AbYA2XWy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, jack@suse.cz


The patch titled
     mount options: fix isofs
has been added to the -mm tree.  Its filename is
     mount-options-fix-isofs.patch

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
Subject: mount options: fix isofs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to isofs.

Use generic_show_options() and save the complete option string in
isofs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/isofs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/isofs/inode.c~mount-options-fix-isofs fs/isofs/inode.c
--- a/fs/isofs/inode.c~mount-options-fix-isofs
+++ a/fs/isofs/inode.c
@@ -110,6 +110,7 @@ static const struct super_operations iso
 	.put_super	= isofs_put_super,
 	.statfs		= isofs_statfs,
 	.remount_fs	= isofs_remount,
+	.show_options	= generic_show_options,
 };
 
 
@@ -561,6 +562,8 @@ static int isofs_fill_super(struct super
 	int table, error = -EINVAL;
 	unsigned int vol_desc_start;
 
+	save_mount_options(s, data);
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		return -ENOMEM;
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
