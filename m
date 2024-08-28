Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A2F1401C
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 01:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724809524; cv=none; b=Hfpa8eAu147no/dAXeIUw4T9tlceCKSzEyXVmIG7vq+oAweAcA81V9Y12frvR01IOl1OzuMMycvoSEv0n6Js8jxRYkO6yq8was4gESI07GBjBZNLM+mYll13m5ksfX0jmXmyiLzR1Yf50a34dWARN9n5J5Y8zJMDHx4jDJldXl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724809524; c=relaxed/simple;
	bh=AYMUYwh0NiESl2xhJWFkDWs6cDteB+TD/rpSyCjcLrY=;
	h=Date:To:From:Subject:Message-Id; b=AlxSN/+vYhc6z14mz9wxT+nagdgT3ozelx1epQ6N1GX04zd2XSjS2DsRu8fL53rx9AJSvVCC1+vyimnl8XJtcItyYvI7x8/bHIH3XCgiFSk20Rsr8+TfauUMJ1D57dz/bA6zv1Qx7MNukFwodBiukXi44WAhNQt3CZ+IBUgsFkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=N7U+indg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="N7U+indg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D552FC32782;
	Wed, 28 Aug 2024 01:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724809523;
	bh=AYMUYwh0NiESl2xhJWFkDWs6cDteB+TD/rpSyCjcLrY=;
	h=Date:To:From:Subject:From;
	b=N7U+indg4e/Prqnc0biNtxZShuKVPFtSLFljv1YsZznTXJVttmkGy1aFCQZKuVo02
	 ZE8CDWeUYjRb/n2r2RlRqw/VzLiUzOTxAQnD7ZWnvdUMeNO+v4UD3MJKJgSxjWDrip
	 GRhG0e/VkyS/KtYXAzxNvk8CttKa7DEMOY5ilDac=
Date: Tue, 27 Aug 2024 18:45:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baohua@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch added to mm-unstable branch
Message-Id: <20240828014523.D552FC32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: fix the gfp flag for large folio allocation
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch

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
Subject: mm: shmem: fix the gfp flag for large folio allocation
Date: Tue, 27 Aug 2024 11:06:34 +0800

In shmem_replace_folio(), it may be necessary to allocate a large folio,
so we should update the gfp flags to ensure it is suitable for allocating
the large folio.

Link: https://lkml.kernel.org/r/5b1e9c5a-7f61-4d97-a8d7-41767ca04c77@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
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

 0 files changed

_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-shmem-simplify-the-suitable-huge-orders-validation-for-tmpfs.patch
mm-shmem-rename-shmem_is_huge-to-shmem_huge_global_enabled.patch
mm-shmem-move-shmem_huge_global_enabled-into-shmem_allowable_huge_orders.patch
mm-swap-extend-swap_shmem_alloc-to-support-batch-swap_map_shmem-flag-setting.patch
mm-shmem-extend-shmem_partial_swap_usage-to-support-large-folio-swap.patch
mm-filemap-use-xa_get_order-to-get-the-swap-entry-order.patch
mm-shmem-use-swap_free_nr-to-free-shmem-swap-entries.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio.patch
mm-shmem-support-large-folio-allocation-for-shmem_replace_folio-fix.patch
mm-shmem-drop-folio-reference-count-using-nr_pages-in-shmem_delete_from_page_cache.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-support-large-folio-swap-out.patch
mm-khugepaged-expand-the-is_refcount_suitable-to-support-file-folios.patch
mm-khugepaged-use-the-number-of-pages-in-the-folio-to-check-the-reference-count.patch
mm-khugepaged-support-shmem-mthp-copy.patch
mm-khugepaged-support-shmem-mthp-collapse.patch
selftests-mm-support-shmem-mthp-collapse-testing.patch

