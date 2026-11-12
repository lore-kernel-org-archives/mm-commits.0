Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510616;
	b=RsLiJA0xPrUdIyeJV0ScG9o8JPCXUdRpdkSzkw1lQtkg6x7vSy7rqRFtS9NKvV/JQn03
	 bXpXxWAowoVIWgwaYmtIZOJr9CFPzFmEhT5wXy8JY2jMAvSoQGwNvE5N5rY0SQO1PlVi5
	 /PkcTk3OZEc3q2nY02J71zZXdcqkrQQtYNLAhRlqHawox+GLgSvd+eZE59tHQHjqBWug9
	 mqZVl2lAnKptxaNSTCz9AWpyjTdSEhUsKf5xLtYFtszaxPFnloA89jJOXFudFZ8wrzfB4
	 ARmSPLHA0DRLP2amiRMTrLfYmWqd7W5C5+UfjXPA5eC6mwH5Qvuezl6vRWfd/XKRhJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510616;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=K4NruQ8ZAlEF745MBUZqGhV18oUrzE/sSwB9jiNfdQk=;
	b=xxQr86KLty91KJIkjZyRhhAnEhA9H8qXBiC3b8qu3TxVuxdSPB6/CwJbKRSgQFxmC8ad
	 oRpQTrT/KePdkyeyHouf5qkicEX7IzsuLhp4WeWHQAndep2UMnX4lLIM5xP3fDJJTnXCS
	 Gh/5E7V7twdjApHwQ8hd5vg9E3CBolouW62MNqEVJYjDhxhk+6XB9+gaNtP2zYenHL2Ha
	 UcX6jwf4WSod9qqhGi6tzymRi34dBYg5E2Z2E58l0Aq7NcY5UDO+2WArPdw0jjdisW63L
	 Kqz89NDpgFH4dwVktQ2e1vVh3GgfUfc9pRtGF4vU50nwjX0KRdYy2Y40HdwSmCT6EqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CBykXsQK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22740606A333
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 19:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=CBykXsQK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA0F1F000C4;
	Thu, 12 Nov 2026 19:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794510615;
	bh=K4NruQ8ZAlEF745MBUZqGhV18oUrzE/sSwB9jiNfdQk=;
	h=Date:To:From:Subject;
	b=CBykXsQKYMkSwSWDQ8Sjqktktj4okzfNncTxetUoScUq7Gc+3vMxLxKwvmrLfr/3Z
	 xSHh5MTeAprGucwCU1ab2VrKrzvXl1UudOqy5738SLnxH8o7sqVFG+G7iS4EO9qOcl
	 uKWY6WNyEIqaDeF21AEDCgtbPXTMB3x+GwF9m9h0=
Date: Thu, 12 Nov 2026 11:10:15 -0800
To: mm-commits@vger.kernel.org,phillip.lougher@gmail.com,
	phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-convert-squashfs_compressed_-to-inline-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20261112191015.9DA0F1F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: convert SQUASHFS_COMPRESSED_* to inline functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-convert-squashfs_compressed_-to-inline-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-convert-squashfs_compressed_-to-inline-functions.patch

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
Link: https://lore.kernel.org/20261111234402.252354-2-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
---

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

