From: akpm@linux-foundation.org
Subject: + mm-detach_vmas_to_be_unmapped-fix.patch added to -mm tree
Date: Tue, 27 Feb 2007 12:55:18 -0800
Message-ID: <200702272055.l1RKtMIt028272@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:51593 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbXB0Uzg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 27 Feb 2007 15:55:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akuster@mvista.com


The patch titled
     mm: detach_vmas_to_be_unmapped() fix
has been added to the -mm tree.  Its filename is
     mm-detach_vmas_to_be_unmapped-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: mm: detach_vmas_to_be_unmapped() fix
From: <akuster@mvista.com>

Wolfgang Wander submitted a fix to address a mmap fragmentation issue.  The
git patch ( 1363c3cd8603a913a27e2995dccbd70d5312d8e6 ) is somewhat different
and yields different results when running Wolfgang's test case leakme.c.

IMHO, the vm start and end address are swapped in arch_unmap_area and
arch_unmap_area_topdown functions.

Prior to this patch arch_unmap_area() used area->vm_start and
arch_unmap_area_topdown used area->vm_end in the git patch the following
change showed up.

if (mm->unmap_area == arch_unmap_area)
     addr = prev ? prev->vm_start : mm->mmap_base;
else
     addr = vma ?  vma->vm_end : mm->mmap_base;

Using Wolfgang Wander's leakme.c test, I get the same results seen with his
original "Avoiding mmap fragmentation" patch as I do after swapping the start
& end address in the above code segment.  The patch I submitted addresses this
typo issue.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN mm/mmap.c~mm-detach_vmas_to_be_unmapped-fix mm/mmap.c
--- a/mm/mmap.c~mm-detach_vmas_to_be_unmapped-fix
+++ a/mm/mmap.c
@@ -1721,9 +1721,9 @@ detach_vmas_to_be_unmapped(struct mm_str
 	*insertion_point = vma;
 	tail_vma->vm_next = NULL;
 	if (mm->unmap_area == arch_unmap_area)
-		addr = prev ? prev->vm_end : mm->mmap_base;
+		addr = prev ? prev->vm_start : mm->mmap_base;
 	else
-		addr = vma ?  vma->vm_start : mm->mmap_base;
+		addr = vma ?  vma->vm_end : mm->mmap_base;
 	mm->unmap_area(mm, addr);
 	mm->mmap_cache = NULL;		/* Kill the cache. */
 }
_

Patches currently in -mm which might be from akuster@mvista.com are

mm-detach_vmas_to_be_unmapped-fix.patch
