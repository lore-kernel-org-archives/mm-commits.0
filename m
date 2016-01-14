From: akpm@linux-foundation.org
Subject: [folded-merged] thp-reintroduce-split_huge_page-fix-2.patch
 removed from -mm tree
Date: Thu, 14 Jan 2016 14:41:16 -0800
Message-ID: <5698240c.9BXNa/ofzHu9jVcp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46245 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbcANWlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 Jan 2016 17:41:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill@shutemov.name, minchan@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: thp-reintroduce-split_huge_page-fix-2
has been removed from the -mm tree.  Its filename was
     thp-reintroduce-split_huge_page-fix-2.patch

This patch was dropped because it was folded into thp-reintroduce-split_huge_page.patch

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: thp-reintroduce-split_huge_page-fix-2

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN mm/huge_memory.c~thp-reintroduce-split_huge_page-fix-2 mm/huge_memory.c
--- a/mm/huge_memory.c~thp-reintroduce-split_huge_page-fix-2
+++ a/mm/huge_memory.c
@@ -3036,6 +3036,7 @@ static void unfreeze_page_vma(struct vm_
 			continue;
 
 		entry = pte_mkold(mk_pte(page, vma->vm_page_prot));
+		entry = pte_mkdirty(entry);
 		if (is_write_migration_entry(swp_entry))
 			entry = maybe_mkwrite(entry, vma);
 
_

Patches currently in -mm which might be from kirill@shutemov.name are

thp-reintroduce-split_huge_page.patch
mm-prepare-page_referenced-and-page_idle-to-new-thp-refcounting-fix.patch
thp-increase-split_huge_page-success-rate-fix.patch
mm-add-page_check_address_transhuge-helper-fix-fix.patch

