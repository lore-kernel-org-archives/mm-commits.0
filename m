Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53EB61A704B;
	Fri, 10 Oct 2025 00:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760054472; cv=none; b=WiTHmFc5XGoLsZup2uUOUl0lpTfJcxhiYxShihnJawhPYNxN9LQxcfbW9lp+RjNz0DeIGQM2PeyhVRk6opLCNnIWjSpcGiG0fvmDAEVJo8oUDYfa0iVV/f1TC8zDMGEjq8/1kOoaqlJpre1hZjD4PzoLvEivdYibk7HZ7tEkoss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760054472; c=relaxed/simple;
	bh=Nve+FDMqu5oHzuPx7ousn3dk94XJF1L/E7wJ74Vh7YE=;
	h=Date:To:From:Subject:Message-Id; b=FFSo4PGMWbvazUL/de1cXmeXBjb7z/DtOycDeCmwDyIM9DTgSvoUreV82WwpxhcteZIuvq8RGCgZ/k3WU+G7YOfU8+g2D/ePIQg0xCv0Q2CDV6Cd2sF8h4gRBURjfC4scviSCRMFz37LrMM9xks1xeTrbD7Qu4loZ1ZLOAhdRQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Q0QKg5hL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Q0QKg5hL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CE1C4CEE7;
	Fri, 10 Oct 2025 00:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760054472;
	bh=Nve+FDMqu5oHzuPx7ousn3dk94XJF1L/E7wJ74Vh7YE=;
	h=Date:To:From:Subject:From;
	b=Q0QKg5hLS+S8H1RDxNnQCSxqCCK0/+CVNCLv4qYNJZJe/yneXb/4zZRywsUVDiIst
	 Y9QU8S2VzV8vr/bAH60AUZJaDLbETQZ0pq3EAbosrU19HHHX8fJg47dgQzMju0IGSV
	 BpHT8hyBkBvDlZxsHNuSVgLXUVxAjhdW73W3cI90=
Date: Thu, 09 Oct 2025 17:01:11 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,robin.murphy@arm.com,isaacmanjarres@google.com,hch@lst.de,catalin.marinas@arm.com,m.szyprowski@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc.patch added to mm-hotfixes-unstable branch
Message-Id: <20251010000112.15CE1C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dma-debug: don't report false positives with DMA_BOUNCE_UNALIGNED_KMALLOC
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: dma-debug: don't report false positives with DMA_BOUNCE_UNALIGNED_KMALLOC
Date: Thu, 9 Oct 2025 16:15:08 +0200

Commit 370645f41e6e ("dma-mapping: force bouncing if the kmalloc() size is
not cache-line-aligned") introduced DMA_BOUNCE_UNALIGNED_KMALLOC feature
and lets architecture specific code to configure kmalloc slabs with sizes
smaller than the value of dma_get_cache_alignment().

When that feature is enabled, the physical address of some small
kmalloc()-ed buffers might be not aligned to the CPU cachelines, thus not
really suitable for typical DMA.  To properly handle that case a SWIOTLB
buffer bouncing is used, so no CPU cache corruption occurs.  When that
happens, there is no point reporting a false-positive DMA-API warning that
the buffer is not properly aligned, as this is not a client driver fault.

Link: https://lkml.kernel.org/r/20251009141508.2342138-1-m.szyprowski@samsung.com
Fixes: 370645f41e6e ("dma-mapping: force bouncing if the kmalloc() size is not cache-line-aligned")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
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
+		     is_swiotlb_allocated())) {
 		err_printk(entry->dev, entry,
 			"cacheline tracking EEXIST, overlapping mappings aren't supported\n");
 	}
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc.patch

