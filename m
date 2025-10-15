Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C832C15A8;
	Wed, 15 Oct 2025 20:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760559910; cv=none; b=qsmJOtyXDgRHySN92y8RM/k9MwYrHgiTgG/tV1OE0fOFop3NMS+MlJncdryitU3CUbMnaF9TotZynxEP3vcvaSsMHiZtFLmBOWCNBI5kRyy8azZRy+IudQ7CBOYEuRdV/Jfpxr+vI36mkMpFGxFFOC05EgJ7RbbJplO3iRhgikU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760559910; c=relaxed/simple;
	bh=ZZlGCvmSUvujse2XK/XgXxJ6PXjh0QnK5Fwt8+R5HC8=;
	h=Date:To:From:Subject:Message-Id; b=X+i0q10I2v1v/N39GLN8feQ2+692Bop7uuvCh+3bnCteNNEFKB56w4OHFEX1Za/kxlsZhqszc59A+PA1BlJtI7GxTvTNcJXoFzu6HyIMQ8+zcUORDSE7rZvuRtsJ9BR8FYE+eF3Pcf9Aq59/+oby72B/06F0LTCOQtnAo85JhN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=H229lSdx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="H229lSdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8815BC4CEF8;
	Wed, 15 Oct 2025 20:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760559907;
	bh=ZZlGCvmSUvujse2XK/XgXxJ6PXjh0QnK5Fwt8+R5HC8=;
	h=Date:To:From:Subject:From;
	b=H229lSdxpfKR1SO37P+acsOO2d+/44bd8y1Qc88uuz482yUaDZid9e0zFmRH3eUy2
	 ECWxxogSDjxRcHjXxtWly3yz3aJZzswzacIR3x2nB8DI4u/846AftOrtNUY2qPLcbc
	 2L0QyfpAgP182d8Nqi1roUrHIaWdS7rne2XbUwqQ=
Date: Wed, 15 Oct 2025 13:25:06 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,robin.murphy@arm.com,isaacmanjarres@google.com,hch@lst.de,catalin.marinas@arm.com,m.szyprowski@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc.patch removed from -mm tree
Message-Id: <20251015202507.8815BC4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dma-debug: don't report false positives with DMA_BOUNCE_UNALIGNED_KMALLOC
has been removed from the -mm tree.  Its filename was
     dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: dma-debug: don't report false positives with DMA_BOUNCE_UNALIGNED_KMALLOC
Date: Thu, 9 Oct 2025 16:15:08 +0200

Commit 370645f41e6e ("dma-mapping: force bouncing if the kmalloc() size is
not cache-line-aligned") introduced DMA_BOUNCE_UNALIGNED_KMALLOC feature
and permitted architecture specific code configure kmalloc slabs with
sizes smaller than the value of dma_get_cache_alignment().

When that feature is enabled, the physical address of some small
kmalloc()-ed buffers might be not aligned to the CPU cachelines, thus not
really suitable for typical DMA.  To properly handle that case a SWIOTLB
buffer bouncing is used, so no CPU cache corruption occurs.  When that
happens, there is no point reporting a false-positive DMA-API warning that
the buffer is not properly aligned, as this is not a client driver fault.

[m.szyprowski@samsung.com: replace is_swiotlb_allocated() with is_swiotlb_active(), per Catalin]
  Link: https://lkml.kernel.org/r/20251010173009.3916215-1-m.szyprowski@samsung.com
Link: https://lkml.kernel.org/r/20251009141508.2342138-1-m.szyprowski@samsung.com
Fixes: 370645f41e6e ("dma-mapping: force bouncing if the kmalloc() size is not cache-line-aligned")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Inki Dae <m.szyprowski@samsung.com>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/debug.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/dma/debug.c~dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc
+++ a/kernel/dma/debug.c
@@ -23,6 +23,7 @@
 #include <linux/ctype.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/swiotlb.h>
 #include <asm/sections.h>
 #include "debug.h"
 
@@ -594,7 +595,9 @@ static void add_dma_entry(struct dma_deb
 	if (rc == -ENOMEM) {
 		pr_err_once("cacheline tracking ENOMEM, dma-debug disabled\n");
 		global_disable = true;
-	} else if (rc == -EEXIST && !(attrs & DMA_ATTR_SKIP_CPU_SYNC)) {
+	} else if (rc == -EEXIST && !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
+		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
+		     is_swiotlb_active(entry->dev))) {
 		err_printk(entry->dev, entry,
 			"cacheline tracking EEXIST, overlapping mappings aren't supported\n");
 	}
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are


