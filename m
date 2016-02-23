From: akpm@linux-foundation.org
Subject: [merged] mm-x86-fix-pte_page-crash-in-gup_pte_range.patch removed from -mm tree
Date: Tue, 23 Feb 2016 12:49:45 -0800
Message-ID: <56ccc5e9.mAxAHm38hS0z5N/a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53255 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096AbcBWUtp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 23 Feb 2016 15:49:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hughd@google.com, Harn-Solo@gmx.de, dan.j.williams@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, x86: fix pte_page() crash in gup_pte_range()
has been removed from the -mm tree.  Its filename was
     mm-x86-fix-pte_page-crash-in-gup_pte_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm, x86: fix pte_page() crash in gup_pte_range()

Commit 3565fce3a659 ("mm, x86: get_user_pages() for dax mappings") has
moved up the pte_page(pte) in x86's fast gup_pte_range(), for no
discernible reason: put it back where it belongs, after the pte_flags
check and the pfn_valid cross-check.

That may be the cause of the NULL pointer dereference in gup_pte_range(),
seen when vfio called vaddr_get_pfn() when starting a qemu-kvm based VM.

Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Michael Long <Harn-Solo@gmx.de>
Tested-by: Michael Long <Harn-Solo@gmx.de>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/gup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/gup.c~mm-x86-fix-pte_page-crash-in-gup_pte_range arch/x86/mm/gup.c
--- a/arch/x86/mm/gup.c~mm-x86-fix-pte_page-crash-in-gup_pte_range
+++ a/arch/x86/mm/gup.c
@@ -102,7 +102,6 @@ static noinline int gup_pte_range(pmd_t
 			return 0;
 		}
 
-		page = pte_page(pte);
 		if (pte_devmap(pte)) {
 			pgmap = get_dev_pagemap(pte_pfn(pte), pgmap);
 			if (unlikely(!pgmap)) {
@@ -115,6 +114,7 @@ static noinline int gup_pte_range(pmd_t
 			return 0;
 		}
 		VM_BUG_ON(!pfn_valid(pte_pfn(pte)));
+		page = pte_page(pte);
 		get_page(page);
 		put_dev_pagemap(pgmap);
 		SetPageReferenced(page);
_

Patches currently in -mm which might be from hughd@google.com are


