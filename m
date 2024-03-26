Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5E013D26E
	for <mm-commits@vger.kernel.org>; Tue, 26 Mar 2024 19:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711482777; cv=none; b=uBL/UpraD6yh84c9J53VzV2TmletPB10dFlSvLvbzguleptSrF2+1YR9s+rohSHtIohx5UDqQOQ019or4mpiCcWKPuZ/zfsJ2ZA3O9VC/rY5/eLIAy42pyKeh9GkCD8kdSE44T85O8IFJg2nU/NLUWdUKg2vfv/lNY/dVAsoCFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711482777; c=relaxed/simple;
	bh=NwAC9T24+TjQRQvi4DHePJhH/I85r8M9sEkoLsNQCQc=;
	h=Date:To:From:Subject:Message-Id; b=r/iozWgnmvbSTvfEKH45xGI3D3fRfDVXG+njZ3jko/915Yeggnaq3a2dYuKmJquRewYb6hfnoG/+14pyPnCv5RQ9wGJARLSTJEheArGrAeudfYToy1patnoJ2mvgihDNcSI8u1fFvhBXzi/TBXOe5M/Bgp1w9oayUyud1lnDUG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d6wo2JLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d6wo2JLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF6BC433C7;
	Tue, 26 Mar 2024 19:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1711482776;
	bh=NwAC9T24+TjQRQvi4DHePJhH/I85r8M9sEkoLsNQCQc=;
	h=Date:To:From:Subject:From;
	b=d6wo2JLUZKsQ2mPYfD9+tt6tY4E3dEGB5ubH8bIUq8cDU/aci5L9GuvVVJBDXPke/
	 N1v8vC86OiOfQFW3ZDQdxdXb7a1Ot0Ybv6S3d9DIMxBQ8bqL8KG1wiOA/7Bpscm8o9
	 PDb/eaQom9t7+b9Y5Ettg73S+8jfJfMmxzWw4fNA=
Date: Tue, 26 Mar 2024 12:52:56 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,mgorman@suse.de,bhe@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-make-__absent_pages_in_range-as-static.patch added to mm-unstable branch
Message-Id: <20240326195256.CBF6BC433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: make __absent_pages_in_range() as static
has been added to the -mm mm-unstable branch.  Its filename is
     mm-make-__absent_pages_in_range-as-static.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-make-__absent_pages_in_range-as-static.patch

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
Subject: mm: make __absent_pages_in_range() as static
Date: Tue, 26 Mar 2024 14:11:29 +0800

It's only called in mm/mm_init.c now.

Link: https://lkml.kernel.org/r/20240326061134.1055295-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: "Mike Rapoport (IBM)" <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h |    2 --
 mm/mm_init.c       |    2 +-
 2 files changed, 1 insertion(+), 3 deletions(-)

--- a/include/linux/mm.h~mm-make-__absent_pages_in_range-as-static
+++ a/include/linux/mm.h
@@ -3228,8 +3228,6 @@ static inline unsigned long get_num_phys
  */
 void free_area_init(unsigned long *max_zone_pfn);
 unsigned long node_map_pfn_alignment(void);
-unsigned long __absent_pages_in_range(int nid, unsigned long start_pfn,
-						unsigned long end_pfn);
 extern unsigned long absent_pages_in_range(unsigned long start_pfn,
 						unsigned long end_pfn);
 extern void get_pfn_range_for_nid(unsigned int nid,
--- a/mm/mm_init.c~mm-make-__absent_pages_in_range-as-static
+++ a/mm/mm_init.c
@@ -1144,7 +1144,7 @@ static void __init adjust_zone_range_for
  * Return the number of holes in a range on a node. If nid is MAX_NUMNODES,
  * then all holes in the requested range will be accounted for.
  */
-unsigned long __init __absent_pages_in_range(int nid,
+static unsigned long __init __absent_pages_in_range(int nid,
 				unsigned long range_start_pfn,
 				unsigned long range_end_pfn)
 {
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

