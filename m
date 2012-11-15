From: akpm@linux-foundation.org
Subject: + mm-highmem-dont-treat-pkmap_addrlast_pkmap-as-a-highmem-address.patch added to -mm tree
Date: Thu, 15 Nov 2012 14:19:29 -0800
Message-ID: <20121115221929.960AF1001CA@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:46811 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2KOWTa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 17:19:30 -0500
Received: by mail-qc0-f202.google.com with SMTP id s25so232440qcq.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 14:19:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: will.deacon@arm.com, mgorman@suse.de


The patch titled
     Subject: mm: highmem: don't treat PKMAP_ADDR(LAST_PKMAP) as a highmem address
has been added to the -mm tree.  Its filename is
     mm-highmem-dont-treat-pkmap_addrlast_pkmap-as-a-highmem-address.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Will Deacon <will.deacon@arm.com>
Subject: mm: highmem: don't treat PKMAP_ADDR(LAST_PKMAP) as a highmem address

kmap_to_page returns the corresponding struct page for a virtual address
of an arbitrary mapping.  This works by checking whether the address falls
in the pkmap region and using the pkmap page tables instead of the linear
mapping if appropriate.

Unfortunately, the bounds checking means that PKMAP_ADDR(LAST_PKMAP) is
incorrectly treated as a highmem address and we can end up walking off the
end of pkmap_page_table and subsequently passing junk to pte_page.

This patch fixes the bound check to stay within the pkmap tables.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/highmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/highmem.c~mm-highmem-dont-treat-pkmap_addrlast_pkmap-as-a-highmem-address mm/highmem.c
--- a/mm/highmem.c~mm-highmem-dont-treat-pkmap_addrlast_pkmap-as-a-highmem-address
+++ a/mm/highmem.c
@@ -98,7 +98,7 @@ struct page *kmap_to_page(void *vaddr)
 {
 	unsigned long addr = (unsigned long)vaddr;
 
-	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
+	if (addr >= PKMAP_ADDR(0) && addr < PKMAP_ADDR(LAST_PKMAP)) {
 		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
 		return pte_page(pkmap_page_table[i]);
 	}
_

Patches currently in -mm which might be from will.deacon@arm.com are

mm-highmem-dont-treat-pkmap_addrlast_pkmap-as-a-highmem-address.patch
linux-next.patch
mm-thp-set-the-accessed-flag-for-old-pages-on-access-fault.patch

