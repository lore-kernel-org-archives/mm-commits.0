Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510684;
	b=2AXSmYMZXn65E+bnwu+4e/2ve7FzhzdhbJzh1Jh7BPeunnIMTYTgY5402CS+VkLhOsJu
	 cRg7T6NGxASdvMIoDYFDG0k2+8Q/om3b72RlPH51FJdXDZqf8IHO940Me0IwbXUtZDYNb
	 UjKgal3KtQtJO9cRn6aU7hVPcGXMocle1CE4DtD1sGv4q0tFWS65GqJ3aAabIkzOOgQcp
	 WkQZdT8zNqEI1ceAFPy68g5kijYTbPIXwqk7T5EBKkv57SXOIpJyaG3q2iLaqZOqY18Dx
	 9senJOFYsCLGZU3a5snnhqY6wVNmBWl7Svji268F+cdx/db8qJKhTautjnnZtllQyzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510684;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=71FPXIhHHp54zLXM4s6uXcz9KyZVJUzMh4ZHhGP1mF4=;
	b=EU5vZDespSvfJVH5UPQBv7IsATsDC/tLtn4gjclTB31j/pBIUlSCmT0jbAn7uvtm77FR
	 6GIrxLsFdijAf3JtUFVAvZdtepYzP8E6qXECwBusHrExWLci1RwAGvCbBCjA+G+BNTpPW
	 uOcTNddqiNObrJ4XAq1jiodkx4ypV3gTW1aDgAFeCKEhgc2LJbKb8NeiV4YRIm1i7Y3m6
	 ODOUyu9jazF0cSczVTyYluPk0K16HdSYhtMmrIUzPF/gjpWXgTwl/5P/WobMbhsMGBH6f
	 aWLPR7W+eP2Y1SqbuycSefMG9Q0Se8I2qzKGIjerJm6wwlDxxOX6gBmIw78Lz86T7AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iz8liQj4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CFA606A334
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 19:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=iz8liQj4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2BA1F000C4;
	Thu, 12 Nov 2026 19:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794510684;
	bh=71FPXIhHHp54zLXM4s6uXcz9KyZVJUzMh4ZHhGP1mF4=;
	h=Date:To:From:Subject;
	b=iz8liQj4sfG5WPI6nHhfOU0n0vr8dYZDcGGr48bc/Fs1d4k4rvn4f2Evnqqwdr616
	 QIjVX+rYs9OGT5+tWJ/BiHfGS624nWSZm32dt8mWw+7mPPbmcuISyrcUrxBhJT7Ms9
	 qcZolz+lH6d49UPH2e8hxCflVjh0x3eeeTeiCWgM=
Date: Thu, 12 Nov 2026 11:11:23 -0800
To: mm-commits@vger.kernel.org,phillip.lougher@gmail.com,
	phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch added to mm-nonmm-unstable branch
Message-Id: <20261112191123.DA2BA1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: fix variables in directory code and add more sanity checks
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch

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
Subject: Squashfs: fix variables in directory code and add more sanity checks
Date: Wed, 11 Nov 2026 23:44:00 +0000

A directory larger than a metadata block (8192 bytes) will have a
directory index to allow faster reading and lookup of names.  This
index allows the code to jump to the desired compressed metadata block,
without requiring the directory to be scanned from the beginning.

But the index handling code has a defect in that multiple variables
including those used to read and track directory indexes from disk are
signed ints.  This means any index which is 2^31 or larger will be
treated as a negative value.  The knock on efect of this is that the
offset into the desired metadata block is incorrectly computed, with the
result the directory fails to be read, and an I/O error is returned.

This commit corrects the variables (and function return value) to be
unsigned int, and it also adds more sanity checking of the values read
off disk (including directory size to avoid underflow in subtraction).
Now if a directory index is found to be incorrect, the index is
discarded and the previous index read from disk is used.  This allows
the directory to be read correctly without throwing an I/O error.

Reproducer
==========

The following reproducer creates a Squashfs filesystem with a root
directory which has a directory index.  The reproducer then corrupts
root directory index 0 with an index value of -1.  The filesystem is
then mounted, and stat run on file /mnt/filename-490.

If the exploit succeeds stat will report an I/O error and dmesg will
contain Squashfs error reports.

=====================================================================
#!/bin/bash

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

for i in $(seq 1 1000); do
	echo "filename-$i f 0700 0 0 echo hello" >> pseudo
done

echo "Create a Squashfs filesystem"
if ! mksquashfs - img.sqsh -pf pseudo -pd "d 0777 0 0" -noI -no-progress -quiet; then
	echo Creating the Squashfs filesystem failed
	finish
fi

# Write -1 in little-endian format to file
/usr/bin/echo -en "\xff\xff\xff\xff" > file

echo "Over-write the root directory index 0, with an index value of -1."
echo "This because the metadata is uncompressed can be over-written directly,"
echo "but, normally the metadata will be compressed."
echo "The location of the 4 byte index is 32150"

dd bs=1 seek=32150 if=file of=img.sqsh count=4 conv=notrunc status=none

echo
echo "Mount the filesystem on /mnt"

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

echo
echo "Run stat /mnt/filename-490 on the mounted filesystem"
echo
echo "If the exploit works stat will report I/O error, and dmesg will"
echo "contain Squashfs error reports"
echo

stat /mnt/filename-490
umount /mnt
popd 2>&1 > /dev/null

rm -rf $DIR
exit 0
=====================================================================

Link: https://lore.kernel.org/20261111234402.252354-21-phillip@squashfs.org.uk
Fixes: 07972dde75c3 ("Squashfs: directory readdir operations")
Fixes: c88da2c97936 ("Squashfs: directory lookup operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
---

 fs/squashfs/dir.c              |   73 ++++++++++++++++++-----
 fs/squashfs/inode.c            |   12 +++
 fs/squashfs/namei.c            |   95 +++++++++++++++++++++++--------
 fs/squashfs/squashfs_helpers.h |    7 ++
 4 files changed, 147 insertions(+), 40 deletions(-)

--- a/fs/squashfs/dir.c~squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks
+++ a/fs/squashfs/dir.c
@@ -37,17 +37,17 @@ static const unsigned char squashfs_file
  * (if any) we have managed to read - the index isn't essential, just
  * quicker.
  */
-static int get_dir_index_using_offset(struct super_block *sb,
+static unsigned int get_dir_index_using_offset(struct super_block *sb,
 	u64 *next_block, int *next_offset, u64 index_start, int index_offset,
-	int i_count, u64 f_pos)
+	unsigned int i_count, loff_t max_index, u64 f_pos)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	s64 res;
-	int err, i, index, length = 0;
-	unsigned int size;
+	int err;
+	unsigned int i, index, length = 0, size, start_block, block;
 	struct squashfs_dir_index dir_index;
 
-	TRACE("Entered get_dir_index_using_offset, i_count %d, f_pos %lld\n",
+	TRACE("Entered get_dir_index_using_offset, i_count %u, f_pos %lld\n",
 					i_count, f_pos);
 
 	/*
@@ -58,6 +58,18 @@ static int get_dir_index_using_offset(st
 	if (f_pos <= 3)
 		return f_pos;
 	f_pos -= 3;
+	max_index -= 3;
+
+	/*
+	 * A valid index starts at a directory header, and there must be enough
+	 * room for a directory header and one directory entry.
+	 */
+	if (max_index < sizeof(struct squashfs_dir_header) +
+					sizeof(struct squashfs_dir_entry) + 1)
+		return 3;
+
+	max_index -= sizeof(struct squashfs_dir_header) +
+					sizeof(struct squashfs_dir_entry) + 1;
 
 	for (i = 0; i < i_count; i++) {
 		err = squashfs_read_metadata(sb, &dir_index, &index_start,
@@ -65,33 +77,51 @@ static int get_dir_index_using_offset(st
 		if (err < 0)
 			break;
 
+		/* Sanity check the directory index contents */
+
+		/* size should never be larger than SQUASHFS_NAME_LEN */
+		size = le32_to_cpu(dir_index.size) + 1;
+		if (size > SQUASHFS_NAME_LEN)
+			break;
+
+		/* The stored index should not be larger than max_index */
 		index = le32_to_cpu(dir_index.index);
+		if (index > max_index)
+			break;
+
+		block = le32_to_cpu(dir_index.start_block);
+
+		if (i > 0) {
+			/* The stored index should be larger than the previous index */
+			if (index <= length)
+				break;
+
+			/* The start_block should not be less than the previous start_block */
+			if (block < start_block)
+				break;
+		}
+
 		if (index > f_pos)
 			/*
 			 * Found the index we're looking for.
 			 */
 			break;
 
-		size = le32_to_cpu(dir_index.size) + 1;
-
-		/* size should never be larger than SQUASHFS_NAME_LEN */
-		if (size > SQUASHFS_NAME_LEN)
-			break;
-
 		err = squashfs_read_metadata(sb, NULL, &index_start,
 				&index_offset, size);
 		if (err < 0)
 			break;
 
-		res = squashfs_dir_start(le32_to_cpu(dir_index.start_block), msblk);
+		res = squashfs_dir_start(block, msblk);
 		if (res < 0)
 			break;
 
+		start_block = block;
 		length = index;
 		*next_block = res;
 	}
 
-	*next_offset = (length + *next_offset) % SQUASHFS_METADATA_SIZE;
+	*next_offset = ((u64)length + *next_offset) % SQUASHFS_METADATA_SIZE;
 
 	/*
 	 * Translate back from internal f_pos to external f_pos.
@@ -105,7 +135,8 @@ static int squashfs_readdir(struct file
 	struct inode *inode = file_inode(file);
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	s64 block = squashfs_dir_start(squashfs_i(inode)->start, msblk);
-	int offset = squashfs_i(inode)->offset, length, err;
+	int offset = squashfs_i(inode)->offset, err;
+	loff_t length;
 	unsigned int inode_number, dir_count, size, type;
 	struct squashfs_dir_header dirh;
 	struct squashfs_dir_entry *dire = NULL;
@@ -154,12 +185,15 @@ static int squashfs_readdir(struct file
 				squashfs_i(inode)->dir_idx_start,
 				squashfs_i(inode)->dir_idx_offset,
 				squashfs_i(inode)->dir_idx_cnt,
-				ctx->pos);
+				i_size_read(inode), ctx->pos);
 
 	while (length < i_size_read(inode)) {
 		/*
 		 * Read directory header
 		 */
+		if (!squashfs_dir_space(inode, length, sizeof(dirh)))
+			goto failed_read;
+
 		err = squashfs_read_metadata(inode->i_sb, &dirh, &block,
 					&offset, sizeof(dirh));
 		if (err < 0)
@@ -176,23 +210,30 @@ static int squashfs_readdir(struct file
 			/*
 			 * Read directory entry.
 			 */
+			if (!squashfs_dir_space(inode, length, sizeof(*dire)))
+				goto failed_read;
+
 			err = squashfs_read_metadata(inode->i_sb, dire, &block,
 					&offset, sizeof(*dire));
 			if (err < 0)
 				goto failed_read;
 
+			length += sizeof(*dire);
 			size = le16_to_cpu(dire->size) + 1;
 
 			/* size should never be larger than SQUASHFS_NAME_LEN */
 			if (size > SQUASHFS_NAME_LEN)
 				goto failed_read;
 
+			if (!squashfs_dir_space(inode, length, size))
+				goto failed_read;
+
 			err = squashfs_read_metadata(inode->i_sb, dire->name,
 					&block, &offset, size);
 			if (err < 0)
 				goto failed_read;
 
-			length += sizeof(*dire) + size;
+			length += size;
 
 			if (ctx->pos >= length)
 				continue;
--- a/fs/squashfs/inode.c~squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks
+++ a/fs/squashfs/inode.c
@@ -253,8 +253,12 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
-		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
+		/* The directory size must be 3 or larger, as it includes "." and ".." entries */
 		inode->i_size = le16_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 3)
+			goto failed_read;
+
+		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
 		inode->i_mode |= S_IFDIR;
@@ -278,9 +282,13 @@ int squashfs_read_inode(struct inode *in
 		if (err < 0)
 			goto failed_read;
 
+		/* The directory size must be 3 or larger, as it includes "." and ".." entries */
+		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
+		if (inode->i_size < 3)
+			goto failed_read;
+
 		xattr_id = le32_to_cpu(sqsh_ino->xattr);
 		set_nlink(inode, le32_to_cpu(sqsh_ino->nlink));
-		inode->i_size = le32_to_cpu(sqsh_ino->file_size);
 		inode->i_op = &squashfs_dir_inode_ops;
 		inode->i_fop = &squashfs_dir_ops;
 		inode->i_mode |= S_IFDIR;
--- a/fs/squashfs/namei.c~squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks
+++ a/fs/squashfs/namei.c
@@ -61,57 +61,96 @@
  * (if any) we have managed to read - the index isn't essential, just
  * quicker.
  */
-static int get_dir_index_using_name(struct super_block *sb,
+static unsigned int get_dir_index_using_name(struct super_block *sb,
 			u64 *next_block, int *next_offset, u64 index_start,
-			int index_offset, int i_count, const char *name)
+			int index_offset, unsigned int i_count,
+			loff_t max_index, const char *name)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	s64 res;
-	int i, length = 0, err;
-	unsigned int size;
-	struct squashfs_dir_index *index;
+	int err;
+	unsigned int i, index, length = 0, size, start_block, block;
+	struct squashfs_dir_index *dir_index;
 
-	TRACE("Entered get_dir_index_using_name, i_count %d\n", i_count);
+	TRACE("Entered get_dir_index_using_name, i_count %u\n", i_count);
 
-	index = kmalloc(sizeof(*index) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
-	if (index == NULL) {
+	dir_index = kmalloc(sizeof(*dir_index) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
+	if (dir_index == NULL) {
 		ERROR("Failed to allocate squashfs_dir_index\n");
 		goto out;
 	}
 
+	/*
+	 * Translate from external index to internal index.  This is offset by
+	 * 3 because we invent "." and ".." entries.
+	 */
+	max_index -= 3;
+
+	/*
+	 * A valid index starts at a directory header, and there must be enough
+	 * room for a directory header and one directory entry.
+	 */
+	if (max_index < sizeof(struct squashfs_dir_header) +
+				sizeof(struct squashfs_dir_entry) + 1)
+		goto out;
+
+	max_index -= sizeof(struct squashfs_dir_header) +
+				sizeof(struct squashfs_dir_entry) + 1;
+
 	for (i = 0; i < i_count; i++) {
-		err = squashfs_read_metadata(sb, index, &index_start,
-					&index_offset, sizeof(*index));
+		err = squashfs_read_metadata(sb, dir_index, &index_start,
+					&index_offset, sizeof(*dir_index));
 		if (err < 0)
 			break;
 
+		/* Sanity check the directory index contents */
 
-		size = le32_to_cpu(index->size) + 1;
+		/* size should never be larger than SQUASHFS_NAME_LEN */
+		size = le32_to_cpu(dir_index->size) + 1;
 		if (size > SQUASHFS_NAME_LEN)
 			break;
 
-		err = squashfs_read_metadata(sb, index->name, &index_start,
+		/* The stored index should not be larger than max_index */
+		index = le32_to_cpu(dir_index->index);
+		if (index > max_index)
+			break;
+
+		block = le32_to_cpu(dir_index->start_block);
+
+		if (i > 0) {
+			/* The stored index should be larger than the previous index */
+			if (index <= length)
+				break;
+
+			/* The start_block should not be less than the previous start_block */
+			if (block < start_block)
+				break;
+		}
+
+		err = squashfs_read_metadata(sb, dir_index->name, &index_start,
 					&index_offset, size);
 		if (err < 0)
 			break;
 
-		index->name[size] = '\0';
+		dir_index->name[size] = '\0';
 
-		if (strcmp(index->name, name) > 0)
+		if (strcmp(dir_index->name, name) > 0)
+			/* Found the index we're looking for. */
 			break;
 
-		res = squashfs_dir_start(le32_to_cpu(index->start_block), msblk);
+		res = squashfs_dir_start(block, msblk);
 		if (res < 0)
 			break;
 
-		length = le32_to_cpu(index->index);
+		start_block = block;
+		length = index;
 		*next_block = res;
 	}
 
-	*next_offset = (length + *next_offset) % SQUASHFS_METADATA_SIZE;
-	kfree(index);
-
 out:
+	*next_offset = ((u64)length + *next_offset) % SQUASHFS_METADATA_SIZE;
+	kfree(dir_index);
+
 	/*
 	 * Return index (f_pos) of the looked up metadata block.  Translate
 	 * from internal f_pos to external f_pos which is offset by 3 because
@@ -133,7 +172,8 @@ static struct dentry *squashfs_lookup(st
 	struct squashfs_dir_entry *dire = NULL;
 	u64 block = squashfs_dir_start(squashfs_i(dir)->start, msblk);
 	int offset = squashfs_i(dir)->offset;
-	int err, length;
+	int err;
+	loff_t length;
 	unsigned int dir_count, size;
 
 	TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(dir)->start, offset);
@@ -155,12 +195,16 @@ static struct dentry *squashfs_lookup(st
 	length = get_dir_index_using_name(dir->i_sb, &block, &offset,
 				squashfs_i(dir)->dir_idx_start,
 				squashfs_i(dir)->dir_idx_offset,
-				squashfs_i(dir)->dir_idx_cnt, name);
+				squashfs_i(dir)->dir_idx_cnt,
+				i_size_read(dir), name);
 
 	while (length < i_size_read(dir)) {
 		/*
 		 * Read directory header.
 		 */
+		if (!squashfs_dir_space(dir, length, sizeof(dirh)))
+			goto read_failure;
+
 		err = squashfs_read_metadata(dir->i_sb, &dirh, &block,
 				&offset, sizeof(dirh));
 		if (err < 0)
@@ -177,23 +221,30 @@ static struct dentry *squashfs_lookup(st
 			/*
 			 * Read directory entry.
 			 */
+			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
+				goto read_failure;
+
 			err = squashfs_read_metadata(dir->i_sb, dire, &block,
 					&offset, sizeof(*dire));
 			if (err < 0)
 				goto read_failure;
 
+			length += sizeof(*dire);
 			size = le16_to_cpu(dire->size) + 1;
 
 			/* size should never be larger than SQUASHFS_NAME_LEN */
 			if (size > SQUASHFS_NAME_LEN)
 				goto data_error;
 
+			if (!squashfs_dir_space(dir, length, size))
+				goto read_failure;
+
 			err = squashfs_read_metadata(dir->i_sb, dire->name,
 					&block, &offset, size);
 			if (err < 0)
 				goto read_failure;
 
-			length += sizeof(*dire) + size;
+			length += size;
 
 			if (name[0] < dire->name[0])
 				goto exit_lookup;
--- a/fs/squashfs/squashfs_helpers.h~squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks
+++ a/fs/squashfs/squashfs_helpers.h
@@ -353,4 +353,11 @@ static inline s64 squashfs_add_indexes(u
 
 	return block + blks;
 }
+
+static inline bool squashfs_dir_space(struct inode *inode, loff_t length, int size)
+{
+	loff_t space = i_size_read(inode) - length;
+
+	return space >= size;
+}
 #endif
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-convert-squashfs_compressed_-to-inline-functions.patch
squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions.patch
squashfs-convert-squashfs_fragment_-to-inline-functions.patch
squashfs-convert-squashfs_lookup_-to-inline-functions.patch
squashfs-convert-squashfs_id_-to-inline-functions.patch
squashfs-convert-squashfs_xattr_-to-inline-functions.patch
squashfs-fix-offset-in-squashfs_read_inode-trace-statements.patch
squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch
squashfs-fix-fragment-index-table-length-too-large-exploit.patch
squashfs-sanity-check-inode-metadata-block-location.patch
squashfs-sanity-check-directory-metadata-block-location.patch
squashfs-widen-xattr-count-variables-and-add-sanity-check.patch
squashfs-very-large-files-can-exceed-an-int-block-count.patch
squashfs-add-more-sanity-checking-to-squashfs_block_size.patch
squashfs-sanity-check-fragment-block-location-and-range.patch
squashfs-sanity-check-block-list-sizes-and-range.patch
squashfs-dont-store-large-export-table-indexes-in-memory.patch
squashfs-dont-store-large-fragment-table-indexes-in-memory.patch
squashfs-dont-store-large-xattr-id-table-indexes-in-memory.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch
squashfs-fix-regression-in-squashfs_copy_cache.patch
squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch

