Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB253C0A10;
	Wed,  5 Aug 2026 02:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896801; cv=none; b=Eu0gcDRYW6g7ODny8aiz7JSmuHpPSwIWsgbiMTuiIy3aPmMEJr+Qi5qDf4OpUdB0SeObXqLGlgrhBnj3iomhqEqhu3s21BN2hfuCvSYUApvfnhIpzrqoiQsID0dYM7eJQok0gkzJZBIvacgvEeu7wxcQrkamLs6gf0wlsyCnfQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896801; c=relaxed/simple;
	bh=QpxN8w7PyjmxWG8KpZgnziwK+1OAMS7VJKGow4z5sVc=;
	h=Date:To:From:Subject:Message-Id; b=V927Y4IZ9u/3nJb7staFFUfM5mZJZW7hF7fAqQXRxfHxn91qUwQPOh2rcq78RB5CQrhLETQj4prYLyeHVn6nAZ/RDTZkjXaXTcxywzOCI4vgS6j/HIE4ZrNGawt7vRRaVE+vstHtJXO6maHjo3kDlstcqMKe7xVznLh51TXYXyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xEI/M+WC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xEI/M+WC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827CD1F000E9;
	Wed,  5 Aug 2026 02:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785896799;
	bh=/SMBAX6MCSZQ5hidmanD4kffUn8zFh4fSvbvKRtzWtk=;
	h=Date:To:From:Subject;
	b=xEI/M+WCaHuCtfE15r/2O1gH2GzRV9Ck0FDRHXHhJWR6W0JY0AvbLvx+KMnuEhZNA
	 37Fcqdk2ICefkSQj5jdNQJu83L3LdwnQ/uD8nTicfg/iFMMsWG/7Xa0HtSWE7IST8v
	 vUVUzvT1M2E7LYWPnw0YRUJgm264giR6uviWlkpA=
Date: Tue, 04 Aug 2026 19:26:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,shakeel.butt@linux.dev,sashiko-bot@kernel.org,ryan.roberts@arm.com,rakie.kim@sk.com,npache@redhat.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,hannes@cmpxchg.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch removed from -mm tree
Message-Id: <20260805022639.827CD1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/mempolicy: skip non-present PMDs when queueing folios
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: mm/mempolicy: skip non-present PMDs when queueing folios
Date: Fri, 10 Jul 2026 03:55:21 -0700

Patch series "mm: handle device-private PMDs in walk callbacks", v3.

Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
to PMD operations") a PMD may hold a device-private swap entry whenever an
HMM-based GPU driver migrates an anonymous THP folio to device memory via
migrate_vma_pages().

pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
for any non-present, non-none huge PMD), so several MM walk callbacks that
used to assume present THP or migration entry are now reachable with a
device-private PMD.  The results range from a VM_BUG_ON() firing on debug
kernels, to an oops on a bogus vmemmap dereference, to silently isolating
an unrelated live folio from LRU in the aliasing case.


This patch (of 3):

queue_folios_pmd() is called under pmd_trans_huge_lock(), whose
pmd_is_huge() check returns true for any non-present, non-none PMD
softleaf.  Passing such a PMD to pmd_folio() treats the softleaf encoding
as a hardware PFN and can return a bogus folio pointer.

Mirror queue_folios_pte_range(): handle non-present entries before looking
up a folio.  Keep migration entries counted as failures, but skip other
non-present PMDs such as device-private entries.

Potential trigger: an HMM-based GPU driver migrates an anonymous THP folio
to device memory via migrate_vma_pages(), leaving a device-private PMD. 
Userspace then calls mbind(), migrate_pages() or set_mempolicy_home_node()
on that range.

Link: https://lore.kernel.org/20260710105557.1987433-1-usama.arif@linux.dev
Link: https://lore.kernel.org/20260710105557.1987433-2-usama.arif@linux.dev
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Jann Horn <jannh@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-skip-non-present-pmds-when-queueing-folios
+++ a/mm/mempolicy.c
@@ -654,12 +654,14 @@ static void queue_folios_pmd(pmd_t *pmd,
 {
 	struct folio *folio;
 	struct queue_pages *qp = walk->private;
+	pmd_t pmdval = pmdp_get(pmd);
 
-	if (unlikely(pmd_is_migration_entry(*pmd))) {
-		qp->nr_failed++;
+	if (unlikely(!pmd_present(pmdval))) {
+		if (pmd_is_migration_entry(pmdval))
+			qp->nr_failed++;
 		return;
 	}
-	folio = pmd_folio(*pmd);
+	folio = pmd_folio(pmdval);
 	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-add-pgrotate_anon-and-pgrotate_file-vmstat-counters.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch

