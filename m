Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCF540960F
	for <mm-commits@vger.kernel.org>; Fri, 10 Jul 2026 23:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783727651; cv=none; b=PKD8ZDt5oFDr+GQzMlltzvRZnekhGE+mSsbi8FlGsn0o7QH8R0OMpyjA0ySNqRHYRzMjqQgMH782Hb2TV+yDnmLP6aUP4uVU1E5OQVT3+T1SeH/B/s+78gvrqw4EHNkBcn6MelB0z3ezYV/swCF59gCsA+ucsKnDapCPk5qLCkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783727651; c=relaxed/simple;
	bh=Zfq1aA3bnqAKHAWIbxsujj6ml6O+GaoqMaq85inXevs=;
	h=Date:To:From:Subject:Message-Id; b=iADdlbKPouAXv7LFa1zFPY4YXWmObwvRd7jQ9fOigGhG0ZZzKe+tbD++MBRp7goec25QVaa9YnaIq01Lt0zDt3xaI2D3HPKvm2I/g+Y0ZL7hass/M5mezC8S1LcjUg0OWD0vkHTK7tCBKT4hTnyqj9DPj3zUJiIuB55sIsQivCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RcIrFcKp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RcIrFcKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B65F81F000E9;
	Fri, 10 Jul 2026 23:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783727649;
	bh=MtfDfooHCV6Zn8e9Lh13VX7P3x3Al1/C/MlX7IsQ3qw=;
	h=Date:To:From:Subject;
	b=RcIrFcKpeIS/XezNzeHJ300RXlEr9FYBNdzsHABl65x6FJvBfktKFxd2KLcrgCE5m
	 7LNInXZT0luYtd86f1y0aOxX1NOgeRuZKc6QDsrKn6r3pFeBsf6EOjUWWBIrW+XOPo
	 CHO+KGWQ5NF5a/YLeiv1Un6hzDmcHkcxYDRi2OSU=
Date: Fri, 10 Jul 2026 16:54:09 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch added to mm-new branch
Message-Id: <20260710235409.B65F81F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/madvise: skip device-private PMDs in cold and pageout walks
has been added to the -mm mm-new branch.  Its filename is
     mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks.patch

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
Subject: mm/madvise: skip device-private PMDs in cold and pageout walks
Date: Fri, 10 Jul 2026 03:55:22 -0700

madvise_cold_or_pageout_pte_range() takes pmd_trans_huge_lock(), whose
pmd_is_huge() check returns true for a device-private PMD.  The subsequent
!pmd_present() branch has a VM_BUG_ON() asserting migration is the only
allowed non-present case; a device-private PMD trips it.

Skip device-private PMDs in that non-present branch and continue to
huge_unlock before calling pmd_folio().  Downgrade the check to
VM_WARN_ON_ONCE() so an unexpected PMD softleaf logs a warning rather than
panicking.  Drop the thp_migration_supported() guard: it expands to
IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF), and both
pmd_is_migration_entry() and pmd_is_device_private_entry() already return
false when that config is not selected, so the guard suppresses only the
case where the warning would already be silent.

Potential trigger: an HMM-based GPU driver races with
madvise(MADV_COLD)/MADV_PAGEOUT: pmd_trans_huge(*pmd) reads true, then
migrate_vma_pages() flips the PMD to a device-private entry before the PMD
lock is acquired.

Link: https://lore.kernel.org/20260710105557.1987433-3-usama.arif@linux.dev
Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Balbir Singh <balbirs@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Byungchul Park <byungchul@sk.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
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
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/madvise.c~mm-madvise-skip-device-private-pmds-in-cold-and-pageout-walks
+++ a/mm/madvise.c
@@ -388,8 +388,8 @@ static int madvise_cold_or_pageout_pte_r
 			goto huge_unlock;
 
 		if (unlikely(!pmd_present(orig_pmd))) {
-			VM_BUG_ON(thp_migration_supported() &&
-					!pmd_is_migration_entry(orig_pmd));
+			VM_WARN_ON_ONCE(!pmd_is_migration_entry(orig_pmd) &&
+					!pmd_is_device_private_entry(orig_pmd));
 			goto huge_unlock;
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

