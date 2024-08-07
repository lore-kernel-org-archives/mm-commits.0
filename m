Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7B85D8F0
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 20:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723063560; cv=none; b=Po9AyPWPH9mFTeqwyppU0eH8B8XGvnbqho0ITvnxk/DHj0lTjUQAVgBMwAkC9ZKcpSfDSjZD89OuwIWbWjHkSXtEJzBqIU3DlQ396RGFIXVoSlEdrK6EowsHvYSyNLRZYITMbNJJVo5rj3ubl3GAZEl9f+2lbDVj5to4a1ZuPKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723063560; c=relaxed/simple;
	bh=JwZhWkFfLfOJH09aK0Lo3t1G5FS9Y5znYhhFA8Giyxs=;
	h=Date:To:From:Subject:Message-Id; b=eiaeVHC8nH4H06oEvTc9dyYZz8wDeNJRfLUeCfZn+Nw8QPuhslwwa2AznqK8bQbru1jr7TdHqm6GEbcpPu95pG3d8k7Mf6kUj1gaw3l+BlkyrAbyXFPz+xb/blmZ/X77bbNCUtSt3i9zTt9L6O1K2R0Npai/6in8Lq2FKUBxASQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=V4TQcU2U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="V4TQcU2U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84F9C32781;
	Wed,  7 Aug 2024 20:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723063559;
	bh=JwZhWkFfLfOJH09aK0Lo3t1G5FS9Y5znYhhFA8Giyxs=;
	h=Date:To:From:Subject:From;
	b=V4TQcU2UoIFGHsHW7eLI0Z1X7/IhGSAx0/sZTj8HYrVupNmAXzEjmGPLzSWS5n9Mb
	 MyRFtcxgo5NEQCV237a+lDHb7Ogv+ux1kdg/34n9Oc10Wo8FhQGyrnN1p1WedjszC/
	 aQk5zq/XgKB8O3bn1CJOwXoI7yJQOotLke7qxzrM=
Date: Wed, 07 Aug 2024 13:45:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmscan-add-validation-before-spliting-shmem-large-folio.patch added to mm-unstable branch
Message-Id: <20240807204559.D84F9C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: vmscan: add validation before spliting shmem large folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmscan-add-validation-before-spliting-shmem-large-folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmscan-add-validation-before-spliting-shmem-large-folio.patch

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
Subject: mm: vmscan: add validation before spliting shmem large folio
Date: Wed, 7 Aug 2024 15:31:06 +0800

Patch series "support large folio swap-out and swap-in for shmem", v4.

Shmem will support large folio allocation [1] [2] to get a better
performance, however, the memory reclaim still splits the precious large
folios when trying to swap-out shmem, which may lead to the memory
fragmentation issue and can not take advantage of the large folio for
shmeme.

Moreover, the swap code already supports for swapping out large folio
without split, and large folio swap-in[3] series is queued into
mm-unstable branch.  Hence this patch set also supports the large folio
swap-out and swap-in for shmem.

Please help to review. Thanks.

Functional testing
==================
Machine environment: 32 Arm cores, 120G memory and 50G swap device.

1. Run xfstests suite to test tmpfs filesystem, and I did not catch any
   regressions with this patch set.
FSTYP=tmpfs
export TEST_DIR=/mnt/tempfs_mnt
export TEST_DEV=/mnt/tempfs_mnt
export SCRATCH_MNT=/mnt/scratchdir
export SCRATCH_DEV=/mnt/scratchdir

2. Run all mm selftests in tools/testing/selftests/mm/, and no
   regressions found.

3. I also wrote several shmem swap test cases, including shmem
   splitting, shmem swapout, shmem swapin, swapoff during shmem swapout,
   shmem reclaim, shmem swapin replacement, etc.  I tested these cases
   under 4K and 64K shmem folio sizes with a swap device, and shmem swap
   functionality works well on my machine.

[1] https://lore.kernel.org/all/cover.1717495894.git.baolin.wang@linux.alibaba.com/
[2] https://lore.kernel.org/all/20240515055719.32577-1-da.gomez@samsung.com/
[3] https://lore.kernel.org/all/20240508224040.190469-6-21cnbao@gmail.com/T/
[4] https://lore.kernel.org/all/8db63194-77fd-e0b8-8601-2bbf04889a5b@google.com/


This patch (of 10):

Page reclaim will not scan anon LRU if no swap space, however MADV_PAGEOUT
can still split shmem large folios even without a swap device.  Thus add
swap available space validation before spliting shmem large folio to avoid
redundant split.

Link: https://lkml.kernel.org/r/cover.1723012159.git.baolin.wang@linux.alibaba.com
Link: https://lkml.kernel.org/r/8a8c6dc9df0bc9f6f7f937bea446062be19611b3.1723012159.git.baolin.wang@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>
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
Cc: Barry Song <baohua@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/mm/vmscan.c~mm-vmscan-add-validation-before-spliting-shmem-large-folio
+++ a/mm/vmscan.c
@@ -1260,6 +1260,14 @@ retry:
 			}
 		} else if (folio_test_swapbacked(folio) &&
 			   folio_test_large(folio)) {
+
+			/*
+			 * Do not split shmem folio if no swap memory
+			 * available.
+			 */
+			if (!total_swap_pages)
+				goto activate_locked;
+
 			/* Split shmem folio */
 			if (split_folio_to_list(folio, folio_list))
 				goto keep_locked;
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

