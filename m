Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406619;
	b=kTcn+xPVi0Aji8IbJSfpGRBeIt4QwOFNJbOhha7a/1qn08HgIiDgK0WQFm1ExLqdpFyI
	 50jUV0Ysw+1jXGZPi4CTLj8CwK8HQbzaH2cYur46Udcl1YEfK4KLVkGOO109BNROkOvwI
	 ayBAiBi1lz19FQhCGXkH4NeuaTRIzAKf70GgDNGs1Z0Fb66Ljz3Wu4cKow5U8rcm1ByJw
	 OXxCQN3BJnau3mphwVBygwLJ0mZInRV3IA1cOq9HRxwN6xpiq199Fgtjho1h5W3hUl5IW
	 dpFW7+iAQWlceOuIlM/s/9LNvy2SNxh7L5mP3hpe6p//njuwoxPrwNXUwiosaAAk2Tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406619;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=wRmgd1KRXGhU9T5TN6zNMgt3SRcysHZCVfrXkKSLYbw=;
	b=wFajPc26iOLtIJZ0iy7bd3uhB5p+DxBX+V+idSidfQjjCR40/tNoUOrujugq5riAtFFC
	 spirHDqp9b1cFtq6/ud0w42dXtQx2clkVs9AOHTvvh4Eu53eTkK9UXgUx8/fAYwMxozkc
	 tfe0n6cF7THgLpmER1z88nGXcmPvh7CQ4vz8Oos1Qro70D+ONsMWsPjkCogHQ6gedhshG
	 TJdYuJjY8LCEQDaYW8ALQpDC5M5fG4dYqtBPIcn1QoAnAt7Z6zpRfAh4jDGVCUCvcl1+m
	 nGhJzrbqPE6+y4nMnjpXLyAW6pdQUC5nihODVBwUaLMmPsf2HlpaN6hq/HHe1PQn/eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lQla8jCW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7600A606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lQla8jCW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7671F000D8;
	Mon, 23 Nov 2026 04:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406618;
	bh=wRmgd1KRXGhU9T5TN6zNMgt3SRcysHZCVfrXkKSLYbw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=lQla8jCWqidcMJ/CevfMmLt5rrUNnYVCj8MxoC8rC/q1ruVqla2sEXHP1wjl4TJup
	 Np5y6civd48UyPSWBfAZNkuaPBdSQ0ToS44nBcaffHa+PPyCxn/1FJHBp7Q9f/2xuP
	 TCBZZ8tX0oWYpeuNIywgdCApXv9iEFMMN8hbbAwk=
Date: Sun, 22 Nov 2026 20:03:38 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261111234402.252354-9-phillip@squashfs.org.uk>
References: <20261111234402.252354-9-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch removed from -mm tree
Message-Id: <20261123040338.CB7671F000D8@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: fix fragment bytes overflow on 32-bit architectures
has been removed from the -mm tree.  Its filename was
     squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: fix fragment bytes overflow on 32-bit architectures
Date: Wed, 11 Nov 2026 23:43:48 +0000

In helper function squashfs_fragment_bytes() the u32 fragments
variable is multiplied by sizeof(struct squashfs_fragment_enty).

On a 32-bit architecture the type of sizeof() is a 32-bit unsigned
integer, which means the computation will overflow for fragments
values above 268435455.

The knock-on effect is the size of the in memory fragment index
table will be incorrectly computed, and a much smaller than expected
index table will be allocated and read into memory.

Later when a fragment index beyond this is looked up in this table,
this will produce an out of bounds access.

The fix is to explicitly widen the fragments variable to a long long
in the squashfs_fragment_bytes() helper function.

Reproducer
=========

The following script when run on a 32-bit x86 kernel (which lacks
KASAN support) will produce an I/O error.  On a 32-bit ARM kernel
with KASAN enabled, the out of bounds access will also produce a
KASAN report.

[  193.817260] ==================================================================
[  193.818057] BUG: KASAN: slab-out-of-bounds in squashfs_frag_lookup+0x23c/0x264
[  193.820408] Read of size 8 at addr cc126708 by task stat/357
[  193.820720]
[  193.821675] CPU: 3 UID: 0 PID: 357 Comm: stat Not tainted 7.2.0-13187-g66498c75b4f8 #113 VOLUNTARY

=================================================================
#!/bin/bash

ARGS="-no-duplicates -no-sparse -no-hardlinks -quiet -no-progress"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

# Create a Squashfs filesystem with 1026 files and 513 fragments.
# This will create a two entry Squashfs fragment index table.
#
DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

# Create a Squashfs pseudo file which is fed to Mksquashfs
echo Create a Squashfs pseudo file which is fed to Mksquashfs

dd if=/dev/urandom of=urandom bs=1024 count=50 status=none
for i in $(seq 1 1026); do
	echo "$i l urandom" >> pseudo
done

# Create the Squashfs filesystem
echo Create the Squashfs filesystem

if ! mksquashfs - img.sqsh -pf pseudo -p "/ d 0777 0 0" $ARGS; then
	echo Failed to create Squashfs filesystem
	finish

fi

# The fragments field (fragment count) in the superblock is at offset
# 16 bytes.
#
# Over-write the fragments count with 268,435,457 little-endian.  On a
# 32-bit architecture, this when multiplied by 16 will overflow, giving
# the value 16.
#
# Ultimately this will cause the kernel code to create and read a single
# entry index table (where in fact the table has two entries).
#
# Then stating file 999 which has a fragment id in the second index,
# will cause an out of bounds access.

# Write 268,435,457 in little-endian format to file
/usr/bin/echo -en "\x01\x00\x00\x10" > file

# Over-write the fragments count in the superblock
echo Over-write the fragments count in the superblock

dd bs=1 seek=16 if=file of=img.sqsh count=4 conv=notrunc status=none

# Mount the filesystem to /mnt
echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

# Stat file 999
echo Stat file 999

stat /mnt/999

popd 2>&1 > /dev/null

rm -rf $DIR
=================================================================

Link: https://patch.msgid.link/20261111234402.252354-9-phillip@squashfs.org.uk
Fixes: ffae2cd73a9e ("Squashfs: header files")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>

 fs/squashfs/squashfs_helpers.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/squashfs_helpers.h~squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures
+++ a/fs/squashfs/squashfs_helpers.h
@@ -55,7 +55,7 @@ static inline s64 squashfs_mkinode(u32 s
 /* fragment and fragment table defines */
 static inline s64 squashfs_fragment_bytes(u32 fragments)
 {
-	return fragments * sizeof(struct squashfs_fragment_entry);
+	return (s64) fragments * sizeof(struct squashfs_fragment_entry);
 }
 
 static inline s32 squashfs_fragment_index(u32 fragments)
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

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
a.patch

