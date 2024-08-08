Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF528BF0
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 01:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723080177; cv=none; b=jvleYGFZWXpOy4zExr2M8DASqPa1As/heVzAMitM1PtXq6Mhdz33AeAXJXhKLpqiVQZUs+fTLGWnBAOrM65ybzdTLB/NFHM68z1mYueOeidMp6xRp9Wo3JQ6jhuHI+YKzi3Ai37X9ARXzP0LBM8xPtg3Ey4QRkDJlNqXiinfq2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723080177; c=relaxed/simple;
	bh=KjEeLWIUshJODszrVFdsfyTaZXpm5b8EfxRjdiG1Ewc=;
	h=Date:To:From:Subject:Message-Id; b=gZFqCpQPZqOF74m5NingLrl5BtV/UXecB1bJqMKHu82cLqY/3GQgZBh3EORA25wtNsgitYnwY8xIOMVBlcVAyFc97ZFdBUd29wi2sIUHPl61P5lggXD6y9KpspevK8vK7aFphamiQ1jVJUHe6wtvXhv3oTRY1CJJINAbI8pRdps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=x567vyPw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="x567vyPw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F43C32781;
	Thu,  8 Aug 2024 01:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723080176;
	bh=KjEeLWIUshJODszrVFdsfyTaZXpm5b8EfxRjdiG1Ewc=;
	h=Date:To:From:Subject:From;
	b=x567vyPwcfUOizSvo7VZMJah+zbBLXJZaOBHhmyngRD33os38uFiSphudX/tJOg2a
	 mgk4d64UCmKw/1ac4SA2YdoFVKszDz4c12p4ICNFJx27BhNuAsZ2ZANbCzn3+Uq4rz
	 bfbTzM18TB0l51dbzO/PvI7xlA4qez0AQ50CEzCU=
Date: Wed, 07 Aug 2024 18:22:56 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baohua@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix.patch removed from -mm tree
Message-Id: <20240808012256.B6F43C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix.patch

This patch was dropped because it was folded into mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix
Date: Wed, 31 Jul 2024 16:56:37 +0800

remove comment, per Barry

Link: https://lkml.kernel.org/r/c55d7ef7-78aa-4ed6-b897-c3e03a3f3ab7@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <baohua@kernel.org>
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

 mm/shmem.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/mm/shmem.c~mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix
+++ a/mm/shmem.c
@@ -1629,10 +1629,6 @@ unsigned long shmem_allowable_huge_order
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	unsigned long vm_flags = vma->vm_flags;
-	/*
-	 * Check all the (large) orders below MAX_PAGECACHE_ORDER + 1 that
-	 * are enabled for this vma.
-	 */
 	unsigned long orders = THP_ORDERS_ALL_FILE_DEFAULT;
 	loff_t i_size;
 	int order;
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch
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

