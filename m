Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647B53F7AA0
	for <mm-commits@vger.kernel.org>; Thu,  2 Apr 2026 17:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775151511; cv=none; b=f1Q1I53+5a+YnjoMMSXkHngfB7/O1l4vyNo2O0+pK/52fqfTARDMC7eC7Ra0W/gsCh17QpJS3tYt3nr0OdKlrINVUtxQWs+tKZjcplJL/QYjnDiUZmH1jYtllYqxVRyNUh4nlLacc75vBxQWK1Y6NWilK1a/tdUsZClhUraysro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775151511; c=relaxed/simple;
	bh=ub/U543CZPFDw5ntjLmADpipwSmsGHVG6+9vTewizUY=;
	h=Date:To:From:Subject:Message-Id; b=fhrMUALKntlYRpKog9jJncXqpFA5SlFW4WPNNDBso1ZGo9KZHjc4d0Ptnd1j/bkuBdetvhsogSzNk/XBgDz2sqLh412A3adY8eUuZKfaa6BTZ30Wi5a8MaXcremZ/9mrUsrdUGTn/ZcjnMUrSiSFeOwjEvaMPnmqJ2Nk8jrb7Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Py796C5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Py796C5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9045C2BCB2;
	Thu,  2 Apr 2026 17:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775151510;
	bh=ub/U543CZPFDw5ntjLmADpipwSmsGHVG6+9vTewizUY=;
	h=Date:To:From:Subject:From;
	b=Py796C5zrGNmaXH451Z0gHw+NxrP7xkT50gd9hBbP+P3T4cYIDxhCb0wlS1oorMvg
	 +QdTYUuYCzqwacNMPtSVrOtLMCwFnWaYnwS2GESp1+P5oaKvgjJ3pNcUcHYwVy1kbQ
	 Wb7oRdc2JAqtOgO+m8QNj51dmcpOdwhja11srQDo=
Date: Thu, 02 Apr 2026 10:38:30 -0700
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,ptesarik@suse.com,mhocko@suse.com,ljs@kernel.org,liam.howlett@oracle.com,david@kernel.org,songmuchun@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-sparse-fix-comment-for-section-map-alignment.patch added to mm-new branch
Message-Id: <20260402173830.C9045C2BCB2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/sparse: fix comment for section map alignment
has been added to the -mm mm-new branch.  Its filename is
     mm-sparse-fix-comment-for-section-map-alignment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-sparse-fix-comment-for-section-map-alignment.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
Subject: mm/sparse: fix comment for section map alignment
Date: Thu, 2 Apr 2026 18:23:20 +0800

The comment in mmzone.h currently details exhaustive per-architecture
bit-width lists and explains alignment using min(PAGE_SHIFT,
PFN_SECTION_SHIFT).  Such details risk falling out of date over time and
may inadvertently be left un-updated.

We always expect a single section to cover full pages.  Therefore, we can
safely assume that PFN_SECTION_SHIFT is large enough to accommodate
SECTION_MAP_LAST_BIT.  We use BUILD_BUG_ON() to ensure this.

Update the comment to accurately reflect this consensus, making it clear
that we rely on a single section covering full pages.

Link: https://lkml.kernel.org/r/20260402102320.3617578-1-songmuchun@bytedance.com
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Petr Tesarik <ptesarik@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |   25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

--- a/include/linux/mmzone.h~mm-sparse-fix-comment-for-section-map-alignment
+++ a/include/linux/mmzone.h
@@ -2068,21 +2068,16 @@ static inline struct mem_section *__nr_t
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
+ * 2. section_nr_to_pfn() always clears PFN_SECTION_SHIFT lowest bits.
+ *
+ * We always expect a single section to cover full pages. Therefore,
+ * we can safely assume that PFN_SECTION_SHIFT is large enough to
+ * accommodate SECTION_MAP_LAST_BIT. We use BUILD_BUG_ON() to ensure this.
  */
 enum {
 	SECTION_MARKED_PRESENT_BIT,
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
mm-sparse-fix-preinited-section_mem_map-clobbering-on-failure-path.patch
mm-sparse-fix-comment-for-section-map-alignment.patch

