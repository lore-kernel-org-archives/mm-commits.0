Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586067;
	b=VwGH8nSMcALFEmNN8fcy1XFFDzdL8uqIvhen0zc9F1UHSTigOD2FJuAjGV8P8bhHN+h0
	 LO1ytwU3k9/fK9ZbY4/Mdhp+cyNh3UESxBsr4FewQUYCg1hBlhhJXOBbyJhgdgteCMH3N
	 rJRPjm/JpC1CDm0kvMdHcS7utTl5gmOL+JW1P9zcG2CliOI/394+Sj3cyGk2dFlZbLPe/
	 0oxn/wKZ5THikYcCdchH/Jb31ZG2sReESQzrtd8vs5J7O9EDQPceiU8p8PcvrXEkwX3Ng
	 LuhTtdEFBQOVvYb4nePuXZhNM3fZWDE6VjpRnCYkW0SB9TbxmRwkvifU1PfzErl6lWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586067;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=aBQRaBj+2oLPB3/PY7uhjHzLGX/+urmBTMcOmNqWsVk=;
	b=esNKMFX1Dd7+/zPpIeTS77h2IC8AxwjIUsx85jNXXsukj5QTeAo+/vZC1zV/UFcqBCXF
	 +cp9P/Rl4jJ7CQblny02mKjZW2zlQ1oI1bNuQ8VGH6cO3w6i32qHUOKEogFgtzm1XcCWE
	 wvofXW/oIn1GTvCEZQEMp7xRw3KafNwqD8MJUeQABYKPQK1ovwA2LizWUfcYAfVppgYr7
	 JVvHkZDS5z7yP4BOMDYAkNyz+r4NZJwutYFdatJRQdJkbPytExgSllkmuKa2oK++t/o8k
	 cUr6WYTabIRBkTz9jqa5tI0tfGXQuN52Hrys8XC1yRhuYLtserRLOzMAWUxl5OnftXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DDKliYBV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BFDB606A321
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DDKliYBV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC671F000D1;
	Wed, 25 Nov 2026 05:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795586066;
	bh=aBQRaBj+2oLPB3/PY7uhjHzLGX/+urmBTMcOmNqWsVk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=DDKliYBVNFYlaJ1fE4NE/xLPyHjXw1wqBp5Fbo3j3lZE+ebQa6P0qgvI/y6rFvFO5
	 7a/x+eLs9auljRowFwMqPcG3UWSs2/RAWaQ8+HwBc4ahYf89rhXaj4nieolJbxViSS
	 qGeRoxOh2OD7VwK8xhrR5adHoElAlwIluIsM78go=
Date: Tue, 24 Nov 2026 21:54:25 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125014737.347231-22-phillip@squashfs.org.uk>
References: <20261125014737.347231-22-phillip@squashfs.org.uk>
Subject: + squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055426.6CC671F000D1@smtp.kernel.org>
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
Date: Wed, 25 Nov 2026 01:47:35 +0000

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

It also ensures that the name size doesn't overflow an unsigned int by
sanity checking the value before adding 1.

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

Link: https://patch.msgid.link/20261125014737.347231-22-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 fs/squashfs/dir.c              |   80 ++++++++++++++++++------
 fs/squashfs/namei.c            |  103 +++++++++++++++++++++++--------
 fs/squashfs/squashfs_fs.h      |    3 
 fs/squashfs/squashfs_helpers.h |    7 ++
 4 files changed, 148 insertions(+), 45 deletions(-)

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
@@ -65,33 +77,52 @@ static int get_dir_index_using_offset(st
 		if (err < 0)
 			break;
 
+		/* Sanity check the directory index contents */
+
+		/* size should never be larger than SQUASHFS_DISK_NAME_LEN */
+		size = le32_to_cpu(dir_index.size);
+		if (size > SQUASHFS_DISK_NAME_LEN)
+			break;
+		++ size;
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
@@ -105,7 +136,8 @@ static int squashfs_readdir(struct file
 	struct inode *inode = file_inode(file);
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	s64 block;
-	int offset, length, err;
+	int offset, err;
+	loff_t length;
 	unsigned int inode_number, dir_count, size, type;
 	struct squashfs_dir_header dirh;
 	struct squashfs_dir_entry *dire = NULL;
@@ -161,12 +193,15 @@ static int squashfs_readdir(struct file
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
@@ -183,15 +218,22 @@ static int squashfs_readdir(struct file
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
 
-			size = le16_to_cpu(dire->size) + 1;
+			length += sizeof(*dire);
+			size = le16_to_cpu(dire->size);
+
+			/* size should never be larger than SQUASHFS_DISK_NAME_LEN */
+			if (size > SQUASHFS_DISK_NAME_LEN)
+				goto failed_read;
 
-			/* size should never be larger than SQUASHFS_NAME_LEN */
-			if (size > SQUASHFS_NAME_LEN)
+			if (!squashfs_dir_space(inode, length, ++ size))
 				goto failed_read;
 
 			err = squashfs_read_metadata(inode->i_sb, dire->name,
@@ -199,7 +241,7 @@ static int squashfs_readdir(struct file
 			if (err < 0)
 				goto failed_read;
 
-			length += sizeof(*dire) + size;
+			length += size;
 
 			if (ctx->pos >= length)
 				continue;
--- a/fs/squashfs/namei.c~squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks
+++ a/fs/squashfs/namei.c
@@ -61,59 +61,98 @@
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
 
 	if (i_count == 0)
 		goto out;
 
-	index = kmalloc(sizeof(*index) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
-	if (index == NULL) {
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
+	dir_index = kmalloc(sizeof(*dir_index) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
+	if (dir_index == NULL) {
 		ERROR("Failed to allocate squashfs_dir_index\n");
 		goto out;
 	}
 
 	for (i = 0; i < i_count; i++) {
-		err = squashfs_read_metadata(sb, index, &index_start,
-					&index_offset, sizeof(*index));
+		err = squashfs_read_metadata(sb, dir_index, &index_start,
+					&index_offset, sizeof(*dir_index));
 		if (err < 0)
 			break;
 
+		/* Sanity check the directory index contents */
+
+		/* size should never be larger than SQUASHFS_DISK_NAME_LEN */
+		size = le32_to_cpu(dir_index->size);
+		if (size > SQUASHFS_DISK_NAME_LEN)
+			break;
+		++ size;
 
-		size = le32_to_cpu(index->size) + 1;
-		if (size > SQUASHFS_NAME_LEN)
+		/* The stored index should not be larger than max_index */
+		index = le32_to_cpu(dir_index->index);
+		if (index > max_index)
 			break;
 
-		err = squashfs_read_metadata(sb, index->name, &index_start,
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
+	*next_offset = ((u64)length + *next_offset) % SQUASHFS_METADATA_SIZE;
+	kfree(dir_index);
 out:
 	/*
 	 * Return index (f_pos) of the looked up metadata block.  Translate
@@ -135,7 +174,8 @@ static struct dentry *squashfs_lookup(st
 	struct squashfs_dir_header dirh;
 	struct squashfs_dir_entry *dire = NULL;
 	s64 block;
-	int offset, err, length;
+	int offset, err;
+	loff_t length;
 	unsigned int dir_count, size;
 
 	TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(dir)->start,
@@ -162,12 +202,16 @@ static struct dentry *squashfs_lookup(st
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
+			goto data_error;
+
 		err = squashfs_read_metadata(dir->i_sb, &dirh, &block,
 				&offset, sizeof(dirh));
 		if (err < 0)
@@ -184,15 +228,22 @@ static struct dentry *squashfs_lookup(st
 			/*
 			 * Read directory entry.
 			 */
+			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
+				goto data_error;
+
 			err = squashfs_read_metadata(dir->i_sb, dire, &block,
 					&offset, sizeof(*dire));
 			if (err < 0)
 				goto read_failure;
 
-			size = le16_to_cpu(dire->size) + 1;
+			length += sizeof(*dire);
+			size = le16_to_cpu(dire->size);
+
+			/* size should never be larger than SQUASHFS_DISK_NAME_LEN */
+			if (size > SQUASHFS_DISK_NAME_LEN)
+				goto data_error;
 
-			/* size should never be larger than SQUASHFS_NAME_LEN */
-			if (size > SQUASHFS_NAME_LEN)
+			if (!squashfs_dir_space(dir, length, ++ size))
 				goto data_error;
 
 			err = squashfs_read_metadata(dir->i_sb, dire->name,
@@ -200,7 +251,7 @@ static struct dentry *squashfs_lookup(st
 			if (err < 0)
 				goto read_failure;
 
-			length += sizeof(*dire) + size;
+			length += size;
 
 			if (name[0] < dire->name[0])
 				goto exit_lookup;
--- a/fs/squashfs/squashfs_fs.h~squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks
+++ a/fs/squashfs/squashfs_fs.h
@@ -32,6 +32,9 @@
 /* Max length of filename (not 255) */
 #define SQUASHFS_NAME_LEN		256
 
+/* Max on-disk length of filename */
+#define SQUASHFS_DISK_NAME_LEN		255
+
 /* Max value for directory header count*/
 #define SQUASHFS_DIR_COUNT		256
 
--- a/fs/squashfs/squashfs_helpers.h~squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks
+++ a/fs/squashfs/squashfs_helpers.h
@@ -352,4 +352,11 @@ static inline s64 squashfs_add_indexes(u
 
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

