From: akpm@linux-foundation.org
Subject: - calculation-of-pgoff-in-do_linear_fault-uses-mixed.patch removed from -mm tree
Date: Tue, 16 Oct 2007 13:31:33 -0700
Message-ID: <200710162031.l9GKVX6X014509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934737AbXJPVme (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Oct 2007 17:42:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dcn@sgi.com, npiggin@suse.de, mm-commits@vger.kernel.org


The patch titled
     calculation of pgoff in do_linear_fault() uses mixed  units
has been removed from the -mm tree.  Its filename was
     calculation-of-pgoff-in-do_linear_fault-uses-mixed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: calculation of pgoff in do_linear_fault() uses mixed  units
From: Dean Nelson <dcn@sgi.com>

The calculation of pgoff in do_linear_fault() should use PAGE_SHIFT and not
PAGE_CACHE_SHIFT since vma->vm_pgoff is in units of PAGE_SIZE and not
PAGE_CACHE_SIZE.  At the moment linux/pagemap.h has PAGE_CACHE_SHIFT
defined as PAGE_SHIFT, but should that ever change this calculation would
break.

Signed-off-by: Dean Nelson <dcn@sgi.com>
Acked-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~calculation-of-pgoff-in-do_linear_fault-uses-mixed mm/memory.c
--- a/mm/memory.c~calculation-of-pgoff-in-do_linear_fault-uses-mixed
+++ a/mm/memory.c
@@ -2361,7 +2361,7 @@ static int do_linear_fault(struct mm_str
 		int write_access, pte_t orig_pte)
 {
 	pgoff_t pgoff = (((address & PAGE_MASK)
-			- vma->vm_start) >> PAGE_CACHE_SHIFT) + vma->vm_pgoff;
+			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
 
 	pte_unmap(page_table);
_

Patches currently in -mm which might be from dcn@sgi.com are

origin.patch
