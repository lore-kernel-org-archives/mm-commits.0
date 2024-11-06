Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D1E18A6D5
	for <mm-commits@vger.kernel.org>; Wed,  6 Nov 2024 01:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730855623; cv=none; b=EyiNolZPFrg4MuUG5nMognYKd+Z/3uIiWMzU+If5bWPoD7XgHmNVOVQNDzq+zK4dBekdSkT8i+LPV225r25u3l9hkgsNqEe2EqxkCzx1OASkTPkwhyP+EruE9fdXI7G3QkDCgSOD7xsJq0Tnu7YA73cLvexldYhAR9BAMn+PrQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730855623; c=relaxed/simple;
	bh=S3cz/MZUIP1HLC8NrFubnFyPPhrD98L2xl5juABtRCM=;
	h=Date:To:From:Subject:Message-Id; b=oNqyE9OJa2L9eUCxQAdvojnywL+5x142/heZywq9hzA5wr+hbW7g1cfpybm/e5ip+XRHijHwn7MQxcPBGsoFX7FRX9P85UD2kq37DX+yWU9UWlMSUN7wEvC+50/F7CkfAO83X3dz8zC4SmFArLAqgJ61vMU/MB0cZkInOoFzrzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FWIjVx2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FWIjVx2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66278C4CECF;
	Wed,  6 Nov 2024 01:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730855623;
	bh=S3cz/MZUIP1HLC8NrFubnFyPPhrD98L2xl5juABtRCM=;
	h=Date:To:From:Subject:From;
	b=FWIjVx2AkKx/gfa2dZIVBt8DS5ehLaAhRNVEzT3rq0CfihItSJ4TeiSI9CxWqyU9T
	 CQhty6ZbuKwGxO6+iFnp4MrC0jvvYVBE0yIXRm+kvoicnpmHw11kZFkA8iuj5GwSa+
	 IRc6yuZYy9WeHDt/joLDO3PjyYYW1MrdsY3ddEuU=
Date: Tue, 05 Nov 2024 17:13:42 -0800
To: mm-commits@vger.kernel.org,robin.murphy@arm.com,petr@tesarici.cz,mhklinux@outlook.com,catalin.marinas@arm.com,sui.jingfeng@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] scatterlist-fix-a-typo.patch removed from -mm tree
Message-Id: <20241106011343.66278C4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: scatterlist: fix a typo
has been removed from the -mm tree.  Its filename was
     scatterlist-fix-a-typo.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sui Jingfeng <sui.jingfeng@linux.dev>
Subject: scatterlist: fix a typo
Date: Sat, 12 Oct 2024 18:08:17 +0800

Replace the 'One' with 'On'.

Link: https://lkml.kernel.org/r/20241012100817.323007-1-sui.jingfeng@linux.dev
Fixes: af2880ec4402 ("scatterlist: add dedicated config for DMA flags")
Signed-off-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Reviewed-by: Petr Tesarik <petr@tesarici.cz>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michael Kelley <mhklinux@outlook.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/scatterlist.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/scatterlist.h~scatterlist-fix-a-typo
+++ a/include/linux/scatterlist.h
@@ -273,7 +273,7 @@ static inline void sg_unmark_end(struct
 }
 
 /*
- * One 64-bit architectures there is a 4-byte padding in struct scatterlist
+ * On 64-bit architectures there is a 4-byte padding in struct scatterlist
  * (assuming also CONFIG_NEED_SG_DMA_LENGTH is set). Use this padding for DMA
  * flags bits to indicate when a specific dma address is a bus address or the
  * buffer may have been bounced via SWIOTLB.
_

Patches currently in -mm which might be from sui.jingfeng@linux.dev are


