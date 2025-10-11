Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FED42050
	for <mm-commits@vger.kernel.org>; Sat, 11 Oct 2025 18:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760207191; cv=none; b=d4sfvAgmkQE6WEordydqqEk7OM2tWOVkiDTTnDJZPzn7OFNLIERyhhCs/HqqZfM3uMoH+5/c0rxKd/2/cP450q0RTSoQJVdXW9uwP88Np6KVIkSxlMg5oXDhzF9fZbswEZ0nf7Wb/9IG1DNpHQy88YNnlk9vdf2akHNJnUk16Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760207191; c=relaxed/simple;
	bh=xaKhFKWj4/97lNWfxXI0OAqEPwOrnIlfeZv2WsL6XCE=;
	h=Date:To:From:Subject:Message-Id; b=C3cLImroaEHqYKSqIZ5zW6ueT7JdilnHShz8jB44aXZhZsSS+M7fQrVrDx7VVGqijPlN5vww4cQTwxpi/y91vM9MKIYM5XuxT3Z9Y9k4DBw1RajGhASZThHjr7vu19x7gPJVA0zyyLM8kRc9qH7zDBtZPMCs0JC+kRbYNXUw3uM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L5UQ8cDa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L5UQ8cDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FDCC4CEF4;
	Sat, 11 Oct 2025 18:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760207190;
	bh=xaKhFKWj4/97lNWfxXI0OAqEPwOrnIlfeZv2WsL6XCE=;
	h=Date:To:From:Subject:From;
	b=L5UQ8cDasIp2HpiWm01j3hc4gUsldZORgPwSmpjaSaiZXxD736w22R6rut7rMQVbN
	 hzBarvNu1mMZDIJZAXeWNH7/unme7o/VK6pZpMkbQR1Q355YT693FU0bppIyRNpnOW
	 OE/Mzq7ZBz4nFH/jgxxsCJewrV3lZUTssuDXzs+Y=
Date: Sat, 11 Oct 2025 11:26:30 -0700
To: mm-commits@vger.kernel.org,robin.murphy@arm.com,isaacmanjarres@google.com,hch@lst.de,catalin.marinas@arm.com,m.szyprowski@samsung.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20251011182630.B8FDCC4CEF4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc-v2
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc-v2.patch

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
dma-debug-dont-report-false-positives-with-dma_bounce_unaligned_kmalloc-v2.patch

