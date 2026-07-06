Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2E336C597
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360608; cv=none; b=KFRnIMjsn1BHFAFyxgDP73Dcv4Ts9/3eHpbg+eH1B4Flx0LCheTMKn1bHCEPvlvTLvciba1hxVil4aMDmw438eQmx31aYRXetazhVxgvZoOjsuxijo1YBBSWvkQ2S7ZTfa9RdRA9u6XExHyRPrByrxUQuy21peRq/B1C4Pw4Q9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360608; c=relaxed/simple;
	bh=j0ER/0sUzTSRmOywoNPS0mG0hNyyhR975Ch4H46I8EA=;
	h=Date:To:From:Subject:Message-Id; b=SEFaWRXKBaVIm6dlZypV4ddun6sZO8rr8pZPc1gILgRMBN6dd5qFNKEMdnU65vo7P3fAj1kNGd4ISlM7UhUruvkp6vZSupdMYv9ifVNMfLhfm8O1+XYrkIxZwU6hnQ0acpo+Nzp0VoAN1eith2xFM4Lj9XTLkuqEs1ZK8m7IiI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=JIz2TFWi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="JIz2TFWi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6DB61F000E9;
	Mon,  6 Jul 2026 17:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783360606;
	bh=7ZPISuxKVicSRN3Y+24jQhQ0AsfyUwoY6SOFaD+2qso=;
	h=Date:To:From:Subject;
	b=JIz2TFWinR8wIuAZtHUa136hv2Xa7kFXn2WucB3Hl4T73X3U2nA/5uJqR+aLYnFMg
	 9ybvfPZuR5QcymiftXK7lfRoRIQhNNGUN4039gS1GWZMHXuPbQ51ePQ2/Ihc9KoR2R
	 tQ1pwsWvkD3W0v7PLDsDNnBk6lTed4J/hFb2g7/w=
Date: Mon, 06 Jul 2026 10:56:46 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-add-softleaf_to_pmd-and-convert-existing-callers.patch added to mm-unstable branch
Message-Id: <20260706175646.A6DB61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: add softleaf_to_pmd() and convert existing callers
has been added to the -mm mm-unstable branch.  Its filename is
     mm-add-softleaf_to_pmd-and-convert-existing-callers.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-add-softleaf_to_pmd-and-convert-existing-callers.patch

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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm: add softleaf_to_pmd() and convert existing callers
Date: Mon, 6 Jul 2026 04:42:03 -0700

Patch series "mm: preparatory patches for PMD level swap entries", v2.

This is the preparatory part of the PMD page table swapin work.  The full
PMD swap entry series has been split into two parts:

  1. this preparatory series, which contains the first 6 patches. Zi [1]
     and Lance [2] suggested to separate this out from the core series.
  2. the PMD swap entry core series, which depends on this one. I will
     send this once the preparatory series is merged in mm-new as v3
     as the combined is currently at v2 [1].
     I have not marked this prep series as v3, as its not really adding
     support for PMD swap entries.

This series does not introduce PMD swap entries and does not install any
new page-table entry type.  It only cleans up existing PMD softleaf
helpers and call sites so the follow-up PMD swap entry series can be
smaller and easier to review.

It should be safe to merge independently.  The patches are either helper
additions, refactors of existing open-coded logic, defensive checks that
preserve current migration/device-private behavior, or a mechanical rename
of the PMD softleaf Kconfig gate.  The follow-up series depends on these
helpers, but this series does not depend on the follow-up series.

Patch breakdown:

  1. mm: add softleaf_to_pmd() and convert existing callers
     Add the PMD counterpart to softleaf_to_pte() and convert existing
     swp_entry_to_pmd() users that are constructing PMD softleaf
     entries.

  2. mm: extract mm_prepare_for_swap_entries() helper
     Hoist the "register mm with swapoff" double-checked-locking
     pattern out of try_to_unmap_one() and copy_nonpresent_pte() so
     future PMD-level users do not need another open-coded copy.

  3. fs/proc: use softleaf_has_pfn() in pagemap PMD walker
     Avoid assuming every non-present PMD softleaf entry encodes a PFN.
     Existing migration/device-private behavior is preserved.

  4. mm/huge_memory: move softleaf_to_folio() inside migration branch
     Keep the folio lookup in change_non_present_huge_pmd() scoped to
     the migration-entry branch that actually needs it.

  5. mm/migrate_device: move softleaf_to_folio() inside device-private
     branch
     Apply the same ordering cleanup to migrate_vma_collect_pmd(): only
     derive a folio after confirming the PMD entry is device-private.

  6. mm: rename ARCH_ENABLE_THP_MIGRATION to ARCH_HAS_PMD_SOFTLEAVES
     Rename the architecture gate to describe what it actually enables:
     PMD softleaf entries.  Migration remains the only current user in
     this series; the follow-up series adds PMD swap entries.


This patch (of 6):

Add softleaf_to_pmd() as the PMD counterpart to softleaf_to_pte(),
completing the symmetry of the softleaf abstraction for page table leaf
entries.

The upcoming PMD swap entry support needs to construct PMD entries from
swap entries.  Converting existing swp_entry_to_pmd() callers to
softleaf_to_pmd() in a prep patch keeps the feature patches focused on new
functionality rather than mixing refactoring with new code.

Link: https://lore.kernel.org/20260706114320.1643046-1-usama.arif@linux.dev
Link: https://lore.kernel.org/20260706114320.1643046-2-usama.arif@linux.dev
Link: https://lore.kernel.org/all/6E99CC4E-A026-4DE3-8A5A-34216771F521@nvidia.com/ [1]
Link: https://lore.kernel.org/all/b08cafbb-a4b7-4609-84ae-dbb2cfcfc8be@linux.dev/#t [2]
Link: https://lore.kernel.org/all/20260602142537.198755-1-usama.arif@linux.dev/ [3]
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/leafops.h |   20 ++++++++++++++++++++
 mm/debug_vm_pgtable.c   |    4 ++--
 mm/huge_memory.c        |   12 ++++++------
 mm/migrate_device.c     |    2 +-
 4 files changed, 29 insertions(+), 9 deletions(-)

--- a/include/linux/leafops.h~mm-add-softleaf_to_pmd-and-convert-existing-callers
+++ a/include/linux/leafops.h
@@ -108,6 +108,21 @@ static inline softleaf_t softleaf_from_p
 	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
 }
 
+/**
+ * softleaf_to_pmd() - Obtain a PMD entry from a leaf entry.
+ * @entry: Leaf entry.
+ *
+ * This generates an architecture-specific PMD entry that can be utilised to
+ * encode the metadata the leaf entry encodes.
+ *
+ * Returns: Architecture-specific PMD entry encoding leaf entry.
+ */
+static inline pmd_t softleaf_to_pmd(softleaf_t entry)
+{
+	/* Temporary until swp_entry_t eliminated. */
+	return swp_entry_to_pmd(entry);
+}
+
 #else
 
 static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
@@ -115,6 +130,11 @@ static inline softleaf_t softleaf_from_p
 	return softleaf_mk_none();
 }
 
+static inline pmd_t softleaf_to_pmd(softleaf_t entry)
+{
+	return __pmd(0);
+}
+
 #endif
 
 /**
--- a/mm/debug_vm_pgtable.c~mm-add-softleaf_to_pmd-and-convert-existing-callers
+++ a/mm/debug_vm_pgtable.c
@@ -758,7 +758,7 @@ static void __init pmd_leaf_soft_dirty_t
 		return;
 
 	pr_debug("Validating PMD swap soft dirty\n");
-	pmd = swp_entry_to_pmd(args->leaf_entry);
+	pmd = softleaf_to_pmd(args->leaf_entry);
 	WARN_ON(!pmd_is_huge(pmd));
 	WARN_ON(!pmd_is_valid_softleaf(pmd));
 
@@ -829,7 +829,7 @@ static void __init pmd_softleaf_tests(st
 		return;
 
 	pr_debug("Validating PMD swap\n");
-	pmd1 = swp_entry_to_pmd(args->leaf_entry);
+	pmd1 = softleaf_to_pmd(args->leaf_entry);
 	WARN_ON(!pmd_is_huge(pmd1));
 	WARN_ON(!pmd_is_valid_softleaf(pmd1));
 
--- a/mm/huge_memory.c~mm-add-softleaf_to_pmd-and-convert-existing-callers
+++ a/mm/huge_memory.c
@@ -1819,7 +1819,7 @@ static void copy_huge_non_present_pmd(
 	if (softleaf_is_migration_write(entry) ||
 	    softleaf_is_migration_read_exclusive(entry)) {
 		entry = make_readable_migration_entry(swp_offset(entry));
-		pmd = swp_entry_to_pmd(entry);
+		pmd = softleaf_to_pmd(entry);
 		if (pmd_swp_soft_dirty(*src_pmd))
 			pmd = pmd_swp_mksoft_dirty(pmd);
 		if (pmd_swp_uffd_wp(*src_pmd))
@@ -1832,7 +1832,7 @@ static void copy_huge_non_present_pmd(
 		 */
 		if (softleaf_is_device_private_write(entry)) {
 			entry = make_readable_device_private_entry(swp_offset(entry));
-			pmd = swp_entry_to_pmd(entry);
+			pmd = softleaf_to_pmd(entry);
 
 			if (pmd_swp_soft_dirty(*src_pmd))
 				pmd = pmd_swp_mksoft_dirty(pmd);
@@ -2570,12 +2570,12 @@ static void change_non_present_huge_pmd(
 			entry = make_readable_exclusive_migration_entry(swp_offset(entry));
 		else
 			entry = make_readable_migration_entry(swp_offset(entry));
-		newpmd = swp_entry_to_pmd(entry);
+		newpmd = softleaf_to_pmd(entry);
 		if (pmd_swp_soft_dirty(*pmd))
 			newpmd = pmd_swp_mksoft_dirty(newpmd);
 	} else if (softleaf_is_device_private_write(entry)) {
 		entry = make_readable_device_private_entry(swp_offset(entry));
-		newpmd = swp_entry_to_pmd(entry);
+		newpmd = softleaf_to_pmd(entry);
 		if (pmd_swp_uffd_wp(*pmd))
 			newpmd = pmd_swp_mkuffd_wp(newpmd);
 	} else {
@@ -4927,7 +4927,7 @@ int set_pmd_migration_entry(struct page_
 	}
 
 	/* Set PMD. */
-	pmdswp = swp_entry_to_pmd(entry);
+	pmdswp = softleaf_to_pmd(entry);
 	if (softdirty)
 		pmdswp = pmd_swp_mksoft_dirty(pmdswp);
 	if (uffd_wp)
@@ -4980,7 +4980,7 @@ void remove_migration_pmd(struct page_vm
 		else
 			entry = make_readable_device_private_entry(
 							page_to_pfn(new));
-		pmde = swp_entry_to_pmd(entry);
+		pmde = softleaf_to_pmd(entry);
 
 		if (pmd_swp_soft_dirty(*pvmw->pmd))
 			pmde = pmd_swp_mksoft_dirty(pmde);
--- a/mm/migrate_device.c~mm-add-softleaf_to_pmd-and-convert-existing-callers
+++ a/mm/migrate_device.c
@@ -835,7 +835,7 @@ static int migrate_vma_insert_huge_pmd_p
 		else
 			swp_entry = make_readable_device_private_entry(
 						page_to_pfn(page));
-		entry = swp_entry_to_pmd(swp_entry);
+		entry = softleaf_to_pmd(swp_entry);
 	} else {
 		if (folio_is_zone_device(folio) &&
 		    !folio_is_device_coherent(folio)) {
_

Patches currently in -mm which might be from usama.arif@linux.dev are

userfaultfd-wait-on-source-pmd-during-uffdio_move.patch
mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch

