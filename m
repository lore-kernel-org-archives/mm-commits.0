Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A615D8F0
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 20:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723063563; cv=none; b=kF4eg8X7U0nfSjq5c+LlTDdMyVEBbH4mzJkNjnhdsstwbETi+sowe2ozdFt/lKvXAXl1bHitN3Hal5pBqfD2sBuHoqSs6r49wdxNYbvgtbsO5kdBVZMy035xFZmAvjlDMcUeil5t9yAae7etIdM57GsvdRgQZwlGqxmBBk22B+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723063563; c=relaxed/simple;
	bh=CdaGUW1QwByQZxKx2GbtDChwvMumuulxQg1IvBRCYhA=;
	h=Date:To:From:Subject:Message-Id; b=rT6g59qkcCHC3/zY2L0+4zN8Ou3N5zmySRt5LC3pdT+DoZsAKWI42VZQxn0aMZRJwaHdlgX6WZx1lOEEPvuhgvUKPH7UMDzZhxzh8GD66aZ1yzoi+z0Z+h61ASJRnTTnep966BkfpkKhL1NC1b2pHu6WtVPHlTmwHMm+W9m1YYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TY2J8Zz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TY2J8Zz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBC0C32781;
	Wed,  7 Aug 2024 20:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723063563;
	bh=CdaGUW1QwByQZxKx2GbtDChwvMumuulxQg1IvBRCYhA=;
	h=Date:To:From:Subject:From;
	b=TY2J8Zz8zyi2sHGT380TZkThLB3903LIIwSys153Bf4ri734xAY4HvM54cy282M5d
	 jAoy78aSeUABTmRmWzMblPIbXeclQIsjLl2GWmvmQ1osU6UK3o131XRgkzFAudtKFv
	 /xGUx2D6hyR09bodPTCdmFn+oDzpSSOPyvsWgkzo=
Date: Wed, 07 Aug 2024 13:46:02 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch added to mm-unstable branch
Message-Id: <20240807204602.ECBC0C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: extend shmem_partial_swap_usage() to support large folio swap
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch

This patch will later appear in the mm-unstable branch at
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
Subject: mm: shmem: extend shmem_partial_swap_usage() to support large folio swap
Date: Wed, 7 Aug 2024 15:31:08 +0800

To support shmem large folio swapout in the following patches, using
xa_get_order() to get the order of the swap entry to calculate the swap
usage of shmem.

Link: https://lkml.kernel.org/r/2e0b4bc7877784348409900f81cb4b8bdafd7b57.1723012159.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap
+++ a/mm/shmem.c
@@ -890,7 +890,7 @@ unsigned long shmem_partial_swap_usage(s
 		if (xas_retry(&xas, page))
 			continue;
 		if (xa_is_value(page))
-			swapped++;
+			swapped += 1 << xa_get_order(xas.xa, xas.xa_index);
 		if (xas.xa_index == max)
 			break;
 		if (need_resched()) {
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch
mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix.patch
mm-shmem-fix-incorrect-aligned-index-when-checking-conflicts.patch
mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch
mm-vmscan-add-validation-before-spliting-shmem-large-folio.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-support-large-folio-swap-out.patch

