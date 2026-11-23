Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795406610;
	b=e6dLV2o9FpZxcuZd7yuowH8DlNmzTDyldOx2tJn7GEquD8zFJCZxpW8fgNyPRVqzJFoH
	 ywudh3IRs1wHqLWFoxslYkSwYeY2PfymzTZRm0etcSMifCBwDRNWsLQsZh3oRBFx2ZFvM
	 g413OrFEKcUiakv8YeX+riDN6F2mGQmTwlSaBLOMW5U05IWs9fqygf2vJsAkEEjflU2sW
	 +fy31TpWbBHq+8zbPIWQMcbu0wLgjmcZDXG1jGaKu9i56twRJNvwXVYDnSN8vGYr7T2cL
	 s4kyWbgW1OsnVb4O2N834ByolSepSTcJoNXk6LmzI7ZX6iaQADOcazqbFqRwgOTzFTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795406610;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=N8/bGRQzrC9vd1o8SZuoE+f05rFqS3G7n8oJlFmCc9A=;
	b=QyVNsUNfnW4VvQLmKwWgbRACA2+cQkh0BXIeDg2fJhW6KDH5Or+T5PlRDJln2ULwHDoB
	 USNH8bjSNgdgEwdmaznuP3D6CdA+pPVIRKE5ROIDL4BgYjVezt5AjWj4B3vHLo0+m96vT
	 7F1IvSoXb8SKjiR92LsoUncY8LhX1ofzb/gQx+83J2xKZNQkCK1Z3YJq3vMM2MgD4/UUe
	 kp0eG1k2b0PcaMokDVIATbFX8Pa0rlxdg81KtWDCc6FIKKHYTd/61NhiRgs5Dbt0hpBLE
	 vWG7fH57JYjUtRVSApsES3Ik1IOYKtqd9qsBxEXNuHzjrpprheeI4fefebeGvk4+MJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WIpYaaaF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D051606A31A
	for <mm-commits@vger.kernel.org>; Mon, 23 Nov 2026 04:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WIpYaaaF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3322E1F000D8;
	Mon, 23 Nov 2026 04:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795406610;
	bh=N8/bGRQzrC9vd1o8SZuoE+f05rFqS3G7n8oJlFmCc9A=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=WIpYaaaF8k+6fNk56E197H1MX8ThvW9/HcsX+nLQR0Yh2NcR27nQXoTImRQgmbeBp
	 wGh3JCxTwpSMnCWE8mFbnxDejCLTM2PsKSause9C+RR/hfuwxqQ0fF0SVGWWuZ+SDC
	 JujdyQ/YfJF2mNL5T3MMAEOF5wBa8hJ2yRAxDceI=
Date: Sun, 22 Nov 2026 20:03:29 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261111234402.252354-4-phillip@squashfs.org.uk>
References: <20261111234402.252354-4-phillip@squashfs.org.uk>
Subject: [to-be-updated] squashfs-convert-squashfs_fragment_-to-inline-functions.patch removed from -mm tree
Message-Id: <20261123040330.3322E1F000D8@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: Squashfs: convert SQUASHFS_FRAGMENT_* to inline functions
has been removed from the -mm tree.  Its filename was
     squashfs-convert-squashfs_fragment_-to-inline-functions.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: convert SQUASHFS_FRAGMENT_* to inline functions
Date: Wed, 11 Nov 2026 23:43:43 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and sigedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261111234402.252354-4-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>

 fs/squashfs/fragment.c         |    7 ++++---
 fs/squashfs/squashfs_fs.h      |   17 -----------------
 fs/squashfs/squashfs_helpers.h |   27 +++++++++++++++++++++++++++
 3 files changed, 31 insertions(+), 20 deletions(-)

--- a/fs/squashfs/fragment.c~squashfs-convert-squashfs_fragment_-to-inline-functions
+++ a/fs/squashfs/fragment.c
@@ -26,6 +26,7 @@
 
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
+#include "squashfs_helpers.h"
 #include "squashfs.h"
 
 /*
@@ -42,8 +43,8 @@ int squashfs_frag_lookup(struct super_bl
 
 	if (fragment >= msblk->fragments)
 		return -EIO;
-	block = SQUASHFS_FRAGMENT_INDEX(fragment);
-	offset = SQUASHFS_FRAGMENT_INDEX_OFFSET(fragment);
+	block = squashfs_fragment_index(fragment);
+	offset = squashfs_fragment_index_offset(fragment);
 
 	start_block = le64_to_cpu(msblk->fragment_index[block]);
 
@@ -63,7 +64,7 @@ int squashfs_frag_lookup(struct super_bl
 __le64 *squashfs_read_fragment_index_table(struct super_block *sb,
 	u64 fragment_table_start, u64 next_table, unsigned int fragments)
 {
-	unsigned int length = SQUASHFS_FRAGMENT_INDEX_BYTES(fragments);
+	unsigned int length = squashfs_fragment_index_bytes(fragments);
 	__le64 *table;
 
 	/*
--- a/fs/squashfs/squashfs_fs.h~squashfs-convert-squashfs_fragment_-to-inline-functions
+++ a/fs/squashfs/squashfs_fs.h
@@ -107,23 +107,6 @@ static inline int squashfs_block_size(__
 	return (size >> 25) ? -EIO : size;
 }
 
-/* fragment and fragment table defines */
-#define SQUASHFS_FRAGMENT_BYTES(A)	\
-				((A) * sizeof(struct squashfs_fragment_entry))
-
-#define SQUASHFS_FRAGMENT_INDEX(A)	(SQUASHFS_FRAGMENT_BYTES(A) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_FRAGMENT_INDEX_OFFSET(A)	(SQUASHFS_FRAGMENT_BYTES(A) % \
-						SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_FRAGMENT_INDEXES(A)	((SQUASHFS_FRAGMENT_BYTES(A) + \
-					SQUASHFS_METADATA_SIZE - 1) / \
-					SQUASHFS_METADATA_SIZE)
-
-#define SQUASHFS_FRAGMENT_INDEX_BYTES(A)	(SQUASHFS_FRAGMENT_INDEXES(A) *\
-						sizeof(u64))
-
 /* inode lookup table defines */
 #define SQUASHFS_LOOKUP_BYTES(A)	((A) * sizeof(u64))
 
--- a/fs/squashfs/squashfs_helpers.h~squashfs-convert-squashfs_fragment_-to-inline-functions
+++ a/fs/squashfs/squashfs_helpers.h
@@ -51,4 +51,31 @@ static inline s64 squashfs_mkinode(u32 s
 {
 	return ((s64)start << 16) | offset;
 }
+
+/* fragment and fragment table defines */
+static inline s64 squashfs_fragment_bytes(u32 fragments)
+{
+	return fragments * sizeof(struct squashfs_fragment_entry);
+}
+
+static inline s32 squashfs_fragment_index(u32 fragments)
+{
+	return squashfs_fragment_bytes(fragments) / SQUASHFS_METADATA_SIZE;
+}
+
+static inline s16 squashfs_fragment_index_offset(u32 fragments)
+{
+	return squashfs_fragment_bytes(fragments) % SQUASHFS_METADATA_SIZE;
+}
+
+static inline s32 squashfs_fragment_indexes(u32 fragments)
+{
+	return (squashfs_fragment_bytes(fragments) + (SQUASHFS_METADATA_SIZE - 1)) /
+		SQUASHFS_METADATA_SIZE;
+}
+
+static inline s32 squashfs_fragment_index_bytes(u32 fragments)
+{
+	return squashfs_fragment_indexes(fragments) * sizeof(long long);
+}
 #endif
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

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

