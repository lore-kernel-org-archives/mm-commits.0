Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794510624;
	b=u9Ej5Vc88pZRYKr/CiiBjC1J0DXjl0eEpH4C5zRqGsPAk7TXeNAklH6IgEY+8R/okQ/1
	 Hy5n3siq/+gclvS7z8zQSFKG5Sn0f5PvW+M1i/Qp7+ju4PMkReTWGhky1uVqmAS07nGmE
	 a8pADgdYDeThN69ql7HDKrwj0nDlHNm08+7fur5VbM+U66i/QE9nPvDUfQkibpKFOKc6Q
	 wRNu5GM+t12BLeBsz5l5CibS9wxFZ+vKuAdeMVjxOCR+X+AVVE8bqV5tKUxVHoxPe7TJL
	 X+j5pR/6Fp1xJgeDwwq8Re/RW/oBEKrtf8yjUp8zLWu8uMe/g0BVIlj0gb8TsZ60DpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794510624;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=knM/tfqnGPWgwMyNydnAAjobnZeCtLC7EP8WbZHOVPo=;
	b=uXFP1n6BeJGdeUPfJrPvCp/e8wr6eVjM8MAiP74815rfs0re+ibi2sBjA6tqy3lajheU
	 oEtuja7ZAKFJZvL27Tj9UOEzxTa/SoBTEtUcRB7pfUNdNUnM8MIwRXy3q0bk9NSxuM0HD
	 JRYyF0IK23kTD8QO2xMB76VpbGJvcSfWgChLWTo0/1XydJ0vkoIJwST6/cIcTHfVm5wHp
	 s4yNo1HbPLULoasYYufagxOBIM6UDnOEt+iq2yFQLDJ1eEGT4PmdTBE6+UZclxe+zOsex
	 e+z+9SuTKTsUb1ySPzL31lkWdHx79UCRUc0vtOZAQaNls538yH2XWBD4DYbPHllrovA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="BOXK/fm/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C48606A888
	for <mm-commits@vger.kernel.org>; Thu, 12 Nov 2026 19:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BOXK/fm/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40AA71F000C4;
	Thu, 12 Nov 2026 19:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794510624;
	bh=knM/tfqnGPWgwMyNydnAAjobnZeCtLC7EP8WbZHOVPo=;
	h=Date:To:From:Subject;
	b=BOXK/fm/4SldyChgfvBqeSWcbEIVtGgqNbMDpbAQQyUoEX4hEuuG2Um+YGJRvGISp
	 m/iamPgf/mf9mDtII0x59fjf0l57kVMSPPdc/EuVsUxFRfZjcjL+/Q/sk7v6d72gVp
	 MyZhe6cYsAX6+hGeCDDh1vhCMTjXBvvZz3flD8YE=
Date: Thu, 12 Nov 2026 11:10:23 -0800
To: mm-commits@vger.kernel.org,phillip.lougher@gmail.com,
	phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-convert-squashfs_fragment_-to-inline-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20261112191024.40AA71F000C4@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: Squashfs: convert SQUASHFS_FRAGMENT_* to inline functions
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-convert-squashfs_fragment_-to-inline-functions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-convert-squashfs_fragment_-to-inline-functions.patch

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

Link: https://lore.kernel.org/20261111234402.252354-4-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Phillip Lougher <phillip.lougher@gmail.com>
---

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

