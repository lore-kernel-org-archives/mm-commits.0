Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79D9226D05
	for <mm-commits@vger.kernel.org>; Tue, 30 Jun 2026 23:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782861418; cv=none; b=S2nVOIX6rdKQxLllwJw6/MzH/EGzY4L4ayvQj+2wtJvd2jue7UbolWtiyviEzFj5KAWTiEwGpoQP6wDYBvnynb0FvldIf9QMSWHSa5Gms25Xuj+ZwCdQxZzZN6YYaLmzFcV8Wbu9YCdAVRSlgATGa0FD30ydcB/+YgaoA+6u8Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782861418; c=relaxed/simple;
	bh=saLuYxtvCFGOpdvTkrr8DjpueeM6eHbdpEqfIZiSeH4=;
	h=Date:To:From:Subject:Message-Id; b=SvomBUQInwdwQbiUkTauyVYl9pmmNwakhSm8G6oiykv9txnrfSdewwzkSA0SHoNuOGfyj/xF7mRCPNAp6OqLkc89A6ztBd7ULHeTQ3mrq/sw2SvjxE5FIY+MFDF6xezNR+8g5q9/pnUt6rVdj07UMS25c5wgMzwnULmHghij5UU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eT+krArn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eT+krArn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6E41F000E9;
	Tue, 30 Jun 2026 23:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782861417;
	bh=L5R8JRXnsuD4gt3U+4PP+yUAz3++qUPFDreeLqffhHM=;
	h=Date:To:From:Subject;
	b=eT+krArnI9Fo5iPRfzZaKq6bE2aI2SzaZOEVC2h1xYpq9Wljq1pF4n4uA7yUz5hH5
	 DyjNRfpIbUt0vuoNoWC4m18t7Ve9takSegQ1KECqEospjZmRlHQJEEpS1Er17aCru7
	 PoaQ42KOnWaNIa9SPs4mdzIb74s6JN3R1DazhdP8=
Date: Tue, 30 Jun 2026 16:16:56 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,guanwentao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-avoid-unnecessary-tlb-flush-for-empty-folio-list-in-vmemmap-optimize.patch added to mm-new branch
Message-Id: <20260630231657.4A6E41F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: avoid unnecessary TLB flush for empty folio list in vmemmap optimize
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-avoid-unnecessary-tlb-flush-for-empty-folio-list-in-vmemmap-optimize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-avoid-unnecessary-tlb-flush-for-empty-folio-list-in-vmemmap-optimize.patch

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
From: Wentao Guan <guanwentao@uniontech.com>
Subject: mm/hugetlb: avoid unnecessary TLB flush for empty folio list in vmemmap optimize
Date: Tue, 30 Jun 2026 19:38:57 +0800

__hugetlb_vmemmap_optimize_folios() unconditionally issues a final
flush_tlb_all() in its out path.  However, a TLB flush must be paired with
an actual page table modification.

When the input folio list is empty, neither PMD splitting nor PTE
remapping takes place, so no page tables are modified and the flush is
pure overhead.  An empty list is reached in common paths such as
gather_bootmem_prealloc_node() on nodes without bootmem gigantic pages,
hugetlb_pages_alloc_boot_node() when no pages were allocated, and runtime
allocation failure paths in set_max_huge_pages().

Add an early return for empty lists.  This restores the basic invariant
that TLB flushes are only issued when page tables have been modified, and
it also makes the NULL hstate passed by gather_bootmem_prealloc_node() on
an empty list harmless.

Assisted-by: kimi-cli:kimi-k2.7 code
Assisted-by: Github Copilot:gpt-5.2 #Reported-by
Link: https://lore.kernel.org/20260630113857.3319612-1-guanwentao@uniontech.com
Fixes: 79359d6d24df ("hugetlb: perform vmemmap optimization on a list of pages")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Guan Wentao <guanwentao@uniontech.com>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb-avoid-unnecessary-tlb-flush-for-empty-folio-list-in-vmemmap-optimize
+++ a/mm/hugetlb_vmemmap.c
@@ -624,6 +624,9 @@ static void __hugetlb_vmemmap_optimize_f
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
+	if (list_empty(folio_list))
+		return;
+
 	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
_

Patches currently in -mm which might be from guanwentao@uniontech.com are

mm-hugetlb-avoid-unnecessary-tlb-flush-for-empty-folio-list-in-vmemmap-optimize.patch

