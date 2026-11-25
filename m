Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585291;
	b=Us6/aNMcWlnJXdQOP4Gh+5T6Vej22jm4hN6UFM8Q2iiV3qHQ3J9lyS6TIXbn0qSoVeK7
	 kshxCWNhoizOS20xOhG4SKCWDwyp2ougWlB8fBCZj+RTTIRD7W6M/OnMF80vdCdTSfh2W
	 Rp5tsJR706yV6l7NsFj8XAck+GQaq0aBPegpakxLAHaKD13g5ig/MjQAuNR1aQImIM7QT
	 Ix9oOouE3W62l/ho1DXpX0p76paqMZjoKDh4XKAxU60Lb1lYSISBbhXWy0Jr4NcmowJZt
	 nLzK/Ll4TwDDQV1BQ8kf0Rf/KKPTemva3L+uNCRekFE1rfaHQsFqgzW3+IhbQMpcT0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585291;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=fV7kC9ZCKVWISfTa1CMWWA+lMTYGEEce5cjpAZNnZvw=;
	b=OykzZlj1j+bTmHnfVQN3qmymJgRAKbPpeXrgcqUeyd2I3vwKEea/MfBFQah39E/hGW0a
	 vvD7bIH3eTEFMB82qQQXK6eCAJgXxiFe4MO3sWGZ+LHpf6IAGv59c6TW71XWEzWOkUt9M
	 tf4cskMg8dhVGlRpU/pH/tH6EeCPEc01WYaomiwKuId+922BCuyBioZJr9nzBvRAtZpOC
	 oYsD6id3YCJ7gsEzWIaLNeGZUCYrv1x+9DUgsvrnjXnZM1f/nRQiGetYjTHsRTK5zBdEM
	 npco1DMaMaJ42Crn49LaoryxErb8r7fatQUAjYt/fh57B1PrrRV/yZqicZMI8Ok3d1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SOCHtBVS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70669606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SOCHtBVS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E38F91F000D1;
	Wed, 25 Nov 2026 05:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585291;
	bh=fV7kC9ZCKVWISfTa1CMWWA+lMTYGEEce5cjpAZNnZvw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=SOCHtBVSNDY2dBN9DmNu1VMN7WFgbOPJyfK2voIXtYre2U4Ao4qFzE+XLaTLBGAKa
	 2Dr83KUZ9jjX+JT1zFoSet2RmzomJsKWfI6oXujykf1CzvJephcoTFWZ6/FXplPcg1
	 XjspeZciQtFCrzIgU+2Q9c1xtKrA/it67+ZBdH4Q=
Date: Tue, 24 Nov 2026 21:41:30 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-9-phillip@squashfs.org.uk>
References: <20261123034304.261742-9-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index.patch removed from -mm tree
Message-Id: <20261125054130.E38F91F000D1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: don't compute start or alloc memory on empty directory or index
has been removed from the -mm tree.  Its filename was
     squashfs-dont-compute-start-or-alloc-memory-on-empty-directory-or-index.patch

This patch was dropped because an updated version will be issued

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

