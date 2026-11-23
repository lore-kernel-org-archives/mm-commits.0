Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406612;
	b=Q4PDMQwJB+1oAO7sRgVofo+wRA/D/Z9Z/5rZiJXMl2qAf9Yba7gFmSLFMj72xyvXuFKy
	 73KNK/U/KPsj1b0edslcy6pt6y4hE4YHEkRo76djMvgDGcqcRtGBSJjD4Df2gsesr80UK
	 4UJ3Fw+GmHOZf3YPFw8eqFYX7WnVMtwZyuKOq3+2KvmdxaDK4DyOAngZVyPuZaZs+L2O5
	 r46PA84aCqRm/xv1UjtS1O0cqhT3rJyQw3fS6S1f0i7aOUQPyPKWeYKW9KaV5HuXh4RDa
	 1quO+TaohHKPZKNy0vzVLRstPj9VD7wRV4AFvMFN3fQBg/mK0ExdJ3yGJTS93y++K6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406612;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=1sfvI1t97aJ1OtIPx3s+YZb4WfZUxedsneOZf8ePmss=;
	b=EO6qUrqv10yYy6vFr0+emocOShaRF+lMwga78p2e/1s9b0uC8HNmUcHyt0gGVYnaXQlO
	 8udQf1N2oCBIXGg9/OgpV33rLs04eHt0N9OCcLFNWF78wjdQJq8nq1HfnmidZLY0HqChY
	 iBYWqhuzbxXjSl/M6TRXFdwS3XsNLqnHlIP91MI+HVXW2JNOAFxdwoclqzafpf1RaQzbS
	 RVrQTBt5kEoJ8vpDGnWz1b0+eVLPRJ25WV8NBxUPo1JZew7puVGuWuRF8MyMv4NVDn3Rv
	 YAkFVqHIEQlZSkWd4e9xcsHiKMU4I1TSWSPUq5QIK+s7DKqjwXPXe1KlhjooGPyuvWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gGnq6OW2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6370606A31E
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gGnq6OW2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7491F000EB;
	Mon, 23 Nov 2026 04:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406612;
	bh=1sfvI1t97aJ1OtIPx3s+YZb4WfZUxedsneOZf8ePmss=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=gGnq6OW2T37asXpZ1AeND/DbffAqfXfhqCekAHT+B+k+jCKdpZVJEtwqFCBw9WNAo
	 mHa3F6I7kaN+6nqUuaBwo/6HCLCTQsHzBbS1NXQM+y2Q23+uviylDU6UBbrMSDHBfT
	 zbLvDKxTuXaUGmoZ3gUPO8tEJ5JsiFTDJK0NlZ2Y=
Date: Sun, 22 Nov 2026 20:03:31 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261111234402.252354-5-phillip@squashfs.org.uk>
References: <20261111234402.252354-5-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-convert-squashfs_lookup_-to-inline-functions.patch removed from -mm tree
Message-Id: <20261123040331.DD7491F000EB@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: convert SQUASHFS_LOOKUP_* to inline functions
has been removed from the -mm tree.  Its filename was
     squashfs-convert-squashfs_lookup_-to-inline-functions.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: convert SQUASHFS_LOOKUP_* to inline functions
Date: Wed, 11 Nov 2026 23:43:44 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and sigedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261111234402.252354-5-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>

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

