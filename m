Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA43D14AA9
	for <mm-commits@vger.kernel.org>; Thu,  1 Aug 2024 19:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722541915; cv=none; b=QqYxb+uMrGqTl28wgc1M1N9LLw2RYyTWylWQjVaNqJ+lgng2OF1jIn54tFgi96/LGtw1U6P/+TjMmLqthdpm24w/uUuGnoXaz8hSoDE4J8Swyrb6iowtBpTSTMC2zvjU1D80LenS5TCHBERekVd45axdEqRtmN818OnMO9t889k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722541915; c=relaxed/simple;
	bh=I1eHQ0yXZe1gH5RWLRhIcUQCOH+Mhh8wAYZGAjxPrNE=;
	h=Date:To:From:Subject:Message-Id; b=oVJCcH+U/RLvDJjgEcVnM6FN5yYdKDXJRCx/yBxqwULFRNlp32OWBZipukuYpFiOEDyf51AK1cUjI65DF+KIUIN8kQjLhMDgWGPylCYBJ9jUbipbF95CPA062YQmWaMYX5Mx/LUf3G3oPXS8+oEnkFalXRQkts+w/mQYY0KmrS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CqNm4VzK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CqNm4VzK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D51C32786;
	Thu,  1 Aug 2024 19:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722541915;
	bh=I1eHQ0yXZe1gH5RWLRhIcUQCOH+Mhh8wAYZGAjxPrNE=;
	h=Date:To:From:Subject:From;
	b=CqNm4VzKmF6FOn34oMuJPB3DV+OgRzu5OIZru4vL/uJGhHWKPq+HiWB7SFqdQvVqu
	 V4gDPYyfi1esNLg0YLkFyz+6c6dnwTP9pOENsis7mOyk23JlAD+f6EdXiAL9A9gEJH
	 QlhP0SHWZ1TUySlFY9VtKSi1fks/OcyyoSkImde0=
Date: Thu, 01 Aug 2024 12:51:54 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baohua@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch added to mm-hotfixes-unstable branch
Message-Id: <20240801195155.28D51C32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: avoid allocating huge pages larger than MAX_PAGECACHE_ORDER for shmem
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch

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
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm: shmem: avoid allocating huge pages larger than MAX_PAGECACHE_ORDER for shmem
Date: Wed, 31 Jul 2024 13:46:19 +0800

Similar to commit d659b715e94ac ("mm/huge_memory: avoid PMD-size page
cache if needed"), ARM64 can support 512MB PMD-sized THP when the base
page size is 64KB, which is larger than the maximum supported page cache
size MAX_PAGECACHE_ORDER.

This is not expected.  To fix this issue, use THP_ORDERS_ALL_FILE_DEFAULT
for shmem to filter allowable huge orders.

Link: https://lkml.kernel.org/r/117121665254442c3c7f585248296495e5e2b45c.1722404078.git.baolin.wang@linux.alibaba.com
Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem
+++ a/mm/shmem.c
@@ -1630,10 +1630,10 @@ unsigned long shmem_allowable_huge_order
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	unsigned long vm_flags = vma->vm_flags;
 	/*
-	 * Check all the (large) orders below HPAGE_PMD_ORDER + 1 that
+	 * Check all the (large) orders below MAX_PAGECACHE_ORDER + 1 that
 	 * are enabled for this vma.
 	 */
-	unsigned long orders = BIT(PMD_ORDER + 1) - 1;
+	unsigned long orders = THP_ORDERS_ALL_FILE_DEFAULT;
 	loff_t i_size;
 	int order;
 
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch
mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix.patch
mm-shmem-fix-incorrect-aligned-index-when-checking-conflicts.patch
mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch

