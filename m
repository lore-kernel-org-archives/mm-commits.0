Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF1F27F7DA
	for <mm-commits@vger.kernel.org>; Fri, 26 Apr 2024 04:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714104105; cv=none; b=HcgqYprdjoB6qhuMgDq8aDSLoSGKZ3uxjrmFuJ2j0gAFg4obqCiClSPqgsWf6+w3B1FUHRI6jymQa9OZJFWRr8NGdUYr5mg8rTpQMVWRk7ql+U6mYFhczDx1HOudD2w3SRU6dMclKBLKH64egYm7h82SmiCo5whB9+Jo34kdsa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714104105; c=relaxed/simple;
	bh=Sc/jIJgArdXbXeYKT7bZrKR2/LVfqX9OQKWlYq6QnOo=;
	h=Date:To:From:Subject:Message-Id; b=YAC3pWpgbHcPS/x69w+7CIhMKQQxR3R9kWTJQx/Y7Q9OA4jgsw37qQJIHHKQsaE8gVpOdjC//8IO8IbkguUCa2ZQq7Lk2Nq5PCJ47XDtSHVxwbADS5ugX+yLQpq21ljfZFZs/Zm2ULlUWiHK24yThGB3GoXtogF91fS8QGipV2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KlbgAS+B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KlbgAS+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B657EC113CD;
	Fri, 26 Apr 2024 04:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714104104;
	bh=Sc/jIJgArdXbXeYKT7bZrKR2/LVfqX9OQKWlYq6QnOo=;
	h=Date:To:From:Subject:From;
	b=KlbgAS+B2lkcAdQSVPlHyFKA1UpV9EzrlBqiVvjU5HuXrlIlk5Apzka7b5jzf9jvV
	 DXh5pZTGFb4yDgSxxSJB3lBr8zMr5XhK1hHaPzFUSFlGvDb8sKhITOLNhXiNKCtdEp
	 BfNiw2VmNgDsKkqwXkGXViQM/uToMDljfcl1MH1k=
Date: Thu, 25 Apr 2024 21:01:44 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,yuzhao@google.com,ying.huang@intel.com,willy@infradead.org,wangkefeng.wang@huawei.com,vbabka@suse.cz,shy828301@gmail.com,ryan.roberts@arm.com,rientjes@google.com,mcgrof@kernel.org,kirill.shutemov@linux.intel.com,jhubbard@nvidia.com,itaru.kitayama@gmail.com,hughd@google.com,fengwei.yin@intel.com,david@redhat.com,catalin.marinas@arm.com,apopple@nvidia.com,anshuman.khandual@arm.com,v-songbaohua@oppo.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch removed from -mm tree
Message-Id: <20240426040144.B657EC113CD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: alloc_anon_folio: avoid doing vma_thp_gfp_mask in fallback cases
has been removed from the -mm tree.  Its filename was
     mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Barry Song <v-songbaohua@oppo.com>
Subject: mm: alloc_anon_folio: avoid doing vma_thp_gfp_mask in fallback cases
Date: Fri, 29 Mar 2024 20:37:50 +1300

Fallback rates surpassing 90% have been observed on phones utilizing 64KiB
CONT-PTE mTHP.  In these scenarios, when one out of every 16 PTEs fails to
allocate large folios, the remaining 15 PTEs fallback.  Consequently,
invoking vma_thp_gfp_mask seems redundant in such cases.  Furthermore,
abstaining from its use can also contribute to improved code readability.

Link: https://lkml.kernel.org/r/20240329073750.20012-1-21cnbao@gmail.com
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Itaru Kitayama <itaru.kitayama@gmail.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/memory.c~mm-alloc_anon_folio-avoid-doing-vma_thp_gfp_mask-in-fallback-cases
+++ a/mm/memory.c
@@ -4358,6 +4358,9 @@ static struct folio *alloc_anon_folio(st
 
 	pte_unmap(pte);
 
+	if (!orders)
+		goto fallback;
+
 	/* Try allocating the highest of the remaining orders. */
 	gfp = vma_thp_gfp_mask(vma);
 	while (orders) {
_

Patches currently in -mm which might be from v-songbaohua@oppo.com are

mm-add-per-order-mthp-anon_fault_alloc-and-anon_fault_fallback-counters.patch
mm-add-per-order-mthp-anon_swpout-and-anon_swpout_fallback-counters.patch
mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi.patch
mm-add-docs-for-per-order-mthp-counters-and-transhuge_page-abi-fix.patch
mm-correct-the-docs-for-thp_fault_alloc-and-thp_fault_fallback.patch

