Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510655;
	b=aTd8zByp4W39m14y1o8x9xAWXBFM4TT8ZqdGIsLKNw9DmfyUi3wl1RVM6ZUnrM5oHPcB
	 Q4RcrajvCs91ki8WTkJKrFnPzFriAo8IMpk+/oLhGDIEQ8AUyk9lbbwy2kP37vw4QqeJZ
	 e6i1GCgSLWQS1BLvKx05d8oiUNTclW3H1HQ+95VP+4XiqHN5VJ8Gct9zpeYxoru+lDCWK
	 Kk6JjALyyzyekhHkbsdARhYTmrqPeadGHwN1AmYDVKJVwEAEcSBuAV+hEl9eLf5Dj8AC/
	 SpMMKSqGDg+3J0nubgALv+bBv7QcKqC+ErfL/wUO/7ACj/E+wzNEjsMrt98p7QeWsuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510655;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nxblBl6KAodIyJHdvaAPSztLeW7f4gbXgwvQ4zUO0j0=;
	b=hXBUDlFe8aigsXPZDoIIeplNiTrvf2F3EjpysPciGYmGFhaWzIynUh1Ew/k8Fx22heCt
	 GqtcYmTKqFVWATs9ZiDUlAdo2ihR27C+ctWEyjK1h80qBK3EHHTGJHQHIQNBxne15w+G3
	 VTnRS+AAaxzUdWL+GhgHjVr6A6yd1B3VhxhnGYTvBfZrntdaaI4HgDyD7ZW3q80UM5qH1
	 RLXDzLvdWXkOk5XAHBsxJZ5OalXFb7UWBv1IZPbLixzauOYF7NkVrPYfXPGbyUri3hwt1
	 i99DG4gd5qeyxywiPnnrIN6te7GtlJaZGOFFn+/vJ5L5Msc/V/a2SdPiWHW4dA3A3ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HFIIomHI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C260606A31C
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 19:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HFIIomHI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677651F000C5;
	Thu, 12 Nov 2026 19:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794510655;
	bh=nxblBl6KAodIyJHdvaAPSztLeW7f4gbXgwvQ4zUO0j0=;
	h=Date:To:From:Subject;
	b=HFIIomHI/Kxjc5rTudax62SiNVImYtxpfvTjmMD2Zjp4NfFjxBi/Pso9FGJtb2Cq6
	 8DghkJE/Hbf5Op3HFjLzN/I5q0/pJBwkBjqWXL5eT8ivjWlA2sMt9UNoRPuwz2yFo6
	 FnSrlzDcSqs80ErRsI9erU8q6Dh4xKYmWU9WGnwY=
Date: Thu, 12 Nov 2026 11:10:55 -0800
To: mm-commits@vger.kernel.org,phillip.lougher@gmail.com,
	phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-very-large-files-can-exceed-an-int-block-count.patch added to mm-nonmm-unstable branch
Message-Id: <20261112191055.677651F000C5@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: very large files can exceed an int block count
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-very-large-files-can-exceed-an-int-block-count.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-very-large-files-can-exceed-an-int-block-count.patch

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
Subject: Squashfs: very large files can exceed an int block count
Date: Wed, 11 Nov 2026 23:43:53 +0000

Squashfs in many places uses a signed int to store the block number and
block count of a file.  If the block size is using the Linux page size
(normally 4 KiB), it means any file larger than 8 TiB (2^43) will
overflow a signed int.

If the block number and block count is in terms of the Squashfs
filesystem block size (which can be between 4 kiB and 1 MiB), it
depends on the block size as to when a signed int will overflow, but a
file larger than 256 TiB (2^48) using 128 KiB blocks will overflow a
signed int.

This commit widens all appropriate variables to long long (s64) to
avoid overflow.

Reproducer
==========

The following reproducer creates a Squashfs filesystem with a 8 TiB +
4096 byte sparse file.  The filestem is mounted, and the last 4096
bytes are read from the file.  If the reproducer is successful the
process will hang.  This is because signed int overflow occurs in
squashfs_copy_cache() with the result that folio_end_read() is
not called.

====================================================================

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

echo "Create an 8 Tib (2^43) + 4096 byte sparse file"

if ! truncate --size 8796093026304 bigfile; then
	echo Create of sparse file failed.
	finish
fi

echo Generate the Squashfs filesystem containing the sparse file
echo This will be VERY slow on Squashfs-tools older than 4.7.3

mksquashfs bigfile bigfile.sqsh -b 1M -quiet

echo Mount the filesystem to /mnt

if ! mount -t squashfs bigfile.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

echo Read the last 4096 bytes from the sparse file.
echo If the exploit succeeds the process will hang

dd if=/mnt/bigfile bs=1 skip=8796093022208

popd 2>&1 > /dev/null
rm -rf $DIR
exit 0
====================================================================

Link: https://lore.kernel.org/20261111234402.252354-14-phillip@squashfs.org.uk
Fixes: 1701aecb6849 ("Squashfs: regular file operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
---

 fs/squashfs/file.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

--- a/fs/squashfs/file.c~squashfs-very-large-files-can-exceed-an-int-block-count
+++ a/fs/squashfs/file.c
@@ -35,6 +35,7 @@
 #include <linux/string.h>
 #include <linux/pagemap.h>
 #include <linux/mutex.h>
+#include <linux/math64.h>
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
@@ -160,7 +161,7 @@ static void release_meta_index(struct in
  * Read the next n blocks from the block list, starting from
  * metadata block <start_block, offset>.
  */
-static long long read_indexes(struct super_block *sb, int n,
+static long long read_indexes(struct super_block *sb, s64 n,
 				u64 *start_block, int *offset)
 {
 	int err, i;
@@ -173,7 +174,7 @@ static long long read_indexes(struct sup
 	}
 
 	while (n) {
-		int blocks = min_t(int, n, PAGE_SIZE >> 2);
+		int blocks = min_t(s64, n, PAGE_SIZE >> 2);
 
 		err = squashfs_read_metadata(sb, blist, start_block,
 				offset, blocks << 2);
@@ -216,7 +217,7 @@ failure:
  */
 static inline int calculate_skip(u64 blocks)
 {
-	u64 skip = blocks / ((SQUASHFS_META_ENTRIES + 1)
+	u64 skip = div_u64(blocks, (SQUASHFS_META_ENTRIES + 1)
 		 * SQUASHFS_META_INDEXES);
 	return min((u64) SQUASHFS_CACHED_BLKS - 1, skip + 1);
 }
@@ -227,7 +228,7 @@ static inline int calculate_skip(u64 blo
  * on-disk locations of the datablock and block list metadata block
  * <index_block, index_offset> for index (scaled to nearest cache index).
  */
-static int fill_meta_index(struct inode *inode, int index,
+static s64 fill_meta_index(struct inode *inode, s64 index,
 		u64 *index_block, int *index_offset, u64 *data_block)
 {
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
@@ -243,7 +244,7 @@ static int fill_meta_index(struct inode
 	/*
 	 * Scale index to cache index (cache slot entry)
 	 */
-	index /= SQUASHFS_META_INDEXES * skip;
+	index = div_u64(index, SQUASHFS_META_INDEXES * skip);
 
 	while (offset < index) {
 		meta = locate_meta_index(inode, offset + 1, index);
@@ -315,7 +316,7 @@ all_done:
 	/*
 	 * Scale cache index (cache slot entry) to index
 	 */
-	return offset * SQUASHFS_META_INDEXES * skip;
+	return (s64)offset * SQUASHFS_META_INDEXES * skip;
 
 failed:
 	release_meta_index(inode, meta);
@@ -327,14 +328,14 @@ failed:
  * Get the on-disk location and compressed size of the datablock
  * specified by index.  Fill_meta_index() does most of the work.
  */
-static int read_blocklist_ptrs(struct inode *inode, int index, u64 *start,
+static int read_blocklist_ptrs(struct inode *inode, s64 index, u64 *start,
 	int *offset, u64 *block)
 {
 	long long blks;
 	__le32 size;
-	int res = fill_meta_index(inode, index, start, offset, block);
+	s64 res = fill_meta_index(inode, index, start, offset, block);
 
-	TRACE("read_blocklist: res %d, index %d, start 0x%llx, offset 0x%x, block 0x%llx\n",
+	TRACE("read_blocklist: res %lld, index %lld, start 0x%llx, offset 0x%x, block 0x%llx\n",
 				res, index, *start, *offset, block ? *block : 0);
 
 	if (res < 0)
@@ -364,7 +365,7 @@ static int read_blocklist_ptrs(struct in
 	return squashfs_block_size(size);
 }
 
-static inline int read_blocklist(struct inode *inode, int index, u64 *block)
+static inline int read_blocklist(struct inode *inode, s64 index, u64 *block)
 {
 	u64 start;
 	int offset;
@@ -397,8 +398,8 @@ void squashfs_copy_cache(struct folio *f
 	struct address_space *mapping = folio->mapping;
 	struct inode *inode = mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	int i, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
-	int start_index = folio->index & ~mask, end_index = start_index | mask;
+	s64 i, mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
+	s64 start_index = folio->index & ~mask, end_index = start_index | mask;
 
 	/*
 	 * Loop copying datablock into pages.  As the datablock likely covers
@@ -412,7 +413,7 @@ void squashfs_copy_cache(struct folio *f
 		size_t avail = buffer ? min(bytes, PAGE_SIZE) : 0;
 		bool updated = false;
 
-		TRACE("bytes %zu, i %d, available_bytes %zu\n", bytes, i, avail);
+		TRACE("bytes %zu, i %lld, available_bytes %zu\n", bytes, i, avail);
 
 		push_folio = (i == folio->index) ? folio :
 			__filemap_get_folio(mapping, i,
@@ -464,8 +465,8 @@ static int squashfs_read_folio(struct fi
 {
 	struct inode *inode = folio->mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	int index = folio->index >> (msblk->block_log - PAGE_SHIFT);
-	int file_end = i_size_read(inode) >> msblk->block_log;
+	s64 index = folio->index >> (msblk->block_log - PAGE_SHIFT);
+	s64 file_end = i_size_read(inode) >> msblk->block_log;
 	int expected = index == file_end ?
 			(i_size_read(inode) & (msblk->block_size - 1)) :
 			 msblk->block_size;
@@ -584,7 +585,7 @@ static void squashfs_readahead(struct re
 	unsigned int nr_pages = 0;
 	struct page **pages;
 	int i;
-	loff_t file_end = i_size_read(inode) >> msblk->block_log;
+	s64 file_end = i_size_read(inode) >> msblk->block_log;
 	unsigned int max_pages = 1UL << shift;
 
 	readahead_expand(ractl, start, (len | mask) + 1);
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

