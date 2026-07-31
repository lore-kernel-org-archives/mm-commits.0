Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84F33264F6
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465719; cv=none; b=UjZgWZitWt7Ccja3FBFWs/PMUqqreFTsfJ+OG4bYzHTZqirr1HtIyJc/nxYH7U1/pdWvBmy760ZvxjUCMCUDxwDKcUEqKR9rEFFfpf3IF3WihFhKFH9RxUEb7oQGZ7Rv7+7D0QM3Lk9hQ96dKvVhJyNn5CCx46RPwNAR4e1GuU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465719; c=relaxed/simple;
	bh=loSOdRsQI3Wnqw9QJQ6pCYmoAMkVzhjaCrYvaAwzFn4=;
	h=Date:To:From:Subject:Message-Id; b=sTuvXJAQINx3LIHUioh0faiALaQ25I2KJWUrSMs1c0eGFkMrGwqRw2d6tHGMa7caZ/4DtvJ0aWb/TqvtpRoJ2ViVfwSNXn4h5nVK3KhVFXq4PC7qvcojy6SJMunKINL68gDsqXUmRs5PgaoIsPotGvG4zkekWSGrLXCsfVZve8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PpHB7aaf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PpHB7aaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FCB1F000E9;
	Fri, 31 Jul 2026 02:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465716;
	bh=tpWk096vDCZ6czyRRK3uLRqZ2NaTdyxHP41NFF+dnWA=;
	h=Date:To:From:Subject;
	b=PpHB7aafgfEPjBGkPqRwp1AronGH02zbe2gWXGQA+jD8/PqyHgUzhjkXIUCUn0YxO
	 Lbz3eYZ+6HfqsgjnIR/X3Pg2T+IuAEW4pfPqWlMq2ktNGU1guEaxFa3N1cYUYDJUMB
	 aMH6GxV5oriSXYsdd8Wz7uGH2zbyy1mh53oNADQQ=
Date: Thu, 30 Jul 2026 19:41:55 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,willy@infradead.org,vbabka@kernel.org,shikemeng@huaweicloud.com,shakeel.butt@linux.dev,ryan.roberts@arm.com,riel@surriel.com,nphamcs@gmail.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kasong@tencent.com,kas@kernel.org,hannes@cmpxchg.org,dev.jain@arm.com,david@kernel.org,chrisl@kernel.org,baoquan.he@linux.dev,baolin.wang@linux.alibaba.com,baohua@kernel.org,alex@ghiti.fr,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch removed from -mm tree
Message-Id: <20260731024156.62FCB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/migrate_device: move softleaf_to_folio() inside device-private branch
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/migrate_device: move softleaf_to_folio() inside device-private branch
Date: Mon, 6 Jul 2026 04:42:07 -0700

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

Link: https://lore.kernel.org/20260706114320.1643046-6-usama.arif@linux.dev
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

mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch
mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch
mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch
mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch

