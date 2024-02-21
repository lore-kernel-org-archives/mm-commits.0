Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794E6A35
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 23:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708559364; cv=none; b=nsKjeLysKgiIQD2IJysXzR7UgIv3NHlr8wT3VrWlzLRM4kmLacjBYqJ6FAHDgrkkQougjc4vrEmjKFye/bgyDwVLeqJujvwCnuHMiJCHHrDdq0QK/skp81KjOLdzbAqEiM1Y1oNNJhhVf2ww2eDR6ixVBynS9PfsVl9JQmA+FoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708559364; c=relaxed/simple;
	bh=G184LIMHc1xZKQLQIV8HAj/IBq/5EIB8lc7pm736RtI=;
	h=Date:To:From:Subject:Message-Id; b=IsuCJR/R/2k+KRQfBeQ7PcBjmxet/4Ojawc2u55D1EkOCnJzgCE6Xpi5FlcfDYsXvwPNx3j+zVP2G5D6xJFVGls6Z9Vs1pWcRXuzl3K5E8/OHS9V2uFosqEg2IylIVdQv1mYRqC6vOShsASFpBbbfU5JY/xPWOkLebHjWUcQl6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ps9X+auB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ps9X+auB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C3FCC43399;
	Wed, 21 Feb 2024 23:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708559363;
	bh=G184LIMHc1xZKQLQIV8HAj/IBq/5EIB8lc7pm736RtI=;
	h=Date:To:From:Subject:From;
	b=ps9X+auBOsNJeLztWhQj196BR/QSrHtWVg3S8qKvgaiTzAjxOY6Be6k+l4Wzs8jL4
	 asvbSShEhDJVSue12vRkYiDqKKLCmX9QW4q2KN9P7nTkybrWW/d0aFSo6oLwV0gNn3
	 dRcgtfr95VznFKDIc4mZa4bBgI+My85xhuMzRWvo=
Date: Wed, 21 Feb 2024 15:49:22 -0800
To: mm-commits@vger.kernel.org,robin.murphy@arm.com,m.szyprowski@samsung.com,hch@lst.de,anshuman.khandual@arm.com,lukas.bulwahn@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-cma-drop-config_cma_debug-fix.patch removed from -mm tree
Message-Id: <20240221234923.1C3FCC43399@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: dma-contiguous: remove debug code to removed CONFIG_CMA_DEBUG
has been removed from the -mm tree.  Its filename was
     mm-cma-drop-config_cma_debug-fix.patch

This patch was dropped because it was folded into mm-cma-drop-config_cma_debug.patch

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: dma-contiguous: remove debug code to removed CONFIG_CMA_DEBUG
Date: Wed, 7 Feb 2024 15:38:25 +0100

Commit acc2f3e42d4a ("mm/cma: drop CONFIG_CMA_DEBUG") removes the config
CMA_DEBUG and the debug code in cma.c, but misses debug code in
kernel/dma/contiguous.c.

Remove this dead code from this removed config option.

Link: https://lkml.kernel.org/r/20240207143825.986-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/dma/contiguous.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/kernel/dma/contiguous.c~mm-cma-drop-config_cma_debug-fix
+++ a/kernel/dma/contiguous.c
@@ -37,12 +37,6 @@
 
 #define pr_fmt(fmt) "cma: " fmt
 
-#ifdef CONFIG_CMA_DEBUG
-#ifndef DEBUG
-#  define DEBUG
-#endif
-#endif
-
 #include <asm/page.h>
 
 #include <linux/memblock.h>
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

maple_tree-avoid-duplicate-variable-init-in-mast_spanning_rebalance.patch
mempolicy-clean-up-minor-dead-code-in-queue_pages_test_walk.patch
mm-cma-drop-config_cma_debug.patch

