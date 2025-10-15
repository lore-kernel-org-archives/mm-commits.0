Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E877B1DD0D4
	for <mm-commits@vger.kernel.org>; Wed, 15 Oct 2025 20:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760559810; cv=none; b=q6Yk8AHmB44k4xmGh6nOLLzhpGQfrQXaFKmrZtwp3rvZU6TmR7MsPSIzvRlK7jMSKl5P3Agd6l/UflU63+/LW26ozufne0VdrHtkF2vOhdl8m7y3uQNMU3styN0UHxU5ihZWoAwt8qtlumItHNRlzwk7k4+BdG9mdWAWOUFUzn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760559810; c=relaxed/simple;
	bh=GtEFx61O7+BI2bYwP27MT0v3wPf3qyZh+HrT55yeLOI=;
	h=Date:To:From:Subject:Message-Id; b=qThuPnO3VL37e+XMa4V0boMwxyr8R59L/53B+TP6Fy1mu5f2ZM7p1o3RSEROqU0NaK3NUFE5oEu+22+JKgITAWHcX6ZpWKilD7PtPLOT4HB1l5cYd2oR1gCUfW0vGCNu0Koft0M4n0QL50DXYH9SWW/iimDtkUQ6nWb4bx1ezoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mEwSpA2k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mEwSpA2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66876C4CEF8;
	Wed, 15 Oct 2025 20:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760559809;
	bh=GtEFx61O7+BI2bYwP27MT0v3wPf3qyZh+HrT55yeLOI=;
	h=Date:To:From:Subject:From;
	b=mEwSpA2kZr900b9O/gt8/nrhE6uxP/F/ta26lbKxror57HzONLnIHHIBkQ6z/iGbC
	 USg+iSfq8htj5duLSllrJvEjz+39LN+xwA/qsA2Byw1hAEJ7djZ5xFSdcdX6j2YPbK
	 SJL8rjrC9pg+JaSSmXvmBqFTOwUlma0vY9qy4BjA=
Date: Wed, 15 Oct 2025 13:23:28 -0700
To: mm-commits@vger.kernel.org,robin.murphy@arm.com,isaacmanjarres@google.com,hch@lst.de,catalin.marinas@arm.com,m.szyprowski@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc-v2.patch removed from -mm tree
Message-Id: <20251015202329.66876C4CEF8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc-v2
has been removed from the -mm tree.  Its filename was
     dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc-v2.patch

This patch was dropped because it was folded into dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc.patch

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc-v2
Date: Fri, 10 Oct 2025 19:30:09 +0200

replace is_swiotlb_allocated() with is_swiotlb_active(), per Catalin

Link: https://lkml.kernel.org/r/20251010173009.3916215-1-m.szyprowski@samsung.com
Fixes: 370645f41e6e ("dma-mapping: force bouncing if the kmalloc() size is not cache-line-aligned")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "Isaac J. Manjarres" <isaacmanjarres@google.com>
Cc: Robin Murohy <robin.murphy@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/debug.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/dma/debug.c~dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc-v2
+++ a/kernel/dma/debug.c
@@ -597,7 +597,7 @@ static void add_dma_entry(struct dma_deb
 		global_disable = true;
 	} else if (rc == -EEXIST && !(attrs & DMA_ATTR_SKIP_CPU_SYNC) &&
 		   !(IS_ENABLED(CONFIG_DMA_BOUNCE_UNALIGNED_KMALLOC) &&
-		     is_swiotlb_allocated())) {
+		     is_swiotlb_active(entry->dev))) {
 		err_printk(entry->dev, entry,
 			"cacheline tracking EEXIST, overlapping mappings aren't supported\n");
 	}
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc.patch

