Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8753F7875
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360127; cv=none; b=MHhdMjIOfd+umL+k7U78f1lljofdqcfFT9bAFZqmbO1utqyq+daMx7VOW4VzlGkPy4RNciDIczmD74p/EgfFoANkflE+ptlWur02IaRrU4xxfn6X3A4MJ7uMlNCFyF2EINKTD9AYw61d8fqJ4GEYZ3RSRZi0uIzOCDlrprIVP+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360127; c=relaxed/simple;
	bh=SL0xRiozHynboU+bBM3ZdeHhgmCXe2jU7+SNPDKGWP4=;
	h=Date:To:From:Subject:Message-Id; b=UuGsyKfjNu6PudG5inKkTLusOFPJR/ANvuVoNhntgAP0BuWECHxVw3bUH7XrC60dKW+mXcVfZwQH4e1ToAuEX3bWxaZECOnYhJ3hgEl7Z0u65xqYKXR52yTmQWKXNn/CqSqj/WkZkc/DN4P0/mqLtA9UPSYL64+zVfBimViR5wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hs4pFUUR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hs4pFUUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838C11F00A3D;
	Mon,  6 Jul 2026 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783360125;
	bh=Q2KdNLPhpvw5fs9tZ5G1y9jW46xzAn7lvcmcEzq1Vj0=;
	h=Date:To:From:Subject;
	b=hs4pFUURTR/79LwEW91oFGtqNyZzppDXRfkhswnWhzB3tfsY2ZkrYPr+D5d8tsQVD
	 nmoipHCotnzYN8wZJ7AL0wFj2WDybq0Wu+aznqyPI6s95lFR7sw4u75Om7CdBfzV7P
	 W8MNk36/HAcbIOGy2ZMFYS0w+6lTRw0kEI9VDYFk=
Date: Mon, 06 Jul 2026 10:48:45 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch removed from -mm tree
Message-Id: <20260706174845.838C11F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: move softleaf_to_folio() inside device-private branch
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/migrate_device: move softleaf_to_folio() inside device-private branch
Date: Tue, 30 Jun 2026 09:34:42 -0700

migrate_vma_collect_pmd() calls softleaf_to_folio() on a non-present PMD
before checking the entry's type.  softleaf_to_folio() converts the
entry's offset to a PFN, which is only meaningful for migration or
device-private entries.

A PMD swap entry's offset is a swap offset, not a PFN, so the lookup would
either return a bogus folio pointer or trip pfn_to_page validation on a
debug kernel.  In the non-device-private path the returned folio is then
unused (the OR short-circuits to migrate_vma_collect_skip()), but the
lookup itself is already unsafe.

Move the softleaf_to_folio() call inside the device-private branch where
the folio is actually needed, mirroring the equivalent
change_non_present_huge_pmd() fix.

Link: https://lore.kernel.org/20260630164143.1595669-6-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
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

 mm/migrate_device.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch
+++ a/mm/migrate_device.c
@@ -166,11 +166,14 @@ static int migrate_vma_collect_huge_pmd(
 	} else if (!pmd_present(*pmdp)) {
 		const softleaf_t entry = softleaf_from_pmd(*pmdp);
 
-		folio = softleaf_to_folio(entry);
-
 		if (!softleaf_is_device_private(entry) ||
-			!(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE) ||
-			(folio->pgmap->owner != migrate->pgmap_owner)) {
+		    !(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE)) {
+			spin_unlock(ptl);
+			return migrate_vma_collect_skip(start, end, walk);
+		}
+
+		folio = softleaf_to_folio(entry);
+		if (folio->pgmap->owner != migrate->pgmap_owner) {
 			spin_unlock(ptl);
 			return migrate_vma_collect_skip(start, end, walk);
 		}
_

Patches currently in -mm which might be from usama.arif@linux.dev are

userfaultfd-wait-on-source-pmd-during-uffdio_move.patch
mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-rename-arch_enable_thp_migration-to-arch_supports_pmd_softleaf.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch

