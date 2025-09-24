Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D3D2AE99
	for <mm-commits@vger.kernel.org>; Wed, 24 Sep 2025 22:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758752926; cv=none; b=gBOG4ad8los0cwR8l6arIpUmhg3YvoujdxdJPmWHoTxKJvE8+MclG+BO24EDdhlwD7j2khHfR9zd9jn+KJVX0UyIAyq6wiklF1FREWRDVbJ1uKT/WpNe0jNBYwx3XM5/ghlg1P886mfyRCbCZno5JmW6VMWevaSSI3ct2YiRzdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758752926; c=relaxed/simple;
	bh=9h3HiWUH4ianL+WTESW1Ev3jdVJ9uJjfPMqaNFxiI4Q=;
	h=Date:To:From:Subject:Message-Id; b=gN1lzN1zT307OzmtY1J+e6PCsbHsJHpdHIYyXZoXc0zpIQ/ZZ3KD/rZZ9WNAvunsPJ1aWyS8cbSO60IBTFMRqA8vyMeHkkX0tAe0wkXYbH72GQ+1fZeyNnJaWSs0RDWRjIetx2afkBckEjqWO/BU0z2KEBHgcD+bu+zksRV5G34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=gdxN8g9O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="gdxN8g9O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D81BC4CEE7;
	Wed, 24 Sep 2025 22:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758752926;
	bh=9h3HiWUH4ianL+WTESW1Ev3jdVJ9uJjfPMqaNFxiI4Q=;
	h=Date:To:From:Subject:From;
	b=gdxN8g9OON9CMPBMFQbA2vEaRylqzd0hr8XGAD7I60rwvLlDZCoqIzWlwdCWJyVkw
	 8WtSBGfafrEID3USKyVvNvizU5Pk1C5StjkbHJW9Y9b8xnu1Uk5wM8HYOs0tol48dK
	 Dwg1MZnZTUbLQXpRe16ZUbhaBZEWAXrHclfwna60=
Date: Wed, 24 Sep 2025 15:28:45 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-add-seek_data-seek_hole-support.patch added to mm-nonmm-unstable branch
Message-Id: <20250924222846.0D81BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Squashfs: add SEEK_DATA/SEEK_HOLE support
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-add-seek_data-seek_hole-support.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-add-seek_data-seek_hole-support.patch

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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: add SEEK_DATA/SEEK_HOLE support
Date: Tue, 23 Sep 2025 23:06:52 +0100

Add support for SEEK_DATA and SEEK_HOLE lseek() whence values.

These allow much faster searches for holes and data in sparse files, which
can significantly speed up file copying, e.g.

before (GNU coreutils, Debian 13):

cp --sparse=always big-file /

took real 11m58s, user 0m5.764s, sys 11m48s

after:

real 0.047s, user 0.000s, sys 0.027s

Where big-file has a 256 GB hole followed by 47 KB of data.

Link: https://lkml.kernel.org/r/20250923220652.568416-3-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c        |  137 +++++++++++++++++++++++++++++++++---
 fs/squashfs/inode.c       |    4 -
 fs/squashfs/squashfs.h    |    1 
 fs/squashfs/squashfs_fs.h |    1 
 4 files changed, 130 insertions(+), 13 deletions(-)

--- a/fs/squashfs/file.c~squashfs-add-seek_data-seek_hole-support
+++ a/fs/squashfs/file.c
@@ -307,7 +307,8 @@ static int fill_meta_index(struct inode
 all_done:
 	*index_block = cur_index_block;
 	*index_offset = cur_offset;
-	*data_block = cur_data_block;
+	if (data_block)
+		*data_block = cur_data_block;
 
 	/*
 	 * Scale cache index (cache slot entry) to index
@@ -324,17 +325,15 @@ failed:
  * Get the on-disk location and compressed size of the datablock
  * specified by index.  Fill_meta_index() does most of the work.
  */
-static int read_blocklist(struct inode *inode, int index, u64 *block)
+static int read_blocklist_ptrs(struct inode *inode, int index, u64 *start,
+	int *offset, u64 *block)
 {
-	u64 start;
 	long long blks;
-	int offset;
 	__le32 size;
-	int res = fill_meta_index(inode, index, &start, &offset, block);
+	int res = fill_meta_index(inode, index, start, offset, block);
 
-	TRACE("read_blocklist: res %d, index %d, start 0x%llx, offset"
-		       " 0x%x, block 0x%llx\n", res, index, start, offset,
-			*block);
+	TRACE("read_blocklist: res %d, index %d, start 0x%llx, offset 0x%x, block 0x%llx\n",
+				res, index, *start, *offset, block ? *block : 0);
 
 	if (res < 0)
 		return res;
@@ -346,22 +345,31 @@ static int read_blocklist(struct inode *
 	 * extra block indexes needed.
 	 */
 	if (res < index) {
-		blks = read_indexes(inode->i_sb, index - res, &start, &offset);
+		blks = read_indexes(inode->i_sb, index - res, start, offset);
 		if (blks < 0)
 			return (int) blks;
-		*block += blks;
+		if (block)
+			*block += blks;
 	}
 
 	/*
 	 * Read length of block specified by index.
 	 */
-	res = squashfs_read_metadata(inode->i_sb, &size, &start, &offset,
+	res = squashfs_read_metadata(inode->i_sb, &size, start, offset,
 			sizeof(size));
 	if (res < 0)
 		return res;
 	return squashfs_block_size(size);
 }
 
+static inline int read_blocklist(struct inode *inode, int index, u64 *block)
+{
+	u64 start;
+	int offset;
+
+	return read_blocklist_ptrs(inode, index, &start, &offset, block);
+}
+
 static bool squashfs_fill_page(struct folio *folio,
 		struct squashfs_cache_entry *buffer, size_t offset,
 		size_t avail)
@@ -658,7 +666,114 @@ skip_pages:
 	kfree(pages);
 }
 
+static loff_t seek_hole_data(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file->f_mapping->host;
+	struct super_block *sb = inode->i_sb;
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	u64 start, index = offset >> msblk->block_log;
+	u64 file_end = (i_size_read(inode) + msblk->block_size - 1) >> msblk->block_log;
+	int s_offset, length;
+	__le32 *blist = NULL;
+
+	/* reject offset if negative or beyond file end */
+	if ((unsigned long long)offset >= i_size_read(inode))
+		return -ENXIO;
+
+	/* is offset within tailend and is tailend packed into a fragment? */
+	if (index + 1 == file_end &&
+			squashfs_i(inode)->fragment_block != SQUASHFS_INVALID_BLK) {
+		if (whence == SEEK_DATA)
+			return offset;
+
+		/* there is an implicit hole at the end of any file */
+		return i_size_read(inode);
+	}
+
+	length = read_blocklist_ptrs(inode, index, &start, &s_offset, NULL);
+	if (length < 0)
+		return length;
+
+	/* nothing more to do if offset matches desired whence value */
+	if ((length == 0 && whence == SEEK_HOLE) ||
+					(length && whence == SEEK_DATA))
+		return offset;
+
+	/* skip scanning forwards if we're at file end */
+	if (++ index == file_end)
+		goto not_found;
+
+	blist = kmalloc(SQUASHFS_SCAN_INDEXES << 2, GFP_KERNEL);
+	if (blist == NULL) {
+		ERROR("%s: Failed to allocate block_list\n", __func__);
+		return -ENOMEM;
+	}
+
+	while (index < file_end) {
+		int i, indexes = min(file_end - index, SQUASHFS_SCAN_INDEXES);
+
+		offset = squashfs_read_metadata(sb, blist, &start, &s_offset, indexes << 2);
+		if (offset < 0)
+			goto finished;
+
+		for (i = 0; i < indexes; i++) {
+			length = squashfs_block_size(blist[i]);
+			if (length < 0) {
+				offset = length;
+				goto finished;
+			}
+
+			/* does this block match desired whence value? */
+			if ((length == 0 && whence == SEEK_HOLE) ||
+					(length && whence == SEEK_DATA)) {
+				offset = (index + i) << msblk->block_log;
+				goto finished;
+			}
+		}
+
+		index += indexes;
+	}
+
+not_found:
+	/* whence value determines what happens */
+	if (whence == SEEK_DATA)
+		offset = -ENXIO;
+	else
+		/* there is an implicit hole at the end of any file */
+		offset = i_size_read(inode);
+
+finished:
+	kfree(blist);
+	return offset;
+}
+
+static loff_t squashfs_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file->f_mapping->host;
+
+	switch (whence) {
+	default:
+		return generic_file_llseek(file, offset, whence);
+	case SEEK_DATA:
+	case SEEK_HOLE:
+		offset = seek_hole_data(file, offset, whence);
+		break;
+	}
+
+	if (offset < 0)
+		return offset;
+
+	return vfs_setpos(file, offset, inode->i_sb->s_maxbytes);
+}
+
 const struct address_space_operations squashfs_aops = {
 	.read_folio = squashfs_read_folio,
 	.readahead = squashfs_readahead
 };
+
+const struct file_operations squashfs_file_operations = {
+	.llseek		= squashfs_llseek,
+	.read_iter	= generic_file_read_iter,
+	.mmap_prepare	= generic_file_readonly_mmap_prepare,
+	.splice_read	= filemap_splice_read
+};
--- a/fs/squashfs/inode.c~squashfs-add-seek_data-seek_hole-support
+++ a/fs/squashfs/inode.c
@@ -168,7 +168,7 @@ int squashfs_read_inode(struct inode *in
 		}
 
 		set_nlink(inode, 1);
-		inode->i_fop = &generic_ro_fops;
+		inode->i_fop = &squashfs_file_operations;
 		inode->i_mode |= S_IFREG;
 		inode->i_blocks = ((inode->i_size - 1) >> 9) + 1;
 		squashfs_i(inode)->fragment_block = frag_blk;
@@ -222,7 +222,7 @@ int squashfs_read_inode(struct inode *in
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_op = &squashfs_inode_ops;
-		inode->i_fop = &generic_ro_fops;
+		inode->i_fop = &squashfs_file_operations;
 		inode->i_mode |= S_IFREG;
 		inode->i_blocks = (inode->i_size -
 				le64_to_cpu(sqsh_ino->sparse) + 511) >> 9;
--- a/fs/squashfs/squashfs_fs.h~squashfs-add-seek_data-seek_hole-support
+++ a/fs/squashfs/squashfs_fs.h
@@ -208,6 +208,7 @@ static inline int squashfs_block_size(__
 #define SQUASHFS_META_INDEXES	(SQUASHFS_METADATA_SIZE / sizeof(unsigned int))
 #define SQUASHFS_META_ENTRIES	127
 #define SQUASHFS_META_SLOTS	8
+#define SQUASHFS_SCAN_INDEXES	1024
 
 struct meta_entry {
 	u64			data_block;
--- a/fs/squashfs/squashfs.h~squashfs-add-seek_data-seek_hole-support
+++ a/fs/squashfs/squashfs.h
@@ -107,6 +107,7 @@ extern const struct address_space_operat
 
 /* inode.c */
 extern const struct inode_operations squashfs_inode_ops;
+extern const struct file_operations squashfs_file_operations;
 
 /* namei.c */
 extern const struct inode_operations squashfs_dir_inode_ops;
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-uninit-value-in-squashfs_get_parent.patch
squashfs-add-additional-inode-sanity-checking.patch
squashfs-add-seek_data-seek_hole-support.patch

