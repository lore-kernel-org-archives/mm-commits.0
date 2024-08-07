Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272F55D8F0
	for <mm-commits@vger.kernel.org>; Wed,  7 Aug 2024 20:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723063566; cv=none; b=mTu/3BgOWaWPJJgyfdMl5MTfSwTh8EksRiC7NVU7MmwkcPACJs7mqUoK3CoTMXpOQOD206bQSMywQUyQjkQ6+khvIGHc2MoAwIWkPQbypTfXpHebwInt9vNuwvdQY98s9/odp7hm1OTykhVFDuGVyJe9mGCjO7fPBVyrMbqoJjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723063566; c=relaxed/simple;
	bh=BEpVY6+CzLJftTjBZanZ4NZSCVPOdcyRYVHZxF072b8=;
	h=Date:To:From:Subject:Message-Id; b=u5b7M3PkgwMqKfLKLmZzx+ihAURPRuQ8CQigwo0zfyl8nAoE1vl+u5CbNjXdmVq2sALKffU7nZvgRY1BF/rxK0zo++XbnzQj+lEZDri9NDSFOo7g/6xMFzm6yqr4jY1ufRyvY8NGjAXR+KJDW/QqDyMZUIopDtwOuddrQoi7Ygk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EF7376ew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EF7376ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EF8C32781;
	Wed,  7 Aug 2024 20:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1723063566;
	bh=BEpVY6+CzLJftTjBZanZ4NZSCVPOdcyRYVHZxF072b8=;
	h=Date:To:From:Subject:From;
	b=EF7376ewRw4aCwHbFkUlwn59mdACUgdPGtvatpFhH3o1xxghc08V6uRunT0wYqjRQ
	 KNf8zBdCrTdRrZidKuNyl1+xaMrWwJ6+FcWHjkTsmrvJl9KulBOTPDLLpmb3T4CKen
	 KhUlKVMazJIL+YRj63dhB+OtT7fiaaCut7JksIDs=
Date: Wed, 07 Aug 2024 13:46:05 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,21cnbao@gmail.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch added to mm-unstable branch
Message-Id: <20240807204605.D9EF8C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: filemap: use xa_get_order() to get the swap entry order
has been added to the -mm mm-unstable branch.  Its filename is
     mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch

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
Subject: mm: filemap: use xa_get_order() to get the swap entry order
Date: Wed, 7 Aug 2024 15:31:10 +0800

In the following patches, shmem will support the swap out of large folios,
which means the shmem mappings may contain large order swap entries, so
using xa_get_order() to get the folio order of the shmem swap entry to
update the '*start' correctly.

Link: https://lkml.kernel.org/r/640ce8446a47b445ef89ed2bd61d6e92a916ecae.1723012159.git.baolin.wang@linux.alibaba.com
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

 mm/filemap.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/filemap.c~mm-filemap-use-xa_get_order-to-get-the-swap-entry-order
+++ a/mm/filemap.c
@@ -2056,6 +2056,8 @@ unsigned find_get_entries(struct address
 		folio = fbatch->folios[idx];
 		if (!xa_is_value(folio))
 			nr = folio_nr_pages(folio);
+		else
+			nr = 1 << xa_get_order(&mapping->i_pages, indices[idx]);
 		*start = indices[idx] + nr;
 	}
 	return folio_batch_count(fbatch);
@@ -2120,6 +2122,8 @@ put:
 		folio = fbatch->folios[idx];
 		if (!xa_is_value(folio))
 			nr = folio_nr_pages(folio);
+		else
+			nr = 1 << xa_get_order(&mapping->i_pages, indices[idx]);
 		*start = indices[idx] + nr;
 	}
 	return folio_batch_count(fbatch);
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

