Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039691B960
	for <mm-commits@vger.kernel.org>; Wed, 28 Aug 2024 02:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724810544; cv=none; b=UoY1EhljwqqWJMhMqhBAQsFmOPDlMO1GHDgE3VUyoD/eEEzGaCRsjXEntaheT0x2bZY88phOSpe5rodD21vRYiLkrezgaGIDTW6gtRyPGvG8BBFIEjQ/Kcyg0ElcRdMRtC3yIVdKIqShFt0NAwlFLheP10Dnnb36MDcnAaV7L6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724810544; c=relaxed/simple;
	bh=lJxARUrbEZ3hy6SrxxhPLH4UFKMvco9OCAGudtLjKRM=;
	h=Date:To:From:Subject:Message-Id; b=R5i2HMOt61XVPuO8PPx9SbRPJbVIfzJC2B1Eba6v48My80GyzWEdn419lu9cZsPk3mOAEYmg1fk1MohtOHvbAoVbTclwOwx0UgaamqVW1GZqXhgSvZRytZdEoJfdk+rHIOL2TJaBnzHxGGpSpE3jG6W/sWurOeYCGHVbTHx0p9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gzi5kxbH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gzi5kxbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DC1C4FF19;
	Wed, 28 Aug 2024 02:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1724810543;
	bh=lJxARUrbEZ3hy6SrxxhPLH4UFKMvco9OCAGudtLjKRM=;
	h=Date:To:From:Subject:From;
	b=Gzi5kxbHg8lwIsraBKKDvpi1FT+XayGKQiA/khLXRzIk+6VnV5q9SnZ1qUyof66DZ
	 tt3DrLJS7PZcU2De2AoFOOJ2o9QnO6AtH+6FkMflOCM6eE/dzrUM1oD81GY+xDHZUe
	 MSaaL1ZEOMHlI0BSw/Gg9WHHKVTc7JYD5BJZJWR4=
Date: Tue, 27 Aug 2024 19:02:22 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-shmem-support-large-folio-swap-out-fix.patch added to mm-unstable branch
Message-Id: <20240828020223.43DC1C4FF19@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: shmem: shmem_writepage() split folio at EOF before swapout
has been added to the -mm mm-unstable branch.  Its filename is
     mm-shmem-support-large-folio-swap-out-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-shmem-support-large-folio-swap-out-fix.patch

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

mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch
mm-shmem-support-large-folio-swap-out-fix.patch
mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch

