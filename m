Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D993AD526;
	Fri, 29 May 2026 23:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780097397; cv=none; b=IdfWP/cgFzWt2d1dg4I8bU2AbDQuYQWlUD4fmWBG+sfsd+mNkLpaLmIVgDsyIrYpEu0fIjXVL4CfT868qKc99SLFE/MABZvbjWPeNgZPj0ZMQSnKD9SA/MVuDog5Lz3nvaaN94/rZ+jB7bnm1gAEzVYH41MFSs/XizPAsMJ4efA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780097397; c=relaxed/simple;
	bh=jxVsQT2wMWKho6tHCJAfuGvj0eaodyXHLPdy0QfgrHc=;
	h=Date:To:From:Subject:Message-Id; b=fZAZxXe5fXKqEeDJQ/IJeqHpADHptBMmDyhdzRNy9JcOYgXIh4ToAqDO7gkC034c5XcFg22xn1kyRHTHTkLXkjsa25re99s66lTc4e8NPfiin1/WW2iB4QfgMEyex2+K5mxPzMh1r05a5aUPBbjJugrP7dNHSiGGtM0Kh+jLx9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=lr0ibSPb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="lr0ibSPb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A67E1F00893;
	Fri, 29 May 2026 23:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780097395;
	bh=tlRXvnQygYhlfs8Xybbmq7gsUXbIh7aRpEOTGlyD6HQ=;
	h=Date:To:From:Subject;
	b=lr0ibSPb3Gk7Fgl2rEp24kv4IxK+yrWeUB/RwM50Ii+rdx83RL5vNmoistmWe4zcM
	 rcXZqizMSLj3+sfwshvdzeJ5oA9PY1WqMl04Chx8Xtn9dxqf/S07cvfT6dIB0Adf0k
	 AEsLqNs8XEBTx8CG1nzz4sB+6mF2mUgiukP3tITs=
Date: Fri, 29 May 2026 16:29:55 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,stable@vger.kernel.org,sashiko-bot@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,ljs@kernel.org,david@kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-proc-task_mmu-use-huge_page_size-in-pagemap_scan_hugetlb_entry.patch added to mm-new branch
Message-Id: <20260529232955.9A67E1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/proc/task_mmu: use huge_page_size() in pagemap_scan_hugetlb_entry()
has been added to the -mm mm-new branch.  Its filename is
     fs-proc-task_mmu-use-huge_page_size-in-pagemap_scan_hugetlb_entry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-proc-task_mmu-use-huge_page_size-in-pagemap_scan_hugetlb_entry.patch

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: fs/proc/task_mmu: use huge_page_size() in pagemap_scan_hugetlb_entry()
Date: Fri, 29 May 2026 18:23:26 +0100

The partial-page check compares against HPAGE_SIZE (PMD_SIZE), which is
wrong for gigantic hugetlb hstates (e.g.  1G).  The walker hands the
callback a huge_page_size()-sized range, never start + HPAGE_SIZE, so the
comparison always declares it partial and aborts the WP.  Compare against
the actual hstate's page size.

Link: https://lore.kernel.org/20260529172331.356655-3-kas@kernel.org
Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/task_mmu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/task_mmu.c~fs-proc-task_mmu-use-huge_page_size-in-pagemap_scan_hugetlb_entry
+++ a/fs/proc/task_mmu.c
@@ -2960,7 +2960,7 @@ static int pagemap_scan_hugetlb_entry(pt
 	if (~categories & PAGE_IS_WRITTEN)
 		goto out_unlock;
 
-	if (end != start + HPAGE_SIZE) {
+	if (end != start + huge_page_size(hstate_vma(vma))) {
 		/* Partial HugeTLB page WP isn't possible. */
 		pagemap_scan_backout_range(p, start, end);
 		p->arg.walk_end = start;
_

Patches currently in -mm which might be from kas@kernel.org are

fs-proc-task_mmu-fix-make_uffd_wp_huge_pte-prot-update-race.patch
fs-proc-task_mmu-use-huge_page_size-in-pagemap_scan_hugetlb_entry.patch
fs-proc-task_mmu-fix-hugetlb-self-deadlock-in-pagemap_scan_pte_hole.patch
mm-huge_memory-preserve-pmd_swp_uffd_wp-on-device-private-pmd-downgrade.patch
userfaultfd-gate-must_wait-writability-check-on-pte_present.patch
userfaultfd-build-__vma_uffd_flags-from-config-gated-masks.patch

