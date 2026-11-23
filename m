Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406633;
	b=xAi+B2X6VCju7slTm8i0HFAQFLTSd9ZDAiqtH2irjNmZHtE3gEBQik3Qu62Ed9KEvzNE
	 kvnD5MUsT5YT+7UNqVF3XEkR2AE1U0V4pLXEJbji4ZhKctySUUEnJBZf/gf/YfxGBUz5u
	 wc115IcWGtppWJTKqGdz13XPt/Ur2ovBUECVRR0vYPlWkKA4W+wpeWxpPuYMPUTfd9KfK
	 qCqnxL0Y1CHtkfHz9hFKFvd0ZDovlgnpcTByz1QJI0QKEpXnWfugMJfIeFvdA+8wnKVQs
	 fvLVEaboLBXWWQZsXNMw9yXX4q6N7+fq/uFQjPhm5OmJzQjdLkMcTHM/9eCjYq+XP2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406633;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=FyMeiAQIwu2UdEd+ZS5azybCF6I/OsRNUDBB+0m5yIk=;
	b=J5t2eOprHUX3VcdMr6BUQhqkZizUtfgewI3nhY4kwEXYow0ENR93iaICsETvUBTZP2bi
	 up45VpSvzUNSkpOJxGGiP0suyDP14CQTx9J7onu7uDkFG1DC382gGXC5hX38oMVre97T5
	 FLx+8j1LOGgO1kt0shvhgdPQPeeGT0VASCKWUtwJ+dR1cK9rXekoNFJdtYJNr/YN6m6th
	 qfmH2ojc0w//wiTdKjr1aO3EDwbcluMg6oQxv25YC4Hu8DNs+9B4pQlcdTdf+nIuOP7W3
	 rjyHqoFrnwiJJz4vJSCgzakREtIfRD5tpDWFLyC7Hr5l1YHYkUnvth/RMrcs8AaPqYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y28vzRDH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B633606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Y28vzRDH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315931F000C4;
	Mon, 23 Nov 2026 04:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406633;
	bh=FyMeiAQIwu2UdEd+ZS5azybCF6I/OsRNUDBB+0m5yIk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Y28vzRDHjmOjI+AK1kl3yCy/UkBfcwfXqyPIpa2+M/xZSCkXLryu1NxBeI02o6+v6
	 vEK2eIq2oqtIHan3Rm0uf8k8k2gwYi9AHiOrfrdYndN3eEJk2kuKeBdX4AxDBLAKZ0
	 qkt9QDH+rX0rotA8fcOH7njhzezVXIa08bxrs6j8=
Date: Sun, 22 Nov 2026 20:03:52 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261111234402.252354-16-phillip@squashfs.org.uk>
References: <20261111234402.252354-16-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-sanity-check-fragment-block-location-and-range.patch removed from -mm tree
Message-Id: <20261123040353.315931F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: sanity check fragment block location and range
has been removed from the -mm tree.  Its filename was
     squashfs-sanity-check-fragment-block-location-and-range.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: sanity check fragment block location and range
Date: Wed, 11 Nov 2026 23:43:55 +0000

When reading fragment blocks from disk the location and range of the
fragment block is not sanity checked before it is passed down to
squashfs_read_data().

In squashfs_read_data() the block location and range are sanity checked
to the extent that the location plus block length does not go beyond the
end of the filesystem.  But, a block location can be crafted to be close
to 2^64, and so the addition of the location and the length can cause
arthimetic overflow, and thereby evade the sanity check.

This evasion, however, will be caught when the code after the sanity
check tries to read the block from the filesystem.  This is because
it is the block location that is passed to the I/O read, and not
the result of the overflowed sanity check.  This will return error
because it will be beyond the end of the device.

The real issue here is that leaving the sanity checking of the fragment
block location and range to squashfs_read_data() is sub-optimal.  This
is because a fragment cache buffer has to be obtained (with possible
waits fop a free buffer, and then the eviction of the original cached
contents) before squashfs_read_data() is called.

This adds unnecessary overhead and contention, which could be exploited
to reduce performance, and this is for incorrect values that should have
been detected earlier.

This commit adds extra sanity checking to ensure the fragment block
location and range are within bounds before a free fragment block is
obtained.

Reproducer
==========

The reproducer generates a Squashfs filesytem with a fragment block, and
then corrupts the location of the fragment block to 2^64 - 32 KiB.  If
the exploit succeeds this corrupted value is paased to
squaashfs_read_data() and it is not detected until the I/O read fails.

=====================================================================

ARGS="-quiet -no-progress -noI -noD -noF -no-sparse -comp gzip"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

echo Create Squashfs filesystem with one file

echo "/ d 0777 0 0" > pseudo
echo "zero f 0777 0 0 dd if=/dev/zero bs=1024 count=32 2>/dev/null" >> pseudo

if ! mksquashfs - img.sqsh -pf pseudo $ARGS; then
	echo Failed to create Squashfs filesystem
	finish

fi

echo "Corrupt the location of fragment block 0"
echo "Alter it to the value 0xFFFFFFFFFFFF8000 (2^64 - 32 KiB)"
echo "The block location is stored at byte offset 32958"

/usr/bin/echo -en "\x00\x80\xff\xff\xff\xff\xff\xff" > file
dd if=file of=img.sqsh seek=32958 bs=1 count=8 conv=notrunc status=none

echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

echo Read the file zero.
echo If the exploit succeeds, dmesg should show the following:
echo "dd: attempt to access beyond end of device"
echo "	loop20: rw=2048, sector=36028797018963904, nr_sectors = 64 limit=72"
echo "SQUASHFS error: Failed to read block 0xffffffffffff8000: -5"
echo "SQUASHFS error: Unable to read fragment cache entry [ffffffffffff8000]"
echo "SQUASHFS error: Unable to read fragment cache entry [ffffffffffff8000]"
echo "SQUASHFS error: Unable to read page, block ffffffffffff8000, size 1008000"

dd if=/mnt/zero

popd 2>&1> /dev/null

rm -rf $DIR
=========================================================================

Link: https://patch.msgid.link/20261111234402.252354-16-phillip@squashfs.org.uk
Fixes: f400e12656ab ("Squashfs: cache operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>

 fs/squashfs/cache.c            |    7 +++++--
 fs/squashfs/file.c             |    8 ++++++--
 fs/squashfs/fragment.c         |    5 +++--
 fs/squashfs/inode.c            |   12 ++++--------
 fs/squashfs/squashfs.h         |    3 ++-
 fs/squashfs/squashfs_helpers.h |   24 ++++++++++++++++++++++--
 6 files changed, 42 insertions(+), 17 deletions(-)

--- a/fs/squashfs/cache.c~squashfs-sanity-check-fragment-block-location-and-range
+++ a/fs/squashfs/cache.c
@@ -490,9 +490,12 @@ struct squashfs_cache_entry *squashfs_ge
 				u64 start_block, int length)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	int res = squashfs_check_range(start_block, length, msblk);
 
-	return squashfs_cache_get(sb, msblk->fragment_cache, start_block,
-		length);
+	if (res < 0)
+		return ERR_PTR(res);
+
+	return squashfs_cache_get(sb, msblk->fragment_cache, start_block, res);
 }
 
 
--- a/fs/squashfs/file.c~squashfs-sanity-check-fragment-block-location-and-range
+++ a/fs/squashfs/file.c
@@ -443,7 +443,7 @@ static int squashfs_readpage_fragment(st
 	struct squashfs_cache_entry *buffer = squashfs_get_fragment(inode->i_sb,
 		squashfs_i(inode)->fragment_block,
 		squashfs_i(inode)->fragment_size);
-	int res = buffer->error;
+	int res = IS_ERR(buffer) ? PTR_ERR(buffer) : buffer->error;
 
 	if (res)
 		ERROR("Unable to read page, block %llx, size %x\n",
@@ -453,7 +453,8 @@ static int squashfs_readpage_fragment(st
 		squashfs_copy_cache(folio, buffer, expected,
 			squashfs_i(inode)->fragment_offset);
 
-	squashfs_cache_put(buffer);
+	if (!IS_ERR(buffer))
+		squashfs_cache_put(buffer);
 	return res;
 }
 
@@ -519,6 +520,9 @@ static int squashfs_readahead_fragment(s
 	void *addr;
 	struct page *last_page;
 
+	if (IS_ERR(buffer))
+		return 1;
+
 	if (buffer->error)
 		goto out;
 
--- a/fs/squashfs/fragment.c~squashfs-sanity-check-fragment-block-location-and-range
+++ a/fs/squashfs/fragment.c
@@ -34,7 +34,7 @@
  * location of the fragment and its compressed size
  */
 int squashfs_frag_lookup(struct super_block *sb, unsigned int fragment,
-				u64 *fragment_block)
+				u64 *fragment_block, int *fragment_size)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	int block, offset, size;
@@ -54,7 +54,8 @@ int squashfs_frag_lookup(struct super_bl
 		return size;
 
 	*fragment_block = le64_to_cpu(fragment_entry.start_block);
-	return squashfs_frag_size(fragment_entry.size, msblk->block_size);
+	*fragment_size = le32_to_cpu(fragment_entry.size);
+	return 0;
 }
 
 
--- a/fs/squashfs/inode.c~squashfs-sanity-check-fragment-block-location-and-range
+++ a/fs/squashfs/inode.c
@@ -158,11 +158,9 @@ int squashfs_read_inode(struct inode *in
 				goto failed_read;
 			}
 			frag_offset = le32_to_cpu(sqsh_ino->offset);
-			frag_size = squashfs_frag_lookup(sb, frag, &frag_blk);
-			if (frag_size < 0) {
-				err = frag_size;
+			err = squashfs_frag_lookup(sb, frag, &frag_blk, &frag_size);
+			if (err < 0)
 				goto failed_read;
-			}
 		} else {
 			frag_blk = SQUASHFS_INVALID_BLK;
 			frag_size = 0;
@@ -215,11 +213,9 @@ int squashfs_read_inode(struct inode *in
 				goto failed_read;
 			}
 			frag_offset = le32_to_cpu(sqsh_ino->offset);
-			frag_size = squashfs_frag_lookup(sb, frag, &frag_blk);
-			if (frag_size < 0) {
-				err = frag_size;
+			err = squashfs_frag_lookup(sb, frag, &frag_blk, &frag_size);
+			if (err < 0)
 				goto failed_read;
-			}
 		} else {
 			frag_blk = SQUASHFS_INVALID_BLK;
 			frag_size = 0;
--- a/fs/squashfs/squashfs.h~squashfs-sanity-check-fragment-block-location-and-range
+++ a/fs/squashfs/squashfs.h
@@ -68,7 +68,8 @@ extern __le64 *squashfs_read_inode_looku
 				unsigned int);
 
 /* fragment.c */
-extern int squashfs_frag_lookup(struct super_block *, unsigned int, u64 *);
+extern int squashfs_frag_lookup(struct super_block *sb, unsigned int fragment,
+				u64 *fragment_block, int *fragment_size);
 extern __le64 *squashfs_read_fragment_index_table(struct super_block *,
 				u64, u64, unsigned int);
 
--- a/fs/squashfs/squashfs_helpers.h~squashfs-sanity-check-fragment-block-location-and-range
+++ a/fs/squashfs/squashfs_helpers.h
@@ -227,9 +227,9 @@ static inline int squashfs_data_size(__l
 	return squashfs_block_size(le32_to_cpu(raw), block_size);
 }
 
-static inline int squashfs_frag_size(__le32 raw, s32 block_size)
+static inline int squashfs_frag_size(u32 disk_size, s32 block_size)
 {
-	int size = squashfs_block_size(le32_to_cpu(raw), block_size);
+	int size = squashfs_block_size(disk_size, block_size);
 
 	if (size < 0)
 		return size;
@@ -239,5 +239,25 @@ static inline int squashfs_frag_size(__l
 		return -EIO;
 
 	return size;
+}
+
+static inline int squashfs_check_range(u64 start_block, s32 disk_size, struct squashfs_sb_info *msblk)
+{
+	int size = squashfs_frag_size(disk_size, msblk->block_size);
+
+	if (size < 0)
+		return size;
+
+	if (start_block >= msblk->inode_table)
+		return -EIO;
+
+	/*
+	 * the above check ensured start_block is not 2^63 or larger, and so
+	 * this addition will not overflow
+	 */
+	if (start_block + squashfs_compressed_size_block(size) > msblk->inode_table)
+		return -EIO;
+
+	return size;
 }
 #endif
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-sanity-check-block-list-sizes-and-range.patch
squashfs-dont-store-large-export-table-indexes-in-memory.patch
squashfs-dont-store-large-fragment-table-indexes-in-memory.patch
squashfs-dont-store-large-xattr-id-table-indexes-in-memory.patch
squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks.patch
squashfs-fix-regression-in-squashfs_copy_cache.patch
squashfs-check-index-isnt-greater-than-s64_max-in-squashfs_read_data.patch
a.patch

