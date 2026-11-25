Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586039;
	b=b8coUacXjCyjUawOLrnf1BJy8FSAut1V2wC0zWSzwfT/GCLc4Hda66C9sL4p2NdHpKZT
	 awSelK9dM/IDeACKEhvI/11cTjV9OdHhHSzHj6y/5soLDlmgINCt5QZzMgo0IuvUprHCt
	 RbYoDX/dQrLiVkiOj4fmbSk8qu9IBPge4aBIGpH906/VB5xH1hz0evG6W9o7DMzhWRcIU
	 2c52xMMWFKf0Z19LBIyVgFmwTdmNWXmONnqZIALY7oM1rl9h2QKK1HzmYIZdx0dNH6E+Y
	 SnNTM/rhY5VoR/1JrzgzV5JLxX/5sVDltvONXp6ZD8pPeGwtgBtLgsKIoGcdRV6vsuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586039;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=FVOnhXthF5wVTa6rb44iu2yp50HHIXLEzSMH8qh/wXw=;
	b=mQ98mESD4zU/HP27llgb/SwelGpSm7LXFhEDIxlOrDKCaotPwNSihvjEK7HRmx9M8iy3
	 +3DTun6324oaLbCBBNTvdeN0mbAOLxEYzCVog0OY3IYMwch5/T5CrZkpH66s3FqvkTu17
	 m8DBcAa0Rmmmrf1Aif2nwTK5A7ZNJbsB1eY3G9NgkEcNV2UyACD/NBPf1nRb6N1ZrRPY9
	 rIMwngUbGiMZxnRWTHMf6FoVGv4Yp9hjyxBXJTNGB9MrDSSxBLE5pu40bmQECAoveiDLX
	 BTg03DquFJAPGNIknOHpKK82x1JtWXoKoz10begDCcNNxAXGdlJ67VM2JBw6xPppMJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=N0PV8ydz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C54606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=N0PV8ydz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587461F000C4;
	Wed, 25 Nov 2026 05:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795586038;
	bh=FVOnhXthF5wVTa6rb44iu2yp50HHIXLEzSMH8qh/wXw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=N0PV8ydz5k3AQGHmbNNdVEvM11UeQeNkq+B3hSvDvH5gmNNSLw5zsrPN+76FYjGf+
	 leZ5BtqTjaHIrTXPh7TslqbPVTnxGHqVVDv2uBP/TcmYYmxmSVZAkJCJNBvQfpASAP
	 ySKE1ZPdBa5Hxgj0wDbUHHeRAq02bl1dg5HEaUGo=
Date: Tue, 24 Nov 2026 21:53:57 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125014737.347231-16-phillip@squashfs.org.uk>
References: <20261125014737.347231-16-phillip@squashfs.org.uk>
Subject: + squashfs-add-more-sanity-checking-to-squashfs_block_size.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055358.587461F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: add more sanity checking to squashfs_block_size()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-add-more-sanity-checking-to-squashfs_block_size.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-add-more-sanity-checking-to-squashfs_block_size.patch

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
Subject: Squashfs: add more sanity checking to squashfs_block_size()
Date: Wed, 25 Nov 2026 01:47:29 +0000

Squashfs_block_size() sanity checks the data and fragment block size
read from disk.  However, it doesn't do all the sanity checking that
it could do.  This means detectably invalid block sizes are passed
down to squashfs_read_data().

This situation is sub-optimal because in the case of fragment
blocks, a fragment cache buffer has to obtained (with possible
waits for a free buffer etc.) before squashfs_read_data() is called.

In both fragment and data block cases if the buffer is compressed, it
means a free decompressor may be obtained (with possible waits for a
decompressor) by squashfs_read_data(), only to have the decompression
fail.

In both these cases this adds unnecessary overhead which may impact
performance, and this is with values that should have been detected
earlier.

This commit adds extra sanity checking to trap additional incorrect
values.

Reproducer
==========

The reproducer generates a Squashfs filesystem and then corrupts the
block size value for file zero block 0.  If the exploit succeeds this
corrupted value is not detected, and it is passed to the decompressor
via squashfs_read_data() which then fails at that point.

====================================================================
#!/bin/bash

ARGS="-quiet -no-progress -no-fragments -noI -noD -no-sparse -comp gzip"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

echo Create Squashfs filesystem with one file

echo "/ d 0777 0 0" > pseudo
echo "zero f 0777 0 0 dd if=/dev/zero bs=1024 count=128 2>/dev/null" >> pseudo

if ! mksquashfs - img.sqsh -pf pseudo $ARGS; then
	echo Failed to create Squashfs filesystem
	finish

fi

echo Corrupt the data block size for block 0 in file zero
echo Flip the compression bit from uncompressed to compressed.
echo "This is at byte offset 131207 (96 + 128 KiB + 37)"

dd if=/dev/zero of=img.sqsh seek=131205 bs=1 count=1 conv=notrunc status=none

echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

echo Read the file zero.
echo If the exploit succeeds, dmesg should show the following:
echo "SQUASHFS error: zlib decompression failed, data probably corrupt"
echo "SQUASHFS error: Failed to read block 0x60: -5"
echo "SQUASHFS error: zlib decompression failed, data probably corrupt"
echo "SQUASHFS error: Failed to read block 0x60: -5"
echo "SQUASHFS error: Unable to read data cache entry [60]"
echo "SQUASHFS error: Unable to read page, block 60, size 20000"

dd if=/mnt/zero

popd 2>&1> /dev/null

rm -rf $DIR
==============================================================================

Link: https://patch.msgid.link/20261125014737.347231-16-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 fs/squashfs/file.c             |    8 ++++--
 fs/squashfs/fragment.c         |    2 -
 fs/squashfs/squashfs_fs.h      |    6 -----
 fs/squashfs/squashfs_helpers.h |   36 +++++++++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 10 deletions(-)

--- a/fs/squashfs/file.c~squashfs-add-more-sanity-checking-to-squashfs_block_size
+++ a/fs/squashfs/file.c
@@ -166,6 +166,7 @@ static long long read_indexes(struct sup
 {
 	int err, i;
 	long long block = 0;
+	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	__le32 *blist = kmalloc(PAGE_SIZE, GFP_KERNEL);
 
 	if (blist == NULL) {
@@ -185,7 +186,7 @@ static long long read_indexes(struct sup
 		}
 
 		for (i = 0; i < blocks; i++) {
-			int size = squashfs_block_size(blist[i]);
+			int size = squashfs_data_size(blist[i], msblk->block_size);
 			if (size < 0) {
 				err = size;
 				goto failure;
@@ -333,6 +334,7 @@ static int read_blocklist_ptrs(struct in
 {
 	long long blks;
 	__le32 size;
+	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 	s64 res = fill_meta_index(inode, index, start, offset, block);
 
 	TRACE("read_blocklist: res %lld, index %lld, start 0x%llx, offset 0x%x, block 0x%llx\n",
@@ -362,7 +364,7 @@ static int read_blocklist_ptrs(struct in
 			sizeof(size));
 	if (res < 0)
 		return res;
-	return squashfs_block_size(size);
+	return squashfs_data_size(size, msblk->block_size);
 }
 
 static inline int read_blocklist(struct inode *inode, s64 index, u64 *block)
@@ -720,7 +722,7 @@ static loff_t seek_hole_data(struct file
 			goto finished;
 
 		for (i = 0; i < indexes; i++) {
-			length = squashfs_block_size(blist[i]);
+			length = squashfs_data_size(blist[i], msblk->block_size);
 			if (length < 0) {
 				offset = length;
 				goto finished;
--- a/fs/squashfs/fragment.c~squashfs-add-more-sanity-checking-to-squashfs_block_size
+++ a/fs/squashfs/fragment.c
@@ -54,7 +54,7 @@ int squashfs_frag_lookup(struct super_bl
 		return size;
 
 	*fragment_block = le64_to_cpu(fragment_entry.start_block);
-	return squashfs_block_size(fragment_entry.size);
+	return squashfs_frag_size(fragment_entry.size, msblk->block_size);
 }
 
 
--- a/fs/squashfs/squashfs_fs.h~squashfs-add-more-sanity-checking-to-squashfs_block_size
+++ a/fs/squashfs/squashfs_fs.h
@@ -101,12 +101,6 @@
 #define SQUASHFS_XATTR_VALUE_OOL        256
 #define SQUASHFS_XATTR_PREFIX_MASK      0xff
 
-static inline int squashfs_block_size(__le32 raw)
-{
-	u32 size = le32_to_cpu(raw);
-	return (size >> 25) ? -EIO : size;
-}
-
 /* cached data constants for filesystem */
 #define SQUASHFS_CACHED_BLKS		8
 
--- a/fs/squashfs/squashfs_helpers.h~squashfs-add-more-sanity-checking-to-squashfs_block_size
+++ a/fs/squashfs/squashfs_helpers.h
@@ -203,4 +203,40 @@ static inline s16 squashfs_xattr_offset(
 {
 	return xattr & 0xffff;
 }
+
+static inline int squashfs_block_size(u32 size, s32 block_size)
+{
+	/* reject any size with bits set where they should not be */
+	if ((size & ~SQUASHFS_COMPRESSED_BIT_BLOCK) > block_size)
+		return -EIO;
+
+	/* a block can't be both full size and compressed */
+	if (size == block_size)
+		return -EIO;
+
+	/* a zero size block will never have SQUASHFS_COMPRESSED_BIT_BLOCK set */
+	if (size == SQUASHFS_COMPRESSED_BIT_BLOCK)
+		return -EIO;
+
+	return size;
+}
+
+static inline int squashfs_data_size(__le32 raw, s32 block_size)
+{
+	return squashfs_block_size(le32_to_cpu(raw), block_size);
+}
+
+static inline int squashfs_frag_size(__le32 raw, s32 block_size)
+{
+	int size = squashfs_block_size(le32_to_cpu(raw), block_size);
+
+	if (size < 0)
+		return size;
+
+	/* a fragment block can't be zero size */
+	if (size == 0)
+		return -EIO;
+
+	return size;
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

