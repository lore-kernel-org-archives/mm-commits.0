Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855F53BADA2
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:48:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360125; cv=none; b=jm513jH0nud9wiGUFu58wA4bXl/52IQN3/1SSsQoyl6pSp5VEABDDxq8+9YQTvE2iQ677XDJWCPy8sgCpfjpHCW2ROypUDvWTUXhNPIxmeeEa9yoYpFyMmHv3tqqBMN3WDJxrjBv2Woq4F4b8118Yi/6KP5SDq1/VZeTKtktr44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360125; c=relaxed/simple;
	bh=W7ppDHe5o89KDm0SfajTdmDLm+RKVXklICkJA81jGiI=;
	h=Date:To:From:Subject:Message-Id; b=eBSQb4quYhcGGHf9voD/9QATs+nKSsx5u41rfELnPqjZNOSpvMbU2LvqffIds8LLjTqwVd3n0EtpGaIrZFrv2HBk6o6ClnwzCJpivEPDnELxabSXBrKYLWK9cJJPALpwUS8vAPVE5r5iLcB0zmCpGQxEMA1RhlfgvLIGRCxHrPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pUUineJq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pUUineJq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAA51F00A3A;
	Mon,  6 Jul 2026 17:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783360124;
	bh=wnhRWOLF+dLazFAlTUJCnuteOrA4JHRK4qjN4+Wv4Bs=;
	h=Date:To:From:Subject;
	b=pUUineJqySnGjW3E0pW9PSHwwTguVUreJbQ6ZT5If8odKTe4RdMYZIFaPW0oAWSUi
	 jpnoioi2WFARSWDYZSeTk4hHkqIWunFk11lJ91LCGhLK6sSBjwHES0T3pwajStFubJ
	 ROR+XXGMoXkPaeyKVLngwH+meA6xNLMmPuMzxkyI=
Date: Mon, 06 Jul 2026 10:48:43 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch removed from -mm tree
Message-Id: <20260706174844.1DAA51F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: move softleaf_to_folio() inside migration branch
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/huge_memory: move softleaf_to_folio() inside migration branch
Date: Tue, 30 Jun 2026 09:34:41 -0700

change_non_present_huge_pmd() calls softleaf_to_folio() unconditionally at
the top of the function.  softleaf_to_folio() extracts a PFN from the
entry and converts it to a folio pointer, which is only meaningful for
migration and device_private entries that encode a real PFN.

A swap entry encodes a swap offset instead, so softleaf_to_folio() would
produce a bogus pointer and crash on mprotect() when a PMD swap entry is
present.

Move the call into the migration_write branch where the folio is actually
used, so the function is safe for any non-present PMD type.

Link: https://lore.kernel.org/20260630164143.1595669-5-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
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

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-move-softleaf_to_folio-inside-migration-branch
+++ a/mm/huge_memory.c
@@ -2557,11 +2557,12 @@ static void change_non_present_huge_pmd(
 		bool uffd_wp_resolve)
 {
 	softleaf_t entry = softleaf_from_pmd(*pmd);
-	const struct folio *folio = softleaf_to_folio(entry);
 	pmd_t newpmd;
 
 	VM_WARN_ON(!pmd_is_valid_softleaf(*pmd));
 	if (softleaf_is_migration_write(entry)) {
+		const struct folio *folio = softleaf_to_folio(entry);
+
 		/*
 		 * A protection check is difficult so
 		 * just be safe and disable write
_

Patches currently in -mm which might be from usama.arif@linux.dev are

userfaultfd-wait-on-source-pmd-during-uffdio_move.patch
mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_supports_pmd_softleaf.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch

