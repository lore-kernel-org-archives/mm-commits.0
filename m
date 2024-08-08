Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E2136FD3
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 01:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723080178; cv=none; b=RG40mEseKGVcrKIVXCp0R1+AA3xlLhVvTBiWEflxegiXER2lxMACZT36KSdIDWrRr99bdkksNnCXPx5P49sWUm1xWQT+KfOC5BTJsSUAo65+6cowqDtyoy/RZS9iXSXQTet1aVOz/NIi8dNws2rcBmz7HWMoua67KLliJkZmLhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723080178; c=relaxed/simple;
	bh=/XatN3wjZw3UKaQuURdHxDYwOvWq2ItUDpB0YuKjYoM=;
	h=Date:To:From:Subject:Message-Id; b=Aszk8UUYbBSRYB5aidyEjjqAlrPi00AJUEUY989Q5bo75sBWqasBZHAR5pDbs7XULYM/o1NYeK/NnB+/Kq21vWzweru+B19mOKR0NzAy1upBj19mMCBz4+uB7B52xXQEa/kmDeJ+9VMqZSohs0ZD6oVSefzopOc1lb6dZ6IZmug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eT3Pw5DD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eT3Pw5DD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC36C32781;
	Thu,  8 Aug 2024 01:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723080178;
	bh=/XatN3wjZw3UKaQuURdHxDYwOvWq2ItUDpB0YuKjYoM=;
	h=Date:To:From:Subject:From;
	b=eT3Pw5DD3N14tRSLluGesQHiYxPI21ZKYT5sd29XM4NmNjDlVyaemoSY6+p+8pOSU
	 6D+5evXUADVJbKPxTlKtse7+6fRmx3S0+bdLmc81DGKTAWQ5tM53w0LgAfhoNiPL/P
	 WRpULYAcM80V5yQ14s6PqyL7vdvvnHNsOiFrX5j4=
Date: Wed, 07 Aug 2024 18:22:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,21cnbao@gmail.com,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix-2.patch removed from -mm tree
Message-Id: <20240808012257.EFC36C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix-2
has been removed from the -mm tree.  Its filename was
     mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix-2.patch

This patch was dropped because it was folded into mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch

------------------------------------------------------
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix-2
Date: Wed, 31 Jul 2024 17:59:23 +0800

remove local `orders'

Link: https://lkml.kernel.org/r/87769ae8-b6c6-4454-925d-1864364af9c8@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem-fix-2
+++ a/mm/shmem.c
@@ -1629,7 +1629,6 @@ unsigned long shmem_allowable_huge_order
 	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
 	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
 	unsigned long vm_flags = vma->vm_flags;
-	unsigned long orders = THP_ORDERS_ALL_FILE_DEFAULT;
 	loff_t i_size;
 	int order;
 
@@ -1674,7 +1673,7 @@ unsigned long shmem_allowable_huge_order
 	if (global_huge)
 		mask |= READ_ONCE(huge_shmem_orders_inherit);
 
-	return orders & mask;
+	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
 }
 
 static unsigned long shmem_suitable_orders(struct inode *inode, struct vm_fault *vmf,
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-shmem-avoid-allocating-huge-pages-larger-than-max_pagecache_order-for-shmem.patch
mm-hugetlb-remove-left-over-comment-about-follow_huge_foo.patch

