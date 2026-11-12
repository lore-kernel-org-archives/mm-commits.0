Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510620;
	b=k/bjnMH+fwRyoJjqL15F7Kzw0i9fFzyjGIQCo82SUkJb8jHAJoRPinONWxMlw4kLw3CD
	 4ocYEuzXhl9nA1zHzHYDUJxU9y1Am3uYSMMVQAEfG6wXfETVGOFudMMmb5CBelM1yNmQK
	 ZzdeEVAPvFYGq63PYeVoPoIzH5ZtD6GOyH7ju1PwKK6pNecAe1g85iOnuMQfseVsRs24Y
	 YY7HyFfwHWlZHsMiWfDVZVYoiL5IGO1qXlyUmbFWnLHyyHS0iuqmuLnaw8HWZ1aG5Y4Ks
	 l85el1vz7lZfajonS6JQ5rFO7oBKkIgQpigpK/wasvJRYbZ2igXrnnZsexaWPGabd4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510620;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=By+ZlrJKrFWdGrm2pV/FL4Qc6DawjRryNfpkUDkw7zE=;
	b=H3Dly00EqDp8o/BDi2V6XJdJiPslvHRYIisD9UlcPuabk3JOzr9dYxMnHtKPX9KVRuFr
	 izC6P9D0fkxMJsDCDh33UhPNYYZKTboX814Dt4doeQgHkpudJ0TAmWIBNlZl/WYIPjxuG
	 bVhroBjsZW4axs03D0vYM0hQrcLJ1TGEeRqoyqL0ICJ2So0w0myMk25EVtwsJ0TGk0At9
	 mXiRHssfSxuT9lidVKdXXIcxTMwrpc3/hfz3P8WUp8MuPV8MRblpoTuQTJLQ0zyKkO6X1
	 yTb4AZdu0OdNT2sWn0q24dxJNgUiP5ykQLoveb4DmMpdl/c7wQYA3I9sshg3TDCAQOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oP5gnrG7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EB660A261F
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 19:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=oP5gnrG7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A96D1F000C8;
	Thu, 12 Nov 2026 19:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794510620;
	bh=By+ZlrJKrFWdGrm2pV/FL4Qc6DawjRryNfpkUDkw7zE=;
	h=Date:To:From:Subject;
	b=oP5gnrG7OyfGl9MgbZ7LVDCKFKCdYk09nDb8MlSOATRh8z1TyiBvcAlLWcS5JpvOL
	 VlHlf2z7ZqJ958+MPai1BEQ46iL+S/nMRxfa+D3OG1NI53aCVZguYaiDpSO+lbGOjj
	 T1yZjwvfIn4fYztjnF8yhrsyQmOxNgjk0zmv1Y04=
Date: Thu, 12 Nov 2026 11:10:19 -0800
To: mm-commits@vger.kernel.org,phillip.lougher@gmail.com,
	phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20261112191020.0A96D1F000C8@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: convert SQUASHFS_INODE_* and SQUASHFS_MKINODE to inline functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions.patch

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
Subject: Squashfs: convert SQUASHFS_INODE_* and SQUASHFS_MKINODE to inline functions
Date: Wed, 11 Nov 2026 23:43:42 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and sigedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://lore.kernel.org/20261111234402.252354-3-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
---

 fs/squashfs/inode.c            |   24 +++++++++++++-----------
 fs/squashfs/namei.c            |    3 ++-
 fs/squashfs/squashfs_fs.h      |   11 -----------
 fs/squashfs/squashfs_helpers.h |   19 +++++++++++++++++++
 fs/squashfs/super.c            |    3 ++-
 5 files changed, 36 insertions(+), 24 deletions(-)

--- a/fs/squashfs/inode.c~squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions
+++ a/fs/squashfs/inode.c
@@ -33,6 +33,7 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "xattr.h"
 
@@ -108,8 +109,9 @@ int squashfs_read_inode(struct inode *in
 {
 	struct super_block *sb = inode->i_sb;
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	u64 block = SQUASHFS_INODE_BLK(ino) + msblk->inode_table;
-	int err, type, offset = SQUASHFS_INODE_OFFSET(ino);
+	u64 block = squashfs_inode_blk(ino) + msblk->inode_table;
+	int offset = squashfs_inode_offset(ino);
+	int err, type;
 	union squashfs_inode squashfs_ino;
 	struct squashfs_base_inode *sqshb_ino = &squashfs_ino.base;
 	int xattr_id = SQUASHFS_INVALID_XATTR;
@@ -128,8 +130,8 @@ int squashfs_read_inode(struct inode *in
 	if (err)
 		goto failed_read;
 
-	block = SQUASHFS_INODE_BLK(ino) + msblk->inode_table;
-	offset = SQUASHFS_INODE_OFFSET(ino);
+	block = squashfs_inode_blk(ino) + msblk->inode_table;
+	offset = squashfs_inode_offset(ino);
 
 	type = le16_to_cpu(sqshb_ino->inode_type);
 	switch (type) {
@@ -181,7 +183,7 @@ int squashfs_read_inode(struct inode *in
 		inode->i_data.a_ops = &squashfs_aops;
 
 		TRACE("File inode %x:%x, start_block %llx, block_list_start "
-			"%llx, offset %x\n", SQUASHFS_INODE_BLK(ino),
+			"%llx, offset %x\n", squashfs_inode_blk(ino),
 			offset, squashfs_i(inode)->start, block, offset);
 		break;
 	}
@@ -241,7 +243,7 @@ int squashfs_read_inode(struct inode *in
 		inode->i_data.a_ops = &squashfs_aops;
 
 		TRACE("File inode %x:%x, start_block %llx, block_list_start "
-			"%llx, offset %x\n", SQUASHFS_INODE_BLK(ino),
+			"%llx, offset %x\n", squashfs_inode_blk(ino),
 			offset, squashfs_i(inode)->start, block, offset);
 		break;
 	}
@@ -264,7 +266,7 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->parent = le32_to_cpu(sqsh_ino->parent_inode);
 
 		TRACE("Directory inode %x:%x, start_block %llx, offset %x\n",
-				SQUASHFS_INODE_BLK(ino), offset,
+				squashfs_inode_blk(ino), offset,
 				squashfs_i(inode)->start,
 				le16_to_cpu(sqsh_ino->offset));
 		break;
@@ -291,7 +293,7 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->parent = le32_to_cpu(sqsh_ino->parent_inode);
 
 		TRACE("Long directory inode %x:%x, start_block %llx, offset "
-				"%x\n", SQUASHFS_INODE_BLK(ino), offset,
+				"%x\n", squashfs_inode_blk(ino), offset,
 				squashfs_i(inode)->start,
 				le16_to_cpu(sqsh_ino->offset));
 		break;
@@ -335,7 +337,7 @@ int squashfs_read_inode(struct inode *in
 		}
 
 		TRACE("Symbolic link inode %x:%x, start_block %llx, offset "
-				"%x\n", SQUASHFS_INODE_BLK(ino), offset,
+				"%x\n", squashfs_inode_blk(ino), offset,
 				block, offset);
 		break;
 	}
@@ -359,7 +361,7 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->parent = 0;
 
 		TRACE("Device inode %x:%x, rdev %x\n",
-				SQUASHFS_INODE_BLK(ino), offset, rdev);
+				squashfs_inode_blk(ino), offset, rdev);
 		break;
 	}
 	case SQUASHFS_LBLKDEV_TYPE:
@@ -384,7 +386,7 @@ int squashfs_read_inode(struct inode *in
 		squashfs_i(inode)->parent = 0;
 
 		TRACE("Device inode %x:%x, rdev %x\n",
-				SQUASHFS_INODE_BLK(ino), offset, rdev);
+				squashfs_inode_blk(ino), offset, rdev);
 		break;
 	}
 	case SQUASHFS_FIFO_TYPE:
--- a/fs/squashfs/namei.c~squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions
+++ a/fs/squashfs/namei.c
@@ -49,6 +49,7 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "xattr.h"
 
@@ -197,7 +198,7 @@ static struct dentry *squashfs_lookup(st
 				off = le16_to_cpu(dire->offset);
 				ino_num = le32_to_cpu(dirh.inode_number) +
 					(short) le16_to_cpu(dire->inode_number);
-				ino = SQUASHFS_MKINODE(blk, off);
+				ino = squashfs_mkinode(blk, off);
 
 				TRACE("calling squashfs_iget for directory "
 					"entry %s, inode  %x:%x, %d\n", name,
--- a/fs/squashfs/squashfs_fs.h~squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions
+++ a/fs/squashfs/squashfs_fs.h
@@ -107,17 +107,6 @@ static inline int squashfs_block_size(__
 	return (size >> 25) ? -EIO : size;
 }
 
-/*
- * Inode number ops.  Inodes consist of a compressed block number, and an
- * uncompressed offset within that block
- */
-#define SQUASHFS_INODE_BLK(A)		((unsigned int) ((A) >> 16))
-
-#define SQUASHFS_INODE_OFFSET(A)	((unsigned int) ((A) & 0xffff))
-
-#define SQUASHFS_MKINODE(A, B)		((long long)(((long long) (A)\
-					<< 16) + (B)))
-
 /* fragment and fragment table defines */
 #define SQUASHFS_FRAGMENT_BYTES(A)	\
 				((A) * sizeof(struct squashfs_fragment_entry))
--- a/fs/squashfs/squashfs_helpers.h~squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions
+++ a/fs/squashfs/squashfs_helpers.h
@@ -32,4 +32,23 @@ static inline bool squashfs_compressed_b
 {
 	return (size & SQUASHFS_COMPRESSED_BIT_BLOCK) == 0;
 }
+
+/*
+ * Inode number ops.  Inodes consist of a compressed block number, and an
+ * uncompressed  offset within that block
+ */
+static inline u32 squashfs_inode_blk(s64 inode)
+{
+	return inode >> 16;
+}
+
+static inline u16 squashfs_inode_offset(s64 inode)
+{
+	return inode & 0xffff;
+}
+
+static inline s64 squashfs_mkinode(u32 start, u16 offset)
+{
+	return ((s64)start << 16) | offset;
+}
 #endif
--- a/fs/squashfs/super.c~squashfs-convert-squashfs_inode_-and-squashfs_mkinode-to-inline-functions
+++ a/fs/squashfs/super.c
@@ -33,6 +33,7 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "decompressor.h"
 #include "xattr.h"
@@ -286,7 +287,7 @@ static int squashfs_fill_super(struct su
 
 	/* Check the root inode for sanity */
 	root_inode = le64_to_cpu(sblk->root_inode);
-	if (SQUASHFS_INODE_OFFSET(root_inode) > SQUASHFS_METADATA_SIZE)
+	if (squashfs_inode_offset(root_inode) > SQUASHFS_METADATA_SIZE)
 		goto insanity;
 
 	msblk->inode_table = le64_to_cpu(sblk->inode_table_start);
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

