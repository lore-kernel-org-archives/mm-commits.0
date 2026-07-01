Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7054138758A
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 19:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782933974; cv=none; b=BdjWiNiSuxJip/hWGfWJF3pvTuYm3h22NaJ3gkrDespAjgGmo8NE99vVQlwNfsElILvqcbRfssSsK+zFUcK8lyA/q2UYSX5PNxtn7U9CxE+ALI2bvN2mgbU6LdS1EeVpD93d0WYVeeF89piIymc022XMFcQQNcPyOD6Ee6LD4MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782933974; c=relaxed/simple;
	bh=qZLI4ai70ymsjOtmOvbFTelOhWilXDw5P6s0RnzRiUU=;
	h=Date:To:From:Subject:Message-Id; b=JZUcmMf/bnE+4Fg1GufEJm3Agc+3tK1UY9Q/luuhjOvn5g1S4hw6JW9fpoBIJQUIrb2Z/JD2IMEr2q9V4uf9DzmI53iX6fWX4yhFjkZa3/pGzzRPQjPEoVUMp17X/UHPjijOGeFeLUv9XG4JHyQYtTmtoLF0hwnf0DHkbMM/JLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QltXkMss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QltXkMss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE9211F000E9;
	Wed,  1 Jul 2026 19:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782933973;
	bh=+lWS+RtMNNDDhxS+cLB9Fv0d3t+xi5fD4t3yDXgcNt8=;
	h=Date:To:From:Subject;
	b=QltXkMssSbn8axv1p6+NMo3ArG9wUCNYhNKeUedXpB5p15+Y2PkXro1ol0ov9/wgw
	 f6oWvbqDGmqc8b3TtKlKeZJt3HghFAbC6u+MMY3xxYDYWme6ZUSCRtYleH5+dcdP57
	 mv+YguSK2PMESdpvE8M0yuV5HQmNyIScxXHXl8Lg=
Date: Wed, 01 Jul 2026 12:26:12 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,shakeel.butt@linux.dev,sashiko-bot@kernel.org,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-pin-large-folios-before-splitting.patch added to mm-new branch
Message-Id: <20260701192612.DE9211F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/migrate_device: pin large folios before splitting
has been added to the -mm mm-new branch.  Its filename is
     mm-migrate_device-pin-large-folios-before-splitting.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-pin-large-folios-before-splitting.patch

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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/migrate_device: pin large folios before splitting
Date: Wed, 1 Jul 2026 07:06:38 -0700

migrate_vma_collect_pmd() can detect a large folio while holding the PTE
lock, then drop the PTE lock before calling migrate_vma_split_folio(). 
The split helper took its own reference, but only after the lock had
already been dropped.

One way to hit this is device migration over a range that contains a large
folio.  The walker reads the PTE while holding the PTE lock and derives
the folio either from a present PTE via vm_normal_page(), or from a
non-present PTE that encodes a device-private softleaf entry.  It then has
to drop the PTE lock because split_folio() can block.  Before
migrate_vma_split_folio() gets a folio reference, concurrent reclaim,
migration, or truncation can replace or clear the entry and drop the last
reference to the folio.  The split helper would then take a reference and
lock on a stale folio pointer.

Take a temporary reference before dropping the PTE lock and pass that
reference into migrate_vma_split_folio().  The helper consumes the
reference, so split_folio() still sees only the expected caller pin
instead of an extra pin that could make the split fail.

Link: https://lore.kernel.org/20260701140638.840773-1-usama.arif@linux.dev
Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260630164143.1595669-1-usama.arif%40linux.dev
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-pin-large-folios-before-splitting
+++ a/mm/migrate_device.c
@@ -77,6 +77,9 @@ static int migrate_vma_collect_hole(unsi
  * @folio: the folio to split
  * @fault_page: struct page associated with the fault if any
  *
+ * If @folio is not the folio containing @fault_page, the caller must hold a
+ * reference on @folio. The helper consumes that reference.
+ *
  * Returns 0 on success
  */
 static int migrate_vma_split_folio(struct folio *folio,
@@ -86,10 +89,8 @@ static int migrate_vma_split_folio(struc
 	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
 	struct folio *new_fault_folio = NULL;
 
-	if (folio != fault_folio) {
-		folio_get(folio);
+	if (folio != fault_folio)
 		folio_lock(folio);
-	}
 
 	ret = split_folio(folio);
 	if (ret) {
@@ -310,6 +311,13 @@ again:
 			if (folio_test_large(folio)) {
 				int ret;
 
+				/*
+				 * Keep the folio stable after dropping the PTE
+				 * lock. migrate_vma_split_folio() consumes this
+				 * reference.
+				 */
+				if (folio != fault_folio)
+					folio_get(folio);
 				lazy_mmu_mode_disable();
 				pte_unmap_unlock(ptep, ptl);
 				ret = migrate_vma_split_folio(folio,
@@ -353,6 +361,13 @@ again:
 			if (folio && folio_test_large(folio)) {
 				int ret;
 
+				/*
+				 * Keep the folio stable after dropping the
+				 * PTE lock. migrate_vma_split_folio() consumes
+				 * this reference.
+				 */
+				if (folio != fault_folio)
+					folio_get(folio);
 				lazy_mmu_mode_disable();
 				pte_unmap_unlock(ptep, ptl);
 				ret = migrate_vma_split_folio(folio,
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_supports_pmd_softleaf.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch

