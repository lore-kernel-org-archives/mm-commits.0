From: akpm@linux-foundation.org
Subject: + mount-options-fix-affs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:04 -0800
Message-ID: <200801292322.m0TNM4dk009669@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60952 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754809AbYA2XWS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, zippel@linux-m68k.org


The patch titled
     mount options: fix affs
has been added to the -mm tree.  Its filename is
     mount-options-fix-affs.patch

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
Subject: mount options: fix affs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to affs.

Use generic_show_options() and save the complete option string in
affs_fill_super() and affs_remount().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/super.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN fs/affs/super.c~mount-options-fix-affs fs/affs/super.c
--- a/fs/affs/super.c~mount-options-fix-affs
+++ a/fs/affs/super.c
@@ -122,6 +122,7 @@ static const struct super_operations aff
 	.write_super	= affs_write_super,
 	.statfs		= affs_statfs,
 	.remount_fs	= affs_remount,
+	.show_options	= generic_show_options,
 };
 
 enum {
@@ -272,6 +273,8 @@ static int affs_fill_super(struct super_
 	u8			 sig[4];
 	int			 ret = -EINVAL;
 
+	save_mount_options(sb, data);
+
 	pr_debug("AFFS: read_super(%s)\n",data ? (const char *)data : "no options");
 
 	sb->s_magic             = AFFS_SUPER_MAGIC;
@@ -487,14 +490,21 @@ affs_remount(struct super_block *sb, int
 	int			 root_block;
 	unsigned long		 mount_flags;
 	int			 res = 0;
+	char			*new_opts = kstrdup(data, GFP_KERNEL);
 
 	pr_debug("AFFS: remount(flags=0x%x,opts=\"%s\")\n",*flags,data);
 
 	*flags |= MS_NODIRATIME;
 
-	if (!parse_options(data,&uid,&gid,&mode,&reserved,&root_block,
-	    &blocksize,&sbi->s_prefix,sbi->s_volume,&mount_flags))
+	if (!parse_options(data, &uid, &gid, &mode, &reserved, &root_block,
+			   &blocksize, &sbi->s_prefix, sbi->s_volume,
+			   &mount_flags)) {
+		kfree(new_opts);
 		return -EINVAL;
+	}
+	kfree(sb->s_options);
+	sb->s_options = new_opts;
+
 	sbi->s_flags = mount_flags;
 	sbi->s_mode  = mode;
 	sbi->s_uid   = uid;
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
