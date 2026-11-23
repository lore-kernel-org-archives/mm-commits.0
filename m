Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406616;
	b=jplUOLnBCjawymmJAfkXa6MR6QbwSrm5or9G6tuB7bjY8UV+R9WpJnGS6K/4QctMepRJ
	 0jbB4m9R6BRZgcqrER0N2WKne/nbR7/Jsvo4sRcxdyF3OVJe2B/eCY4hvl2dVK9CwkD92
	 35Ulv438nO/roxBkUVEgeL9q9oCmrQGH+RhOZekbkIYXo6xcg+NvPy++qwLLEJ8A59t7B
	 zjDVVWsOHghF3oYyA8aAb32zopel0IDQjFFSMz4PamzG9DXtuT7J96VqIpCbxvxHiFkpa
	 MpqOgSx0A/VVctJvpa8rkFFw1qEHM6nAc2nEWwngeLNu0E9GpsnXmeZzE20lELAJoow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406616;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=Y7f9JbhdIDFr2E7qWQrDgBwn/POeW8iOBQiX3cI+uDw=;
	b=TeoHMyPjlAU9mSAPm5S2ELkcWhRI2mF6UX2pOW5Nfaw2MlAGG5Q5GV3blSsV6RGCU5Bk
	 PafJz1x/0y1OcDhAHSsrip4l2i+sEwSOk3DsuM7aShaBeVwplqNCaJEJVKZpxmkRJDpOF
	 SD3F3t6hfGIWIryt6E9aRK3dDPchoYgftZkdvjAbEsk5pezyBLwjgjc90Vio/1BAnZwKs
	 Os1T1+0z6SOo6Htg86Kwyq2yEEJ/MaLX1VqXc6YGE6sbbnuBm+byc6g1aFAF7c1o/FhY3
	 TRki6s1yFFVLGtLhy+5oiTaQHr+nXSOdiQawBQUmoR59INt681HMx4ZnwwgRn7tkoMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="nGxL0aD/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E6F2606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=nGxL0aD/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8BD1F000D0;
	Mon, 23 Nov 2026 04:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406615;
	bh=Y7f9JbhdIDFr2E7qWQrDgBwn/POeW8iOBQiX3cI+uDw=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=nGxL0aD/KPgaNHB+tqHnBWb7G2KksmsN/zNWJTtxDV8jiaIeGyBdgXwUpGnIhreIm
	 V4izhTmc3oxbf6EvXK866oekewgBuu+HjnOYYM+VuO8bDg2Uc4R//Xo8pu2fxuqd3f
	 HA0U/gJ5vQOARpEJOvGBCQHp2wAwQKUZI54mVf+c=
Date: Sun, 22 Nov 2026 20:03:34 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261111234402.252354-7-phillip@squashfs.org.uk>
References: <20261111234402.252354-7-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-convert-squashfs_xattr_-to-inline-functions.patch removed from -mm tree
Message-Id: <20261123040335.5A8BD1F000D0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: convert SQUASHFS_XATTR_* to inline functions
has been removed from the -mm tree.  Its filename was
     squashfs-convert-squashfs_xattr_-to-inline-functions.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: convert SQUASHFS_XATTR_* to inline functions
Date: Wed, 11 Nov 2026 23:43:46 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and sigedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261111234402.252354-7-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>

 fs/squashfs/squashfs_fs.h      |   19 ---------------
 fs/squashfs/squashfs_helpers.h |   37 +++++++++++++++++++++++++++++++
 fs/squashfs/xattr.c            |   18 +++++++--------
 fs/squashfs/xattr_id.c         |    9 ++++---
 4 files changed, 51 insertions(+), 32 deletions(-)

--- a/fs/squashfs/squashfs_fs.h~squashfs-convert-squashfs_xattr_-to-inline-functions
+++ a/fs/squashfs/squashfs_fs.h
@@ -107,25 +107,6 @@ static inline int squashfs_block_size(__
 	return (size >> 25) ? -EIO : size;
 }
 
-/* xattr id lookup table defines */
-#define SQUASHFS_XATTR_BYTES(A)		(((u64) (A)) * sizeof(struct squashfs_xattr_id))
-
-#define SQUASHFS_XATTR_BLOCK(A)		(SQUASHFS_XATTR_BYTES(A) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_XATTR_BLOCK_OFFSET(A)	(SQUASHFS_XATTR_BYTES(A) % \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_XATTR_BLOCKS(A)	((SQUASHFS_XATTR_BYTES(A) + \
-					SQUASHFS_METADATA_SIZE - 1) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_XATTR_BLOCK_BYTES(A)	(SQUASHFS_XATTR_BLOCKS(A) *\
-					sizeof(u64))
-#define SQUASHFS_XATTR_BLK(A)		((unsigned int) ((A) >> 16))
-
-#define SQUASHFS_XATTR_OFFSET(A)	((unsigned int) ((A) & 0xffff))
-
 /* cached data constants for filesystem */
 #define SQUASHFS_CACHED_BLKS		8
 
--- a/fs/squashfs/squashfs_helpers.h~squashfs-convert-squashfs_xattr_-to-inline-functions
+++ a/fs/squashfs/squashfs_helpers.h
@@ -132,4 +132,41 @@ static inline s16 squashfs_id_block_byte
 {
 	return squashfs_id_blocks(ids) * sizeof(long long);
 }
+
+/* xattr id lookup table defines */
+static inline s64 squashfs_xattr_bytes(u32 xattrs)
+{
+	return (s64) xattrs * sizeof(struct squashfs_xattr_id);
+}
+
+static inline s32 squashfs_xattr_block(u32 xattrs)
+{
+	return squashfs_xattr_bytes(xattrs) / SQUASHFS_METADATA_SIZE;
+}
+
+static inline s16 squashfs_xattr_block_offset(u32 xattrs)
+{
+	return squashfs_xattr_bytes(xattrs) % SQUASHFS_METADATA_SIZE;
+}
+
+static inline s32 squashfs_xattr_blocks(u32 xattrs)
+{
+	return (squashfs_xattr_bytes(xattrs) + SQUASHFS_METADATA_SIZE - 1) /
+		SQUASHFS_METADATA_SIZE;
+}
+
+static inline s32 squashfs_xattr_block_bytes(u32 xattrs)
+{
+	return squashfs_xattr_blocks(xattrs) * sizeof(long long);
+}
+
+static inline u32 squashfs_xattr_blk(s64 xattr)
+{
+	return xattr >> 16;
+}
+
+static inline s16 squashfs_xattr_offset(s64 xattr)
+{
+	return xattr & 0xffff;
+}
 #endif
--- a/fs/squashfs/xattr.c~squashfs-convert-squashfs_xattr_-to-inline-functions
+++ a/fs/squashfs/xattr.c
@@ -19,6 +19,7 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 
 static const struct xattr_handler *squashfs_xattr_handler(int);
@@ -29,9 +30,9 @@ ssize_t squashfs_listxattr(struct dentry
 	struct inode *inode = d_inode(d);
 	struct super_block *sb = inode->i_sb;
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	u64 start = SQUASHFS_XATTR_BLK(squashfs_i(inode)->xattr)
-						 + msblk->xattr_table;
-	int offset = SQUASHFS_XATTR_OFFSET(squashfs_i(inode)->xattr);
+	u64 start = squashfs_xattr_blk(squashfs_i(inode)->xattr)
+						+ msblk->xattr_table;
+	int offset = squashfs_xattr_offset(squashfs_i(inode)->xattr);
 	int count = squashfs_i(inode)->xattr_count;
 	size_t rest = buffer_size;
 	int err;
@@ -107,14 +108,13 @@ static int squashfs_xattr_get(struct ino
 {
 	struct super_block *sb = inode->i_sb;
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	u64 start = SQUASHFS_XATTR_BLK(squashfs_i(inode)->xattr)
-						 + msblk->xattr_table;
-	int offset = SQUASHFS_XATTR_OFFSET(squashfs_i(inode)->xattr);
+	u64 start = squashfs_xattr_blk(squashfs_i(inode)->xattr)
+						+ msblk->xattr_table;
+	int offset = squashfs_xattr_offset(squashfs_i(inode)->xattr);
 	int count = squashfs_i(inode)->xattr_count;
 	int name_len = strlen(name);
 	int err, vsize;
 	char *target = kmalloc(name_len, GFP_KERNEL);
-
 	if (target == NULL)
 		return  -ENOMEM;
 
@@ -158,9 +158,9 @@ static int squashfs_xattr_get(struct ino
 				if (err < 0)
 					goto failed;
 				xattr = le64_to_cpu(xattr_val);
-				start = SQUASHFS_XATTR_BLK(xattr) +
+				start = squashfs_xattr_blk(xattr) +
 							msblk->xattr_table;
-				offset = SQUASHFS_XATTR_OFFSET(xattr);
+				offset = squashfs_xattr_offset(xattr);
 			}
 			/* read xattr value */
 			err = squashfs_read_metadata(sb, &val, &start, &offset,
--- a/fs/squashfs/xattr_id.c~squashfs-convert-squashfs_xattr_-to-inline-functions
+++ a/fs/squashfs/xattr_id.c
@@ -19,6 +19,7 @@
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "xattr.h"
 
@@ -29,8 +30,8 @@ int squashfs_xattr_lookup(struct super_b
 		int *count, unsigned int *size, unsigned long long *xattr)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int block = SQUASHFS_XATTR_BLOCK(index);
-	int offset = SQUASHFS_XATTR_BLOCK_OFFSET(index);
+	int block = squashfs_xattr_block(index);
+	int offset = squashfs_xattr_block_offset(index);
 	u64 start_block;
 	struct squashfs_xattr_id id;
 	int err;
@@ -79,8 +80,8 @@ __le64 *squashfs_read_xattr_id_table(str
 	if (*xattr_ids == 0)
 		return ERR_PTR(-EINVAL);
 
-	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
-	indexes = SQUASHFS_XATTR_BLOCKS(*xattr_ids);
+	len = squashfs_xattr_block_bytes(*xattr_ids);
+	indexes = squashfs_xattr_blocks(*xattr_ids);
 
 	/*
 	 * The computed size of the index table (len bytes) should exactly
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

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
a.patch

