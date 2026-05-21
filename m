Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C741C862D;
	Thu, 21 May 2026 22:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779402707; cv=none; b=ZPZHLKlu1xTVJ2CrPX7/R9Jnd+VCyeXeIk/St820obTtLDI8cXAmGXHCjwBMBO2tCmDyQJxxDe9K97EF2kPoxuSNayShHueUR972nxpUivNN05EOcZvwMdqbRXCofDWF28D35822SfWWDWoczwSYJW+L1KZy/HomnRc17vLPy8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779402707; c=relaxed/simple;
	bh=qyGBdGyQ/CWefK2oqbQlOgQZiEgYgkcpCY23OGa3SPE=;
	h=Date:To:From:Subject:Message-Id; b=D1oCYQwjC+GzrRpLAB5ohQ05uGmLgz9JA9t1P++9HcRg3cBwiRGObdR2lVX4Nkg2GSE6cBqqvuUiQ+oXshgvZaaGnm35hLzIMCaqV95QchqpWaDyKpHoUmUhIPcL5fCF22S5rmCgJ1m79pKX4MBxUX22DR2KKQWYXYCf/1VyFts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZBAzQY83; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZBAzQY83"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312AF1F000E9;
	Thu, 21 May 2026 22:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779402706;
	bh=/pWeIqweOvhX+3g8Hmdaoiw17MzRQZInKbDVAdFNJ34=;
	h=Date:To:From:Subject;
	b=ZBAzQY83OqWZ7UsZoSeQYoIpCFVyXiP7RpOyVPBzaPTtdS1YgsLZ6SDLL1MY8UAuT
	 0Wc+SE0RF5K0kwNpJBoAkWqGnI6KEJPDxiiauqQzO+LmNCFULXoM3T4ih4a+v06Kxb
	 qoZqAU0QHBQGTIdCaPNdNHwhr6EPccAH26WTlv5Q=
Date: Thu, 21 May 2026 15:31:45 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,stable@vger.kernel.org,david@kernel.org,catalin.marinas@arm.com,apopple@nvidia.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + arm64-mm-call-pagetable-dtor-when-freeing-hot-removed-page-tables.patch added to mm-hotfixes-unstable branch
Message-Id: <20260521223146.312AF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: arm64: mm: call pagetable dtor when freeing hot-removed page tables
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     arm64-mm-call-pagetable-dtor-when-freeing-hot-removed-page-tables.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/arm64-mm-call-pagetable-dtor-when-freeing-hot-removed-page-tables.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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

arm64-mm-call-pagetable-dtor-when-freeing-hot-removed-page-tables.patch

