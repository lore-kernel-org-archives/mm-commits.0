Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795407239;
	b=aWHYJcXk4fYdKs31Yk3b5vfiEr725Eim+ISLBy7yiBIlV5zcvPiapRhsYZeIQwnmYSku
	 0crjidlV9xLD+sHj+tcYLWv4pd3nyK4GZO175TjfGnqTrxl9UMmY148LJcCRrbLjWy8EC
	 1/0sCPqaUyvHcnm5UkxPQtxqIurfNWsgMOSsE8GG2OHnW6IjhaRqNPLxm2UEvYbNCLFFx
	 7gnl4iMY5FwB6vvh/k6NgY8p9z5aCeZ11gpg+Wa+/nKvSzIoKFY2en4M4XoCkPZJQq2Ut
	 m+tCaWeeTLKVrS3WtvaZXvnAtm8JJaZwHME2l9JTuNAbfCORF/+2LG48S7kn+Uqj2Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795407239;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=wkZECLvlJNsPLE8QuUe0Ju+B0SuNf8Bj0Nm+V2w0BEY=;
	b=JRut9uVRnIxDMibEe/Jwky49yh6Rs7EMnjopSUjT1pwGJPaSjbfJhgKPlh2k75a+eIuP
	 VZvSYqrAAw89KNErqxIE9gBDPpHeau/X2RQIo8323kuSVXZvfMvZlL0egbJR+zWb9zw3X
	 r5cH0drau7vRF9qtEiAjQuZdMKAjjg7WLd5VQNcwLJtFTQGBPTZKedS5n4rKsB6w7lZYY
	 xqqQtRdIMwmrkWzwIaKSnoqxAua7e4iNig80m8DC+7bbgn6xH+0MkCmMiUM2a0n/Aubrj
	 Jeko0dHImJ1Z4nAtX0/sn2peq5SndHnMUIdi5H8i/MN4ROXyVUDWBS/eMiNP5XXyixg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="byOf/UvY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F237606A332
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=byOf/UvY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269351F000D2;
	Mon, 23 Nov 2026 04:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795407239;
	bh=wkZECLvlJNsPLE8QuUe0Ju+B0SuNf8Bj0Nm+V2w0BEY=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=byOf/UvYRm9kbjn+PWvWbLgHDh0RUfmja7VFNi2npQr8pyAj5PNaBaD5cC+UND0DA
	 PAfJjvvNk+ZgOxPN2T4ICJx6ZUrS4WFQIPuga1WD4QqurrrmV5w7idZ/EzTYlBC51D
	 yInK5pCDUxhfH8CtFqkCdUkeSlbeX2uy/BWHpBis=
Date: Sun, 22 Nov 2026 20:13:58 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-9-phillip@squashfs.org.uk>
References: <20261123034304.261742-9-phillip@squashfs.org.uk>
Subject: + squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index.patch added to mm-nonmm-unstable branch
Message-Id: <20261123041359.269351F000D2@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: don't compute start or alloc memory on empty directory or index
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: don't compute start or alloc memory on empty directory or index
Date: Mon, 23 Nov 2026 03:42:49 +0000

If a directory is empty (length equals 3), then there is no data to be
read from the filesystem.

This means we can optimise directory reading and lookup with empty
directories by skipping allocating memory to read data into, and
also skip computing the start location.

If the directory index is also empty, we can also skip allocating
memory when reading the index.

This commit also fixes the TRACE statements to display the start
and offset of the directory data within the directory table,
rather than the computed location on disk, or the incremented values
after squashfs_read_metadata() has been called.

It also adds sanity checks to ensure that the directory length is not
less than 3 bytes.

Link: https://patch.msgid.link/20261123034304.261742-9-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

 fs/squashfs/dir.c   |   32 +++++++++++++++++++++-----------
 fs/squashfs/inode.c |   16 ++++++++++++++--
 fs/squashfs/namei.c |   32 +++++++++++++++++++-------------
 3 files changed, 54 insertions(+), 26 deletions(-)

--- a/fs/squashfs/dir.c~squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index
+++ a/fs/squashfs/dir.c
@@ -99,19 +99,14 @@ static int squashfs_readdir(struct file
 {
 	struct inode *inode = file_inode(file);
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	u64 block = squashfs_i(inode)->start + msblk->directory_table;
-	int offset = squashfs_i(inode)->offset, length, err;
+	u64 block;
+	int offset, length, err;
 	unsigned int inode_number, dir_count, size, type;
 	struct squashfs_dir_header dirh;
 	struct squashfs_dir_entry *dire;
 
-	TRACE("Entered squashfs_readdir [%llx:%x]\n", block, offset);
-
-	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
-	if (dire == NULL) {
-		ERROR("Failed to allocate squashfs_dir_entry\n");
-		goto finish;
-	}
+	TRACE("Entered squashfs_readdir [%llx:%x]\n", squashfs_i(inode)->start,
+			squashfs_i(inode)->offset);
 
 	/*
 	 * Return "." and  ".." entries as the first two filenames in the
@@ -142,6 +137,19 @@ static int squashfs_readdir(struct file
 		ctx->pos += size;
 	}
 
+	if (i_size_read(inode) == 3)
+		/* The directory is empty, nothing more to do */
+		goto finish;
+
+	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
+	if (dire == NULL) {
+		ERROR("Failed to allocate squashfs_dir_entry\n");
+		goto finish;
+	}
+
+	block = squashfs_i(inode)->start + msblk->directory_table;
+	offset = squashfs_i(inode)->offset;
+
 	length = get_dir_index_using_offset(inode->i_sb, &block, &offset,
 				squashfs_i(inode)->dir_idx_start,
 				squashfs_i(inode)->dir_idx_offset,
@@ -206,12 +214,14 @@ static int squashfs_readdir(struct file
 		}
 	}
 
-finish:
 	kfree(dire);
+
+finish:
 	return 0;
 
 failed_read:
-	ERROR("Unable to read directory block [%llx:%x]\n", block, offset);
+	ERROR("Unable to read directory [%llx:%x]\n", squashfs_i(inode)->start,
+			squashfs_i(inode)->offset);
 	kfree(dire);
 	return 0;
 }
--- a/fs/squashfs/inode.c~squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index
+++ a/fs/squashfs/inode.c
@@ -257,8 +257,14 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
-		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
+		/* The directory size must be 3 or larger, as it includes "." and ".." entries */
 		inode->i_size = le16_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 3) {
+			err = -EINVAL;
+			goto failed_read;
+		}
+
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
 		inode->i_mode |= S_IFDIR;
@@ -282,9 +288,15 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
+		/* The directory size must be 3 or larger, as it includes "." and ".." entries */
+		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 3) {
+			err = -EINVAL;
+			goto failed_read;
+		}
+
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
-		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
 		inode->i_mode |= S_IFDIR;
--- a/fs/squashfs/namei.c~squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index
+++ a/fs/squashfs/namei.c
@@ -72,6 +72,9 @@ static int get_dir_index_using_name(stru
 
 	TRACE("Entered get_dir_index_using_name, i_count %d\n", i_count);
 
+	if (i_count == 0)
+		goto out;
+
 	index = kmalloc(sizeof(*index) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
 	if (index == NULL) {
 		ERROR("Failed to allocate squashfs_dir_index\n");
@@ -126,13 +129,20 @@ static struct dentry *squashfs_lookup(st
 	struct inode *inode = NULL;
 	struct squashfs_sb_info *msblk = dir->i_sb->s_fs_info;
 	struct squashfs_dir_header dirh;
-	struct squashfs_dir_entry *dire;
-	u64 block = squashfs_i(dir)->start + msblk->directory_table;
-	int offset = squashfs_i(dir)->offset;
-	int err, length;
+	struct squashfs_dir_entry *dire = NULL;
+	u64 block;
+	int offset, err, length;
 	unsigned int dir_count, size;
 
-	TRACE("Entered squashfs_lookup [%llx:%x]\n", block, offset);
+	TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(inode)->start,
+			squashfs_i(inode)->offset);
+
+	if (len > SQUASHFS_NAME_LEN)
+		return ERR_PTR(-ENAMETOOLONG);
+
+	if (i_size_read(dir) == 3)
+		/* The directory is empty, and so there's nothing to do */
+		goto exit_lookup;
 
 	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
 	if (dire == NULL) {
@@ -140,10 +150,8 @@ static struct dentry *squashfs_lookup(st
 		return ERR_PTR(-ENOMEM);
 	}
 
-	if (len > SQUASHFS_NAME_LEN) {
-		err = -ENAMETOOLONG;
-		goto failed;
-	}
+	block = squashfs_i(dir)->start + msblk->directory_table;
+	offset = squashfs_i(dir)->offset;
 
 	length = get_dir_index_using_name(dir->i_sb, &block, &offset,
 				squashfs_i(dir)->dir_idx_start,
@@ -218,10 +226,8 @@ data_error:
 	err = -EIO;
 
 read_failure:
-	ERROR("Unable to read directory block [%llx:%x]\n",
-		squashfs_i(dir)->start + msblk->directory_table,
-		squashfs_i(dir)->offset);
-failed:
+	ERROR("Unable to read directory [%llx:%x]\n", squashfs_i(dir)->start,
+			squashfs_i(dir)->offset);
 	kfree(dire);
 	return ERR_PTR(err);
 }
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-convert-squashfs_compressed_-to-inline-functions.patch
squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions.patch
squashfs-convert-squashfs_fragment_-to-inline-functions.patch
squashfs-convert-squashfs_lookup_-to-inline-functions.patch
squashfs-convert-squashfs_id_-to-inline-functions.patch
squashfs-convert-squashfs_xattr_-to-inline-functions.patch
squashfs-fix-offset-in-squashfs_read_inode-trace-statements.patch
squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index.patch
squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch
squashfs-fix-fragment-index-table-length-too-large-exploit.patch
squashfs-sanity-check-inode-metadata-block-location.patch
squashfs-sanity-check-directory-metadata-block-location.patch
squashfs-widen-xattr-count-variables-and-add-sanity-check.patch
squashfs-very-large-files-can-exceed-an-int-or-size_t.patch
squashfs-add-more-sanity-checking-to-squashfs_block_size.patch
squashfs-sanity-check-fragment-block-location-and-range.patch
squashfs-sanity-check-block-list-sizes-and-range.patch
squashfs-dont-store-large-export-table-indexes-in-memory.patch
squashfs-dont-store-large-fragment-table-indexes-in-memory.patch
squashfs-dont-store-large-xattr-id-table-indexes-in-memory.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch
squashfs-fix-regression-in-squashfs_copy_cache.patch
squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

