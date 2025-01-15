Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B0017ADF7
	for <mm-commits@vger.kernel.org>; Wed, 15 Jan 2025 03:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736911483; cv=none; b=IisivFYv58efK8zCvSfYPbJ3YEmmeZYwbETfe2a3B7rJMRoSWUkEhV5m14icpK9SzhzlWsP8v3PnoGZZpoVXcX5S3oCVJgfbFCfFt6R9+a+RxB0k5ykBLbJreodnouljqqMYPUweera9w8YWZ+/ImN6HfDD18NJt0HLeOy/93qM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736911483; c=relaxed/simple;
	bh=Nvtzcvh9x93BzT3zXzwptP7SXfujQGUWfPxdjubok9A=;
	h=Date:To:From:Subject:Message-Id; b=hLTYquF7xsEh4dIBjgUdt1Sg65YXwPmNBkVZ1Gz/dU1L5+7LBm3aMPu28DswYI5PB29XOvR6SrPBkubbZdDb3JM+ND5RfePjXTS+a0MR3QlqJGmS9FwjwJSJ3xkPd8pwUAHJsigLWz2IahLBXafKzsR5WozrE2uoyUzDWzhR8lI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YVqCdchX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YVqCdchX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CBB9C4CEDD;
	Wed, 15 Jan 2025 03:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736911483;
	bh=Nvtzcvh9x93BzT3zXzwptP7SXfujQGUWfPxdjubok9A=;
	h=Date:To:From:Subject:From;
	b=YVqCdchXIrGJCYokROqXzIbA1IAbVvis20vxQyRzzEvQrSg24MUzkKxZ1wtWb5wbC
	 hQBHBVYs71c0kV56wUOpKBQaS4xISd5v9hNxXUmrz+EsOrvGJeEozp5f3evKubSt+C
	 b8dI2sYoN2Z/s2ss+lN+q2rjP2G+5as63LBg2txc=
Date: Tue, 14 Jan 2025 19:24:42 -0800
To: mm-commits@vger.kernel.org,zbestahu@gmail.com,yann.collet.73@gmail.com,terrelln@fb.com,dhavale@google.com,chao@kernel.org,hsiangkao@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + include-linux-lz4h-add-some-missing-macros.patch added to mm-nonmm-unstable branch
Message-Id: <20250115032443.4CBB9C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: include/linux/lz4.h: add some missing macros
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     include-linux-lz4h-add-some-missing-macros.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/include-linux-lz4h-add-some-missing-macros.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: include/linux/lz4.h: add some missing macros
Date: Tue, 14 Jan 2025 21:04:54 +0800

Currently, LZ4_DISTANCE_MAX and LZ4_DECOMPRESS_INPLACE_MARGIN are
defined in the erofs subsystem for LZ4 in-place decompression, which is
somewhat unsuitable since they should belong to the LZ4 itself and
may change with future LZ4 codebase updates.

Move them to include/linux/lz4.h to match the upstream LZ4 library [1].
No logic changes.

[1] https://github.com/lz4/lz4/blob/v1.10.0/lib/lz4.h#L670

Link: https://lkml.kernel.org/r/20250114130454.1191150-1-hsiangkao@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Yann Collet <yann.collet.73@gmail.com>
Cc: Nick Terrell <terrelln@fb.com>
Cc: Chao Yu <chao@kernel.org>
Cc: Yue Hu <zbestahu@gmail.com>
Cc; Jeffle Xu <jefflexu@linux.alibaba.com>
Cc: Sandeep Dhavale <dhavale@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/erofs/decompressor.c  |    7 -------
 include/linux/lz4.h      |    6 ++++++
 lib/lz4/lz4_compress.c   |    1 -
 lib/lz4/lz4_decompress.c |    1 -
 lib/lz4/lz4defs.h        |    4 ++--
 lib/lz4/lz4hc_compress.c |    1 -
 6 files changed, 8 insertions(+), 12 deletions(-)

--- a/fs/erofs/decompressor.c~include-linux-lz4h-add-some-missing-macros
+++ a/fs/erofs/decompressor.c
@@ -7,14 +7,7 @@
 #include "compress.h"
 #include <linux/lz4.h>
 
-#ifndef LZ4_DISTANCE_MAX	/* history window size */
-#define LZ4_DISTANCE_MAX 65535	/* set to maximum value by default */
-#endif
-
 #define LZ4_MAX_DISTANCE_PAGES	(DIV_ROUND_UP(LZ4_DISTANCE_MAX, PAGE_SIZE) + 1)
-#ifndef LZ4_DECOMPRESS_INPLACE_MARGIN
-#define LZ4_DECOMPRESS_INPLACE_MARGIN(srcsize)  (((srcsize) >> 8) + 32)
-#endif
 
 struct z_erofs_lz4_decompress_ctx {
 	struct z_erofs_decompress_req *rq;
--- a/include/linux/lz4.h~include-linux-lz4h-add-some-missing-macros
+++ a/include/linux/lz4.h
@@ -645,4 +645,10 @@ int LZ4_decompress_safe_usingDict(const
 int LZ4_decompress_fast_usingDict(const char *source, char *dest,
 	int originalSize, const char *dictStart, int dictSize);
 
+#define LZ4_DECOMPRESS_INPLACE_MARGIN(compressedSize)          (((compressedSize) >> 8) + 32)
+
+#ifndef LZ4_DISTANCE_MAX	/* history window size; can be user-defined at compile time */
+#define LZ4_DISTANCE_MAX 65535	/* set to maximum value by default */
+#endif
+
 #endif
--- a/lib/lz4/lz4_compress.c~include-linux-lz4h-add-some-missing-macros
+++ a/lib/lz4/lz4_compress.c
@@ -33,7 +33,6 @@
 /*-************************************
  *	Dependencies
  **************************************/
-#include <linux/lz4.h>
 #include "lz4defs.h"
 #include <linux/module.h>
 #include <linux/kernel.h>
--- a/lib/lz4/lz4_decompress.c~include-linux-lz4h-add-some-missing-macros
+++ a/lib/lz4/lz4_decompress.c
@@ -33,7 +33,6 @@
 /*-************************************
  *	Dependencies
  **************************************/
-#include <linux/lz4.h>
 #include "lz4defs.h"
 #include <linux/init.h>
 #include <linux/module.h>
--- a/lib/lz4/lz4defs.h~include-linux-lz4h-add-some-missing-macros
+++ a/lib/lz4/lz4defs.h
@@ -39,6 +39,7 @@
 
 #include <linux/bitops.h>
 #include <linux/string.h>	 /* memset, memcpy */
+#include <linux/lz4.h>
 
 #define FORCE_INLINE __always_inline
 
@@ -92,8 +93,7 @@ typedef uintptr_t uptrval;
 #define MB (1 << 20)
 #define GB (1U << 30)
 
-#define MAXD_LOG 16
-#define MAX_DISTANCE ((1 << MAXD_LOG) - 1)
+#define MAX_DISTANCE LZ4_DISTANCE_MAX
 #define STEPSIZE sizeof(size_t)
 
 #define ML_BITS	4
--- a/lib/lz4/lz4hc_compress.c~include-linux-lz4h-add-some-missing-macros
+++ a/lib/lz4/lz4hc_compress.c
@@ -34,7 +34,6 @@
 /*-************************************
  *	Dependencies
  **************************************/
-#include <linux/lz4.h>
 #include "lz4defs.h"
 #include <linux/module.h>
 #include <linux/kernel.h>
_

Patches currently in -mm which might be from hsiangkao@linux.alibaba.com are

include-linux-lz4h-add-some-missing-macros.patch

