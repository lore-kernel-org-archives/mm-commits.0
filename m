Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101984CB5B
	for <mm-commits@vger.kernel.org>; Sun,  5 Jul 2026 22:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783290862; cv=none; b=bpB2jYxGyT1OJkCNPAwjn2PBHfGtP1oPNVbio6WKsZwp3iL8jqarb9piowCj6oWCbhZUEpVr8/zQAbK0JxsNrDvUaKEWAW2qgKAO+yyA9OJLTL9U0A3Ve9h4AL1ZSNh8ffL0IaQC3PbMUVJ9VTLz7rNPEh2MTDzUPdz/vdp7ai4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783290862; c=relaxed/simple;
	bh=OhLutzh2UgEcSGR/+FTeEDHvnYV6GHT3oD1W2TO8U9s=;
	h=Date:To:From:Subject:Message-Id; b=oeCBn9cW75FVyNAXf7+H5E7iugiA7lxSjD2WZ2fJNOvIKaZQIfvk9f/hWltXmRBqHoVeCE6wk8gswFWzIwt1EuCiXU0ygHUWfCqlZSf3zNEWUgtYQMBzYwLmZBA6MBXe3fyjpXawfiU+eeSTspA89rKe6GKqvEdNevcC6adcKj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0djL/58C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0djL/58C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746ED1F000E9;
	Sun,  5 Jul 2026 22:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783290860;
	bh=AdWNUGfSN/LB/MIXbae/rExlzNk9kv0r2W1MST6QZTI=;
	h=Date:To:From:Subject;
	b=0djL/58CIl3+IHqmf5bkk4gdDAj0LjZfQEuxX2bW6fVVf9mvx4vSLlg97VfHEARbI
	 RY3hGIng1V2vQaZuUvge9fLeOfRFqj8dcubGC8NGli7kRqNBo/z3QBTd8yw9ff8ue3
	 cc/fa9XKBXFV1u93c/E3QR2EpER0SSw54Fw5E7pM=
Date: Sun, 05 Jul 2026 15:34:20 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,guanwentao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-avoid-unnecessary-tlb-flush-for-empty-folio-list-in-vmemmap-optimize.patch added to mm-unstable branch
Message-Id: <20260705223420.746ED1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: avoid unnecessary TLB flush for empty folio list in vmemmap optimize
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-avoid-unnecessary-tlb-flush-for-empty-folio-list-in-vmemmap-optimize.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-avoid-unnecessary-tlb-flush-for-empty-folio-list-in-vmemmap-optimize.patch

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
From: Wentao Guan <guanwentao@uniontech.com>
Subject: mm/hugetlb: avoid unnecessary TLB flush for empty folio list in vmemmap optimize
Date: Tue, 30 Jun 2026 19:38:57 +0800

Since 79359d6d24df ("hugetlb: perform vmemmap optimization on a list of
pages") __hugetlb_vmemmap_optimize_folios() unconditionally issues a final
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
Link: https://lore.kernel.org/20260701053422.3664813-1-guanwentao@uniontech.com
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

