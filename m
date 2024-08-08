Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F7AC121
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 01:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723081330; cv=none; b=CY95nGths6vjmXQP5i04e2JGs1sYrT9o1B9DyP6Qx2IwQ/p+WAu7Fd3BNknsFlRbIFr1abW76+F/N10dGq7432Z2Cn/eQB4X3aMmJatDWEeqQXHIFF7iD1RcsP+AG66D00Tw5zSPotgoFuFQB3M6pXhwN2w8sqGQBSPQzCKaXxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723081330; c=relaxed/simple;
	bh=wH1/iOk/H9BK/Zj0g5GLcOjnE/icXUQV/JBEh4fQc94=;
	h=Date:To:From:Subject:Message-Id; b=GOaBBa9D/R2uTWpD92eL3jPBS1otOQkO7vPi4Gd82G25LYwfinm4H9qJ+9Hse/khLY3GptPFDnbCR5d/Ong/d+z+4quVKvYX2YlLoXOGWEt7fRyhJBLLO5vss1FP38vONEpwdSj9Ij0SDJMmUV2BjEfjKDxQ6JWXoEZsbiXRprw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Enb2rcMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Enb2rcMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF86EC32781;
	Thu,  8 Aug 2024 01:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723081328;
	bh=wH1/iOk/H9BK/Zj0g5GLcOjnE/icXUQV/JBEh4fQc94=;
	h=Date:To:From:Subject:From;
	b=Enb2rcMSVoElPzAZy0Npjr6H6KnlZWbla8AEGIjkcOx0c0o8kHj7ti+4BTED1hIOf
	 TvCkbBiaUx1oRBD6d0FJsR/jlp7nL3CK5k1F55WwPZzl/SB6uNq/dhbR356dzHIGyn
	 0NsOL0UJylJ2BspMCp0X1dp3c76q4fwYKFS2+uLM=
Date: Wed, 07 Aug 2024 18:42:08 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baohua@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch removed from -mm tree
Message-Id: <20240808014208.AF86EC32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: avoid allocating huge pages larger than MAX_PAGECACHE_ORDER for shmem
has been removed from the -mm tree.  Its filename was
     mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

[baolin.wang@linux.alibaba.com: remove comment, per Barry]
  Link: https://lkml.kernel.org/r/c55d7ef7-78aa-4ed6-b897-c3e03a3f3ab7@linux.alibaba.com
[wangkefeng.wang@huawei.com: remove local `orders']
  Link: https://lkml.kernel.org/r/87769ae8-b6c6-4454-925d-1864364af9c8@huawei.com
Link: https://lkml.kernel.org/r/117121665254442c3c7f585248296495e5e2b45c.1722404078.git.baolin.wang@linux.alibaba.com
Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/mm/shmem.c~mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem
+++ a/mm/shmem.c
@@ -1629,11 +1629,6 @@ unsigned long shmem_allowable_huge_order
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	unsigned long vm_flags = vma->vm_flags;
-	/*
-	 * Check all the (large) orders below HPAGE_PMD_ORDER + 1 that
-	 * are enabled for this vma.
-	 */
-	unsigned long orders = BIT(PMD_ORDER + 1) - 1;
 	loff_t i_size;
 	int order;
 
@@ -1678,7 +1673,7 @@ unsigned long shmem_allowable_huge_order
 	if (global_huge)
 		mask |= READ_ONCE(huge_shmem_orders_inherit);
 
-	return orders & mask;
+	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
 }
 
 static unsigned long shmem_suitable_orders(struct inode *inode, struct vm_fault *vmf,
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

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

