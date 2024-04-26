Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AD380C0A;
	Fri, 26 Apr 2024 04:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104169; cv=none; b=Z77wrV1MxboNGDWGCQdwbQUp/0dtpiUGXvnCRCA9n01x6YC9OYb0cF9octAOz/VDU5r9cCcb84MPJiZbOILam05VaOH+zsj6vZdW6lwr01NkCHswY5Y9DAGCQfxqcbtH3LcBKvUE76IWCiDN21wDiL8PsqGKrMp1QMzVOt27240=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104169; c=relaxed/simple;
	bh=w1fKV/Cp5CBgq+7gj7ncUGT4zodpDnY8YahfYwezyxs=;
	h=Date:To:From:Subject:Message-Id; b=QJYJRBgXZUTEjE37bl1J7jztYu0JOCZkd+AD42TnQiaxBD09LwKXqjxxhJBA6MRri2UY+rEuBXJ4eVK8TKsrs5CypUfFYbs+2tV1gLfyByXi7koCs4OELUiXKIN3AHFIT2jikYAk7DSoZEw1sTmMPZ2etFTHxLUORJoFY04/KAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qMpmaSVt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qMpmaSVt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680F7C2BD11;
	Fri, 26 Apr 2024 04:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104169;
	bh=w1fKV/Cp5CBgq+7gj7ncUGT4zodpDnY8YahfYwezyxs=;
	h=Date:To:From:Subject:From;
	b=qMpmaSVtXUj1OtDa12/hYdRWWKy+yt9//OSE3LH0CJ6/dkur0vqFD0I/mExUBpNU3
	 X7Z9N1XE6nryBcI0OmDUmHWrRQkKQSC/zLBbSmXYq56WBfgakTL1aNVIGgWjaTWlx+
	 yUPlclRYYiYEea1wVN8rsvm5+Q5oORETJ2IQPIB8=
Date: Thu, 25 Apr 2024 21:02:48 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,roman.gushchin@linux.dev,muchun.song@linux.dev,m.szyprowski@samsung.com,david@redhat.com,fvdl@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-cma-drop-incorrect-alignment-check-in-cma_init_reserved_mem.patch removed from -mm tree
Message-Id: <20240426040249.680F7C2BD11@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/cma: drop incorrect alignment check in cma_init_reserved_mem
has been removed from the -mm tree.  Its filename was
     mm-cma-drop-incorrect-alignment-check-in-cma_init_reserved_mem.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Frank van der Linden <fvdl@google.com>
Subject: mm/cma: drop incorrect alignment check in cma_init_reserved_mem
Date: Thu, 4 Apr 2024 16:25:14 +0000

cma_init_reserved_mem uses IS_ALIGNED to check if the size represented by
one bit in the cma allocation bitmask is aligned with
CMA_MIN_ALIGNMENT_BYTES (pageblock size).

However, this is too strict, as this will fail if order_per_bit >
pageblock_order, which is a valid configuration.

We could check IS_ALIGNED both ways, but since both numbers are powers of
two, no check is needed at all.

Link: https://lkml.kernel.org/r/20240404162515.527802-1-fvdl@google.com
Fixes: de9e14eebf33 ("drivers: dma-contiguous: add initialization from device tree")
Signed-off-by: Frank van der Linden <fvdl@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/cma.c~mm-cma-drop-incorrect-alignment-check-in-cma_init_reserved_mem
+++ a/mm/cma.c
@@ -182,10 +182,6 @@ int __init cma_init_reserved_mem(phys_ad
 	if (!size || !memblock_is_region_reserved(base, size))
 		return -EINVAL;
 
-	/* alignment should be aligned with order_per_bit */
-	if (!IS_ALIGNED(CMA_MIN_ALIGNMENT_PAGES, 1 << order_per_bit))
-		return -EINVAL;
-
 	/* ensure minimal alignment required by mm core */
 	if (!IS_ALIGNED(base | size, CMA_MIN_ALIGNMENT_BYTES))
 		return -EINVAL;
_

Patches currently in -mm which might be from fvdl@google.com are


