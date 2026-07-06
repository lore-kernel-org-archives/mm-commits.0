Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6F23BA244
	for <mm-commits@vger.kernel.org>; Mon,  6 Jul 2026 17:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783360615; cv=none; b=DqfS0gKKWAc5RZEwJqwd8TMScGV2Vl+rfguYze/n0zJe3xTiM1n6jWm8RnTP4vbp5R6PqKCovtdQtVGagQHHZSafAJDfXkKrVVmgR8UOlIhsYdqFaOuMRTccDLqyBZIBn4YA/0NJntowLe3ez+HgdE73fc6kp4Ha9HWAqJMOrgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783360615; c=relaxed/simple;
	bh=ZIjt2t+HdvfSMr01gDyZMii29r+xVZ2djs/tmwl+sRs=;
	h=Date:To:From:Subject:Message-Id; b=R3GgwEb5fY3VgM7SbLPcaj3C9PlKYX9sL5RzF3cxvsBTrNsT7deC2fZCzCMmvHb2ivYlX+czWFEGLrarYcrlF/Y//XeyMZY8fAv3ArAwCnRKVffPQixJNzHhxDKyfldBZ/LIufQHKlvQ1Dp0H+5vmYRKrgcX1J3r/Cn4bYg25YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=aITo3kv6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="aITo3kv6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6681F000E9;
	Mon,  6 Jul 2026 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783360613;
	bh=By23taD3PS83SW64MOYJl9DtUjcoABncw3BKtDUt26Y=;
	h=Date:To:From:Subject;
	b=aITo3kv6fr4O6CnrFTTf02aJBKnCU29Fhwxr9Temi8ZCAm7jhzP9g3f0L62MYE1FE
	 3zsQfcasMAro7yeRKHbDwdvPywVuyyQ6aCpEgzuQQNaPjarIrtXZHb8cckL+rBO54H
	 cftx9yjCqdSpsQwZe+0hf64E70gk4eGLl07ymMPc=
Date: Mon, 06 Jul 2026 10:56:53 -0700
To: mm-commits@vger.kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch added to mm-unstable branch
Message-Id: <20260706175653.7E6681F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc: use softleaf_has_pfn() in pagemap PMD walker
has been added to the -mm mm-unstable branch.  Its filename is
     fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch

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
Subject: fs/proc: use softleaf_has_pfn() in pagemap PMD walker
Date: Mon, 6 Jul 2026 04:42:05 -0700

pagemap_pmd_range_thp() assumes that every non-present PMD is a migration
entry and unconditionally calls softleaf_to_page().  This will crash on
any non-present PMD type that does not encode a PFN, such as the upcoming
PMD-level swap entries.

Guard the page lookup with softleaf_has_pfn(), matching how
pte_to_pagemap_entry() already handles non-present PTEs.

Link: https://lore.kernel.org/20260706114320.1643046-4-usama.arif@linux.dev
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

