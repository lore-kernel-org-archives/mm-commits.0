Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795586006;
	b=KbgZSJY9hyfrN6jJtEYe3NFI0FxmGnJRzyc48zI2KOfk++fyMvrArcBkGZwo5ZUKHMOf
	 rTfOE/q1p2qaPZx2yn9Rq/nt3Lot22eW1hEwpjiN6NkWfZV6yLsjjJrF6UyGORCgXR98r
	 8VJzVcA/zWJ9R91O/6tsRY7BujVrCLpE/i2Jf33B+Mf5VGJovTagBJkuYgSzp+Wolomk5
	 wpcmwQi1ElYxsai7D6FhB9IFAe6C9hcLzfLkUupS55GoUXOJf+XgUOXJD8EIyhRAOhrZx
	 rTIXTeFSUjwhL1f2Emuu5zfNluiYH0eRj1V2NZVeXWgf5CjO1hoys33ImWPfwhqRUNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795586006;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=dWtc5uZ1hroL34Vn9BdvXuc0M/NBqociCCUerQIApvg=;
	b=3EnFF3t0VLJU8q1N0R/c85Ek35dr5Iuh0UMoSswbEPS1gDvHnG21iK93RMBKqN2YYx/8
	 sPZNL6eFWZFhLE1Ti5Bqujw7oHGwjhsKJPxeWkL6NSEFKW6wfnOuhKoKPSOk20lOxWh2U
	 IWTBH34g7zS1PKCrRvXUEc9gnLqxpSgqyaojbdnotYaEc2gtOF1cD7Ao9y1k2qMG4Vh/N
	 4hiVhAJBRJCBcHz0jzZScWcbbmDV8zZSrI03O3eddwNUMzz6JPFW5h059/3+IXqjEHnhN
	 PTfBhTtxQRAd6Duh21PEIQxCPBnogwtmI+hG+PcHg2jpFW7MKzYG8EhuSe9uVBOvUfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dOY6LxGV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30948606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=dOY6LxGV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763851F000C6;
	Wed, 25 Nov 2026 05:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795586005;
	bh=dWtc5uZ1hroL34Vn9BdvXuc0M/NBqociCCUerQIApvg=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=dOY6LxGV2Eul/AR8YxLcBl1UwT71/R0d81JLay1W1wdStgwkbPiZ7mlC3ZeIuPvme
	 26AorG+DzjSn8xflTfiJy73ynB2Rv5hXFgGkCpVCIN84HIuQPIyZdOpMmAUEjmeOfF
	 E5mGOO7w2IsCbp8Gwu/BGSjHn0tWMpn7/p+4ln+s=
Date: Tue, 24 Nov 2026 21:53:24 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125014737.347231-6-phillip@squashfs.org.uk>
References: <20261125014737.347231-6-phillip@squashfs.org.uk>
Subject: + squashfs-convert-squashfs_id_-to-inline-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055325.763851F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: convert SQUASHFS_ID_* to inline functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-convert-squashfs_id_-to-inline-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-convert-squashfs_id_-to-inline-functions.patch

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
Subject: Squashfs: convert SQUASHFS_ID_* to inline functions
Date: Wed, 25 Nov 2026 01:47:19 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and signedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261125014737.347231-6-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

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

