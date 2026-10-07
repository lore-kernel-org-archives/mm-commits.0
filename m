Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10432EEE61;
	Wed,  7 Oct 2026 00:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334250; cv=none; b=IVanvD34uC1JLuB798KNh1eWHviBuK0iB0TqIz40sqGU1/QC8qhmIWujSuoKiAQqzzUNpqgmmOCBN5lKd2MU8+tLzw/Ovm1QcqBHj+Ioy83h3j+S1TtUZ/FR4u87INrLeBmuCt2HO//848HnlkGTvbJgcC2hzZgNoX+XUuHf5QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334250; c=relaxed/simple;
	bh=+KVGg2jLlwGhctb+89Cnyfpw63wUtSy+m1L1f3dPBwo=;
	h=Date:To:From:Subject:Message-Id; b=hSH1s7wjfTUDArB/r+QNwL6KqDBnrBR7kbsn2JcIL6t9IMRiverd5fukeLfebDgBAks7jXxaeyiPQM9T2vgMJ4CV8zvfIxoaW4WTAdqiddHJvULf1w+HVbV26xo5Bt0YFsU/kLUIxjfiehW+w8pr32AnB3rGqKCL09zmquUeLjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u04FNaVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u04FNaVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719801F0089C;
	Wed,  7 Oct 2026 00:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334249;
	bh=NuIZN8gS4JKJu7WnMNADd68eBV9zKlDllpskDeJqo3U=;
	h=Date:To:From:Subject;
	b=u04FNaVDzbgtDqqNONbfIxwqNunxpqETItVtiMdEV7wvp3UHg/t0wesMyMiuBBNX4
	 sfR+ryklKLek3W4YchauFIg6Pn5hV1Sjd0OchE2DQeLoluYvcBI070yCe3EiEl1mPR
	 i7zDyodrRIL0jwn6m7S21Jakm5l5Gi8EUH8v+pTI=
Date: Tue, 06 Oct 2026 17:50:49 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,rakie.kim@sk.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch removed from -mm tree
Message-Id: <20261007005049.719801F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: skip zone device folios in madvise_free_huge_pmd()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Gregory Price <gourry@gourry.net>
Subject: mm/huge_memory: skip zone device folios in madvise_free_huge_pmd()
Date: Mon, 17 Aug 2026 18:08:08 -0400

Patch series "mm: reject zone device folios in more folio walkers", v2.

Several LRU-oriented mm walkers resolve the folio backing a PMD entry (or
a physical pfn) and then reclaim, age, migrate, or lazyfree it without
ever checking for ZONE_DEVICE memory.

This series adds missing folio_is_zone_device() rejections, matching the
checks that comparable walkers already perform.

- mm/huge_memory, mm/madvise: the !pmd_present branch above these sites
  only filters device-private entries (which are non-present).

  A present zone device PMD (e.g. device-coherent) would still reach the
  folio and be lazyfreed / aged / paged out. Add an explicit check.

- mm/mempolicy: queue_folios_pmd() can see a present zone device PMD
  (e.g. device-coherent) and queue it for migration.

No crash reproducer - this is a correctness/hardening cleanup found by
inspection.  All checks are placed after the folio is resolved and before
it is acted upon, on paths that already hold the relevant page-table lock,
so no locking or refcount changes are involved.


This patch (of 3):

madvise_free_huge_pmd() resolves the folio backing a PMD via pmd_folio()
and marks it lazyfree without checking for zone device memory.

The surrounding guards do not cover every zone device case:

 - MADV_FREE only operates on anonymous VMAs (DAX mappings are excluded)

 - !pmd_present() branch rejects device-private and migration entries

 - present zone device PMD (device coherent THP) is not filtered.
   Unlike vm_normal_page_pmd(), it performs no special/pfnmap check,
   and would be marked lazyfree here.

Bail out when the folio is a zone device folio.

Link: https://lore.kernel.org/20260817220810.1175596-1-gourry@gourry.net
Link: https://lore.kernel.org/20260817220810.1175596-2-gourry@gourry.net
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
---

 mm/huge_memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/huge_memory.c~mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd
+++ a/mm/huge_memory.c
@@ -2423,6 +2423,10 @@ bool madvise_free_huge_pmd(struct mmu_ga
 	}
 
 	folio = pmd_folio(orig_pmd);
+
+	if (folio_is_zone_device(folio))
+		goto out;
+
 	/*
 	 * If other processes are mapping this folio, we couldn't discard
 	 * the folio unless they all do MADV_FREE so let's skip the folio.
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-memory_hotplug-factor-out-node_is_memoryless.patch
mm-mempolicy-use-vm_normal_folio_pmd-in-queue_folios_pmd.patch
mm-madvise-use-vm_normal_folio_pmd-in-cold-pageout-pmd-range.patch
mm-refactor-find_next_best_node-to-find_next_best_node_in.patch
mm-page_alloc-refactor-build_node_zonelist-out-of-build_zonelists.patch
proc-task_mmu-handle-special-pmds-in-clear_refs-and-pagemap.patch
mm-madvise-reclaim-isolated-folios-if-pte-restart-fails.patch
mm-madvise-use-folio_trylock-in-the-cold-pageout-pmd-split.patch

