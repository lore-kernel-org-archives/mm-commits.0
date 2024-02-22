Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E60163D5
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:03:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560224; cv=none; b=hY107PFUMOZxNlMAEXdGlnzrs1TIJbmo3ZQBCI+Shm4f6z/spmVJ7AUC4/GQ0ltg2uOZKjZJ3uT6QvFcp6UoaAjuMx7hxrwtvmjiYvebkWVk/rAPz0dR/t5aqoHjnf9q6lYidFqKrwHYXCOU+Y7iyz2zbsgjaKkD526FZG2G9TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560224; c=relaxed/simple;
	bh=53+wKX+X0qtq9WV15lQ8IqyciZ8vdNCQJHxoPPbYI2I=;
	h=Date:To:From:Subject:Message-Id; b=NzcT1RlvPMxzDuhBhNlGa6o118fX8Lw3dAHz9FejGUHJtaZ4ThW3X0LnWXjewaqiesru3Mz3r91U3HwH0RKSxv7fu7RQ9ZlPcGss+dCD/bsdMdzd4e4XIGrofa9aUwk961raoTz6jNnYS73y/CDGYIuvouInpvZOAZRrYY4GpUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WAYryle/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WAYryle/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24993C433C7;
	Thu, 22 Feb 2024 00:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560224;
	bh=53+wKX+X0qtq9WV15lQ8IqyciZ8vdNCQJHxoPPbYI2I=;
	h=Date:To:From:Subject:From;
	b=WAYryle/l1hJpoiRZxAdjTc30ILkNrnjwS787ouHZFRM8dVhn66pmaklRXTI94o0Q
	 il/l1ahoZlDn5yipN224zodkEx+2aKKtlFJm2/NnskGGh9EuujAGYkhKpClsYwFC1C
	 JaYs/dPl/fD9epQEFs/H7ziWdKHII0y9yQ8pyYY4=
Date: Wed, 21 Feb 2024 16:03:43 -0800
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,axboe@kernel.dk,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zram-do-not-allocate-physically-contiguous-strm-buffers.patch removed from -mm tree
Message-Id: <20240222000344.24993C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zram: do not allocate physically contiguous strm buffers
has been removed from the -mm tree.  Its filename was
     zram-do-not-allocate-physically-contiguous-strm-buffers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: zram: do not allocate physically contiguous strm buffers
Date: Tue, 13 Feb 2024 19:54:00 +1300

Currently zram allocates 2 physically contiguous pages per-CPU's
compression stream (we may have up to 4 streams per-CPU).  Since those
buffers are per-CPU we allocate them from CPU hotplug path, which may have
higher risks of failed allocations on devices with fragmented memory.

Switch to virtually contiguous allocations - crypto comp does not seem
impose requirements on compression working buffers to be physically
contiguous.

Link: https://lkml.kernel.org/r/20240213065400.6561-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zcomp.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zcomp.c~zram-do-not-allocate-physically-contiguous-strm-buffers
+++ a/drivers/block/zram/zcomp.c
@@ -11,6 +11,7 @@
 #include <linux/sched.h>
 #include <linux/cpu.h>
 #include <linux/crypto.h>
+#include <linux/vmalloc.h>
 
 #include "zcomp.h"
 
@@ -37,7 +38,7 @@ static void zcomp_strm_free(struct zcomp
 {
 	if (!IS_ERR_OR_NULL(zstrm->tfm))
 		crypto_free_comp(zstrm->tfm);
-	free_pages((unsigned long)zstrm->buffer, 1);
+	vfree(zstrm->buffer);
 	zstrm->tfm = NULL;
 	zstrm->buffer = NULL;
 }
@@ -53,7 +54,7 @@ static int zcomp_strm_init(struct zcomp_
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
 	 * case when compressed size is larger than the original one
 	 */
-	zstrm->buffer = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+	zstrm->buffer = vzalloc(2 * PAGE_SIZE);
 	if (IS_ERR_OR_NULL(zstrm->tfm) || !zstrm->buffer) {
 		zcomp_strm_free(zstrm);
 		return -ENOMEM;
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-zswap-increase-reject_compress_poor-but-not-reject_compress_fail-if-compression-returns-enospc.patch
mm-swapfile-__swap_duplicate-drop-redundant-write_once-on-swap_map-for-err-cases.patch
madvise-madvise_cold_or_pageout_pte_range-allow-split-while-folio_estimated_sharers-=-0.patch

