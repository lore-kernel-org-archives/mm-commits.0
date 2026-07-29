Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD613264FC
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 03:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785297446; cv=none; b=EvRr1zCpXmj+mUbLwCP7RBRnHgyW8Jxk5fjVkjQi0l8OMwRFIgkNIW9d5SCIK8YIOGrski7YFBMdcqnMAmBaDfIylewFNSwcB60s1WDDWAKyAVbLZldm8fpnTUUSGHbOmHWmNwKi/CZA1R7HgcwzZnUbVzPsATa45/a2bSCbn8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785297446; c=relaxed/simple;
	bh=v7IJuod+QdJ2TZ8rqOkO2PLN1CnRBoQIlYEt/ZSjZFM=;
	h=Date:To:From:Subject:Message-Id; b=n1SDoJ+OVS9taynZp2QWLTdTMYXBtA1GFV9EqgRZULnZVwgsnmcsO3tgkZX+mgqtW7L4dyLn82hoqvv1QLI+2UiU9vxh+vpHEojmgFzTCMZmADK5Mzjovp8QY87Ibjv5J3cnjeHaK3VJRfMKbl9jxzesQDWPA718/w2MRGE4Tfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=13XJedpC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="13XJedpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002651F00A3A;
	Wed, 29 Jul 2026 03:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785297445;
	bh=MIRFv8XmxiBrR+JaZTInaWb1yqP1Um42fbYms1rCzHQ=;
	h=Date:To:From:Subject;
	b=13XJedpC6qkjiAObAL+eOnT9PQeqmy2OMZoaDEBt9z9iqDjKAN4R85bcb9XKiecYD
	 N64eZo92pTQU3Cd0kRXP4+zzF7jN2q4kC8Lw9+KKJRF+o7H4fsNF1NM6kkWkQRBrh2
	 TUwQFGzBANX1rHtgpBZYa1e8P3SDDOGSAtsJZKpw=
Date: Tue, 28 Jul 2026 20:57:24 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,shakeel.butt@linux.dev,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-migrate_device-pin-large-folios-before-splitting-fix.patch removed from -mm tree
Message-Id: <20260729035725.002651F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: condense comment about folio reference
has been removed from the -mm tree.  Its filename was
     mm-migrate_device-pin-large-folios-before-splitting-fix.patch

This patch was dropped because it was folded into mm-migrate_device-pin-large-folios-before-splitting.patch

------------------------------------------------------
From: Usama Arif <usama.arif@linux.dev>
Subject: condense comment about folio reference
Date: Wed, 1 Jul 2026 11:12:54 -0700

per various review comments

Link: https://lore.kernel.org/87bbf335-648f-4065-abc8-3eaab5a3beeb@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Gregory Price <gourry@gourry.net>
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Rakie Kim <rakie.kim@sk.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/migrate_device.c |   12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

--- a/mm/migrate_device.c~mm-migrate_device-pin-large-folios-before-splitting-fix
+++ a/mm/migrate_device.c
@@ -311,11 +311,7 @@ again:
 			if (folio_test_large(folio)) {
 				int ret;
 
-				/*
-				 * Keep the folio stable after dropping the PTE
-				 * lock. migrate_vma_split_folio() consumes this
-				 * reference.
-				 */
+				/* migrate_vma_split_folio() consumes this reference */
 				if (folio != fault_folio)
 					folio_get(folio);
 				lazy_mmu_mode_disable();
@@ -361,11 +357,7 @@ again:
 			if (folio && folio_test_large(folio)) {
 				int ret;
 
-				/*
-				 * Keep the folio stable after dropping the
-				 * PTE lock. migrate_vma_split_folio() consumes
-				 * this reference.
-				 */
+				/* migrate_vma_split_folio() consumes this reference */
 				if (folio != fault_folio)
 					folio_get(folio);
 				lazy_mmu_mode_disable();
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch
mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch
mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch
mm-vmstat-mm-memcontrol-add-_monotonic-vmstat-readers.patch
mm-vmscan-reduce-lru_lock-contention-via-vmstat-derived-scan-balance-cost.patch

