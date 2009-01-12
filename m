From: akpm@linux-foundation.org
Subject: + fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes.patch added to -mm tree
Date: Mon, 12 Jan 2009 14:59:43 -0800
Message-ID: <200901122259.n0CMxhn8022289@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756070AbZALXAm (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 12 Jan 2009 18:00:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yinghan@google.com, hugh@veritas.com, mikew@google.com


The patch titled
     fs/exec.c: fix value of vma->vm_pgoff for the stack VMA of 32-bit processes
has been added to the -mm tree.  Its filename is
     fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/exec.c: fix value of vma->vm_pgoff for the stack VMA of 32-bit processes
From: Ying Han <yinghan@google.com>

With a 32 bit binary running on a 64 bit system, the /proc/pid/maps for
the [stack] VMA displays a 64-bit address:

ff96c000-ff981000 rwxp 7ffffffea000 00:00 0 [stack]

This is because vma->vm_pgoff for that VMA is incorrectly being stored in
units of offset-in-bytes.  It should be stored in units of offset-in-pages.

Signed-off-by: Ying Han <yinghan@google.com>
Cc: Mike Waychison <mikew@google.com>
Cc: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes fs/exec.c
--- a/fs/exec.c~fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes
+++ a/fs/exec.c
@@ -509,6 +509,7 @@ static int shift_arg_pages(struct vm_are
 	unsigned long length = old_end - old_start;
 	unsigned long new_start = old_start - shift;
 	unsigned long new_end = old_end - shift;
+	unsigned long new_pgoff = new_start >> PAGE_SHIFT;
 	struct mmu_gather *tlb;
 
 	BUG_ON(new_start > new_end);
@@ -523,7 +524,7 @@ static int shift_arg_pages(struct vm_are
 	/*
 	 * cover the whole range: [new_start, old_end)
 	 */
-	vma_adjust(vma, new_start, old_end, vma->vm_pgoff, NULL);
+	vma_adjust(vma, new_start, old_end, new_pgoff, NULL);
 
 	/*
 	 * move the page tables downwards, on failure we rely on
@@ -556,7 +557,7 @@ static int shift_arg_pages(struct vm_are
 	/*
 	 * shrink the vma to just the new range.
 	 */
-	vma_adjust(vma, new_start, new_end, vma->vm_pgoff, NULL);
+	vma_adjust(vma, new_start, new_end, new_pgoff, NULL);
 
 	return 0;
 }
_

Patches currently in -mm which might be from yinghan@google.com are

fs-execc-fix-value-of-vma-vm_pgoff-for-the-stack-vma-of-32-bit-processes.patch
page_fault-retry-with-nopage_retry.patch
page_fault-retry-with-nopage_retry-fix.patch
page_fault-retry-with-nopage_retry-fix-fix.patch

