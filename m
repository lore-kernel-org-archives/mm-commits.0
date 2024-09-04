Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 690F5BE40
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725422034; cv=none; b=HUvLrf2lYEf91HV15ntm2tdt3Pm1lNJS2esb0A/n0F7gs8f/hiFCjLScZxqWZNDCwI26PqCp6L8+izIyZyzdCbA8v52gl7o3RPFi2bUw0zwxMfZz619qhXGCC4u5qM+3CMjnx8LTJI3Bswm5YiU3aUn7j6uAF36tnlS6ZR+aL0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725422034; c=relaxed/simple;
	bh=scnpaAybpiefh4TWd5UtQBebgdPnQDBe/mBskXQwRZU=;
	h=Date:To:From:Subject:Message-Id; b=slM7hqnxVWwsITimMFto847yxchTZRxh3knvKtoNHaYgLCenIfEOyG/A13qUPpuCPoJab/hMqicEDHKP0iM+xTAJMXExTKjcSaQv4Vc9817ccsoxDmusPbEbZeKM7MZpGlrOXF1WIRl8f6qASuLK3wOl6VMXpbZK9AsiGwGYjYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GE24qycd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GE24qycd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CBB9C4CEC2;
	Wed,  4 Sep 2024 03:53:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725422034;
	bh=scnpaAybpiefh4TWd5UtQBebgdPnQDBe/mBskXQwRZU=;
	h=Date:To:From:Subject:From;
	b=GE24qycdBMMqlUyT4O8GJqtu1RF9Vq8HjUQcjkE6kmnmoZPL7p0skM4LCft17fPkD
	 1zaYm0EmOjo4sR/woIwHv95H5bM8Oob1lyJeh7N/64pnFgDTCjVrlwY5z9ZKaApO6i
	 72HejQOhnXrMX5CsyvoBR/xKH23Y501/N92l0udw=
Date: Tue, 03 Sep 2024 20:53:53 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-support-large-folio-swap-out-fix.patch removed from -mm tree
Message-Id: <20240904035354.3CBB9C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: shmem: shmem_writepage() split folio at EOF before swapout
has been removed from the -mm tree.  Its filename was
     mm-shmem-support-large-folio-swap-out-fix.patch

This patch was dropped because it was folded into mm-shmem-support-large-folio-swap-out.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: shmem: shmem_writepage() split folio at EOF before swapout
Date: Sun, 25 Aug 2024 16:14:17 -0700 (PDT)

Working in a constrained (size= or nr_blocks=) huge=always tmpfs relies
on swapout to split a large folio at EOF, to trim off its excess before
hitting premature ENOSPC: shmem_unused_huge_shrink() contains no code to
handle splitting huge swap blocks, and nobody would want that to be added.

Link: https://lkml.kernel.org/r/aef55f8d-6040-692d-65e3-16150cce4440@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/mm/shmem.c~mm-shmem-support-large-folio-swap-out-fix
+++ a/mm/shmem.c
@@ -1459,6 +1459,7 @@ static int shmem_writepage(struct page *
 	swp_entry_t swap;
 	pgoff_t index;
 	int nr_pages;
+	bool split = false;
 
 	/*
 	 * Our capabilities prevent regular writeback or sync from ever calling
@@ -1480,8 +1481,20 @@ static int shmem_writepage(struct page *
 	 * If /sys/kernel/mm/transparent_hugepage/shmem_enabled is "always" or
 	 * "force", drivers/gpu/drm/i915/gem/i915_gem_shmem.c gets huge pages,
 	 * and its shmem_writeback() needs them to be split when swapping.
+	 *
+	 * And shrinkage of pages beyond i_size does not split swap, so
+	 * swapout of a large folio crossing i_size needs to split too
+	 * (unless fallocate has been used to preallocate beyond EOF).
 	 */
-	if (wbc->split_large_folio && folio_test_large(folio)) {
+	if (folio_test_large(folio)) {
+		split = wbc->split_large_folio;
+		index = shmem_fallocend(inode,
+			DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE));
+		if (index > folio->index && index < folio_next_index(folio))
+			split = true;
+	}
+
+	if (split) {
 try_split:
 		/* Ensure the subpages are still dirty */
 		folio_test_set_dirty(folio);
_

Patches currently in -mm which might be from hughd@google.com are

mm-shmem-support-large-folio-swap-out.patch
mm-restart-if-multiple-traversals-raced-fix.patch
mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch

