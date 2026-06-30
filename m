Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD3946AF1A
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 19:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782849065; cv=none; b=uUOfcMZBxOqQ1rQf7ngNstztI32OGfcptdRGvz+7atNfzYeO7hLN8pXOV1EdXxdgDOvewrcTj7Fp8uf9wqgT1mN15OHMFmX6R7Ngdcw6iZ2iVncvf+peAsqsD6JoOO6bkW3vFvF485G/kbPVFfZqenbw+ROQuHzo+YnKpDHFDzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782849065; c=relaxed/simple;
	bh=B7qIHXx3GDTjLF4M6NRGJ9xw6NVrn9vahwhdIjE+YaA=;
	h=Date:To:From:Subject:Message-Id; b=NXQPOvmuS4McYGLE/4l/dSuplqegNtN86JxKi9Z1ThxNWGDG87h3wrw8nR9T1QlFx+8nvmokVdde+Mv0xvF2CIIjaOZpTx+UTb3a/J6SRk+gECLiDw4jl+tMkQ1HAw4N8noE2QkL2LyhFA8y9nCAvmFBGl79rdJt2WwuDqgmQQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ocwaDeLf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ocwaDeLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661BA1F000E9;
	Tue, 30 Jun 2026 19:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782849063;
	bh=061FfZVyX9PhRNIQ+WpQBtiCVjpXzy0fGqbhe5Xwtyc=;
	h=Date:To:From:Subject;
	b=ocwaDeLfCGaX50TTF5d+qhzlxZszorqPS/p34XdCxvVStfTFO7B7Ov+FdXhgAFtgn
	 fDp1+JiDq0+y7QN1stPuXS8sYdJ0Qyxtb636rcUJOTwkv+OJ59+34QeMgrsbrgdji7
	 VtIW13p4ZWJoFlXFA6MEqdzPwLo1faNeZUGwxQwY=
Date: Tue, 30 Jun 2026 12:51:02 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch added to mm-new branch
Message-Id: <20260630195103.661BA1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc: use softleaf_has_pfn() in pagemap PMD walker
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch

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
Subject: fs/proc: use softleaf_has_pfn() in pagemap PMD walker
Date: Tue, 30 Jun 2026 09:34:40 -0700

pagemap_pmd_range_thp() assumes that every non-present PMD is a migration
entry and unconditionally calls softleaf_to_page().  This will crash on
any non-present PMD type that does not encode a PFN, such as the upcoming
PMD-level swap entries.

Guard the page lookup with softleaf_has_pfn(), matching how
pte_to_pagemap_entry() already handles non-present PTEs.

Link: https://lore.kernel.org/20260630164143.1595669-4-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
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

 fs/proc/task_mmu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker
+++ a/fs/proc/task_mmu.c
@@ -2129,7 +2129,8 @@ static int pagemap_pmd_range_thp(pmd_t *
 			flags |= PM_SOFT_DIRTY;
 		if (pmd_swp_uffd_wp(pmd))
 			flags |= PM_UFFD_WP;
-		page = softleaf_to_page(entry);
+		if (softleaf_has_pfn(entry))
+			page = softleaf_to_page(entry);
 	}
 
 	if (page) {
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-split-v1-userspace-eventfd-code-into-vmpressure-v1c.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_supports_pmd_softleaf.patch

