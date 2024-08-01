Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207C213C832
	for <mm-commits@vger.kernel.org>; Thu,  1 Aug 2024 19:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722542330; cv=none; b=IkLIMFYgrzsDkoE87T7JiRdU7P+csqyPlNp2ayLBHiMsswLmAjeePqleOT0/wwoYJTnG4BHHvWf7OGoTPuZJiUjK10P/bqv2+pSRCl8Vlr6SGyqS8clpKe/opSTuAYKVwJZW4FSkBI//azWC/Fy9Ud3/S7JUN1xBQQ32X9U5Uew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722542330; c=relaxed/simple;
	bh=bxzKDSIWhCk8CU2bkGCwejRzqJ8kti2zjW9CHPK3AzE=;
	h=Date:To:From:Subject:Message-Id; b=i6yMUsLv61qfjm/1DY1AmfEvMzzKzAhlF8VXweLBDVuAXWar2c4Dw3av/RC32p0qyanNmd5Jg5RbzGXFrHT+IlDIffzaXkY9qdGwEqSukIJXqJjzpirTpxqllrds9W7YpJMd29hzt6+KylPmgFYeKZIZc52SImAd9r15sVCRLUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sHu2oKTJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sHu2oKTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AADC32786;
	Thu,  1 Aug 2024 19:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722542329;
	bh=bxzKDSIWhCk8CU2bkGCwejRzqJ8kti2zjW9CHPK3AzE=;
	h=Date:To:From:Subject:From;
	b=sHu2oKTJd/PNeX9EfLVgMKkbLq8z4mHxps38S0SGo39+g5JQyQyeW4lczbhE5BVNj
	 tRdovA5ePlg4HjrXo9XTy/Hw/4zPnG8FsEFdvPzCwso/iZNXIdR6Hp9mG1FOAxykzi
	 rkYRryLx0gChWoxgZhy2cWEAUSHhwmucuQ2Vov/A=
Date: Thu, 01 Aug 2024 12:58:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baohua@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-fix-incorrect-aligned-index-when-checking-conflicts.patch added to mm-hotfixes-unstable branch
Message-Id: <20240801195849.A3AADC32786@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix incorrect aligned index when checking conflicts
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-shmem-fix-incorrect-aligned-index-when-checking-conflicts.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-fix-incorrect-aligned-index-when-checking-conflicts.patch

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
Subject: mm: shmem: fix incorrect aligned index when checking conflicts
Date: Wed, 31 Jul 2024 13:46:20 +0800

In the shmem_suitable_orders() function, xa_find() is used to check for
conflicts in the pagecache to select suitable huge orders.  However, when
checking each huge order in every loop, the aligned index is calculated
from the previous iteration, which may cause suitable huge orders to be
missed.

We should use the original index each time in the loop to calculate a new
aligned index for checking conflicts to avoid this issue.

Link: https://lkml.kernel.org/r/07433b0f16a152bffb8cee34934a5c040e8e2ad6.1722404078.git.baolin.wang@linux.alibaba.com
Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-incorrect-aligned-index-when-checking-conflicts
+++ a/mm/shmem.c
@@ -1681,6 +1681,7 @@ static unsigned long shmem_suitable_orde
 					   unsigned long orders)
 {
 	struct vm_area_struct *vma = vmf->vma;
+	pgoff_t aligned_index;
 	unsigned long pages;
 	int order;
 
@@ -1692,9 +1693,9 @@ static unsigned long shmem_suitable_orde
 	order = highest_order(orders);
 	while (orders) {
 		pages = 1UL << order;
-		index = round_down(index, pages);
-		if (!xa_find(&mapping->i_pages, &index,
-			     index + pages - 1, XA_PRESENT))
+		aligned_index = round_down(index, pages);
+		if (!xa_find(&mapping->i_pages, &aligned_index,
+			     aligned_index + pages - 1, XA_PRESENT))
 			break;
 		order = next_order(&orders, order);
 	}
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch
mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix.patch
mm-shmem-fix-incorrect-aligned-index-when-checking-conflicts.patch
mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch

