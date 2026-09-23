Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F6544AB76
	for <mm-commits@vger.kernel.org>; Wed, 23 Sep 2026 22:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202764; cv=none; b=hg/TRqL+kUGiEQ5/VW8GbsxjOXnKiTqJdlPN8XtadUykf5Mom0yFxdN9yyYRdDyHbec9Vwrzan5Fft689HdBQJfoJsEBhW30ExkBoHHnoC4ucZDT6QnGseD4AFINXlh/XCRptjiWruR2eN209pMGchXjCzFsWoiiST4vwwlsnCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202764; c=relaxed/simple;
	bh=DW7HdpRiXK326Se1Sfr2sllFyB5aO0nwX2DLYdsdMmI=;
	h=Date:To:From:Subject:Message-Id; b=TGJ3QXH6R/BiUr0kKewE5GBMWF1RUEs7MnIz37dfdxVoQP/pWERiDaIkk+TqrKkTlSqB4+U3NkOIbuO2fvat869DZoM1TU/8WlBz8W9CLiQ4g2ElP6HcpiZRK1AxcXaY9vatw1sfTDapDRHAHQRaZ1nIKofAelmyqPPfmox+tzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=GdiXKHpN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="GdiXKHpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E23A1F000FF;
	Wed, 23 Sep 2026 22:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790202760;
	bh=YGLQoB2kFsol3JKG6HELTgd0AAcUdxKNKyY7SzH2Cjc=;
	h=Date:To:From:Subject;
	b=GdiXKHpNv2cuYOzvlT84Ssyq9PkYLNTVm/0pX9A0U5WfXNDrd4aKG/4t2xVYpQm58
	 +Ap1jGFL2Vrj2/stBGcguh/evosQ+KyYpruVJ8Y/a9PjfZNkiW+GhYmPbIMAgwkDXl
	 tgtplGvChAbPoVt+l1EPLRiY9FgcM6F86sjedQek=
Date: Wed, 23 Sep 2026 15:32:39 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch added to mm-unstable branch
Message-Id: <20260923223240.5E23A1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: rename remap_page() to remap_anon_folio()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: rename remap_page() to remap_anon_folio()
Date: Wed, 23 Sep 2026 23:32:40 +0200

remap_page() now only has one caller, __folio_freeze_split_anon(), and is
only ever called for anon folios: unmap_folio() currently leaves file
folios unmapped after the split, so they need no remapping.

Rename it to remap_anon_folio() to make that explicit, and add a
VM_WARN_ON_FOLIO() documenting it.

Link: https://lore.kernel.org/20260923-swap-thp-cleanup-v6-9-ba1b4ba72c6f@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>
Cc: Kairui Song <ryncsn@gmail.com>
---

 mm/huge_memory.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-rename-remap_page-to-remap_anon_folio
+++ a/mm/huge_memory.c
@@ -3551,7 +3551,6 @@ static void unmap_folio(struct folio *fo
 	/*
 	 * Anon pages need migration entries to preserve them, but file
 	 * pages can simply be left unmapped, then faulted back on demand.
-	 * If that is ever changed (perhaps for mlock), update remap_page().
 	 */
 	if (folio_test_anon(folio))
 		try_to_migrate(folio, ttu_flags);
@@ -3636,10 +3635,17 @@ bool unmap_huge_pmd_locked(struct vm_are
 	return __discard_anon_folio_pmd_locked(vma, addr, pmdp, folio);
 }
 
-static void remap_page(struct folio *folio, unsigned long nr, int flags)
+static void remap_anon_folio(struct folio *folio, unsigned long nr, int flags)
 {
 	int i = 0;
 
+	/*
+	 * unmap_folio() installs migration entries only for anon folios,
+	 * so currently only anon folios need to be remapped. File folios
+	 * stay unmapped after the split and are faulted back on demand.
+	 */
+	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
+
 	for (;;) {
 		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
 		i += folio_nr_pages(folio);
@@ -3723,7 +3729,7 @@ static void __split_folio_to_order(struc
 		 *
 		 * Note that for mapped sub-pages of an anonymous THP,
 		 * PG_anon_exclusive has been cleared in unmap_folio() and is stored in
-		 * the migration entry instead from where remap_page() will restore it.
+		 * the migration entry instead from where remap_anon_folio() will restore it.
 		 * We can still have PG_anon_exclusive set on effectively unmapped and
 		 * unreferenced sub-pages of an anonymous THP: we can simply drop
 		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
@@ -4083,7 +4089,7 @@ out_no_split:
 	if (need_remap) {
 		if (!ret && !folio_is_device_private(folio))
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-		remap_page(folio, 1 << old_order, ttu_flags);
+		remap_anon_folio(folio, 1 << old_order, ttu_flags);
 	}
 
 	return ret;
_

Patches currently in -mm which might be from kasong@tencent.com are

mm-memcontrol-move-the-lru_zone_size-sanity-check-to-the-reader-side.patch
mm-mglru-introduce-helpers-for-manipulating-gen-and-refs-flags.patch
mm-migrate-copy-all-referenced-state-via-folio_migrate_lru_refs.patch
mm-mglru-move-max_seq-read-into-walk_update_folio.patch
mm-mglru-use-explicit-tier-range-in-read_ctrl_pos.patch
mm-mglru-fix-potential-generation-folio-number-leak.patch
mm-swap-fix-off-by-one-in-swap-cache-replace-sanity-check.patch
mm-huge_memory-fix-rejection-of-swap-cache-folios-with-a-mapping.patch
mm-huge_memory-invert-folio_ref_freeze-check-to-reduce-indentation.patch
mm-huge_memory-split-the-routine-for-splitting-anon-and-file-folio.patch
mm-huge_memory-rename-__split_unmapped_folio-to-__split_frozen_folio.patch
mm-huge_memory-consolidate-irq-and-locking-for-folio-split.patch
mm-huge_memory-move-eof-trimming-into-the-file-split-helper.patch
mm-huge_memory-move-unmap-and-remap-into-the-split-helpers.patch
mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch
mm-huge_memory-move-the-racy-refcount-check-into-unmap_folio.patch
mm-huge_memory-move-filemap-management-into-the-file-split-helper.patch
mm-huge_memory-move-anon_vma-handling-into-the-anon-split-helper.patch
mm-huge_memory-move-memcg-switch-into-the-file-split-helper.patch
mm-huge_memory-drop-the-unused-do_lru-argument-of-the-file-split-helper.patch
mm-huge_memory-clean-up-after-split-folio-freeing-in-__folio_split.patch
mm-huge_memory-count-only-swap-cache-refs-in-anon-folio-split.patch
mm-huge_memory-drop-the-redundant-mapping-argument-of-__split_frozen_folio.patch

