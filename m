Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F335945104C
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 19:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782849068; cv=none; b=nIMeOC6GTmg15EHFPFkU8U4VCOYFf/k0+4YQeMrrBqEcTYs4lNz0zXV9wqYRgRP6Yx/9/XNiXQn5feQB5yyROz7+JuuQV1QlbP2TIRyCfOk1hd8Tesf2q1CD3NQea5OUCJHq3jmhqu1aDzLJ2YaukXdRqvx6Rr6lD8sZtqthmYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782849068; c=relaxed/simple;
	bh=NOpl4G6b1SCPY9SB7U/Ad4vlTkrYZIzAtUPWpXaerVQ=;
	h=Date:To:From:Subject:Message-Id; b=OP6TbFQjZHiMeVU8plnK+zq3iLo3CF96rvbnrOykM4oFaAP550gsSug1Ssnc0+YmkfSdCQPGyBY2dpskfn+AqPXHcNi12fGJuwM3mFeXtBlNgwb2xxPiaGeCEdNBCPoWrouC8zF//PiPhNthFn5XAn9KBByh80CG+vozhVLeNbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xcN+UWgV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xcN+UWgV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C7411F000E9;
	Tue, 30 Jun 2026 19:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782849065;
	bh=AaJ7BU0T1LbqZi8kxeRpHKow0z8b2TwZtqqd7mE7SKs=;
	h=Date:To:From:Subject;
	b=xcN+UWgV8B9R2uOvgdM7hFIvAMUFgt18xW4mREVdSMCt9ACqSlB2QnZEJdvFa1jq5
	 5z79mPcSAPRBsj65skx/T42l4Wcgrr5/INKQf6K3PAi6BpcsFUhQxfwmesNR9Zbqn7
	 0w/HhCqzmVZd4wOFZPl/v8YZVwipisVCdiq/imO8=
Date: Tue, 30 Jun 2026 12:51:05 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch added to mm-new branch
Message-Id: <20260630195105.8C7411F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: move softleaf_to_folio() inside migration branch
has been added to the -mm mm-new branch.  Its filename is
     mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch

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
Subject: mm/huge_memory: move softleaf_to_folio() inside migration branch
Date: Tue, 30 Jun 2026 09:34:41 -0700

change_non_present_huge_pmd() calls softleaf_to_folio() unconditionally at
the top of the function.  softleaf_to_folio() extracts a PFN from the
entry and converts it to a folio pointer, which is only meaningful for
migration and device_private entries that encode a real PFN.

A swap entry encodes a swap offset instead, so softleaf_to_folio() would
produce a bogus pointer and crash on mprotect() when a PMD swap entry is
present.

Move the call into the migration_write branch where the folio is actually
used, so the function is safe for any non-present PMD type.

Link: https://lore.kernel.org/20260630164143.1595669-5-usama.arif@linux.dev
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

mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-split-v1-userspace-eventfd-code-into-vmpressure-v1c.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_supports_pmd_softleaf.patch

