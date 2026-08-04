Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FC44ADD9B
	for <mm-commits@vger.kernel.org>; Tue,  4 Aug 2026 19:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785873581; cv=none; b=tn5mw9+vClMw7xQEmeEnDBBORq5aTn83z4TOZJ6vpWTal7UOtDLPbrpN59j6a106UVG7DVXPztaKFuSF27OThVRX2edzS/9M2EbrUGKYizij8OdYX17wEq6Bj5NQk4Fqy4xvjbULqY/JJ3F4fz4LOjoNdq3W4a3/aBb4PLZQuZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785873581; c=relaxed/simple;
	bh=CxeIS5rumZwwI+eqRJ/UO+CA4UY+u0UaeLc1dZ10Rng=;
	h=Date:To:From:Subject:Message-Id; b=NLSrHbSPyhlh39fLWSQhU4CC9BoxBZdP3nR3xbtJYoEp4CdaijvMKxh4DTACMxFFlz9HAt5rHcHj9LkNlLM+UKy/zeo+hHDGGWMXrDUqUa03Dh5l9LC3C1FTevKoMdn+QqBT4PDwOdM1ARAoqvCRKeKwF+Oe0Sll92Z0xY6U9hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=B4YVj9uS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="B4YVj9uS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08621F000E9;
	Tue,  4 Aug 2026 19:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785873579;
	bh=GF1Tvq+FhIsMXjC9bjPkXajSg0VUkzsV6CGCgvvA4LA=;
	h=Date:To:From:Subject;
	b=B4YVj9uS0ccEgHbL/KKANqozf6NcnppBWSyIqlQFv5krs1m2fBGlG/Ha4WeN3gyUw
	 J5NWG1QLF/VOF1W04+09rDHgLZHnEnT0vkFVLg12Hi8dPKFID88auLDyzCAfvInChI
	 vSXHU92NXq+i7f3BM2NrsX6cVWQMLrAvxZy+GT6w=
Date: Tue, 04 Aug 2026 12:59:39 -0700
To: mm-commits@vger.kernel.org,zigiwang@tencent.com,terrelln@fb.com,senozhatsky@chromium.org,minchan@kernel.org,dsterba@suse.com,axboe@kernel.dk,haoqinhuang@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-add-pr_fmt-to-backend-files.patch added to mm-new branch
Message-Id: <20260804195939.A08621F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: add pr_fmt to backend files
has been added to the -mm mm-new branch.  Its filename is
     zram-add-pr_fmt-to-backend-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-add-pr_fmt-to-backend-files.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: Haoqin Huang <haoqinhuang@tencent.com>
Subject: zram: add pr_fmt to backend files
Date: Tue, 4 Aug 2026 17:38:39 +0800

Add pr_fmt to each backend so that pr_err() messages are auto-prefixed
with the algorithm name.  While at it, tweak the deflate winbits pr_err to
avoid a duplicated "deflate" prefix.

Link: https://lore.kernel.org/20260804093841.67920-4-haoqinhuang7@gmail.com
Signed-off-by: Haoqin Huang <haoqinhuang@tencent.com>
Signed-off-by: Rongwei Wang <zigiwang@tencent.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nick Terrell <terrelln@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/backend_842.c     |    2 ++
 drivers/block/zram/backend_deflate.c |    4 +++-
 drivers/block/zram/backend_lz4.c     |    4 ++++
 drivers/block/zram/backend_lz4hc.c   |    4 ++++
 drivers/block/zram/backend_lzo.c     |    2 ++
 drivers/block/zram/backend_lzorle.c  |    2 ++
 drivers/block/zram/backend_zstd.c    |    2 ++
 7 files changed, 19 insertions(+), 1 deletion(-)

--- a/drivers/block/zram/backend_842.c~zram-add-pr_fmt-to-backend-files
+++ a/drivers/block/zram/backend_842.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#define pr_fmt(fmt) "842: " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/sw842.h>
--- a/drivers/block/zram/backend_deflate.c~zram-add-pr_fmt-to-backend-files
+++ a/drivers/block/zram/backend_deflate.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#define pr_fmt(fmt) "deflate: " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
@@ -30,7 +32,7 @@ static int deflate_setup_params(struct z
 		s32 wb = params->deflate.winbits;
 
 		if ((wb < -15 || wb > -9) && (wb < 9 || wb > 15)) {
-			pr_err("invalid deflate winbits: %d\n", wb);
+			pr_err("invalid winbits %d\n", wb);
 			return -EINVAL;
 		}
 	}
--- a/drivers/block/zram/backend_lz4.c~zram-add-pr_fmt-to-backend-files
+++ a/drivers/block/zram/backend_lz4.c
@@ -1,3 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#define pr_fmt(fmt) "lz4: " fmt
+
 #include <linux/kernel.h>
 #include <linux/lz4.h>
 #include <linux/slab.h>
--- a/drivers/block/zram/backend_lz4hc.c~zram-add-pr_fmt-to-backend-files
+++ a/drivers/block/zram/backend_lz4hc.c
@@ -1,3 +1,7 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+#define pr_fmt(fmt) "lz4hc: " fmt
+
 #include <linux/kernel.h>
 #include <linux/lz4.h>
 #include <linux/slab.h>
--- a/drivers/block/zram/backend_lzo.c~zram-add-pr_fmt-to-backend-files
+++ a/drivers/block/zram/backend_lzo.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#define pr_fmt(fmt) "lzo: " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/lzo.h>
--- a/drivers/block/zram/backend_lzorle.c~zram-add-pr_fmt-to-backend-files
+++ a/drivers/block/zram/backend_lzorle.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#define pr_fmt(fmt) "lzo-rle: " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/lzo.h>
--- a/drivers/block/zram/backend_zstd.c~zram-add-pr_fmt-to-backend-files
+++ a/drivers/block/zram/backend_zstd.c
@@ -1,5 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
 
+#define pr_fmt(fmt) "zstd: " fmt
+
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
_

Patches currently in -mm which might be from haoqinhuang@tencent.com are

zram-do-not-release-zstd-global-params-from-error-paths.patch
zram-reject-zero-size-dictionary.patch
zram-add-pr_fmt-to-backend-files.patch
zram-validate-parameters-in-each-backends-setup_params.patch
zram-reset-per-priority-params-when-changing-algorithm-before-init.patch

