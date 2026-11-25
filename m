Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795585999;
	b=btNd89l/grmXaff+QxZcQLPCZvojKLVk9Wsy3xdVglujLQ4HR15600qR46nAWDHEtIrB
	 cLjG+mqi0R/45Szhn0wEwOFYdJclyTK1CdYEC6rLSMR358Kicra6cZIk8iALulH5nAckN
	 msAzXR6Pip8D2C0g0BAT6NBRjPhktWwp+RL2qh+hj/jIqYkSe5QWrH9P/pRF/p/GhUGiU
	 GoAzMDVqwcuoyoXYNfY9odmx0kgOkCEg8Du+OJHjXPasho1USW4SCDz335ALG9/EPYRU0
	 5hDgNNnHM85NceWOB0HQw4ge9Ppl1+1uQdeQISOC0hj2uASRYVOWxNbI8YbXWiT7Z2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795585999;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=c/xaViLgWVX6OL4lFpgfgKCX+vDEXmHSiOFon/X4PW0=;
	b=0BV1c1YYG+HEfDriHxS68irGmEkwQCQYzmFZARnFcOFiH4Kt3TovKTsHHGSk1aL25Zad
	 I0kTVuOWq84/n1mQwzQhjX82GLYbthsSLI0/Eb9aZKJ6F9WvgzQrqXWNfL30kyD0L/+ms
	 03lLgYp/EMZB+CwDyVh+3fYL3xOw7V54JnDhIZ+1uc8i46BIP+Kuld5KpojLEbT8mVL5X
	 YCutFQv+MJiqY1WkCjkpqNXmr2SHrraLp2/ud5WjQz2+rvoKlx4NtX823L5Vg2Synfx6L
	 Ll4qLhlG929l2b19M2tsgmB2IaXIQIcSURi+d45Cdymu25a5kgLZmg8+RMpgf4XR4rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lVf+OThw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182F6606A31E
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 05:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lVf+OThw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA15D1F000C4;
	Wed, 25 Nov 2026 05:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795585998;
	bh=c/xaViLgWVX6OL4lFpgfgKCX+vDEXmHSiOFon/X4PW0=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=lVf+OThw1W5QHhQaJH5oFZdRiEGolwIL2WjG+mG/l51Hb336hrqGzK1/uZ7F/p5fY
	 ad6DTIVKhBDVrF6ca/Zwr8S/Ydin1f/crhPGBte8G1mU2X2CzH1s+fwpug9oUXN31W
	 8YO43DYBOLy/TnOn+p2PRYeXVvQ8uzal5X1C4oF4=
Date: Tue, 24 Nov 2026 21:53:18 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,
	akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261125014737.347231-4-phillip@squashfs.org.uk>
References: <20261125014737.347231-4-phillip@squashfs.org.uk>
Subject: + squashfs-convert-squashfs_fragment_-to-inline-functions.patch added to mm-nonmm-unstable branch
Message-Id: <20261125055318.BA15D1F000C4@smtp.kernel.org>
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
Date: Wed, 25 Nov 2026 01:47:17 +0000

Convert old fashioned #define macros into inline functions.  This has
the following improvements:

1. Inline functions are typed, which makes the width and signedness of
   input and outputs explicit, which reduces errors.

2. The inline functions enable more sanity checking to be added in
   later commits.

3. Inline functions are easier to read than #define macros, which
   improves code comprehension.

Link: https://patch.msgid.link/20261125014737.347231-4-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

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

