Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46408F5B
	for <mm-commits@vger.kernel.org>; Thu,  8 Aug 2024 01:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723081330; cv=none; b=MegmsPpRkBoXb0bIhw72IMlO7kaF1Tb3l2sdzej9vUgUNlYmkxildN0Hn60k8fiUhfPJStdH7HkpbNnPvfGtAGFLbK06S5fyC8yyIUVO090cYy3bNz115v/x1azoibuxXPX2V8HyrsLQgBJjHtJJoPhq3uj3Qh8yguSOn4/TtDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723081330; c=relaxed/simple;
	bh=VhX2CsoRiDmkpP93+BrFnvFzUtMORRx2iq/49SVabkQ=;
	h=Date:To:From:Subject:Message-Id; b=ri36psxvynOGWjk3aitC5F51ye050gccFDD17kaSmMxEs5Nt69OMW/rcGWUqURbEKLWDKsB5fLCg6tXBHGvRSOtiMiuVVl9wdftdQuBPpFFDuJZjuDFku6nZTh1FM9OVQaXj1zGQ39ex8wY3czkWgcBNc4iJoX3rdWWH0tUJKMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nKh0+UmM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nKh0+UmM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E31C4AF0B;
	Thu,  8 Aug 2024 01:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723081330;
	bh=VhX2CsoRiDmkpP93+BrFnvFzUtMORRx2iq/49SVabkQ=;
	h=Date:To:From:Subject:From;
	b=nKh0+UmMLWcuVx8EEypWi+QQ6VLEQHyjchwkVxwUYTfOzmesDzbJHreDH1xozOKyV
	 YZV9RMkOW2/7m23WnvjV2ocfSe4EtIEauYrNL9Mab33YNR7QYcQvnUFnA3ZKqwp1QX
	 voAawhNbkvPGO3mbe9safOPESPGi092C5RAFzrtQ=
Date: Wed, 07 Aug 2024 18:42:09 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,willy@infradead.org,wangkefeng.wang@huawei.com,ryan.roberts@arm.com,ioworker0@gmail.com,hughd@google.com,gshan@redhat.com,david@redhat.com,baohua@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-shmem-fix-incorrect-aligned-index-when-checking-conflicts.patch removed from -mm tree
Message-Id: <20240808014210.22E31C4AF0B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: fix incorrect aligned index when checking conflicts
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-incorrect-aligned-index-when-checking-conflicts.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

