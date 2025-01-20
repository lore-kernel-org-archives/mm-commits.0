Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F294A1E
	for <mm-commits@vger.kernel.org>; Mon, 20 Jan 2025 02:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737338460; cv=none; b=V/Kd4yP5puJPXC1uCrCx5UaH6yP11K0IGH7w0B/t3ReljiScrbB8OEhCMPRvndyzDlLN+sKgsH0NQEArQG+4R/5LnLW/g8ap+wmjeS8yKf+lAQcU+V9uR46fpb/Z3BelFY5JsT3Jbu9baEWyjnZ5VQ+86z6a3W3cluzwj1ty3IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737338460; c=relaxed/simple;
	bh=q+Dl3ZMtywIEa1UDpVjuwpLXD8/SFMLvbEo9kKCS52o=;
	h=Date:To:From:Subject:Message-Id; b=QozsdS2dqa1Y/d7ohFmrCGMnrcFbvvaaThslnGk0dusjzbc2FMcNnZiD7gFJQlLQScJCB858yMHo4xooTeb1cnWZUTN+M2o0vZhRgndWzaWm4X+eQxr7EEATCg7pwXP2ierFzS+Nc9+Qn4gXQbOBqD7CT3VaXdx6iM+pzpSqT/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CtGu2IO/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CtGu2IO/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B8EC4CED6;
	Mon, 20 Jan 2025 02:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1737338460;
	bh=q+Dl3ZMtywIEa1UDpVjuwpLXD8/SFMLvbEo9kKCS52o=;
	h=Date:To:From:Subject:From;
	b=CtGu2IO/kkljM+JpeLdl1MPSEFb0kKwSZ/OYvBCE5LW6pC9fn3+tJtHoL58Uv2CAQ
	 /RKdWrRpR/3HJvcp8POpioyyMjXyTXwkgmGtgnZ/9IbvmVNqY8W6ZZmz5jpAqctqnK
	 cdIDD4xwwHmIghpOZMAT97dCdWfvCooCxYvoRJsc=
Date: Sun, 19 Jan 2025 18:00:59 -0800
To: mm-commits@vger.kernel.org,zbestahu@gmail.com,yann.collet.73@gmail.com,terrelln@fb.com,dhavale@google.com,chao@kernel.org,hsiangkao@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] include-linux-lz4h-add-some-missing-macros.patch removed from -mm tree
Message-Id: <20250120020059.E8B8EC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: include/linux/lz4.h: add some missing macros
has been removed from the -mm tree.  Its filename was
     include-linux-lz4h-add-some-missing-macros.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


