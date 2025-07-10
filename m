Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909DF469D
	for <mm-commits@vger.kernel.org>; Thu, 10 Jul 2025 04:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752122332; cv=none; b=pcfrtg+Yk3YN8QfIswrTFIsLGW5KnrG02ouP0z+3T+qTMEMXvRZD9Ad5/Q0AeDi2hJ5pXLjplmFAYtxOUiq6O9VL31u93zmmM5HAV/W/x8t/HxbNQt81wLjHQyHi+jCjxC3fDdBHWlDJ39Lhm3YS+DyStQi5eyOy8NbubuayeVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752122332; c=relaxed/simple;
	bh=uY3IFurrBEsEyCUTxgHwqN1ZsPF+iDHHomti1eDO3HI=;
	h=Date:To:From:Subject:Message-Id; b=JUE4D+Ls6oIeNzd69dSyhEGJV8w8qWzr/oppzcpq6+vVlIY6yejq7SztGZ3Io27t3DeuK4kvfWl4XRgDbs9Qfkcc1lcVZ3MLT2aVJT+1300VXEAJ8VuH2LUSXzDTMGbORhxar8qkWYyhtVLmi0NkgpGAR7y/SVbl6wxo/i4GzSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SAnd3NF9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SAnd3NF9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD84C4CEE3;
	Thu, 10 Jul 2025 04:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752122332;
	bh=uY3IFurrBEsEyCUTxgHwqN1ZsPF+iDHHomti1eDO3HI=;
	h=Date:To:From:Subject:From;
	b=SAnd3NF9Ur8eEpuHf+1mD1gJAfmptVvqFwrdwHR1MP/Hw+6Y53KHQn6383se3e9gh
	 PD9V5K9tf9qz7pZ2yh9/3xaKq15KeaXqos/KTIoIp9d0xKCfim+H5FPohKPmi5skfB
	 5g4C0sBD0t8LNcf+F8MiBsKXqvNiszaE1mDqFssQ=
Date: Wed, 09 Jul 2025 21:38:51 -0700
To: mm-commits@vger.kernel.org,lkp@intel.com,julia.lawall@inria.fr,ryan.roberts@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2.patch removed from -mm tree
Message-Id: <20250710043852.0AD84C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2
has been removed from the -mm tree.  Its filename was
     mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2.patch

This patch was dropped because it was folded into mm-filemap-allow-arch-to-request-folio-size-for-exec-memory.patch

------------------------------------------------------
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2
Date: Mon, 7 Jul 2025 10:08:09 +0100

use the vma_pages() helper instead of open-coding

Link: https://lkml.kernel.org/r/0e0f674b-3b7e-494f-ae7a-fc9dbb98dad4@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Julia Lawall <julia.lawall@inria.fr>
Closes: https://lore.kernel.org/r/202507071459.lLPSj5Bd-lkp@intel.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-filemap-allow-arch-to-request-folio-size-for-exec-memory-fix-2
+++ a/mm/filemap.c
@@ -3279,7 +3279,7 @@ static struct file *do_sync_mmap_readahe
 		 */
 		struct vm_area_struct *vma = vmf->vma;
 		unsigned long start = vma->vm_pgoff;
-		unsigned long end = start + ((vma->vm_end - vma->vm_start) >> PAGE_SHIFT);
+		unsigned long end = start + vma_pages(vma);
 		unsigned long ra_end;
 
 		ra->order = exec_folio_order();
_

Patches currently in -mm which might be from ryan.roberts@arm.com are

mm-readahead-honour-new_order-in-page_cache_ra_order.patch
mm-readahead-terminate-async-readahead-on-natural-boundary.patch
mm-readahead-make-space-in-struct-file_ra_state.patch
mm-readahead-store-folio-order-in-struct-file_ra_state.patch
mm-filemap-allow-arch-to-request-folio-size-for-exec-memory.patch
mm-remove-arch_flush_tlb_batched_pending-arch-helper.patch

