Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406628;
	b=M0ifn3aKLegkv2V5lQ4O1Viy9mgEuNTm85tTkvlOcWdp2Mg14aZrcI0Yc0Zb2RO5x+qb
	 CXbMxP3LTAsGUbMyh1lZTARRa7fqwwfhlM3YJhGswMCKmto6vkR0Z5Ju+oad8TH5TYNa9
	 xvb7NIKLv2cfh5TFKM1/RHQw345ND2goe24BpRDTI7gWBLKVlvclwJXsrKJi9fq+Ly21A
	 PUNO0OzjCtZUq20vuBF4AcFoG5kN2M28hxztcM8bXo8ZaDnZCzGlakopmvUv1szP3j22k
	 Z+mgeSH9gwLhorl3jRrujcxXk3VT2LXWI9szubbD1FhqXNIVq/e4SmlUpavxQ7zL2Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406628;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=WaPs/lYteIjbLdtwcPtilXm5+teJrUesuc8wvdlXMCc=;
	b=GLOQozw2xdx+WxLGbHBBYu4gYMZ4JvpL2ozw9Rcfbgpv188rBjeLv3l7MxkTmEcXXBiu
	 YSwAxZ/bDDBsnB0WGz/AV0vhFIyYcRA/x9s69LMamcZeMztV/gGt+9R7pwS9OplhFKT4j
	 hQSeftbFuRxBM1UvBEuJTYR2S66BLQXkewFDzQrX75QpDQox4r744E2wULMZ4MV6LbB57
	 8nchT/yIAL7FVM8NSza3yBc7YQtdv4bVcgOI0qKzw/VDXem/Sw/TiPtN+kr+Zn1lzNbTv
	 dizPQX4dI8h8kJvrLpMziDLVi+aPq8ltkyG7BVlBU6FimxhQYUcZqsAue3lijY1OvRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="o7yB/uhL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4079D606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=o7yB/uhL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37161F000D3;
	Mon, 23 Nov 2026 04:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406627;
	bh=WaPs/lYteIjbLdtwcPtilXm5+teJrUesuc8wvdlXMCc=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=o7yB/uhL9cMmHL9cWjPG0SuhEjdb8tSVCKCCdwqNyBLAwXflbDL+BbfQXeDzACiji
	 5/CnOKSCYpgTPA+tMUl1jKA1qNDHtf3NKUstphv3r+VEJUifCmCMXnRvyjKBjmyTIb
	 FOuy6tZ57kcSwbLkf+LAvKESFLseTk5RVmayQMqA=
Date: Sun, 22 Nov 2026 20:03:47 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261111234402.252354-13-phillip@squashfs.org.uk>
References: <20261111234402.252354-13-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-widen-xattr-count-variables-and-add-sanity-check.patch removed from -mm tree
Message-Id: <20261123040347.B37161F000D3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: widen xattr count variables and add sanity check
has been removed from the -mm tree.  Its filename was
     squashfs-widen-xattr-count-variables-and-add-sanity-check.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: widen xattr count variables and add sanity check
Date: Wed, 11 Nov 2026 23:43:52 +0000

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

echo Create a Squashfs pseudo file which is fed to Mksquashfs

echo "/ d 0777 0 0" > pseudo
echo "example f 0777 0 0 echo example data" >> pseudo
echo "example x user.comment=example xattr" >> pseudo

echo Generate the Squashfs filesystem

mksquashfs - img.sqsh -pf pseudo -quiet -no-progress -noX

low=$(dd if=img.sqsh bs=1 skip=56 count=1 status=none | od -An -v -tu1 | tr -d '\n')
hi=$(dd if=img.sqsh bs=1 skip=57 count=1 status=none | od -An -v -tu1 | tr -d '\n')
start=$(( $hi * 256 + $low ))

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

Link: https://patch.msgid.link/20261111234402.252354-13-phillip@squashfs.org.uk
Fixes: f41d207cbede ("squashfs: add support for xattr reading")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>

 fs/squashfs/inode.c         |    2 +-
 fs/squashfs/squashfs_fs_i.h |    2 +-
 fs/squashfs/xattr.c         |   27 ++++++++++++++++++++-------
 fs/squashfs/xattr.h         |    6 +++---
 fs/squashfs/xattr_id.c      |    3 ++-
 5 files changed, 27 insertions(+), 13 deletions(-)

--- a/fs/squashfs/inode.c~squashfs-widen-xattr-count-variables-and-add-sanity-check
+++ a/fs/squashfs/inode.c
@@ -448,7 +448,7 @@ int squashfs_read_inode(struct inode *in
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

