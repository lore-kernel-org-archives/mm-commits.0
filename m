Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B46331ED7
	for <mm-commits@vger.kernel.org>; Fri, 31 Jul 2026 02:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785465736; cv=none; b=ej/7ThuGvHRmazTnkrDZW6Aa3plWQuKMI6kmzQkibqOmY2w1GTVPhirGtmo1ZEPHnGtZIvCALHTWjzggBDyHGKrdBCX/ib+X7wx38ENuvw1taP7rsLxGnIAh11WFu7lAx0ReqIDkSmIp3M3hwwVr2lH4/WD4lI412ka56VVKRAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785465736; c=relaxed/simple;
	bh=lUE8pCB1nzjVwVA6rK3NBabG1J6XrJElrbwe9/72iTo=;
	h=Date:To:From:Subject:Message-Id; b=EZSLVE4gP8Ol3gIuaGYuBXezaJyAOfIviuUQYstFkMlp6SEDozboWVVG16y7J3xkNugQavxQuMC1pst0/AoHEW4S9EWCiiP9W7ZhGLMoSl0ar8PWdgmmq07oHFbPjbgzEHSFIUiefTnRfnvbKfdHFYlyIBqPKFjpu8omqpl/lkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=p7HHVYYd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="p7HHVYYd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 375681F00A3A;
	Fri, 31 Jul 2026 02:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785465735;
	bh=X9ZeF6RiJw99R6dq+f8/BBr5YsmYAvJn63/f6Zt60is=;
	h=Date:To:From:Subject;
	b=p7HHVYYd11QnawTAidbdKCaVZswgfPDl241ato689KIDRKmy/lx3UaMIAR3wl9aGw
	 LnQZE47Bk55McDl+9gVZgkxcH8tAc+124zChEf3ksQ/SBrgR1JDm3xrhKo0MWaQPTt
	 7PGEv2bqhs1V23CUwxrAONTte3Sov9oc/Qs0PUfA=
Date: Thu, 30 Jul 2026 19:42:14 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,guanwentao@uniontech.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-avoid-unnecessary-tlb-flush-for-empty-folio-list-in-vmemmap-optimize.patch removed from -mm tree
Message-Id: <20260731024215.375681F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/hugetlb: avoid unnecessary TLB flush for empty folio list in vmemmap optimize
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-avoid-unnecessary-tlb-flush-for-empty-folio-list-in-vmemmap-optimize.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


