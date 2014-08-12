From: akpm@linux-foundation.org
Subject: [merged] fs-bfs-use-bfs-prefix-for-dump_imap.patch removed from
 -mm tree
Date: Tue, 12 Aug 2014 12:40:48 -0700
Message-ID: <53ea6dc0.hncc6bdndSH8zTdl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:37657 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbaHLTkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Aug 2014 15:40:49 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so1910900oig.1
        for <mm-commits@vger.kernel.org>; Tue, 12 Aug 2014 12:40:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, tigran@aivazian.fsnet.co.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/bfs: use bfs prefix for dump_imap
has been removed from the -mm tree.  Its filename was
     fs-bfs-use-bfs-prefix-for-dump_imap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/bfs: use bfs prefix for dump_imap

All bfs related functions use bfs_ prefix.  This patch also moves extern
declaration to bfs.h and removes prototype from inode.c

This fixes checkpatch warning:
'WARNING: externs should be avoided in .c files'

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Cc: "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/bfs/bfs.h   |    1 +
 fs/bfs/dir.c   |    4 +---
 fs/bfs/inode.c |    8 +++-----
 3 files changed, 5 insertions(+), 8 deletions(-)

diff -puN fs/bfs/bfs.h~fs-bfs-use-bfs-prefix-for-dump_imap fs/bfs/bfs.h
--- a/fs/bfs/bfs.h~fs-bfs-use-bfs-prefix-for-dump_imap
+++ a/fs/bfs/bfs.h
@@ -46,6 +46,7 @@ static inline struct bfs_inode_info *BFS
 
 /* inode.c */
 extern struct inode *bfs_iget(struct super_block *sb, unsigned long ino);
+extern void bfs_dump_imap(const char *, struct super_block *);
 
 /* file.c */
 extern const struct inode_operations bfs_file_inops;
diff -puN fs/bfs/dir.c~fs-bfs-use-bfs-prefix-for-dump_imap fs/bfs/dir.c
--- a/fs/bfs/dir.c~fs-bfs-use-bfs-prefix-for-dump_imap
+++ a/fs/bfs/dir.c
@@ -75,8 +75,6 @@ const struct file_operations bfs_dir_ope
 	.llseek		= generic_file_llseek,
 };
 
-extern void dump_imap(const char *, struct super_block *);
-
 static int bfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 						bool excl)
 {
@@ -110,7 +108,7 @@ static int bfs_create(struct inode *dir,
 	BFS_I(inode)->i_eblock = 0;
 	insert_inode_hash(inode);
         mark_inode_dirty(inode);
-	dump_imap("create", s);
+	bfs_dump_imap("create", s);
 
 	err = bfs_add_entry(dir, dentry->d_name.name, dentry->d_name.len,
 							inode->i_ino);
diff -puN fs/bfs/inode.c~fs-bfs-use-bfs-prefix-for-dump_imap fs/bfs/inode.c
--- a/fs/bfs/inode.c~fs-bfs-use-bfs-prefix-for-dump_imap
+++ a/fs/bfs/inode.c
@@ -30,8 +30,6 @@ MODULE_LICENSE("GPL");
 #define dprintf(x...)
 #endif
 
-void dump_imap(const char *prefix, struct super_block *s);
-
 struct inode *bfs_iget(struct super_block *sb, unsigned long ino)
 {
 	struct bfs_inode *di;
@@ -194,7 +192,7 @@ static void bfs_evict_inode(struct inode
 			info->si_freeb += bi->i_eblock + 1 - bi->i_sblock;
 		info->si_freei++;
 		clear_bit(ino, info->si_imap);
-		dump_imap("delete_inode", s);
+		bfs_dump_imap("delete_inode", s);
         }
 
 	/*
@@ -297,7 +295,7 @@ static const struct super_operations bfs
 	.statfs		= bfs_statfs,
 };
 
-void dump_imap(const char *prefix, struct super_block *s)
+void bfs_dump_imap(const char *prefix, struct super_block *s)
 {
 #ifdef DEBUG
 	int i;
@@ -443,7 +441,7 @@ static int bfs_fill_super(struct super_b
 	}
 	brelse(bh);
 	brelse(sbh);
-	dump_imap("read_super", s);
+	bfs_dump_imap("read_super", s);
 	return 0;
 
 out3:
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-cifs-remove-obsolete-__constant.patch
fs-cifs-filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-cifs-smb2filec-replace-countsize-kzalloc-by-kcalloc.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
fs-isofs-logging-clean-up.patch
fs-isofs-logging-clean-up-fix.patch
linux-next.patch
kernel-posix-timersc-code-clean-up.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kernel-kprobesc-convert-printk-to-pr_foo.patch

