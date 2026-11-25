Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586002;
	b=bO79LdAo4Wz0VqsGrM+6HoEUTKeCsWTwdX2DEMqCJ+nkErGzVHbDcy6Gkb1t9E4IRac9
	 5SrL2+J1/C1Cb2pdHwPduwxxxONvyGLglKjG2rkC7cWn3Ym33AIpGL70E/v9jqcObSqLJ
	 YDvcF1TqZrK1x3vInTiyZGDbbJN73zMv0oWwWAJI5fcR3agTt6f4VTHjYVDtMg886xicb
	 RcAOqgvEwuOYxXs9orNy23o5Rk4N6KWH5wpsHop7nGHfluxKMPlCy1DF4LtRHiKkvJNb9
	 RXqdjTd42sFCMcFy5VeM2Sh+ajTdIRMRhb78fxhyrCPw1Vph99mbokWwqhFBmg1ztKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586002;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=E3PKwe518mP/H66oZRffpCz6P/bWTldJjG432MXFX5c=;
	b=xVkADt8JRjDKq6IziaVHulKgIdOXCDztInjU+nyvaTr5HpKSrQ9g6I3j/uer+wc6ZrCv
	 3ou71FDZWLSTyHe5rRfmzvdyT99qQadbH7MBd/MKY2lAZMCBb0yEWtQSHZmdQ/XMMThC/
	 NeDmdJWAj9QB+wgpPnfboqPSTZuaN/7qUG6hR+7334bRAsOUbeVwzsbwcu31s5a3Cc+gj
	 lueTtDK1bxwR8Tkn/Zw5jTcjs8yQ/ki1Mdui5pzh6a+VNXoP5X2ftUyr1TyEd2Lx2+vFl
	 8rSkAQZswmMktZ3drULOmZlvlULI05IU2Lw/Lmbiuege59tUEoHECt2gYFzLDxsrPXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0kt5o77R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0F1606A326
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=0kt5o77R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AD41F000C0;
	Wed, 25 Nov 2026 05:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795586002;
	bh=E3PKwe518mP/H66oZRffpCz6P/bWTldJjG432MXFX5c=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=0kt5o77Rqrud2yLRobb+GAy3Ty26mVe020BwdIOnkbaNRh2karXId1LOsUsve2sOQ
	 BM3vgNxAxsIbM8OMbKhuhHNXpsK9qNSvZweiXA7NYOxhqx7dHdQJJnn3Mv8sTRpkzn
	 FaMjCj1Pjx9QFMBE6ysa8V6XapJ65iPVa1DzpsQg=
Date: Tue, 24 Nov 2026 21:53:21 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125014737.347231-5-phillip@squashfs.org.uk>
References: <20261125014737.347231-5-phillip@squashfs.org.uk>
Subject: + squashfs-convert-squashfs_lookup_-to-inline-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055322.21AD41F000C0@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: convert SQUASHFS_LOOKUP_* to inline functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-convert-squashfs_lookup_-to-inline-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-convert-squashfs_lookup_-to-inline-functions.patch

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
Subject: Squashfs: convert SQUASHFS_LOOKUP_* to inline functions
Date: Wed, 25 Nov 2026 01:47:18 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and signedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261125014737.347231-5-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

 fs/squashfs/export.c           |    9 +++++----
 fs/squashfs/squashfs_fs.h      |   16 ----------------
 fs/squashfs/squashfs_helpers.h |   27 +++++++++++++++++++++++++++
 3 files changed, 32 insertions(+), 20 deletions(-)

--- a/fs/squashfs/export.c~squashfs-convert-squashfs_lookup_-to-inline-functions
+++ a/fs/squashfs/export.c
@@ -31,6 +31,7 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 
 /*
@@ -39,8 +40,8 @@
 static long long squashfs_inode_lookup(struct super_block *sb, int ino_num)
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
-	int blk = SQUASHFS_LOOKUP_BLOCK(ino_num - 1);
-	int offset = SQUASHFS_LOOKUP_BLOCK_OFFSET(ino_num - 1);
+	int blk = squashfs_lookup_block(ino_num - 1);
+	int offset = squashfs_lookup_block_offset(ino_num - 1);
 	u64 start;
 	__le64 ino;
 	int err;
@@ -115,8 +116,8 @@ static struct dentry *squashfs_get_paren
 __le64 *squashfs_read_inode_lookup_table(struct super_block *sb,
 		u64 lookup_table_start, u64 next_table, unsigned int inodes)
 {
-	unsigned int length = SQUASHFS_LOOKUP_BLOCK_BYTES(inodes);
-	unsigned int indexes = SQUASHFS_LOOKUP_BLOCKS(inodes);
+	unsigned int length = squashfs_lookup_block_bytes(inodes);
+	unsigned int indexes = squashfs_lookup_blocks(inodes);
 	int n;
 	__le64 *table;
 	u64 start, end;
--- a/fs/squashfs/squashfs_fs.h~squashfs-convert-squashfs_lookup_-to-inline-functions
+++ a/fs/squashfs/squashfs_fs.h
@@ -107,22 +107,6 @@ static inline int squashfs_block_size(__
 	return (size >> 25) ? -EIO : size;
 }
 
-/* inode lookup table defines */
-#define SQUASHFS_LOOKUP_BYTES(A)	((A) * sizeof(u64))
-
-#define SQUASHFS_LOOKUP_BLOCK(A)	(SQUASHFS_LOOKUP_BYTES(A) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_LOOKUP_BLOCK_OFFSET(A)	(SQUASHFS_LOOKUP_BYTES(A) % \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_LOOKUP_BLOCKS(A)	((SQUASHFS_LOOKUP_BYTES(A) + \
-					SQUASHFS_METADATA_SIZE - 1) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_LOOKUP_BLOCK_BYTES(A)	(SQUASHFS_LOOKUP_BLOCKS(A) *\
-					sizeof(u64))
-
 /* uid/gid lookup table defines */
 #define SQUASHFS_ID_BYTES(A)		((A) * sizeof(unsigned int))
 
--- a/fs/squashfs/squashfs_helpers.h~squashfs-convert-squashfs_lookup_-to-inline-functions
+++ a/fs/squashfs/squashfs_helpers.h
@@ -78,4 +78,31 @@ static inline s32 squashfs_fragment_inde
 {
 	return squashfs_fragment_indexes(fragments) * sizeof(long long);
 }
+
+/* inode lookup table defines */
+static inline s64 squashfs_lookup_bytes(u32 inodes)
+{
+	return (s64) inodes * sizeof(s64);
+}
+
+static inline s32 squashfs_lookup_block(u32 inodes)
+{
+	return squashfs_lookup_bytes(inodes) / SQUASHFS_METADATA_SIZE;
+}
+
+static inline s16 squashfs_lookup_block_offset(u32 inodes)
+{
+	return squashfs_lookup_bytes(inodes) % SQUASHFS_METADATA_SIZE;
+}
+
+static inline s32 squashfs_lookup_blocks(u32 inodes)
+{
+	return (squashfs_lookup_bytes(inodes) + (SQUASHFS_METADATA_SIZE - 1)) /
+		SQUASHFS_METADATA_SIZE;
+}
+
+static inline s32 squashfs_lookup_block_bytes(u32 inodes)
+{
+	return squashfs_lookup_blocks(inodes) * sizeof(long long);
+}
 #endif
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

