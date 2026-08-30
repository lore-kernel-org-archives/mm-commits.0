Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB0D25B09C;
	Sun, 30 Aug 2026 00:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788049130; cv=none; b=rAyK4KWMRrVFFYbJDBK4s//oQAXHfbiUx7q2sKecPanWocB6kWx/HoHnYrZBZWOVTx6BUieM04hjVCMSpVysz2EscLCd6tJCXWi53UxC44LDiPmfhUgNo+vLGogmF4oVrTDJngLHFJc5/H2x5qKP4Ty/WqWZXK0JPc83BQJoCWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788049130; c=relaxed/simple;
	bh=93jdF4EurVPEf4xGc2I4TfdZW5b/vKJmUKpT1KfVSUU=;
	h=Date:To:From:Subject:Message-Id; b=GJrJfbnubeLATXdbCjXkmDchkmwtMhlaTLXaS3F7aAOxm+NmF+e1JkhIJoDlTwVk3kweeDYYUqSVn70YvGzcv+3vU/Tb342pleWXnBIMwZIxJdhaQGjFA5T16aTDcHqNherZsAg+/Jhk51FkCgGJHBWIZg9gvJZM3jUn67xzOYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DKlKB+GG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DKlKB+GG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCACB1F000E9;
	Sun, 30 Aug 2026 00:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788049128;
	bh=8KaJRgGkA5NY0TN8puCBbFBBTdGu/r9IWpGj5cu9MOg=;
	h=Date:To:From:Subject;
	b=DKlKB+GGocYtO4P6O8N1tZR/DtloPCU0axaftseifeiCllpOqOUqagkkKQ9EZQpzx
	 oImCrXdd/5RyhB1wvn0LgkjW/ytfYcU82ESIwoMnykFeVmnvB1yc6aSbWDy3BdFHwv
	 hzB0wnY63iCPEW0LPiHgTqfBLBvakVu5NoYc3KMU=
Date: Sat, 29 Aug 2026 17:18:48 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@linux.alibaba.com,vbabka@kernel.org,stable@vger.kernel.org,ryan.roberts@arm.com,rakie.kim@sk.com,matthew.brost@intel.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,joshua.hahnjy@gmail.com,jannh@google.com,dev.jain@arm.com,david@kernel.org,byungchul@sk.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,balbirs@nvidia.com,apopple@nvidia.com,gourry@gourry.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch added to mm-new branch
Message-Id: <20260830001848.DCACB1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mempolicy: skip zone device folios when queueing folios
has been added to the -mm mm-new branch.  Its filename is
     mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch

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
Subject: mm/mempolicy: skip zone device folios when queueing folios
Date: Mon, 17 Aug 2026 18:08:10 -0400

queue_folios_pte_range() already pairs vm_normal_folio() with an explicit
folio_is_zone_device() check before adding folios to the migration
pagelist.

vm_normal_folio() alone does not reject zone device memory (a present
device-coherent page in a normal VMA is returned as "normal").

Mirror the explicit check in queue_folios_pmd() as well.

queue_folios_pmd() uses pmd_folio() directly and can encounter a present
zone device PMD - e.g. a device-coherent THP.

This is not filtered by existing checks:
  !pmd_present()   - only rejects non-present device-private and
                     migration entries

  vma_migratable() - excludes DAX and VM_PFNMAP.

The early return also means such a folio is no longer counted in
qp->nr_failed under MPOL_MF_STRICT.  This is the same pattern used by
queue_folios_pte_range() (skipping zone device without failing).

Link: https://lore.kernel.org/20260817220810.1175596-4-gourry@gourry.net
Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
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
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/mempolicy.c~mm-mempolicy-skip-zone-device-folios-when-queueing-folios
+++ a/mm/mempolicy.c
@@ -679,6 +679,8 @@ static void queue_folios_pmd(pmd_t *pmd,
 		return;
 	}
 	folio = pmd_folio(pmdval);
+	if (folio_is_zone_device(folio))
+		return;
 	if (is_huge_zero_folio(folio)) {
 		walk->action = ACTION_CONTINUE;
 		return;
_

Patches currently in -mm which might be from gourry@gourry.net are

mm-mempolicy-take-a-cpuset-cookie-for-the-interleave-node-count.patch
mm-mempolicy-use-srcu-for-the-weighted-interleave-state.patch
mm-mempolicy-stop-copying-the-nodemask-in-the-interleave-paths.patch
mm-huge_memory-skip-zone-device-folios-in-madvise_free_huge_pmd.patch
mm-madvise-skip-zone-device-folios-in-cold-pageout-pmd-range.patch
mm-mempolicy-skip-zone-device-folios-when-queueing-folios.patch

