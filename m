Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586032;
	b=T2vdiDNzU/9nW9Q4nZq/VXCJci1zFmhaJosJIJ074tC3phrlenYVwZPr/qn4pRLSRrCH
	 b4artSJk8xlsCc+H0dfUDRPgS8wmgB1O2CeLu8glH4LVTqMtjHsehhby04grrKhqrGOaL
	 6H6SaWpvWfgBVQnPFbGL18dffPRSUL0bcot1k6b9mPHC7RPEXKGp5LqJwzi1etb0Usqeg
	 d6jyAdp4tSIQqDMOvP5YQlhSHM592/HbEwvrjP7rorlSEQoQ35hhJ3NxVapTLSkAGYvaU
	 8mq6cyVSPoE7KMJB6DiAAeneDgoCb4AAyBUJ0eSwRvCVqc6Mz649C/McEzFIUcGaChQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586032;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Pyhw30H0hs8EwDkEhA/wy7kzuvdaku/daBMLc5ukwOM=;
	b=gPOY7skRdClM6ng9MYXBn8cPsAhK1MJU3/MVXpbbFjYDnespZ30Cozf8t+Rzv1Lr2/Ki
	 cEVN0J2/PD+yKqMjlHCw7jtPfbvO8SxIThgrQ8tMCMwi1F8X1I5BfxLvY5uKozbFmarHM
	 gjOoDeg33ta5pnsIKeb9TqzjkkdGelI1fYjEE66Xe87pbXioVEG+021q9OJ9Rg7Ry5Z/e
	 ty4d8Kuox3zNRnRqPpW0BpLfJ6mPmSft4MK+fFNSsaScJrPOG0nAivKQw2smOMcDqbeFC
	 MnpKG89oUBLBhipmd1NA2wJTn7CINf/wmyLECwzR9qzGg9KbL85kjZTF5c3zoGwyJ9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=onkq7hY+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227BD606A32C
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=onkq7hY+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BAB11F000CA;
	Wed, 25 Nov 2026 05:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795586031;
	bh=Pyhw30H0hs8EwDkEhA/wy7kzuvdaku/daBMLc5ukwOM=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=onkq7hY+LdT6xhFP3xozl5ty0XE/hgRJ3wV7MSRpiAiPHLdEcZin/2B2bGd0bzTDM
	 kLfjlmH5xPybdDgon3TbEu+i7rOrucz2z62Z6KmeSTu4Y3LVp158hRXn4Q+430RLEh
	 F26FC1beEFcjq+wJinMOYptk5PJ0lOMFmn+s0btM=
Date: Tue, 24 Nov 2026 21:53:50 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125014737.347231-14-phillip@squashfs.org.uk>
References: <20261125014737.347231-14-phillip@squashfs.org.uk>
Subject: + squashfs-widen-xattr-count-variables-and-add-sanity-check.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055351.0BAB11F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: widen xattr count variables and add sanity check
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-widen-xattr-count-variables-and-add-sanity-check.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-widen-xattr-count-variables-and-add-sanity-check.patch

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
Subject: Squashfs: widen xattr count variables and add sanity check
Date: Wed, 25 Nov 2026 01:47:27 +0000

The maximum number of Xattrs in an inode is 2^32-1 in Squashfs.  However
the code incorrectly treats the count as signed, or 2^31-1.

This means any value above 2^31-1 becomes a negative number, and it
means loops will not terminate due to the negative comparison.  This
means the code will continue reading the filesystem until either the
data is incorrect, or the end of the filesystem is reached.

The code also lacks a check that the count is too large, which will
again mean that the code will continue reading the filesystem.

Finally, the code also lacks a check for a zero count, this means
anything reading xattrs from the inode will successfully read no xattrs,
even though this should have returned error due to corruption.

This commit changes the variables to be unsigned, and so negative values
do not occur, and it first adds a sanity check for a zero xattr count,
and second checks that the count isn't larger than the xattr size.

Reproducer
==========

This reproducer allows both zero, negative and large xattr count to be
reproduced.  In the case of a negative or large count, the exploit
succeeds if dmesg shows the code failed to read a metadata block, due to
the loop not terminating.  In the case of a zero count, the exploit
succeeds if gerfattr successfully returns with no xattrs.

====================================================================
#!/bin/bash

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

if [ $# -lt 1 ]; then
	echo This needs a parameter
	echo $0 N/0/L 
	echo N reproduce negative xattr count
	echo 0 reproduce 0 xattr count
	echo L reproduce a large count
	exit 1
fi

if [ $1 = "N" ]; then
	echo Reproducing negative xattr count
elif [ $1 = "0" ]; then
	echo Reproducing 0 xattr count
elif [ $1 = "L" ]; then
	echo Reproducing large xattr count
else
	echo Input not N, 0 or L
	exit 1
fi

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

# Create a Squashfs pseudo file which is fed to Mksquashfs
echo Create a Squashfs pseudo file which is fed to Mksquashfs

echo "/ d 0777 0 0" > pseudo
echo "example f 0777 0 0 echo example data" >> pseudo
echo "example x user.comment=example xattr" >> pseudo

# Generate the Squashfs filesystem
echo Generate the Squashfs filesystem

mksquashfs - img.sqsh -pf pseudo -quiet -no-progress -noX

# The xattr_id_table_start is at offset 56 in the superblock, 32-bit little-endian.
# For such a small filesystem, we only need to read the first two bytes.
low=$(dd if=img.sqsh bs=1 skip=56 count=1 status=none | od -An -v -tu1 | tr -d '\n')
hi=$(dd if=img.sqsh bs=1 skip=57 count=1 status=none | od -An -v -tu1 | tr -d '\n')
start=$(( $hi * 256 + $low ))

# The start of the single xattr id is 16 bytes before the xattr_id_table, and the
# count field is 8 bytes before
(( start -= 8 ))

if [ $1 = "N" ]; then
	# Write -1 to the count field
	echo Writing -1 to the count field
	echo -ne "\xff\xff\xff\xff" > file
elif [ $1 = "0" ]; then
	# Write 0 to the count field
	echo Writing 0 to the count field
	echo -ne "\x00\x00\x00\x00" > file
else
	# Write 255 to the count field
	echo Writing 255 to the count field
	echo -ne "\xff\x00\x00\x00" > file
fi

dd if=file of=img.sqsh bs=1 seek=$start count=4 conv=notrunc status=none

# Mount the filesystem to /mnt
echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

if [ $1 = "0" ]; then
	if ! getfattr /mnt/example > output; then
		echo Exploit failed, getfattr returned error
	elif [ ! -s output ]; then
		echo Exploit succeeded, getfattr returned success with no xattrs
	else
		echo Getfattr succeeded with some xattrs.  The filesystem was not corrupted
	fi
else
	if ! getfattr /mnt/example; then
		echo Getfattr failed, this is expected.
		echo If dmesg shows the following, then the exploit succeeded
		echo SQUASHFS error: Failed to read block 0x124: -5
		echo SQUASHFS error: Unable to read metadata cache entry [122]
	else
		echo Getfattr succeeded with some xattrs.  The filesystem was not corrupted
	fi
fi

popd 2>&1 > /dev/null
rm -rf $DIR
exit 0
====================================================================

Link: https://patch.msgid.link/20261125014737.347231-14-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 fs/squashfs/inode.c         |    2 +-
 fs/squashfs/squashfs_fs_i.h |    2 +-
 fs/squashfs/xattr.c         |   27 ++++++++++++++++++++-------
 fs/squashfs/xattr.h         |    6 +++---
 fs/squashfs/xattr_id.c      |    3 ++-
 5 files changed, 27 insertions(+), 13 deletions(-)

--- a/fs/squashfs/inode.c~squashfs-widen-xattr-count-variables-and-add-sanity-check
+++ a/fs/squashfs/inode.c
@@ -460,7 +460,7 @@ int squashfs_read_inode(struct inode *in
 		inode->i_blocks += ((squashfs_i(inode)->xattr_size - 1) >> 9)
 				+ 1;
 	} else
-		squashfs_i(inode)->xattr_count = 0;
+		squashfs_i(inode)->xattr = SQUASHFS_INVALID_BLK;
 
 	return 0;
 
--- a/fs/squashfs/squashfs_fs_i.h~squashfs-widen-xattr-count-variables-and-add-sanity-check
+++ a/fs/squashfs/squashfs_fs_i.h
@@ -15,7 +15,7 @@ struct squashfs_inode_info {
 	int		offset;
 	u64		xattr;
 	unsigned int	xattr_size;
-	int		xattr_count;
+	unsigned int	xattr_count;
 	int		parent;
 	union {
 		struct {
--- a/fs/squashfs/xattr.c~squashfs-widen-xattr-count-variables-and-add-sanity-check
+++ a/fs/squashfs/xattr.c
@@ -33,13 +33,16 @@ ssize_t squashfs_listxattr(struct dentry
 	u64 start = squashfs_xattr_blk(squashfs_i(inode)->xattr)
 						+ msblk->xattr_table;
 	int offset = squashfs_xattr_offset(squashfs_i(inode)->xattr);
-	int count = squashfs_i(inode)->xattr_count;
+	unsigned int count = squashfs_i(inode)->xattr_count;
 	size_t rest = buffer_size;
 	int err;
 
-	/* check that the file system has xattrs */
-	if (msblk->xattr_id_table == NULL)
-		return -EOPNOTSUPP;
+	/* check that the file has xattrs */
+	if (squashfs_i(inode)->xattr == SQUASHFS_INVALID_BLK)
+		return 0;
+
+	if (count == 0 || count > squashfs_i(inode)->xattr_size)
+		return -EIO;
 
 	/* loop reading each xattr name */
 	while (count--) {
@@ -111,12 +114,21 @@ static int squashfs_xattr_get(struct ino
 	u64 start = squashfs_xattr_blk(squashfs_i(inode)->xattr)
 						+ msblk->xattr_table;
 	int offset = squashfs_xattr_offset(squashfs_i(inode)->xattr);
-	int count = squashfs_i(inode)->xattr_count;
+	unsigned int count = squashfs_i(inode)->xattr_count;
 	int name_len = strlen(name);
 	int err, vsize;
-	char *target = kmalloc(name_len, GFP_KERNEL);
+	char *target;
+
+	/* check that the file has xattrs */
+	if (squashfs_i(inode)->xattr == SQUASHFS_INVALID_BLK)
+		return -ENODATA;
+
+	if (count == 0 || count > squashfs_i(inode)->xattr_size)
+		return -EIO;
+
+	target = kmalloc(name_len, GFP_KERNEL);
 	if (target == NULL)
-		return  -ENOMEM;
+		return -ENOMEM;
 
 	/* loop reading each xattr name */
 	for (; count; count--) {
@@ -169,6 +181,7 @@ static int squashfs_xattr_get(struct ino
 				goto failed;
 
 			vsize = le32_to_cpu(val.vsize);
+
 			if (buffer) {
 				if (vsize > buffer_size) {
 					err = -ERANGE;
--- a/fs/squashfs/xattr.h~squashfs-widen-xattr-count-variables-and-add-sanity-check
+++ a/fs/squashfs/xattr.h
@@ -11,8 +11,8 @@
 #ifdef CONFIG_SQUASHFS_XATTR
 extern __le64 *squashfs_read_xattr_id_table(struct super_block *, u64,
 		u64 *, unsigned int *);
-extern int squashfs_xattr_lookup(struct super_block *, unsigned int, int *,
-		unsigned int *, unsigned long long *);
+extern int squashfs_xattr_lookup(struct super_block *, unsigned int,
+		unsigned int *, unsigned int *, unsigned long long *);
 #else
 static inline __le64 *squashfs_read_xattr_id_table(struct super_block *sb,
 		u64 start, u64 *xattr_table_start, unsigned int *xattr_ids)
@@ -31,7 +31,7 @@ static inline __le64 *squashfs_read_xatt
 }
 
 static inline int squashfs_xattr_lookup(struct super_block *sb,
-		unsigned int index, int *count, unsigned int *size,
+		unsigned int index, unsigned int *count, unsigned int *size,
 		unsigned long long *xattr)
 {
 	return 0;
--- a/fs/squashfs/xattr_id.c~squashfs-widen-xattr-count-variables-and-add-sanity-check
+++ a/fs/squashfs/xattr_id.c
@@ -27,7 +27,8 @@
  * Map xattr id using the xattr id look up table
  */
 int squashfs_xattr_lookup(struct super_block *sb, unsigned int index,
-		int *count, unsigned int *size, unsigned long long *xattr)
+		unsigned int *count, unsigned int *size,
+		unsigned long long *xattr)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	int block = squashfs_xattr_block(index);
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

