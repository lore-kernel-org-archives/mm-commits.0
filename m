Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D88CC3F1045;
	Sun, 30 Aug 2026 00:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788049126; cv=none; b=rDqzIvuIK6AgM367vTfm5kHDwmAqy0KLMU6NBQoYRULqiNTl19NhPoYzV+NoA+qMxC8H50u8Y0J1g/+omj935M9qaaOMZa2UUUk+inGdaKaXBZxwLZFjqVFM1Jk1kNUOOen17pka5pWS54JorHxMPDinAnU8gPOEFg7JJLNFjJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788049126; c=relaxed/simple;
	bh=fEf+c07wSHeMNcQ/IRFKZIRC9DxjiJ0hEE0hsgp/ASo=;
	h=Date:To:From:Subject:Message-Id; b=XAedJZskTZdzcnI5MCBf0q84I7U8s6S/HuB7T3Z82cA0BJAUS8ico87otKK2Ea+RedLuXdZwoZUvBBRqqWNf6+gXoYCGMMLwjAdEbiXY5ixIvMjNMNcX6Ukdsy7NDvae3xQyLDR77QHkorGktQsUDNC2BuENp53GWxuDb9Mgc4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OcH9CPJw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OcH9CPJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DB21F000E9;
	Sun, 30 Aug 2026 00:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788049124;
	bh=sSskkZC0i1EtX0h3ugbs5+nE7KCCJ4ju2fFTiS9nlVU=;
	h=Date:To:From:Subject;
	b=OcH9CPJwVR6UN6hrPEWlPZ6uamcip9XxUeTxDlmRPn4ie+pq8OY3XojqlmScHWeup
	 r2rOEccnlIL5hp4n2TBMsQuwcA5ZyUc1jiq2I2wVB8/D+xOhwn45mJPkYtBVBXyLsA
	 GDR4Z8UKPIxtx3IKnKCvj0gc1e05pNxGBrxCnRo8=
Date: Sat, 29 Aug 2026 17:18:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,rakie.kim@sk.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch added to mm-new branch
Message-Id: <20260830001844.67DB21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: skip zone device folios in madvise_free_huge_pmd()
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch

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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch
mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch
mm-mempolicy-stop-copying-the-nodemask-in-the-interleave-paths.patch
mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch
mm-madvise-skip-zone-device-folios-in-cold-pageout-pmd-range.patch
mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch

