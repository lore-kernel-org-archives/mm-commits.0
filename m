From: akpm@linux-foundation.org
Subject: +
 mm-fix-use-after-free-if-memory-allocation-failed-in-vma_adjust.patch added to -mm tree
Date: Wed, 27 Jul 2016 12:31:29 -0700
Message-ID: <57990c11.wDsa6BuTyeQZqKDA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41377 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbcG0Tba (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Jul 2016 15:31:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kirill.shutemov@linux.intel.com, riel@redhat.com, vbabka@suse.cz, vegard.nossum@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: fix use-after-free if memory allocation failed in vma_adjust()
has been added to the -mm tree.  Its filename is
     mm-fix-use-after-free-if-memory-allocation-failed-in-vma_adjust.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-fix-use-after-free-if-memory-allocation-failed-in-vma_adjust.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-fix-use-after-free-if-memory-allocation-failed-in-vma_adjust.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: mm: fix use-after-free if memory allocation failed in vma_adjust()

There's one case when vma_adjust() expands the vma, overlapping with *two*
next vma.  See case 6 of mprotect, described in the comment to
vma_merge().

To handle this (and only this) situation we iterate twice over main part
of the function.  See "goto again".

Vegard reported[1] that he sees out-of-bounds access complain from KASAN,
if anon_vma_clone() on the *second* iteration fails.

This happens because we free 'next' vma by the end of first iteration and
don't have a way to undo this if anon_vma_clone() fails on the second
iteration.

The solution is to do all required allocations upfront, before we touch
vmas.

The allocation on the second iteration is only required if first two vmas
don't have anon_vma, but third does.  So we need, in total, one
anon_vma_clone() call.

It's easy to adjust 'exporter' to the third vma for such case.

[1] http://lkml.kernel.org/r/1469514843-23778-1-git-send-email-vegard.nossum@oracle.com

Link: http://lkml.kernel.org/r/1469625255-126641-1-git-send-email-kirill.shutemov@linux.intel.com
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reported-by: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmap.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff -puN mm/mmap.c~mm-fix-use-after-free-if-memory-allocation-failed-in-vma_adjust mm/mmap.c
--- a/mm/mmap.c~mm-fix-use-after-free-if-memory-allocation-failed-in-vma_adjust
+++ a/mm/mmap.c
@@ -621,7 +621,6 @@ int vma_adjust(struct vm_area_struct *vm
 {
 	struct mm_struct *mm = vma->vm_mm;
 	struct vm_area_struct *next = vma->vm_next;
-	struct vm_area_struct *importer = NULL;
 	struct address_space *mapping = NULL;
 	struct rb_root *root = NULL;
 	struct anon_vma *anon_vma = NULL;
@@ -631,17 +630,25 @@ int vma_adjust(struct vm_area_struct *vm
 	int remove_next = 0;
 
 	if (next && !insert) {
-		struct vm_area_struct *exporter = NULL;
+		struct vm_area_struct *exporter = NULL, *importer = NULL;
 
 		if (end >= next->vm_end) {
 			/*
 			 * vma expands, overlapping all the next, and
 			 * perhaps the one after too (mprotect case 6).
 			 */
-again:			remove_next = 1 + (end > next->vm_end);
+			remove_next = 1 + (end > next->vm_end);
 			end = next->vm_end;
 			exporter = next;
 			importer = vma;
+
+			/*
+			 * If next doesn't have anon_vma, import from vma after
+			 * next, if the vma overlaps with it.
+			 */
+			if (remove_next == 2 && next && !next->anon_vma)
+				exporter = next->vm_next;
+
 		} else if (end > next->vm_start) {
 			/*
 			 * vma expands, overlapping part of the next:
@@ -675,7 +682,7 @@ again:			remove_next = 1 + (end > next->
 				return error;
 		}
 	}
