Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585282;
	b=QX+6MTMwW0CwFbABwHbGfz+Tu4qPQEKg17TJSOoOIuMQQDAlgZ/UoSVe0KtekOaJQTF6
	 mLFEFr1omdg7q0+HFW0r/AEmV+6lfYrVClybJpZmfW5mLIm63egWO6c/CS2vE2Rt9whbB
	 dxqCW5ybytAPImRU46iAzIAb4Zmc/zUBVZ4cz+4CbK02KOKSBwapWDUfSZV5d37Usj/cC
	 nX4xVJQJ++EBWtoYDKowUP0lnCih/xv3ClluoBW6epTeCVm8vseq3//HrWRgwMkgnmqFv
	 DM00BAJ50cPPZHjSGi9RuSV+l2Jy4jb36YZTEnFcrAAilO+P+IIVjxEAy/4YlZSJ/Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585282;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=U7O5K7p7dm4qU+AP9HT3ZzmnGspldd6Ej17rh+2sZ9s=;
	b=r/0d+mcZ8PkPrBaLLsbJPWhsWOOA5SRScTTYn4i6fdpe7hnQS8dbMtmsAfb5Fb7Al4xC
	 TW3pur5f9KZCB3vNEPQUX++xorINesbYtVqYCsv9RFwaZmA2LrUAnTrmKSCcqpSSnMN0X
	 GDN4nI9NZZeM4Yg751jQ+ZdcHiLf2I3F8Q78svy6UZVN1sY/Uy1LZi83SDWQ+D9s3dP82
	 SQhBvuN/eMIWGLE63x9XuGNpRDFlG27lW3vmtRhqCAuUZuT2YNfdRx290/5N9bKefL77C
	 H+j+9DpHSm0sQ9r0uzzPmtIlEzhCpTl23+ptmTE6ohEM1VG0bHH85hN6hvOZIYby/SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wCNClpbo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87B9606A323
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=wCNClpbo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17FC1F000C6;
	Wed, 25 Nov 2026 05:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585282;
	bh=U7O5K7p7dm4qU+AP9HT3ZzmnGspldd6Ej17rh+2sZ9s=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=wCNClpboqHwsaSjzWA/MtOHBOSZ3OOeKA+SwyLz3tefNgm5IpNIVvKseo3pF4Lnej
	 qVecdqc2tsNWqk1QSg1FA3oAZ/aJfmywjxCnBI0L0mOfDpmzV9TCuoeByVaKfGiOUz
	 bs6UfWLPHK9vNfP8UHaTnAo9omGkZ39cuLB56NZs=
Date: Tue, 24 Nov 2026 21:41:21 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261123034304.261742-5-phillip@squashfs.org.uk>
References: <20261123034304.261742-5-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-convert-squashfs_lookup_-to-inline-functions.patch removed from -mm tree
Message-Id: <20261125054121.E17FC1F000C6@smtp.kernel.org>
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
Date: Mon, 23 Nov 2026 03:42:45 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and signedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261123034304.261742-5-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Loehle <christian.loehle@arm.com>
Cc: Dan Carpenter <error27@gmail.com>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>

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

