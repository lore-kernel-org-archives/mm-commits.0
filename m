Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2853B383C7B
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 23:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783727653; cv=none; b=UmtXwbW8+aANhomiS3arHs7GJagu1R4MQ1DOiDKfRW86mkBy3fmxmi/nepB5VS+s0Eo1ghaiftaapcymsTPatJYX9gy16bOtugc1ZP8bgk8tJP3/x6hUge0UM7YJIj6PHxI+pKsxbs4NBbDurJ57fU7rr/4KFsyjwR5L6Fv6MNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783727653; c=relaxed/simple;
	bh=QgW3t1IcDLrM7MJYWbBs4PHYLdhmWTIhSbjso/adM9c=;
	h=Date:To:From:Subject:Message-Id; b=DuNzPhjdFwSsV3hbNnRuitpvUXGmvZpXpiAjx411dieXZ2AzKVFdRv4ahoL3wZhd2XgBR+QNdEndqRQlR8Vk3+ZtOVgomW2fve2EfEa59zAraAVDSNAGFJIP3J3uvw6fe2PMmdX4YO5xxBvDdNLnQZxdpFRAzu5XVkqUWZJDyw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MJWbvY32; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MJWbvY32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C3E1F000E9;
	Fri, 10 Jul 2026 23:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783727652;
	bh=ln3K4GXH0oWlka08aFgGXeaDUWYAtUFrtxQzGftCPaU=;
	h=Date:To:From:Subject;
	b=MJWbvY32uF6nEIXQrbZkBAcs9djM9A5t6jxC1l0mXVjte7EBQLu9wVKPsztqGGyly
	 0jNZsPLAYoJkOOePUOly6QYeod6rWFbv/VYK9C+fDwkXmX5ef749worTP2C0cmttdz
	 kI/4w35BmFyVMSuFCyaCBQ1nQ7p0BbRkXkx7Sa3Y=
Date: Fri, 10 Jul 2026 16:54:11 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch added to mm-new branch
Message-Id: <20260710235411.F0C3E1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch

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
Subject: mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd
Date: Fri, 10 Jul 2026 03:55:23 -0700

madvise_free_pte_range() checks pmd_trans_huge(*pmd) unlocked, then
madvise_free_huge_pmd() takes pmd_trans_huge_lock().  pmd_is_huge()
returns true for a device-private PMD, so orig_pmd can be device-private
and enter the !pmd_present() branch.

Skip device-private PMDs in that non-present branch and continue to out
before calling pmd_folio().  Downgrade the check to VM_WARN_ON_ONCE() so
an unexpected PMD softleaf logs a warning rather than panicking.  Drop the
thp_migration_supported() guard: it expands to
IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF), and both
pmd_is_migration_entry() and pmd_is_device_private_entry() already return
false when that config is not selected, so the guard suppresses only the
case where the warning would already be silent.

Potential trigger: an HMM-based GPU driver races with madvise(MADV_FREE):
migrate_vma_pages() flips the PMD to a device-private entry between the
caller's pmd_trans_huge() check and the callee's pmd_trans_huge_lock().

Link: https://lore.kernel.org/20260710105557.1987433-4-usama.arif@linux.dev
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Gregory Price <gourry@gourry.net>
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
Cc: sashiko-bot <sashiko-bot@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd
+++ a/mm/huge_memory.c
@@ -2331,8 +2331,8 @@ bool madvise_free_huge_pmd(struct mmu_ga
 		goto out;
 
 	if (unlikely(!pmd_present(orig_pmd))) {
-		VM_BUG_ON(thp_migration_supported() &&
-				  !pmd_is_migration_entry(orig_pmd));
+		VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
+				!pmd_is_device_private_entry(orig_pmd));
 		goto out;
 	}
 
_

Patches currently in -mm which might be from usama.arif@linux.dev are

userfaultfd-wait-on-source-pmd-during-uffdio_move.patch
mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_has_pmd_softleaves.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch
mm-migrate_device-pin-large-folios-before-splitting.patch
mm-migrate_device-pin-large-folios-before-splitting-fix.patch
mm-mempolicy-skip-non-present-pmds-when-queueing-folios.patch
mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch
mm-huge_memory-skip-device-private-pmds-in-madvise_free_huge_pmd.patch

