From: akpm@linux-foundation.org
Subject: + mount-options-fix-reiserfs.patch added to -mm tree
Date: Tue, 29 Jan 2008 15:22:51 -0800
Message-ID: <200801292322.m0TNMpPv009737@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40866 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755226AbYA2X00 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 18:26:26 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mszeredi@suse.cz


The patch titled
     mount options: fix reiserfs
has been added to the -mm tree.  Its filename is
     mount-options-fix-reiserfs.patch

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
Subject: mount options: fix reiserfs
From: Miklos Szeredi <mszeredi@suse.cz>

Add a .show_options super operation to reiserfs.

Use generic_show_options() and save the complete option string in
reiserfs_fill_super() and reiserfs_remount().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/reiserfs/super.c |   38 ++++++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 12 deletions(-)

diff -puN fs/reiserfs/super.c~mount-options-fix-reiserfs fs/reiserfs/super.c
--- a/fs/reiserfs/super.c~mount-options-fix-reiserfs
+++ a/fs/reiserfs/super.c
@@ -617,6 +617,7 @@ static const struct super_operations rei
 	.unlockfs = reiserfs_unlockfs,
 	.statfs = reiserfs_statfs,
 	.remount_fs = reiserfs_remount,
+	.show_options = generic_show_options,
 #ifdef CONFIG_QUOTA
 	.quota_read = reiserfs_quota_read,
 	.quota_write = reiserfs_quota_write,
@@ -1138,6 +1139,7 @@ static int reiserfs_remount(struct super
 	unsigned long safe_mask = 0;
 	unsigned int commit_max_age = (unsigned int)-1;
 	struct reiserfs_journal *journal = SB_JOURNAL(s);
+	char *new_opts = kstrdup(arg, GFP_KERNEL);
 	int err;
 #ifdef CONFIG_QUOTA
 	int i;
@@ -1153,7 +1155,8 @@ static int reiserfs_remount(struct super
 			REISERFS_SB(s)->s_qf_names[i] = NULL;
 		}
 #endif
-		return -EINVAL;
+		err = -EINVAL;
+		goto out_err;
 	}
 
 	handle_attrs(s);
@@ -1191,9 +1194,9 @@ static int reiserfs_remount(struct super
 	}
 
 	if (blocks) {
-		int rc = reiserfs_resize(s, blocks);
-		if (rc != 0)
-			return rc;
+		err = reiserfs_resize(s, blocks);
+		if (err != 0)
+			goto out_err;
 	}
 
 	if (*mount_flags & MS_RDONLY) {
@@ -1201,16 +1204,16 @@ static int reiserfs_remount(struct super
 		/* remount read-only */
 		if (s->s_flags & MS_RDONLY)
 			/* it is read-only already */
-			return 0;
+			goto out_ok;
 		/* try to remount file system with read-only permissions */
 		if (sb_umount_state(rs) == REISERFS_VALID_FS
 		    || REISERFS_SB(s)->s_mount_state != REISERFS_VALID_FS) {
-			return 0;
+			goto out_ok;
 		}
 
 		err = journal_begin(&th, s, 10);
 		if (err)
-			return err;
+			goto out_err;
 
 		/* Mounting a rw partition read-only. */
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
@@ -1220,11 +1223,13 @@ static int reiserfs_remount(struct super
 		/* remount read-write */
 		if (!(s->s_flags & MS_RDONLY)) {
 			reiserfs_xattr_init(s, *mount_flags);
-			return 0;	/* We are read-write already */
+			goto out_ok;	/* We are read-write already */
 		}
 
-		if (reiserfs_is_journal_aborted(journal))
-			return journal->j_errno;
+		if (reiserfs_is_journal_aborted(journal)) {
+			err = journal->j_errno;
+			goto out_err;
+		}
 
 		handle_data_mode(s, mount_options);
 		handle_barrier_mode(s, mount_options);
@@ -1232,7 +1237,7 @@ static int reiserfs_remount(struct super
 		s->s_flags &= ~MS_RDONLY;	/* now it is safe to call journal_begin */
 		err = journal_begin(&th, s, 10);
 		if (err)
-			return err;
+			goto out_err;
 
 		/* Mount a partition which is read-only, read-write */
 		reiserfs_prepare_for_journal(s, SB_BUFFER_WITH_SB(s), 1);
@@ -1247,7 +1252,7 @@ static int reiserfs_remount(struct super
 	SB_JOURNAL(s)->j_must_wait = 1;
 	err = journal_end(&th, s, 10);
 	if (err)
-		return err;
+		goto out_err;
 	s->s_dirt = 0;
 
 	if (!(*mount_flags & MS_RDONLY)) {
@@ -1255,7 +1260,14 @@ static int reiserfs_remount(struct super
 		reiserfs_xattr_init(s, *mount_flags);
 	}
 
+out_ok:
+	kfree(s->s_options);
+	s->s_options = new_opts;
 	return 0;
+
+out_err:
+	kfree(new_opts);
+	return err;
 }
 
 static int read_super_block(struct super_block *s, int offset)
@@ -1559,6 +1571,8 @@ static int reiserfs_fill_super(struct su
 	struct reiserfs_sb_info *sbi;
 	int errval = -EINVAL;
 
+	save_mount_options(s, data);
+
 	sbi = kzalloc(sizeof(struct reiserfs_sb_info), GFP_KERNEL);
 	if (!sbi) {
 		errval = -ENOMEM;
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
