Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E413BA244
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360617; cv=none; b=buBSaRitu6h+M2eNMjgAFffFTI9ItGwujIXDq8JKnnEuMhVynQC9k+rkzfzYRml1zlRg9oNcLghcGv0usl94FBKoodR2x9FYoROFuUxpCjbevgg/DxrZMUM7WL3UEhIkc3OKpf/1QLIypZn60k3eG9xxHyigENU1xOO+oHrjVQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360617; c=relaxed/simple;
	bh=DnN5fuminzlPe37Z6pniSWKyahJLj7jFz3fHFSQXvIs=;
	h=Date:To:From:Subject:Message-Id; b=Pu0JPe17mzAmDPA0jz0+WPxpnuEs2lUNuIaa31E81j3m+ZgCVbZ0H0wqJnSb4jq6T64Lp8lA8I3XVOZX/he2WeCMBIuPHAfQB96lcJhYy8l9QEw23Zhlklh7agANJ0wrdYJG2FpYQecQol5HjhaOXHxIkzA5mIqq+kDt/kOLuzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=18ledD6G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="18ledD6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D241F00A3A;
	Mon,  6 Jul 2026 17:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783360615;
	bh=Hj9F3sMdHWFlsLGVb7CD82uu3gwF6zFnvTddxcV6GDE=;
	h=Date:To:From:Subject;
	b=18ledD6GnklJsHjwZLcxYdRWHnJEAg6KcdGHvLfkjuyJEtUxe9niMPkcywf5a9HvU
	 cBnMKdCPt1o/B0WK4XsysYG0nUneJuUB5ZwcGUj4w4ePl6rLToMVDmOfcoU161+wf5
	 K0herufREXlQ5nhx7c9n9FeIk72YmvnH0rl6pugQ=
Date: Mon, 06 Jul 2026 10:56:55 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch added to mm-unstable branch
Message-Id: <20260706175655.B0D241F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: move softleaf_to_folio() inside migration branch
has been added to the -mm mm-unstable branch.  Its filename is
     mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch

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
Subject: mm/huge_memory: move softleaf_to_folio() inside migration branch
Date: Mon, 6 Jul 2026 04:42:06 -0700

change_non_present_huge_pmd() calls softleaf_to_folio() unconditionally at
the top of the function.  softleaf_to_folio() extracts a PFN from the
entry and converts it to a folio pointer, which is only meaningful for
migration and device_private entries that encode a real PFN.

A swap entry encodes a swap offset instead, so softleaf_to_folio() would
produce a bogus pointer and crash on mprotect() when a PMD swap entry is
present.

Move the call into the migration_write branch where the folio is actually
used, so the function is safe for any non-present PMD type.

Link: https://lore.kernel.org/20260706114320.1643046-5-usama.arif@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Li <chrisl@kernel.org>
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

 mm/huge_memory.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-move-softleaf_to_folio-inside-migration-branch
+++ a/mm/huge_memory.c
@@ -2557,11 +2557,12 @@ static void change_non_present_huge_pmd(
 		bool uffd_wp_resolve)
 {
 	softleaf_t entry = softleaf_from_pmd(*pmd);
-	const struct folio *folio = softleaf_to_folio(entry);
 	pmd_t newpmd;
 
 	VM_WARN_ON(!pmd_is_valid_softleaf(*pmd));
 	if (softleaf_is_migration_write(entry)) {
+		const struct folio *folio = softleaf_to_folio(entry);
+
 		/*
 		 * A protection check is difficult so
 		 * just be safe and disable write
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

