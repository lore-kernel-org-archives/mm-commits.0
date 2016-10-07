From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-mlock-check-against-vma-for-actual-mlock-size-fix-2.patch removed from
 -mm tree
Date: Fri, 07 Oct 2016 16:38:15 -0700
Message-ID: <57f831e7.VoiCA8/tpNfoGVyz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38371 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932799AbcJGXiQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 7 Oct 2016 19:38:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: wei.guo.simon@gmail.com, kirill@shutemov.name, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mlock: correct a typo in count_mm_mlocked_page_nr() for caculate VMLOCKED pages
has been removed from the -mm tree.  Its filename was
     mm-mlock-check-against-vma-for-actual-mlock-size-fix-2.patch

This patch was dropped because it was folded into mm-mlock-check-against-vma-for-actual-mlock-size.patch

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
mm-mlock-avoid-increase-mm-locked_vm-on-mlock-when-already-mlock2mlock_onfault.patch
selftest-split-mlock2_-funcs-into-separate-mlock2h.patch
selftests-vm-add-test-for-mlock-when-areas-are-intersected.patch
selftest-move-seek_to_smaps_entry-out-of-mlock2-testsc.patch
selftests-expanding-more-mlock-selftest.patch

