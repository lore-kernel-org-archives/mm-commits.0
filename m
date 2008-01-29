From: akpm@linux-foundation.org
Subject: + mount-options-fix-autofs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:11 -0800
Message-ID: <200801292322.m0TNMBx7009681@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42094 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754370AbYA2XWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, hpa@zytor.com


The patch titled
     mount options: fix autofs
has been added to the -mm tree.  Its filename is
     mount-options-fix-autofs.patch

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
Subject: mount options: fix autofs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to autofs.

Use generic_show_options() and save the complete option string in
autofs_fill_super().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs/inode.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN fs/autofs/inode.c~mount-options-fix-autofs fs/autofs/inode.c
--- a/fs/autofs/inode.c~mount-options-fix-autofs
+++ a/fs/autofs/inode.c
@@ -54,6 +54,7 @@ out_kill_sb:
 
 static const struct super_operations autofs_sops = {
 	.statfs		= simple_statfs,
+	.show_options	= generic_show_options,
 };
 
 enum {Opt_err, Opt_fd, Opt_uid, Opt_gid, Opt_pgrp, Opt_minproto, Opt_maxproto};
@@ -140,6 +141,8 @@ int autofs_fill_super(struct super_block
 	int minproto, maxproto;
 	pid_t pgid;
 
+	save_mount_options(s, data);
+
 	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
 	if (!sbi)
 		goto fail_unlock;
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
