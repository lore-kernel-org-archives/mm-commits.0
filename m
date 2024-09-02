Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9695F144D0A
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248851; cv=none; b=D/LHaSFBe+kKclWsCK06StJo0E6nFx7V81h5XQjs7l+UEATXXwYlpr1bYxcrSornKf+qE5qx3GMaZXO5mMfecn3TZmiQKeQMbIqKXsH8hJ7PtydmrATIDbbFwwL+qLm03w2NU8MTaTnwSHvA8qO3hSQVTnZG6XvHgHhjLerLPuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248851; c=relaxed/simple;
	bh=GYdT0rwhCRlvI53uLwvHDx+1gRwwGjwyykpQrXYPc9w=;
	h=Date:To:From:Subject:Message-Id; b=q0ALA3KOQBgu3b33QHFxZluVxVouxdJMlGyfWwhkR6jWGCpm+ebATWGcFJTcM3E1raNkJHRXu0NJTxOyLTYFdgztFiV9heUPl2FRgcLYEPDJY90/3yLqQ1GKQAJjeOYz9hqxWzrkVaIWS+Nu2qfo9Vi6BymtfYdLmxzwVvp1d2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BphDcMMV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BphDcMMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63625C4CEC2;
	Mon,  2 Sep 2024 03:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248851;
	bh=GYdT0rwhCRlvI53uLwvHDx+1gRwwGjwyykpQrXYPc9w=;
	h=Date:To:From:Subject:From;
	b=BphDcMMVKqRxQs1Q0OBAp8xOIQxfyP3acFv7emFlIdPiFw4nhUrRZXhhILV2pF2Ag
	 x6UveiR85aqNAQWahIcKBTgRuiRYfEuB+cFSJee3FI5cQV7iPw9LvknvggY/Na49gZ
	 nuC4TVlSPCW4ojyNox4jj/Xnr7E3hFsTMtjZYcy4=
Date: Sun, 01 Sep 2024 20:47:30 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,huangxiaojia2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-use-common-implementation-of-file-type.patch removed from -mm tree
Message-Id: <20240902034731.63625C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: use common implementation of file type
has been removed from the -mm tree.  Its filename was
     nilfs2-use-common-implementation-of-file-type.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Huang Xiaojia <huangxiaojia2@huawei.com>
Subject: nilfs2: use common implementation of file type
Date: Tue, 27 Aug 2024 02:41:09 +0900

Patch series "nilfs2: assorted cleanups".

This is a collection of cleanup patches, with only the last three focused
on the log writer thread, the rest are miscellaneous.

Patches 1/8, 4/8, and 7/8 adopt common implementations, 2/8 uses a generic
macro, 5/8 removes dead code, 6/8 removes an unnecessary reference, and
3/8 and 8/8 each simplify a paticular messy implementation.


This patch (of 8):

Deduplicate the nilfs2 file type conversion implementation.

Link: https://lkml.kernel.org/r/20240826174116.5008-1-konishi.ryusuke@gmail.com
Link: https://lkml.kernel.org/r/20240815013442.1220909-1-huangxiaojia2@huawei.com
Link: https://lkml.kernel.org/r/20240826174116.5008-2-konishi.ryusuke@gmail.com
Signed-off-by: Huang Xiaojia <huangxiaojia2@huawei.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/dir.c |   44 +++++---------------------------------------
 1 file changed, 5 insertions(+), 39 deletions(-)

--- a/fs/nilfs2/dir.c~nilfs2-use-common-implementation-of-file-type
+++ a/fs/nilfs2/dir.c
@@ -231,37 +231,6 @@ static struct nilfs_dir_entry *nilfs_nex
 					  nilfs_rec_len_from_disk(p->rec_len));
 }
 
-static unsigned char
-nilfs_filetype_table[NILFS_FT_MAX] = {
-	[NILFS_FT_UNKNOWN]	= DT_UNKNOWN,
-	[NILFS_FT_REG_FILE]	= DT_REG,
-	[NILFS_FT_DIR]		= DT_DIR,
-	[NILFS_FT_CHRDEV]	= DT_CHR,
-	[NILFS_FT_BLKDEV]	= DT_BLK,
-	[NILFS_FT_FIFO]		= DT_FIFO,
-	[NILFS_FT_SOCK]		= DT_SOCK,
-	[NILFS_FT_SYMLINK]	= DT_LNK,
-};
-
-#define S_SHIFT 12
-static unsigned char
-nilfs_type_by_mode[(S_IFMT >> S_SHIFT) + 1] = {
-	[S_IFREG >> S_SHIFT]	= NILFS_FT_REG_FILE,
-	[S_IFDIR >> S_SHIFT]	= NILFS_FT_DIR,
-	[S_IFCHR >> S_SHIFT]	= NILFS_FT_CHRDEV,
-	[S_IFBLK >> S_SHIFT]	= NILFS_FT_BLKDEV,
-	[S_IFIFO >> S_SHIFT]	= NILFS_FT_FIFO,
-	[S_IFSOCK >> S_SHIFT]	= NILFS_FT_SOCK,
-	[S_IFLNK >> S_SHIFT]	= NILFS_FT_SYMLINK,
-};
-
-static void nilfs_set_de_type(struct nilfs_dir_entry *de, struct inode *inode)
-{
-	umode_t mode = inode->i_mode;
-
-	de->file_type = nilfs_type_by_mode[(mode & S_IFMT)>>S_SHIFT];
-}
-
 static int nilfs_readdir(struct file *file, struct dir_context *ctx)
 {
 	loff_t pos = ctx->pos;
@@ -297,10 +266,7 @@ static int nilfs_readdir(struct file *fi
 			if (de->inode) {
 				unsigned char t;
 
-				if (de->file_type < NILFS_FT_MAX)
-					t = nilfs_filetype_table[de->file_type];
-				else
-					t = DT_UNKNOWN;
+				t = fs_ftype_to_dtype(de->file_type);
 
 				if (!dir_emit(ctx, de->name, de->name_len,
 						le64_to_cpu(de->inode), t)) {
@@ -444,7 +410,7 @@ void nilfs_set_link(struct inode *dir, s
 	err = nilfs_prepare_chunk(folio, from, to);
 	BUG_ON(err);
 	de->inode = cpu_to_le64(inode->i_ino);
-	nilfs_set_de_type(de, inode);
+	de->file_type = fs_umode_to_ftype(inode->i_mode);
 	nilfs_commit_chunk(folio, mapping, from, to);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 }
@@ -531,7 +497,7 @@ got_it:
 	de->name_len = namelen;
 	memcpy(de->name, name, namelen);
 	de->inode = cpu_to_le64(inode->i_ino);
-	nilfs_set_de_type(de, inode);
+	de->file_type = fs_umode_to_ftype(inode->i_mode);
 	nilfs_commit_chunk(folio, folio->mapping, from, to);
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 	nilfs_mark_inode_dirty(dir);
@@ -612,14 +578,14 @@ int nilfs_make_empty(struct inode *inode
 	de->rec_len = nilfs_rec_len_to_disk(NILFS_DIR_REC_LEN(1));
 	memcpy(de->name, ".\0\0", 4);
 	de->inode = cpu_to_le64(inode->i_ino);
-	nilfs_set_de_type(de, inode);
+	de->file_type = fs_umode_to_ftype(inode->i_mode);
 
 	de = (struct nilfs_dir_entry *)(kaddr + NILFS_DIR_REC_LEN(1));
 	de->name_len = 2;
 	de->rec_len = nilfs_rec_len_to_disk(chunk_size - NILFS_DIR_REC_LEN(1));
 	de->inode = cpu_to_le64(parent->i_ino);
 	memcpy(de->name, "..\0", 4);
-	nilfs_set_de_type(de, inode);
+	de->file_type = fs_umode_to_ftype(inode->i_mode);
 	kunmap_local(kaddr);
 	nilfs_commit_chunk(folio, mapping, 0, chunk_size);
 fail:
_

Patches currently in -mm which might be from huangxiaojia2@huawei.com are


