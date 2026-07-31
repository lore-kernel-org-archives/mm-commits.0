Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE73331ECE
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465710; cv=none; b=p3e7mMfUJR3P39ruCME1YQ6/05yjJ4J7mYTnMkSoHZSHrzsXKNEcChEh9Om3z6dWuR68Q4Vig1XDucHg67qSJZKS4EsUL0DvWK9Ps3i3Mm/q7Lv5i4u67NHGbsIfE9IW4xiNr8J4h9ngSKHX5+CHGK+SXRhBMl33V6G+9T47zRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465710; c=relaxed/simple;
	bh=C9a2PQfDiFMc4/Vx8yoaHoBmUayoMR2C25iNKyV3zmU=;
	h=Date:To:From:Subject:Message-Id; b=ga54q+6SN+CCiPUnHAWB45h9TlV032AE1QgKDq3IO5dzN9TZ6mzGaLM29jlyFGm10EDf/Oyv9nPdYBYpn9mUwajJS4+oT7RVx4qm2EgCsvMVr6qZpBOrOr3cctkVcsrt8sq3GWzgx2n0F563uzKM23pTFALnW6Xzv9pqbyy+Yd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=WKMHGJPt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="WKMHGJPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 107271F00A3A;
	Fri, 31 Jul 2026 02:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465707;
	bh=L2atig856m2e0SMegWuDbAvgwMx3+hhDKyfEDbNeCiE=;
	h=Date:To:From:Subject;
	b=WKMHGJPtk9sbLH/87Q6F2Z0jhTAhyAgUOj7m51RLraN16eNyo7OhN1jj7Ic/g77sQ
	 +7TszrSAX2dAgToapmCVfO/i/8ab61DpQBjMbOKJQ/PNIZXRPyMSvyBFE/gaKeGzm8
	 8AvK0EWfsbkmTlAd+fX6jWaewxEiuUdwh4QYgMxs=
Date: Thu, 30 Jul 2026 19:41:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,vbabka@kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,alex@ghiti.fr,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-add-softleaf_to_pmd-and-convert-existing-callers.patch removed from -mm tree
Message-Id: <20260731024147.107271F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: add softleaf_to_pmd() and convert existing callers
has been removed from the -mm tree.  Its filename was
     mm-add-softleaf_to_pmd-and-convert-existing-callers.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -836,7 +836,7 @@ static int migrate_vma_insert_huge_pmd_p
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

mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch
mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch
mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch
mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch

