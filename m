Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510639;
	b=zkX9n8sQi/Tqw1Syl2B4UlEps6kC8EPzeoB9l/OTsyVfLf9v7tT08E+QSxxObkBJYrRl
	 l5U+/3UHw5OC/88sAwZ99RtNQq7PPgfMZNUfwWdJf6s9ctFWaEChIPminrByrGr1SsE1I
	 2BX3UzglrpOGhSaUUsQFZyolCfvY8eSvSzuyAUfLAr7JSu5lXSQLtQmjaO2UfVXsfdfxq
	 oyO7qowTeRosaKhwOxFrNqIoHG3iMe4rxBpFw5JheTK0VxiA0k5BtxEaNvP4b3uoAMLal
	 sUZWOpy55Z8DjVLfEOIHAUNwUOY/2CKswmZXT1ULcpSC5sym0IYyDfXt8tBJy2is0tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510639;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nZCA8dD0wAR5MHHyHUQ0aMA8vLN7j8HBD6hQWZF0GsY=;
	b=kONdBKHBEUq3KEEdj781X0aJD6PV2yVFB7guKnscLK5HSswKj71rn+QQv/KfMHfDMdrN
	 97wQKO/Lfnw6jtAcv8Xaro+TZH3KHjCqHnCUJSyHuLSNsDQ6CeDreDxSPJ57lAM4SVjPs
	 6SZCGE1SwqxDYZ8wM8f5grinzhkpmlSRc3gkMAwAvKKxKA25Mo2B5fGAowKB630gDy7dC
	 pFllVSd/mFQjDZ5cqDG/HvfJXzHDvHNvlCxVFMktfky7QiZCN++CmMd9IW1MuC77Kcfqc
	 esuaNDrvxRPPD01QUR4Qw1g+f2Pkx1KM2MEb3XnsgpWZioZqDmKUpkduWNKEQLwdrjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WPIozNVt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED14606A331
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 19:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WPIozNVt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987521F000C4;
	Thu, 12 Nov 2026 19:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794510639;
	bh=nZCA8dD0wAR5MHHyHUQ0aMA8vLN7j8HBD6hQWZF0GsY=;
	h=Date:To:From:Subject;
	b=WPIozNVtTqYvaZT7fc/dO/QdyCxyhRQftZfnW9tJZqJ6mGWxi8zLVudiCOEsrAlAn
	 WjlUHWNC6jSCHc//0ncoBrZhcR+e9/Iy9i81IHcwTJIhGoZAxakIer5R6PxROACVMi
	 gcpMEozKv60ngpOHJETe9a5n8fh+UNwzM0l5fFsk=
Date: Thu, 12 Nov 2026 11:10:39 -0800
To: mm-commits@vger.kernel.org,phillip.lougher@gmail.com,
	phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch added to mm-nonmm-unstable branch
Message-Id: <20261112191039.987521F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: fix fragment bytes overflow on 32-bit architectures
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch

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

Link: https://lore.kernel.org/20261111234402.252354-9-phillip@squashfs.org.uk
Fixes: ffae2cd73a9e ("Squashfs: header files")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
---

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

