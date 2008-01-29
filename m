From: akpm@linux-foundation.org
Subject: + mount-options-fix-hpfs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:41 -0800
Message-ID: <200801292322.m0TNMfbw009716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41203 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754928AbYA2XW5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:22:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz, mikulas@artax.karlin.mff.cuni.cz


The patch titled
     mount options: fix hpfs
has been added to the -mm tree.  Its filename is
     mount-options-fix-hpfs.patch

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
Subject: mount options: fix hpfs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to hpfs.

Use generic_show_options() and save the complete option string in
hpfs_fill_super() and hpfs_remount_fs().

Also add a small fix: hpfs_remount_fs() should return -EINVAL on
error, instead of 1, which is not an error value.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hpfs/super.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff -puN fs/hpfs/super.c~mount-options-fix-hpfs fs/hpfs/super.c
--- a/fs/hpfs/super.c~mount-options-fix-hpfs
+++ a/fs/hpfs/super.c
@@ -386,6 +386,7 @@ static int hpfs_remount_fs(struct super_
 	int lowercase, conv, eas, chk, errs, chkdsk, timeshift;
 	int o;
 	struct hpfs_sb_info *sbi = hpfs_sb(s);
+	char *new_opts = kstrdup(data, GFP_KERNEL);
 	
 	*flags |= MS_NOATIME;
 	
@@ -398,15 +399,15 @@ static int hpfs_remount_fs(struct super_
 	if (!(o = parse_opts(data, &uid, &gid, &umask, &lowercase, &conv,
 	    &eas, &chk, &errs, &chkdsk, &timeshift))) {
 		printk("HPFS: bad mount options.\n");
-	    	return 1;
+		goto out_err;
 	}
 	if (o == 2) {
 		hpfs_help();
-		return 1;
+		goto out_err;
 	}
 	if (timeshift != sbi->sb_timeshift) {
 		printk("HPFS: timeshift can't be changed using remount.\n");
-		return 1;
+		goto out_err;
 	}
 
 	unmark_dirty(s);
@@ -419,7 +420,14 @@ static int hpfs_remount_fs(struct super_
 
 	if (!(*flags & MS_RDONLY)) mark_dirty(s);
 
+	kfree(s->s_options);
+	s->s_options = new_opts;
+
 	return 0;
+
+out_err:
+	kfree(new_opts);
+	return -EINVAL;
 }
 
 /* Super operations */
@@ -432,6 +440,7 @@ static const struct super_operations hpf
 	.put_super	= hpfs_put_super,
 	.statfs		= hpfs_statfs,
 	.remount_fs	= hpfs_remount_fs,
+	.show_options	= generic_show_options,
 };
 
 static int hpfs_fill_super(struct super_block *s, void *options, int silent)
@@ -454,6 +463,8 @@ static int hpfs_fill_super(struct super_
 
 	int o;
 
+	save_mount_options(s, options);
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
