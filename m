From: akpm@linux-foundation.org
Subject: + mm-mlock-check-against-vma-for-actual-mlock-size-fix-2.patch
 added to -mm tree
Date: Thu, 08 Sep 2016 15:37:05 -0700
Message-ID: <57d1e811.hNP7YbLis7TEfVY5%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45765 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751455AbcIHWhG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 8 Sep 2016 18:37:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.guo.simon@gmail.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: correct a typo in count_mm_mlocked_page_nr() for caculate VMLOCKED pages
has been added to the -mm tree.  Its filename is
     mm-mlock-check-against-vma-for-actual-mlock-size-fix-2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mlock-check-against-vma-for-actual-mlock-size-fix-2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mlock-check-against-vma-for-actual-mlock-size-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Simon Guo <wei.guo.simon@gmail.com>
Subject: mm: mlock: correct a typo in count_mm_mlocked_page_nr() for caculate VMLOCKED pages

There is a typo/bug in count_mm_mlocked_page_nr() for "&" which is
mistakenly used with "&&".

Also add more checks and some minor change based on Kirill's previous
comment.

Link: http://lkml.kernel.org/r/1473325970-11393-2-git-send-email-wei.guo.simon@gmail.com
Signed-off-by: Simon Guo <wei.guo.simon@gmail.com>
Suggested-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mlock.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN mm/mlock.c~mm-mlock-check-against-vma-for-actual-mlock-size-fix-2 mm/mlock.c
--- a/mm/mlock.c~mm-mlock-check-against-vma-for-actual-mlock-size-fix-2
+++ a/mm/mlock.c
@@ -638,9 +638,11 @@ static int count_mm_mlocked_page_nr(stru
 		vma = mm->mmap;
 
 	for (; vma ; vma = vma->vm_next) {
+		if (start >= vma->vm_end)
+			continue;
 		if (start + len <=  vma->vm_start)
 			break;
-		if (vma->vm_flags && VM_LOCKED) {
+		if (vma->vm_flags & VM_LOCKED) {
 			if (start > vma->vm_start)
 				count -= (start - vma->vm_start);
 			if (start + len < vma->vm_end) {
@@ -651,7 +653,7 @@ static int count_mm_mlocked_page_nr(stru
 		}
 	}
 
-	return (PAGE_ALIGN(count) >> PAGE_SHIFT);
+	return count >> PAGE_SHIFT;
 }
 
 static __must_check int do_mlock(unsigned long start, size_t len, vm_flags_t flags)
_

Patches currently in -mm which might be from wei.guo.simon@gmail.com are

mm-mlock-check-against-vma-for-actual-mlock-size.patch
mm-mlock-check-against-vma-for-actual-mlock-size-fix-2.patch
mm-mlock-avoid-increase-mm-locked_vm-on-mlock-when-already-mlock2mlock_onfault.patch
selftest-split-mlock2_-funcs-into-separate-mlock2h.patch
selftests-vm-add-test-for-mlock-when-areas-are-intersected.patch

