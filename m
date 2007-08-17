From: akpm@linux-foundation.org
Subject: + calculation-of-pgoff-in-do_linear_fault-uses-mixed.patch added to -mm tree
Date: Fri, 17 Aug 2007 11:40:13 -0700
Message-ID: <200708171840.l7HIeDZe024041@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37286 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752901AbXHQSkm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 17 Aug 2007 14:40:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dcn@sgi.com, npiggin@suse.de


The patch titled
     calculation of pgoff in do_linear_fault() uses mixed  units
has been added to the -mm tree.  Its filename is
     calculation-of-pgoff-in-do_linear_fault-uses-mixed.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: calculation of pgoff in do_linear_fault() uses mixed  units
From: dcn@sgi.com (Dean Nelson)

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
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/memory.c~calculation-of-pgoff-in-do_linear_fault-uses-mixed mm/memory.c
--- a/mm/memory.c~calculation-of-pgoff-in-do_linear_fault-uses-mixed
+++ a/mm/memory.c
@@ -2356,7 +2356,7 @@ static int do_linear_fault(struct mm_str
 		int write_access, pte_t orig_pte)
 {
 	pgoff_t pgoff = (((address & PAGE_MASK)
-			- vma->vm_start) >> PAGE_CACHE_SHIFT) + vma->vm_pgoff;
+			- vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
 	unsigned int flags = (write_access ? FAULT_FLAG_WRITE : 0);
 
 	return __do_fault(mm, vma, address, page_table, pmd, pgoff,
_

Patches currently in -mm which might be from dcn@sgi.com are

calculation-of-pgoff-in-do_linear_fault-uses-mixed.patch
