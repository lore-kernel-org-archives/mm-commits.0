Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AEE1E515
	for <mm-commits@vger.kernel.org>; Wed,  4 Sep 2024 03:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725421964; cv=none; b=GTIG93FsLFyi4DRJ8oU5yVAMNu7sY1NRp5aBojG1HybpOL0AHEx6FOdwjrOFsR7B8wT9rq+bQ90DxogPGI/RjAI7ifQCbz5dNvlHwv47Pn0Yt9fBN++JjhGkBpX591JlxJESLEY0ry/GxptD9GCZc7ZWIoiv4uw93EbTlpkUVFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725421964; c=relaxed/simple;
	bh=vPnqq0EKmJS8+S6vteXNi1swDQa/kc3wsTY1AwSKLrY=;
	h=Date:To:From:Subject:Message-Id; b=apR8bx8p/JgOsqx/FdUQPJATjkmcnrH0Lp9SfNLqK7E46GUSQVu45oh1jKgQM5C6YTcCux/xiBg/i8FvNLyVaWrfdFvhWbLvkfWq5xSjZsp1m1GuUqNxi3gbR9e7XV0VJQkLA+Nb5P1tOdJRUyxvKmMZMREh7aP8/4aGQ6+mflg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rrCqK3YC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rrCqK3YC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423E5C4CEC2;
	Wed,  4 Sep 2024 03:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725421964;
	bh=vPnqq0EKmJS8+S6vteXNi1swDQa/kc3wsTY1AwSKLrY=;
	h=Date:To:From:Subject:From;
	b=rrCqK3YC6csA4fUo5CtpUt8BRkx52auAFKUBKVloaA1TEHC9H9nkEJQrU4RzxzRnG
	 gXwVubCsSRm4uV1ppTg8UfL3Snh0kJvptPbRceNxH0liCfJMK7iaKHqsZsPyfpuOWk
	 R9rRzB9+SJF+6fU8Fh1yx3/0vz2CgHNcO1srcm8k=
Date: Tue, 03 Sep 2024 20:52:43 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,david@redhat.com,da.gomez@samsung.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch removed from -mm tree
Message-Id: <20240904035244.423E5C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix
has been removed from the -mm tree.  Its filename was
     mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch

This patch was dropped because it was folded into mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix
Date: Sun, 25 Aug 2024 15:31:21 -0700 (PDT)

Fix all the
Unexpected gfp: 0x2 (__GFP_HIGHMEM). Fixing up to gfp: 0x1120d0
(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_HARDWALL|__GFP_RECLAIMABLE).
Fix your code!
warnings from kmalloc_fix_flags() from xas_split_alloc() from
shmem_split_large_entry().

Link: https://lkml.kernel.org/r/e2a2ba5d-864c-50aa-7579-97cba1c7dd0c@google.com
Fixes: a960844d5ac9 ("mm: shmem: split large entry if the swapin folio is not large")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Daniel Gomez <da.gomez@samsung.com>
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

 mm/shmem.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/shmem.c~mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix
+++ a/mm/shmem.c
@@ -2003,6 +2003,9 @@ static int shmem_split_large_entry(struc
 	void *alloced_shadow = NULL;
 	int alloced_order = 0, i;
 
+	/* Convert user data gfp flags to xarray node gfp flags */
+	gfp &= GFP_RECLAIM_MASK;
+
 	for (;;) {
 		int order = -1, split_order = 0;
 		void *old = NULL;
_

Patches currently in -mm which might be from hughd@google.com are

mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large.patch
mm-shmem-support-large-folio-swap-out-fix.patch
mm-restart-if-multiple-traversals-raced-fix.patch
mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch

