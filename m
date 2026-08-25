Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1622C2363
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622839; cv=none; b=eJ2c79RVu0Ng85r8aG5NhwM+E/prg5pFgDgywLrl1JDiD+P1cdeC/IXHGaO+ua0tERLORg+ihFauBq0+AKFfWHD0od4YJcBnBUFWOO4FohHB3z5tIUU53deYcTTc87qL5X0A/IEJru4hfUYdSu8+dDBYtjC5WM9NQKDUCIK5ero=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622839; c=relaxed/simple;
	bh=65qV6vldekZ+X+gqHj8U+01gUNL514GnOpRWXoL09o4=;
	h=Date:To:From:Subject:Message-Id; b=KPS+OAkrkiIEMZP35N2GWiulc5hYWWhCgjMWAbek7YK+lCPYIzZ9EkM9WT5dezTvVBV+LLfu5RGXoKFLfNmws0DBSDUp2tF4mJ+0eUNYT/p2eeWJtf0qylt0H/yFnztNeQ0h6FMJ7hqDXPEj4rT654yUt5nhOQpuzzfv7Rcpo4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=D3wrxTa4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="D3wrxTa4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 048461F00A3A;
	Tue, 25 Aug 2026 01:53:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622838;
	bh=+FmklLYFyxiLI0cVa5jYmibwvquO2f+dpE9UsMgKSN4=;
	h=Date:To:From:Subject;
	b=D3wrxTa4ndA/DYcsQIAFz1wnHHHfNJQRehCPYHYoEMEsAEOzUY29kA7LFSVMB4B5r
	 7mB8HnrUgmfKj7HYqmFFBM9NDKIrSRrnMHV7uWhhLc7OVhcIy7uY0VMAfjYnj4n80Y
	 3ORiNDyVEquhoTKrnjS9bHBjDLd90+kAyheetjT4=
Date: Mon, 24 Aug 2026 18:53:57 -0700
To: mm-commits@vger.kernel.org,zigiwang@tencent.com,terrelln@fb.com,senozhatsky@chromium.org,minchan@kernel.org,dsterba@suse.com,axboe@kernel.dk,haoqinhuang@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-add-pr_fmt-to-backend-files.patch removed from -mm tree
Message-Id: <20260825015358.048461F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: add pr_fmt to backend files
has been removed from the -mm tree.  Its filename was
     zram-add-pr_fmt-to-backend-files.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


