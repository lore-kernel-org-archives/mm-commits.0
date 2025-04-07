Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B851314F123
	for <mm-commits@vger.kernel.org>; Mon,  7 Apr 2025 05:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744002152; cv=none; b=jT8Z/kPDY6uShP0GLng71n6rB7vekzfocgB7ANc7TAeMtxsUyfQflp4bLZnWwlil1axDkrxx46edX0KkSU5E2VhvTUFVITX0FJPuxmqKyyTQtgl7acV7zcGt+G7PsJ03wurxE02vzAtDg0pzODxyyEdC9AAg0fbMySf+LalZ+zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744002152; c=relaxed/simple;
	bh=1RCWgTrLBCSm0rrvm5dPh+W6Sk1moSHpnk7YLOWdr5Q=;
	h=Date:To:From:Subject:Message-Id; b=bTdZZs715mNFUzyN3Zv0HkiAR/R6tSiutkWVRbPvOF2oyIJiJbeHoAIUfbl7ogjONNzOKuAD+eh9G16DP5F6YXa6zE5odZWIuNBOCdw+fbI7lmUrNrRhWTc9qiO/eg7zPhacFyfTaDvlUNpmp5bAC7B7Mib3isnispXWmI4A5EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mMx+4jl4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mMx+4jl4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19E1AC4CEDD;
	Mon,  7 Apr 2025 05:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744002152;
	bh=1RCWgTrLBCSm0rrvm5dPh+W6Sk1moSHpnk7YLOWdr5Q=;
	h=Date:To:From:Subject:From;
	b=mMx+4jl41j8j4MmjPAtd/iQYVWYlxFZC5XlM89rhhZ84xs5wCaeGRV/EMrUqSiG6r
	 RR21R9aujNdjeybWO6IX59R1Oc0Uj0I9bDWR47xhHohsRGhPvQ3m1FoU3O8RGcvPgM
	 2Kj5/l0dhUScrY/6iWY95htL2IBIXp0dL5yK4NiQ=
Date: Sun, 06 Apr 2025 22:02:31 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,lorenzo.stoakes@oracle.com,david@redhat.com,corbet@lwn.net,avagin@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + tools-headers-uapi-sync-linux-fsh-with-the-kernel-sources.patch added to mm-new branch
Message-Id: <20250407050232.19E1AC4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: tools headers UAPI: sync linux/fs.h with the kernel sources
has been added to the -mm mm-new branch.  Its filename is
     tools-headers-uapi-sync-linux-fsh-with-the-kernel-sources.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/tools-headers-uapi-sync-linux-fsh-with-the-kernel-sources.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Andrei Vagin <avagin@gmail.com>
Subject: tools headers UAPI: sync linux/fs.h with the kernel sources
Date: Mon, 24 Mar 2025 06:53:27 +0000

Required for a new PAGEMAP_SCAN test to verify guard region reporting.

Link: https://lkml.kernel.org/r/20250324065328.107678-3-avagin@google.com
Signed-off-by: Andrei Vagin <avagin@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/include/uapi/linux/fs.h |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

--- a/tools/include/uapi/linux/fs.h~tools-headers-uapi-sync-linux-fsh-with-the-kernel-sources
+++ a/tools/include/uapi/linux/fs.h
@@ -40,6 +40,15 @@
 #define BLOCK_SIZE_BITS 10
 #define BLOCK_SIZE (1<<BLOCK_SIZE_BITS)
 
+/* flags for integrity meta */
+#define IO_INTEGRITY_CHK_GUARD		(1U << 0) /* enforce guard check */
+#define IO_INTEGRITY_CHK_REFTAG		(1U << 1) /* enforce ref check */
+#define IO_INTEGRITY_CHK_APPTAG		(1U << 2) /* enforce app check */
+
+#define IO_INTEGRITY_VALID_FLAGS (IO_INTEGRITY_CHK_GUARD | \
+				  IO_INTEGRITY_CHK_REFTAG | \
+				  IO_INTEGRITY_CHK_APPTAG)
+
 #define SEEK_SET	0	/* seek relative to beginning of file */
 #define SEEK_CUR	1	/* seek relative to current file position */
 #define SEEK_END	2	/* seek relative to end of file */
@@ -329,9 +338,16 @@ typedef int __bitwise __kernel_rwf_t;
 /* per-IO negation of O_APPEND */
 #define RWF_NOAPPEND	((__force __kernel_rwf_t)0x00000020)
 
+/* Atomic Write */
+#define RWF_ATOMIC	((__force __kernel_rwf_t)0x00000040)
+
+/* buffered IO that drops the cache after reading or writing data */
+#define RWF_DONTCACHE	((__force __kernel_rwf_t)0x00000080)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
-			 RWF_APPEND | RWF_NOAPPEND)
+			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC |\
+			 RWF_DONTCACHE)
 
 #define PROCFS_IOCTL_MAGIC 'f'
 
@@ -347,6 +363,7 @@ typedef int __bitwise __kernel_rwf_t;
 #define PAGE_IS_PFNZERO		(1 << 5)
 #define PAGE_IS_HUGE		(1 << 6)
 #define PAGE_IS_SOFT_DIRTY	(1 << 7)
+#define PAGE_IS_GUARD		(1 << 8)
 
 /*
  * struct page_region - Page region with flags
_

Patches currently in -mm which might be from avagin@gmail.com are

fs-proc-extend-the-pagemap_scan-ioctl-to-report-guard-regions.patch
tools-headers-uapi-sync-linux-fsh-with-the-kernel-sources.patch
selftests-mm-add-pagemap_scan-guard-region-test.patch

