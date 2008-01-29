From: akpm@linux-foundation.org
Subject: + mount-options-fix-autofs4.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:09 -0800
Message-ID: <200801292322.m0TNM9FT009676@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42355 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753413AbYA2XWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, raven@themaw.net


The patch titled
     mount options: fix autofs4
has been added to the -mm tree.  Its filename is
     mount-options-fix-autofs4.patch

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
Subject: mount options: fix autofs4
From: Miklos Szeredi <mszeredi@suse.cz>

Add uid= and gid= options to /proc/mounts for autofs4 filesystems.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: Ian Kent <raven@themaw.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/autofs4/inode.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/autofs4/inode.c~mount-options-fix-autofs4 fs/autofs4/inode.c
--- a/fs/autofs4/inode.c~mount-options-fix-autofs4
+++ a/fs/autofs4/inode.c
@@ -188,11 +188,16 @@ out_kill_sb:
 static int autofs4_show_options(struct seq_file *m, struct vfsmount *mnt)
 {
 	struct autofs_sb_info *sbi = autofs4_sbi(mnt->mnt_sb);
+	struct inode *root_inode = mnt->mnt_sb->s_root->d_inode;
 
 	if (!sbi)
 		return 0;
 
 	seq_printf(m, ",fd=%d", sbi->pipefd);
+	if (root_inode->i_uid != 0)
+		seq_printf(m, ",uid=%u", root_inode->i_uid);
+	if (root_inode->i_gid != 0)
+		seq_printf(m, ",gid=%u", root_inode->i_gid);
 	seq_printf(m, ",pgrp=%d", sbi->oz_pgrp);
 	seq_printf(m, ",timeout=%lu", sbi->exp_timeout/HZ);
 	seq_printf(m, ",minproto=%d", sbi->min_proto);
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
