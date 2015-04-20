From: akpm@linux-foundation.org
Subject: [merged] befs-replace-typedef-befs_inode_info-by-structure.patch
 removed from -mm tree
Date: Mon, 20 Apr 2015 12:18:37 -0700
Message-ID: <5535510d.sygq+ijIUPr3naNW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbbDTTMQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Apr 2015 15:12:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, mm-commits@vger.kernel.org


The patch titled
     Subject: befs: replace typedef befs_inode_info by structure
has been removed from the -mm tree.  Its filename was
     befs-replace-typedef-befs_inode_info-by-structure.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: befs: replace typedef befs_inode_info by structure

See Documentation/CodingStyle

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/befs/befs.h     |    7 +++----
 fs/befs/linuxvfs.c |    7 ++++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/befs/befs.h~befs-replace-typedef-befs_inode_info-by-structure fs/befs/befs.h
--- a/fs/befs/befs.h~befs-replace-typedef-befs_inode_info-by-structure
+++ a/fs/befs/befs.h
@@ -56,7 +56,7 @@ struct befs_sb_info {
 	struct nls_table *nls;
 };
 
-typedef struct befs_inode_info {
+struct befs_inode_info {
 	u32 i_flags;
 	u32 i_type;
 
@@ -70,8 +70,7 @@ typedef struct befs_inode_info {
 	} i_data;
 
 	struct inode vfs_inode;
-
-} befs_inode_info;
+};
 
 enum befs_err {
 	BEFS_OK,
@@ -110,7 +109,7 @@ BEFS_SB(const struct super_block *super)
 	return (struct befs_sb_info *) super->s_fs_info;
 }
 
-static inline befs_inode_info *
+static inline struct befs_inode_info *
 BEFS_I(const struct inode *inode)
 {
 	return list_entry(inode, struct befs_inode_info, vfs_inode);
diff -puN fs/befs/linuxvfs.c~befs-replace-typedef-befs_inode_info-by-structure fs/befs/linuxvfs.c
--- a/fs/befs/linuxvfs.c~befs-replace-typedef-befs_inode_info-by-structure
+++ a/fs/befs/linuxvfs.c
@@ -305,7 +305,7 @@ static struct inode *befs_iget(struct su
 	struct buffer_head *bh = NULL;
 	befs_inode *raw_inode = NULL;
 	struct befs_sb_info *befs_sb = BEFS_SB(sb);
-	befs_inode_info *befs_ino = NULL;
+	struct befs_inode_info *befs_ino = NULL;
 	struct inode *inode;
 	long ret = -EIO;
 
@@ -471,7 +471,7 @@ static void *
 befs_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
 	struct super_block *sb = dentry->d_sb;
-	befs_inode_info *befs_ino = BEFS_I(dentry->d_inode);
+	struct befs_inode_info *befs_ino = BEFS_I(dentry->d_inode);
 	befs_data_stream *data = &befs_ino->i_data.ds;
 	befs_off_t len = data->size;
 	char *link;
@@ -501,7 +501,8 @@ befs_follow_link(struct dentry *dentry,
 static void *
 befs_fast_follow_link(struct dentry *dentry, struct nameidata *nd)
 {
-	befs_inode_info *befs_ino = BEFS_I(dentry->d_inode);
+	struct befs_inode_info *befs_ino = BEFS_I(dentry->d_inode);
+
 	nd_set_link(nd, befs_ino->i_data.symlink);
 	return NULL;
 }
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch
linux-next.patch

