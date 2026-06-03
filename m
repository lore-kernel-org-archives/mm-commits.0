Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B22B4DC55E;
	Wed,  3 Jun 2026 23:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780529194; cv=none; b=ud1yPqjDSGsjfFwHVUtyKzMf/YTmSmzu2b/v79pijnXo+Cf+/KilsVAThJ5NC3JKijek6RyU8zazapvdCVv5L6XTreR5cdmNLdmWhHePjnKG+MQhnf6mC5LDPaQXjFc/orrrQn7H48kTy1xXo/V97FiNhaG1bOM5Ddyq4uIlf44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780529194; c=relaxed/simple;
	bh=bbacSH0Ez3/OlpVImkJ5pRQthvKXQek7eopuTmPtVpc=;
	h=Date:To:From:Subject:Message-Id; b=m0L1BEBK4u2MDOtkt4DV/GgnK96X3QFFBxWnFRqB6vuDVAKq64hth5YYKM5grWuHkXsfSXtsB/thEMMW4DNTOiijc+aX4r3Pqk1D6mLTtyRbIDafn3RSlMg5P03/+JIjs/ZQEYYpwOPJTZiMvkXEOwqB92ffo7JXi/F6Du6TEsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=12ziQdX/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="12ziQdX/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7221F00893;
	Wed,  3 Jun 2026 23:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780529193;
	bh=0R94EdS0pgi8LRX1pY3x0BmVPY7f2OIJ7TF7fpnjQ3Y=;
	h=Date:To:From:Subject;
	b=12ziQdX/oazIX3QTJlI89xZb2htaiw9adIbnqwpBxFnkT4pFzBYhKXNYwOarGCQxb
	 jj3x6EzB9NyZRwPQqlo1lnSshpodN6VFetAaO2u0aMOghVPlISQRyWS/so3EcUbOSI
	 hsRkJBJdITYpFfaPU8St8X+4MdeRwF4f3m6jdFMM=
Date: Wed, 03 Jun 2026 16:26:32 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,david@kernel.org,catalin.marinas@arm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] arm64-mm-call-pagetable-dtor-when-freeing-hot-removed-page-tables.patch removed from -mm tree
Message-Id: <20260603232632.DC7221F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: arm64: mm: call pagetable dtor when freeing hot-removed page tables
has been removed from the -mm tree.  Its filename was
     arm64-mm-call-pagetable-dtor-when-freeing-hot-removed-page-tables.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Alistair Popple <apopple@nvidia.com>
Subject: arm64: mm: call pagetable dtor when freeing hot-removed page tables
Date: Thu, 21 May 2026 13:27:30 +1000

Since 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in
__create_pgd_mapping()") page-table allocation on ARM64 always calls
pagetable_{pte,pmd,pud,p4d}_ctor().  This sets the page_type to
PGTY_table, increments NR_PAGETABLE and possible allocates a PTL.  However
the matching pagetable_dtor() calls were never added.

With DEBUG_VM enabled on kernel versions prior to v6.17 without
2dfcd1608f3a9 ("mm/page_alloc: let page freeing clear any set page type")
this leads to the following warning when freeing these pages due to
page->page_type sharing page->_mapcount:

  BUG: Bad page state in process ... pfn:284fbb
  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x284fbb
  flags: 0x17fffc000000000(node=0|zone=2|lastcpupid=0x1ffff)
  page_type: f2(table)
  page dumped because: nonzero mapcount
  Call trace:
   bad_page+0x13c/0x160
   __free_frozen_pages+0x6cc/0x860
   ___free_pages+0xf4/0x180
   free_pages+0x54/0x80
   free_hotplug_page_range.part.0+0x58/0x90
   free_empty_tables+0x438/0x500
   __remove_pgd_mapping.constprop.0+0x60/0xa8
   arch_remove_memory+0x48/0x80
   try_remove_memory+0x158/0x1d8
   offline_and_remove_memory+0x138/0x180

It can also lead to leaking the ptl allocation if ALLOC_SPLIT_PTLOCKS is
defined and incorrect NR_PAGETABLE stats.  Fix this by calling
pagetable_dtor() in free_hotplug_pgtable_page() prior to freeing the page
to undo the effects of calling pagetable_*_ctor().

Link: https://lore.kernel.org/20260521032730.2104017-1-apopple@nvidia.com
Fixes: 5e8eb9aeeda3 ("arm64: mm: always call PTE/PMD ctor in __create_pgd_mapping()")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/mm/mmu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/mm/mmu.c~arm64-mm-call-pagetable-dtor-when-freeing-hot-removed-page-tables
+++ a/arch/arm64/mm/mmu.c
@@ -1441,6 +1441,7 @@ static void free_hotplug_page_range(stru
 
 static void free_hotplug_pgtable_page(struct page *page)
 {
+	pagetable_dtor(page_ptdesc(page));
 	free_hotplug_page_range(page, PAGE_SIZE, NULL);
 }
 
_

Patches currently in -mm which might be from apopple@nvidia.com are


