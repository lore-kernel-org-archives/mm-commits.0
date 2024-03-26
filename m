Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C658113D272
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711482784; cv=none; b=uqymutZPK3mZ7SEl+d6rAs/ze4D4XIgsAlue5NDusWSm1RQg6X3KaiQFC8l5Df3Qq9AyDdByHJJzlob+VV/jX9tLqAMcDcYuHNxNBM5yE7D8TAYkry4iEh3++er6ojrLYBHIHUhYlQDno4L2y+MTGJiAKN2N9dc8IeeYvXAZuCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711482784; c=relaxed/simple;
	bh=7JE6ds1LtRhAc9rKTSRrMRB4tyJHYcQGj9thsbYwkb0=;
	h=Date:To:From:Subject:Message-Id; b=camte9f/sZZZA/rV9gRaOusObUpd5n+y+q7gTX0Al03A0ZkNhuUjctE3L4jnFPNj4f0SNKOPFPVic4VPNsirt/WUlqDAyUDlDRYor/81qf7zA8cO2gdmEnl+Tm6HdiGJx2888oxf55vuCPn8A6vq/d2MAUb6liSKcNuc4hhDZYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=s2HPPKjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="s2HPPKjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F926C433F1;
	Tue, 26 Mar 2024 19:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711482784;
	bh=7JE6ds1LtRhAc9rKTSRrMRB4tyJHYcQGj9thsbYwkb0=;
	h=Date:To:From:Subject:From;
	b=s2HPPKjs6y/861JlKddCEa7iytQOnqLs5VX4jztTVRBNTUo7tPHGxSK3guoPDE7kI
	 bD26jMnqjAhK07Nm7Jy3deh5oxyfqa1n+DbmDW9X75kBI36brS9tiI4IxfQYGCiAUa
	 XIpO0giSMEGfitDFmZpefv64mSz0hrj6S3rnXHqk=
Date: Tue, 26 Mar 2024 12:53:03 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch added to mm-unstable branch
Message-Id: <20240326195304.6F926C433F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_alloc.c: change the array-length to MIGRATE_PCPTYPES
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch

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
From: Baoquan He <bhe@redhat.com>
Subject: mm/page_alloc.c: change the array-length to MIGRATE_PCPTYPES
Date: Tue, 26 Mar 2024 14:11:33 +0800

Earlier, in commit 1dd214b8f21c ("mm: page_alloc: avoid merging
non-fallbackable pageblocks with others"), migrate type MIGRATE_CMA and
MIGRATE_ISOLATE are removed from fallbacks list since they are never used.

Later on, in commit ("aa02d3c174ab mm/page_alloc: reduce fallbacks to
(MIGRATE_PCPTYPES - 1)"), the array column size is reduced to
'MIGRATE_PCPTYPES - 1'. In fact, the array row size need be reduced to
MIGRATE_PCPTYPES too since it's only covering rows of the number
MIGRATE_PCPTYPES. Even though the current code has handled cases
when the migratetype is CMA, HIGHATOMIC and MEMORY_ISOLATION, making
the row size right is still good to avoid future error and confusion.

Link: https://lkml.kernel.org/r/20240326061134.1055295-8-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_allocc-change-the-array-length-to-migrate_pcptypes
+++ a/mm/page_alloc.c
@@ -1545,7 +1545,7 @@ struct page *__rmqueue_smallest(struct z
  *
  * The other migratetypes do not have fallbacks.
  */
-static int fallbacks[MIGRATE_TYPES][MIGRATE_PCPTYPES - 1] = {
+static int fallbacks[MIGRATE_PCPTYPES][MIGRATE_PCPTYPES - 1] = {
 	[MIGRATE_UNMOVABLE]   = { MIGRATE_RECLAIMABLE, MIGRATE_MOVABLE   },
 	[MIGRATE_MOVABLE]     = { MIGRATE_RECLAIMABLE, MIGRATE_UNMOVABLE },
 	[MIGRATE_RECLAIMABLE] = { MIGRATE_UNMOVABLE,   MIGRATE_MOVABLE   },
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmallocc-optimize-to-reduce-arguments-of-alloc_vmap_area.patch
x86-remove-unneeded-memblock_find_dma_reserve.patch
mm-mm_initc-remove-the-useless-dma_reserve.patch
mm-mm_initc-add-new-function-calc_nr_all_pages.patch
mm-mm_initc-remove-meaningless-calculation-of-zone-managed_pages-in-free_area_init_core.patch
mm-mm_initc-remove-unneeded-calc_memmap_size.patch
mm-mm_initc-remove-arch_reserved_kernel_pages.patch
mm-move-array-mem_section-init-code-out-of-memory_present.patch
mm-init-remove-the-unnecessary-special-treatment-for-memory-less-node.patch
mm-make-__absent_pages_in_range-as-static.patch
mm-page_allocc-remove-unneeded-codes-in-numa-version-of-build_zonelists.patch
mm-mm_initc-remove-the-outdated-code-comment-above-deferred_grow_zone.patch
mm-page_allocc-dont-show-protection-in-zones-lowmem_reserve-for-empty-zone.patch
mm-page_allocc-change-the-array-length-to-migrate_pcptypes.patch

