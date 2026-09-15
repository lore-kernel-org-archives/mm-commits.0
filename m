Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FC0233947
	for <mm-commits@vger.kernel.org>; Tue, 15 Sep 2026 00:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789433115; cv=none; b=UqYcCwjvC5eeg437PmVcEVmuv82ubEDjRt2mZKPKeLqyn6nKduJzmSaj+xFK1t/tLvbn8O+XrJ3aPPaFYdlyMKAnRuqWuSznRpDPSV9IFxlZ7V4ES3QnQkrIt0t9t7KZh1KnWNkgyQ2rfAsQcM1CjPzEdKevfOONuGti1nfOhOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789433115; c=relaxed/simple;
	bh=Mv0a8cOPodLj2enUATfqb/M7yskYjCr+M5r4SWamd+E=;
	h=Date:To:From:Subject:Message-Id; b=IJbqnfvvO9qiXI4RvJ9RTgqJ20kStNCked0VPOgpGS8XiH7cckfoVHkp+xyns7x2/62WGW8slsuNfNMlM+ih7J69Ag52alvnR0LNRf4yVFLSfZHKiUgPJ520teg8nvokiw4geq8a1To6G6/g5HshAIhelU2beZ43BVaXr9vFjA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=1m98K1Di; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1m98K1Di"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74801F00893;
	Tue, 15 Sep 2026 00:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789433111;
	bh=l6TVwIYP0auqQ3dq0NGw/qusUfeBrM0FrjKtbw9vJiw=;
	h=Date:To:From:Subject;
	b=1m98K1DiwcQofyj4+5qif9Mo8JLA5xko+lqt4YNcxHV0n2AdMdKBQzwUMFStra6jn
	 Nl2/Sg0aRr/F6xsht8kEHQeIq5+B2J8IXsbB4fLkuaFdmichKd1I6wJhZlOEIKGF3G
	 AOQiPTMk3qhtGxvbL9v9owpAuKh4Z4dNUlOod4qM=
Date: Mon, 14 Sep 2026 17:45:10 -0700
To: mm-commits@vger.kernel.org,kasong@tencent.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch added to mm-new branch
Message-Id: <20260915004510.D74801F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: rename remap_page() to remap_anon_folio()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-rename-remap_page-to-remap_anon_folio.patch

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
From: Kairui Song <kasong@tencent.com>
Subject: mm/huge_memory: rename remap_page() to remap_anon_folio()
Date: Tue, 15 Sep 2026 01:14:50 +0800

remap_page() now only has one caller, __folio_freeze_split_anon(), and is
only ever called for anon folios: unmap_folio() currently leaves file
folios unmapped after the split, so they need no remapping.

Rename it to remap_anon_folio() to make that explicit, and add a
VM_WARN_ON_FOLIO() documenting it.

Link: https://lore.kernel.org/20260915-swap-thp-cleanup-v5-9-39878b37dfb0@tencent.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 mm/huge_memory.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-rename-remap_page-to-remap_anon_folio
+++ a/mm/huge_memory.c
@@ -3552,7 +3552,7 @@ static void unmap_folio(struct folio *fo
 	/*
 	 * Anon pages need migration entries to preserve them, but file
 	 * pages can simply be left unmapped, then faulted back on demand.
-	 * If that is ever changed (perhaps for mlock), update remap_page().
+	 * If that is ever changed (perhaps for mlock), update remap_anon_folio().
 	 */
 	if (folio_test_anon(folio))
 		try_to_migrate(folio, ttu_flags);
@@ -3637,10 +3637,17 @@ bool unmap_huge_pmd_locked(struct vm_are
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
@@ -3724,7 +3731,7 @@ static void __split_folio_to_order(struc
 		 *
 		 * Note that for mapped sub-pages of an anonymous THP,
 		 * PG_anon_exclusive has been cleared in unmap_folio() and is stored in
-		 * the migration entry instead from where remap_page() will restore it.
+		 * the migration entry instead from where remap_anon_folio() will restore it.
 		 * We can still have PG_anon_exclusive set on effectively unmapped and
 		 * unreferenced sub-pages of an anonymous THP: we can simply drop
 		 * PG_anon_exclusive (-> PG_mappedtodisk) for these here.
@@ -4084,7 +4091,7 @@ out_no_split:
 	if (need_remap) {
 		if (!ret && !folio_is_device_private(folio))
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
-		remap_page(folio, 1 << old_order, ttu_flags);
+		remap_anon_folio(folio, 1 << old_order, ttu_flags);
 	}
 
 	return ret;
@@ -4206,7 +4213,7 @@ static int __folio_freeze_split_file(str
 fail:
 	/*
 	 * If we want to use try_to_migrate() on file in unmap_folio,
-	 * remember to add remap_page() and adapt it.
+	 * remember to add remap_anon_folio() and adapt it.
 	 */
 	xas_unlock_irq(xas);
 	if (nr_shmem_dropped)
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

