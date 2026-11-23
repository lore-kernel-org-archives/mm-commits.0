Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406607;
	b=HK/ZYarexEam66mgFWqQ3FPYizwzkl5nr/H1vq4cUxtgcjEv0LYFbfr343WpYimOdQpl
	 KfpxiqsFoq/FXfM8+wLZkLWpgl5w7n/EgPUORTRjdlADAAuvBMg6glX/r1PLU32rnEEN5
	 rJG/aEuC46slRHI+2jEzPqjp2KDODaTdNnMMHmThvPGjaw7/2FBdu2slr+2GCX69WaiRz
	 1c9HMGPPOpCNNgCpoFfjJhg7snGK+xNOXP6nzTLqPFyiBdktxkeD1fFxWOtpUuVf8eERX
	 M4HtqC2c39x5iujnd/cyevWo/pXJMTG/v+2gGcPniewP60ltr6SrwYD0rf44991NEJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406607;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=jN4DGYYeUwezzY1gl7Z1GGAsw2UVFttoh5txkVmW3Kc=;
	b=xlw9y8ypPh3XMM1ioI4ZqvTnRha6BK382YrMiKjJAe39Zro9n0VmSuTNNXvsfrSSMS0q
	 0ZGQTd2renlVT+FlMSF++C/EBWzyfKzohOSszKayhOuTshLUt6JLoTSO46d3hwE7+Bra2
	 NCqAE5RvTPeb/OMCi4qXqeKM2K0Uzc6aDArj/pMJ/M/9K4oaRzc5YlH1NWDitP+fsfRqg
	 QzsjW/25WeZtCkgsWODsux5vOdPgTasz1VdTCb8z4Ya8QYnZRhIb6HZRSlM7jfxqzn5p0
	 EW/RmfboqWoweqLkzf+3i+PHx0arY37KVwDnZg33k8auDhtGbPSTaFtaEZLYcVy4uFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cYjPwjA5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA72606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=cYjPwjA5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66041F000CA;
	Mon, 23 Nov 2026 04:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406606;
	bh=jN4DGYYeUwezzY1gl7Z1GGAsw2UVFttoh5txkVmW3Kc=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=cYjPwjA5d/OyFhJBToyryT/P+wgWXCUHT6PuhR2sqPWdkqKAFHClQoPQe0LcYCxjQ
	 YSu3ZaVngHcvkf8A4I0Ay7XdquVqs4YNiL6bzMYfH3B+cAXxOUR/jVGmOKdUgqHT31
	 v9a84JWu+FPIV6Jfkole/7sF9LJhJAsROgH70Zhw=
Date: Sun, 22 Nov 2026 20:03:26 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261111234402.252354-2-phillip@squashfs.org.uk>
References: <20261111234402.252354-2-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-convert-squashfs_compressed_-to-inline-functions.patch removed from -mm tree
Message-Id: <20261123040326.A66041F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: convert SQUASHFS_COMPRESSED_* to inline functions
has been removed from the -mm tree.  Its filename was
     squashfs-convert-squashfs_compressed_-to-inline-functions.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: convert SQUASHFS_COMPRESSED_* to inline functions
Date: Wed, 11 Nov 2026 23:43:41 +0000

Patch series "Squashfs: fix a lot of AI issues and AI style issues", v2.

This large patch-set is inspired by the recent spate of AI generated
code reports.  Four of the patches directly fix AI reported issues, and
the rest have been found manually by a read-through and testing of the
code.

In all cases (except patches 17, 18 and 19) the patches deal with
over-sights relating to variable overflow, arithmetic overflow, variable
signedness or just lack of sanity checking of data read from disk.
These can cause the code to fail, and which could be used as a potential
exploit.

Patches 17, 18, and 19 fix potential excessive memory use exploits.  The
code in question was written in the early days when Squashfs filesystems
were small, but with very large filesystems it could try to allocate
memory in excess of 4 MiB, and up to 64 MiB.

The patches can be broken down as follows:

Patches 1 - 6 are preparatory patches.  They convert old fashioned
#define macros into inline functions.  These being typed make widths and
signedness explicit, and allow additional checking to be added in later
patches.

Patch 7 fixes an incorrect offset value in TRACE statements in
squashfs_read_inode().  This new to this V2 patch-set.

Patches 8 - 16 fix various issues relating to variable overflow,
arithmetic overflow and add additional sanity checking to prevent these
issues from occurring.

Patches 17 - 19 remove the excessive allocation of memory by introducing
caches, which limit the maximum usage to 4 pages.

Patches 20 - 21 are new to this V2 patch-set.  They deal with some
issues Sashiko reported in the original patch-set.

Patch 22 is also new to this V2 patch-set.  It adds an additional belts
and braces sanity check.

Patches 8 - 20 have reproducers which show how the existing code faults
can be exploited, in some cases which can allow a Squashfs filesystem
to be tampered with to make files readable by unprivileged users.


This patch (of 22):

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and sigedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://lore.kernel.org/20261111234402.252354-1-phillip@squashfs.org.uk
Link: https://patch.msgid.link/20261111234402.252354-2-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>

 fs/squashfs/block.c            |   11 +++++----
 fs/squashfs/cache.c            |    1 
 fs/squashfs/file.c             |    3 +-
 fs/squashfs/squashfs_fs.h      |   17 ---------------
 fs/squashfs/squashfs_helpers.h |   35 +++++++++++++++++++++++++++++++
 5 files changed, 44 insertions(+), 23 deletions(-)

--- a/fs/squashfs/block.c~squashfs-convert-squashfs_compressed_-to-inline-functions
+++ a/fs/squashfs/block.c
@@ -23,6 +23,7 @@
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "decompressor.h"
 #include "page_actor.h"
@@ -292,7 +293,7 @@ int squashfs_read_data(struct super_bloc
 {
 	struct squashfs_sb_info *msblk = sb->s_fs_info;
 	struct bio *bio = NULL;
-	int compressed;
+	bool compressed;
 	int res;
 	int offset;
 
@@ -300,8 +301,8 @@ int squashfs_read_data(struct super_bloc
 		/*
 		 * Datablock.
 		 */
-		compressed = SQUASHFS_COMPRESSED_BLOCK(length);
-		length = SQUASHFS_COMPRESSED_SIZE_BLOCK(length);
+		compressed = squashfs_compressed_block(length);
+		length = squashfs_compressed_size_block(length);
 		TRACE("Block @ 0x%llx, %scompressed size %d, src size %d\n",
 			index, compressed ? "" : "un", length, output->length);
 	} else {
@@ -341,8 +342,8 @@ int squashfs_read_data(struct super_bloc
 		bio_uninit(bio);
 		kfree(bio);
 
-		compressed = SQUASHFS_COMPRESSED(length);
-		length = SQUASHFS_COMPRESSED_SIZE(length);
+		compressed = squashfs_compressed(length);
+		length = squashfs_compressed_size(length);
 		index += 2;
 
 		TRACE("Block @ 0x%llx, %scompressed size %d\n", index - 2,
--- a/fs/squashfs/cache.c~squashfs-convert-squashfs_compressed_-to-inline-functions
+++ a/fs/squashfs/cache.c
@@ -42,6 +42,7 @@
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "page_actor.h"
 
--- a/fs/squashfs/file.c~squashfs-convert-squashfs_compressed_-to-inline-functions
+++ a/fs/squashfs/file.c
@@ -39,6 +39,7 @@
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 #include "page_actor.h"
 
@@ -188,7 +189,7 @@ static long long read_indexes(struct sup
 				err = size;
 				goto failure;
 			}
-			block += SQUASHFS_COMPRESSED_SIZE_BLOCK(size);
+			block += squashfs_compressed_size_block(size);
 		}
 		n -= blocks;
 	}
--- a/fs/squashfs/squashfs_fs.h~squashfs-convert-squashfs_compressed_-to-inline-functions
+++ a/fs/squashfs/squashfs_fs.h
@@ -101,22 +101,6 @@
 #define SQUASHFS_XATTR_VALUE_OOL        256
 #define SQUASHFS_XATTR_PREFIX_MASK      0xff
 
-/* Flag whether block is compressed or uncompressed, bit is set if block is
- * uncompressed */
-#define SQUASHFS_COMPRESSED_BIT		(1 << 15)
-
-#define SQUASHFS_COMPRESSED_SIZE(B)	(((B) & ~SQUASHFS_COMPRESSED_BIT) ? \
-		(B) & ~SQUASHFS_COMPRESSED_BIT :  SQUASHFS_COMPRESSED_BIT)
-
-#define SQUASHFS_COMPRESSED(B)		(!((B) & SQUASHFS_COMPRESSED_BIT))
-
-#define SQUASHFS_COMPRESSED_BIT_BLOCK	(1 << 24)
-
-#define SQUASHFS_COMPRESSED_SIZE_BLOCK(B)	((B) & \
-						~SQUASHFS_COMPRESSED_BIT_BLOCK)
-
-#define SQUASHFS_COMPRESSED_BLOCK(B)	(!((B) & SQUASHFS_COMPRESSED_BIT_BLOCK))
-
 static inline int squashfs_block_size(__le32 raw)
 {
 	u32 size = le32_to_cpu(raw);
@@ -449,5 +433,4 @@ struct squashfs_xattr_id_table {
 	__le32			xattr_ids;
 	__le32			unused;
 };
-
 #endif
diff --git a/fs/squashfs/squashfs_helpers.h a/fs/squashfs/squashfs_helpers.h
new file mode 100644
--- /dev/null
+++ a/fs/squashfs/squashfs_helpers.h
@@ -0,0 +1,35 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef SQUASHFS_HELPERS_H
+#define SQUASHFS_HELPERS_H
+/*
+ * Copyright (c) 2026
+ * Phillip Lougher <phillip@squashfs.org.uk>
+ */
+
+/* Flag whether block is compressed or uncompressed, bit is set if block is
+ * uncompressed
+ */
+#define SQUASHFS_COMPRESSED_BIT		(1 << 15)
+
+static inline s16 squashfs_compressed_size(s16 size)
+{
+	return size & ~SQUASHFS_COMPRESSED_BIT;
+}
+
+static inline bool squashfs_compressed(s16 size)
+{
+	return (size & SQUASHFS_COMPRESSED_BIT) == 0;
+}
+
+#define SQUASHFS_COMPRESSED_BIT_BLOCK		(1 << 24)
+
+static inline s32 squashfs_compressed_size_block(s32 size)
+{
+	return size & ~SQUASHFS_COMPRESSED_BIT_BLOCK;
+}
+
+static inline bool squashfs_compressed_block(s32 size)
+{
+	return (size & SQUASHFS_COMPRESSED_BIT_BLOCK) == 0;
+}
+#endif
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

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
a.patch

