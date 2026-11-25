Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585295;
	b=PHNTLUIIe1vlHpG3FAeizECCiZEDIxLK3whQ+swoE7haoFNFvQB/mXuvttjXbIeJ4ypt
	 Th6uqWqfLJ0G2a6Wi46F8/MunkJSw1+3KH7VDKZwE5q8b1ECXeapQaeNNTtyO0azpbEoA
	 O5i3BxtQTWs1B/jsN6tQEYPqYPrpAqBBJhYc89j21zeGunNJC5/9tb73fbKj2dZpKwTjb
	 8mMWDhz6krWpz063PYVX0e8NMZravHC9FpHtk2QnvOK9H2uS6gV8r9Y33QvTxCf26prZ0
	 a0AtXg5jAwGJuHX90FE/A7C59OTr8qMHIJ15VurWzOe0Xson0jWiEcA2+sOWT8IgLtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585295;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=64eXlF0cYerdU1vnCsaA/rl2M3g1VrjATgAC4a3uVAw=;
	b=mZdpuPK7Gd7sAInZRjG3AWE1SU7XyyOgp0wjZf5R+PF7Apir33EUohKQZdOFb5kQlv3l
	 /GeVQLwbAjlQV/HlAp0AClef0A6kB36mMqlcH5gvKT53HlzE5uK9pRw5v9io+tMeHncHX
	 aotrq7iNGBllN16DvbiyMDxTSr3BK0qiIg5z1OVHUrFfD098PZDM3AEz80V/oykHrpQzd
	 tiTeuM6SDh9r1TVEYJh6/5cz9GImn2XfJTjnt3XraLFWnugAYh0R0u/AhUkfAuv69HMc1
	 ZnEEZoT3QjmOZ7AB6eRlyBnRKMIyxccOBl4Lry1M6SXXmB8LsooGI5iEN99QgPtD5EQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=glR9KSv0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E4C606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=glR9KSv0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC901F000C4;
	Wed, 25 Nov 2026 05:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585294;
	bh=64eXlF0cYerdU1vnCsaA/rl2M3g1VrjATgAC4a3uVAw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=glR9KSv0GNb02BpCVddfu4xHxncmex7ouGTmACdWmviKrtZ1xEyLWGehHf2/x3NYK
	 9vcHRG+7kfyxs9Ul4J8exzVRufnb2zpFZTH9hIn/eqnatkSoo1GxO35hkrI/nrMrHH
	 rXz0q8UvCjvVxvxdLOjryItOzzKonXvL8Bg9oLuI=
Date: Tue, 24 Nov 2026 21:41:33 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-10-phillip@squashfs.org.uk>
References: <20261123034304.261742-10-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-fix-fragment-bytes-overflow-on-32-bit-architectures.patch removed from -mm tree
Message-Id: <20261125054134.5DC901F000C4@smtp.kernel.org>
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
Date: Mon, 23 Nov 2026 03:42:50 +0000

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

Link: https://patch.msgid.link/20261123034304.261742-10-phillip@squashfs.org.uk
Fixes: ffae2cd73a9e ("Squashfs: header files")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

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

