Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094C01B3B19
	for <mm-commits@vger.kernel.org>; Fri,  3 Jul 2026 01:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783043329; cv=none; b=anvqJUQ9Jn10bnnT16+oGUGetvGzWhrGVNQCJWLjQfMdtls2E1yu89dLXZZi9sYTkRFSDiDuyJbKVdQLSDP6n7pcSfNhM1poJxqC6SnIe/0z3HrEn21zTavFNHzmL1nYESrZ2LpmKFHjygX7b4KHpoTj8Q1hRjoKTbrzex51sh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783043329; c=relaxed/simple;
	bh=PqdnQcddbcUzWrIWSeMmA66nDw06YOop7jw+NJbn3YI=;
	h=Date:To:From:Subject:Message-Id; b=LfH/vKnppb4yrXj1etLc2m76/mFQGsmh7jltyjPCR/eerB7hrkmiL1+EVJGcsSuJ95KyAsbdE/ymfI2zWH2KA2ta6Cf0z61mjbQfXZgB4s8F/pKyyEVF3gIlQXF64k/iPhNOdQnn7qZdlqCO1qIvpP/drTyz6MvV1zZ8ezPwMxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uzYjLO4w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uzYjLO4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7859E1F000E9;
	Fri,  3 Jul 2026 01:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783043327;
	bh=LT0kcwEMqiPU0C7lhkOh9Hb8fndRPATj9k+FL+aCBCg=;
	h=Date:To:From:Subject;
	b=uzYjLO4wtYYppYUH8xeaWg774VioZQ61cNIJgzRMS8erUzYGLd+syM6vZIMyYxImm
	 O7fleeeJCnA6P7eyzHOY3yoY10yxaxFSvzNIocXuKl1Hs3nwRCigiR7xvtLqDZwyRv
	 WPczlqqsS6RaWFO+iSOMbsZwlEWonvwbThgikY3g=
Date: Thu, 02 Jul 2026 18:48:47 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,shakeel.butt@linux.dev,rakie.kim@sk.com,matthew.brost@intel.com,joshua.hahnjy@gmail.com,hannes@cmpxchg.org,gourry@gourry.net,david@kernel.org,byungchul@sk.com,apopple@nvidia.com,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-migrate_device-pin-large-folios-before-splitting-fix.patch added to mm-unstable branch
Message-Id: <20260703014847.7859E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: condense comment about folio reference
has been added to the -mm mm-unstable branch.  Its filename is
     mm-migrate_device-pin-large-folios-before-splitting-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-migrate_device-pin-large-folios-before-splitting-fix.patch

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
mm-rename-arch_enable_thp_migration-to-arch_supports_pmd_softleaf.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch

