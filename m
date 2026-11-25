Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585284;
	b=I5l9o1f+EyMn2D+ojS151F0gFlV3hDlYcIkV6AM8fHzSGrCDV66Ox3IiDbUv4d38Gwi3
	 pXkAvRNfq8LguAoxNT8KcBCbL3aATA6Dyj8+DDlp+H8HfVzzf6yxHMl1iKsewAVz4C/35
	 PkD6PDpDm4T4frtGdtGG1jfp8k5xKlRWT9IAYd5J4BmuFSZ3GbEBQXZ5D3BBt/axFptwU
	 /aFcoG+fTb1SYHHwgfz9Ffb8HQlHbygqpbDgkpCCnkKbD/VgeKCfbW38DiXGlGqvyfrm4
	 8jV2/KVKmxJSedzREErGNCMeChhxwPdb/kfhNAjmV9iItSxXeiTGdgHoDj94UeRnIiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585284;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=wmdw5cPIp+7YP0uM5JbQesTTwjS8eFUsearWCiAYQ0A=;
	b=WMO6FqH6U00dql75/ie9RhEFpmk/PrNntMjvwVU6Pk7kDa5G/kRhxv2+frEulwWg+Flz
	 C9JsugmnOOlGK3bpklLbNDBSUnKM8ez+hkCfu0HkdWGLdV4V/P5B0CAN/yyFMCGGF2ea+
	 APDP/vBLpUOZR8elLPPCibL4xW3tZ2/4IUE6TzPZW7b4AN7XQtS66F1mmlFfGp0kVtEVG
	 vazyTJTGz4vptRhez11K8ZJjg2hYp5L2KFurTnH3YIt5KcVXtwKBnSgLEwqRArisAF+6i
	 X13bO15jj6+uX+6MHOdOSpqKHlIAXHp8zEDldBfW6O5gIbMyonFRRfpXB3y7iYoW5Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XUuUEYZr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB7C606A323
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=XUuUEYZr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1542D1F000CA;
	Wed, 25 Nov 2026 05:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585284;
	bh=wmdw5cPIp+7YP0uM5JbQesTTwjS8eFUsearWCiAYQ0A=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=XUuUEYZrTyTYCb3ZPEyr7iu6jNUGRnZEIH1hsyfN3ZpEkYBqmIAOoJNNYdXM65fer
	 WKlLoOCbJ6XgIzgfVF718Y/65chPfrhJRhJNbKLhuFtGMzBaSldIH+HCTzqBS8Ukr9
	 Q+RLkQv35B5QbqbNNlJGkxQ3Tu8F6KY9emFG+9LY=
Date: Tue, 24 Nov 2026 21:41:23 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-6-phillip@squashfs.org.uk>
References: <20261123034304.261742-6-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-convert-squashfs_id_-to-inline-functions.patch removed from -mm tree
Message-Id: <20261125054124.1542D1F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: convert SQUASHFS_ID_* to inline functions
has been removed from the -mm tree.  Its filename was
     squashfs-convert-squashfs_id_-to-inline-functions.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: convert SQUASHFS_ID_* to inline functions
Date: Mon, 23 Nov 2026 03:42:46 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and signedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261123034304.261742-6-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

 fs/squashfs/id.c               |    9 +++++----
 fs/squashfs/squashfs_fs.h      |   15 ---------------
 fs/squashfs/squashfs_helpers.h |   27 +++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 19 deletions(-)

--- a/fs/squashfs/id.c~squashfs-convert-squashfs_id_-to-inline-functions
+++ a/fs/squashfs/id.c
@@ -24,6 +24,7 @@
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 
 /*
@@ -33,8 +34,8 @@ int squashfs_get_id(struct super_block *
 					unsigned int *id)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int block = SQUASHFS_ID_BLOCK(index);
-	int offset = SQUASHFS_ID_BLOCK_OFFSET(index);
+	int block = squashfs_id_block(index);
+	int offset = squashfs_id_block_offset(index);
 	u64 start_block;
 	__le32 disk_id;
 	int err;
@@ -60,8 +61,8 @@ int squashfs_get_id(struct super_block *
 __le64 *squashfs_read_id_index_table(struct super_block *sb,
 		u64 id_table_start, u64 next_table, unsigned short no_ids)
 {
-	unsigned int length = SQUASHFS_ID_BLOCK_BYTES(no_ids);
-	unsigned int indexes = SQUASHFS_ID_BLOCKS(no_ids);
+	unsigned int length = squashfs_id_block_bytes(no_ids);
+	unsigned int indexes = squashfs_id_blocks(no_ids);
 	int n;
 	__le64 *table;
 	u64 start, end;
--- a/fs/squashfs/squashfs_fs.h~squashfs-convert-squashfs_id_-to-inline-functions
+++ a/fs/squashfs/squashfs_fs.h
@@ -107,21 +107,6 @@ static inline int squashfs_block_size(__
 	return (size >> 25) ? -EIO : size;
 }
 
-/* uid/gid lookup table defines */
-#define SQUASHFS_ID_BYTES(A)		((A) * sizeof(unsigned int))
-
-#define SQUASHFS_ID_BLOCK(A)		(SQUASHFS_ID_BYTES(A) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_ID_BLOCK_OFFSET(A)	(SQUASHFS_ID_BYTES(A) % \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_ID_BLOCKS(A)		((SQUASHFS_ID_BYTES(A) + \
-					SQUASHFS_METADATA_SIZE - 1) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_ID_BLOCK_BYTES(A)	(SQUASHFS_ID_BLOCKS(A) *\
-					sizeof(u64))
 /* xattr id lookup table defines */
 #define SQUASHFS_XATTR_BYTES(A)		(((u64) (A)) * sizeof(struct squashfs_xattr_id))
 
--- a/fs/squashfs/squashfs_helpers.h~squashfs-convert-squashfs_id_-to-inline-functions
+++ a/fs/squashfs/squashfs_helpers.h
@@ -105,4 +105,31 @@ static inline s32 squashfs_lookup_block_
 {
 	return squashfs_lookup_blocks(inodes) * sizeof(long long);
 }
+
+/* uid lookup table defines */
+static inline s32 squashfs_id_bytes(u16 ids)
+{
+	return (s32) ids * sizeof(unsigned int);
+}
+
+static inline s32 squashfs_id_block(u16 ids)
+{
+	return squashfs_id_bytes(ids) / SQUASHFS_METADATA_SIZE;
+}
+
+static inline s16 squashfs_id_block_offset(u16 ids)
+{
+	return squashfs_id_bytes(ids) % SQUASHFS_METADATA_SIZE;
+}
+
+static inline s8 squashfs_id_blocks(u16 ids)
+{
+	return (squashfs_id_bytes(ids) + (SQUASHFS_METADATA_SIZE - 1)) /
+		SQUASHFS_METADATA_SIZE;
+}
+
+static inline s16 squashfs_id_block_bytes(u16 ids)
+{
+	return squashfs_id_blocks(ids) * sizeof(long long);
+}
 #endif
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

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

