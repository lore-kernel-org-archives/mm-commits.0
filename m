Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF46D3D2FF0
	for <mm-commits@vger.kernel.org>; Tue, 31 Mar 2026 20:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774987651; cv=none; b=EV2SitLz2UFbkRy6O6Rx1qRDxQNYn85s/MN1B9w5phAHSFa0qFJY8dTlurMY+XWd6rsVbqd0J8ISTdGQL7inaA+Zdt0wU5/eZI5YfCv07FCkdTBolPP+fapCTj3Spz4EvJZRgLW8+ZClhxVkMyWBkR/YK/ls+RBz0KqxcW4rwDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774987651; c=relaxed/simple;
	bh=S58X8EFbMPscr5JIGke1yLKDqpEEHfLbWM41+7U73SE=;
	h=Date:To:From:Subject:Message-Id; b=cC7pnJr4ZDbFbMxyKTsCQlzXmj+oN6+XNJ4RxSLZ/5LLyDNIX39i13qVZVY2rvgIUaAZrzAG9x/mnAWkPlDPLRE1gAeHixg6KPbE59qxxV6vFprxRxanpxOjGPjQ9NNIV3h91eeOayOLzbL3hNlStlXxKURMT+mdPYeH5UQ5ZBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JdE/PeSu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JdE/PeSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522B7C19423;
	Tue, 31 Mar 2026 20:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774987650;
	bh=S58X8EFbMPscr5JIGke1yLKDqpEEHfLbWM41+7U73SE=;
	h=Date:To:From:Subject:From;
	b=JdE/PeSuFTIsdSfZKd9WowsO4a+1uJROHPpd/B9Hxau/A9ngHtMjIb7QjE3aThik/
	 sHgIWcIDerSK874flfGaxYQGTKsuedb0ewfCX11PvZCGffJr4YQ13mtP7dWwdxdueZ
	 r52J0nCLm3paUSXuIjZ2xxk3CrR4MeBYYxhUmatM=
Date: Tue, 31 Mar 2026 13:07:29 -0700
To: mm-commits@vger.kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-fix-build_bug_on-check-for-section-map-alignment.patch added to mm-unstable branch
Message-Id: <20260331200730.522B7C19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: fix BUILD_BUG_ON check for section map alignment
has been added to the -mm mm-unstable branch.  Its filename is
     mm-sparse-fix-build_bug_on-check-for-section-map-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-fix-build_bug_on-check-for-section-map-alignment.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Muchun Song <songmuchun@bytedance.com>
Subject: mm/sparse: fix BUILD_BUG_ON check for section map alignment
Date: Tue, 31 Mar 2026 19:30:23 +0800

The comment in mmzone.h states that the alignment requirement
is the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT. However, the
pointer arithmetic (mem_map - section_nr_to_pfn()) results in
a byte offset scaled by sizeof(struct page). Thus, the actual
alignment provided by the second term is PFN_SECTION_SHIFT +
__ffs(sizeof(struct page)).

Update the compile-time check and the mmzone.h comment to
accurately reflect this mathematically guaranteed alignment by
taking the minimum of PAGE_SHIFT and PFN_SECTION_SHIFT +
__ffs(sizeof(struct page)). This avoids the issue of the check
being overly restrictive on architectures like powerpc where
PFN_SECTION_SHIFT alone is very small (e.g., 6).

Also, remove the exhaustive per-architecture bit-width list from the
comment; such details risk falling out of date over time and may
inadvertently be left un-updated, while the existing BUILD_BUG_ON
provides sufficient compile-time verification of the constraint.

No runtime impact so far: SECTION_MAP_LAST_BIT happens to fit within
the smaller limit on all existing architectures.

Link: https://lkml.kernel.org/r/20260331113023.2068075-1-songmuchun@bytedance.com
Fixes: def9b71ee651 ("include/linux/mmzone.h: fix explanation of lower bits in the SPARSEMEM mem_map pointer")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   24 +++++++++---------------
 mm/internal.h          |    3 ++-
 2 files changed, 11 insertions(+), 16 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-fix-build_bug_on-check-for-section-map-alignment
+++ a/include/linux/mmzone.h
@@ -2068,21 +2068,15 @@ static inline struct mem_section *__nr_t
 extern size_t mem_section_usage_size(void);
 
 /*
- * We use the lower bits of the mem_map pointer to store
- * a little bit of information.  The pointer is calculated
- * as mem_map - section_nr_to_pfn(pnum).  The result is
- * aligned to the minimum alignment of the two values:
- *   1. All mem_map arrays are page-aligned.
- *   2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT
- *      lowest bits.  PFN_SECTION_SHIFT is arch-specific
- *      (equal SECTION_SIZE_BITS - PAGE_SHIFT), and the
- *      worst combination is powerpc with 256k pages,
- *      which results in PFN_SECTION_SHIFT equal 6.
- * To sum it up, at least 6 bits are available on all architectures.
- * However, we can exceed 6 bits on some other architectures except
- * powerpc (e.g. 15 bits are available on x86_64, 13 bits are available
- * with the worst case of 64K pages on arm64) if we make sure the
- * exceeded bit is not applicable to powerpc.
+ * We use the lower bits of the mem_map pointer to store a little bit of
+ * information. The pointer is calculated as mem_map - section_nr_to_pfn().
+ * The result is aligned to the minimum alignment of the two values:
+ *
+ * 1. All mem_map arrays are page-aligned.
+ * 2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT lowest bits. Because
+ *    it is subtracted from a struct page pointer, the offset is scaled by
+ *    sizeof(struct page). This provides an alignment of PFN_SECTION_SHIFT +
+ *    __ffs(sizeof(struct page)).
  */
 enum {
 	SECTION_MARKED_PRESENT_BIT,
--- a/mm/internal.h~mm-sparse-fix-build_bug_on-check-for-section-map-alignment
+++ a/mm/internal.h
@@ -972,7 +972,8 @@ static inline void sparse_init_one_secti
 {
 	unsigned long coded_mem_map;
 
-	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > PFN_SECTION_SHIFT);
+	BUILD_BUG_ON(SECTION_MAP_LAST_BIT > min(PFN_SECTION_SHIFT + __ffs(sizeof(struct page)),
+						PAGE_SHIFT));
 
 	/*
 	 * We encode the start PFN of the section into the mem_map such that
_

Patches currently in -mm which might be from songmuchun@bytedance.com are

mm-memcontrol-remove-dead-code-of-checking-parent-memory-cgroup.patch
mm-workingset-use-folio_lruvec-in-workingset_refault.patch
mm-rename-unlock_page_lruvec_irq-and-its-variants.patch
mm-vmscan-refactor-move_folios_to_lru.patch
mm-memcontrol-allocate-object-cgroup-for-non-kmem-case.patch
mm-memcontrol-return-root-object-cgroup-for-root-memory-cgroup.patch
mm-memcontrol-prevent-memory-cgroup-release-in-get_mem_cgroup_from_folio.patch
buffer-prevent-memory-cgroup-release-in-folio_alloc_buffers.patch
writeback-prevent-memory-cgroup-release-in-writeback-module.patch
mm-memcontrol-prevent-memory-cgroup-release-in-count_memcg_folio_events.patch
mm-page_io-prevent-memory-cgroup-release-in-page_io-module.patch
mm-migrate-prevent-memory-cgroup-release-in-folio_migrate_mapping.patch
mm-mglru-prevent-memory-cgroup-release-in-mglru.patch
mm-memcontrol-prevent-memory-cgroup-release-in-mem_cgroup_swap_full.patch
mm-workingset-prevent-memory-cgroup-release-in-lru_gen_eviction.patch
mm-workingset-prevent-lruvec-release-in-workingset_refault.patch
mm-zswap-prevent-lruvec-release-in-zswap_folio_swapin.patch
mm-swap-prevent-lruvec-release-in-lru_gen_clear_refs.patch
mm-workingset-prevent-lruvec-release-in-workingset_activation.patch
mm-memcontrol-prepare-for-reparenting-lru-pages-for-lruvec-lock.patch
mm-memcontrol-eliminate-the-problem-of-dying-memory-cgroup-for-lru-folios.patch
mm-lru-add-vm_warn_on_once_folio-to-lru-maintenance-helpers.patch
mm-sparse-fix-build_bug_on-check-for-section-map-alignment.patch

