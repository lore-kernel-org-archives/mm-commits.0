Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C55010E0
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 00:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724803796; cv=none; b=SKFQbMYdhd0J8KfXk60XNH4qSkYPG4ZD57QSds+GhP+4ib/QEr3mZHTj/okZkD6eaW3z3cHmMJ0O39g95oZpQ4PScDcq7SQ3bKPyjtnheZeKQNwoLu+K4owUOdRL887SnN7f452HmuC1udUUms/R/ZBx6XXJDNCVTgvqWcnEvKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724803796; c=relaxed/simple;
	bh=5Q/PgWmxEyvQm7MMdVWsZzhdbpgp0t1EkPHmAoMLaNI=;
	h=Date:To:From:Subject:Message-Id; b=q7cHqkKGgYKBil9pXjknLA0iayguXshetL50IlAOPTiqUTn7zGYLhABb1/W15b94knOQT/SbPvTtmlr7AE3Ums2EISqOpjRe6YgMzLlk/dSMW3aKDiiW75PO0KcEevWoQEgMwHKl/z1WAcK7E5CXYmeE+4e8G8FuHGljQHiutsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YMduBzo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YMduBzo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4F4C4AF51;
	Wed, 28 Aug 2024 00:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724803795;
	bh=5Q/PgWmxEyvQm7MMdVWsZzhdbpgp0t1EkPHmAoMLaNI=;
	h=Date:To:From:Subject:From;
	b=YMduBzo1FdYVCREqVqcJLDe18Y9KSvua2X+DvMyE6S5c0XDtz6lPkFwh0aQPSdYJp
	 P8gwd+AR8yqEBLQrEMeIBeBM2dfIAeu7KN8KTfCEQWENOp9yHsyNC65NdZUgpbyo5J
	 VKa6EflykX95d2uKIJ8/5oSOLVURX9CNIpReHqbE=
Date: Tue, 27 Aug 2024 17:09:55 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,huangxiaojia2@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-use-common-implementation-of-file-type.patch added to mm-nonmm-unstable branch
Message-Id: <20240828000955.AD4F4C4AF51@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: use common implementation of file type
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-use-common-implementation-of-file-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-use-common-implementation-of-file-type.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

nilfs2-use-common-implementation-of-file-type.patch

